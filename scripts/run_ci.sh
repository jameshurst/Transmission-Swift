#!/bin/bash

set -ex

if [ -n "$(git ls-files --others --modified --exclude-standard)" ]; then
  printf "\e[1;31mError: Unclean git environment.\e[0m\n"
  exit -1
fi

scripts/format.sh
if [ -n "$(git ls-files --others --modified --exclude-standard)" ]; then
  printf "\e[1;31mError: Found changes after running 'scripts/format.sh'.\e[0m\n"
  exit -1
fi

tools/swiftlint --strict

swift package clean
swift build
