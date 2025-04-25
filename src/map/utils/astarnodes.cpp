/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "map/utils/astarnodes.hpp"

#include "creatures/combat/combat.hpp"
#include "creatures/monsters/monster.hpp"
#include "items/tile.hpp"

AStarNodes::AStarNodes(uint32_t x, uint32_t y, int_fast32_t extraCost) :
#if defined(__AVX2__) || defined(__SSE2__)
	nodesTable(), // 1. nodesTable
	calculatedNodes(), // 2. calculatedNodes
	nodes(), // 3. nodes
	closedNodes(0), // 4. closedNodes
	curNode(0), // 5. curNode
	openNodes() // 6. openNodes
#else
	nodes(), // 1. nodes
	nodesTable(), // 2. nodesTable
	closedNodes(0), // 3. closedNodes
	curNode(0), // 4. curNode
	openNodes() // 5. openNodes
#endif
{
#if defined(__AVX2__)
	__m256i defaultCost = _mm256_set1_epi32(std::numeric_limits<int32_t>::max());
	for (int32_t i = 0; i < MAX_NODES; i += 32) {
		_mm256_stream_si256(reinterpret_cast<__m256i*>(&calculatedNodes[i + 0]), defaultCost);
		_mm256_stream_si256(reinterpret_cast<__m256i*>(&calculatedNodes[i + 8]), defaultCost);
		_mm256_stream_si256(reinterpret_cast<__m256i*>(&calculatedNodes[i + 16]), defaultCost);
		_mm256_stream_si256(reinterpret_cast<__m256i*>(&calculatedNodes[i + 24]), defaultCost);
	}
	_mm_sfence();
#elif defined(__SSE2__)
	__m128i defaultCost = _mm_set1_epi32(std::numeric_limits<int32_t>::max());
	for (int32_t i = 0; i < MAX_NODES; i += 16) {
		_mm_stream_si128(reinterpret_cast<__m128i*>(&calculatedNodes[i + 0]), defaultCost);
		_mm_stream_si128(reinterpret_cast<__m128i*>(&calculatedNodes[i + 4]), defaultCost);
		_mm_stream_si128(reinterpret_cast<__m128i*>(&calculatedNodes[i + 8]), defaultCost);
		_mm_stream_si128(reinterpret_cast<__m128i*>(&calculatedNodes[i + 12]), defaultCost);
	}
	_mm_sfence();
#endif

	curNode = 1;
	closedNodes = 0;
	openNodes[0] = true;

	AStarNode &startNode = nodes[0];
	startNode.parent = nullptr;
	startNode.x = x;
	startNode.y = y;
	startNode.f = 0;
	startNode.g = 0;
	startNode.c = extraCost;
	nodesTable[0] = (x << 16) | y;
#if defined(__SSE2__) || defined(__AVX2__)
	calculatedNodes[0] = 0;
#endif
}

bool AStarNodes::createOpenNode(AStarNode* parent, uint32_t x, uint32_t y, int_fast32_t f, int_fast32_t heuristic, int_fast32_t extraCost) {
	if (curNode >= MAX_NODES) {
		return false;
	}

	const int32_t retNode = curNode++;
	openNodes[retNode] = true;

	AStarNode &node = nodes[retNode];
	node.parent = parent;
	node.x = x;
	node.y = y;
	node.f = f;
	node.g = heuristic;
	node.c = extraCost;
	nodesTable[retNode] = (x << 16) | y;
#if defined(__SSE2__)
	calculatedNodes[retNode] = f + heuristic;
#endif
	return true;
}

