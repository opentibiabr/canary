/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/game.hpp"
#include "creatures/creature.hpp"
#include "creatures/npcs/npc.hpp"
#include "lua/functions/creatures/npc/npc_functions.hpp"
#include "map/spectators.hpp"

int NpcFunctions::luaNpcCreate(lua_State* L) {
	// Npc([id or name or userdata])
	std::shared_ptr<Npc> npc;
	if (lua_gettop(L) >= 2) {
		if (isNumber(L, 2)) {
			npc = g_game().getNpcByID(getNumber<uint32_t>(L, 2));
		} else if (isString(L, 2)) {
			npc = g_game().getNpcByName(getString(L, 2));
		} else if (isUserdata(L, 2)) {
			if (getUserdataType(L, 2) != LuaData_t::Npc) {
				lua_pushnil(L);
				return 1;
			}
			npc = getUserdataShared<Npc>(L, 2);
		} else {
			npc = nullptr;
		}
	} else {
		npc = getUserdataShared<Npc>(L, 1);
	}

	if (npc) {
		pushUserdata<Npc>(L, npc);
		setMetatable(L, -1, "Npc");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcFunctions::luaNpcIsNpc(lua_State* L) {
	// npc:isNpc()
	pushBoolean(L, getUserdataShared<const Npc>(L, 1) != nullptr);
	return 1;
}

int NpcFunctions::luaNpcSetMasterPos(lua_State* L) {
	// npc:setMasterPos(pos)
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	const Position &pos = getPosition(L, 2);
	npc->setMasterPos(pos);
	pushBoolean(L, true);
	return 1;
}

int NpcFunctions::luaNpcGetCurrency(lua_State* L) {
	// npc:getCurrency()
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
	}

	lua_pushnumber(L, npc->getCurrency());
	return 1;
}

int NpcFunctions::luaNpcSetCurrency(lua_State* L) {
	// npc:getCurrency()
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	npc->setCurrency(getNumber<uint16_t>(L, 2));
	return 1;
}

int NpcFunctions::luaNpcGetSpeechBubble(lua_State* L) {
	// npc:getSpeechBubble()
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
	}

	lua_pushnumber(L, npc->getSpeechBubble());
	return 1;
}

int NpcFunctions::luaNpcSetSpeechBubble(lua_State* L) {
	// npc:setSpeechBubble(speechBubble)
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
	}

	npc->setSpeechBubble(getNumber<uint8_t>(L, 2));
	return 1;
}

int NpcFunctions::luaNpcGetName(lua_State* L) {
	// npc:getName()
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	pushString(L, npc->getName());
	return 1;
}

int NpcFunctions::luaNpcSetName(lua_State* L) {
	// npc:setName(name)
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	const std::string &name = getString(L, 2);
	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
	}

	npc->setName(name);
	return 1;
}

int NpcFunctions::luaNpcPlace(lua_State* L) {
	// npc:place(position[, extended = false[, force = true]])
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	const Position &position = getPosition(L, 2);
	bool extended = getBoolean(L, 3, false);
	bool force = getBoolean(L, 4, true);
	if (g_game().placeCreature(npc, position, extended, force)) {
		pushUserdata<Npc>(L, npc);
		setMetatable(L, -1, "Npc");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcFunctions::luaNpcSay(lua_State* L) {
	// npc:say(text[, type = TALKTYPE_PRIVATE_NP[, ghost = false[, target = nullptr[, position]]]])
	int parameters = lua_gettop(L);

	Position position;
	if (parameters >= 6) {
		position = getPosition(L, 6);
		if (!position.x || !position.y) {
			reportErrorFunc("Invalid position specified.");
			pushBoolean(L, false);
			return 1;
		}
	}

	std::shared_ptr<Creature> target = nullptr;
	if (parameters >= 5) {
		target = getCreature(L, 5);
	}

	bool ghost = getBoolean(L, 4, false);

	SpeakClasses type = getNumber<SpeakClasses>(L, 3, TALKTYPE_PRIVATE_NP);
	const std::string &text = getString(L, 2);
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (!npc) {
		lua_pushnil(L);
		return 1;
	}

	Spectators spectators;
	if (target) {
		spectators.insert(target);
	}

	if (position.x != 0) {
		pushBoolean(L, g_game().internalCreatureSay(npc, type, text, ghost, &spectators, &position));
	} else {
		pushBoolean(L, g_game().internalCreatureSay(npc, type, text, ghost, &spectators));
	}
	return 1;
}

/**
 * @param creature, Is the creature that the npc will focus on
 * @param true, If true, force stop walk, if @param false, do not force stop walk
 */
int NpcFunctions::luaNpcTurnToCreature(lua_State* L) {
	// npc:turnToCreature(creature, true)
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	std::shared_ptr<Creature> creature = getCreature(L, 2);

	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	bool stopEventWalk = getBoolean(L, 3, true);
	if (stopEventWalk) {
		npc->stopEventWalk();
	}
	npc->turnToCreature(creature);
	pushBoolean(L, true);
	return 1;
}

int NpcFunctions::luaNpcSetPlayerInteraction(lua_State* L) {
	// npc:setPlayerInteraction(creature, topic = 0)
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	std::shared_ptr<Creature> creature = getCreature(L, 2);
	uint16_t topicId = getNumber<uint16_t>(L, 3, 0);

	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	npc->setPlayerInteraction(creature->getID(), topicId);
	pushBoolean(L, true);
	return 1;
}

int NpcFunctions::luaNpcRemovePlayerInteraction(lua_State* L) {
	// npc:removePlayerInteraction()
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	std::shared_ptr<Creature> creature = getCreature(L, 2);

	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	npc->removePlayerInteraction(creature->getPlayer());
	pushBoolean(L, true);
	return 1;
}

int NpcFunctions::luaNpcIsInteractingWithPlayer(lua_State* L) {
	// npc:isInteractingWithPlayer(creature)
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	std::shared_ptr<Creature> creature = getCreature(L, 2);

	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, npc->isInteractingWithPlayer(creature->getID()));
	return 1;
}

int NpcFunctions::luaNpcIsPlayerInteractingOnTopic(lua_State* L) {
	// npc:isPlayerInteractingOnTopic(creature, topicId = 0)
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	std::shared_ptr<Creature> creature = getCreature(L, 2);
	uint32_t topicId = getNumber<uint32_t>(L, 3, 0);

	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, npc->isPlayerInteractingOnTopic(creature->getID(), topicId));
	return 1;
}

