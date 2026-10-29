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
            checksum: "7fc3cfb613ecb17c06d4d7f13380ce504d1a09444400c11abdf7c1098ba68250"
        )
    ]
)
