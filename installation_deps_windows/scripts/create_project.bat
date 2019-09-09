@echo off

SET NSP_INSTALL_LOCATION=%appdata%\nsp

echo Creating NSP Project
mkdir %1
cd %1
mkdir .nsp
mkdir src
copy %NSP_INSTALL_LOCATION%\project_defaults\app.d.default .\src\app.d
copy %NSP_INSTALL_LOCATION%\project_defaults\nosyn.ns.default .\src\nosyn.ns

cd .\.nsp
dub init %1 -n
move %1 dproj
del /q .\dproj\source\*
type nul > buildtime
cd ..\