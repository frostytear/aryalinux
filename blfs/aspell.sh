#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:aspell:0.60.6.1

#REQ:general_which


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/aspell/aspell-0.60.6.1.tar.gz || wget -nc https://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/aspell/aspell-0.60.6.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/aspell/aspell-0.60.6.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/aspell/aspell-0.60.6.1.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/aspell/aspell-0.60.6.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -svfn aspell-0.60 /usr/lib/aspell &&
install -v -m755 -d /usr/share/doc/aspell-0.60.6.1/aspell{,-dev}.html &&
install -v -m644 manual/aspell.html/* \
    /usr/share/doc/aspell-0.60.6.1/aspell.html &&
install -v -m644 manual/aspell-dev.html/* \
    /usr/share/doc/aspell-0.60.6.1/aspell-dev.html

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m 755 scripts/ispell /usr/bin/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m 755 scripts/spell /usr/bin/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "aspell=>`date`" | sudo tee -a $INSTALLED_LIST
