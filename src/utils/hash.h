#pragma once

namespace stdext {
	template <class _Kty>
	using hash = phmap::Hash<_Kty>;

	// Robin Hood lib
	inline size_t hash_int(uint64_t x) noexcept {
		x ^= x >> 33U;
		x *= UINT64_C(0xff51afd7ed558ccd);
		x ^= x >> 33U;
		return static_cast<size_t>(x);
	}

	// Boost Lib
	inline void hash_union(size_t &seed, const size_t h) {
		seed ^= h + 0x9e3779b9 + (seed << 6) + (seed >> 2);
	}

	void hash_combine(size_t &seed, uint64_t v) {
		hash_union(seed, hash_int(v));
	}

	void hash_combine(size_t &seed, uint32_t v) {
		hash_union(seed, hash_int(v));
	}

	void hash_combine(size_t &seed, uint16_t v) {
		hash_union(seed, hash_int(v));
	}

	void hash_combine(size_t &seed, uint8_t v) {
		hash_union(seed, hash_int(v));
	}

	template <class T>
	void hash_combine(size_t &seed, const T &v) {
		stdext::hash<T> hasher;
		hash_union(seed, hasher(v));
	}
}
