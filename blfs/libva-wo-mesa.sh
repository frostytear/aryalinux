#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:libva:1.7.1

#REQ:mesa
#OPT:doxygen
#OPT:wayland

cd $SOURCE_DIR

URL=http://www.freedesktop.org/software/vaapi/releases/libva/libva-1.7.1.tar.bz2

wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
./configure $XORG_CONFIG &&
make

sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "libva-wo-mesa=>`date`" | sudo tee -a $INSTALLED_LIST
