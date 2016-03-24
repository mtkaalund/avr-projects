#!/bin/bash
#	Author:		Michael Kaalund
#	Program:	This script downloads and builds
#			avr-libc, avr-gcc, avrdude and
#			other.
#			This will install the toolchain
#			in a local directory which the
#			makefiles will reference to.
BINUTILS_VERSION="2.26"
GCC_VERSION="5.3.0"
AVRLIBC_VERSION="2.0.0"
AVRDUDE_VERSION="6.3"
# Files
BINUTILS_FILE="binutils-$BINUTILS_VERSION.tar.gz"
GCC_FILE="gcc-$GCC_VERSION.tar.gz"
AVRLIBC_FILE="avr-libc-$AVRLIBC_VERSION.tar.bz2"
AVRDUDE_FILE="avrdude-$AVRDUDE_VERSION.tar.gz"
declare -a FILE_LOCAL=("$BINUTILS_FILE" "$GCC_FILE" "$AVRLIBC_FILE" "$AVRDUDE_FILE")

# Download urls
declare -a FILE_URLS=("http://ftp.gnu.org/gnu/binutils/$BINUTILS_FILE" "ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-$GCC_VERSION/$GCC_FILE" "http://download.savannah.gnu.org/releases/avr-libc/$AVRLIBC_FILE" "http://download.savannah.gnu.org/releases/avrdude/$AVRDUDE_FILE")
# PATH variables
PREFIX=`pwd`/toolchain
SOURCES=`pwd`/.avr-src
# Program variables
WGET_CMD="--quiet"
BINUTILS_CONFIG="--prefix=$PREFIX --target=avr --disable-nls"
GCC_CONFIG="--prefix=$PREFIX --target=avr --enable-languages=c,c++ --disable-nls"
AVRLIBC_CONFIG="--prefix=$PREFIX --host=avr"
AVRDUDE_CONFIG="--prefix=$PREFIX"
# Functions
function download_sources() {
	if [ ! -d "$SOURCES" ]; then
		mkdir -p $SOURCES
	fi

	OLD_PWD=`pwd`

	cd $SOURCES

	echo "Downloading sources"

	array_max=${#FILE_LOCAL[*]}

	for (( i=0; i<=$(( $array_max -1 )); i++ ))
	do
		echo "${FILE_LOCAL[$i]} ${FILE_URLS[$i]}"
	done


	cd $OLD_PWD
}

# Main program
download_sources()
