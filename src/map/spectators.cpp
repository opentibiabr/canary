/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "map/spectators.hpp"

#include "creatures/creature.hpp"
#include "game/game.hpp"

phmap::flat_hash_map<Position, SpectatorsCache> Spectators::spectatorsCache;

void Spectators::clearCache() {
	spectatorsCache.clear();
}

Spectators Spectators::insert(const std::shared_ptr<Creature> &creature) {
	if (creature) {
		creatures.emplace_back(creature);
	}
	return *this;
}

Spectators Spectators::insertAll(const CreatureVector &list) {
	if (!list.empty()) {
		const bool hasValue = !creatures.empty();

		creatures.insert(creatures.end(), list.begin(), list.end());

		// Remove duplicate
		if (hasValue) {
			std::unordered_set uset(creatures.begin(), creatures.end());
			creatures.clear();
			creatures.insert(creatures.end(), uset.begin(), uset.end());
		}
	}
	return *this;
}

bool Spectators::checkCache(const SpectatorsCache::FloorData &specData, bool onlyPlayers, bool onlyMonsters, bool onlyNpcs, const Position &centerPos, bool checkDistance, bool multifloor, int32_t minRangeX, int32_t maxRangeX, int32_t minRangeY, int32_t maxRangeY) {
	const auto &list = multifloor || !specData.floor ? specData.multiFloor : specData.floor;

	if (!list) {
		return false;
	}

	if (!multifloor && !specData.floor) {
		// Force check the distance of creatures as we only need to pick up creatures from the Floor(centerPos.z)
		checkDistance = true;
	}

	if (checkDistance) {
		CreatureVector spectators;
		spectators.reserve(creatures.size());
		for (const auto &creature : *list) {
			const auto &specPos = creature->getPosition();
			if ((centerPos.x - specPos.x >= minRangeX
			         && centerPos.y - specPos.y >= minRangeY
			         && centerPos.x - specPos.x <= maxRangeX
			         && centerPos.y - specPos.y <= maxRangeY
			         && (multifloor || specPos.z == centerPos.z)
			         && ((onlyPlayers && creature->getPlayer())
			             || (onlyMonsters && creature->getMonster())
			             || (onlyNpcs && creature->getNpc()))
			     || (!onlyPlayers && !onlyMonsters && !onlyNpcs))) {
				spectators.emplace_back(creature);
			}
		}
		insertAll(spectators);
	} else {
		insertAll(*list);
	}

	return true;
}

CreatureVector Spectators::getSpectators(const Position &centerPos, bool multifloor, bool onlyPlayers, bool onlyMonsters, bool onlyNpcs, int32_t minRangeX, int32_t maxRangeX, int32_t minRangeY, int32_t maxRangeY) {
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

	const int32_t min_y = centerPos.y + minRangeY;
	const int32_t min_x = centerPos.x + minRangeX;
	const int32_t max_y = centerPos.y + maxRangeY;
	const int32_t max_x = centerPos.x + maxRangeX;

	const auto width = static_cast<uint32_t>(max_x - min_x);
	const auto height = static_cast<uint32_t>(max_y - min_y);
	const auto depth = static_cast<uint32_t>(maxRangeZ - minRangeZ);

	const int32_t minoffset = centerPos.getZ() - maxRangeZ;
	const int32_t x1 = std::min<int32_t>(0xFFFF, std::max<int32_t>(0, min_x + minoffset));
	const int32_t y1 = std::min<int32_t>(0xFFFF, std::max<int32_t>(0, min_y + minoffset));

	const int32_t maxoffset = centerPos.getZ() - minRangeZ;
	const int32_t x2 = std::min<int32_t>(0xFFFF, std::max<int32_t>(0, max_x + maxoffset));
	const int32_t y2 = std::min<int32_t>(0xFFFF, std::max<int32_t>(0, max_y + maxoffset));

	const int32_t startx1 = x1 - (x1 & SECTOR_MASK);
	const int32_t starty1 = y1 - (y1 & SECTOR_MASK);
	const int32_t endx2 = x2 - (x2 & SECTOR_MASK);
	const int32_t endy2 = y2 - (y2 & SECTOR_MASK);

	CreatureVector spectators;
	spectators.reserve(std::max<uint8_t>(MAP_MAX_VIEW_PORT_X, MAP_MAX_VIEW_PORT_Y) * 2);

	const MapSector* startSector = g_game().map.getMapSector(startx1, starty1);
	const MapSector* sectorS = startSector;
	for (int32_t ny = starty1; ny <= endy2; ny += SECTOR_SIZE) {
		const MapSector* sectorE = sectorS;
		for (int32_t nx = startx1; nx <= endx2; nx += SECTOR_SIZE) {
			if (sectorE) {
				const auto &nodeList = onlyPlayers ? sectorE->player_list
					: onlyMonsters                 ? sectorE->monster_list
					: onlyNpcs                     ? sectorE->npc_list
												   : sectorE->creature_list;

				for (const auto &creature : nodeList) {
					const auto &cpos = creature->getPosition();
					if (static_cast<uint32_t>(static_cast<int32_t>(cpos.z) - minRangeZ) <= depth) {
						const int_fast16_t offsetZ = Position::getOffsetZ(centerPos, cpos);
						if (static_cast<uint32_t>(cpos.x - offsetZ - min_x) <= width && static_cast<uint32_t>(cpos.y - offsetZ - min_y) <= height) {
							spectators.emplace_back(creature);
						}
					}
				}
				sectorE = sectorE->sectorE;
			} else {
				sectorE = g_game().map.getMapSector(nx + SECTOR_SIZE, ny);
			}
		}

		if (sectorS) {
			sectorS = sectorS->sectorS;
		} else {
			sectorS = g_game().map.getMapSector(startx1, ny + SECTOR_SIZE);
		}
	}

	return spectators;
}

