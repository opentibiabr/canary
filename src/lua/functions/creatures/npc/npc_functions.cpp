/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/npc/npc_functions.hpp"

#include "creatures/creature.hpp"
#include "creatures/npcs/npc.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "map/spectators.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void NpcFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Npc", "Creature", NpcFunctions::luaNpcCreate);
	Lua::registerMetaMethod(L, "Npc", "__eq", Lua::luaUserdataCompare);
	Lua::registerMethod(L, "Npc", "isNpc", NpcFunctions::luaNpcIsNpc);
	Lua::registerMethod(L, "Npc", "setMasterPos", NpcFunctions::luaNpcSetMasterPos);
	Lua::registerMethod(L, "Npc", "getCurrency", NpcFunctions::luaNpcGetCurrency);
	Lua::registerMethod(L, "Npc", "setCurrency", NpcFunctions::luaNpcSetCurrency);
	Lua::registerMethod(L, "Npc", "getSpeechBubble", NpcFunctions::luaNpcGetSpeechBubble);
	Lua::registerMethod(L, "Npc", "setSpeechBubble", NpcFunctions::luaNpcSetSpeechBubble);
	Lua::registerMethod(L, "Npc", "getId", NpcFunctions::luaNpcGetId);
	Lua::registerMethod(L, "Npc", "getName", NpcFunctions::luaNpcGetName);
	Lua::registerMethod(L, "Npc", "setName", NpcFunctions::luaNpcSetName);
	Lua::registerMethod(L, "Npc", "place", NpcFunctions::luaNpcPlace);
	Lua::registerMethod(L, "Npc", "say", NpcFunctions::luaNpcSay);
	Lua::registerMethod(L, "Npc", "turnToCreature", NpcFunctions::luaNpcTurnToCreature);
	Lua::registerMethod(L, "Npc", "setPlayerInteraction", NpcFunctions::luaNpcSetPlayerInteraction);
	Lua::registerMethod(L, "Npc", "removePlayerInteraction", NpcFunctions::luaNpcRemovePlayerInteraction);
	Lua::registerMethod(L, "Npc", "isInteractingWithPlayer", NpcFunctions::luaNpcIsInteractingWithPlayer);
	Lua::registerMethod(L, "Npc", "isInTalkRange", NpcFunctions::luaNpcIsInTalkRange);
	Lua::registerMethod(L, "Npc", "isPlayerInteractingOnTopic", NpcFunctions::luaNpcIsPlayerInteractingOnTopic);
	Lua::registerMethod(L, "Npc", "openShopWindow", NpcFunctions::luaNpcOpenShopWindow);
	Lua::registerMethod(L, "Npc", "openShopWindowTable", NpcFunctions::luaNpcOpenShopWindowTable);
	Lua::registerMethod(L, "Npc", "closeShopWindow", NpcFunctions::luaNpcCloseShopWindow);
	Lua::registerMethod(L, "Npc", "getShopItem", NpcFunctions::luaNpcGetShopItem);
	Lua::registerMethod(L, "Npc", "isMerchant", NpcFunctions::luaNpcIsMerchant);

	Lua::registerMethod(L, "Npc", "move", NpcFunctions::luaNpcMove);
	Lua::registerMethod(L, "Npc", "turn", NpcFunctions::luaNpcTurn);
	Lua::registerMethod(L, "Npc", "follow", NpcFunctions::luaNpcFollow);
	Lua::registerMethod(L, "Npc", "sellItem", NpcFunctions::luaNpcSellItem);

	Lua::registerMethod(L, "Npc", "getDistanceTo", NpcFunctions::luaNpcGetDistanceTo);

	ShopFunctions::init(L);
	NpcTypeFunctions::init(L);
}

