/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "spectators.hpp"
#include "game/game.hpp"

phmap::flat_hash_map<Position, SpectatorsCache> Spectators::spectatorsCache;

void Spectators::clearCache() {
	spectatorsCache.clear();
}

bool Spectators::checkCache(const SpectatorsCache::FloorData &specData, bool onlyPlayers, const Position &centerPos, bool checkDistance, bool multifloor, int32_t minRangeX, int32_t maxRangeX, int32_t minRangeY, int32_t maxRangeY) {
	const auto &list = multifloor || !specData.floor ? specData.multiFloor : specData.floor;

	if (!list) {
		return false;
	}

	if (!multifloor && !specData.floor) {
		// Force check the distance of creatures as we only need to pick up creatures from the Floor(centerPos.z)
		checkDistance = true;
	}

	if (checkDistance) {
		SpectatorList spectators;
		spectators.reserve(creatures.size());
		for (const auto creature : *list) {
			const auto &specPos = creature->getPosition();
			if (centerPos.x - specPos.x >= minRangeX
				&& centerPos.y - specPos.y >= minRangeY
				&& centerPos.x - specPos.x <= maxRangeX
				&& centerPos.y - specPos.y <= maxRangeY
				&& (multifloor || specPos.z == centerPos.z)
				&& (!onlyPlayers || creature->getPlayer())) {
				spectators.emplace_back(creature);
			}
		}
		insertAll(spectators);
	} else {
		insertAll(*list);
	}

	return true;
}

