#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:alsa-tools:1.1.0

#REQ:alsa-lib
#OPT:gtk2
#OPT:gtk3
#OPT:fltk


cd $SOURCE_DIR

URL=http://alsa.cybermirror.org/tools/alsa-tools-1.1.0.tar.bz2

wget -nc http://alsa.cybermirror.org/tools/alsa-tools-1.1.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/alsa-tools/alsa-tools-1.1.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-tools/alsa-tools-1.1.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-tools/alsa-tools-1.1.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/alsa-tools/alsa-tools-1.1.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/alsa-tools/alsa-tools-1.1.0.tar.bz2 || wget -nc ftp://ftp.alsa-project.org/pub/tools/alsa-tools-1.1.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}
export -f as_root


rm -rf qlo10k1 Makefile gitcompile


for tool in *
do
  case $tool in
    seq )
      tool_dir=seq/sbiload
    ;;
    * )
      tool_dir=$tool
    ;;
  esac
  pushd $tool_dir
    ./configure --prefix=/usr
    make "-j`nproc`"
    as_root make install
    as_root /sbin/ldconfig
  popd
done
unset tool tool_dir


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "alsa-tools=>`date`" | sudo tee -a $INSTALLED_LIST
