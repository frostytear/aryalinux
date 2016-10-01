#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:python-modules#setuptools
#REQ:python-distutils-extra
#REQ:python-modules#pyxdg

URL=http://archive.ubuntu.com/ubuntu/pool/universe/k/kazam/kazam_1.0.6.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

python setup.py build &&
sudo python setup.py install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "kazam=>`date`" | sudo tee -a $INSTALLED_LIST