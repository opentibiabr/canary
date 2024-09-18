/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

struct Position;
class Creature;
class Tile;

struct AStarNode {
	AStarNode* parent;
	int_fast32_t f, g, c;
	uint16_t x, y;
};

class AStarNodes {
public:
	AStarNodes(uint32_t x, uint32_t y, int_fast32_t extraCost);

	bool createOpenNode(AStarNode* parent, uint32_t x, uint32_t y, int_fast32_t f, int_fast32_t heuristic, int_fast32_t extraCost);
	AStarNode* getBestNode();
	void closeNode(const AStarNode* node);
	void openNode(const AStarNode* node);
	int32_t getClosedNodes() const;
	AStarNode* getNodeByPosition(uint32_t x, uint32_t y);

	static int_fast32_t getMapWalkCost(AStarNode* node, const Position &neighborPos);
	static int_fast32_t getTileWalkCost(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &tile);

private:
	static constexpr int32_t MAX_NODES = 512;
	static constexpr int32_t MAP_NORMALWALKCOST = 10;
	static constexpr int32_t MAP_PREFERDIAGONALWALKCOST = 14;
	static constexpr int32_t MAP_DIAGONALWALKCOST = 25;

#if defined(__SSE2__)
	alignas(16) uint32_t nodesTable[MAX_NODES];
	alignas(64) int32_t calculatedNodes[MAX_NODES];
	AStarNode nodes[MAX_NODES];
#else
	AStarNode nodes[MAX_NODES];
	uint32_t nodesTable[MAX_NODES];
#endif
	int32_t closedNodes;
	int32_t curNode;
	bool openNodes[MAX_NODES];
};
