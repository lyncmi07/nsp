#!/bin/sh

# Dependency Checks

if ! id -u; then
	echo "You must be root to perform install"
	exit 1
fi

echo "Running dependency checks for installation"

DEP_ERR_MSG="must be installed before installing nsp"
BUILDABLE=true

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

if test -d /usr/share/nsp; then
	if test -f /usr/bin/nsp; then
		printf "Would you like to reinstall nsp? [n/Y]:"
		read USER_INPUT
		if test "$USER_INPUT" = 'n'; then
			echo "Install cancelled"
			exit 1
		fi
	else
		printf "The /usr/share/nsp file already exists. Is it ok to overwrite this for install? [N/y]:"
		read USER_INPUT
		if ! test "$USER_INPUT" ='y'; then
			echo "Install cancelled"
			exit 1
		fi
	fi
fi

rm -f /usr/bin/nsp
rm -f -r /usr/share/nsp
rm -f /usr/share/man/man1/nsp.1

cp -r ./installation_deps /usr/share/nsp
cp ./nsp /usr/share/nsp/nsp_compile
ln -s /usr/share/nsp/scripts/nsp_bin.sh /usr/bin/nsp 
cp ./documents/nspman /usr/share/man/man1/nsp.1

echo "Install complete"