Spectators Spectators::find(const Position &centerPos, bool multifloor, bool onlyPlayers, bool onlyMonsters, bool onlyNpcs, int32_t minRangeX, int32_t maxRangeX, int32_t minRangeY, int32_t maxRangeY, bool useCache) {
	minRangeX = (minRangeX == 0 ? -MAP_MAX_VIEW_PORT_X : -minRangeX);
	maxRangeX = (maxRangeX == 0 ? MAP_MAX_VIEW_PORT_X : maxRangeX);
	minRangeY = (minRangeY == 0 ? -MAP_MAX_VIEW_PORT_Y : -minRangeY);
	maxRangeY = (maxRangeY == 0 ? MAP_MAX_VIEW_PORT_Y : maxRangeY);

	if (!useCache) {
		insertAll(getSpectators(centerPos, multifloor, onlyPlayers, onlyMonsters, onlyNpcs, minRangeX, maxRangeX, minRangeY, maxRangeY));
		return *this;
	}

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

			if (onlyPlayers || onlyMonsters || onlyNpcs) {
				static const SpectatorsCache::FloorData EMPTY_FLOOR_DATA;

				const auto &creaturesCache = onlyPlayers ? cache.players
					: onlyMonsters                       ? cache.monsters
					: onlyNpcs                           ? cache.npcs
														 : EMPTY_FLOOR_DATA;

				// check players/monsters/npcs cache
				if (checkCache(creaturesCache, onlyPlayers, onlyMonsters, onlyNpcs, centerPos, checkDistance, multifloor, minRangeX, maxRangeX, minRangeY, maxRangeY)) {
					return *this;
				}

				// if there is no players/monsters/npcs cache, look for players/monsters/npcs in the creatures cache.
				if (checkCache(cache.creatures, onlyPlayers, onlyMonsters, onlyNpcs, centerPos, true, multifloor, minRangeX, maxRangeX, minRangeY, maxRangeY)) {
					return *this;
				}
				// All Creatures
			} else if (checkCache(cache.creatures, false, false, false, centerPos, checkDistance, multifloor, minRangeX, maxRangeX, minRangeY, maxRangeY)) {
				return *this;
			}
		}
	}

	const auto &spectators = getSpectators(centerPos, multifloor, onlyPlayers, onlyMonsters, onlyNpcs, minRangeX, maxRangeX, minRangeY, maxRangeY);

	// It is necessary to create the cache even if no spectators is found, so that there is no future query.
	auto &cache = cacheFound ? it->second : spectatorsCache.emplace(centerPos, SpectatorsCache { .minRangeX = minRangeX, .maxRangeX = maxRangeX, .minRangeY = minRangeY, .maxRangeY = maxRangeY, .creatures = {}, .monsters = {}, .npcs = {}, .players = {} }).first->second;
	auto &creaturesCache = onlyPlayers ? cache.players
		: onlyMonsters                 ? cache.monsters
		: onlyNpcs                     ? cache.npcs
									   : cache.creatures;
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

Spectators Spectators::excludeMaster() const {
	auto specs = Spectators();
	if (creatures.empty()) {
		return specs;
	}

	specs.creatures.reserve(creatures.size());

	for (const auto &c : creatures) {
		if (c->getMonster() != nullptr && !c->getMaster()) {
			specs.insert(c);
		}
	}

	return specs;
}

Spectators Spectators::excludePlayerMaster() const {
	auto specs = Spectators();
	if (creatures.empty()) {
		return specs;
	}

	specs.creatures.reserve(creatures.size());

	for (const auto &c : creatures) {
		if ((c->getMonster() != nullptr && !c->getMaster() || !c->getMaster()->getPlayer())) {
			specs.insert(c);
		}
	}

	return specs;
}

Spectators Spectators::filter(bool onlyPlayers, bool onlyMonsters, bool onlyNpcs) const {
	auto specs = Spectators();
	specs.creatures.reserve(creatures.size());

	for (const auto &c : creatures) {
		if (onlyPlayers && c->getPlayer() != nullptr) {
			specs.insert(c);
		} else if (onlyMonsters && c->getMonster() != nullptr) {
			specs.insert(c);
		} else if (onlyNpcs && c->getNpc() != nullptr) {
			specs.insert(c);
		}
	}

	return specs;
}
