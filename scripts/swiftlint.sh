#!/bin/bash

set -ex

VERSION='0.39.1'
SWIFTLINT='scripts/.bin/swiftlint'
BUILD='scripts/.bin/build/SwiftLint'

unset SDKROOT

if [[ -e $SWIFTLINT && $($SWIFTLINT version) != $VERSION ]]; then
    rm $SWIFTLINT
fi

if [[ ! -e $SWIFTLINT ]]; then
    mkdir -p $(dirname $BUILD)
    rm -rf $BUILD
    git clone --depth 1 --branch $VERSION 'https://github.com/realm/SwiftLint.git' $BUILD
    pushd $BUILD
    swift build --product swiftlint -Xswiftc -suppress-warnings
    popd
    mkdir -p $(dirname $SWIFTLINT)
    mv $BUILD/.build/debug/swiftlint $SWIFTLINT
    rm -rf $BUILD
fi

./$SWIFTLINT $@
