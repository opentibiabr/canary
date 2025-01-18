/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/map/tile_functions.hpp"

#include "creatures/combat/combat.hpp"
#include "game/game.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void TileFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Tile", "", TileFunctions::luaTileCreate);
	Lua::registerMetaMethod(L, "Tile", "__eq", Lua::luaUserdataCompare);

	Lua::registerMethod(L, "Tile", "getPosition", TileFunctions::luaTileGetPosition);
	Lua::registerMethod(L, "Tile", "getGround", TileFunctions::luaTileGetGround);
	Lua::registerMethod(L, "Tile", "getThing", TileFunctions::luaTileGetThing);
	Lua::registerMethod(L, "Tile", "getThingCount", TileFunctions::luaTileGetThingCount);
	Lua::registerMethod(L, "Tile", "getTopVisibleThing", TileFunctions::luaTileGetTopVisibleThing);

	Lua::registerMethod(L, "Tile", "getTopTopItem", TileFunctions::luaTileGetTopTopItem);
	Lua::registerMethod(L, "Tile", "getTopDownItem", TileFunctions::luaTileGetTopDownItem);
	Lua::registerMethod(L, "Tile", "getFieldItem", TileFunctions::luaTileGetFieldItem);

	Lua::registerMethod(L, "Tile", "getItemById", TileFunctions::luaTileGetItemById);
	Lua::registerMethod(L, "Tile", "getItemByType", TileFunctions::luaTileGetItemByType);
	Lua::registerMethod(L, "Tile", "getItemByTopOrder", TileFunctions::luaTileGetItemByTopOrder);
	Lua::registerMethod(L, "Tile", "getItemCountById", TileFunctions::luaTileGetItemCountById);

	Lua::registerMethod(L, "Tile", "getBottomCreature", TileFunctions::luaTileGetBottomCreature);
	Lua::registerMethod(L, "Tile", "getTopCreature", TileFunctions::luaTileGetTopCreature);
	Lua::registerMethod(L, "Tile", "getBottomVisibleCreature", TileFunctions::luaTileGetBottomVisibleCreature);
	Lua::registerMethod(L, "Tile", "getTopVisibleCreature", TileFunctions::luaTileGetTopVisibleCreature);

	Lua::registerMethod(L, "Tile", "getItems", TileFunctions::luaTileGetItems);
	Lua::registerMethod(L, "Tile", "getItemCount", TileFunctions::luaTileGetItemCount);
	Lua::registerMethod(L, "Tile", "getDownItemCount", TileFunctions::luaTileGetDownItemCount);
	Lua::registerMethod(L, "Tile", "getTopItemCount", TileFunctions::luaTileGetTopItemCount);

	Lua::registerMethod(L, "Tile", "getCreatures", TileFunctions::luaTileGetCreatures);
	Lua::registerMethod(L, "Tile", "getCreatureCount", TileFunctions::luaTileGetCreatureCount);

	Lua::registerMethod(L, "Tile", "getThingIndex", TileFunctions::luaTileGetThingIndex);

	Lua::registerMethod(L, "Tile", "hasProperty", TileFunctions::luaTileHasProperty);
	Lua::registerMethod(L, "Tile", "hasFlag", TileFunctions::luaTileHasFlag);

	Lua::registerMethod(L, "Tile", "queryAdd", TileFunctions::luaTileQueryAdd);
	Lua::registerMethod(L, "Tile", "addItem", TileFunctions::luaTileAddItem);
	Lua::registerMethod(L, "Tile", "addItemEx", TileFunctions::luaTileAddItemEx);

	Lua::registerMethod(L, "Tile", "getHouse", TileFunctions::luaTileGetHouse);
	Lua::registerMethod(L, "Tile", "sweep", TileFunctions::luaTileSweep);
}

