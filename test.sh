#!/bin/bash

depends="binutils gcc acy"

for package in ${depends[@]}
do
	echo $package t_packages/$package.package
	if [ -f t_packages/$package.package ]; then
		echo "  Can be resolved"
		if [ -f .avr-toolchain/.stamp-${package} ]; then
			unset installed
			echo "    .stamp found"
			source .avr-toolchain/.stamp-${package}
			echo "    installed: ${installed}"
			source t_packages/${package}.package
			if [ "${installed}" == "${version}" ]; then
				echo "     Same version installed as in package"
			elif [ "${version//./}" -gt "${installed//./}" ]; then
				echo "    Installed version is less than the one in package manager"
				echo "    PkgM version ${version} | Installed : ${installed}"
			else 
				echo "     Not the same version. Version : ${version} Installed : ${installed}"
			fi

		fi
	else
		echo "  Can not be resolved"
		break
	fi
done
