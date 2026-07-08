// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "TALibKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "TALibKit",
            targets: ["TALibKit"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "TALibKit",
            url: "https://github.com/shahid0-cyber/TALibKit/releases/download/v0.7.1/TALibKit.xcframework.zip",
            checksum: "8c8ada62080afb3cb30cfc455b01f3a8fd5152e608a9d303d108b0c37335122c"
        )
    ]
)
