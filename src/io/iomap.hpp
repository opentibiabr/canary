/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "declarations.hpp"

#include "config/configmanager.hpp"
#include "map/house/house.hpp"
#include "items/item.hpp"
#include "map/map.hpp"
#include "creatures/monsters/spawns/spawn_monster.hpp"
#include "creatures/npcs/spawns/spawn_npc.hpp"
#include "game/zones/zone.hpp"

class IOMap {
public:
	static void loadMap(Map* map, const Position &pos = Position());

	/**
	 * Load main map monsters
	 * \param map Is the map class
	 * \returns true if the monsters spawn map was loaded successfully
	 */
	static bool loadMonsters(Map* map) {
		if (map->monsterfile.empty()) {
			// OTBM file doesn't tell us about the monsterfile,
			// Lets guess it is mapname-monster.xml.
			map->monsterfile = getMapFilePath("monster", __FUNCTION__);
			map->monsterfile += "-monster.xml";
		}

		return map->spawnsMonster.loadFromXML(map->monsterfile);
	}

	/**
	 * Load main map zones
	 * \param map Is the map class
	 * \returns true if the zones spawn map was loaded successfully
	 */
	static bool loadZones(Map* map) {
		if (map->zonesfile.empty()) {
			// OTBM file doesn't tell us about the zonesfile,
			// Lets guess it is mapname-zone.xml.
			map->zonesfile = getMapFilePath("zones", __FUNCTION__);
			map->zonesfile += "-zones.xml";
		}

		return Zone::loadFromXML(map->zonesfile);
	}

	/**
	 * Load main map npcs
	 * \param map Is the map class
	 * \returns true if the npcs spawn map was loaded successfully
	 */
	static bool loadNpcs(Map* map) {
		if (map->npcfile.empty()) {
			// OTBM file doesn't tell us about the npcfile,
			// Lets guess it is mapname-npc.xml.
			map->npcfile = getMapFilePath("npc", __FUNCTION__);
			map->npcfile += "-npc.xml";
		}

		return map->spawnsNpc.loadFromXml(map->npcfile);
	}

	/**
	 * Load main map houses
	 * \param map Is the map class
	 * \returns true if the main map houses was loaded successfully
	 */
	static bool loadHouses(Map* map) {
		if (map->housefile.empty()) {
			// OTBM file doesn't tell us about the housefile,
			// Lets guess it is mapname-house.xml.
			map->housefile = getMapFilePath("house", __FUNCTION__);
			map->housefile += "-house.xml";
		}

		return map->houses.loadHousesXML(map->housefile);
	}

	/**
	 * Load custom  map monsters
	 * \param map Is the map class
	 * \returns true if the monsters spawn map custom was loaded successfully
	 */
	static bool loadMonstersCustom(Map* map, const std::string &mapName, int customMapIndex) {
#if CLIENT_VERSION >= 1100
		if (map->monsterfile.empty()) {
			// OTBM file doesn't tell us about the monsterfile,
			// Lets guess it is mapname-monster.xml.
			map->monsterfile = mapName;
			map->monsterfile += "-monster.xml";
		}
		return map->spawnsMonsterCustomMaps[customMapIndex].loadFromXML(map->monsterfile);
#else
		return true;
#endif
	}

	/**
	 * Load custom  map zones
	 * \param map Is the map class
	 * \returns true if the zones spawn map custom was loaded successfully
	 */
	static bool loadZonesCustom(Map* map, const std::string &mapName, int customMapIndex) {
#if CLIENT_VERSION >= 1100
		if (map->zonesfile.empty()) {
			// OTBM file doesn't tell us about the zonesfile,
			// Lets guess it is mapname-zones.xml.
			map->zonesfile = mapName;
			map->zonesfile += "-zones.xml";
		}
		return Zone::loadFromXML(map->zonesfile, customMapIndex);
#else
		return true;
#endif
	}

	/**
	 * Load custom map npcs
	 * \param map Is the map class
	 * \returns true if the npcs spawn map custom was loaded successfully
	 */
	static bool loadNpcsCustom(Map* map, const std::string &mapName, int customMapIndex) {
#if CLIENT_VERSION >= 1100
		if (map->npcfile.empty()) {
			// OTBM file doesn't tell us about the npcfile,
			// Lets guess it is mapname-npc.xml.
			map->npcfile = mapName;
			map->npcfile += "-npc.xml";
		}

		return map->spawnsNpcCustomMaps[customMapIndex].loadFromXml(map->npcfile);
#else
		return true;
#endif
	}

	/**
	 * Load custom map houses
	 * \param map Is the map class
	 * \returns true if the map custom houses was loaded successfully
	 */
	static bool loadHousesCustom(Map* map, const std::string &mapName, int customMapIndex) {
#if CLIENT_VERSION >= 1100
		if (map->housefile.empty()) {
			// OTBM file doesn't tell us about the housefile,
			// Lets guess it is mapname-house.xml.
			map->housefile = mapName;
			map->housefile += "-house.xml";
		}
		return map->housesCustomMaps[customMapIndex].loadHousesXML(map->housefile);
#else
		return true;
#endif
	}

private:
	static const std::string &getMapFilePath(const std::string &fileName, const std::string &functionCallName) {
		static std::string mapNameFilePack;
		static std::string prefix = CLIENT_VERSION < 1100 ? fmt::format("{}/", CLIENT_VERSION) : "";
		mapNameFilePack = fmt::format("{}{}-{}.xml", prefix, g_configManager().getString(MAP_NAME, functionCallName), fileName);
		return mapNameFilePack;
	}

	static void parseMapDataAttributes(FileStream &stream, Map* map);
	static void parseWaypoints(FileStream &stream, Map &map);
	static void parseTowns(FileStream &stream, Map &map);
	static void parseTileArea(FileStream &stream, Map &map, const Position &pos);
};

class IOMapException : public std::exception {
public:
	explicit IOMapException(const std::string &msg) :
		message(msg) { }

	const char* what() const noexcept override {
		return message.c_str();
	}

private:
	std::string message;
};
