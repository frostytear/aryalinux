#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

PACKAGE_NAME="librime"

#REQ:glog
#REQ:leveldb
#REQ:marisa
#REQ:opencc
#REQ:yaml-cpp
#REQ:kyotocabinet

URL=https://github.com/rime/librime/archive/rime-1.2.9.tar.gz

cd $SOURCE_DIR
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

cmake -DCMAKE_INSTALL_PREFIX=/usr . &&
make
sudo make install

cd $SOURCE_DIR
sudo rm -r $DIRECTORY

echo "$PACKAGE_NAME=>`date`" | sudo tee -a $INSTALLED_LIST
