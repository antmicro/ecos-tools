#!/bin/bash

# check for ecosconfig
command -v ecosconfig >/dev/null 2>&1 || { echo >&2 "FATAL: ecosconfig is not installed in the system. Put it in /usr/local/bin or an equivalent location."; exit 1; }

function get_option {
    VALUE=`echo $1 | sed 's/[-a-zA-Z0-9]*=//'`
}

function ecc_get_value {
	RET=`cat $ECC | grep $1 -A 10 | grep -v '#' | grep '_value' | head -1 | awk '{$1=""; print $0}' | sed 's/\"//g'`
	# if this value is not set, take the default one
	if [ -z "$RET" ]; then
		RET=`cat $ECC | grep $1 -A 10 | grep 'Default' | head -1 | awk '{$1=$2=$3=""; print $0}' | sed 's/\"//g'`
	fi
	echo $RET
}


function usage {
        echo "Usage: `basename $0` --config=<config-name> (--output-filename=<filename>|--tests|--rebuild)"
        echo "       Use a config with FILES='' to just generate a kernel"
}

TESTS=false
REBUILD=false

for i in "$@"
do
get_option $i
case $i in
    -c=*|--config=*)
        CONFIG=$VALUE
        ;;
    -o=*|--output-filename=*)
        OUTPUT_FILENAME=$VALUE    
        ;;
    -t|--tests)
        TESTS=true
        ;;
    -r|--rebuild)
        REBUILD=true
	;;
    *)
        echo "FATAL: You have provided an unknown option: $i."
	usage
        exit 1
esac
done

if [ -z $CONFIG ]
then
	echo "FATAL: No config file provided."
	usage
	exit 1
fi

CONFIG_FILE=$CONFIG.config

if [ ! -e $CONFIG_FILE ]
then
	echo "FATAL: The config file \"$CONFIG_FILE\" does not exist."
	exit 1
fi

TPATH_FILE=$CONFIG.tpath

if [ -e $TPATH_FILE ]
then
	# include the toolchain path file, if it exits
	export PATH="`cat $TPATH_FILE`:$PATH"
fi

# include config file to set appropriate variables
. ./$CONFIG_FILE

ECOS_REPOSITORY=`readlink -f $ECOS_REPOSITORY`
ECC=`readlink -f $ECC`

if [ -z $ECOS_REPOSITORY ] || [ -z $ECC ]
then
	echo "FATAL: The variables \"ECOS_REPOSITORY\" AND \"ECC\" have not been set properly."
	exit 1
fi

GCC=`ecc_get_value CYGBLD_GLOBAL_COMMAND_PREFIX`-gcc
CFLAGS=`ecc_get_value CYGBLD_GLOBAL_CFLAGS`

# check for compiler
command -v $GCC >/dev/null 2>&1 || { echo >&2 "FATAL: The required compiler ($GCC) does not exist in your PATH. Did you forget an appropriate $CONFIG.tpath file?"; exit 1; }

mkdir -p $CONFIG\_build
if $REBUILD ; then
  rm -rf $CONFIG\_build/*
fi
cd $CONFIG\_build
KPATH=`pwd`

ecosconfig --config=$ECC tree
if $TESTS ; then
   make tests
   exit
else
   make
fi

cd ..

if [ ! -z "$FILES" ]
then
   if [ -z $OUTPUT_FILENAME ] ; then
      OUTPUT_FILENAME=$CONFIG
   fi
   
echo "Compiling eCos application..."
$GCC -g -I./ -g -I${KPATH}/install/include ${FILES} \
   	-L${KPATH}/install/lib -Ttarget.ld ${CFLAGS} ${ADD_OPT} -nostdlib -o $OUTPUT_FILENAME
fi
