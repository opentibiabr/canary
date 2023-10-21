/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <string>
#include <vector>
#include <unordered_map>
#include <variant>
#include <optional>
#include <algorithm>
#include <ranges>
#include <iterator>
#include <type_traits>

class ValueWrapper;

using StringType = std::string;
using BooleanType = bool;
using IntType = int;
using DoubleType = double;
using ArrayType = std::vector<ValueWrapper>;
using MapType = phmap::flat_hash_map<std::string, std::shared_ptr<ValueWrapper>>;

using ValueVariant = std::variant<StringType, BooleanType, IntType, DoubleType, ArrayType, MapType>;

class ValueWrapper {
public:
	explicit ValueWrapper(uint64_t timestamp = 0);
	explicit(false) ValueWrapper(const ValueVariant &value, uint64_t timestamp = 0);
	explicit(false) ValueWrapper(const std::string &value, uint64_t timestamp = 0);
	explicit(false) ValueWrapper(bool value, uint64_t timestamp = 0);
	explicit(false) ValueWrapper(int value, uint64_t timestamp = 0);
	explicit(false) ValueWrapper(double value, uint64_t timestamp = 0);
	explicit(false) ValueWrapper(const phmap::flat_hash_map<std::string, ValueWrapper> &value, uint64_t timestamp = 0);
	explicit(false) ValueWrapper(const std::initializer_list<std::pair<const std::string, ValueWrapper>> &init_list, uint64_t timestamp = 0);

	static ValueWrapper deleted() {
		static ValueWrapper wrapper;
		wrapper.setDeleted(true);
		return wrapper;
	}

	template <typename T>
	T get() const {
		if (std::holds_alternative<T>(data_)) {
			return std::get<T>(data_);
		}
		return T {};
	}

	double getNumber() const {
		if (std::holds_alternative<IntType>(data_)) {
			return static_cast<double>(std::get<IntType>(data_));
		} else if (std::holds_alternative<DoubleType>(data_)) {
			return std::get<DoubleType>(data_);
		}
		return 0.0;
	}

	const ValueVariant &getVariant() const {
		return data_;
	}

	std::optional<ValueWrapper> get(const std::string &key) const;
	std::optional<ValueWrapper> get(size_t index) const;

	template <typename T>
	T get(const std::string &key) const;

	template <typename T>
	T get(size_t index) const;

	uint64_t getTimestamp() const {
		return timestamp_;
	}

	void setTimestamp(uint64_t timestamp) {
		timestamp_ = timestamp;
	}

	void setDeleted(bool deleted) {
		deleted_ = deleted;
	}

	bool isDeleted() const {
		return deleted_;
	}

	bool operator==(const ValueWrapper &rhs) const;

	explicit(false) operator std::string() const {
		return get<StringType>();
	}

	explicit(false) operator bool() const {
		return get<BooleanType>();
	}

	explicit(false) operator int() const {
		return get<IntType>();
	}

	explicit(false) operator double() const {
		return get<DoubleType>();
	}

	explicit(false) operator ArrayType() const {
		return get<ArrayType>();
	}

	explicit(false) operator MapType() const {
		return get<MapType>();
	}

private:
	ValueVariant data_;
	uint64_t timestamp_ = 0;
	bool deleted_ = false;

	template <typename Iter>
	static MapType createMapFromRange(Iter begin, Iter end, uint64_t timestamp) {
		static_assert(std::is_base_of_v<std::input_iterator_tag, typename std::iterator_traits<Iter>::iterator_category>, "The iterator must be at least an input iterator.");

		MapType map;
		for (auto it = begin; it != end; ++it) {
			const auto &[key, val] = *it;
			std::visit(
				[&map, &key, &timestamp](const auto &val) {
					if constexpr (std::is_same_v<std::decay_t<decltype(val)>, std::shared_ptr<ValueWrapper>>) {
						map[key] = val;
					} else {
						map[key] = std::make_shared<ValueWrapper>(val, timestamp);
					}
				},
				val.data_
			);
		}
		return map;
	}
};

template <typename T>
T ValueWrapper::get(const std::string &key) const {
	auto optValue = get(key);
	if (optValue.has_value()) {
		if (auto pval = std::get_if<T>(&optValue->data_)) {
			return *pval;
		}
	}
	return T {};
}

template <typename T>
T ValueWrapper::get(size_t index) const {
	auto optValue = get(index);
	if (optValue.has_value()) {
		if (auto pval = std::get_if<T>(&optValue->data_)) {
			return *pval;
		}
	}
	return T {};
}

inline bool ValueWrapper::operator==(const ValueWrapper &rhs) const {
	return data_ == rhs.data_;
}

inline bool operator==(const ValueVariant &lhs, const ValueVariant &rhs) {
	return std::visit(
		[](const auto &a, const auto &b) {
			using A = std::decay_t<decltype(a)>;
			using B = std::decay_t<decltype(b)>;

			if constexpr (!std::is_same_v<A, B>) {
				return false;
			}
			// Perform shallow comparison for maps
			if constexpr (std::is_same_v<A, MapType> && std::is_same_v<B, MapType>) {
				if (a.size() != b.size()) {
					return false;
				}
				return std::ranges::all_of(a, [&b](const auto &pair) {
					const auto &[key, value] = pair;
					return b.contains(key) && value.get() == b.at(key).get();
				});
			}
			// Compares a and b if types A and B are the same, at compile-time
			if constexpr (std::is_same_v<A, B>) {
				return a == b;
			}
		},
		lhs, rhs
	);
}

inline std::ostream &operator<<(std::ostream &os, const ValueVariant &val) {
	std::visit(
		[&os](const auto &v) {
			os << v;
		},
		val
	);
	return os;
}

inline std::ostream &operator<<(std::ostream &os, const ValueWrapper &wrapper) {
	os << wrapper.getVariant();
	return os;
}
