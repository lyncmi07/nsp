#!/bin/sh

NSP_INSTALL_LOCATION=$(dirname $(readlink -f "$0"))/../

if test "$1" = 'create'; then
	$NSP_INSTALL_LOCATION/scripts/create_project.sh $2
fi

if test "$1" = 'compile'; then
	$NSP_INSTALL_LOCATION/nsp_compile
fi

if test "$1" = 'run'; then
	$NSP_INSTALL_LOCATION/scripts/run_program.sh
fi

if test "$1" = 'clean'; then
	$NSP_INSTALL_LOCATION/scripts/clean_project.sh
fi
