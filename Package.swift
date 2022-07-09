// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "CodableNilOnFail",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_11),
        .watchOS(.v2),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: "CodableNilOnFail",
            targets: ["CodableNilOnFail"]
        )
    ],
    targets: [
        .target(
            name: "CodableNilOnFail"
        ),
        .testTarget(
            name: "CodableNilOnFailTests",
            dependencies: ["CodableNilOnFail"]
        )
    ]
)
