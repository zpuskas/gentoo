# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Intel Open Path Guiding Library"
HOMEPAGE="https://github.com/RenderKit/openpgl"
SRC_URI="https://github.com/RenderKit/openpgl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="-* ~amd64 ~arm64"

X86_CPU_FLAGS=( sse4_2 avx2 avx512dq )
CPU_FLAGS=( "${X86_CPU_FLAGS[@]/#/cpu_flags_x86_}" )
IUSE="${CPU_FLAGS[*]} debug"

REQUIRED_USE="
	amd64? ( || ( ${X86_CPU_FLAGS[*]/#/cpu_flags_x86_} ) )
"

RDEPEND="
	media-libs/embree:=
	dev-cpp/tbb:=
"
DEPEND="${RDEPEND}"

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/926890
	#
	# Upstream "solved" this by setting -fno-strict-aliasing themselves.
	# Do not trust with LTO.
	filter-lto

	local mycmakeargs=(
		-DOPENPGL_ISA_SSE4="$(usex cpu_flags_x86_sse4_2)"
		-DOPENPGL_ISA_AVX2="$(usex cpu_flags_x86_avx2)"
		-DOPENPGL_ISA_AVX512="$(usex cpu_flags_x86_avx512dq)"
		-DOPENPGL_ISA_NEON="$(usex arm64)"
		# TODO look into neon 2x support
		# neon2x is "double pumped" neon on apple silicon
		# -DOPENPGL_ISA_NEON2X="$(usex cpu_flags_arm64_neon2x)"
	)

	# This is currently needed on arm64 to get the NEON SIMD wrapper to compile the code successfully
	use arm64 && append-flags -flax-vector-conversions

	# Disable asserts
	append-cppflags "$(usex debug '' '-DNDEBUG')"

	cmake_src_configure
}
