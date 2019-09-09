@echo on

SET DEP_ERR_MSG="must be installed before installing nsp"
SET BUILDABLE=true
SET EXE_LOCATION=%appdata%\local\bin\nsp.bat
SET DEP_LOCATION=%appdata%\nsp

echo Warning: Ensure that the NoSyn compiler nsc is installed before installing nsp
echo Warning: Ensure that the D Build Management System DUB is installed before installing nsp

if %BUILDABLE%==true (echo "Please install nsp dependencies" || exit)

dub build

IF EXIST %DEP_LOCATION% (
    IF EXIST %EXE_LOCATION% ( goto DEP_EXE_EXISTS ) ELSE ( goto DEP_EXISTS_EXE_NOT )
) ELSE ( goto DEP_NOT_EXIST )

:DEP_EXE_EXISTS
    SET /p USER_INPUT= "Would you like to reinstall nsp? [n/Y]:"
    IF "%USER_INPUT%"=="n" (echo Install cancelled || exit)

    goto INSTALL_NSP
:DEP_EXISTS_EXE_NOT
    SET /p USER_INPUT= "The %DEP_LOCATION% file already exists. Is it ok to overwrite this for install? [N/y]:"
    echo %USER_INPUT%
    IF "%USER_INPUT%"=="y" (
        echo Continue
    ) ELSE (echo Install cancelled || exit)

    goto INSTALL_NSP
:DEP_NOT_EXIST
    goto INSTALL_NSP

:INSTALL_NSP
del %EXE_LOCATION%
rmdir /s /q %DEP_LOCATION%

mkdir %DEP_LOCATION%
xcopy /e /y .\installation_deps_windows %DEP_LOCATION%
mkdir %DEP_LOCATION%\project_defaults
xcopy /e /y .\installation_deps\project_defaults %DEP_LOCATION%\project_defaults
copy .\nsp.exe %DEP_LOCATION%\nsp_compile.exe
mklink %EXE_LOCATION% %DEP_LOCATION%\scripts\nsp_bin.bat 

:END_PROGRAM

