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


.PHONY: upload
upload: ${DEB}
	umount /pve/${RELEASE}; mount /pve/${RELEASE} -o rw 
	mkdir -p /pve/${RELEASE}/extra
	rm -f /pve/${RELEASE}/extra/${PACKAGE}_*.deb
	rm -f /pve/${RELEASE}/extra/Packages*
	cp ${DEB} /pve/${RELEASE}/extra
	cd /pve/${RELEASE}/extra; dpkg-scanpackages . /dev/null > Packages; gzip -9c Packages > Packages.gz
	umount /pve/${RELEASE}; mount /pve/${RELEASE} -o ro

.PHONY: distclean
distclean: clean

.PHONY: clean
clean:
	rm -rf *~ debian/*~ ${SRCDIR} ${PACKAGE}_*.deb ${PACKAGE}_*.changes

.PHONY: dinstall
dinstall: ${DEB}
	dpkg -i ${DEB}

