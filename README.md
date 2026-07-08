# TALibKit

Auto-built Swift Package (XCFramework) wrapping the official [TA-Lib](https://github.com/TA-Lib/ta-lib) C library for iOS, macOS, tvOS and watchOS.

This repo has a GitHub Action that checks daily for new TA-Lib releases, cross-compiles a fresh XCFramework, publishes it as a GitHub Release asset, and auto-updates this README and Package.swift with the new download link and checksum.

<!-- AUTO-UPDATE:START -->
![TA-Lib version](https://img.shields.io/badge/TA--Lib-v0.7.1-blue)

- Latest built release: [v0.7.1](https://github.com/shahid0-cyber/TALibKit/releases/download/v0.7.1/TALibKit.xcframework.zip)

```swift
.package(url: "https://github.com/shahid0-cyber/TALibKit.git", from: "0.7.1")
```
<!-- AUTO-UPDATE:END -->

## Usage

Add this package in Xcode via File > Add Packages, or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/shahid0-cyber/TALibKit.git", from: "0.7.1")
]
```
