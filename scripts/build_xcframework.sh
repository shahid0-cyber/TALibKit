#!/bin/bash
set -euo pipefail

# Usage: ./build_xcframework.sh <ta-lib-version-tag>
TALIB_VERSION="${1:?Provide TA-Lib version tag, e.g. v0.7.1}"
WORKDIR="$(pwd)/talib_build"
SRC_DIR="$WORKDIR/src"
OUT_DIR="$WORKDIR/out"
XCFRAMEWORK_NAME="TALibKit.xcframework"
JOBS="$(sysctl -n hw.ncpu)"

rm -rf "$WORKDIR"
mkdir -p "$SRC_DIR" "$OUT_DIR"

echo ">> Cloning TA-Lib $TALIB_VERSION"
git clone --depth 1 --branch "$TALIB_VERSION" https://github.com/TA-Lib/ta-lib.git "$SRC_DIR"

# One XCFramework slice per SDK: "sdk|clang target triples".
# Deployment targets match the platforms in Package.swift.
SLICES=(
  "iphoneos|arm64-apple-ios13.0"
  "iphonesimulator|arm64-apple-ios13.0-simulator x86_64-apple-ios13.0-simulator"
  "macosx|arm64-apple-macos11.0 x86_64-apple-macos11.0"
  "appletvos|arm64-apple-tvos13.0"
  "appletvsimulator|arm64-apple-tvos13.0-simulator x86_64-apple-tvos13.0-simulator"
  "watchos|arm64_32-apple-watchos6.0 arm64-apple-watchos6.0"
  "watchsimulator|arm64-apple-watchos6.0-simulator x86_64-apple-watchos6.0-simulator"
)

SOURCES=()
while IFS= read -r src; do SOURCES+=("$src"); done < <(
  find "$SRC_DIR/src/ta_func" "$SRC_DIR/src/ta_common" "$SRC_DIR/src/ta_abstract" -name '*.c' | sort
)

INCLUDES=(
  -I"$SRC_DIR/include"
  -I"$SRC_DIR/src/ta_common"
  -I"$SRC_DIR/src/ta_func"
  -I"$SRC_DIR/src/ta_abstract"
  -I"$SRC_DIR/src/ta_abstract/frames"
)

# Compiles every triple of an SDK and merges them into one static library.
build_slice() {
  local sdk="$1" triples="$2"
  local slice_dir="$WORKDIR/build/$sdk"
  local cc sdk_path triple
  cc="$(xcrun --sdk "$sdk" --find clang)"
  sdk_path="$(xcrun --sdk "$sdk" --show-sdk-path)"

  local libs=()
  for triple in $triples; do
    echo ">> Building $triple" >&2
    local obj_dir="$slice_dir/$triple"
    mkdir -p "$obj_dir"
    (cd "$obj_dir" && printf '%s\0' "${SOURCES[@]}" |
      xargs -0 -n 32 -P "$JOBS" "$cc" -target "$triple" -isysroot "$sdk_path" -O2 "${INCLUDES[@]}" -c)
    xcrun --sdk "$sdk" libtool -static -o "$obj_dir/libta-lib.a" "$obj_dir"/*.o
    libs+=("$obj_dir/libta-lib.a")
  done

  lipo -create "${libs[@]}" -output "$slice_dir/libta-lib.a"
  echo "$slice_dir/libta-lib.a"
}

# The module map lets Swift `import TALibKit` and call the C API directly.
# It sits in a TALibKit/ subfolder so it can't clash with other XCFrameworks'
# headers, which Xcode copies into one shared include directory.
HEADERS_DIR="$WORKDIR/headers"
mkdir -p "$HEADERS_DIR/TALibKit"
cp "$SRC_DIR"/include/*.h "$HEADERS_DIR/TALibKit/"
cat > "$HEADERS_DIR/TALibKit/module.modulemap" <<'EOF'
module TALibKit {
    umbrella header "ta_libc.h"
    export *
}
EOF

XCFRAMEWORK_ARGS=()
for slice in "${SLICES[@]}"; do
  lib="$(build_slice "${slice%%|*}" "${slice#*|}")"
  XCFRAMEWORK_ARGS+=(-library "$lib" -headers "$HEADERS_DIR")
done

echo ">> Creating XCFramework"
xcodebuild -create-xcframework "${XCFRAMEWORK_ARGS[@]}" -output "$OUT_DIR/$XCFRAMEWORK_NAME"

cd "$OUT_DIR"
zip -qr "${XCFRAMEWORK_NAME}.zip" "$XCFRAMEWORK_NAME"

echo ">> Done: $OUT_DIR/${XCFRAMEWORK_NAME}.zip"
echo ">> Checksum:"
swift package compute-checksum "${XCFRAMEWORK_NAME}.zip"
