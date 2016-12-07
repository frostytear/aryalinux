#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The lximage-qt package contains abr3ak lightweight image viewer and screenshot program.br3ak"
SECTION="lxqt"
VERSION=0.5.0
NAME="lximage-qt"

#REQ:libexif
#REQ:libfm-qt
#OPT:git
#OPT:lxqt-l10n


cd $SOURCE_DIR

URL=http://downloads.lxqt.org/lximage-qt/0.5.0/lximage-qt-0.5.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lximage-qt/lximage-qt-0.5.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lximage-qt/lximage-qt-0.5.0.tar.xz || wget -nc http://downloads.lxqt.org/lximage-qt/0.5.0/lximage-qt-0.5.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lximage-qt/lximage-qt-0.5.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lximage-qt/lximage-qt-0.5.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lximage-qt/lximage-qt-0.5.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lximage-qt/lximage-qt-0.5.0.tar.xz

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
cmake -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DPULL_TRANSLATIONS=no              \
      ..       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -svf $LXQT_PREFIX/share/applications/lximage-qt.desktop \
        /usr/share/applications &&
ln -svf $LXQT_PREFIX/share/applications/lximage-qt-screenshot.desktop \
        /usr/share/applications

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"