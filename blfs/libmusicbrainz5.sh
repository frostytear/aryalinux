#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libmusicbrainz packagebr3ak contains a library which allows you to access the data held on thebr3ak MusicBrainz server.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:cmake
#REQ:libxml2
#REQ:neon
#OPT:doxygen


#VER:libmusicbrainz:5.1.0


NAME="libmusicbrainz5"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-5.1.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-5.1.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-5.1.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-5.1.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libmusicbrainz/libmusicbrainz-5.1.0.tar.gz || wget -nc https://github.com/metabrainz/libmusicbrainz/releases/download/release-5.1.0/libmusicbrainz-5.1.0.tar.gz


URL=https://github.com/metabrainz/libmusicbrainz/releases/download/release-5.1.0/libmusicbrainz-5.1.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
