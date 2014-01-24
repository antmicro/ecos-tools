#!/bin/bash

TOOLS_PATH=$(dirname $(readlink -f $0))

function get_option {
    VALUE=`echo $1 | sed 's/[-a-zA-Z0-9]*=//'`
}

function ecc_get_value {
    echo `cat $ECC | grep $1 -A 100 | grep user_value | head -1 | sed 's,user_value,|,g' | cut -f 2 -d '|' | tr -d '"'`
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

# include config file to set appropriate variables
. ./$CONFIG_FILE

if [ -z $ECOS_REPOSITORY ] || [ -z $ECC ]
then
	echo "FATAL: The variables \"ECOS_REPOSITORY\" AND \"ECC\" have not been set properly."
	exit 1
fi

ECOS_REPOSITORY=`readlink -f $ECOS_REPOSITORY`
ECC=`readlink -f $ECC`

GCC=`ecc_get_value CYGBLD_GLOBAL_COMMAND_PREFIX`-gcc
CFLAGS=`ecc_get_value CYGBLD_GLOBAL_CFLAGS`

mkdir -p $CONFIG\_build
if $REBUILD ; then
  rm -rf $CONFIG\_build/*
fi
cd $CONFIG\_build
KPATH=`pwd`

$TOOLS_PATH/ecosconfig --config=$ECC tree
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
PATH="${TOOLS_PATH}:$PATH" $GCC -g -I./ -g -I${KPATH}/install/include ${FILES} \
   	-L${KPATH}/install/lib -Ttarget.ld ${CFLAGS} ${ADD_OPT} -nostdlib -o $OUTPUT_FILENAME
fi
