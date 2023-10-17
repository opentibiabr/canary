/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <algorithm>
#include <vector>

// # Mehah
// vector_set is an container that contains a sorted set of unique objects.
// Note: this is faster than std::set

namespace stdext {
	template <typename T>
	class vector_set {
	public:
		bool contains(const T &v) {
			update();
			return std::ranges::binary_search(container.begin(), container.end(), v, std::less());
		}

		bool erase(const T &v) {
			update();

			const auto it = std::ranges::lower_bound(container.begin(), container.end(), v, std::less());
			if (it == container.end()) {
				return false;
			}
			container.erase(it);

			return true;
		}

		template <class F>
		bool erase_if(F fnc) {
			update();
			return std::erase_if(container, std::move(fnc)) > 0;
		}

		void insert(const T &v) {
			needUpdate = true;
			return container.push_back(v);
		}

		template <class... _Valty>
		auto emplace(_Valty &&... v) {
			needUpdate = true;
			return container.emplace_back(v...);
		}

		auto insertAll(const vector_set<T> &list) {
			needUpdate = true;
			return container.insert(container.end(), list.begin(), list.end());
		}

		auto insertAll(const std::vector<T> &list) {
			needUpdate = true;
			return container.insert(container.end(), list.begin(), list.end());
		}

		constexpr auto insert(std::vector<T>::const_iterator _Where, const T &_Val) {
			needUpdate = true;
			return container.insert(_Where, _Val);
		}

		constexpr auto insert(std::vector<T>::const_iterator _Where, T &&_Val) {
			needUpdate = true;
			return container.insert(_Where, std::move(_Val));
		}

		template <std::forward_iterator _Iter>
		constexpr auto insert(std::vector<T>::const_iterator _Where, _Iter _First, _Iter _Last) {
			needUpdate = true;
			return container.insert(_Where, _First, _Last);
		}

		bool empty() const noexcept {
			return container.empty();
		}

		size_t size() noexcept {
			update();
			return container.size();
		}

		auto begin() noexcept {
			update();
			return container.begin();
		}

		auto end() noexcept {
			return container.end();
		}

		void clear() noexcept {
			return container.clear();
		}

		void reserve(size_t newCap) noexcept {
			container.reserve(newCap);
		}

		const auto &data() noexcept {
			update();
			return container;
		}

		T &operator[](const size_t i) {
			update();
			return container[i];
		}

	private:
		void update() noexcept {
			if (!needUpdate) {
				return;
			}

			needUpdate = false;
			std::ranges::sort(container.begin(), container.end(), std::less());
			const auto &[f, l] = std::ranges::unique(container);
			container.erase(f, l);
		}

		std::vector<T> container;
		bool needUpdate = false;
	};
}
