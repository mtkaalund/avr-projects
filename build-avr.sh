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
PREFIX=`pwd`/.toolchain
SOURCES=`pwd`/.avr-src
PATH=$PREFIX/bin:$PATH
export PATH
# Program variables
WGET_CMD="--quiet"
BINUTILS_CONFIG="--prefix=$PREFIX --target=avr --disable-nls --enable-ld=default --enable-gold --enable-plugins --enable-threads --with-pic --enable-shared --disable-werror --disable-multilib"
GCC_CONFIG="--prefix=$PREFIX --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --with-dwarf2 --disable-install-libiberty --disable-libstdcxx-pch --disable-libunwind-exceptions --disable-linker-build-id --disable-werror --enable-__cxa_atexit --enable-checking=release --enable-clocale=gnu --enable-gnu-unique-object --enable-gold --enable-ld=default --enable-lto --enable-plugin --enable-shared --with-gnu-as --with-gnu-ld --with-system-zlib --with-isl --enable-gnu-indirect-function" #--with-avrlib"
AVRLIBC_CONFIG="--prefix=$PREFIX --host=avr"
AVRDUDE_CONFIG="--prefix=$PREFIX"
# Functions
function build_binutils() {
	OLD_PWD=`pwd`
	
	if [ ! -d "$SOURCES" ]; then
		mkdir -p $SOURCES
	fi

	cd $SOURCES

	printf "Building binutils\n"

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
	../binutils-$BINUTILS_VERSION/configure $BINUTILS_CONFIG --build=`./config.guess`
	printf "\trunning configure-host\n"
	make configure-host
	printf "\tmake tooldir\n"
	make tooldir=$PREFIX
	printf "\tInstalling binutils\n"
	make prefix=$PREFIX tooldir=$PREFIX install
	printf "\tCleaning up after binutils\n"

	for bin in ar as nm objcopy objdump ranlib strip readelf; do
		rm -f $PREFIX/bin/${bin}
	done

	for info in as bfd binutils gprof ld; do
		mv $PREFIX/share/info/${info}.info $PREFIX/share/info/avr-${info}.info
	done

	rm -r $PREFIX/share/locale

	rm -rf obj-binutils binutils-$BINUTILS_VERSION $BINUTILS_FILE
		
	cd $OLD_PWD
}

function build_gcc() {
	OLD_PWD=`pwd`

	if [ ! -d "$SOURCES" ]; then
		mkdir -p $SOURCES
	fi
	
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

	echo ${GCC_VERSION} > gcc-$GCC_VERSION/BASE-VER

	if [ -d "obj-gcc" ]; then
		printf "\tRemoving old object directory\n"
		rm -rf obj-gcc
	fi
	mkdir obj-gcc
	cd obj-gcc

	printf "\tConfigure gcc\n"
	../gcc-$GCC_VERSION/configure $GCC_CONFIG
	printf "\tCompiling gcc\n"
	make
	printf "\tInstalling gcc\n"
	make install

	cd $SOURCES
	printf "\tCleaning up after gcc\n"
	rm -rf obj-gcc gcc-$GCC_VERSION $GCC_FILE $GCC_GMP_FILE $GCC_MPFR_FILE $GCC_MPC_FILE $GCC_ISL_FILE	

	cd $OLD_PWD
}

function build_avrlibc() {
	OLD_PWD=`pwd`
	OLD_CC="$CC"
	unset CC

	printf "PATH variable: %s\n" $PATH
	if [ ! -d "$SOURCES" ]; then
		mkdir -p $SOURCES
	fi
	
	cd $SOURCES

	printf "Building avr-libc\n"

	if [ ! -f "$AVRLIBC_FILE" ]; then
		printf "\tDownloading %s\n" "$AVRLIBC_FILE"
		wget $WGET_CMD $AVRLIBC_URL
	fi

	if [ -d "avr-libc-$AVRLIBC_VERSION" ]; then
		printf "\tRemoving old extracted\n"
		rm -rf avr-libc-$AVRLIBC_VERSION
	fi

	printf "\tExtracting %s\n" "$AVRLIBC_FILE"
	tar xf $AVRLIBC_FILE

	printf "\tConfigure avr-libc\n"
	cd avr-libc-$AVRLIBC_VERSION
	./bootstrap
	./configure $AVRLIBC_CONFIG --build=`./config.guess`
	
	printf "\tCompiling avr-libc\n"
	make

	printf "\tInstalling avr-libc\n"
	make install

	printf "\tCleaning up after avr-libc\n"
	rm -rf avr-libc-$AVRLIBC_VERSION $AVRLIBC_FILE

	CC=$OLD_CC
	cd $OLD_PWD
}
# Main program

build_binutils
build_gcc
build_avrlibc

# Clean up
rm -rf $SOURCES