int NpcFunctions::luaNpcIsInTalkRange(lua_State* L) {
	// npc:isInTalkRange(position[, range = 4])
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	const Position &position = getPosition(L, 2);
	uint32_t range = getNumber<uint32_t>(L, 3, 4);

	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, npc && npc->canInteract(position, range));
	return 1;
}

int NpcFunctions::luaNpcOpenShopWindow(lua_State* L) {
	// npc:openShopWindow(player)
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	const auto &player = getPlayer(L, 2);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	player->closeShopWindow();
	pushBoolean(L, player->openShopWindow(npc));
	return 1;
}

int NpcFunctions::luaNpcOpenShopWindowTable(lua_State* L) {
	// npc:openShopWindowTable(player, items)
	const auto &npc = getUserdataShared<Npc>(L, 1);
	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	const auto &player = getUserdataShared<Player>(L, 2);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	if (lua_istable(L, 3) == 0) {
		reportError(__FUNCTION__, "item list is not a table.");
		pushBoolean(L, false);
		return 1;
	}

	std::vector<ShopBlock> items;
	lua_pushnil(L);
	while (lua_next(L, 3) != 0) {
		const auto tableIndex = lua_gettop(L);

		auto itemId = getField<uint16_t>(L, tableIndex, "clientId");
		auto subType = getField<int32_t>(L, tableIndex, "subType");
		if (subType == 0) {
			subType = getField<int32_t>(L, tableIndex, "subtype");
			lua_pop(L, 1);
		}

		auto buyPrice = getField<uint32_t>(L, tableIndex, "buy");
		auto sellPrice = getField<uint32_t>(L, tableIndex, "sell");
		auto storageKey = getField<int32_t>(L, tableIndex, "storageKey");
		auto storageValue = getField<int32_t>(L, tableIndex, "storageValue");
		auto itemName = getFieldString(L, tableIndex, "itemName");
		if (itemName.empty()) {
			itemName = Item::items[itemId].name;
		}
		items.emplace_back(itemId, itemName, subType, buyPrice, sellPrice, storageKey, storageValue);
		lua_pop(L, 8);
	}
	lua_pop(L, 3);

	player->closeShopWindow();
	pushBoolean(L, player->openShopWindow(npc, items));
	return 1;
}

int NpcFunctions::luaNpcCloseShopWindow(lua_State* L) {
	// npc:closeShopWindow(player)
	const auto &player = getPlayer(L, 2);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	if (player->getShopOwner() == npc) {
		player->closeShopWindow();
	}

	pushBoolean(L, true);
	return 1;
}

int NpcFunctions::luaNpcIsMerchant(lua_State* L) {
	// npc:isMerchant()
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	auto playerGUID = getNumber<uint32_t>(L, 2, 0);
	const auto &shopItems = npc->getShopItemVector(playerGUID);
	if (shopItems.empty()) {
		pushBoolean(L, false);
		return 1;
	}

	pushBoolean(L, true);
	return 1;
}

