#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Solid is a device integrationbr3ak framework. It provides a way of querying and interacting withbr3ak hardware independently of the underlying operating system.br3ak"
SECTION="lxqt"
VERSION=5.28.0
NAME="lxqt-solid"

#REQ:extra-cmake-modules
#REQ:qt5
#OPT:udisks2
#OPT:upower


cd $SOURCE_DIR

URL=http://download.kde.org/stable/frameworks/5.28/solid-5.28.0.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/solid/solid-5.28.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/solid/solid-5.28.0.tar.xz || wget -nc http://download.kde.org/stable/frameworks/5.28/solid-5.28.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/solid/solid-5.28.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/solid/solid-5.28.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/solid/solid-5.28.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/solid/solid-5.28.0.tar.xz

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

mkdir -v build &&
cd       build &&
cmake -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_LIBDIR=lib          \
      -DBUILD_TESTING=OFF                 \
      -Wno-dev ..                         &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
