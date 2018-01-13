#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak libpeas is a GObject based pluginsbr3ak engine, and is targeted at giving every application the chance tobr3ak assume its own extensibility.br3ak"
SECTION="gnome"
VERSION=1.22.0
NAME="libpeas"

#REQ:gobject-introspection
#REQ:gtk3
#REC:python-modules#pygobject3
#OPT:gdb
#OPT:gtk-doc
#OPT:valgrind


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/libpeas/1.22/libpeas-1.22.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/libpeas/1.22/libpeas-1.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libpeas/libpeas-1.22.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libpeas/libpeas-1.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpeas/libpeas-1.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpeas/libpeas-1.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libpeas/libpeas-1.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libpeas/libpeas-1.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libpeas/1.22/libpeas-1.22.0.tar.xz
wget -nc http://www.lua.org/ftp/lua-5.1.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lua/lua-5.1.5.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lua/lua-5.1.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lua/lua-5.1.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lua/lua-5.1.5.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lua/lua-5.1.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lua/lua-5.1.5.tar.gz

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

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
