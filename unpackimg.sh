#!/usr/bin/env sh

. "$(dirname $0)/bin/archdetect.sh"
. "$(dirname $0)/bin/list.sh"

if [ "$(osarch)" = "Unknow" ]; then
  echo "Arch $(uname -m) does not support on this script ..."
  exit 1
fi

LOCALDIR=`pwd`
BINPATH="$(realpath $(dirname $0)/bin/$(ostype)/$(osarch))"
PATH="${BINPATH}:${PATH}"

cpio="$(realpath ${BINPATH})/cpio"
alias ifvndrboot="$(realpath ${BINPATH})/ifvndrboot"
alias format="$(realpath ${BINPATH})/format"

if [ "$OS" = "Windows_NT" ]; then
  alias sudo=""
# on Android device the Var "$OSTYPE"=""
elif [ "$OSTYPE" = "" ]; then
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
  echo "    $0 [FILE]"
  echo "        -h  print this usage"
}

vendorbootWarning() {
	echo "######################################"
	echo "Warning : vendor boot image detected..."
	echo "######################################"
}

main() {
  if [ "$1" = "" ] ;then Usage && exit 0 ;fi
  if [ "$1" = "-h" ] ;then  Usage && exit 0 ;fi

  if [ -f "$1" ] ;then
    Detials
    echo Extracting file "$1" at current dir...
	ifvndrboot "$1" && vendorbootWarning && vendorboot=1
    # cleanup before unpack
    magiskboot cleanup 2>&1
    magiskboot unpack -h "$1" 2>&1
	if [ "$?" = "1" ]; then
		echo "Unsupport boot image..."
		exit 1
	fi
	if [ -d "split_img" ]; then rm -rf "split_img"; fi
	mkdir "split_img"
	for i in $split_img
	do
		if [ -f "$i" ]; then
			mv "$i" "split_img/$i"
		fi
	done
	if [ "$vendorboot" = "1" ]; then
		r_fmt="$(format ./ramdisk.cpio)"
		echo "Detect cpio format : ${r_fmt}"
		printf "${r_fmt}" > "ramdisk_compress_type"
		if [ ! "$r_fmt" = "raw" ]; then
			magiskboot decompress "ramdisk.cpio" "ramdisk.cpio.dec"
			rm -f "ramdisk.cpio"
			mv "ramdisk.cpio.dec" "ramdisk.cpio"
		fi
	fi
    echo -e "Img Type : "
    if [ "$?" = "0" ]; then
    echo "Valid"
    elif [ "$?" = "2" ]; then
    echo "Chromeos"
    else
    echo "Error"
    exit 1
    fi
  fi

  if [ -f "split_img/ramdisk.cpio" ]; then
    chmod 0755 "split_img/ramdisk.cpio"
    if [ -d "ramdisk" ]; then rm -rf ramdisk ;fi
    echo "Extracting ramdisk folder..."
    mkdir "ramdisk" && cd "ramdisk"
    ${sudo} ${sudoarg} "${cpio}" -iv -I "../split_img/ramdisk.cpio" 2>&1
	if [ -d ".backup" ]; then "${sudo}" chmod -R 0755 ".backup";fi
    cd "${LOCALDIR}"
  fi

  exit 0
}

main $@