int TileFunctions::luaTileCreate(lua_State* L) {
	// Tile(x, y, z)
	// Tile(position)
	std::shared_ptr<Tile> tile;
	if (Lua::isTable(L, 2)) {
		tile = g_game().map.getTile(Lua::getPosition(L, 2));
	} else {
		const uint8_t z = Lua::getNumber<uint8_t>(L, 4);
		const uint16_t y = Lua::getNumber<uint16_t>(L, 3);
		const uint16_t x = Lua::getNumber<uint16_t>(L, 2);
		tile = g_game().map.getTile(x, y, z);
	}

	if (tile) {
		Lua::pushUserdata<Tile>(L, tile);
		Lua::setMetatable(L, -1, "Tile");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetPosition(lua_State* L) {
	// tile:Lua::getPosition()
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (tile) {
		Lua::pushPosition(L, tile->getPosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetGround(lua_State* L) {
	// tile:getGround()
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (tile && tile->getGround()) {
		Lua::pushUserdata<Item>(L, tile->getGround());
		Lua::setItemMetatable(L, -1, tile->getGround());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetThing(lua_State* L) {
	// tile:getThing(index)
	const int32_t index = Lua::getNumber<int32_t>(L, 2);
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	const auto &thing = tile->getThing(index);
	if (!thing) {
		lua_pushnil(L);
		return 1;
	}

	if (const auto &creature = thing->getCreature()) {
		Lua::pushUserdata<Creature>(L, creature);
		Lua::setCreatureMetatable(L, -1, creature);
	} else if (const auto &item = thing->getItem()) {
		Lua::pushUserdata<Item>(L, item);
		Lua::setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetThingCount(lua_State* L) {
	// tile:getThingCount()
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (tile) {
		lua_pushnumber(L, tile->getThingCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetTopVisibleThing(lua_State* L) {
	// tile:getTopVisibleThing(creature)
	const auto &creature = Lua::getCreature(L, 2);
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	const auto &thing = tile->getTopVisibleThing(creature);
	if (!thing) {
		lua_pushnil(L);
		return 1;
	}

	if (const auto &visibleCreature = thing->getCreature()) {
		Lua::pushUserdata<Creature>(L, visibleCreature);
		Lua::setCreatureMetatable(L, -1, visibleCreature);
	} else if (const auto &visibleItem = thing->getItem()) {
		Lua::pushUserdata<Item>(L, visibleItem);
		Lua::setItemMetatable(L, -1, visibleItem);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetTopTopItem(lua_State* L) {
	// tile:getTopTopItem()
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	const auto &item = tile->getTopTopItem();
	if (item) {
		Lua::pushUserdata<Item>(L, item);
		Lua::setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetTopDownItem(lua_State* L) {
	// tile:getTopDownItem()
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	const auto &item = tile->getTopDownItem();
	if (item) {
		Lua::pushUserdata<Item>(L, item);
		Lua::setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetFieldItem(lua_State* L) {
	// tile:getFieldItem()
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	const auto &item = tile->getFieldItem();
	if (item) {
		Lua::pushUserdata<Item>(L, item);
		Lua::setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetItemById(lua_State* L) {
	// tile:getItemById(itemId[, subType = -1])
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (Lua::isNumber(L, 2)) {
		itemId = Lua::getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(Lua::getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}
	const auto subType = Lua::getNumber<int32_t>(L, 3, -1);

	const auto &item = g_game().findItemOfType(tile, itemId, false, subType);
	if (item) {
		Lua::pushUserdata<Item>(L, item);
		Lua::setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetItemByType(lua_State* L) {
	// tile:getItemByType(itemType)
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	bool found;

	const ItemTypes_t itemType = Lua::getNumber<ItemTypes_t>(L, 2);
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

	if (const auto &item = tile->getGround()) {
		const ItemType &it = Item::items[item->getID()];
		if (it.type == itemType) {
			Lua::pushUserdata<Item>(L, item);
			Lua::setItemMetatable(L, -1, item);
			return 1;
		}
	}

	if (const TileItemVector* items = tile->getItemList()) {
		for (auto &item : *items) {
			const ItemType &it = Item::items[item->getID()];
			if (it.type == itemType) {
				Lua::pushUserdata<Item>(L, item);
				Lua::setItemMetatable(L, -1, item);
				return 1;
			}
		}
	}

	lua_pushnil(L);
	return 1;
}

int TileFunctions::luaTileGetItemByTopOrder(lua_State* L) {
	// tile:getItemByTopOrder(topOrder)
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	const int32_t topOrder = Lua::getNumber<int32_t>(L, 2);

	const auto &item = tile->getItemByTopOrder(topOrder);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	Lua::pushUserdata<Item>(L, item);
	Lua::setItemMetatable(L, -1, item);
	return 1;
}

int TileFunctions::luaTileGetItemCountById(lua_State* L) {
	// tile:getItemCountById(itemId[, subType = -1])
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	const auto subType = Lua::getNumber<int32_t>(L, 3, -1);

	uint16_t itemId;
	if (Lua::isNumber(L, 2)) {
		itemId = Lua::getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(Lua::getString(L, 2));
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
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	const auto &creature = tile->getBottomCreature();
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	Lua::pushUserdata<const Creature>(L, creature);
	Lua::setCreatureMetatable(L, -1, creature);
	return 1;
}

int TileFunctions::luaTileGetTopCreature(lua_State* L) {
	// tile:getTopCreature()
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	const auto &creature = tile->getTopCreature();
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	Lua::pushUserdata<Creature>(L, creature);
	Lua::setCreatureMetatable(L, -1, creature);
	return 1;
}

int TileFunctions::luaTileGetBottomVisibleCreature(lua_State* L) {
	// tile:getBottomVisibleCreature(creature)
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	const auto &creature = Lua::getCreature(L, 2);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const auto &visibleCreature = tile->getBottomVisibleCreature(creature);
	if (visibleCreature) {
		Lua::pushUserdata<const Creature>(L, visibleCreature);
		Lua::setCreatureMetatable(L, -1, visibleCreature);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetTopVisibleCreature(lua_State* L) {
	// tile:getTopVisibleCreature(creature)
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	const auto &creature = Lua::getCreature(L, 2);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const auto &visibleCreature = tile->getTopVisibleCreature(creature);
	if (visibleCreature) {
		Lua::pushUserdata<Creature>(L, visibleCreature);
		Lua::setCreatureMetatable(L, -1, visibleCreature);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetItems(lua_State* L) {
	// tile:getItems()
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
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
		Lua::pushUserdata<Item>(L, item);
		Lua::setItemMetatable(L, -1, item);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int TileFunctions::luaTileGetItemCount(lua_State* L) {
	// tile:getItemCount()
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, tile->getItemCount());
	return 1;
}

int TileFunctions::luaTileGetDownItemCount(lua_State* L) {
	// tile:getDownItemCount()
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (tile) {
		lua_pushnumber(L, tile->getDownItemCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileGetTopItemCount(lua_State* L) {
	// tile:getTopItemCount()
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, tile->getTopItemCount());
	return 1;
}

int TileFunctions::luaTileGetCreatures(lua_State* L) {
	// tile:getCreatures()
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
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
		Lua::pushUserdata<Creature>(L, creature);
		Lua::setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int TileFunctions::luaTileGetCreatureCount(lua_State* L) {
	// tile:getCreatureCount()
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, tile->getCreatureCount());
	return 1;
}

int TileFunctions::luaTileHasProperty(lua_State* L) {
	// tile:hasProperty(property[, item])
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Item> item;
	if (lua_gettop(L) >= 3) {
		item = Lua::getUserdataShared<Item>(L, 3);
	} else {
		item = nullptr;
	}

	ItemProperty property = Lua::getNumber<ItemProperty>(L, 2);
	if (item) {
		Lua::pushBoolean(L, tile->hasProperty(item, property));
	} else {
		Lua::pushBoolean(L, tile->hasProperty(property));
	}
	return 1;
}

int TileFunctions::luaTileGetThingIndex(lua_State* L) {
	// tile:getThingIndex(thing)
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	const auto &thing = Lua::getThing(L, 2);
	if (thing) {
		lua_pushnumber(L, tile->getThingIndex(thing));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileHasFlag(lua_State* L) {
	// tile:hasFlag(flag)
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (tile) {
		TileFlags_t flag = Lua::getNumber<TileFlags_t>(L, 2);
		Lua::pushBoolean(L, tile->hasFlag(flag));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileQueryAdd(lua_State* L) {
	// tile:queryAdd(thing[, flags])
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	const auto &thing = Lua::getThing(L, 2);
	if (thing) {
		const auto flags = Lua::getNumber<uint32_t>(L, 3, 0);
		lua_pushnumber(L, tile->queryAdd(0, thing, 1, flags));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileAddItem(lua_State* L) {
	// tile:addItem(itemId[, count/subType = 1[, flags = 0]])
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (Lua::isNumber(L, 2)) {
		itemId = Lua::getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(Lua::getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	const auto subType = Lua::getNumber<uint32_t>(L, 3, 1);

	const auto &item = Item::CreateItem(itemId, std::min<uint32_t>(subType, Item::items[itemId].stackSize));
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	const auto flags = Lua::getNumber<uint32_t>(L, 4, 0);

	ReturnValue ret = g_game().internalAddItem(tile, item, INDEX_WHEREEVER, flags);
	if (ret == RETURNVALUE_NOERROR) {
		Lua::pushUserdata<Item>(L, item);
		Lua::setItemMetatable(L, -1, item);
	} else {

		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileAddItemEx(lua_State* L) {
	// tile:addItemEx(item[, flags = 0])
	const auto &item = Lua::getUserdataShared<Item>(L, 2);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	if (item->getParent() != VirtualCylinder::virtualCylinder) {
		Lua::reportErrorFunc("Item already has a parent");
		lua_pushnil(L);
		return 1;
	}

	const auto flags = Lua::getNumber<uint32_t>(L, 3, 0);
	ReturnValue ret = g_game().internalAddItem(tile, item, INDEX_WHEREEVER, flags);
	if (ret == RETURNVALUE_NOERROR) {
		ScriptEnvironment::removeTempItem(item);
	}
	lua_pushnumber(L, ret);
	return 1;
}

int TileFunctions::luaTileGetHouse(lua_State* L) {
	// tile:getHouse()
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	if (const auto &houseTile = std::dynamic_pointer_cast<HouseTile>(tile)) {
		Lua::pushUserdata<House>(L, houseTile->getHouse());
		Lua::setMetatable(L, -1, "House");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TileFunctions::luaTileSweep(lua_State* L) {
	// tile:sweep(actor)
	const auto &tile = Lua::getUserdataShared<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}
	const auto &actor = Lua::getPlayer(L, 2);
	if (!actor) {
		lua_pushnil(L);
		return 1;
	}

	const auto &house = tile->getHouse();
	if (!house) {
		g_logger().debug("TileFunctions::luaTileSweep: tile has no house");
		lua_pushnil(L);
		return 1;
	}

	if (house->getHouseAccessLevel(actor) < HOUSE_OWNER) {
		g_logger().debug("TileFunctions::luaTileSweep: player is not owner of house");
		lua_pushnil(L);
		return 1;
	}

	const auto &houseTile = std::dynamic_pointer_cast<HouseTile>(tile);
	if (!houseTile) {
		g_logger().debug("TileFunctions::luaTileSweep: tile is not a house tile");
		lua_pushnil(L);
		return 1;
	}

	Lua::pushBoolean(L, house->transferToDepot(actor, houseTile));
	return 1;
}
