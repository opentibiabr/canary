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

static SpectatorsCache creaturesCache;
static SpectatorsCache playersCache;

void Spectators::clearCache() {
	creaturesCache.clear();
	playersCache.clear();
}

void Spectators::update() {
	if (!needUpdate) {
		return;
	}

	needUpdate = false;
#ifndef SPECTATORS_USE_HASHSET
	std::ranges::sort(creatures);
	const auto &[f, l] = std::ranges::unique(creatures);
	creatures.erase(f, l);
#endif
}

bool Spectators::checkCache(const SpectatorsCache &cache, bool onlyPlayers, const Position &centerPos, bool checkDistance, bool multifloor, int32_t minRangeX, int32_t maxRangeX, int32_t minRangeY, int32_t maxRangeY) {
	const auto &it = cache.find(centerPos);
	if (it == cache.end()) {
		return false;
	}

	const auto &list = multifloor ? it->second.first : it->second.second;
	if (checkDistance) {
		for (const auto creature : list) {
			const auto &specPos = creature->getPosition();
			if (centerPos.x - specPos.x >= minRangeX
				&& centerPos.y - specPos.y >= minRangeY
				&& centerPos.x - specPos.x <= maxRangeX
				&& centerPos.y - specPos.y <= maxRangeY) {
				if (!onlyPlayers || creature->getPlayer()) {
					insert(creature);
				}
			}
		}
	} else {
		insertAll(list);
	}

	return true;
}

Spectators &Spectators::find(const Position &centerPos, bool multifloor, bool onlyPlayers, int32_t minRangeX, int32_t maxRangeX, int32_t minRangeY, int32_t maxRangeY) {
	if (!creatures.empty()) {
		needUpdate = true;
	}

	minRangeX = (minRangeX == 0 ? -MAP_MAX_VIEW_PORT_X : -minRangeX);
	maxRangeX = (maxRangeX == 0 ? MAP_MAX_VIEW_PORT_X : maxRangeX);
	minRangeY = (minRangeY == 0 ? -MAP_MAX_VIEW_PORT_Y : -minRangeY);
	maxRangeY = (maxRangeY == 0 ? MAP_MAX_VIEW_PORT_Y : maxRangeY);

	const bool canCache = minRangeX == -MAP_MAX_VIEW_PORT_X && maxRangeX == MAP_MAX_VIEW_PORT_X && minRangeY == -MAP_MAX_VIEW_PORT_Y && maxRangeY == MAP_MAX_VIEW_PORT_Y;

	if (onlyPlayers) {
		// check on players cache
		if (checkCache(playersCache, true, centerPos, !canCache, multifloor, minRangeX, maxRangeX, minRangeY, maxRangeY)) {
			return *this;
		}

		// check in the cache that contain all the creatures
		if (checkCache(creaturesCache, true, centerPos, true, multifloor, minRangeX, maxRangeX, minRangeY, maxRangeY)) {
			return *this;
		}

		// All Creatures
	} else if (checkCache(creaturesCache, false, centerPos, !canCache, multifloor, minRangeX, maxRangeX, minRangeY, maxRangeY)) {
		return *this;
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
	const int_fast32_t x1 = std::min<uint32_t>(0xFFFF, std::max<int32_t>(0, (min_x + minoffset)));
	const int_fast32_t y1 = std::min<uint32_t>(0xFFFF, std::max<int32_t>(0, (min_y + minoffset)));

	const int_fast16_t maxoffset = centerPos.getZ() - minRangeZ;
	const int_fast32_t x2 = std::min<uint32_t>(0xFFFF, std::max<int32_t>(0, (max_x + maxoffset)));
	const int_fast32_t y2 = std::min<uint32_t>(0xFFFF, std::max<int32_t>(0, (max_y + maxoffset)));

	const int32_t startx1 = x1 - (x1 % FLOOR_SIZE);
	const int32_t starty1 = y1 - (y1 % FLOOR_SIZE);
	const int32_t endx2 = x2 - (x2 % FLOOR_SIZE);
	const int32_t endy2 = y2 - (y2 % FLOOR_SIZE);

	const auto startLeaf = g_game().map.getQTNode(startx1, starty1);
	const QTreeLeafNode* leafS = startLeaf;
	const QTreeLeafNode* leafE;

	SpectatorList spectators;
	spectators.reserve(std::max<uint8_t>(MAP_MAX_VIEW_PORT_X, MAP_MAX_VIEW_PORT_Y));

	for (int_fast32_t ny = starty1; ny <= endy2; ny += FLOOR_SIZE) {
		leafE = leafS;
		for (int_fast32_t nx = startx1; nx <= endx2; nx += FLOOR_SIZE) {
			if (leafE) {
				const auto &node_list = (onlyPlayers ? leafE->player_list : leafE->creature_list);
				for (const auto creature : node_list) {
					const auto &cpos = creature->getPosition();
					if (minRangeZ > cpos.z || maxRangeZ < cpos.z) {
						continue;
					}

					int_fast16_t offsetZ = Position::getOffsetZ(centerPos, cpos);
					if ((min_y + offsetZ) > cpos.y || (max_y + offsetZ) < cpos.y || (min_x + offsetZ) > cpos.x || (max_x + offsetZ) < cpos.x) {
						continue;
					}

#ifdef SPECTATORS_USE_HASHSET
					spectators.emplace(creature);
#else
					spectators.emplace_back(creature);
#endif
				}
				leafE = leafE->leafE;
			} else {
				leafE = g_game().map.getQTNode(nx + FLOOR_SIZE, ny);
			}
		}

		if (leafS) {
			leafS = leafS->leafS;
		} else {
			leafS = g_game().map.getQTNode(startx1, ny + FLOOR_SIZE);
		}
	}

	insertAll(spectators);

	if (canCache) {
		auto &hashmap = onlyPlayers ? playersCache : creaturesCache;
		auto &[floors, floor] = hashmap.try_emplace(centerPos).first->second;
		auto &spectatorsCache = (multifloor ? floors : floor);

#ifdef SPECTATORS_USE_HASHSET
		spectatorsCache.insert(spectators.begin(), spectators.end());
#else
		spectatorsCache.insert(spectatorsCache.end(), spectators.begin(), spectators.end());
#endif
	}

	return *this;
}

Spectators &Spectators::join(const Spectators &anotherSpectators) {
	insertAll(anotherSpectators.creatures);
	return *this;
}

Spectators &Spectators::insert(Creature* creature) {
#ifdef SPECTATORS_USE_HASHSET
	creatures.emplace(creature);
#else
	creatures.emplace_back(creature);
#endif
	return *this;
}

Spectators &Spectators::insertAll(const SpectatorList &list) {
#ifdef SPECTATORS_USE_HASHSET
	creatures.insert(list.begin(), list.end());
#else
	creatures.insert(creatures.end(), list.begin(), list.end());
#endif
	return *this;
}

bool Spectators::contains(const Creature* creature) const {
#ifdef SPECTATORS_USE_HASHSET
	return creatures.contains(creature);
#else
	return std::ranges::find(creatures.begin(), creatures.end(), creature) != creatures.end();
#endif
}

bool Spectators::erase(const Creature* creature) {
	update();
#ifdef SPECTATORS_USE_HASHSET
	return creatures.erase(creature) > 0;
#else
	const auto &it = std::ranges::find(creatures.begin(), creatures.end(), creature);
	if (it == creatures.end()) {
		return false;
	}
	creatures.erase(it);
	return true;
#endif
}