AStarNode* AStarNodes::getBestNode() {
// Branchless best node search
#if defined(__AVX512F__)
	const __m512i increment = _mm512_set1_epi32(16);
	__m512i indices = _mm512_setr_epi32(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
	__m512i minindices = indices;
	__m512i minvalues = _mm512_load_si512(reinterpret_cast<const void*>(calculatedNodes));
	for (int32_t pos = 16; pos < curNode; pos += 16) {
		const __m512i values = _mm512_load_si512(reinterpret_cast<const void*>(&calculatedNodes[pos]));
		indices = _mm512_add_epi32(indices, increment);
		minindices = _mm512_mask_blend_epi32(_mm512_cmplt_epi32_mask(values, minvalues), minindices, indices);
		minvalues = _mm512_min_epi32(minvalues, values);
	}

	alignas(64) int32_t values_array[16];
	alignas(64) int32_t indices_array[16];
	_mm512_store_si512(reinterpret_cast<void*>(values_array), minvalues);
	_mm512_store_si512(reinterpret_cast<void*>(indices_array), minindices);

	int32_t best_node = indices_array[0];
	int32_t best_node_f = values_array[0];
	for (int32_t i = 1; i < 16; ++i) {
		int32_t total_cost = values_array[i];
		best_node = (total_cost < best_node_f ? indices_array[i] : best_node);
		best_node_f = (total_cost < best_node_f ? total_cost : best_node_f);
	}
	return (openNodes[best_node] ? &nodes[best_node] : nullptr);
#elif defined(__AVX2__)
	const __m256i increment = _mm256_set1_epi32(8);
	__m256i indices = _mm256_setr_epi32(0, 1, 2, 3, 4, 5, 6, 7);
	__m256i minindices = indices;
	__m256i minvalues = _mm256_load_si256(reinterpret_cast<const __m256i*>(calculatedNodes));
	for (int32_t pos = 8; pos < curNode; pos += 8) {
		const __m256i values = _mm256_load_si256(reinterpret_cast<const __m256i*>(&calculatedNodes[pos]));
		indices = _mm256_add_epi32(indices, increment);
		minindices = _mm256_blendv_epi8(minindices, indices, _mm256_cmpgt_epi32(minvalues, values));
		minvalues = _mm256_min_epi32(values, minvalues);
	}

	__m256i res = _mm256_min_epi32(minvalues, _mm256_shuffle_epi32(minvalues, _MM_SHUFFLE(2, 3, 0, 1))); // Calculate horizontal minimum
	res = _mm256_min_epi32(res, _mm256_shuffle_epi32(res, _MM_SHUFFLE(0, 1, 2, 3))); // Calculate horizontal minimum
	res = _mm256_min_epi32(res, _mm256_permutevar8x32_epi32(res, _mm256_set_epi32(0, 1, 2, 3, 4, 5, 6, 7))); // Calculate horizontal minimum

	alignas(32) int32_t indices_array[8];
	_mm256_store_si256(reinterpret_cast<__m256i*>(indices_array), minindices);

	int32_t best_node = indices_array[(mm_ctz(_mm256_movemask_epi8(_mm256_cmpeq_epi32(minvalues, res))) >> 2)];
	return (openNodes[best_node] ? &nodes[best_node] : nullptr);
#elif defined(__SSE4_1__)
	const __m128i increment = _mm_set1_epi32(4);
	__m128i indices = _mm_setr_epi32(0, 1, 2, 3);
	__m128i minindices = indices;
	__m128i minvalues = _mm_load_si128(reinterpret_cast<const __m128i*>(calculatedNodes));
	for (int32_t pos = 4; pos < curNode; pos += 4) {
		const __m128i values = _mm_load_si128(reinterpret_cast<const __m128i*>(&calculatedNodes[pos]));
		indices = _mm_add_epi32(indices, increment);
		minindices = _mm_blendv_epi8(minindices, indices, _mm_cmplt_epi32(values, minvalues));
		minvalues = _mm_min_epi32(values, minvalues);
	}

	__m128i res = _mm_min_epi32(minvalues, _mm_shuffle_epi32(minvalues, _MM_SHUFFLE(2, 3, 0, 1))); // Calculate horizontal minimum
	res = _mm_min_epi32(res, _mm_shuffle_epi32(res, _MM_SHUFFLE(0, 1, 2, 3))); // Calculate horizontal minimum

	alignas(16) int32_t indices_array[4];
	_mm_store_si128(reinterpret_cast<__m128i*>(indices_array), minindices);

	int32_t best_node = indices_array[(mm_ctz(_mm_movemask_epi8(_mm_cmpeq_epi32(minvalues, res))) >> 2)];
	return (openNodes[best_node] ? &nodes[best_node] : NULL);
#elif defined(__SSE2__)
	auto _mm_sse2_min_epi32 = [](const __m128i a, const __m128i b) {
		__m128i mask = _mm_cmpgt_epi32(a, b);
		return _mm_or_si128(_mm_and_si128(mask, b), _mm_andnot_si128(mask, a));
	};

	auto _mm_sse2_blendv_epi8 = [](const __m128i a, const __m128i b, __m128i mask) {
		mask = _mm_cmplt_epi8(mask, _mm_setzero_si128());
		return _mm_or_si128(_mm_andnot_si128(mask, a), _mm_and_si128(mask, b));
	};

	const __m128i increment = _mm_set1_epi32(4);
	__m128i indices = _mm_setr_epi32(0, 1, 2, 3);
	__m128i minindices = indices;
	__m128i minvalues = _mm_load_si128(reinterpret_cast<const __m128i*>(calculatedNodes));
	for (int32_t pos = 4; pos < curNode; pos += 4) {
		const __m128i values = _mm_load_si128(reinterpret_cast<const __m128i*>(&calculatedNodes[pos]));
		indices = _mm_add_epi32(indices, increment);
		minindices = _mm_sse2_blendv_epi8(minindices, indices, _mm_cmplt_epi32(values, minvalues));
		minvalues = _mm_sse2_min_epi32(values, minvalues);
	}

	__m128i res = _mm_sse2_min_epi32(minvalues, _mm_shuffle_epi32(minvalues, _MM_SHUFFLE(2, 3, 0, 1))); // Calculate horizontal minimum
	res = _mm_sse2_min_epi32(res, _mm_shuffle_epi32(res, _MM_SHUFFLE(0, 1, 2, 3))); // Calculate horizontal minimum

	alignas(16) int32_t indices_array[4];
	_mm_store_si128(reinterpret_cast<__m128i*>(indices_array), minindices);

	int32_t best_node = indices_array[(mm_ctz(_mm_movemask_epi8(_mm_cmpeq_epi32(minvalues, res))) >> 2)];
	return (openNodes[best_node] ? &nodes[best_node] : nullptr);
#else
	int32_t best_node_f = std::numeric_limits<int32_t>::max();
	int32_t best_node = -1;
	for (int32_t pos = 0; pos < curNode; ++pos) {
		if (!openNodes[pos]) {
			continue;
		}

		int32_t total_cost = nodes[pos].f + nodes[pos].g;
		best_node = (total_cost < best_node_f ? pos : best_node);
		best_node_f = (total_cost < best_node_f ? total_cost : best_node_f);
	}
	return (best_node != -1 ? &nodes[best_node] : nullptr);
#endif
}

void AStarNodes::closeNode(const AStarNode* node) {
	const size_t index = node - nodes;
	assert(index < MAX_NODES);
#if defined(__SSE2__)
	calculatedNodes[index] = std::numeric_limits<int32_t>::max();
#endif
	openNodes[index] = false;
	++closedNodes;
}

void AStarNodes::openNode(const AStarNode* node) {
	const size_t index = node - nodes;
	assert(index < MAX_NODES);
#if defined(__SSE2__)
	calculatedNodes[index] = nodes[index].f + nodes[index].g;
#endif
	closedNodes -= (openNodes[index] ? 0 : 1);
	openNodes[index] = true;
}

int32_t AStarNodes::getClosedNodes() const {
	return closedNodes;
}

AStarNode* AStarNodes::getNodeByPosition(uint32_t x, uint32_t y) {
	uint32_t xy = (x << 16) | y;
#if defined(__SSE2__)
	const __m128i key = _mm_set1_epi32(xy);

	int32_t pos = 0;
	int32_t curRound = curNode - 16;
	for (; pos <= curRound; pos += 16) {
		__m128i v[4];
		v[0] = _mm_cmpeq_epi32(_mm_load_si128(reinterpret_cast<const __m128i*>(&nodesTable[pos])), key);
		v[1] = _mm_cmpeq_epi32(_mm_load_si128(reinterpret_cast<const __m128i*>(&nodesTable[pos + 4])), key);
		v[2] = _mm_cmpeq_epi32(_mm_load_si128(reinterpret_cast<const __m128i*>(&nodesTable[pos + 8])), key);
		v[3] = _mm_cmpeq_epi32(_mm_load_si128(reinterpret_cast<const __m128i*>(&nodesTable[pos + 12])), key);
		const uint32_t mask = _mm_movemask_epi8(_mm_packs_epi16(_mm_packs_epi32(v[0], v[1]), _mm_packs_epi32(v[2], v[3])));
		if (mask != 0) {
			return &nodes[pos + mm_ctz(mask)];
		}
	}
	curRound = curNode - 8;
	if (pos <= curRound) {
		__m128i v[2];
		v[0] = _mm_cmpeq_epi32(_mm_load_si128(reinterpret_cast<const __m128i*>(&nodesTable[pos])), key);
		v[1] = _mm_cmpeq_epi32(_mm_load_si128(reinterpret_cast<const __m128i*>(&nodesTable[pos + 4])), key);
		const uint32_t mask = _mm_movemask_epi8(_mm_packs_epi32(v[0], v[1]));
		if (mask != 0) {
			return &nodes[pos + (mm_ctz(mask) >> 1)];
		}
		pos += 8;
	}
	for (; pos < curNode; ++pos) {
		if (nodesTable[pos] == xy) {
			return &nodes[pos];
		}
	}
	return nullptr;
#else
	for (int32_t i = 1; i < curNode; ++i) {
		if (nodesTable[i] == xy) {
			return &nodes[i];
		}
	}
	return (nodesTable[0] == xy ? &nodes[0] : nullptr); // The first node is very unlikely to be the "neighbor" so leave it for end
#endif
}

int_fast32_t AStarNodes::getMapWalkCost(const AStarNode* node, const Position &neighborPos) {
	// diagonal movement extra cost
	return (((std::abs(node->x - neighborPos.x) + std::abs(node->y - neighborPos.y)) - 1) * MAP_DIAGONALWALKCOST) + MAP_NORMALWALKCOST;
}

int_fast32_t AStarNodes::getTileWalkCost(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &tile) {
	int_fast32_t cost = 0;

	if (creature && tile) {
		// Destroy creature cost
		if (tile->getTopVisibleCreature(creature) != nullptr) {
			cost += MAP_NORMALWALKCOST * 4;
		}
		if (const auto &field = tile->getFieldItem()) {
			const CombatType_t combatType = field->getCombatType();
			if (combatType != COMBAT_NONE && !creature->isImmune(combatType) && !creature->hasCondition(Combat::DamageToConditionType(combatType)) && (creature->getMonster() && !creature->getMonster()->canWalkOnFieldType(combatType))) {
				cost += MAP_NORMALWALKCOST * 18;
			}
		}
	}

	return cost;
}
