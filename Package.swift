// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "EasyCodable",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_11),
        .watchOS(.v2),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: "EasyCodable",
            targets: ["EasyCodable"]
        )
    ],
    targets: [
        .target(
            name: "EasyCodable"
        ),
        .testTarget(
            name: "EasyCodableTests",
            dependencies: ["EasyCodable"]
        )
    ]
)
