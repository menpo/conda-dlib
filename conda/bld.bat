@echo off

mkdir build
cd build

rem Need to handle Python 3.x case at some point (Visual Studio 2010)
if %ARCH%==32 (
  set CMAKE_CONFIG="Release"

  if %PY_VER% LSS 3 (
	set GENERATOR="Visual Studio 9 2008"
  ) else (
	set GENERATOR="Visual Studio 10"
  )
)
if %ARCH%==64 (
  set CMAKE_CONFIG="Release"

  if %PY_VER% LSS 3 (
	set GENERATOR="Visual Studio 9 2008 Win64"
  ) else (
	set GENERATOR="Visual Studio 10 Win64"
  )
)

set CMAKE_COMMAND="%LIBRARY_BIN%\bin\cmake.exe"
set CMAKE_ROOT="%LIBRARY_BIN%\share\cmake-3.3"

rem The Python lib has no period in the
rem version string, so we remove it here.
set PY_VER_NO_DOT=%PY_VER:.=%

%CMAKE_COMMAND% ..\tools\python -LAH -G%GENERATOR% ^
-DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
-DBUILD_SHARED_LIBS=1 ^
-DBoost_USE_STATIC_LIBS=0 ^
-DBoost_USE_STATIC_RUNTIME=0 ^
-DBOOST_INCLUDEDIR="%LIBRARY_INC%" ^
-DBOOST_LIBRARYDIR="%LIBRARY_LIB%" ^
-DPYTHON3=%PY3K% ^
-DPYTHON_LIBRARY="%PREFIX%\libs\python%PY_VER_NO_DOT%.lib" ^
-DPYTHON_INCLUDE_DIR="%PREFIX%\include" ^
-DDLIB_LINK_WITH_SQLITE3=0 ^
-DDLIB_LINK_WITH_LIBPNG=1 ^
-DPNG_INCLUDE_DIR="%LIBRARY_INC%" ^
-DPNG_PNG_INCLUDE_DIR="%LIBRARY_INC%" ^
-DDLIB_LINK_WITH_LIBJPEG=1 ^
-DDLIB_NO_GUI_SUPPORT=1 ^
-DDLIB_USE_BLAS=0 ^
-DDLIB_USE_LAPACK=0

%CMAKE_COMMAND% --build . --config %CMAKE_CONFIG% --target ALL_BUILD
%CMAKE_COMMAND% --build . --config %CMAKE_CONFIG% --target INSTALL

rem Copy the dlib libraries and the dlls it depends upon
rem Unfortunately, they have to be put in the root.
cp "%LIBRARY_BIN%\libpng16.dll" "%SP_DIR%\libpng16.dll"
move "..\python_examples\*.dll" "%SP_DIR%"
move "..\python_examples\dlib.lib" "%SP_DIR%"
move "..\python_examples\dlib.pyd" "%SP_DIR%"
