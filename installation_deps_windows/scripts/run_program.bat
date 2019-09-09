@echo off
call nsp compile
dub run --root=.\.nsp\dproj
