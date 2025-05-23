# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Parameterized testing with any Python test framework"
HOMEPAGE="
	https://github.com/wolever/parameterized/
	https://pypi.org/project/parameterized/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-py312-test.patch"
	# https://github.com/wolever/parameterized/pull/176
	"${FILESDIR}/${P}-py313-test.patch"
)

distutils_enable_tests unittest
