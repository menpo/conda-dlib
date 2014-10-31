#!/bin/bash
mkdir build
cd build

CMAKE_ARCH="-m"$ARCH

if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  export CFLAGS="$CFLAGS -fPIC $CMAKE_ARCH"
  export LDFLAGS="$LDFLAGS $CMAKE_ARCH"
  DYNAMIC_EXT="so"
  EXTRA_FLAGS=""
fi
if [ "$(uname -s)" == "Darwin" ]; then
  DYNAMIC_EXT="dylib"
  EXTRA_FLAGS="-DCMAKE_OSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET}"
fi

if [ $PY3K -eq 1 ]; then
  export PY_STR="${PY_VER}m"
else
  export PY_STR="${PY_VER}"
fi

export LDFLAGS="-L${LIBRARY_PATH} $LDFLAGS"

cmake ../tools/python \
-DCMAKE_PREFIX_PATH=$PREFIX \
-DBUILD_SHARED_LIBS=1 \
-DBoost_USE_STATIC_LIBS=0 \
-DBoost_USE_STATIC_RUNTIME=0 \
-DBOOST_INCLUDEDIR="${INCLUDE_PATH}" \
-DBOOST_LIBRARYDIR="${LIBRARY_PATH}" \
-DPYTHON_LIBRARY="${LIBRARY_PATH}/libpython$PY_STR.$DYNAMIC_EXT" \
-DPYTHON_INCLUDE_DIR="${INCLUDE_PATH}/python$PY_STR" \
-DDLIB_NO_GUI_SUPPORT=1 \
-DDLIB_USE_BLAS=0 \
-DDLIB_USE_LAPACK=0 ${EXTRA_FLAGS}
# Above should be changed when the MKL features problem is solved

cmake --build . --config Release --target install

cp dlib.so $SP_DIR

