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
isFunc() { declare -Ff "$1" >/dev/null; }

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
export PATH
printf "Adding path environment variable to $HOME/.profile\n"
echo "PATH=$PATH" >> $HOME/.profile

main() {
	for package in `ls ${package_directory}`
	do
		#first we need to unset the variables
		unset version
		unset compress
		unset file
		unset url
		unset config
		printf "\tSourcing %s\n" "$package"
		source ${package_directory}/$package
		printf "\t\tversion: %s\n" "$version"
		printf "\t\tfile: %s.%s\n" "$file" "$compress"
		printf "\t\turl: %s\n" "$url"
		printf "\t\tconfig: %s\n" "$config"
	done
}

printf "Done with this\n"
main
