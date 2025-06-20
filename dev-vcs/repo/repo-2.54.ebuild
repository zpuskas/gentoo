# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NB: The ${PV} tracks the *repo launcher version*, not the last signed release
# of the repo project.  The launcher only gets a new update when changes are
# made in it.

EAPI="8"

PYTHON_COMPAT=( python3_{11..13} )

inherit bash-completion-r1 python-r1

DESCRIPTION="Google tool for managing git, particularly multiple repos"
HOMEPAGE="https://gerrit.googlesource.com/git-repo"
SRC_URI="https://github.com/GerritCodeReview/git-repo/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/git-${P}"
LICENSE="Apache-2.0"
SLOT="0"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	!app-admin/radmind
"

src_install() {
	python_foreach_impl python_doscript ${PN}
	newbashcomp completion.bash ${PN}
	doman man/*.[0-9]
}
