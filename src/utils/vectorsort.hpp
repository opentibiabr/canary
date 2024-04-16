/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <algorithm>
#include <vector>

// # Mehah
// vector_sort is a container that contains sorted objects.

namespace stdext {
	template <typename T>
	class vector_sort {
	public:
		bool contains(const T &v) {
			update();
			return std::ranges::binary_search(container, v);
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

		bool erase(const size_t begin, const size_t end) {
			update();

			if (begin > size() || end > size()) {
				return false;
			}

			container.erase(container.begin() + begin, container.begin() + end);
			return true;
		}

		template <class F>
		bool erase_if(F fnc) {
			update();
			return std::erase_if(container, std::move(fnc)) > 0;
		}

		auto &front() {
			update();
			return container.front();
		}

		void pop_back() {
			update();
			container.pop_back();
		}

		auto &back() {
			update();
			return container.back();
		}

		void push_back(const T &v) {
			needUpdate = true;
			container.push_back(v);
		}

		void push_back(T &&_Val) {
			needUpdate = true;
			container.push_back(std::move(_Val));
		}

		// Copy all content list to this
		auto insert_all(const vector_sort<T> &list) {
			needUpdate = true;
			return container.insert(container.end(), list.begin(), list.end());
		}

		// Copy all content list to this
		auto insert_all(const std::vector<T> &list) {
			needUpdate = true;
			return container.insert(container.end(), list.begin(), list.end());
		}

		// Move all content list to this
		auto join(vector_sort<T> &list) {
			needUpdate = true;
			auto res = container.insert(container.end(), make_move_iterator(list.begin()), make_move_iterator(list.end()));
			list.clear();
			return res;
		}

		// Move all content list to this
		auto join(std::vector<T> &list) {
			needUpdate = true;
			auto res = container.insert(container.end(), make_move_iterator(list.begin()), make_move_iterator(list.end()));
			list.clear();
			return res;
		}

		template <class... _Valty>
		decltype(auto) emplace_back(_Valty &&... v) {
			needUpdate = true;
			return container.emplace_back(std::forward<_Valty>(v)...);
		}

		void partial_sort(size_t begin, size_t end = 0) {
			partial_begin = begin;
			if (end > begin) {
				partial_end = size() - end;
			}
		}

		void notify_sort() {
			needUpdate = true;
		}

		bool empty() const noexcept {
			return container.empty();
		}

		size_t size() const noexcept {
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
			partial_begin = partial_end = 0;
			return container.clear();
		}

		void reserve(size_t newCap) noexcept {
			container.reserve(newCap);
		}

		const auto &data() noexcept {
			update();
			return container.data();
		}

		T &operator[](const size_t i) {
			update();
			return container[i];
		}

	private:
		inline void update() noexcept {
			if (!needUpdate) {
				return;
			}

			needUpdate = false;
			std::ranges::sort(container.begin() + partial_begin, container.end() - partial_end, std::less());
		}

		std::vector<T> container;

		bool needUpdate = false;
		size_t partial_begin { 0 };
		size_t partial_end { 0 };
	};
}
