/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "qtreenode.h"
#include <creatures/creature.h>

template <typename T>
bool QTreeLeafNode<T>::newLeaf = false;

template <typename T>
void QTreeLeafNode<T>::addCreature(Creature* c) {
	creature_list.push_back(c);

	if (c->getPlayer()) {
		player_list.push_back(c);
	}
}

template <typename T>
void QTreeLeafNode<T>::removeCreature(Creature* c) {
	auto iter = std::find(creature_list.begin(), creature_list.end(), c);
	assert(iter != creature_list.end());
	*iter = creature_list.back();
	creature_list.pop_back();

	if (c->getPlayer()) {
		iter = std::find(player_list.begin(), player_list.end(), c);
		assert(iter != player_list.end());
		*iter = player_list.back();
		player_list.pop_back();
	}
}

template <typename T>
QTreeLeafNode<T>* QTreeNode<T>::getLeaf(uint32_t x, uint32_t y) {
	if (leaf)
		return static_cast<QTreeLeafNode<T>*>(this);

	const auto node = child[((x & 0x8000) >> 15) | ((y & 0x8000) >> 14)];
	return node ? node->getLeaf(x << 1, y << 1) : nullptr;
}

template <typename T>
QTreeLeafNode<T>* QTreeNode<T>::createLeaf(uint32_t x, uint32_t y, uint32_t level) {
	if (isLeaf())
		return static_cast<QTreeLeafNode<T>*>(this);

	const uint32_t index = ((x & 0x8000) >> 15) | ((y & 0x8000) >> 14);
	if (!child[index]) {
		if (level != FLOOR_BITS) {
			child[index] = new QTreeNode<T>();
		} else {
			child[index] = new QTreeLeafNode<T>();
			QTreeLeafNode<T>::newLeaf = true;
		}
	}

	return child[index]->createLeaf(x * 2, y * 2, level - 1);
}

template <typename T>
QTreeLeafNode<T>* QTreeNode<T>::getBestLeaf(uint32_t x, uint32_t y, uint32_t level) {
	QTreeLeafNode<T>::newLeaf = false;
	auto leaf = createLeaf(x, y, 15);

	if (QTreeLeafNode<T>::newLeaf) {
		// update north
		if (const auto northLeaf = getLeaf(x, y - FLOOR_SIZE)) {
			northLeaf->leafS = leaf;
		}

		// update west leaf
		if (const auto westLeaf = getLeaf(x - FLOOR_SIZE, y)) {
			westLeaf->leafE = leaf;
		}

		// update south
		if (const auto southLeaf = getLeaf(x, y + FLOOR_SIZE)) {
			leaf->leafS = southLeaf;
		}

		// update east
		if (const auto eastLeaf = getLeaf(x + FLOOR_SIZE, y)) {
			leaf->leafE = eastLeaf;
		}
	}

	return leaf;
}
