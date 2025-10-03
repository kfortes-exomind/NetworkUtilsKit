// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkUtilsKit",
	platforms: [.iOS("15.0"), .macOS("14.0")],
    products: [
        .library(name: "NetworkUtilsKit", targets: ["NetworkUtilsKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/kfortes-exomind/UtilsKit.git", branch: "Version-4-0-0-Swift5"),
    ],
    targets: [
        .target(
            name: "NetworkUtilsKit",
            dependencies: ["UtilsKitCore"])
    ]
)
