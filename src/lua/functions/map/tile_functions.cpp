/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "game/game.hpp"
#include "lua/functions/map/tile_functions.hpp"

int TileFunctions::luaTileCreate(lua_State* L) {
	// Tile(x, y, z)
	// Tile(position)
	std::shared_ptr<Tile> tile;
	if (isTable(L, 2)) {
		tile = g_game().map.getTile(getPosition(L, 2));
	} else {
		uint8_t z = getNumber<uint8_t>(L, 4);
		uint16_t y = getNumber<uint16_t>(L, 3);
		uint16_t x = getNumber<uint16_t>(L, 2);
		tile = g_game().map.getTile(x, y, z);
	}

	if (tile) {
		pushUserdata<Tile>(L, tile);
		setMetatable(L, -1, "Tile");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetPosition(lua_State* L) {
	// tile:getPosition()
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (tile) {
		pushPosition(L, tile->getPosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetGround(lua_State* L) {
	// tile:getGround()
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (tile && tile->getGround()) {
		pushUserdata<Item>(L, tile->getGround());
		setItemMetatable(L, -1, tile->getGround());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetThing(lua_State* L) {
	// tile:getThing(index)
	int32_t index = getNumber<int32_t>(L, 2);
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Thing> thing = tile->getThing(index);
	if (!thing) {
		lua_pushnil(L);
		return 1;
	}

	if (std::shared_ptr<Creature> creature = thing->getCreature()) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
	} else if (std::shared_ptr<Item> item = thing->getItem()) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetThingCount(lua_State* L) {
	// tile:getThingCount()
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (tile) {
		lua_pushnumber(L, tile->getThingCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetTopVisibleThing(lua_State* L) {
	// tile:getTopVisibleThing(creature)
	std::shared_ptr<Creature> creature = getCreature(L, 2);
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Thing> thing = tile->getTopVisibleThing(creature);
	if (!thing) {
		lua_pushnil(L);
		return 1;
	}

	if (std::shared_ptr<Creature> visibleCreature = thing->getCreature()) {
		pushUserdata<Creature>(L, visibleCreature);
		setCreatureMetatable(L, -1, visibleCreature);
	} else if (std::shared_ptr<Item> visibleItem = thing->getItem()) {
		pushUserdata<Item>(L, visibleItem);
		setItemMetatable(L, -1, visibleItem);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetTopTopItem(lua_State* L) {
	// tile:getTopTopItem()
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Item> item = tile->getTopTopItem();
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetTopDownItem(lua_State* L) {
	// tile:getTopDownItem()
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Item> item = tile->getTopDownItem();
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetFieldItem(lua_State* L) {
	// tile:getFieldItem()
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Item> item = tile->getFieldItem();
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetItemById(lua_State* L) {
	// tile:getItemById(itemId[, subType = -1])
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}
	int32_t subType = getNumber<int32_t>(L, 3, -1);

	std::shared_ptr<Item> item = g_game().findItemOfType(tile, itemId, false, subType);
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetItemByType(lua_State* L) {
	// tile:getItemByType(itemType)
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	bool found;

	ItemTypes_t itemType = getNumber<ItemTypes_t>(L, 2);
	switch (itemType) {
		case ITEM_TYPE_TELEPORT:
			found = tile->hasFlag(TILESTATE_TELEPORT);
			break;
		case ITEM_TYPE_MAGICFIELD:
			found = tile->hasFlag(TILESTATE_MAGICFIELD);
			break;
		case ITEM_TYPE_MAILBOX:
			found = tile->hasFlag(TILESTATE_MAILBOX);
			break;
		case ITEM_TYPE_TRASHHOLDER:
			found = tile->hasFlag(TILESTATE_TRASHHOLDER);
			break;
		case ITEM_TYPE_BED:
			found = tile->hasFlag(TILESTATE_BED);
			break;
		case ITEM_TYPE_DEPOT:
			found = tile->hasFlag(TILESTATE_DEPOT);
			break;
		default:
			found = true;
			break;
	}

	if (!found) {
		lua_pushnil(L);
		return 1;
	}

	if (std::shared_ptr<Item> item = tile->getGround()) {
		const ItemType &it = Item::items[item->getID()];
		if (it.type == itemType) {
			pushUserdata<Item>(L, item);
			setItemMetatable(L, -1, item);
			return 1;
		}
	}

	if (const TileItemVector* items = tile->getItemList()) {
		for (auto &item : *items) {
			const ItemType &it = Item::items[item->getID()];
			if (it.type == itemType) {
				pushUserdata<Item>(L, item);
				setItemMetatable(L, -1, item);
				return 1;
			}
		}
	}

	lua_pushnil(L);
	return 1;
}

int TileFunctions::luaTileGetItemByTopOrder(lua_State* L) {
	// tile:getItemByTopOrder(topOrder)
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	int32_t topOrder = getNumber<int32_t>(L, 2);

	std::shared_ptr<Item> item = tile->getItemByTopOrder(topOrder);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	pushUserdata<Item>(L, item);
	setItemMetatable(L, -1, item);
	return 1;
}

int TileFunctions::luaTileGetItemCountById(lua_State* L) {
	// tile:getItemCountById(itemId[, subType = -1])
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	int32_t subType = getNumber<int32_t>(L, 3, -1);

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	lua_pushnumber(L, tile->getItemTypeCount(itemId, subType));
	return 1;
}

int TileFunctions::luaTileGetBottomCreature(lua_State* L) {
	// tile:getBottomCreature()
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Creature> creature = tile->getBottomCreature();
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	pushUserdata<const Creature>(L, creature);
	setCreatureMetatable(L, -1, creature);
	return 1;
}

int TileFunctions::luaTileGetTopCreature(lua_State* L) {
	// tile:getTopCreature()
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Creature> creature = tile->getTopCreature();
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	pushUserdata<Creature>(L, creature);
	setCreatureMetatable(L, -1, creature);
	return 1;
}

int TileFunctions::luaTileGetBottomVisibleCreature(lua_State* L) {
	// tile:getBottomVisibleCreature(creature)
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Creature> creature = getCreature(L, 2);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Creature> visibleCreature = tile->getBottomVisibleCreature(creature);
	if (visibleCreature) {
		pushUserdata<const Creature>(L, visibleCreature);
		setCreatureMetatable(L, -1, visibleCreature);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetTopVisibleCreature(lua_State* L) {
	// tile:getTopVisibleCreature(creature)
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Creature> creature = getCreature(L, 2);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Creature> visibleCreature = tile->getTopVisibleCreature(creature);
	if (visibleCreature) {
		pushUserdata<Creature>(L, visibleCreature);
		setCreatureMetatable(L, -1, visibleCreature);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetItems(lua_State* L) {
	// tile:getItems()
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	TileItemVector* itemVector = tile->getItemList();
	if (!itemVector) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, itemVector->size(), 0);

	int index = 0;
	for (auto &item : *itemVector) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int TileFunctions::luaTileGetItemCount(lua_State* L) {
	// tile:getItemCount()
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, tile->getItemCount());
	return 1;
}

int TileFunctions::luaTileGetDownItemCount(lua_State* L) {
	// tile:getDownItemCount()
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (tile) {
		lua_pushnumber(L, tile->getDownItemCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetTopItemCount(lua_State* L) {
	// tile:getTopItemCount()
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, tile->getTopItemCount());
	return 1;
}

int TileFunctions::luaTileGetCreatures(lua_State* L) {
	// tile:getCreatures()
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	CreatureVector* creatureVector = tile->getCreatures();
	if (!creatureVector) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, creatureVector->size(), 0);

	int index = 0;
	for (auto &creature : *creatureVector) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int TileFunctions::luaTileGetCreatureCount(lua_State* L) {
	// tile:getCreatureCount()
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, tile->getCreatureCount());
	return 1;
}

int TileFunctions::luaTileHasProperty(lua_State* L) {
	// tile:hasProperty(property[, item])
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Item> item;
	if (lua_gettop(L) >= 3) {
		item = getUserdataShared<Item>(L, 3);
	} else {
		item = nullptr;
	}

	ItemProperty property = getNumber<ItemProperty>(L, 2);
	if (item) {
		pushBoolean(L, tile->hasProperty(item, property));
	} else {
		pushBoolean(L, tile->hasProperty(property));
	}
	return 1;
}

int TileFunctions::luaTileGetThingIndex(lua_State* L) {
	// tile:getThingIndex(thing)
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Thing> thing = getThing(L, 2);
	if (thing) {
		lua_pushnumber(L, tile->getThingIndex(thing));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileHasFlag(lua_State* L) {
	// tile:hasFlag(flag)
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (tile) {
		TileFlags_t flag = getNumber<TileFlags_t>(L, 2);
		pushBoolean(L, tile->hasFlag(flag));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileQueryAdd(lua_State* L) {
	// tile:queryAdd(thing[, flags])
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Thing> thing = getThing(L, 2);
	if (thing) {
		uint32_t flags = getNumber<uint32_t>(L, 3, 0);
		lua_pushnumber(L, tile->queryAdd(0, thing, 1, flags));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileAddItem(lua_State* L) {
	// tile:addItem(itemId[, count/subType = 1[, flags = 0]])
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	uint32_t subType = getNumber<uint32_t>(L, 3, 1);

	std::shared_ptr<Item> item = Item::CreateItem(itemId, std::min<uint32_t>(subType, Item::items[itemId].stackSize));
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t flags = getNumber<uint32_t>(L, 4, 0);

	ReturnValue ret = g_game().internalAddItem(tile, item, INDEX_WHEREEVER, flags);
	if (ret == RETURNVALUE_NOERROR) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {

		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileAddItemEx(lua_State* L) {
	// tile:addItemEx(item[, flags = 0])
	std::shared_ptr<Item> item = getUserdataShared<Item>(L, 2);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	if (item->getParent() != VirtualCylinder::virtualCylinder) {
		reportErrorFunc("Item already has a parent");
		lua_pushnil(L);
		return 1;
	}

	uint32_t flags = getNumber<uint32_t>(L, 3, 0);
	ReturnValue ret = g_game().internalAddItem(tile, item, INDEX_WHEREEVER, flags);
	if (ret == RETURNVALUE_NOERROR) {
		ScriptEnvironment::removeTempItem(item);
	}
	lua_pushnumber(L, ret);
	return 1;
}

int TileFunctions::luaTileGetHouse(lua_State* L) {
	// tile:getHouse()
	std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	if (std::shared_ptr<HouseTile> houseTile = std::dynamic_pointer_cast<HouseTile>(tile)) {
		pushUserdata<House>(L, houseTile->getHouse());
		setMetatable(L, -1, "House");
	} else {
		lua_pushnil(L);
	}
	return 1;
}
