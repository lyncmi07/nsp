#!/bin/sh

BASEDIR=$(dirname "$0")

mkdir $1
cd $1
mkdir .nsp
mkdir src
cat $BASEDIR/app.d.default > ./src/app.d
cat $BASEDIR/nosyn.ns.default> ./src/nosyn.ns

cd ./.nsp
dub init $1 -n
mv $1 dproj
touch buildtime
