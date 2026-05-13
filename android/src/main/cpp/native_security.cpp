#include <jni.h>
#include <string>
#include <unistd.h>
#include <sys/ptrace.h>
#include <fstream>
#include <android/log.h>

#define LOG_TAG "NativeSecurity"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <dirent.h>

// Simple XOR to hide strings from basic 'strings' command
std::string decrypt(std::string s) {
    for (int i = 0; i < s.size(); i++) s[i] ^= 0x55;
    return s;
}

#include <dlfcn.h>

// Helper to check if a function is hooked via inline patching
bool is_hooked(const char* func_name) {
    void* addr = dlsym(RTLD_DEFAULT, func_name);
    if (!addr) return false;

    unsigned char* ptr = (unsigned char*)addr;

#if defined(__aarch64__)
    // 🛡️ ARM64 Detection: Look for common LDR/BR hook patterns
    // Pattern: LDR X16, #8 ; BR X16 (0x58000050, 0xD61F0200)
    if (ptr[0] == 0x50 && ptr[1] == 0x00 && ptr[2] == 0x00 && ptr[3] == 0x58) return true;
    if (ptr[0] == 0x00 && ptr[1] == 0x02 && ptr[2] == 0x1F && ptr[3] == 0xD6) return true;
    // Pattern: B (0x14XXXXXX)
    if ((ptr[3] & 0xFC) == 0x14) return true;
#elif defined(__arm__)
    // 🛡️ ARM 32-bit Detection: Look for LDR PC, [PC, #-4] (0xE51FF004)
    if (ptr[0] == 0x04 && ptr[1] == 0xF0 && ptr[2] == 0x1F && ptr[3] == 0xE5) return true;
#elif defined(__i386__) || defined(__x86_64__)
    // 🛡️ x86 Detection: Look for JMP (0xE9) or PUSH/RET (0x68/0xC3)
    if (ptr[0] == 0xE9 || ptr[0] == 0xEB) return true;
#endif

    return false;
}

// 🛡️ The actual security check function
jboolean check_native_security(JNIEnv* env, jobject thiz) {
    // 1. Anti-Frida: /proc/self/maps (Enhanced)
    std::ifstream maps("/proc/self/maps");
    std::string line;
    std::string f = decrypt("\x33\x27\x3C\x31\x34"); // "frida" ^ 0x55
    while (std::getline(maps, line)) {
        if (line.find(f) != std::string::npos || 
            line.find("gadget") != std::string::npos ||
            line.find("gum-js") != std::string::npos) {
            return JNI_TRUE;
        }
    }

    // 2. Anti-Frida: Symbol Check (dlsym)
    void* handle = dlopen(NULL, RTLD_NOW);
    if (handle) {
        if (dlsym(handle, "frida_agent_main") || 
            dlsym(handle, "gum_js_script_scheduler_new") ||
            dlsym(handle, "frida_spawn_child")) {
            dlclose(handle);
            return JNI_TRUE;
        }
        dlclose(handle);
    }

    // 3. Inline Hook Detection: Check critical system functions
    const char* critical_funcs[] = {"open", "openat", "read", "write", "ptrace", "fork", "dlopen", "connect"};
    for (const char* func : critical_funcs) {
        if (is_hooked(func)) return JNI_TRUE;
    }

    // 4. Anti-Frida: Port Check (27042)
    struct sockaddr_in sa;
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    sa.sin_family = AF_INET;
    sa.sin_port = htons(27042);
    inet_aton("127.0.0.1", &sa.sin_addr);
    if (connect(sock, (struct sockaddr*)&sa, sizeof(sa)) == 0) {
        close(sock);
        return JNI_TRUE;
    }
    close(sock);

    // 5. Anti-Frida: Thread Name Check
    DIR* dir = opendir("/proc/self/task");
    if (dir != NULL) {
        struct dirent* entry;
        while ((entry = readdir(dir)) != NULL) {
            if (entry->d_name[0] == '.') continue;
            std::string path = "/proc/self/task/";
            path += entry->d_name;
            path += "/comm";
            std::ifstream comm(path);
            std::string tname;
            if (std::getline(comm, tname)) {
                if (tname.find("gmain") != std::string::npos || tname.find(f) != std::string::npos) {
                    closedir(dir);
                    return JNI_TRUE;
                }
            }
        }
        closedir(dir);
    }
    
    return JNI_FALSE;
}

// 📦 JNI Registration Table
static const JNINativeMethod gMethods[] = {
    {"checkNativeSecurity", "()Z", (void*)check_native_security}
};

// 🚀 JNI_OnLoad is called automatically when System.loadLibrary() is called
JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void* reserved) {
    LOGI("JNI_OnLoad called");
    JNIEnv* env;
    if (vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_6) != JNI_OK) {
        LOGI("GetEnv failed");
        return JNI_ERR;
    }

    // Find the class where the native methods are defined
    const char* className = "id/grasm/flutter_security_check/FlutterSecurityCheckPlugin";
    jclass clazz = env->FindClass(className);
    if (clazz == nullptr) {
        LOGI("FindClass failed for %s", className);
        return JNI_ERR;
    }

    // Register our native methods
    if (env->RegisterNatives(clazz, gMethods, sizeof(gMethods) / sizeof(gMethods[0])) < 0) {
        LOGI("RegisterNatives failed");
        return JNI_ERR;
    }

    LOGI("JNI_OnLoad successful");
    return JNI_VERSION_1_6;
}
