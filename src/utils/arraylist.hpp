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
// Arraylist is a very fast container for adding to the front and back,
// it uses two vectors to do this juggling and doesn't allow you to remove the front, as it is slow,
// use std::list for this case.

namespace stdext {
	template <typename T>
	class arraylist {
	public:
		arraylist() = default;

		explicit arraylist(size_t reserveSize) {
			reserve(reserveSize);
		}

		explicit arraylist(std::initializer_list<T> _Ilist) {
			backContainer.assign(_Ilist);
		}

		arraylist &operator=(std::initializer_list<T> _Ilist) {
			backContainer.assign(_Ilist);
			return *this;
		}

		void assign(std::initializer_list<T> _Ilist) {
			backContainer.assign(_Ilist);
		}

		bool contains(const T &v) {
			update();
			return std::ranges::find(backContainer, v) != backContainer.end();
		}

		bool erase(const T &v) {
			update();

			auto it = std::ranges::find(backContainer, v);
			if (it == backContainer.end()) {
				return false;
			}
			backContainer.erase(it);

			return true;
		}

		bool erase(const size_t begin, const size_t end) {
			update();

			if (begin > size() || end > size()) {
				return false;
			}

			backContainer.erase(backContainer.begin() + begin, backContainer.begin() + end);
			return true;
		}

		template <class F>
		bool erase_if(F fnc) {
			update();
			return std::erase_if(backContainer, std::move(fnc)) > 0;
		}

		auto &front() {
			update();
			return backContainer.front();
		}

		void pop_back() {
			update();
			backContainer.pop_back();
		}

		auto &back() {
			update();
			return backContainer.back();
		}

		void push_front(const T &v) {
			needUpdate = true;
			frontContainer.push_back(v);
		}

		void push_front(T &&_Val) {
			needUpdate = true;
			frontContainer.push_back(std::move(_Val));
		}

		template <class... _Valty>
		decltype(auto) emplace_front(_Valty &&... v) {
			needUpdate = true;
			return frontContainer.emplace_back(std::forward<_Valty>(v)...);
		}

		void push_back(const T &v) {
			backContainer.push_back(v);
		}

		void push_back(T &&_Val) {
			backContainer.push_back(std::move(_Val));
		}

		template <class... _Valty>
		decltype(auto) emplace_back(_Valty &&... v) {
			return backContainer.emplace_back(std::forward<_Valty>(v)...);
		}

		bool empty() const noexcept {
			return backContainer.empty() && frontContainer.empty();
		}

		size_t size() const noexcept {
			return backContainer.size() + frontContainer.size();
		}

		auto begin() noexcept {
			update();
			return backContainer.begin();
		}

		auto end() noexcept {
			return backContainer.end();
		}

		void clear() noexcept {
			frontContainer.clear();
			return backContainer.clear();
		}

		void reserve(size_t newCap) noexcept {
			backContainer.reserve(newCap);
			frontContainer.reserve(newCap);
		}

		const auto &data() noexcept {
			update();
			return backContainer;
		}

		T &operator[](const size_t i) {
			update();
			return backContainer[i];
		}

	private:
		inline void update() noexcept {
			if (!needUpdate) {
				return;
			}

			needUpdate = false;
			std::ranges::reverse(frontContainer);
			frontContainer.insert(frontContainer.end(), make_move_iterator(backContainer.begin()), make_move_iterator(backContainer.end()));
			backContainer.clear();
			backContainer.insert(backContainer.end(), make_move_iterator(frontContainer.begin()), make_move_iterator(frontContainer.end()));
			frontContainer.clear();
		}

		std::vector<T> backContainer;
		std::vector<T> frontContainer;

		bool needUpdate = false;
	};
}
