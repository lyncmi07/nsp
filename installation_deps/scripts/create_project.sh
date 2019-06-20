#!/bin/sh

NSP_INSTALL_LOC=$(dirname $(readlink -f "$0"))/../

mkdir $1
cd $1
mkdir .nsp
mkdir src
cat $NSP_INSTALL_LOC/project_defaults/app.d.default > ./src/app.d
cat $NSP_INSTALL_LOC/project_defaults/nosyn.ns.default> ./src/nosyn.ns

cd ./.nsp
dub init $1 -n
mv $1 dproj
rm ./dproj/source/*
touch buildtime
