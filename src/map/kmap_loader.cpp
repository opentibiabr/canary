/**
 *Canary - A free and open-source MMORPG server emulator
 *Copyright (©) 2019-2022 OpenTibiaBR<opentibiabr@outlook.com>
 *Repository: https://github.com/opentibiabr/canary
 *License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 *Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 *Website: https://docs.opentibiabr.org/
 */
#include "otpch.h"

#include "map/kmap_loader.hpp"

#include <fstream>
#include <filesystem>

bool KmapLoader::load(Map &map, const std::string &fileName)
{
	int64_t start = OTSYS_TIME();
	if (loadFile(fileName) == false)
	{
		return false;
	}

	auto kmap = Kmap::GetMap(buffer.data());
	loadHeader(map, kmap->header(), fileName);
	loadData(map, kmap->data());

	SPDLOG_INFO("Map loading time: {} seconds", (OTSYS_TIME() - start) / (1000.));
	return true;
}

bool KmapLoader::loadFile(const std::string &fileName)
{
	std::fstream fileStream(fileName, std::ios:: in | std::ios::binary);
	if (!fileStream.is_open())
	{
		SPDLOG_ERROR("Unable to load {}, could not open file", fileName);
		return false;
	}

	if (!fileStream.good())
	{
		SPDLOG_ERROR("Unable to load {}, error for read file", fileName);
		return false;
	}

	std::vector<uint8_t> fileBuffer((std::istreambuf_iterator<char> (fileStream)), (std::istreambuf_iterator<char> ()));
	buffer = fileBuffer;

	fileStream.close();
	return true;
}

void KmapLoader::loadHeader(
	Map &map, const Kmap::MapHeader *header, const std::string &fileName
)
{
	map.width = header->width();
	map.height = header->height();
	SPDLOG_INFO("Map size: {}x{}", map.width, map.height);

	map.monsterfile = readResourceFile(fileName, *header->monster_spawn_file());
	map.npcfile = readResourceFile(fileName, *header->npc_spawn_file());
	map.housefile = readResourceFile(fileName, *header->house_file());
}

void KmapLoader::loadData(Map &map, const Kmap::MapData *mapData)
{
	for (auto area: *mapData->areas())
	{
		for (auto tile: *area->tiles())
		{
			loadTile(map, tile, area->position());
		}
	}

	for (auto town: *mapData->towns())
	{
		loadTown(map, town);
	}

	for (auto waypoint: *mapData->waypoints())
	{
		loadWaypoint(map, waypoint);
	}
}

void KmapLoader::loadTile(Map &map, const Kmap::Tile *tile, const Kmap::Position *areaPosition)
{
	TileFlags_t mapTileFlags = readFlags(tile->flags());
	const Position tilePosition(
		areaPosition->x() + tile->x(),
		areaPosition->y() + tile->y(),
		areaPosition->z()
	);

	Tile *mapTile = nullptr;
	House *house = nullptr;
	loadHouses(map, mapTile, house, tilePosition, tile->house_id());
	
	auto ground = tile->tile();
	// Create tile items
	Item *itemTile = Item::createMapItem(ground->id());
	if (itemTile) {
		mapTile = createTile(itemTile, nullptr, tilePosition);
		mapTile->internalAddThing(itemTile);
		itemTile->startDecaying();
		itemTile->setLoadedFromMap(true);
	}

	for (auto item : *tile->items())
	{
		loadItem(map, item);
	}
}

void KmapLoader::loadHouses(Map &map, Tile *tile, House *house, const Position &tilePosition, const uint32_t houseId)
{
	// Create house tiles
	if (houseId != 0)
	{
		//SPDLOG_INFO("Found house id {}, on position {}", houseId, tilePosition.toString());
		house = map.houses.addHouse(houseId);
		if (house == nullptr)
		{
			SPDLOG_ERROR("{} - Could not create house id: {}, on position: {}", __FUNCTION__, houseId, tilePosition.toString());
			return;
		}
		tile = new HouseTile(tilePosition.x, tilePosition.y, tilePosition.z, house);
		if (tile == nullptr)
		{
			SPDLOG_ERROR("{} - Tile is nullptr, discarding house id: {}, on position: {}", __FUNCTION__, houseId, tilePosition.toString());
			return;
		}

		house->addTile(static_cast<HouseTile*>(tile));
	}
}

