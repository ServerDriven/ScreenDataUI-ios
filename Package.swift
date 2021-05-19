// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScreenDataUI",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ScreenDataUI",
            targets: ["ScreenDataUI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "ScreenData", url: "https://github.com/ServerDriven/ScreenData-swift", from: "0.4.1"),
        .package(name: "ScreenDataNavigation", url: "https://github.com/ServerDriven/ScreenDataNavigation-swift", from: "0.5.0"),
        .package(url: "https://github.com/0xLeif/FlatMany", from: "0.2.0"),
        .package(url: "https://github.com/0xLeif/Task", .branch("main"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ScreenDataUI",
            dependencies: [
                "ScreenData",
                "ScreenDataNavigation",
                "FlatMany",
                "Task"
            ]),
        .testTarget(
            name: "ScreenDataUITests",
            dependencies: ["ScreenDataUI"]),
    ]
)
