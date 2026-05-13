// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "GlassKitDemo",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "GlassKitDemo",
            targets: ["App"]
        )
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: ["GlassKitCore"],
            path: "Sources/App"
        ),
        .target(
            name: "GlassKitCore",
            path: "Sources/GlassKit"
        )
    ]
)
