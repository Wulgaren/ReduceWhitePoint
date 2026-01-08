// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ReduceWhitePoint",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "ReduceWhitePoint",
            targets: ["ReduceWhitePoint"]
        )
    ],
    targets: [
        .executableTarget(
            name: "ReduceWhitePoint",
            dependencies: []
        )
    ]
)
