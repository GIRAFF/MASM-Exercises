#!/bin/bash

if [ $# -lt 1 ] ; then
	echo "Usage: $0 name_without_ext"
	exit 1
fi
	
jwasm -coff $1.asm
jwlink format windows pe file $1.o, libs/kernel32.Lib, libs/User32.Lib
