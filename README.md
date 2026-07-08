# TALibKit

Auto-built Swift Package (XCFramework) wrapping the official [TA-Lib](https://github.com/TA-Lib/ta-lib) C library for iOS, macOS, tvOS and watchOS.

This repo has a GitHub Action that checks daily for new TA-Lib releases, cross-compiles a fresh XCFramework, publishes it as a GitHub Release asset, and auto-updates this README and Package.swift with the new download link and checksum.

<!-- AUTO-UPDATE:START -->


- Latest built release: pending first run

```swift
.package(url: "https://github.com/YOUR_GH_USERNAME/TALibKit.git", from: "0.0.0")
```
<!-- AUTO-UPDATE:END -->

## Usage

Add this package in Xcode via File > Add Packages, or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/YOUR_GH_USERNAME/TALibKit.git", from: "0.7.1")
]
```
