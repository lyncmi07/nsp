#!/bin/sh

# Dependency Checks


echo "Running dependency checks for installation"

DEP_ERR_MSG="must be installed before installing nsp"
BUILDABLE=true
EXE_LOCATION=/usr/local/bin/nsp
DEP_LOCATION=/usr/local/share/nsp
MAN_LOCATION=/usr/local/share/man

if test $(id -u) != 0 ; then
    echo "Run as root to install"
    exit 1
fi

if ! command -v nsc; then
	echo "The NoSyn compiler nsc $DEP_ERR_MSG"
	BUILDABLE=false
fi

if ! command -v dub; then
	echo "The D Build Management System DUB $DEP_ERR_MSG"
	BUILDABLE=false
fi

if ! $BUILDABLE; then
	echo "Not installing due to missing dependencies"
	exit 1
fi

dub build

if test -d $DEP_LOCATION; then
	if test -f $EXE_LOCATION; then
		printf "Would you like to reinstall nsp? [n/Y]:"
		read USER_INPUT
		if test "$USER_INPUT" = 'n'; then
			echo "Install cancelled"
			exit 1
		fi
	else
		printf "The $DEP_LOCATION file already exists. Is it ok to overwrite this for install? [N/y]:"
		read USER_INPUT
		if test $USER_INPUT != 'y'; then
			echo "Install cancelled"
			exit 1
		fi
	fi
fi

rm -f $EXE_LOCATION
rm -f -r $DEP_LOCATION
rm -f $MAN_LOCATION/man1/nsp.1

cp -r ./installation_deps $DEP_LOCATION
cp ./nsp $DEP_LOCATION/nsp_compile
chmod +x $DEP_LOCATION/nsp_compile
ln -s $DEP_LOCATION/scripts/nsp_bin.sh $EXE_LOCATION
chmod +x $EXE_LOCATION
chmod +x $DEP_LOCATION/scripts/*
cp ./documents/nsp.man $MAN_LOCATION/man1/nsp.1

echo "Install complete"
