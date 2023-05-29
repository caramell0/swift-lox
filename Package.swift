// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "swift-lox",
    products: [
        .library(
            name: "Lox",
            targets: [
                "Lox"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "1.2.2"))
    ],
    targets: [
        .target(
            name: "Lox",
            dependencies: []
        ),
        .executableTarget(
            name: "loxi",
            dependencies: [
                "Lox",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "LoxTests",
            dependencies: [
                "Lox"
            ]
        ),
    ]
)