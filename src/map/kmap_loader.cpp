/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
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
		SPDLOG_ERROR("Unable to load :{}, could not open file", fileName);
		return false;
	}

	if (!fileStream.good())
	{
		SPDLOG_ERROR("Unable to load :{}, error for read file", fileName);
		return false;
	}

	std::vector<uint8_t> fileBuffer((std::istreambuf_iterator<char> (fileStream)), (std::istreambuf_iterator<char> ()));
	buffer = fileBuffer;

	fileStream.close();
	return true;
}

void KmapLoader::loadHeader(
	Map &map,
	const Kmap::MapHeader *header,
	const std::string &fileName
) {
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
		for (auto kTile: *area->tiles())
		{
			Tile* tile = loadTile(map, kTile, area->position());
			tile->setFlag(readFlags(kTile->flags()));
			map.setTile(tile->getPosition(), tile);
		}
	}

	for (auto town: *mapData->towns())
	{
		loadTown(map, town);
	}
}

Tile* KmapLoader::loadTile(Map& map, const Kmap::Tile* kTile, const Kmap::Position* areaPosition)
{
	const Position tilePosition(
		areaPosition->x() + kTile->x(),
		areaPosition->y() + kTile->y(),
		areaPosition->z()
	);

	Item* groundItem = nullptr;

	// Load houses
	Tile *tile = loadHouses(map, tilePosition, kTile->house_id());

	// Create ground tiles, if no house tiles yet.
	if (groundItem = loadItem(kTile->ground()); groundItem && tile == nullptr)
	{
		tile = createTile(tilePosition, groundItem->isBlocking());
	}

	// If there are no items, we can just persist the tile and move on.
	if (!kTile->items()) {
		return persistTile(tilePosition, groundItem, tile);
	}

	// Create ground items
	for (auto kItem : *kTile->items())
	{
		Item *item = loadItem(kItem);

		if (item == nullptr) continue;

		// Create tiles from ground items (if no tile was created yet)
		if (tile == nullptr)
		{
			if (item->isGroundTile())
			{
				delete groundItem;
				groundItem = item;
				continue;
			}

			// Create items from grounds
			tile = createTile(tilePosition, item && item->isBlocking());
		}

		// Set items from ground attributes
		tile->internalAddThing(item);
		item->startDecaying();
		item->setLoadedFromMap(true);
	}

	return persistTile(tilePosition, groundItem, tile);
}

Tile* KmapLoader::persistTile(const Position& tilePosition, Item* groundItem, Tile* tile)
{
	tile = !tile ? createTile(tilePosition, groundItem && groundItem->isBlocking()) : tile;

	if (groundItem) {
		tile->internalAddThing(groundItem);
		groundItem->startDecaying();
		groundItem->setLoadedFromMap(true);
	}

	return tile;
}

Tile* KmapLoader::loadHouses(Map &map, const Position &tilePosition, const uint32_t houseId)
{
	if (houseId == 0)
	{
		return nullptr;
	}

	if (House* house = map.houses.addHouse(houseId))
	{
		Tile* tile = new HouseTile(tilePosition, house);
		house->addTile(static_cast<HouseTile*>(tile));
		return tile;
	}

	SPDLOG_ERROR("{} - Could not create house id: {}, on position: {}", __FUNCTION__, houseId, tilePosition.toString());
	return nullptr;
}

Item* KmapLoader::loadItem(const Kmap::Item *kItem)
{
	if (kItem == nullptr)
	{
		return nullptr;
	}

	Item *item = Item::CreateItem(kItem->id(), 1);

	if (item == nullptr)
	{
		SPDLOG_WARN("{} - Failed to create item :{}.", __FUNCTION__, kItem->id());
		return nullptr;
	}

	if (auto attributes = kItem->attributes(); attributes)
	{
		attributes->count();
		attributes->count();
		attributes->description();

		if (auto action = attributes->action(); action)
		{
			action->action_id();
			action->unique_id();
		}
	}

	if (auto details = kItem->details(); details)
	{
		details->depot_id();
		details->door_id();
		details->teleport();

		auto kContainerItem = details->container_items();
		if (kContainerItem == nullptr)
		{
			return item;
		}

		if (const ItemType &itemType = Item::items[item->getID()];
		!itemType.isContainer() && kContainerItem->size() > 0)
		{
			SPDLOG_ERROR("{} - Container items found, but item :{} is not a container.", __FUNCTION__, kItem->id());
			return item;
		}

		for (auto containerItem: *kContainerItem)
		{
			if (auto container = item->getContainer(); container != nullptr) {
				container->addItem(loadItem(containerItem));
			}
		}
	}

	return item;
}

void KmapLoader::loadTown(Map &map, const Kmap::Town *kTown)
{
	auto townId = kTown->id();
	if (townId == 0)
	{
		SPDLOG_ERROR("{} - Invalid town id", __FUNCTION__);
		return;
	}

	auto position = kTown->position();
	std::unique_ptr<Town> townPtr(
			new Town(
				kTown->name()->str(),
				townId,
				Position(position->x(), position->y(), position->z())
			)
	);

	if (!map.towns.addTown(townId, townPtr.get()))
	{
		SPDLOG_ERROR("{} - Cannot create town with id: {}, discarding town", __FUNCTION__, townId);
		return;
	}
}

std::string KmapLoader::readResourceFile(
	const std::string &fileName, const flatbuffers::String &resourceFile
)
{
	return fileName.substr(0, fileName.rfind('/') + 1) + resourceFile.str();
}

TileFlags_t KmapLoader::readFlags(uint32_t encodedflags)
{
	std::map<uint32_t, TileFlags_t> flagConvertionMap {
		{ OTBM_TILEFLAG_PROTECTIONZONE, TILESTATE_PROTECTIONZONE },
		{ OTBM_TILEFLAG_NOPVPZONE, TILESTATE_NOPVPZONE },
		{ OTBM_TILEFLAG_PVPZONE, TILESTATE_PVPZONE },
		{ OTBM_TILEFLAG_NOLOGOUT, TILESTATE_NOLOGOUT }
	};

	uint32_t tileFlags = TILESTATE_NONE;
	for (auto const &[encodedFlag, tileFlag] : flagConvertionMap)
	{
		if ((encodedflags & encodedFlag) != 0)
		{
			tileFlags |= tileFlag;
		}
	}

	return static_cast<TileFlags_t>(tileFlags);
}

Tile* KmapLoader::createTile(const Position &position, bool isBlocking)
{
	if (isBlocking) {
		return new StaticTile(position);
	}
	return new DynamicTile(position);
}
