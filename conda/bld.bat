@echo off

mkdir build
cd build

rem Need to handle Python 3.x case at some point (Visual Studio 2010)
if %ARCH%==32 (
  if %PY_VER% LSS 3 (
    set CMAKE_CONFIG="Release|Win32"
	set GENERATOR="Visual Studio 9 2008"
  )
)
if %ARCH%==64 (
  if %PY_VER% LSS 3 (
    set CMAKE_CONFIG="Release|x64"
	set GENERATOR="Visual Studio 9 2008 Win64"
  )
)

rem The Python lib has no period in the
rem version string, so we remove it here.
set PY_VER_NO_DOT=%PY_VER:.=%

cmake ..\tools\python -LAH -G%GENERATOR% ^
-DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
-DBUILD_SHARED_LIBS=1 ^
-DBoost_USE_STATIC_LIBS=0 ^
-DBoost_USE_STATIC_RUNTIME=0 ^
-DBOOST_INCLUDEDIR="%LIBRARY_INC%" ^
-DBOOST_LIBRARYDIR="%LIBRARY_LIB%" ^
-DPYTHON_LIBRARY="%PREFIX%\libs\python%PY_VER_NO_DOT%.lib" ^
-DPYTHON_INCLUDE_DIR="%PREFIX%\include" ^
-DDLIB_NO_GUI_SUPPORT=1 ^
-DDLIB_USE_BLAS=0 ^
-DDLIB_USE_LAPACK=0

cmake --build . --config %CMAKE_CONFIG% --target ALL_BUILD
cmake --build . --config %CMAKE_CONFIG% --target INSTALL

rem Copy the dlib libraries and the dlls it depends upon
rem Unfortunately, they have to be put in the root.
move "..\python_examples\*.dll" "%SP_DIR%"
move "..\python_examples\dlib.lib" "%SP_DIR%"
move "..\python_examples\dlib.pyd" "%SP_DIR%"
