#!/bin/bash

set -ex

# CMake 4.x's FindThreads probes (CMAKE_HAVE_LIBC_PTHREAD, -pthread, -lpthread)
# all fail to compile/link in the conda-forge macOS cross-compile sysroot, so
# any find_package(Threads) (ours and CGAL's) errors out with "Could NOT find
# Threads". On macOS pthread lives in libSystem (libc), so assert that directly;
# FindThreads then short-circuits to an empty Threads::Threads target.
if [[ "${target_platform}" == osx-* ]]; then
    export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_HAVE_LIBC_PTHREAD=ON"
fi

# Build with CMake
cmake -B build -S . -G Ninja ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_PYTHON=ON \
    -DBUILD_STP2GLB=ON \
    -DSTP2GLB_BIN_DIR="${PREFIX}/bin" \
    -DBUILD_WASM=OFF \
    -DPYTHON_EXECUTABLE="${PYTHON}" \
    -DPYTHON_INCLUDE="${PREFIX}/include" \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_SYSTEM_PREFIX_PATH=$PREFIX \
    -DPYTHON_SITE_PACKAGES="${SP_DIR}"

cmake --build build
cmake --install build

# Install Python package files
${PYTHON} -m pip install . --no-deps --no-build-isolation -vv