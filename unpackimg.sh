#!/usr/bin/env sh

. "$(dirname $0)/bin/archdetect.sh"

LOCALDIR=`pwd`
BINPATH="$(dirname $0)/bin/$(ostype)/$(osarch)"
PATH="${BINPATH}:${PATH}"

echo $PATH

cpio="$(realpath ${BINPATH})/cpio"

if [ "$OS" = "Windows_NT" ]; then
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
  echo "    $0 [FILE]"
  echo "        -h  print this usage"
}


main() {
  if [ "$1" = "" ] ;then Usage && exit 0 ;fi
  if [ "$1" = "-h" ] ;then  Usage && exit 0 ;fi

  if [ -f "$1" ] ;then
    Detials
    echo Extracting file "$1" at current dir...
    # cleanup before unpack
    magiskboot cleanup 2>&1
    magiskboot unpack -h "$1" 2>&1
    echo -e "Img Type : "
    if [ "$?" = "0" ]; then
    echo "Valid"
    elif [ "$?" = "2" ]; then
    echo "Chromeos"
    else
    echo "Error"
    exit /b 1
    fi
  fi

  if [ -f "ramdisk.cpio" ]; then
    chmod 0755 "ramdisk.cpio"
    ramdiskpath="$(realpath ./ramdisk.cpio)"
    if [ -d "ramdisk" ]; then rm -rf ramdisk ;fi
    echo "Extracting ramdisk folder..."
    mkdir "ramdisk" && cd "ramdisk"
    magiskboot cpio "${ramdiskpath}" extract 2>&1
	if [ -d ".backup" ]; then "${sudo}" chmod -R 0755 ".backup";fi
    cd "${LOCALDIR}"
  fi

  exit 0
}

main $@