#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The acpid (Advanced Configurationbr3ak and Power Interface event daemon) is a completely flexible, totallybr3ak extensible daemon for delivering ACPI events. It listens on netlinkbr3ak interface and when an event occurs, executes programs to handle thebr3ak event. The programs it executes are configured through a set ofbr3ak configuration files, which can be dropped into place by packages orbr3ak by the user.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:acpid:2.0.28


NAME="acpid"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/acpid/acpid-2.0.28.tar.xz || wget -nc http://downloads.sourceforge.net/acpid2/acpid-2.0.28.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/acpid/acpid-2.0.28.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/acpid/acpid-2.0.28.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/acpid/acpid-2.0.28.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/acpid/acpid-2.0.28.tar.xz


URL=http://downloads.sourceforge.net/acpid2/acpid-2.0.28.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --docdir=/usr/share/doc/acpid-2.0.28 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /etc/acpi/events &&
cp -r samples /usr/share/doc/acpid-2.0.28

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/acpi/events/lid << "EOF"
event=button/lid
action=/etc/acpi/lid.sh
EOF
cat > /etc/acpi/lid.sh << "EOF"
#!/bin/sh
/bin/grep -q open /proc/acpi/button/lid/LID/state && exit 0
/usr/sbin/pm-suspend
EOF
chmod +x /etc/acpi/lid.sh

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-acpid

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
