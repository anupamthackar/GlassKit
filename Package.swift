// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "GlassKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "GlassKit",
            targets: ["GlassKit"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "GlassKit",
            dependencies: [],
            path: "Sources/GlassKit",
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "GlassKitTests",
            dependencies: ["GlassKit"],
            path: "Tests/GlassKitTests"
        ),
    ]
)
