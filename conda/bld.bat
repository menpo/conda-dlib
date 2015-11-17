@echo off
setlocal EnableDelayedExpansion

mkdir build
cd build

set CMAKE_CONFIG="Release"

if "%PY_VER%" == "3.4" (
    set GENERATOR=Visual Studio 10 2010
) else (
    if "%PY_VER%" == "3.5" (
        set GENERATOR=Visual Studio 14 2015
    ) else (
        set GENERATOR=Visual Studio 9 2008
    )
)

if %ARCH% EQU 64 (
    set GENERATOR=%GENERATOR% Win64
)

set CMAKE_COMMAND="%LIBRARY_BIN%\bin\cmake.exe"
set CMAKE_ROOT="%LIBRARY_BIN%\share\cmake-3.3"

rem The Python lib has no period in the
rem version string, so we remove it here.
set PY_VER_NO_DOT=%PY_VER:.=%

%CMAKE_COMMAND% ..\tools\python -LAH -G"%GENERATOR%" ^
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
copy "%LIBRARY_BIN%\libpng16.dll" "%SP_DIR%\libpng16.dll"
copy "%LIBRARY_BIN%\zlib.dll" "%SP_DIR%\zlib.dll"
robocopy "%LIBRARY_LIB%" "%SP_DIR%" /E boost_python*.dll
move "..\python_examples\dlib.pyd" "%SP_DIR%\dlib.pyd"
