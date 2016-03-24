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
GCC_GMP_VERSION="6.1.0"
GCC_MPFR_VERSION="3.1.4"
GCC_MPC_VERSION="1.0.3"
GCC_ISL_VERSION="0.16.1"
AVRLIBC_VERSION="2.0.0"
AVRDUDE_VERSION="6.3"
# Files
BINUTILS_FILE="binutils-$BINUTILS_VERSION.tar.gz"
GCC_FILE="gcc-$GCC_VERSION.tar.gz"
GCC_GMP_FILE="gmp-$GCC_GMP_VERSION.tar.lz"
GCC_MPFR_FILE="mpfr-$GCC_MPFR_VERSION.tar.xz"
GCC_MPC_FILE="mpc-$GCC_MPC_VERSION.tar.gz"
GCC_ISL_FILE="isl-$GCC_ISL_VERSION.tar.gz"
AVRLIBC_FILE="avr-libc-$AVRLIBC_VERSION.tar.bz2"
AVRDUDE_FILE="avrdude-$AVRDUDE_VERSION.tar.gz"
# Download urls
BINUTILS_URL="http://ftp.gnu.org/gnu/binutils/$BINUTILS_FILE"
GCC_URL="ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-$GCC_VERSION/$GCC_FILE"
GCC_GMP_URL="https://gmplib.org/download/gmp/$GCC_GMP_FILE"
GCC_MPFR_URL="http://www.mpfr.org/mpfr-current/$GCC_MPFR_FILE"
GCC_MPC_URL="ftp://ftp.gnu.org/gnu/mpc/$GCC_MPC_FILE"
GCC_ISL_URL="http://isl.gforge.inria.fr/$GCC_ISL_FILE"
AVRLIBC_URL="http://download.savannah.gnu.org/releases/avr-libc/$AVRLIBC_FILE" 
AVRDUDE_URL="http://download.savannah.gnu.org/releases/avrdude/$AVRDUDE_FILE"
# PATH variables
PREFIX=`pwd`/toolchain
SOURCES=`pwd`/.avr-src
PATH=$PATH:$PREFIX/bin
export PATH
# Program variables
WGET_CMD="--quiet"
BINUTILS_CONFIG="--prefix=$PREFIX --target=avr --disable-nls"
GCC_CONFIG="--prefix=$PREFIX --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --with-dwarf2"
AVRLIBC_CONFIG="--prefix=$PREFIX --host=avr"
AVRDUDE_CONFIG="--prefix=$PREFIX"
# Functions
function build_binutils() {
	OLD_PWD=`pwd`
	
	printf "Building binutils\n"

	cd $SOURCES
	if [ ! -f "$BINUTILS_FILE" ]; then
		printf "\tDownloading %s\n" "$BINUTILS_FILE"
		wget $WGET_CMD $BINUTILS_URL
	fi

	if [ -d "binutils-$BINUTILS_VERSION" ]; then
		printf "\tRemoving old extracted\n"
		rm -rf binutils-$BINUTILS_VERSION
	fi

	printf "\tExtracting %s\n" "$BINUTILS_FILE"
	tar xf $BINUTILS_FILE

	if [ -d "obj-binutils" ]; then
		printf "\tRemoving old compile directory\n"
		rm -rf obj-binutils
	fi

	printf "\tCreating compile directory\n"
	mkdir obj-binutils
	cd obj-binutils
	
	printf "\tConfigure binutils\n"
	../binutils-$BINUTILS_VERSION/configure $BINUTILS_CONFIG	
	printf "\tCompiling binutils\n"
	make
	printf "\tInstalling binutils\n"
	make install
	printf "\tCleaning up after binutils\n"
	rm -rf obj-binutils binutils-$BINUTILS_VERSION $BINUTILS_FILE
		
	cd $OLD_PWD
}

function build_gcc() {
	OLD_PWD=`pwd`
	
	cd $SOURCES
	
	printf "Building avr-gcc\n"

	if [ ! -f $GCC_FILE ]; then
		printf "\tDownloading %s\n" "$GCC_FILE"
		wget $WGET_CMD $GCC_URL
	fi

	if [ ! -f $GCC_GMP_FILE ]; then
		printf "\tDownloading %s\n" "$GCC_GMP_FILE"
		wget $WGET_CMD $GCC_GMP_URL
	fi

	if [ ! -f $GCC_MPFR_FILE ]; then
		printf "\tDownloading %s\n" "$GCC_MPFR_FILE"
		wget $WGET_CMD $GCC_MPFR_URL
	fi

	if [ ! -f $GCC_MPC_FILE ]; then
		printf "\tDownloading %s\n" "$GCC_MPC_FILE"
		wget $WGET_CMD $GCC_MPC_URL
	fi

	if [ ! -f $GCC_ISL_FILE ]; then
		printf "\tDownloading %s\n" "$GCC_ISL_FILE"
		wget $WGET_CMD $GCC_ISL_URL
	fi
	if [ -d "gcc-$GCC_VERSION" ]; then
		printf "\tRemoving old extracted gcc\n"
		rm -rf gcc-$GCC_VERSION
	fi

	printf "\tExtracting %s\n" "$GCC_FILE"
	tar xf $GCC_FILE
	printf "\tExtracting %s\n" "$GCC_GMP_FILE"
	tar xf $GCC_GMP_FILE
	printf "\tExtracting %s\n" "$GCC_MPFR_FILE"
	tar xf $GCC_MPFR_FILE
	printf "\tExtracting %s\n" "$GCC_MPC_FILE"
	tar xf $GCC_MPC_FILE
	printf "\tExtracting %s\n" "$GCC_ISL_FILE"
	tar xf $GCC_ISL_FILE
	
	printf "\tmoving GMP into gcc directory\n"
	mv gmp-$GCC_GMP_VERSION gcc-$GCC_VERSION/gmp

	printf "\tmoving MPFR into gcc directory\n"
	mv mpfr-$GCC_MPFR_VERSION gcc-$GCC_VERSION/mpfr

	printf "\tmoving MPC into gcc directory\n"
	mv mpc-$GCC_MPC_VERSION gcc-$GCC_VERSION/mpc

	printf "\tmoving ISL into gcc directory\n"
	mv isl-$GCC_ISL_VERSION gcc-$GCC_VERSION/isl

	if [ -d "obj-gcc" ]; then
		printf "\tRemoving old object directory\n"
		rm -rf obj-gcc
	fi
	mkdir obj-gcc
	cd obj-gcc

	../gcc-$GCC_VERSION/configure $GCC_CONFIG
	make
	make install

	cd $SOURCES
	rm -rf obj-gcc gcc-$GCC_VERSION $GCC_FILE $GCC_GMP_FILE $GCC_MPFR_FILE $GCC_MPC_FILE $GCC_ISL_FILE	

	cd $OLD_PWD
}
# Main program
#build_binutils
build_gcc
