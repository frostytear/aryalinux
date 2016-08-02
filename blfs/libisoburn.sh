#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libisoburn:1.4.4

#REQ:libburn
#REQ:libisofs


cd $SOURCE_DIR

URL=http://files.libburnia-project.org/releases/libisoburn-1.4.4.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libisoburn/libisoburn-1.4.4.tar.gz || wget -nc http://files.libburnia-project.org/releases/libisoburn-1.4.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libisoburn/libisoburn-1.4.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libisoburn/libisoburn-1.4.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libisoburn/libisoburn-1.4.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libisoburn/libisoburn-1.4.4.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr              \
            --disable-static           \
            --enable-pkg-check-modules &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libisoburn=>`date`" | sudo tee -a $INSTALLED_LIST

