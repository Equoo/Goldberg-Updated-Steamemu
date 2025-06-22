cd /d "%~dp0"
del /Q /S release\*
rmdir /S /Q release\experimental
rmdir /S /Q release\experimental_steamclient
rmdir /S /Q release\lobby_connect
rmdir /S /Q release
mkdir release
call build_set_protobuf_directories.bat
echo DEBUG protobuf directories: %PROTOBUF_X86_DIRECTORY% %PROTOBUF_X64_DIRECTORY%
"%PROTOC_X86_EXE%" -I.\dll\ --cpp_out=.\dll\ .\dll\net.proto
echo DEBUG protoc x86: %PROTOC_X86_EXE%

if not exist "%PROTOC_X86_EXE%" (
	echo ERROR: protoc x86 executable not found: %PROTOC_X86_EXE%
	exit /b 1
)
if not exist "%PROTOC_X64_EXE%" (
	echo ERROR: protoc x64 executable not found: %PROTOC_X64_EXE%
	exit /b 1
)
if not exist "%PROTOBUF_X86_DIRECTORY%\include\google\protobuf\compiler\plugin.h" (
	echo ERROR: protobuf x86 include directory not found: %PROTOBUF_X86_DIRECTORY%\include\google\protobuf\compiler\plugin.h
	exit /b 1
)
if not exist "%PROTOBUF_X64_DIRECTORY%\include\google\protobuf\compiler\plugin.h" (
	echo ERROR: protobuf x64 include directory not found: %PROTOBUF_X64_DIRECTORY%\include\google\protobuf\compiler\plugin.h
	exit /b 1
)
if not exist "%PROTOBUF_X86_LIBRARY%" (
	echo ERROR: protobuf x86 library not found: %PROTOBUF_X86_LIBRARY%
	exit /b 1
)
if not exist "%PROTOBUF_X64_LIBRARY%" (
	echo ERROR: protobuf x64 library not found: %PROTOBUF_X64_LIBRARY%
	exit /b 1
)
if not exist dll\rtlgenrandom.c (
	echo ERROR: rtlgenrandom.c not found in dll directory.
	exit /b 1
)
if not exist dll\rtlgenrandom.def (
	echo ERROR: rtlgenrandom.def not found in dll directory.
	exit /b 1
)
if not exist dll\net.proto (
	echo ERROR: net.proto not found in dll directory.
	exit /b 1
)
if not exist dll\*.cpp (
	echo ERROR: No .cpp files found in dll directory.
	exit /b 1
)
if not exist dll\*.cc (
	echo ERROR: No .cc files found in dll directory.
	exit /b 1
)
if not exist "%PROTOBUF_X86_LIBRARY%" (
	echo ERROR: Protobuf x86 library not found: %PROTOBUF_X86_LIBRARY%
	exit /b 1
)
if not exist "%PROTOBUF_X64_LIBRARY%" (
	echo ERROR: Protobuf x64 library not found: %PROTOBUF_X64_LIBRARY%
	exit /b 1
)


call build_env_x86.bat
cl dll/rtlgenrandom.c dll/rtlgenrandom.def
cl /LD /DEMU_RELEASE_BUILD /DNDEBUG /I%PROTOBUF_X86_DIRECTORY%\include\ dll/*.cpp dll/*.cc "%PROTOBUF_X86_LIBRARY%" Iphlpapi.lib Ws2_32.lib rtlgenrandom.lib Shell32.lib /EHsc /MP12 /Ox /link /debug:none /OUT:release\steam_api.dll

"%PROTOC_X64_EXE%" -I.\dll\ --cpp_out=.\dll\ .\dll\net.proto
call build_env_x64.bat
cl dll/rtlgenrandom.c dll/rtlgenrandom.def
cl /LD /DEMU_RELEASE_BUILD /DNDEBUG /I%PROTOBUF_X64_DIRECTORY%\include\ dll/*.cpp dll/*.cc "%PROTOBUF_X64_LIBRARY%" Iphlpapi.lib Ws2_32.lib rtlgenrandom.lib Shell32.lib /EHsc /MP12 /Ox /link /debug:none /OUT:release\steam_api64.dll
copy Readme_release.txt release\Readme.txt
xcopy /s files_example\* release\

call build_win_release_experimental.bat
call build_win_release_experimental_steamclient.bat
call build_win_lobby_connect.bat
call build_win_find_interfaces.bat
