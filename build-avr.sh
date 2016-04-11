#!/bin/bash
#	Author:		Michael Kaalund
#	Program:	This script downloads and builds
#			avr-libc, avr-gcc, avrdude and
#			other.
#			This will install the toolchain
#			in a local directory which the
#			makefiles will reference to.

# isFunc name_of_function
# returns 0 or 1
# Checks if function exists
isFunc() { 
	if type -t $1 > /dev/null; then
		return 0
	else
		return 1
	fi
}

## Loading configurations file
printf "Checking there is a configurations file\n"
if [ -f "./avr-tools-build.conf" ]; then
	printf "Using configuration file in current directory\n"
	source ./avr-tools-build.conf
else
	printf "No configurations files found in search directories.\n"
	printf "Using fall back config\n"
	main_directory=`pwd`
	sources_directory=${main_directory}/.avr-sources
	install_directory=${main_directroy}/.avr-toolchain
	package_directory=${main_directory}/packages
fi

# PATH variables
PREFIX=${install_directory}
SOURCES=${sources_directory}
PATH=$PREFIX/bin:$PATH

if [ ! `grep -q "PATH=$PATH" "$HOME/.profile"` ]; then
	export PATH
	printf "Adding path environment variable to $HOME/.profile\n"
	echo "PATH=$PATH" >> $HOME/.profile
fi

if [ ! -d $SOURCES ]; then
	mkdir -pv $SOURCES
fi

if [ ! -d $PREFIX ]; then
	mkdir -pv $PREFIX
fi

main() {
	for package in `ls ${package_directory}`
	do
		#first we need to unset the variables
		unset version
		unset compress
		unset file
		unset url
		unset config
		unset build_dir
		printf "\tSourcing %s\n" "$package"
		source ${package_directory}/$package
		printf "\t\tversion: %s\n" "$version"
		printf "\t\tfile: %s.%s\n" "$file" "$compress"
		printf "\t\turl: %s\n" "$url"
		printf "\t\tconfig: %s\n" "$config"
		printf "\t\tbuild dir: %s\n" "$build_dir"

		if [ ! -f $PREFIX/.stamp-$file ]; then
			## first we need to download the file
#			custom_download=`isFunc do_download`
			if isFunc do_download; then
				printf "\t\tPackage has custom download function\n"
				do_download
			else
				printf "\t\tPackage using default download function\n"
				def_download "$url" "$file" "$compress"
			fi
#			unset custom_download

#			custom_config=`isFunc do_config`
			if isFunc do_config; then
				printf "\t\tPackage has custom config function\n"
				do_config
			else
				printf "\t\tPackage using default config function\n"
				def_config "$file" "$config" "$build_dir"
			fi
#			unset custom_config

#			custom_build=`isFunc do_build`
			if isFunc do_build; then
				printf "\t\tPackage has custom build function\n"
				do_build
			else
				printf "\t\tPackage using default build function\n"
				def_build "$file" "$build_dir"
			fi
#			unset custom_build

#			custom_install=`isFunc do_install`
			if isFunc do_install; then
				printf "\t\tPackage has custom install function\n"
				do_install
			else
				printf "\t\tPackage using default install function\n"
				def_install "$file" "$build_dir"
			fi			
#			unset custom_install
		else
			printf "\t\tPackage already installed\n"
		fi
	done
}

def_download() {
	pushd $SOURCES
	
	file=$2
	compress=$3
	url=$1

	if [ ! -f "$file.$compress" ]; then
		printf "\tfile: %s\n\tDownloading: " "$url"
	
		wget --quiet $1
		if [ -f "$file.$compress" ]; then
			printf "DONE\n"
		else
			printf "FAILED\n"
			return 1
		fi
	else
		printf "\tfile: %s\nExists using old sources\n" "$file.$compress"
	fi
	printf "Extracting %s\n" "$file.$compress"
	tar xf "$file.$compress"
	# Returns to execute directory
	popd

	return 0
}

def_config() {
	file=$1
	config=$2
	build_dir=$3

	pushd $SOURCES/$file
	if [ "$build_dir"="yes" ]; then
		mkdir build
		pushd build
		
		../configure $config

		popd
	else
		./configure $config
	fi

	popd
}

def_build() {
	file=$1
	build_dir=$2

	pushd $SOURCES/$file
	
	if [ "$build_dir"="yes" ]; then
		pushd build

		make

		popd
	else
		make
	fi

	popd
}

def_install() {
	file=$1
	build_dir=$2

	pushd $SOURCES/$file

	if [ "$build_dir"="yes" ]; then
		pushd build

		make install
		
		popd
	else
		make install
	fi

	touch $PREFIX/.stamp-$file

	popd
}

printf "Done with this\n"
main
