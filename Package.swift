// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Wayland",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Wayland",
            targets: ["WaylandServer"]),
    ],
    dependencies: [
        //.package(url: "https://github.com/PerfectlySoft/Perfect-Net.git", from: "3.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "WaylandServer",
            dependencies: ["Private", "Util"]),
        .target(
            name: "WaylandClient",
            dependencies: ["Private", "Util"]),
        .target(
            name: "Private",
            dependencies: ["Util"]),
        .target(
            name: "Util",
            dependencies: []),
        .testTarget(
            name: "ClientTests",
            dependencies: ["WaylandClient"]),
        .testTarget(
            name: "ServerTests",
            dependencies: ["WaylandServer"]),
    ]
)
