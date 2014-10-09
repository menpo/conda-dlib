#!/bin/bash
mkdir build
cd build

CMAKE_GENERATOR="Unix Makefiles"
CMAKE_ARCH="-m"$ARCH

if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  export CFLAGS="$CFLAGS -fPIC $CMAKE_ARCH"
  export LDFLAGS="$LDFLAGS $CMAKE_ARCH"
  DYNAMIC_EXT="so"
fi
if [ "$(uname -s)" == "Darwin" ]; then
  DYNAMIC_EXT="dylib"
fi

export LDFLAGS="-L$PREFIX/lib $LDFLAGS"

cmake ../tools/python -G"$CMAKE_GENERATOR" \
-DCMAKE_PREFIX_PATH=$PREFIX \
-DBUILD_SHARED_LIBS=1 \
-DBoost_USE_STATIC_LIBS=0 \
-DBoost_USE_STATIC_RUNTIME=0 \
-DBOOST_INCLUDEDIR=$PREFIX/include \
-DBOOST_LIBRARYDIR=$PREFIX/lib \
-DPYTHON_LIBRARY=$PREFIX/lib/libpython$PY_VER.$DYNAMIC_EXT \
-DPYTHON_INCLUDE_DIR=$PREFIX/include/python$PY_VER \
-DDLIB_NO_GUI_SUPPORT=1 \
-DDLIB_USE_BLAS=0 \
-DDLIB_USE_LAPACK=0
# Above should be changed when the MKL features problem is solved

cmake --build . --config Release --target install

cp dlib.so $SP_DIR

