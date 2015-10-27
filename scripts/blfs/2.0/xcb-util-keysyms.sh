#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libxcb


cd $SOURCE_DIR

wget -nc http://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.0.tar.bz2


TARBALL=xcb-util-keysyms-0.4.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure $XORG_CONFIG &&
make

cat > 1434987998789.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998789.sh
sudo ./1434987998789.sh
sudo rm -rf 1434987998789.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xcb-util-keysyms=>`date`" | sudo tee -a $INSTALLED_LIST