int NpcFunctions::luaNpcCreate(lua_State* L) {
	// Npc([id or name or userdata])
	std::shared_ptr<Npc> npc;
	if (lua_gettop(L) >= 2) {
		if (Lua::isNumber(L, 2)) {
			npc = g_game().getNpcByID(Lua::getNumber<uint32_t>(L, 2));
		} else if (Lua::isString(L, 2)) {
			npc = g_game().getNpcByName(Lua::getString(L, 2));
		} else if (Lua::isUserdata(L, 2)) {
			if (Lua::getUserdataType(L, 2) != LuaData_t::Npc) {
				lua_pushnil(L);
				return 1;
			}
			npc = Lua::getUserdataShared<Npc>(L, 2, "Npc");
		} else {
			npc = nullptr;
		}
	} else {
		npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	}

	if (npc) {
		Lua::pushUserdata<Npc>(L, npc);
		Lua::setMetatable(L, -1, "Npc");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcFunctions::luaNpcIsNpc(lua_State* L) {
	// npc:isNpc()
	Lua::pushBoolean(L, Lua::getUserdataShared<Npc>(L, 1, "Npc") != nullptr);
	return 1;
}

int NpcFunctions::luaNpcSetMasterPos(lua_State* L) {
	// npc:setMasterPos(pos)
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const Position &pos = Lua::getPosition(L, 2);
	npc->setMasterPos(pos);
	Lua::pushBoolean(L, true);
	return 1;
}

int NpcFunctions::luaNpcGetCurrency(lua_State* L) {
	// npc:getCurrency()
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
	}

	lua_pushnumber(L, npc->getCurrency());
	return 1;
}

int NpcFunctions::luaNpcSetCurrency(lua_State* L) {
	// npc:getCurrency()
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	npc->setCurrency(Lua::getNumber<uint16_t>(L, 2));
	return 1;
}

int NpcFunctions::luaNpcGetSpeechBubble(lua_State* L) {
	// npc:getSpeechBubble()
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
	}

	lua_pushnumber(L, npc->getSpeechBubble());
	return 1;
}

int NpcFunctions::luaNpcSetSpeechBubble(lua_State* L) {
	// npc:setSpeechBubble(speechBubble)
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
	}

	npc->setSpeechBubble(Lua::getNumber<uint8_t>(L, 2));
	return 1;
}

int NpcFunctions::luaNpcGetName(lua_State* L) {
	// npc:getName()
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	Lua::pushString(L, npc->getName());
	return 1;
}

int NpcFunctions::luaNpcSetName(lua_State* L) {
	// npc:setName(name)
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	const std::string &name = Lua::getString(L, 2);
	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
	}

	npc->setName(name);
	return 1;
}

