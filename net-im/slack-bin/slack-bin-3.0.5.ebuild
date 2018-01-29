# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils rpm pax-utils xdg-utils

DESCRIPTION="A messaging app for teams"
HOMEPAGE="https://slack.com/"
SRC_URI="https://downloads.slack-edge.com/linux_releases/slack-${PV}-0.1.fc21.x86_64.rpm"
LICENSE="Slack"
RESTRICT="mirror"

SLOT="0"
KEYWORDS="~amd64 -*"
IUSE=""

QA_PREBUILT="usr/lib/slack/*"

DEPEND=""
RDEPEND="
	>=gnome-base/gconf-3.2.6-r4
	>=gnome-base/libgnome-keyring-3.12.0
	>=x11-libs/libXScrnSaver-1.2.2-r1
"

S=${WORKDIR}

src_unpack() {
	rpm_unpack ${A}
}

src_prepare() {
	rm etc/cron.daily/slack
	eapply_user
}

src_install() {
	cp -a . "${D}" || die
	pax-mark rm "${ED}/usr/lib/slack/slack"
	make_desktop_entry ${PN} "Slack" /usr/share/pixmaps/${PN}.png "Network"
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
