# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A small and lightweight parser library for ATA S.M.A.R.T. hard disks"
HOMEPAGE="https://salsa.debian.org/utopia-team/libatasmart"
SRC_URI="mirror://debian/pool/main/liba/${PN}/${PN}_${PV/_p*}.orig.tar.xz
	mirror://debian/pool/main/liba/${PN}/${PN}_${PV/_p/-}.debian.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0/4"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv sparc x86"
IUSE="static-libs"

RDEPEND="virtual/libudev:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${P/_p*}"

src_prepare() {
	# https://bugs.gentoo.org/470874
	local d="${WORKDIR}/debian/patches"
	sed -i -e '/#/d' \
		-e "s|^|${d}/|" "${d}"/series || die
	eapply $(<"${d}"/series)
	eapply_user
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_compile() {
	if tc-is-cross-compiler; then
		tc-export_build_env
		emake -C strpool strpool \
			CFLAGS="${BUILD_CFLAGS}" \
			CPPFLAGS="${BUILD_CPPFLAGS}" \
			LDFLAGS="${BUILD_LDFLAGS}"
	fi
	emake
}

src_install() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
}
