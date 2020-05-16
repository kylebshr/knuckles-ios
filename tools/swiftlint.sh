#!/bin/bash

if which swiftlint >/dev/null; then
  swiftlint
else
  echo "warning: SwiftLint not installed, install with 'brew install swiftlint'"
fi
