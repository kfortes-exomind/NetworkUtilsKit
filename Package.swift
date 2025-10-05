// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkUtilsKit",
	platforms: [.iOS("15.0"), .macOS("13.0")],
    products: [
        .library(name: "NetworkUtilsKit", targets: ["NetworkUtilsKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/kfortes-exomind/UtilsKit", branch: "swift-5.4")
    ],
    targets: [
        .target(
            name: "NetworkUtilsKit",
            dependencies: [.product(name: "UtilsKitCore", package: "UtilsKit")])
    ]
)
