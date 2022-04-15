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
  alias find="$(realpath ${BINPATH})/find"
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
  echo "    $0 [ORIGBOOT] [DIR]"
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
  imgpath="$(realpath $1)"
  if [ ! -f "$1" ]; then echo "File not exist..." && exit 0;fi
  if [ -d "$2" ]; then dirpath="$(realpath $2)" ;fi
  echo ${dirpath}
  cd "${dirpath}"
  echo "Repacking boot image..."
  if [ ! -d "split_img" ]; then
	echo "Split file does not found..."
	echo "Please unpack first..."
	exit 1
  fi
  ifvndrboot "$imgpath" && vendorbootWarning && vendorboot=1
  echo "Repacking ramdisk..."
  if [ -d "${dirpath}/ramdisk" ]; then
	rm -f "ramdisk.cpio"
    cd "${dirpath}/ramdisk"
	# prefix some issues
	#if [ -d "./ramdisk/.backup" ]; then chmod -R 0755 "./ramdisk/.backup";fi
	sudo find | sed 1d | sudo "${cpio}" -o > "${dirpath}/split_img/ramdisk.cpio"
	cd "${dirpath}"
  if [ "$vendorboot" = "1" ]; then
    if [ -f 'ramdisk_compress_type' ]; then
	  r_fmt="$(cat 'ramdisk_compress_type')"
	  if [ ! "$r_fmt" = "raw" ]; then
	    echo "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	    magiskboot compress=$r_fmt "ramdisk.cpio" "ramdisk.cpio.comp"
		rm -f "ramdisk.cpio"
		mv "ramdisk.cpio.comp" "split_img/ramdisk.cpio"
	  fi
	fi
  fi
    if [ -d "split_img" ]; then
		for i in $split_img
		do
			if [ -f "split_img/$i" ]; then
				cp "split_img/$i" "$i"
			fi
		done
	fi
	magiskboot repack "$imgpath"
	magiskboot cleanup 2>&1
  fi
}

main $@
  
