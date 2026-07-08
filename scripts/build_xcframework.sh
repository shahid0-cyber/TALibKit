#!/bin/bash
set -euo pipefail

# Usage: ./build_xcframework.sh <ta-lib-version-tag>
TALIB_VERSION="${1:?Provide TA-Lib version tag, e.g. v0.7.1}"
WORKDIR="$(pwd)/talib_build"
SRC_DIR="$WORKDIR/src"
OUT_DIR="$WORKDIR/out"
XCFRAMEWORK_NAME="TALibKit.xcframework"

rm -rf "$WORKDIR"
mkdir -p "$SRC_DIR" "$OUT_DIR"

echo ">> Cloning TA-Lib $TALIB_VERSION"
git clone --depth 1 --branch "$TALIB_VERSION" https://github.com/TA-Lib/ta-lib.git "$SRC_DIR"

# Platform/arch matrix: sdk|arch|min-version
PLATFORMS=(
  "iphoneos|arm64|13.0"
  "iphonesimulator|arm64|13.0"
  "iphonesimulator|x86_64|13.0"
  "macosx|arm64|11.0"
  "macosx|x86_64|11.0"
)

build_for_platform() {
  local sdk="$1" arch="$2" minver="$3"
  local build_dir="$WORKDIR/build_${sdk}_${arch}"
  mkdir -p "$build_dir"

  local sdk_path
  sdk_path=$(xcrun --sdk "$sdk" --show-sdk-path)

  local min_flag
  case "$sdk" in
    iphoneos) min_flag="-mios-version-min=$minver" ;;
    iphonesimulator) min_flag="-mios-simulator-version-min=$minver" ;;
    macosx) min_flag="-mmacosx-version-min=$minver" ;;
  esac

  echo ">> Building for $sdk / $arch" >&2
  local cc=(xcrun -sdk "$sdk" clang)
  local cflags=(-arch "$arch" -isysroot "$sdk_path" "$min_flag" -fembed-bitcode -O2)
  local includes=(
    -I"$SRC_DIR/include"
    -I"$SRC_DIR/src/ta_common"
    -I"$SRC_DIR/src/ta_func"
    -I"$SRC_DIR/src/ta_abstract"
    -I"$SRC_DIR/src/ta_abstract/frames"
  )

  find "$SRC_DIR/src/ta_func" -name "*.c" > "$build_dir/sources.txt"
  find "$SRC_DIR/src/ta_common" -name "*.c" >> "$build_dir/sources.txt"
  find "$SRC_DIR/src/ta_abstract" -name "*.c" >> "$build_dir/sources.txt" 2>/dev/null || true

  local obj_dir="$build_dir/obj"
  mkdir -p "$obj_dir"

  while read -r src; do
    obj="$obj_dir/$(basename "${src%.c}").o"
    "${cc[@]}" "${cflags[@]}" "${includes[@]}" -c "$src" -o "$obj"
  done < "$build_dir/sources.txt"

  local lib_path="$build_dir/libta-lib.a"
  xcrun -sdk "$sdk" libtool -static -o "$lib_path" "$obj_dir"/*.o

  echo "$lib_path"
}

LIB_IOS_DEVICE=$(build_for_platform "iphoneos" "arm64" "13.0")

LIB_SIM_ARM64=$(build_for_platform "iphonesimulator" "arm64" "13.0")
LIB_SIM_X86_64=$(build_for_platform "iphonesimulator" "x86_64" "13.0")
SIM_UNIVERSAL="$WORKDIR/libta-lib-sim-universal.a"
lipo -create "$LIB_SIM_ARM64" "$LIB_SIM_X86_64" -output "$SIM_UNIVERSAL"

LIB_MAC_ARM64=$(build_for_platform "macosx" "arm64" "11.0")
LIB_MAC_X86_64=$(build_for_platform "macosx" "x86_64" "11.0")
MAC_UNIVERSAL="$WORKDIR/libta-lib-mac-universal.a"
lipo -create "$LIB_MAC_ARM64" "$LIB_MAC_X86_64" -output "$MAC_UNIVERSAL"

HEADERS_DIR="$WORKDIR/headers"
mkdir -p "$HEADERS_DIR"
cp "$SRC_DIR"/include/*.h "$HEADERS_DIR"/

echo ">> Creating XCFramework"
xcodebuild -create-xcframework \
  -library "$LIB_IOS_DEVICE" -headers "$HEADERS_DIR" \
  -library "$SIM_UNIVERSAL" -headers "$HEADERS_DIR" \
  -library "$MAC_UNIVERSAL" -headers "$HEADERS_DIR" \
  -output "$OUT_DIR/$XCFRAMEWORK_NAME"

cd "$OUT_DIR"
zip -r "${XCFRAMEWORK_NAME}.zip" "$XCFRAMEWORK_NAME"

echo ">> Done: $OUT_DIR/${XCFRAMEWORK_NAME}.zip"
echo ">> Checksum:"
swift package compute-checksum "${XCFRAMEWORK_NAME}.zip"