int NpcFunctions::luaNpcPlace(lua_State* L) {
	// npc:place(position[, extended = false[, force = true]])
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	const Position &position = Lua::getPosition(L, 2);
	const bool extended = Lua::getBoolean(L, 3, false);
	const bool force = Lua::getBoolean(L, 4, true);
	if (g_game().placeCreature(npc, position, extended, force)) {
		Lua::pushUserdata<Npc>(L, npc);
		Lua::setMetatable(L, -1, "Npc");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcFunctions::luaNpcSay(lua_State* L) {
	// npc:say(text[, type = TALKTYPE_PRIVATE_NP[, ghost = false[, target = nullptr[, position]]]])
	const int parameters = lua_gettop(L);

	Position position;
	if (parameters >= 6) {
		position = Lua::getPosition(L, 6);
		if (!position.x || !position.y) {
			Lua::reportErrorFunc("Invalid position specified.");
			Lua::pushBoolean(L, false);
			return 1;
		}
	}

	std::shared_ptr<Creature> target = nullptr;
	if (parameters >= 5) {
		target = Lua::getCreature(L, 5);
	}

	const bool ghost = Lua::getBoolean(L, 4, false);

	const auto &type = Lua::getNumber<SpeakClasses>(L, 3, TALKTYPE_PRIVATE_NP);
	const std::string &text = Lua::getString(L, 2);
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (!npc) {
		lua_pushnil(L);
		return 1;
	}

	Spectators spectators;
	if (target) {
		spectators.insert(target);
	}

	if (position.x != 0) {
		Lua::pushBoolean(L, g_game().internalCreatureSay(npc, type, text, ghost, &spectators, &position));
	} else {
		Lua::pushBoolean(L, g_game().internalCreatureSay(npc, type, text, ghost, &spectators));
	}
	return 1;
}

/**
 * @param creature, Is the creature that the npc will focus on
 * @param true, If true, force stop walk, if @param false, do not force stop walk
 */
int NpcFunctions::luaNpcTurnToCreature(lua_State* L) {
	// npc:turnToCreature(creature, true)
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	const auto &creature = Lua::getCreature(L, 2);

	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (!creature) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	const bool stopEventWalk = Lua::getBoolean(L, 3, true);
	if (stopEventWalk) {
		npc->stopEventWalk();
	}
	npc->turnToCreature(creature);
	Lua::pushBoolean(L, true);
	return 1;
}

int NpcFunctions::luaNpcSetPlayerInteraction(lua_State* L) {
	// npc:setPlayerInteraction(creature, topic = 0)
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	const auto &creature = Lua::getCreature(L, 2);
	const auto topicId = Lua::getNumber<uint16_t>(L, 3, 0);

	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (!creature) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	npc->setPlayerInteraction(creature->getID(), topicId);
	Lua::pushBoolean(L, true);
	return 1;
}

int NpcFunctions::luaNpcRemovePlayerInteraction(lua_State* L) {
	// npc:removePlayerInteraction()
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	const auto &creature = Lua::getCreature(L, 2);

	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (!creature) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	npc->removePlayerInteraction(creature->getPlayer());
	Lua::pushBoolean(L, true);
	return 1;
}

int NpcFunctions::luaNpcIsInteractingWithPlayer(lua_State* L) {
	// npc:isInteractingWithPlayer(creature)
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	const auto &creature = Lua::getCreature(L, 2);

	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (!creature) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	Lua::pushBoolean(L, npc->isInteractingWithPlayer(creature->getID()));
	return 1;
}

int NpcFunctions::luaNpcIsPlayerInteractingOnTopic(lua_State* L) {
	// npc:isPlayerInteractingOnTopic(creature, topicId = 0)
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	const auto &creature = Lua::getCreature(L, 2);
	const auto topicId = Lua::getNumber<uint32_t>(L, 3, 0);

	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (!creature) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	Lua::pushBoolean(L, npc->isPlayerInteractingOnTopic(creature->getID(), topicId));
	return 1;
}

int NpcFunctions::luaNpcIsInTalkRange(lua_State* L) {
	// npc:isInTalkRange(position[, range = 4])
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	const Position &position = Lua::getPosition(L, 2);
	const auto range = Lua::getNumber<uint32_t>(L, 3, 4);

	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	Lua::pushBoolean(L, npc && npc->canInteract(position, range));
	return 1;
}

int NpcFunctions::luaNpcOpenShopWindow(lua_State* L) {
	// npc:openShopWindow(player)
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &player = Lua::getPlayer(L, 2);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	player->closeShopWindow();
	Lua::pushBoolean(L, player->openShopWindow(npc));
	return 1;
}

int NpcFunctions::luaNpcOpenShopWindowTable(lua_State* L) {
	// npc:openShopWindowTable(player, items)
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &player = Lua::getUserdataShared<Player>(L, 2, "Player");
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	if (lua_istable(L, 3) == 0) {
		Lua::reportError(__FUNCTION__, "item list is not a table.");
		Lua::pushBoolean(L, false);
		return 1;
	}

	std::vector<ShopBlock> items;
	lua_pushnil(L);
	while (lua_next(L, 3) != 0) {
		const auto tableIndex = lua_gettop(L);

		auto itemId = Lua::getField<uint16_t>(L, tableIndex, "clientId");
		auto subType = Lua::getField<int32_t>(L, tableIndex, "subType");
		if (subType == 0) {
			subType = Lua::getField<int32_t>(L, tableIndex, "subtype");
			lua_pop(L, 1);
		}

		auto buyPrice = Lua::getField<uint32_t>(L, tableIndex, "buy");
		auto sellPrice = Lua::getField<uint32_t>(L, tableIndex, "sell");
		auto storageKey = Lua::getField<int32_t>(L, tableIndex, "storageKey");
		auto storageValue = Lua::getField<int32_t>(L, tableIndex, "storageValue");
		auto itemName = Lua::getFieldString(L, tableIndex, "itemName");
		if (itemName.empty()) {
			itemName = Item::items[itemId].name;
		}
		items.emplace_back(itemId, itemName, subType, buyPrice, sellPrice, storageKey, storageValue);
		lua_pop(L, 8);
	}
	lua_pop(L, 3);

	player->closeShopWindow();
	Lua::pushBoolean(L, player->openShopWindow(npc, items));
	return 1;
}

int NpcFunctions::luaNpcCloseShopWindow(lua_State* L) {
	// npc:closeShopWindow(player)
	const auto &player = Lua::getPlayer(L, 2);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (player->getShopOwner() == npc) {
		player->closeShopWindow();
	}

	Lua::pushBoolean(L, true);
	return 1;
}

int NpcFunctions::luaNpcIsMerchant(lua_State* L) {
	// npc:isMerchant()
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto playerGUID = Lua::getNumber<uint32_t>(L, 2, 0);
	const auto &shopItems = npc->getShopItemVector(playerGUID);
	if (shopItems.empty()) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	Lua::pushBoolean(L, true);
	return 1;
}

int NpcFunctions::luaNpcGetShopItem(lua_State* L) {
	// npc:getShopItem(itemId)
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto playerGUID = Lua::getNumber<uint32_t>(L, 2, 0);
	const auto &shopItems = npc->getShopItemVector(playerGUID);
	for (const ShopBlock &shopBlock : shopItems) {
		Lua::setField(L, "id", shopBlock.itemId);
		Lua::setField(L, "name", shopBlock.itemName);
		Lua::setField(L, "subType", shopBlock.itemSubType);
		Lua::setField(L, "buyPrice", shopBlock.itemBuyPrice);
		Lua::setField(L, "sellPrice", shopBlock.itemSellPrice);
		Lua::setField(L, "storageKey", shopBlock.itemStorageKey);
		Lua::setField(L, "storageValue", shopBlock.itemStorageValue);
	}

	Lua::pushBoolean(L, true);
	return 1;
}

int NpcFunctions::luaNpcMove(lua_State* L) {
	// npc:move(direction)
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (npc) {
		g_game().internalMoveCreature(npc, Lua::getNumber<Direction>(L, 2));
	}
	return 0;
}

int NpcFunctions::luaNpcTurn(lua_State* L) {
	// npc:turn(direction)
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (npc) {
		g_game().internalCreatureTurn(npc, Lua::getNumber<Direction>(L, 2));
	}
	return 0;
}

int NpcFunctions::luaNpcFollow(lua_State* L) {
	// npc:follow(player)
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (!npc) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &player = Lua::getPlayer(L, 2);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	Lua::pushBoolean(L, npc->setFollowCreature(player));
	return 1;
}

int NpcFunctions::luaNpcGetId(lua_State* L) {
	// npc:getId()
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, npc->getID());
	return 1;
}

int NpcFunctions::luaNpcSellItem(lua_State* L) {
	// npc:sellItem(player, itemid, amount, <optional: default: 1> subtype, <optional: default: 0> actionid, <optional: default: false> ignoreCap, <optional: default: false> inBackpacks)
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &player = Lua::getPlayer(L, 2);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	auto itemId = Lua::getNumber<uint16_t>(L, 3);
	const double amount = Lua::getNumber<double>(L, 4);
	const auto subType = Lua::getNumber<uint16_t>(L, 5, 1);
	const auto actionId = Lua::getNumber<uint16_t>(L, 6, 0);
	const bool ignoreCap = Lua::getBoolean(L, 7, false);
	const bool inBackpacks = Lua::getBoolean(L, 8, false);

	const ItemType &it = Item::items[itemId];
	if (it.id == 0) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	constexpr uint32_t shoppingBagPrice = 20;
	constexpr double shoppingBagSlots = 20;
	if (const auto &tile = ignoreCap ? player->getTile() : nullptr; tile) {
		double slotsNedeed = 0;
		if (it.stackable) {
			slotsNedeed = inBackpacks ? std::ceil(std::ceil(amount / it.stackSize) / shoppingBagSlots) : std::ceil(amount / it.stackSize);
		} else {
			slotsNedeed = inBackpacks ? std::ceil(amount / shoppingBagSlots) : amount;
		}

		if ((static_cast<double>(tile->getItemList()->size()) + (slotsNedeed - player->getFreeBackpackSlots())) > 30) {
			Lua::pushBoolean(L, false);
			player->sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
			return 1;
		}
	}

	uint64_t pricePerUnit = 0;
	const auto &shopVector = npc->getShopItemVector(player->getGUID());
	for (const ShopBlock &shopBlock : shopVector) {
		if (itemId == shopBlock.itemId && shopBlock.itemBuyPrice != 0) {
			pricePerUnit = shopBlock.itemBuyPrice;
			break;
		}
	}

	const auto &[_, itemsPurchased, backpacksPurchased] = g_game().createItem(player, itemId, amount, subType, actionId, ignoreCap, inBackpacks ? ITEM_SHOPPING_BAG : 0);

	std::stringstream ss;
	const uint64_t itemCost = itemsPurchased * pricePerUnit;
	const uint64_t backpackCost = backpacksPurchased * shoppingBagPrice;
	if (npc->getCurrency() == ITEM_GOLD_COIN) {
		if (!g_game().removeMoney(player, itemCost + backpackCost, 0, true)) {
			g_logger().error("[NpcFunctions::luaNpcSellItem (removeMoney)] - Player {} have a problem for buy item {} on shop for npc {}", player->getName(), itemId, npc->getName());
			g_logger().debug("[Information] Player {} bought {} x item {} on shop for npc {}, at position {}", player->getName(), itemsPurchased, itemId, npc->getName(), player->getPosition().toString());
		} else if (backpacksPurchased > 0) {
			ss << "Bought " << std::to_string(itemsPurchased) << "x " << it.name << " and " << std::to_string(backpacksPurchased);
			if (backpacksPurchased > 1) {
				ss << " shopping bags for " << std::to_string(itemCost + backpackCost) << " gold coin";
			} else {
				ss << " shopping bag for " << std::to_string(itemCost + backpackCost) << " gold coin";
			}
			if ((itemCost + backpackCost) > 1) {
				ss << "s.";
			} else {
				ss << ".";
			}
		} else {
			ss << "Bought " << std::to_string(itemsPurchased) << "x " << it.name << " for " << std::to_string(itemCost) << " gold coin";
			if (itemCost > 1) {
				ss << "s.";
			} else {
				ss << ".";
			}
		}
	} else {
		if (!g_game().removeMoney(player, backpackCost, 0, true) || !player->removeItemOfType(npc->getCurrency(), itemCost, -1, false)) {
			g_logger().error("[NpcFunctions::luaNpcSellItem (removeItemOfType)] - Player {} have a problem for buy item {} on shop for npc {}", player->getName(), itemId, npc->getName());
			g_logger().debug("[Information] Player {} buyed item {} on shop for npc {}, at position {}", player->getName(), itemId, npc->getName(), player->getPosition().toString());
		} else if (backpacksPurchased > 0) {
			ss << "Bought " << std::to_string(itemsPurchased) << "x " << it.name << " for " << std::to_string(itemCost) << " " << Item::items[npc->getCurrency()].name;
			if (itemCost > 1) {
				ss << "s";
			}
			ss << " and " << std::to_string(backpacksPurchased) << "x shopping bag";
			if (backpacksPurchased > 1) {
				ss << "s";
			}
			ss << " for " << std::to_string(backpackCost) << " gold coin";
			if (backpackCost > 1) {
				ss << "s.";
			} else {
				ss << ".";
			}
		} else {
			ss << "Bought " << std::to_string(itemsPurchased) << "x " << it.name << " for " << std::to_string(itemCost) << " " << Item::items[npc->getCurrency()].name;
			if (itemCost > 1) {
				ss << "s.";
			} else {
				ss << ".";
			}
		}
	}

	player->sendTextMessage(MESSAGE_TRADE, ss.str());
	Lua::pushBoolean(L, true);
	return 1;
}

int NpcFunctions::luaNpcGetDistanceTo(lua_State* L) {
	// npc:getDistanceTo(uid)
	const auto &npc = Lua::getUserdataShared<Npc>(L, 1, "Npc");
	if (!npc) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &thing = Lua::getScriptEnv()->getThingByUID(Lua::getNumber<uint32_t>(L, -1));
	Lua::pushBoolean(L, thing && thing->isPushable());
	if (!thing) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_THING_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	const Position &thingPos = thing->getPosition();
	const Position &npcPos = npc->getPosition();
	if (npcPos.z != thingPos.z) {
		lua_pushnumber(L, -1);
	} else {
		const int32_t dist = std::max<int32_t>(Position::getDistanceX(npcPos, thingPos), Position::getDistanceY(npcPos, thingPos));
		lua_pushnumber(L, dist);
	}
	return 1;
}
