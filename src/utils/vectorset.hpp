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
			return v && std::ranges::binary_search(container, v);
		}

		bool erase(const T &v) {
			update();

			const auto &it = std::ranges::lower_bound(container, v);
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

		void push_back(const T &v) {
			needUpdate = true;
			return container.push_back(v);
		}

		template <class... _Valty>
		auto emplace_back(_Valty &&... v) {
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

	private:
		void update() noexcept {
			if (!needUpdate) {
				return;
			}

			needUpdate = false;
			std::ranges::sort(container);
			const auto &[f, l] = std::ranges::unique(container);
			container.erase(f, l);
		}

		std::vector<T> container;
		bool needUpdate = false;
	};
}
