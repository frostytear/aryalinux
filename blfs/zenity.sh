#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Zenity is a rewrite ofbr3ak gdialog, the GNOME port of dialog which allows you to displaybr3ak GTK+ dialog boxes from the commandbr3ak line and shell scripts.br3ak"
SECTION="gnome"
VERSION=3.22.0
NAME="zenity"

#REQ:gtk3
#REQ:itstool
#REC:libnotify
#OPT:webkitgtk


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/zenity/3.22/zenity-3.22.0.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/zenity/3.22/zenity-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/zenity/zenity-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/zenity/zenity-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/zenity/zenity-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/zenity/zenity-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/zenity/3.22/zenity-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/zenity/zenity-3.22.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
