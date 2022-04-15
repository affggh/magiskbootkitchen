# source from magiskboot.hpp
HEADER_FILE="header"
KERNEL_FILE="kernel"
RAMDISK_FILE="ramdisk.cpio"
SECOND_FILE="second"
EXTRA_FILE="extra"
KER_DTB_FILE="kernel_dtb"
RECV_DTBO_FILE="recovery_dtbo"
DTB_FILE="dtb"
NEW_BOOT="new-boot.img"

split_img="
	$HEADER_FILE
	$KERNEL_FILE
	$KER_DTB_FILE
	$RAMDISK_FILE
	$SECOND_FILE
	$EXTRA_FILE
	$KER_DTB_FILE
	$RECV_DTBO_FILE
	$DTB_FILE
"