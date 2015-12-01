#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gnome-keyring

cd $SOURCE_DIR

URL="http://pub.mate-desktop.org/releases/1.12/mate-power-manager-1.12.0.tar.xz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static --without-keyring &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "mate-power-manager=>`date`" | sudo tee -a $INSTALLED_LIST