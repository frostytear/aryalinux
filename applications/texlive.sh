#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Most of TeX Live can be built from source without a pre-existingbr3ak installation, but xindy (forbr3ak indexing) needs working versions of <span class=\"command\"><strong>latex</strong> and <span class=\"command\"><strong>pdflatex</strong> when configure is run,br3ak and the testsuite and install for <span class=\"command\"><strong>asy</strong> (for vector graphics) willbr3ak fail if TeX has not already been installed. Additionally,br3ak biber is not provided within thebr3ak texlive source.br3ak"
SECTION="pst"
VERSION=20160523
NAME="texlive"

#REC:gs
#REC:fontconfig
#REC:freetype2
#REC:gc
#REC:graphite2
#REC:harfbuzz
#REC:icu
#REC:libpaper
#REC:libpng
#REC:poppler
#REC:python2
#REC:ruby
#REC:xorg-server


cd $SOURCE_DIR

URL=ftp://tug.org/texlive/historic/2016/texlive-20160523b-source.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/texlive/texlive-20160523b-source.tar.xz || wget -nc ftp://tug.org/texlive/historic/2016/texlive-20160523b-source.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/texlive/texlive-20160523b-source.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/texlive/texlive-20160523b-source.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/texlive/texlive-20160523b-source.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/texlive/texlive-20160523b-source.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/texlive/texlive-20160523b-source.tar.xz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/texlive/texlive-20160523b-texmf.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/texlive/texlive-20160523b-texmf.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/texlive/texlive-20160523b-texmf.tar.xz || wget -nc ftp://tug.org/texlive/historic/2016/texlive-20160523b-texmf.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/texlive/texlive-20160523b-texmf.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/texlive/texlive-20160523b-texmf.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/texlive/texlive-20160523b-texmf.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/downloads/texlive/texlive-20160523b-source-upstream_fixes-2.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/texlive-20160523b-source-upstream_fixes-2.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/texlive-20160523b-texmf-upstream_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/texlive/texlive-20160523b-texmf-upstream_fixes-1.patch

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/ld.so.conf << EOF
# Begin texlive 2016 addition
/opt/texlive/2016/lib
# End texlive 2016 addition
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&
patch -Np1 -i ../texlive-20160523b-source-upstream_fixes-2.patch &&
mkdir texlive-build &&
cd texlive-build    &&
../configure                                        \
    --prefix=/opt/texlive/2016                      \
    --bindir=/opt/texlive/2016/bin/$TEXARCH         \
    --datarootdir=/opt/texlive/2016                 \
    --includedir=/opt/texlive/2016/include          \
    --infodir=/opt/texlive/2016/texmf-dist/doc/info \
    --libdir=/opt/texlive/2016/lib                  \
    --mandir=/opt/texlive/2016/texmf-dist/doc/man   \
    --disable-native-texlive-build                  \
    --disable-static --enable-shared                \
    --with-system-cairo                             \
    --with-system-fontconfig                        \
    --with-system-freetype2                         \
    --with-system-gmp                               \
    --with-system-graphite2                         \
    --with-system-harfbuzz                          \
    --with-system-icu                               \
    --with-system-libgs                             \
    --with-system-libpaper                          \
    --with-system-libpng                            \
    --with-system-mpfr                              \
    --with-system-pixman                            \
    --with-system-poppler                           \
    --with-system-xpdf                              \
    --with-system-zlib                              \
    --with-banner-add=" - BLFS" &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2
tar xf blfs-systemd-units-20160602.tar.bz2
cd blfs-systemd-units-20160602
make install-strip &&
make texlinks &&
ldconfig &&
mkdir -pv /opt/texlive/2016/tlpkg/TeXLive/ &&
install -v -m644 ../texk/tests/TeXLive/* /opt/texlive/2016/tlpkg/TeXLive/

cd ..
rm -rf blfs-systemd-units-20160602
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tar -xf ../../texlive-20160523b-texmf.tar.xz -C /opt/texlive/2016 --strip-components=1 &&
pushd /opt/texlive/2016 &&
patch -Np1 -i /sources/texlive-20160523b-texmf-upstream_fixes-1.patch &&
popd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mktexlsr &&
fmtutil-sys --all &&
mtxrun --generate

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i '/^mpost,/d' /opt/texlive/2016/texmf-dist/web2c/texmf.cnf &&
fmtutil-sys --all &&

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
