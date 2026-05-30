// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_security_check",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "flutter-security-check", targets: ["flutter_security_check"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "flutter_security_check",
            dependencies: [],
            path: "../../Classes",
            resources: []
        )
    ]
)
