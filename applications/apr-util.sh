#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Apache Portable Runtime Utility Library provides a predictablebr3ak and consistent interface to underlying client library interfaces.br3ak This application programming interface assures predictable if notbr3ak identical behaviour regardless of which libraries are available onbr3ak a given platform.br3ak"
SECTION="general"
VERSION=1.5.4
NAME="apr-util"

#REQ:apr
#REC:openssl
#OPT:db
#OPT:mariadb
#OPT:openldap
#OPT:postgresql
#OPT:sqlite
#OPT:unixodbc


cd $SOURCE_DIR

URL=https://www.apache.org/dist/apr/apr-util-1.5.4.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://www.apache.org/dist/apr/apr-util-1.5.4.tar.bz2

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

./configure --prefix=/usr       \
            --with-apr=/usr     \
            --with-gdbm=/usr    \
            --with-openssl=/usr \
            --with-crypto &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
