#!/bin/bash

if [ $# -lt 1 ] ; then
	echo "Usage: $0 name_without_ext"
	exit 1
fi

iconv -f utf-8 -t cp1251 "$1.asm" -o "$1.cp1251.asm"
jwasm -coff "$1.cp1251.asm"
jwlink format windows pe file $1.cp1251.o, libs/kernel32.Lib, libs/User32.Lib
