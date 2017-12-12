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
        .package(url: "https://github.com/cyllene-project/Networking.git", from: "0.2.1"),
        .package(url: "https://github.com/IBM-Swift/BlueSignals.git", from: "0.9.50"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "WaylandServer",
            dependencies: ["Networking", "Util", "Signals"]),
        .target(
            name: "WaylandClient",
            dependencies: ["Networking", "Util", "Signals"]),
        .target(
            name: "Util",
            dependencies: []),
        .target(
            name: "Private",
            dependencies: ["Util"]),
        .testTarget(
            name: "ClientTests",
            dependencies: ["WaylandClient"]),
        .testTarget(
            name: "ServerTests",
            dependencies: ["WaylandServer"]),
    ]
)
