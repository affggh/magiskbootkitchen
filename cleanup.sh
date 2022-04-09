#!/usr/bin/env sh

. "$(dirname $0)/bin/archdetect.sh"

LOCALDIR=`pwd`
BINPATH="$(realpath $(dirname $0)/bin/$(ostype)/$(osarch))"
PATH="${BINPATH}:${PATH}"

# on Android device the Var "$OSTYPE"=""
if [ "$OSTYPE" = "" ]; then
  if [ ! "$(whoami)" = "root" ]; then
    echo Script need run on root ...
	exit 1
  fi
  alias sudo=""
fi

magiskboot cleanup 2>&1
if [ -d "ramdisk" ]; then rm -rf ramdisk ;fi
exit 0

