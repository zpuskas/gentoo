# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Fast samples-based log normalization library"
HOMEPAGE="https://www.liblognorm.com"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/rsyslog/${PN}.git"

	inherit git-r3
else
	SRC_URI="https://www.liblognorm.com/files/download/${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~hppa ~ppc64 ~riscv ~sparc x86 ~amd64-linux"
fi

LICENSE="LGPL-2.1 Apache-2.0"
SLOT="0/5.1.0"
IUSE="debug doc static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libestr-0.1.3
	>=dev-libs/libfastjson-0.99.2:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/autoconf-archive-2015.02.04
	virtual/pkgconfig
	doc? ( >=dev-python/sphinx-1.2.2 )
"

DOCS=( ChangeLog )

PATCHES=(
	"${FILESDIR}/${P}-sphinx-5.patch"
	"${FILESDIR}/${P}-configure-clang16.patch"
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# regexp disabled due to https://github.com/rsyslog/liblognorm/issues/143
	local myeconfargs=(
		--enable-compile-warnings=yes
		--disable-Werror
		$(use_enable doc docs)
		$(use_enable test testbench)
		$(use_enable debug)
		$(use_enable static-libs static)
		--disable-regexp
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	# When adding new tests via patches we have to make them executable
	einfo "Adjusting permissions of test scripts ..."
	find "${S}"/tests -type f -name '*.sh' \! -perm -111 -exec chmod a+x '{}' \; || \
		die "Failed to adjust test scripts permission"

	emake -j1 check
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
