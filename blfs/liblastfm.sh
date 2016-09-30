#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:liblastfm_.orig:1.0.9

#REQ:libfftw3

URL=http://archive.ubuntu.com/ubuntu/pool/universe/libl/liblastfm/liblastfm_1.0.9.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

mkdir build &&
cd build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "liblastfm=>`date`" | sudo tee -a $INSTALLED_LIST
