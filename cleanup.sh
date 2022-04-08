#!/usr/bin/env sh

. "$(dirname $0)/bin/archdetect.sh"

LOCALDIR=`pwd`
BINPATH="$(dirname $0)/bin/$(ostype)/$(osarch)"
PATH="${BINPATH}:${PATH}"

magiskboot cleanup 2>&1
if [ -d "ramdisk" ]; then rm -rf ramdisk ;fi
exit 0

