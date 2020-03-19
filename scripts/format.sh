#!/bin/bash

set -ex

VERSION='0.44.5'
SWIFTFORMAT='scripts/.bin/swiftformat'
BUILD='scripts/.bin/build/SwiftFormat'

unset SDKROOT

if [[ -e $SWIFTFORMAT && $($SWIFTFORMAT --version) != $VERSION ]]; then
    rm $SWIFTFORMAT
fi

if [[ ! -e $SWIFTFORMAT ]]; then
    mkdir -p $(dirname $BUILD)
    rm -rf $BUILD
    git clone --depth 1 --branch $VERSION 'https://github.com/nicklockwood/SwiftFormat.git' $BUILD
    pushd $BUILD
    swift build --product swiftformat -Xswiftc -suppress-warnings
    popd
    mkdir -p $(dirname $SWIFTFORMAT)
    mv $BUILD/.build/debug/swiftformat $SWIFTFORMAT
    rm -rf $BUILD
fi

./$SWIFTFORMAT --swiftversion 5.2 Sources Tests
