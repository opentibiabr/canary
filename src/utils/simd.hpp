/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

// #define __DISABLE_VECTORIZATION__ 1

#if defined(__DISABLE_VECTORIZATION__)
	// You might want to disable vectorization on some compilers
    // it can just get buggy and the engine will crashes
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
__forceinline unsigned int mm_ctz(unsigned int value) {
	unsigned long i = 0;
	_BitScanForward(&i, value);
	return static_cast<unsigned int>(i);
}
#else
	#define mm_ctz __builtin_ctz
#endif
