#!/bin/sh

NSP_INSTALL_LOCATION=/usr/local/share/nsp

echo "Creating NSP Project"
mkdir $1
cd $1
mkdir .nsp
mkdir src
cat $NSP_INSTALL_LOCATION/project_defaults/app.d.default > ./src/app.d
cat $NSP_INSTALL_LOCATION/project_defaults/nosyn.ns.default> ./src/nosyn.ns

cd ./.nsp
dub init $1 -n
mv $1 dproj
rm ./dproj/source/*
touch buildtime