void KmapLoader::loadItem(Map &map, const Kmap::Item *item)
{
	item->id();
	if (auto details = item->details();
	details)
	{
		details->depot_id();
		details->door_id();
		details->teleport();

		for (auto containerItem: *details->container_items())
		{
			loadItem(map, containerItem);
		}
	}

	if (auto attributes = item->attributes();
	attributes)
	{
		attributes->count();
		attributes->count();
		attributes->description();

		if (auto action = attributes->action();
		action)
		{
			action->action_id();
			action->unique_id();
		}
	}
}

void KmapLoader::loadTown(Map &map, const Kmap::Town *town)
{
	uint8_t townId = town->id();
	if (townId == 0)
	{
		SPDLOG_ERROR("{} - Invalid town id", __FUNCTION__);
		return;
	}

	Position townPosition(town->position()->x(), town->position()->y(), town->position()->z());

	Town newTown(town->id());
	newTown.setName(town->name()->str());
	newTown.setTemplePos(townPosition);

	if (townPosition.x == 0 || townPosition.y == 0 || townPosition.z == 0 || newTown.getName().empty())
	{
		SPDLOG_ERROR("{} - Town {} is not valid.", __FUNCTION__, townId);
		return;
	}

	if (!map.towns.addTown(townId, &newTown))
	{
		SPDLOG_ERROR("{} - Duplicate town with id: {}, discarding town", __FUNCTION__, townId);
		return;
	}
}

void KmapLoader::loadWaypoint(Map &map, const Kmap::Waypoint *waypoint)
{
	const std::string waypointName = waypoint->name()->str();
	Position waypointPosition(
		waypoint->position()->x(),
		waypoint->position()->y(),
		waypoint->position()->z()
	);

	if (waypointPosition.x == 0 || waypointPosition.y == 0 || waypointPosition.z == 0 || waypointName.empty())
	{
		SPDLOG_ERROR("{} - Invalid waypoint.", __FUNCTION__);
		return;
	}

	map.waypoints[waypointName] = waypointPosition;
}

std::string KmapLoader::readResourceFile(
	const std::string &fileName, const flatbuffers::String &resourceFile
)
{
	return fileName.substr(0, fileName.rfind('/') + 1) + resourceFile.str();
}

TileFlags_t KmapLoader::readFlags(uint32_t encodedflags)
{
	std::map<uint32_t, TileFlags_t> flagConvertionMap;
	{
		{
			OTBM_TILEFLAG_PROTECTIONZONE, TILESTATE_PROTECTIONZONE;
		}
		{
			OTBM_TILEFLAG_NOPVPZONE, TILESTATE_NOPVPZONE;
		}
		{
			OTBM_TILEFLAG_PVPZONE, TILESTATE_PVPZONE;
		}
		{
			OTBM_TILEFLAG_NOLOGOUT, TILESTATE_NOLOGOUT;
		}
	};

	uint32_t tileFlags = TILESTATE_NONE;
	for (auto const &[encodedFlag, tileFlag]: flagConvertionMap)
	{
		if ((encodedflags & encodedFlag) != 0)
		{
			tileFlags |= tileFlag;
		}
	}

	return static_cast<TileFlags_t>(tileFlags);
}

Tile* KmapLoader::createTile(Item* ground, Item* item, const Position &position)
{
	if (!ground) {
		return new StaticTile(position.x, position.y, position.z);
	}

	Tile *tile;
	if ((item && item->isBlocking()) || ground->isBlocking()) {
		tile = new StaticTile(position.x, position.y, position.z);
	} else {
		tile = new DynamicTile(position.x, position.y, position.z);
	}

	tile->internalAddThing(ground);
	ground->startDecaying();
	ground = nullptr;
	return tile;
}
