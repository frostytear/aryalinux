#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:%DESCRIPTION%
#SECTION:general

whoami > /tmp/currentuser

#REQ:python-modules#pygobject2
#REQ:atk
#REQ:pango
#REQ:python-modules#py2cairo
#REQ:gtk2
#REQ:libglade
#OPT:libxslt


#VER:pygtk:2.24.0


NAME="python-modules#pygtk"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.gnome.org/pub/gnome/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2 || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2


URL=http://ftp.gnome.org/pub/gnome/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
