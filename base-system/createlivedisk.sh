#!/bin/bash

./umountal.sh

LFS=/mnt/lfs
mkdir -pv $LFS

./umountal.sh

. ./build-properties

set -e

if [ $# -ne 0 ]
then

for i in "$@"
do
case $i in
    -r=*|--root-partition=*)
    ROOT_PART="${i#*=}"
    shift # past argument=value
    ;;
    -h=*|--home-partition=*)
    HOME_PART="${i#*=}"
    shift # past argument=value
    ;;
    -l=*|--label=*)
    LABEL="${i#*=}"
    shift # past argument=value
    ;;
    -o=*|--output=*)
    OUTFILE="${i#*=}"
    shift # past argument=value
    ;;
    -u=*|--default-user=*)
    USERNAME="${i#*=}"
    shift # past argument=value
    ;;
    -s=*|--create-squashedfs=*)
    CREATE_ROOTSFS="${i#*=}"
    shift # past argument=value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument with no value
    ;;
    *)
            # unknown option
    ;;
esac
done

else

if [ "x$INSTALL_DESKTOP_ENVIRONMENT" == "xy" ]; then
	if [ "x$DESKTOP_ENVIRONMENT" == "x1" ]; then
		DE="XFCE"
	elif [ "x$DESKTOP_ENVIRONMENT" == "x2" ]; then
		DE="Mate";
	elif [ "x$DESKTOP_ENVIRONMENT" == "x3" ]; then
		DE="KDE5"
	elif [ "x$DESKTOP_ENVIRONMENT" == "x4" ]; then
		DE="GNOME"
	else
		DE="Builder"
	fi
	LABEL="$OS_NAME $DE $OS_VERSION"
else
	LABEL="OS_NAME $OS_VERSION"
fi

if [ "x$DE" != "x" ]
then
	OUTFILE="$(echo $OS_NAME | tr '[:upper:]' [:lower:])-$(echo $DE | tr '[:upper:]' '[:lower:]')-$OS_VERSION-$(uname -m).iso"
else
	OUTFILE="$(echo $OS_NAME | tr '[:upper:]' [:lower:])-$OS_VERSION-$(uname -m).iso"
fi

CREATE_ROOTSFS="y"

fi

mount $ROOT_PART $LFS
if [ "x$HOME_PART" != "x" ]
then
	mount $HOME_PART $LFS/home
fi

mount -v --bind /dev $LFS/dev

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

cp -v make-efibootimg.sh $LFS/sources/
cp -v mkliveinitramfs.sh $LFS/sources/
cp -v init.sh $LFS/sources/

