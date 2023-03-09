// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "DependenceDay",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "DependenceDay",
            targets: ["DependenceDay"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "DependenceDay",
            dependencies: []),
        .testTarget(
            name: "DependenceDayTests",
            dependencies: ["DependenceDay"]),
    ]
)
