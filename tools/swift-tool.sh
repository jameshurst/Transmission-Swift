#!/bin/bash

set -eu

unset SDKROOT

BIN_BASE="$(dirname "$0")/.bin"
BUILD_BASE="$BIN_BASE/build"
BIN="$BIN_BASE/$TOOL_NAME"
BUILD="$BUILD_BASE/$TOOL_NAME"

if [[ -e "$BIN" && $("$BIN" "$VERSION_CMD") != "$VERSION" ]]; then
    rm "$BIN"
fi

if [[ ! -e "$BIN" ]]; then
    mkdir -p "$BUILD_BASE"
    rm -rf "$BUILD"
    git clone --depth 1 --branch "$VERSION" "$REPO" "$BUILD"
    pushd "$BUILD"
    swift build --product "$PRODUCT" -Xswiftc -suppress-warnings
    BUILD_BIN="$(swift build --show-bin-path)/$PRODUCT"
    popd
    mkdir -p "$(dirname "$BIN")"
    mv "$BUILD_BIN" "$BIN"
    rm -rf "$BUILD"
    rmdir "$BUILD_BASE" 2>/dev/null || true
fi

"$BIN" $@
