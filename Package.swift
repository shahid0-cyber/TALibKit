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
            url: "TALIB_XCFRAMEWORK_URL_PLACEHOLDER",
            checksum: "TALIB_XCFRAMEWORK_CHECKSUM_PLACEHOLDER"
        )
    ]
)
