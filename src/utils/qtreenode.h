#pragma once

#include <pch.hpp>

static constexpr int32_t FLOOR_BITS = 3;
static constexpr int32_t FLOOR_SIZE = (1 << FLOOR_BITS);
static constexpr int32_t FLOOR_MASK = (FLOOR_SIZE - 1);

class Creature;
using CreatureVector = std::vector<Creature*>;

template <typename T>
class QTreeLeafNode;

template <typename T>
class QTreeNode {
	public:
		constexpr QTreeNode() = default;
		~QTreeNode() {
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

		QTreeLeafNode<T>* getLeaf(uint32_t x, uint32_t y);

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
			return array[z] ? array[z] : (array[z] = std::make_unique<T>());
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

		// MAP_MAX_LAYERS
		std::unique_ptr<T> array[16] = {};

		CreatureVector creature_list;
		CreatureVector player_list;

		friend class Map;
		friend class MapCache;
		friend class QTreeNode<T>;
};
