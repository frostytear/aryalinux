#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The libqtxdg is a Qtbr3ak implementation of freedesktop.org xdg specifications.br3ak"
SECTION="lxqt"
VERSION=2.0.0
NAME="libqtxdg"

#REQ:cmake
#REQ:qt5
#OPT:gtk2


cd $SOURCE_DIR

URL=http://downloads.lxqt.org/libqtxdg/2.0.0/libqtxdg-2.0.0.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libqtxdg/libqtxdg-2.0.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libqtxdg/libqtxdg-2.0.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libqtxdg/libqtxdg-2.0.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libqtxdg/libqtxdg-2.0.0.tar.xz || wget -nc http://downloads.lxqt.org/libqtxdg/2.0.0/libqtxdg-2.0.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libqtxdg/libqtxdg-2.0.0.tar.xz

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

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib          \
      ..       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
