@echo off

mkdir build
cd build

rem Need to handle Python 3.x case at some point (Visual Studio 2010)
if %ARCH%==32 (
  if %PY_VER% LSS 3 (
    set CMAKE_GENERATOR="Visual Studio 9 2008"
    set CMAKE_CONFIG="Release|Win32"
  )
)
if %ARCH%==64 (
  if %PY_VER% LSS 3 (
    set CMAKE_GENERATOR="Visual Studio 9 2008 Win64"
    set CMAKE_CONFIG="Release|x64"
  )
)

cmake ../tools/python -G"$CMAKE_GENERATOR" ^
-DCMAKE_PREFIX_PATH="%PREFIX%" ^
-DBUILD_SHARED_LIBS=1 ^
-DBoost_USE_STATIC_LIBS=0 ^
-DBoost_USE_STATIC_RUNTIME=0 ^
-DBOOST_INCLUDEDIR="%PREFIX%\include" ^
-DBOOST_LIBRARYDIR="%PREFIX%\lib" ^
-DPYTHON_LIBRARY="%PREFIX%\lib\libpython$PY_VER.dll" ^
-DPYTHON_INCLUDE_DIR="%PREFIX%\include\python$PY_VER" ^
-DDLIB_NO_GUI_SUPPORT=1 ^
-DDLIB_USE_BLAS=0 ^
-DDLIB_USE_LAPACK=0

cmake --build . --config %CMAKE_CONFIG% --target ALL_BUILD
cmake --build . --config %CMAKE_CONFIG% --target INSTALL

move dlib.dll "%SP_DIR%"
