RELEASE=2.2

# wget http://download.openvz.org/utils/vzquota/3.1/src/vzquota-3.1.tar.bz2

PACKAGE=vzquota
PKGVER=3.1
PACKAGERELEASE=1

ARCH=amd64
DEB=${PACKAGE}_${PKGVER}-${PACKAGERELEASE}_${ARCH}.deb

SRCDIR=vzquota-${PKGVER}
SRC=${SRCDIR}.tar.bz2

all: ${DEB}

${DEB}: ${SRC}
	rm -rf ${SRCDIR}
	tar xf ${SRC}
	cp -a debian ${SRCDIR}
	cd ${SRCDIR}; dpkg-buildpackage -b -rfakeroot -us -uc
	lintian ${DEB}


clean:
	rm -rf *~ debian/*~ ${SRCDIR} ${PACKAGE}_*.deb ${PACKAGE}_*.changes