Spectators Spectators::find(const Position &centerPos, bool multifloor, bool onlyPlayers, int32_t minRangeX, int32_t maxRangeX, int32_t minRangeY, int32_t maxRangeY) {
	minRangeX = (minRangeX == 0 ? -MAP_MAX_VIEW_PORT_X : -minRangeX);
	maxRangeX = (maxRangeX == 0 ? MAP_MAX_VIEW_PORT_X : maxRangeX);
	minRangeY = (minRangeY == 0 ? -MAP_MAX_VIEW_PORT_Y : -minRangeY);
	maxRangeY = (maxRangeY == 0 ? MAP_MAX_VIEW_PORT_Y : maxRangeY);

	const auto &it = spectatorsCache.find(centerPos);
	const bool cacheFound = it != spectatorsCache.end();
	if (cacheFound) {
		auto &cache = it->second;
		if (minRangeX < cache.minRangeX || maxRangeX > cache.maxRangeX || minRangeY < cache.minRangeY || maxRangeY > cache.maxRangeY) {
			// recache with new range
			cache.minRangeX = minRangeX = std::min<int32_t>(minRangeX, cache.minRangeX);
			cache.minRangeY = minRangeY = std::min<int32_t>(minRangeY, cache.minRangeY);
			cache.maxRangeX = maxRangeX = std::max<int32_t>(maxRangeX, cache.maxRangeX);
			cache.maxRangeY = maxRangeY = std::max<int32_t>(maxRangeY, cache.maxRangeY);
		} else {
			const bool checkDistance = minRangeX != cache.minRangeX || maxRangeX != cache.maxRangeX || minRangeY != cache.minRangeY || maxRangeY != cache.maxRangeY;

			if (onlyPlayers) {
				// check players cache
				if (checkCache(cache.players, true, centerPos, checkDistance, multifloor, minRangeX, maxRangeX, minRangeY, maxRangeY)) {
					return *this;
				}

				// if there is no player cache, look for players in the creatures cache.
				if (checkCache(cache.creatures, true, centerPos, true, multifloor, minRangeX, maxRangeX, minRangeY, maxRangeY)) {
					return *this;
				}

				// All Creatures
			} else if (checkCache(cache.creatures, false, centerPos, checkDistance, multifloor, minRangeX, maxRangeX, minRangeY, maxRangeY)) {
				return *this;
			}
		}
	}

	uint8_t minRangeZ = centerPos.z;
	uint8_t maxRangeZ = centerPos.z;

	if (multifloor) {
		if (centerPos.z > MAP_INIT_SURFACE_LAYER) {
			minRangeZ = static_cast<uint8_t>(std::max<int8_t>(centerPos.z - MAP_LAYER_VIEW_LIMIT, 0u));
			maxRangeZ = static_cast<uint8_t>(std::min<int8_t>(centerPos.z + MAP_LAYER_VIEW_LIMIT, MAP_MAX_LAYERS - 1));
		} else if (centerPos.z == MAP_INIT_SURFACE_LAYER - 1) {
			minRangeZ = 0;
			maxRangeZ = (MAP_INIT_SURFACE_LAYER - 1) + MAP_LAYER_VIEW_LIMIT;
		} else if (centerPos.z == MAP_INIT_SURFACE_LAYER) {
			minRangeZ = 0;
			maxRangeZ = MAP_INIT_SURFACE_LAYER + MAP_LAYER_VIEW_LIMIT;
		} else {
			minRangeZ = 0;
			maxRangeZ = MAP_INIT_SURFACE_LAYER;
		}
	}

	const int_fast32_t min_y = centerPos.y + minRangeY;
	const int_fast32_t min_x = centerPos.x + minRangeX;
	const int_fast32_t max_y = centerPos.y + maxRangeY;
	const int_fast32_t max_x = centerPos.x + maxRangeX;

	const int_fast16_t minoffset = centerPos.getZ() - maxRangeZ;
	const int_fast32_t x1 = std::min<int_fast32_t>(0xFFFF, std::max<int_fast32_t>(0, (min_x + minoffset)));
	const int_fast32_t y1 = std::min<int_fast32_t>(0xFFFF, std::max<int_fast32_t>(0, (min_y + minoffset)));

	const int_fast16_t maxoffset = centerPos.getZ() - minRangeZ;
	const int_fast32_t x2 = std::min<int_fast32_t>(0xFFFF, std::max<int_fast32_t>(0, (max_x + maxoffset)));
	const int_fast32_t y2 = std::min<int_fast32_t>(0xFFFF, std::max<int_fast32_t>(0, (max_y + maxoffset)));

	const uint_fast16_t startx1 = x1 - (x1 % FLOOR_SIZE);
	const uint_fast16_t starty1 = y1 - (y1 % FLOOR_SIZE);
	const uint_fast16_t endx2 = x2 - (x2 % FLOOR_SIZE);
	const uint_fast16_t endy2 = y2 - (y2 % FLOOR_SIZE);

	const auto startLeaf = g_game().map.getQTNode(static_cast<uint16_t>(startx1), static_cast<uint16_t>(starty1));
	const QTreeLeafNode* leafS = startLeaf;
	const QTreeLeafNode* leafE;

	SpectatorList spectators;
	spectators.reserve(std::max<uint8_t>(MAP_MAX_VIEW_PORT_X, MAP_MAX_VIEW_PORT_Y) * 2);

	for (uint_fast16_t ny = starty1; ny <= endy2; ny += FLOOR_SIZE) {
		leafE = leafS;
		for (uint_fast16_t nx = startx1; nx <= endx2; nx += FLOOR_SIZE) {
			if (leafE) {
				const auto &node_list = (onlyPlayers ? leafE->player_list : leafE->creature_list);
				for (const auto creature : node_list) {
					const auto &cpos = creature->getPosition();
					if (minRangeZ > cpos.z || maxRangeZ < cpos.z) {
						continue;
					}

					const int_fast16_t offsetZ = Position::getOffsetZ(centerPos, cpos);
					if ((min_y + offsetZ) > cpos.y || (max_y + offsetZ) < cpos.y || (min_x + offsetZ) > cpos.x || (max_x + offsetZ) < cpos.x) {
						continue;
					}

					spectators.emplace_back(creature);
				}
				leafE = leafE->leafE;
			} else {
				leafE = g_game().map.getQTNode(static_cast<uint16_t>(nx + FLOOR_SIZE), static_cast<uint16_t>(ny));
			}
		}

		if (leafS) {
			leafS = leafS->leafS;
		} else {
			leafS = g_game().map.getQTNode(static_cast<uint16_t>(startx1), static_cast<uint16_t>(ny + FLOOR_SIZE));
		}
	}

	// It is necessary to create the cache even if no spectators is found, so that there is no future query.
	auto &cache = cacheFound ? it->second : spectatorsCache.emplace(centerPos, SpectatorsCache { .minRangeX = minRangeX, .maxRangeX = maxRangeX, .minRangeY = minRangeY, .maxRangeY = maxRangeY }).first->second;
	auto &creaturesCache = onlyPlayers ? cache.players : cache.creatures;
	auto &creatureList = (multifloor ? creaturesCache.multiFloor : creaturesCache.floor);
	if (creatureList) {
		creatureList->clear();
	} else {
		creatureList.emplace();
	}

	if (!spectators.empty()) {
		insertAll(spectators);

		creatureList->insert(creatureList->end(), spectators.begin(), spectators.end());
	}

	return *this;
}