int NpcFunctions::luaNpcGetShopItem(lua_State* L) {
	// npc:getShopItem(itemId)
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	auto playerGUID = getNumber<uint32_t>(L, 2, 0);
	const auto &shopItems = npc->getShopItemVector(playerGUID);
	for (ShopBlock shopBlock : shopItems) {
		setField(L, "id", shopBlock.itemId);
		setField(L, "name", shopBlock.itemName);
		setField(L, "subType", shopBlock.itemSubType);
		setField(L, "buyPrice", shopBlock.itemBuyPrice);
		setField(L, "sellPrice", shopBlock.itemSellPrice);
		setField(L, "storageKey", shopBlock.itemStorageKey);
		setField(L, "storageValue", shopBlock.itemStorageValue);
	}

	pushBoolean(L, true);
	return 1;
}

int NpcFunctions::luaNpcMove(lua_State* L) {
	// npc:move(direction)
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (npc) {
		g_game().internalMoveCreature(npc, getNumber<Direction>(L, 2));
	}
	return 0;
}

int NpcFunctions::luaNpcTurn(lua_State* L) {
	// npc:turn(direction)
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (npc) {
		g_game().internalCreatureTurn(npc, getNumber<Direction>(L, 2));
	}
	return 0;
}

int NpcFunctions::luaNpcFollow(lua_State* L) {
	// npc:follow(player)
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (!npc) {
		pushBoolean(L, false);
		return 1;
	}

	const auto &player = getPlayer(L, 2);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	pushBoolean(L, npc->setFollowCreature(player));
	return 1;
}

int NpcFunctions::luaNpcGetId(lua_State* L) {
	// npc:getId()
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, npc->getID());
	return 1;
}

int NpcFunctions::luaNpcSellItem(lua_State* L) {
	// npc:sellItem(player, itemid, amount, <optional: default: 1> subtype, <optional: default: 0> actionid, <optional: default: false> ignoreCap, <optional: default: false> inBackpacks)
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	const auto &player = getPlayer(L, 2);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	uint16_t itemId = getNumber<uint16_t>(L, 3);
	double amount = getNumber<double>(L, 4);
	uint16_t subType = getNumber<uint16_t>(L, 5, 1);
	uint16_t actionId = getNumber<uint16_t>(L, 6, 0);
	bool ignoreCap = getBoolean(L, 7, false);
	bool inBackpacks = getBoolean(L, 8, false);

	const ItemType &it = Item::items[itemId];
	if (it.id == 0) {
		pushBoolean(L, false);
		return 1;
	}

	uint32_t shoppingBagPrice = 20;
	double shoppingBagSlots = 20;
	if (std::shared_ptr<Tile> tile = ignoreCap ? player->getTile() : nullptr; tile) {
		double slotsNedeed = 0;
		if (it.stackable) {
			slotsNedeed = inBackpacks ? std::ceil(std::ceil(amount / it.stackSize) / shoppingBagSlots) : std::ceil(amount / it.stackSize);
		} else {
			slotsNedeed = inBackpacks ? std::ceil(amount / shoppingBagSlots) : amount;
		}

		if ((static_cast<double>(tile->getItemList()->size()) + (slotsNedeed - player->getFreeBackpackSlots())) > 30) {
			pushBoolean(L, false);
			player->sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
			return 1;
		}
	}

	uint64_t pricePerUnit = 0;
	const auto &shopVector = npc->getShopItemVector(player->getGUID());
	for (ShopBlock shopBlock : shopVector) {
		if (itemId == shopBlock.itemId && shopBlock.itemBuyPrice != 0) {
			pricePerUnit = shopBlock.itemBuyPrice;
			break;
		}
	}

	const auto &[_, itemsPurchased, backpacksPurchased] = g_game().createItem(player, itemId, amount, subType, actionId, ignoreCap, inBackpacks ? ITEM_SHOPPING_BAG : 0);

	std::stringstream ss;
	uint64_t itemCost = itemsPurchased * pricePerUnit;
	uint64_t backpackCost = backpacksPurchased * shoppingBagPrice;
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
	pushBoolean(L, true);
	return 1;
}

int NpcFunctions::luaNpcGetDistanceTo(lua_State* L) {
	// npc:getDistanceTo(uid)
	std::shared_ptr<Npc> npc = getUserdataShared<Npc>(L, 1);
	if (!npc) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	std::shared_ptr<Thing> thing = getScriptEnv()->getThingByUID(getNumber<uint32_t>(L, -1));
	pushBoolean(L, thing && thing->isPushable());
	if (!thing) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_THING_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	const Position &thingPos = thing->getPosition();
	const Position &npcPos = npc->getPosition();
	if (npcPos.z != thingPos.z) {
		lua_pushnumber(L, -1);
	} else {
		int32_t dist = std::max<int32_t>(Position::getDistanceX(npcPos, thingPos), Position::getDistanceY(npcPos, thingPos));
		lua_pushnumber(L, dist);
	}
	return 1;
}
