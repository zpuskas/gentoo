# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Common styles for fluxbox, blackbox, and openbox"
HOMEPAGE="http://mkeadle.org/distfiles/"
SRC_URI="
	mirror://gentoo/${P}.tar.bz2
	http://mkeadle.org/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ppc ppc64 sparc x86"

RDEPEND="
	|| (
		x11-wm/fluxbox
		x11-wm/blackbox
		x11-wm/openbox
	)"

src_install() {
	insinto /usr/share/commonbox
	doins -r backgrounds styles

	dodoc README.commonbox-styles STYLES.authors
}
