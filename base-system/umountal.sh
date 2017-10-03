#!/bin/bash

export LFS=/mnt/lfs

umount $LFS/boot/efi &> /dev/null
umount $LFS/sys/firmware/efi/efivars &> /dev/null
umount $LFS/dev/pts &> /dev/null
umount $LFS/dev &> /dev/null
umount $LFS/sys &> /dev/null
umount $LFS/proc &> /dev/null
umount $LFS/run &> /dev/null
umount $LFS/home &> /dev/null
umount $LFS &> /dev/null

exit 0
