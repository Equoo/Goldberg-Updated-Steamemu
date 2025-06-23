
cd /d "%~dp0"
mkdir release\tools
del /Q release\tools\*

call build_env_x86.bat

:: Create the response file
(
    echo generate_interfaces_file.cpp
    echo /EHsc
    echo /MP12
    echo /Ox
    echo /link
    echo /debug:none
    echo /OUT:release\tools\generate_interfaces_file.exe
) > compile_args.rsp

:: Compile using the response file
cl @compile_args.rsp

del /Q /S release\tools\*.lib
del /Q /S release\tools\*.exp
copy Readme_generate_interfaces.txt release\tools\Readme_generate_interfaces.txt
