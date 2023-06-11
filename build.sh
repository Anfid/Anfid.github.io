#!/bin/sh

set -e

# Build page in release mode
echo "Building..."
echo "$ elm make --optimize --output docs/main.js src/Main.elm"
elm make --optimize --output docs/main.js src/Main.elm

# TODO: build subprojects

# Uglify
if command -v terser > /dev/null 2>&1; then
  echo "Uglifying..."
  echo "$ terser docs/main.js --compress passes=2,pure_getters=true -o docs/main.js"
  terser docs/main.js --compress passes=2,pure_getters=true -o docs/main.js && echo "Done"
else
  echo "terser CLI util wasn't found, uglification skipped"
fi
