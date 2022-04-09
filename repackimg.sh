#!/usr/bin/env sh

. "$(dirname $0)/bin/archdetect.sh"

LOCALDIR=`pwd`
BINPATH="$(realpath $(dirname $0)/bin/$(ostype)/$(osarch))"
PATH="${BINPATH}:${PATH}"

cpio="$(realpath ${BINPATH})/cpio"

if [ "$OS" = "Windows_NT" ]; then
  alias sudo=""
  alias find="$(realpath ${BINPATH})/find"
fi

# on Android device the Var "$OSTYPE"=""
if [ "$OSTYPE" = "" ]; then
  if [ ! "$(whoami)" = "root" ]; then
    echo Script need run on root ...
	exit 1
  fi
  alias sudo=""
fi

Detials() {
  echo "Based on magiskboot and cpio"
  echo "Script by affggh"
  echo "binary file magiskboot by affggh"
  echo "binary file cpio by affggh"
  echo "binary file busybox from cygwin"
  echo "This script only support x86_64 env"
  #echo $PATH
}

Usage() {
  echo "Usage:"
  echo "    $0 [ORIGBOOT] [DIR]"
  echo "        -h  print this usage"
}

main() {
  if [ "$1" = "" ] ;then Usage && exit 0 ;fi
  if [ "$1" = "-h" ] ;then  Usage && exit 0 ;fi
  
  if [ ! -f "$1" ]; then echo "File not exist..." && exit 0;fi
  if [ -d "$2" ]; then dirpath="$(realpath $2)" ;fi
  echo ${dirpath}
  cd "${dirpath}"
  echo "Repacking boot image..."
  echo "Repacking ramdisk..."
  if [ -d "${dirpath}/ramdisk" ]; then
	rm -f "ramdisk.cpio"
    cd "${dirpath}/ramdisk"
	# prefix some issues
	#if [ -d "./ramdisk/.backup" ]; then chmod -R 0755 "./ramdisk/.backup";fi
	sudo find | sudo "${cpio}" -H newc -ov > "${dirpath}/ramdisk.cpio"
	cd "${dirpath}"
	magiskboot repack "$1"
  fi
}

main $@
  