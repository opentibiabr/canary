/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/creature.hpp"
#include "qtreenode.hpp"

bool QTreeLeafNode::newLeaf = false;

QTreeLeafNode* QTreeNode::getLeaf(uint32_t x, uint32_t y) {
	if (leaf) {
		return static_cast<QTreeLeafNode*>(this);
	}

	const auto node = child[((x & 0x8000) >> 15) | ((y & 0x8000) >> 14)];
	return node ? node->getLeaf(x << 1, y << 1) : nullptr;
}

QTreeLeafNode* QTreeNode::createLeaf(uint32_t x, uint32_t y, uint32_t level) {
	if (isLeaf()) {
		return static_cast<QTreeLeafNode*>(this);
	}

	const uint32_t index = ((x & 0x8000) >> 15) | ((y & 0x8000) >> 14);
	if (!child[index]) {
		if (level != FLOOR_BITS) {
			child[index] = new QTreeNode();
		} else {
			child[index] = new QTreeLeafNode();
			QTreeLeafNode::newLeaf = true;
		}
	}

	return child[index]->createLeaf(x * 2, y * 2, level - 1);
}

QTreeLeafNode* QTreeNode::getBestLeaf(uint32_t x, uint32_t y, uint32_t level) {
	QTreeLeafNode::newLeaf = false;
	auto tempLeaf = createLeaf(x, y, level);

	if (QTreeLeafNode::newLeaf) {
		// update north
		if (const auto northLeaf = getLeaf(x, y - FLOOR_SIZE)) {
			northLeaf->leafS = tempLeaf;
		}

		// update west leaf
		if (const auto westLeaf = getLeaf(x - FLOOR_SIZE, y)) {
			westLeaf->leafE = tempLeaf;
		}

		// update south
		if (const auto southLeaf = getLeaf(x, y + FLOOR_SIZE)) {
			tempLeaf->leafS = southLeaf;
		}

		// update east
		if (const auto eastLeaf = getLeaf(x + FLOOR_SIZE, y)) {
			tempLeaf->leafE = eastLeaf;
		}
	}

	return tempLeaf;
}

void QTreeLeafNode::addCreature(const std::shared_ptr<Creature> &c) {
	creature_list.push_back(c);

	if (c->getPlayer()) {
		player_list.push_back(c);
	}
}

void QTreeLeafNode::removeCreature(std::shared_ptr<Creature> c) {
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
