#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Hdparm package contains abr3ak utility that is useful for controlling ATA/IDE controllers and hardbr3ak drives both to increase performance and sometimes to increasebr3ak stability.br3ak"
SECTION="general"
VERSION=9.50
NAME="hdparm"



cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/hdparm/hdparm-9.50.tar.gz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/hdparm/hdparm-9.50.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/hdparm/hdparm-9.50.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/hdparm/hdparm-9.50.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/hdparm/hdparm-9.50.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/hdparm/hdparm-9.50.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/hdparm/hdparm-9.50.tar.gz || wget -nc http://downloads.sourceforge.net/hdparm/hdparm-9.50.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make binprefix=/usr install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
