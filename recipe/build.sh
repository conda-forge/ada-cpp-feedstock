#!/bin/bash

set -ex
# if darwin print sdk version
if [[ $(uname) == Darwin ]]; then
  echo $CMAKE_ARGS
  xcrun --show-sdk-version
fi

python -m pip install . --no-build-isolation -v \
    --config-settings=cmake.args=-DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    --config-settings=cmake.args=-DBUILD_PYTHON=ON \
    --config-settings=cmake.args=-DBUILD_STP2GLB=ON \
    --config-settings=cmake.args=-DSTP2GLB_BIN_DIR="${PREFIX}/bin" \
    --config-settings=cmake.args=-DBUILD_WASM=OFF