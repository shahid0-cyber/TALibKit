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
            url: "https://github.com/shahid0-cyber/TALibKit/releases/download/v0.8.3/TALibKit.xcframework.zip",
            checksum: "5d56389a337692a73e74209b10b19006169840d3f5a9583ecec2e01f185b625c"
        )
    ]
)
