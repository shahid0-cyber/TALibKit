# TALibKit

Auto-built Swift Package (XCFramework) wrapping the official [TA-Lib](https://github.com/TA-Lib/ta-lib) C library for iOS, macOS, tvOS and watchOS.

This repo has a GitHub Action that checks daily for new TA-Lib releases, cross-compiles a fresh XCFramework, publishes it as a GitHub Release asset, and auto-updates this README and Package.swift with the new download link and checksum.

<!-- AUTO-UPDATE:START -->
![TA-Lib version](https://img.shields.io/badge/TA--Lib-v0.8.3-blue)

- Latest built release: [v0.8.3](https://github.com/shahid0-cyber/TALibKit/releases/download/v0.8.3/TALibKit.xcframework.zip)

```swift
.package(url: "https://github.com/shahid0-cyber/TALibKit.git", from: "0.8.3")
```
<!-- AUTO-UPDATE:END -->

## Usage

Add the package in Xcode via File > Add Package Dependencies, or add the line above to the `dependencies` in your `Package.swift`.

`import TALibKit` exposes the TA-Lib C API directly. No bridging header, C shim target or `@_silgen_name` needed:

```swift
import TALibKit

TA_Initialize() // once, before other TA-Lib calls

let closes: [Double] = [/* your price series */]
var begIdx: Int32 = 0, outCount: Int32 = 0
var rsi = [Double](repeating: 0, count: closes.count)

if TA_RSI(0, Int32(closes.count - 1), closes, 14, &begIdx, &outCount, &rsi) == TA_SUCCESS {
    // rsi[i] belongs to closes[Int(begIdx) + i], for i in 0..<Int(outCount)
}
```

Every function is listed in the [TA-Lib API docs](https://ta-lib.org/api/).
