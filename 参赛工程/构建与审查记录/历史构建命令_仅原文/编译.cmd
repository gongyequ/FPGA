@echo off
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" >nul
set GIT_CONFIG_COUNT=1
set GIT_CONFIG_KEY_0=safe.directory
set GIT_CONFIG_VALUE_0=*
set PATH=R:\suite\bin;R:\suite\lib;D:\python;D:\python\Scripts;%PATH%
"C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" -S R:/src -B R:/build -G Ninja -DCMAKE_MAKE_PROGRAM="C:/Program Files/Microsoft Visual Studio/2022/Community/Common7/IDE/CommonExtensions/Microsoft/CMake/Ninja/ninja.exe" -DCMAKE_BUILD_TYPE=Release -DCMAKE_PROJECT_yosys_INCLUDE=R:/deps/config.cmake -DPython3_EXECUTABLE=D:/python/python.exe -DYOSYS_ENABLE_UNIT_TESTS=OFF -DYOSYS_WITHOUT_SLANG=ON -DYOSYS_WITHOUT_TCL=OFF -DYOSYS_WITHOUT_READLINE=ON -DYOSYS_WITHOUT_EDITLINE=ON -DYOSYS_ABC_EXECUTABLE=R:/suite/bin/yosys-abc.exe -DFLEX_EXECUTABLE="R:/deps/winflexbison/flex.exe" -DBISON_EXECUTABLE="R:/deps/winflexbison/bison.exe"
if errorlevel 1 exit /b 1
"C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" --build R:/build --parallel 6
