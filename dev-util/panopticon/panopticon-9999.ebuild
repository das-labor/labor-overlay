# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="A libre cross platform disassembler"
HOMEPAGE="https://www.panopticon.re"
EGIT_REPO_URI="https://github.com/das-labor/panopticon.git"
SRC_URI=""
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"
IUSE="debug test"

RDEPEND="
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtsvg:5
	dev-qt/qtquickcontrols:5[widgets]"
DEPEND="${RDEPEND}
	dev-lang/rust
	dev-util/cargo
	dev-util/cmake"

RESTRICT="strip"

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	cd "${WORKDIR}/${P}"
}

src_compile() {
	if use debug
	then
		cargo build --verbose --all
	else
		cargo build --release --verbose --all
	fi
}

src_install() {
	if use debug
	then
		install -D -s -m 555 "${WORKDIR}/${P}/target/debug/panopticon" "$D/usr/bin/panopticon"
		install -D -s -m 555 "${WORKDIR}/${P}/target/debug/panop" "$D/usr/bin/panop"
	else
		install -D -s -m 555 "${WORKDIR}/${P}/target/release/panopticon" "$D/usr/bin/panopticon"
		install -D -s -m 555 "${WORKDIR}/${P}/target/release/panop" "$D/usr/bin/panop"
	fi
	install -m 755 -d "${D}/usr/share/panopticon/qml"
	cp -R "${WORKDIR}/${P}/qml/"* "${D}/usr/share/panopticon/qml"
	chown -R root:root "${D}/usr/share/panopticon/qml"
}

src_test() {
	if use test
	then
		cargo test --verbose --all
	fi
}
