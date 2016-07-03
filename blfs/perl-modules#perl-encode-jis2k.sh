#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf


URL="http://www.cpan.org/authors/id/D/DA/DANKOGAI/Encode-JIS2K-0.03.tar.gz"

#VER:Encode-JIS2K:0.03

cd $SOURCE_DIR
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

if [ -f Build.PL ]
then
perl Build.PL &&
./Build &&
sudo ./Build install
fi

if [ -f Makefile.PL ]
then
perl Makefile.PL &&
make &&
sudo make install
fi
cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

echo "perl-modules#perl-encode-jis2k=>`date`" | sudo tee -a $INSTALLED_LIST
