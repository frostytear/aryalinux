#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:docbook-dsssl:1.79
#VER:docbook-dsssl-doc:1.79

#REQ:sgml-common
#REQ:sgml-dtd-3
#REQ:sgml-dtd
#REQ:opensp
#REQ:openjade


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/docbook/docbook-dsssl-1.79.tar.bz2

wget -nc http://downloads.sourceforge.net/docbook/docbook-dsssl-doc-1.79.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/docbook/docbook-dsssl-doc-1.79.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/docbook/docbook-dsssl-doc-1.79.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/docbook/docbook-dsssl-doc-1.79.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook/docbook-dsssl-doc-1.79.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook/docbook-dsssl-doc-1.79.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook/docbook-dsssl-1.79.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/docbook/docbook-dsssl-1.79.tar.bz2 || wget -nc http://downloads.sourceforge.net/docbook/docbook-dsssl-1.79.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/docbook/docbook-dsssl-1.79.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/docbook/docbook-dsssl-1.79.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook/docbook-dsssl-1.79.tar.bz2 || wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/docbook-dsssl-1.79.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

tar -xf ../docbook-dsssl-doc-1.79.tar.bz2 --strip-components=1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 bin/collateindex.pl /usr/bin                      &&
install -v -m644 bin/collateindex.pl.1 /usr/share/man/man1         &&
install -v -d -m755 /usr/share/sgml/docbook/dsssl-stylesheets-1.79 &&
cp -v -R * /usr/share/sgml/docbook/dsssl-stylesheets-1.79          &&
install-catalog --add /etc/sgml/dsssl-docbook-stylesheets.cat \
    /usr/share/sgml/docbook/dsssl-stylesheets-1.79/catalog         &&
install-catalog --add /etc/sgml/dsssl-docbook-stylesheets.cat \
    /usr/share/sgml/docbook/dsssl-stylesheets-1.79/common/catalog  &&
install-catalog --add /etc/sgml/sgml-docbook.cat              \
    /etc/sgml/dsssl-docbook-stylesheets.cat

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cd /usr/share/sgml/docbook/dsssl-stylesheets-1.79/doc/testdata

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
openjade -t rtf -d jtest.dsl jtest.sgm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
onsgmls -sv test.sgm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
openjade -t rtf \
    -d /usr/share/sgml/docbook/dsssl-stylesheets-1.79/print/docbook.dsl \
    test.sgm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
openjade -t sgml \
    -d /usr/share/sgml/docbook/dsssl-stylesheets-1.79/html/docbook.dsl \
    test.sgm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm jtest.rtf test.rtf c1.htm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "docbook-dsssl=>`date`" | sudo tee -a $INSTALLED_LIST
