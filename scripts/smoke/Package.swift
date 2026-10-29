// swift-tools-version:5.7
import PackageDescription

// Imports the freshly built XCFramework the way apps do, before it is published.
let package = Package(
    name: "Smoke",
    platforms: [.macOS(.v11)],
    targets: [
        .binaryTarget(name: "TALibKit", path: "../../talib_build/out/TALibKit.xcframework"),
        .executableTarget(name: "Smoke", dependencies: ["TALibKit"])
    ]
)
