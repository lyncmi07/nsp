@echo off

rmdir /S /Q .\.nsp\dproj\source
mkdir .\.nsp\dproj\source
del .\.nsp\buildtime
type nul > buildtime
