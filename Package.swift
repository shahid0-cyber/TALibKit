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
            checksum: "d092ae2a62b9dafdd0e5e87f59af978a112b4e841a886830a4e0ceea6d3633eb"
        )
    ]
)
