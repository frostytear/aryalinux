#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak MPlayer is a powerful audio/videobr3ak player controlled via the command line or a graphical interfacebr3ak that is able to play almost every popular audio and video filebr3ak format. With supported video hardware and additional drivers,br3ak MPlayer can play video filesbr3ak without an X Window Systembr3ak installed.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:yasm
#REC:gtk2
#REC:x7driver
#OPT:cdparanoia
#OPT:libcdio
#OPT:libdvdread
#OPT:libdvdnav
#OPT:libdvdcss
#OPT:samba
#OPT:pulseaudio
#OPT:sdl
#OPT:aalib
#OPT:giflib
#OPT:libjpeg
#OPT:libmng
#OPT:libpng
#OPT:openjpeg
#OPT:faac
#OPT:faad2
#OPT:lame
#OPT:liba52
#OPT:libdv
#OPT:libmad
#OPT:libmpeg2
#OPT:libtheora
#OPT:libvpx
#OPT:lzo
#OPT:mpg123
#OPT:speex
#OPT:xvid
#OPT:x264
#OPT:fontconfig
#OPT:freetype2
#OPT:fribidi
#OPT:gnutls
#OPT:openssl
#OPT:opus
#OPT:unrar
#OPT:libxslt
#OPT:docbook
#OPT:docbook-xsl


#VER:MPlayer:1.3.0
#VER:Clearlooks:1.7


NAME="mplayer"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/MPlayer/MPlayer-1.3.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/MPlayer/MPlayer-1.3.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/MPlayer/MPlayer-1.3.0.tar.xz || wget -nc ftp://ftp.mplayerhq.hu/MPlayer/releases/MPlayer-1.3.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/MPlayer/MPlayer-1.3.0.tar.xz || wget -nc http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.3.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/MPlayer/MPlayer-1.3.0.tar.xz
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/clearlooks/Clearlooks-1.7.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/clearlooks/Clearlooks-1.7.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/clearlooks/Clearlooks-1.7.tar.bz2 || wget -nc ftp://ftp.mplayerhq.hu/MPlayer/skins/Clearlooks-1.7.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/clearlooks/Clearlooks-1.7.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/clearlooks/Clearlooks-1.7.tar.bz2 || wget -nc https://www.mplayerhq.hu/MPlayer/skins/Clearlooks-1.7.tar.bz2


URL=http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.3.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr            \
            --confdir=/etc/mplayer   \
            --enable-dynamic-plugins \
            --enable-menu            \
            --enable-gui             &&
make "-j`nproc`"


make doc



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install  &&
ln -svf ../icons/hicolor/48x48/apps/mplayer.png \
        /usr/share/pixmaps/mplayer.png

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/mplayer-1.3.0 &&
install -v -m644    DOCS/HTML/en/* \
                    /usr/share/doc/mplayer-1.3.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 etc/codecs.conf /etc/mplayer

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 etc/*.conf /etc/mplayer

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tar -xvf  ../Clearlooks-1.7.tar.bz2 \
    -C    /usr/share/mplayer/skins &&
ln  -sfvn Clearlooks /usr/share/mplayer/skins/default

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