chmod a+x $LFS/sources/*.sh

if [ `uname -m` == "x86_64" ]
then

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash /sources/make-efibootimg.sh "$LABEL"

fi

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash /sources/mkliveinitramfs.sh

sleep 5
set +e
./umountal.sh
set -e

mount $ROOT_PART $LFS
if [ "x$HOME_PART" != "x" ]
then
	mount $HOME_PART $LFS/home
fi

if [ ! -f $LFS/etc/lightdm/lightdm.conf ]
then
	mkdir -pv $LFS/etc/systemd/system/getty@tty1.service.d/
	pushd $LFS/etc/systemd/system/getty@tty1.service.d/
cat >override.conf<<EOF
[Service]
Type=simple
ExecStart=
ExecStart=-/sbin/agetty --autologin $USERNAME --noclear %I 38400 linux
EOF
	popd
fi

if [ -f $LFS/etc/slim.conf ]; then

cp $LFS/etc/slim.conf $LFS/etc/slim.conf.bak
sed -i "s@sessiondir@#sessiondir@g" $LFS/etc/slim.conf
sed -i "s@#default_user@default_user@g" $LFS/etc/slim.conf
sed -i "s@simone@$USERNAME@g" $LFS/etc/slim.conf
sed -i "s@#auto_login          no@auto_login          yes@g" $LFS/etc/slim.conf

if [ "$DE" == "1" ]; then
	SESSION="xfce4-session"
elif [ "$DE" == "2" ]; then
	SESSION="mate-session"
elif [ "$DE" == "3" ]; then
	SESSION="startkde"
elif [ "$DE" == "4" ]; then
	SESSION="gnome-session"
else
	SESSION="xfce4-session"
fi

cat > $LFS/home/$USERNAME/.xinitrc <<EOF
exec $SESSION
EOF

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash /sources/enable-disable-service.sh disable lightdm

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash /sources/enable-disable-service.sh enable slim

fi

rm -f $LFS/sources/root.sfs
sudo mksquashfs $LFS $LFS/sources/root.sfs -b 1048576 -comp xz -Xdict-size 100% -e $LFS/sources -e $LFS/var/cache/alps/sources/* -e $LFS/tools -e $LFS/etc/fstab

if [ ! -f $LFS/etc/lightdm/lightdm.conf ]
then
	rm -fv /etc/systemd/system/getty@tty1.service.d/override.conf
fi

if [ -f $LFS/etc/slim.conf ]; then

cp $LFS/etc/slim.conf $LFS/etc/slim.conf.bak
sed -i "s@#sessiondir@sessiondir@g" $LFS/etc/slim.conf
sed -i "s@default_user@#default_user@g" $LFS/etc/slim.conf
sed -i "s@$USERNAME@simone@g" $LFS/etc/slim.conf
sed -i "s@auto_login          yes@#auto_login          no@g" $LFS/etc/slim.conf

rm $LFS/home/$USERNAME/.xinitrc

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash /sources/enable-disable-service.sh disable slim

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash /sources/enable-disable-service.sh enable lightdm

fi

cd $LFS/sources/

tar xf $LFS/sources/syslinux-4.06.tar.xz
rm -fr live

mkdir -pv live/aryalinux
mkdir -pv live/isolinux

if [ `uname -m` == "x86_64" ]
then

mkdir -pv live/EFI/BOOT
cp -v $LFS/sources/efiboot.img live/isolinux/
cp -v $LFS/sources/bootx64.efi live/EFI/BOOT/
cat > live/EFI/BOOT/grub.cfg << EOF
set default="0"
set timeout="30"
set hidden_timeout_quiet=false

menuentry "$LABEL"{
  echo "Loading AryaLinux.  Please wait..."
  linux /isolinux/vmlinuz quiet splash
  initrd /isolinux/initram.fs
}

menuentry "$LABEL Debug Mode"{
  echo "Loading AryaLinux in debug mode.  Please wait..."
  linux /isolinux/vmlinuz
  initrd /isolinux/initram.fs
}
EOF

fi

echo "AryaLinux Live" >id_label

cp -v id_label live/isolinux
cp -v syslinux-4.06/core/isolinux.bin live/isolinux
cp -v syslinux-4.06/com32/menu/menu.c32 live/isolinux

cat > live/isolinux/isolinux.cfg << EOF
DEFAULT menu.c32
PROMPT 0
MENU TITLE Select an option to boot Aryalinux
TIMEOUT 300

LABEL slientlive
    MENU LABEL $LABEL
    MENU DEFAULT
    KERNEL /isolinux/vmlinuz
    APPEND initrd=initram.fs quiet splash
LABEL debuglive
    MENU LABEL $LABEL Debug Mode
    KERNEL /isolinux/vmlinuz
    APPEND initrd=initram.fs
EOF

cp -v $LFS/sources/root.sfs live/aryalinux/
cp -v `ls $LFS/boot/vmlinuz*`   live/isolinux/vmlinuz
cp -v $LFS/boot/initram.fs live/isolinux/

echo "AryaLinux Live" > live/isolinux/id_label


if [ `uname -m` == "x86_64" ]
then
mkisofs -o $LFS/sources/$OUTFILE -R -J -A "$LABEL" -hide-rr-moved -v -d -N -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -c isolinux/isolinux.boot -eltorito-alt-boot -no-emul-boot -eltorito-platform 0xEF -eltorito-boot isolinux/efiboot.img -V "ARYALIVE" live
isohybrid -u $LFS/sources/$OUTFILE
else
mkisofs -o $LFS/sources/$OUTFILE -R -J -A "$LABEL" -hide-rr-moved -v -d -N -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -c isolinux/isolinux.boot -no-emul-boot -V "ARYALIVE" live
isohybrid $LFS/sources/$OUTFILE
fi

rm -rvf $LFS/boot/initram.fs
rm -rvf $LFS/boot/id_label
