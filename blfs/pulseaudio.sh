#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak PulseAudio is a sound system forbr3ak POSIX OSes, meaning that it is a proxy for sound applications. Itbr3ak allows you to do advanced operations on your sound data as itbr3ak passes between your application and your hardware. Things likebr3ak transferring the audio to a different machine, changing the samplebr3ak format or channel count and mixing several sounds into one arebr3ak easily achieved using a sound server.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:json-c
#REQ:libsndfile
#REQ:bluez
#REQ:sbc
#REC:alsa-lib
#REC:dbus
#REC:glib2
#REC:libcap
#REC:openssl
#REC:speex
#REC:x7lib
#OPT:avahi
#OPT:bluez
#OPT:check
#OPT:GConf
#OPT:gtk3
#OPT:libsamplerate
#OPT:sbc
#OPT:valgrind


#VER:pulseaudio:9.0


NAME="pulseaudio"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pulseaudio/pulseaudio-9.0.tar.xz || wget -nc http://freedesktop.org/software/pulseaudio/releases/pulseaudio-9.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pulseaudio/pulseaudio-9.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pulseaudio/pulseaudio-9.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pulseaudio/pulseaudio-9.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pulseaudio/pulseaudio-9.0.tar.xz


URL=http://freedesktop.org/software/pulseaudio/releases/pulseaudio-9.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/#/" build-aux/ltmain.sh


./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --enable-bluez5 --enable-bluez5-ofono-headset     \
            --disable-rpath      &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm /etc/dbus-1/system.d/pulseaudio-system.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i '/load-module module-console-kit/s/^/#/' /etc/pulse/default.pa

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
