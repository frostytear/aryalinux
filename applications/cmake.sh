#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The CMake package contains abr3ak modern toolset used for generating Makefiles. It is a successor ofbr3ak the auto-generated <span class=\"command\"><strong>configure</strong> script and aims to bebr3ak platform- and compiler-independent. A significant user ofbr3ak CMake is KDE since version 4.br3ak"
SECTION="general"
VERSION=3.7.1
NAME="cmake"

#REC:curl
#REC:libarchive
#OPT:qt5
#OPT:subversion


cd $SOURCE_DIR

URL=http://www.cmake.org/files/v3.7/cmake-3.7.1.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cmake/cmake-3.7.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/cmake/cmake-3.7.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cmake/cmake-3.7.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cmake/cmake-3.7.1.tar.gz || wget -nc http://www.cmake.org/files/v3.7/cmake-3.7.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cmake/cmake-3.7.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cmake/cmake-3.7.1.tar.gz

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

sed -i '/CMAKE_USE_LIBUV 1/s/1/0/' CMakeLists.txt &&
./bootstrap --prefix=/usr       \
            --system-libs       \
            --mandir=/share/man \
            --no-system-jsoncpp \
            --docdir=/share/doc/cmake-3.7.1 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
