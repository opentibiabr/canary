/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "astarnodes.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/combat/combat.hpp"

AStarNodes::AStarNodes(uint32_t x, uint32_t y) :
	nodes(), openNodes() {
	curNode = 1;
	closedNodes = 0;
	openNodes[0] = true;

	AStarNode &startNode = nodes[0];
	startNode.parent = nullptr;
	startNode.x = x;
	startNode.y = y;
	startNode.f = 0;
	nodeTable[(x << 16) | y] = nodes;
}

AStarNode* AStarNodes::createOpenNode(AStarNode* parent, uint32_t x, uint32_t y, int_fast32_t f) {
	if (curNode >= MAX_NODES) {
		return nullptr;
	}

	size_t retNode = curNode++;
	openNodes[retNode] = true;

	AStarNode* node = nodes + retNode;
	nodeTable[(x << 16) | y] = node;
	node->parent = parent;
	node->x = x;
	node->y = y;
	node->f = f;
	return node;
}

AStarNode* AStarNodes::getBestNode() {
	if (curNode == 0) {
		return nullptr;
	}

	int32_t best_node_f = std::numeric_limits<int32_t>::max();
	int32_t best_node = -1;
	for (size_t i = 0; i < curNode; i++) {
		if (openNodes[i] && nodes[i].f < best_node_f) {
			best_node_f = nodes[i].f;
			best_node = i;
		}
	}

	if (best_node >= 0) {
		return nodes + best_node;
	}
	return nullptr;
}

void AStarNodes::closeNode(const AStarNode* node) {
	size_t index = node - nodes;
	assert(index < MAX_NODES);
	openNodes[index] = false;
	++closedNodes;
}

void AStarNodes::openNode(const AStarNode* node) {
	size_t index = node - nodes;
	assert(index < MAX_NODES);
	if (!openNodes[index]) {
		openNodes[index] = true;
		--closedNodes;
	}
}

int_fast32_t AStarNodes::getClosedNodes() const {
	return closedNodes;
}

AStarNode* AStarNodes::getNodeByPosition(uint32_t x, uint32_t y) {
	auto it = nodeTable.find((x << 16) | y);
	if (it == nodeTable.end()) {
		return nullptr;
	}
	return it->second;
}

int_fast32_t AStarNodes::getMapWalkCost(AStarNode* node, const Position &neighborPos, bool preferDiagonal) {
	if (std::abs(node->x - neighborPos.x) == std::abs(node->y - neighborPos.y)) {
		// diagonal movement extra cost
		if (preferDiagonal) {
			return MAP_PREFERDIAGONALWALKCOST;
		} else {
			return MAP_DIAGONALWALKCOST;
		}
	}
	return MAP_NORMALWALKCOST;
}

int_fast32_t AStarNodes::getTileWalkCost(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &tile) {
	if (!creature || !tile) {
		return 0;
	}

	int_fast32_t cost = 0;
	if (tile->getTopVisibleCreature(creature) != nullptr) {
		// destroy creature cost
		cost += MAP_NORMALWALKCOST * 3;
	}

	if (const auto &field = tile->getFieldItem()) {
		const CombatType_t combatType = field->getCombatType();
		const auto &monster = creature->getMonster();

		if (!creature->isImmune(combatType) && !creature->hasCondition(Combat::DamageToConditionType(combatType)) && (monster && !monster->canWalkOnFieldType(combatType))) {
			cost += MAP_NORMALWALKCOST * 18;
		}
		/**
		 * Make player try to avoid magic fields, when calculating pathing
		 */
		const auto &player = creature->getPlayer();
		if (player && !field->isBlocking() && field->getDamage() != 0) {
			cost += MAP_NORMALWALKCOST * 18;
		}
	}
	return cost;
}
