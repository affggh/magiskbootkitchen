#!/usr/bin/env sh

. "$(dirname $0)/bin/archdetect.sh"

if [ "$(osarch)" = "Unknow" ]; then
  echo "Arch $(uname -m) does not support on this script ..."
  exit 1
fi

LOCALDIR=`pwd`
BINPATH="$(realpath $(dirname $0)/bin/$(ostype)/$(osarch))"
PATH="${BINPATH}:${PATH}"

# on Android device the Var "$OSTYPE"=""
if [ "$OSTYPE" = "" ] && [ ! "$OS" = "Windows_NT" ]; then
  if [ ! "$(whoami)" = "root" ]; then
    echo Script need run on root ...
	exit 1
  fi
  alias sudo=""
fi

magiskboot cleanup 2>&1
if [ -d "ramdisk" ]; then rm -rf ramdisk ;fi
if [ -d "split_img" ]; then rm -rf split_img ;fi
if [ -f "ramdisk_compress_type" ]; then rm -f "ramdisk_compress_type"; fi
exit 0

