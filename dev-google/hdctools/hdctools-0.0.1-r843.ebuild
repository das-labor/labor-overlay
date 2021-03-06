# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_{6,7} )

inherit git-r3 distutils-r1 toolchain-funcs multilib udev

DESCRIPTION="Software to communicate with servo/miniservo debug boards"
HOMEPAGE="https://www.chromium.org/chromium-os/servo"
EGIT_REPO_URI="https://chromium.googlesource.com/chromiumos/third_party/hdctools"
EGIT_COMMIT="1ae80656af2e97b3b1ae218fe318d1c8f6b4fafd"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="dev-embedded/libftdi:1
	dev-python/numpy
	>=dev-python/pexpect-3.0
	dev-python/pyserial
	dev-python/pyusb
	virtual/libusb:1
	app-misc/screen
	dev-google/ec-devutils"
DEPEND="${RDEPEND}
	app-text/htmltidy"

src_compile() {
	tc-export CC PKG_CONFIG
	local makeargs=( LIBFTDI_CFLAGS="-fPIC -Wno-error -I/usr/include/libftdi1 -I/usr/include/libusb-1.0" LIBFTDI_LDLIBS="-L/usr/lib64 -lftdi1 -lusb-1.0" EXTRA_DIRS=chromeos )
	emake "${makeargs[@]}"
	distutils-r1_src_compile
}

src_install() {
	local makeargs=(
		EXTRA_DIRS=chromeos
		DESTDIR="${D}"
		LIBDIR=/usr/$(get_libdir)
		UDEV_DEST="${D}$(get_udevdir)/rules.d"
		install
	)
	emake "${makeargs[@]}"
	distutils-r1_src_install
}
