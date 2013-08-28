#!/bin/sh

# TODO: let application reside in other directories
# TODO: include flags to only compile kernel etc.

if [ -z $1 ]
then
	echo "Usage: `basename $0` <config-name>"
	exit 1
fi

CONFIG_FILE=config.$1

if [ ! -e $CONFIG_FILE ]
then
	echo "The config file \"$CONFIG_FILE\" does not exist."
	exit 1
fi

# include config file to set appropriate variables
. ./$CONFIG_FILE

if [ -z ECOS_REPOSITORY ] || [ -z ECC ]
then
	echo "The variables \"ECOS_REPOSITORY\" AND \"ECC\" have not been set properly."
	exit 1
fi

mkdir -p $1-build
rm -rf $1-build/*
cd $1-build
KPATH=`pwd`

../ecosconfig --config=../$ECC tree
make

cd ..

OPT="-std=gnu99 -Wpointer-arith -Winline -Wundef -g -nostdlib -ffunction-sections -fdata-sections -fno-exceptions"

# compile the application
arm-none-eabi-gcc -g -I./ -g -I${KPATH}/install/include ${FILES} \
	-L${KPATH}/install/lib -Ttarget.ld ${ARCH_OPT} ${OPT} ${ADD_OPT} -o $1 
