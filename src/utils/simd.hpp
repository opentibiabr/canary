/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 * Copyright (C) 2019-2021 Saiyans King
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef SRC_UTILS_SIMD_HPP_
#define SRC_UTILS_SIMD_HPP_

//#define __DISABLE_VECTORIZATION__ 1

#if defined(__DISABLE_VECTORIZATION__)
//You might want to disable vectorization on some compilers
//it can just get buggy and the engine will crashes
#undef __NEON__
#undef __ARM_NEON__
#undef __ARM_FEATURE_SIMD32
#undef __SSE__
#undef __SSE2__
#undef __SSE3__
#undef __SSSE3__
#undef __SSE4_1__
#undef __SSE4_2__
#undef __AVX__
#undef __AVX2__
#undef __AVX512F__
#else
#if defined(__ARM_NEON__) || defined(__ARM_FEATURE_SIMD32)
#define __NEON__ 1
#include <arm_neon.h>
#endif
#if defined(__SSE__)
#include <xmmintrin.h>
#endif
#if defined(__SSE2__)
#include <emmintrin.h>
#endif
#if defined(__SSE3__)
#include <pmmintrin.h>
#endif
#if defined(__SSSE3__)
#include <tmmintrin.h>
#endif
#if defined(__SSE4_1__)
#include <smmintrin.h>
#endif
#if defined(__SSE4_2__)
#include <nmmintrin.h>
#endif
#if defined(__AVX__) || defined(__AVX2__) || defined(__AVX512F__)
#include <immintrin.h>
#endif
#endif

#ifdef _MSC_VER
#include <intrin.h>
__forceinline unsigned int _mm_ctz(unsigned int value)
{
	unsigned long i = 0;
	_BitScanForward(&i, value);
	return static_cast<unsigned int>(i);
}
#else
#define _mm_ctz __builtin_ctz
#endif

#endif  // SRC_UTILS_SIMD_HPP_
