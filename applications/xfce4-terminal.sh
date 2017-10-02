#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Xfce4 Terminal is a GTK+3 terminal emulator. This is useful forbr3ak running commands or programs in the comfort of an Xorg window; youbr3ak can drag and drop files into the Xfce4br3ak Terminal or copy and paste text with your mouse.br3ak"
SECTION="xfce"
VERSION=0.8.6
NAME="xfce4-terminal"

#REQ:libxfce4ui
#REQ:vte


cd $SOURCE_DIR

URL=http://archive.xfce.org/src/apps/xfce4-terminal/0.8/xfce4-terminal-0.8.6.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://archive.xfce.org/src/apps/xfce4-terminal/0.8/xfce4-terminal-0.8.6.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xfce/xfce4-terminal-0.8.6.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/xfce/xfce4-terminal-0.8.6.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-terminal-0.8.6.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-terminal-0.8.6.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-terminal-0.8.6.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-terminal-0.8.6.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
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
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
