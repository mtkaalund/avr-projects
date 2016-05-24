#!/bin/bash

depends="binutils gcc acy"

for package in ${depends}
do
	echo $package
	if [ -f packages/$package.package ]; then
		echo "  Can be resolved"
	else
		echo "  Can not be resolved"
		break
	fi
done
