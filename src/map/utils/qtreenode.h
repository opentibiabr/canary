/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <pch.hpp>
#include <map/map_const.h>

template <typename T>
class QTreeLeafNode;
class Creature;

template <typename T>
class QTreeNode {
	public:
		constexpr QTreeNode() = default;

		virtual ~QTreeNode() {
			for (auto* ptr : child) {
				delete ptr;
			}
		};

		// non-copyable
		QTreeNode(const QTreeNode &) = delete;
		QTreeNode &operator=(const QTreeNode &) = delete;

		bool isLeaf() const {
			return leaf;
		}

		template <typename Leaf, typename Node>
		static Leaf getLeafStatic(Node node, uint32_t x, uint32_t y) {
			do {
				node = node->child[((x & 0x8000) >> 15) | ((y & 0x8000) >> 14)];
				if (!node) {
					return nullptr;
				}

				x <<= 1;
				y <<= 1;
			} while (!node->leaf);
			return static_cast<Leaf>(node);
		}

		QTreeLeafNode<T>* getLeaf(uint32_t x, uint32_t y);
		QTreeLeafNode<T>* createLeaf(uint32_t x, uint32_t y, uint32_t level);
		QTreeLeafNode<T>* getBestLeaf(uint32_t x, uint32_t y, uint32_t level);

	protected:
		QTreeNode<T>* child[4] = {};

		bool leaf = false;
};

template <typename T>
class QTreeLeafNode final : public QTreeNode<T> {
	public:
		QTreeLeafNode() {
			QTreeNode<T>::leaf = true;
			newLeaf = true;
		}

		// non-copyable
		QTreeLeafNode(const QTreeLeafNode &) = delete;
		QTreeLeafNode &operator=(const QTreeLeafNode &) = delete;

		const std::unique_ptr<T> &createFloor(uint32_t z) {
			return array[z] ? array[z] : (array[z] = std::make_unique<T>(z));
		}

		const std::unique_ptr<T> &getFloor(uint8_t z) const {
			return array[z];
		}

		void addCreature(Creature* c);
		void removeCreature(Creature* c);

	private:
		static bool newLeaf;
		QTreeLeafNode* leafS = nullptr;
		QTreeLeafNode* leafE = nullptr;

		std::unique_ptr<T> array[MAP_MAX_LAYERS] = {};

		std::vector<Creature*> creature_list;
		std::vector<Creature*> player_list;

		friend class Map;
		friend class MapCache;
		friend class QTreeNode<T>;
};
