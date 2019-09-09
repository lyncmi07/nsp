@echo off
SET NSP_INSTALL_LOCATION=%appdata%\nsp

IF "%1"=="create" (
    call %NSP_INSTALL_LOCATION%\scripts\create_project.bat %2
)
IF "%1"=="compile" (
    %NSP_INSTALL_LOCATION%\nsp_compile
)
IF "%1"=="run" (
    call %NSP_INSTALL_LOCATION%\scripts\run_program.bat
)
IF "%1"=="clean" (
    call %NSP_INSTALL_LOCATION%\scripts\clean_project.bat
)
