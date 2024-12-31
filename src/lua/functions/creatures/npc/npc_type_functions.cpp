/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/npc/npc_type_functions.hpp"

#include "config/configmanager.hpp"
#include "creatures/npcs/npcs.hpp"
#include "game/game.hpp"
#include "lua/scripts/scripts.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void NpcTypeFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "NpcType", "", NpcTypeFunctions::luaNpcTypeCreate);
	Lua::registerMetaMethod(L, "NpcType", "__eq", Lua::luaUserdataCompare);

	Lua::registerMethod(L, "NpcType", "isPushable", NpcTypeFunctions::luaNpcTypeIsPushable);
	Lua::registerMethod(L, "NpcType", "floorChange", NpcTypeFunctions::luaNpcTypeFloorChange);

	Lua::registerMethod(L, "NpcType", "canSpawn", NpcTypeFunctions::luaNpcTypeCanSpawn);

	Lua::registerMethod(L, "NpcType", "canPushItems", NpcTypeFunctions::luaNpcTypeCanPushItems);
	Lua::registerMethod(L, "NpcType", "canPushCreatures", NpcTypeFunctions::luaNpcTypeCanPushCreatures);

	Lua::registerMethod(L, "NpcType", "name", NpcTypeFunctions::luaNpcTypeName);

	Lua::registerMethod(L, "NpcType", "nameDescription", NpcTypeFunctions::luaNpcTypeNameDescription);

	Lua::registerMethod(L, "NpcType", "health", NpcTypeFunctions::luaNpcTypeHealth);
	Lua::registerMethod(L, "NpcType", "maxHealth", NpcTypeFunctions::luaNpcTypeMaxHealth);

	Lua::registerMethod(L, "NpcType", "getVoices", NpcTypeFunctions::luaNpcTypeGetVoices);
	Lua::registerMethod(L, "NpcType", "addVoice", NpcTypeFunctions::luaNpcTypeAddVoice);

	Lua::registerMethod(L, "NpcType", "getCreatureEvents", NpcTypeFunctions::luaNpcTypeGetCreatureEvents);
	Lua::registerMethod(L, "NpcType", "registerEvent", NpcTypeFunctions::luaNpcTypeRegisterEvent);

	Lua::registerMethod(L, "NpcType", "eventType", NpcTypeFunctions::luaNpcTypeEventType);
	Lua::registerMethod(L, "NpcType", "onThink", NpcTypeFunctions::luaNpcTypeEventOnCallback);
	Lua::registerMethod(L, "NpcType", "onAppear", NpcTypeFunctions::luaNpcTypeEventOnCallback);
	Lua::registerMethod(L, "NpcType", "onDisappear", NpcTypeFunctions::luaNpcTypeEventOnCallback);
	Lua::registerMethod(L, "NpcType", "onMove", NpcTypeFunctions::luaNpcTypeEventOnCallback);
	Lua::registerMethod(L, "NpcType", "onSay", NpcTypeFunctions::luaNpcTypeEventOnCallback);
	Lua::registerMethod(L, "NpcType", "onCloseChannel", NpcTypeFunctions::luaNpcTypeEventOnCallback);
	Lua::registerMethod(L, "NpcType", "onBuyItem", NpcTypeFunctions::luaNpcTypeEventOnCallback);
	Lua::registerMethod(L, "NpcType", "onSellItem", NpcTypeFunctions::luaNpcTypeEventOnCallback);
	Lua::registerMethod(L, "NpcType", "onCheckItem", NpcTypeFunctions::luaNpcTypeEventOnCallback);

	Lua::registerMethod(L, "NpcType", "outfit", NpcTypeFunctions::luaNpcTypeOutfit);
	Lua::registerMethod(L, "NpcType", "baseSpeed", NpcTypeFunctions::luaNpcTypeBaseSpeed);
	Lua::registerMethod(L, "NpcType", "walkInterval", NpcTypeFunctions::luaNpcTypeWalkInterval);
	Lua::registerMethod(L, "NpcType", "walkRadius", NpcTypeFunctions::luaNpcTypeWalkRadius);
	Lua::registerMethod(L, "NpcType", "light", NpcTypeFunctions::luaNpcTypeLight);

	Lua::registerMethod(L, "NpcType", "yellChance", NpcTypeFunctions::luaNpcTypeYellChance);
	Lua::registerMethod(L, "NpcType", "yellSpeedTicks", NpcTypeFunctions::luaNpcTypeYellSpeedTicks);

	Lua::registerMethod(L, "NpcType", "respawnTypePeriod", NpcTypeFunctions::luaNpcTypeRespawnTypePeriod);
	Lua::registerMethod(L, "NpcType", "respawnTypeIsUnderground", NpcTypeFunctions::luaNpcTypeRespawnTypeIsUnderground);
	Lua::registerMethod(L, "NpcType", "speechBubble", NpcTypeFunctions::luaNpcTypeSpeechBubble);
	Lua::registerMethod(L, "NpcType", "currency", NpcTypeFunctions::luaNpcTypeCurrency);

	Lua::registerMethod(L, "NpcType", "addShopItem", NpcTypeFunctions::luaNpcTypeAddShopItem);

	Lua::registerMethod(L, "NpcType", "soundChance", NpcTypeFunctions::luaNpcTypeSoundChance);
	Lua::registerMethod(L, "NpcType", "soundSpeedTicks", NpcTypeFunctions::luaNpcTypeSoundSpeedTicks);
	Lua::registerMethod(L, "NpcType", "addSound", NpcTypeFunctions::luaNpcTypeAddSound);
	Lua::registerMethod(L, "NpcType", "getSounds", NpcTypeFunctions::luaNpcTypeGetSounds);
}

void NpcTypeFunctions::createNpcTypeShopLuaTable(lua_State* L, const std::vector<ShopBlock> &shopVector) {
	lua_createtable(L, shopVector.size(), 0);

	int index = 0;
	for (const auto &shopBlock : shopVector) {
		lua_createtable(L, 0, 5);

		Lua::setField(L, "itemId", shopBlock.itemId);
		Lua::setField(L, "itemName", shopBlock.itemName);
		Lua::setField(L, "itemBuyPrice", shopBlock.itemBuyPrice);
		Lua::setField(L, "itemSellPrice", shopBlock.itemSellPrice);
		Lua::setField(L, "itemStorageKey", shopBlock.itemStorageKey);
		Lua::setField(L, "itemStorageValue", shopBlock.itemStorageValue);

		createNpcTypeShopLuaTable(L, shopBlock.childShop);
		lua_setfield(L, -2, "childShop");

		lua_rawseti(L, -2, ++index);
	}
}

int NpcTypeFunctions::luaNpcTypeCreate(lua_State* L) {
	// NpcType(name)
	const auto &npcType = g_npcs().getNpcType(Lua::getString(L, 1), true);
	Lua::pushUserdata<NpcType>(L, npcType);
	Lua::setMetatable(L, -1, "NpcType");
	return 1;
}

int NpcTypeFunctions::luaNpcTypeIsPushable(lua_State* L) {
	// get: npcType:isPushable() set: npcType:isPushable(bool)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, npcType->info.pushable);
		} else {
			npcType->info.pushable = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeFloorChange(lua_State* L) {
	// get: npcType:floorChange() set: npcType:floorChange(bool)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, npcType->info.floorChange);
		} else {
			npcType->info.floorChange = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeCanSpawn(lua_State* L) {
	// monsterType:canSpawn(pos)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	const Position &position = Lua::getPosition(L, 2);
	if (npcType) {
		Lua::pushBoolean(L, npcType->canSpawn(position));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeCanPushItems(lua_State* L) {
	// get: npcType:canPushItems() set: npcType:canPushItems(bool)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, npcType->info.canPushItems);
		} else {
			npcType->info.canPushItems = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeCanPushCreatures(lua_State* L) {
	// get: npcType:canPushCreatures() set: npcType:canPushCreatures(bool)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, npcType->info.canPushCreatures);
		} else {
			npcType->info.canPushCreatures = Lua::getBoolean(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int32_t NpcTypeFunctions::luaNpcTypeName(lua_State* L) {
	// get: npcType:name() set: npcType:name(name)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			Lua::pushString(L, npcType->name);
		} else {
			npcType->name = Lua::getString(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeNameDescription(lua_State* L) {
	// get: npcType:nameDescription() set: npcType:nameDescription(desc)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			Lua::pushString(L, npcType->nameDescription);
		} else {
			npcType->nameDescription = Lua::getString(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeHealth(lua_State* L) {
	// get: npcType:health() set: npcType:health(health)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, npcType->info.health);
		} else {
			npcType->info.health = Lua::getNumber<int32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeMaxHealth(lua_State* L) {
	// get: npcType:maxHealth() set: npcType:maxHealth(health)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, npcType->info.healthMax);
		} else {
			npcType->info.healthMax = Lua::getNumber<int32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeAddShopItem(lua_State* L) {
	// npcType:addShopItem(shop)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (!npcType) {
		lua_pushnil(L);
		return 1;
	}

	const auto &shop = Lua::getUserdataShared<Shop>(L, 2);
	if (shop) {
		npcType->loadShop(npcType, shop->shopBlock);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeAddVoice(lua_State* L) {
	// npcType:addVoice(sentence, interval, chance, yell)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		voiceBlock_t voice;
		voice.text = Lua::getString(L, 2);
		npcType->info.yellSpeedTicks = Lua::getNumber<uint32_t>(L, 3);
		npcType->info.yellChance = Lua::getNumber<uint32_t>(L, 4);
		voice.yellText = Lua::getBoolean(L, 5);
		npcType->info.voiceVector.push_back(voice);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeGetVoices(lua_State* L) {
	// npcType:getVoices()
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (!npcType) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, npcType->info.voiceVector.size(), 0);
	for (const auto &voiceBlock : npcType->info.voiceVector) {
		lua_createtable(L, 0, 2);
		Lua::setField(L, "text", voiceBlock.text);
		Lua::setField(L, "yellText", voiceBlock.yellText);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeGetCreatureEvents(lua_State* L) {
	// npcType:getCreatureEvents()
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (!npcType) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, npcType->info.scripts.size(), 0);
	for (const std::string &creatureEvent : npcType->info.scripts) {
		Lua::pushString(L, creatureEvent);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeRegisterEvent(lua_State* L) {
	// npcType:registerEvent(name)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		npcType->info.scripts.insert(Lua::getString(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeEventOnCallback(lua_State* L) {
	// npcType:onThink(callback)
	// npcType:onAppear(callback)
	// npcType:onDisappear(callback)
	// npcType:onMove(callback)
	// npcType:onSay(callback)
	// npcType:onBuyItem(callback)
	// npcType:onSellItem(callback)
	// npcType:onCheckItem(callback)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		if (npcType->loadCallback(&g_scripts().getScriptInterface())) {
			Lua::pushBoolean(L, true);
			return 1;
		}
		Lua::pushBoolean(L, false);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeEventType(lua_State* L) {
	// npcType:eventType(event)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		npcType->info.eventType = Lua::getNumber<NpcsEvent_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeOutfit(lua_State* L) {
	// get: npcType:outfit() set: npcType:outfit(outfit)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			Lua::pushOutfit(L, npcType->info.outfit);
		} else {
			Outfit_t outfit = Lua::getOutfit(L, 2);
			if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && outfit.lookType != 0 && !g_game().isLookTypeRegistered(outfit.lookType)) {
				g_logger().warn("[NpcTypeFunctions::luaNpcTypeOutfit] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", outfit.lookType);
				lua_pushnil(L);
			} else {
				npcType->info.outfit = Lua::getOutfit(L, 2);
				Lua::pushBoolean(L, true);
			}
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeBaseSpeed(lua_State* L) {
	// npcType:getBaseSpeed()
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, npcType->info.baseSpeed);
		} else {
			npcType->info.baseSpeed = Lua::getNumber<uint32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeWalkInterval(lua_State* L) {
	// get: npcType:walkInterval() set: npcType:walkInterval(interval)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, npcType->info.walkInterval);
		} else {
			npcType->info.walkInterval = Lua::getNumber<uint32_t>(L, 2);
			lua_pushboolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeWalkRadius(lua_State* L) {
	// get: npcType:walkRadius() set: npcType:walkRadius(id)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, npcType->info.walkRadius);
		} else {
			npcType->info.walkRadius = Lua::getNumber<int32_t>(L, 2);
			lua_pushboolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeLight(lua_State* L) {
	// get: npcType:light() set: npcType:light(color, level)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (!npcType) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, npcType->info.light.level);
		lua_pushnumber(L, npcType->info.light.color);
		return 2;
	} else {
		npcType->info.light.color = Lua::getNumber<uint8_t>(L, 2);
		npcType->info.light.level = Lua::getNumber<uint8_t>(L, 3);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeYellChance(lua_State* L) {
	// get: npcType:yellChance() set: npcType:yellChance(chance)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			if (lua_gettop(L) == 1) {
				lua_pushnumber(L, npcType->info.yellChance);
			} else {
				npcType->info.yellChance = Lua::getNumber<uint32_t>(L, 2);
				Lua::pushBoolean(L, true);
			}
		} else {
			npcType->info.yellChance = Lua::getNumber<uint32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeYellSpeedTicks(lua_State* L) {
	// get: npcType:yellSpeedTicks() set: npcType:yellSpeedTicks(rate)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, npcType->info.yellSpeedTicks);
		} else {
			npcType->info.yellSpeedTicks = Lua::getNumber<uint32_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

/**
 * Respawn Type
 */

int NpcTypeFunctions::luaNpcTypeRespawnTypePeriod(lua_State* L) {
	// npcType:respawnTypePeriod()
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, npcType->info.respawnType.period);
		} else {
			npcType->info.respawnType.period = Lua::getNumber<RespawnPeriod_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeRespawnTypeIsUnderground(lua_State* L) {
	// npcType:respawnTypeIsUnderground()
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, npcType->info.respawnType.underground);
		} else {
			npcType->info.respawnType.underground = Lua::getNumber<RespawnPeriod_t>(L, 2);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeSpeechBubble(lua_State* L) {
	// get = npcType:speechBubble()
	// set = npcType:speechBubble(newSpeechBubble)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (!npcType) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_TYPE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, npcType->info.speechBubble);
	} else {
		npcType->info.speechBubble = Lua::getNumber<uint8_t>(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeCurrency(lua_State* L) {
	// get = npcType:currency()
	// set = npcType:currency(newCurrency)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (!npcType) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_TYPE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, npcType->info.currencyId);
	} else {
		npcType->info.currencyId = Lua::getNumber<uint16_t>(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeSoundChance(lua_State* L) {
	// get: npcType:soundChance() set: npcType:soundChance(chance)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (!npcType) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_TYPE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, npcType->info.soundChance);
	} else {
		npcType->info.soundChance = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeSoundSpeedTicks(lua_State* L) {
	// get: npcType:soundSpeedTicks() set: npcType:soundSpeedTicks(ticks)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (!npcType) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_TYPE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, npcType->info.soundSpeedTicks);
	} else {
		npcType->info.soundSpeedTicks = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeAddSound(lua_State* L) {
	// npcType:addSound(soundId)
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (!npcType) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_NPC_TYPE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	npcType->info.soundVector.push_back(Lua::getNumber<SoundEffect_t>(L, 2));
	Lua::pushBoolean(L, true);
	return 1;
}

int NpcTypeFunctions::luaNpcTypeGetSounds(lua_State* L) {
	// npcType:getSounds()
	const auto &npcType = Lua::getUserdataShared<NpcType>(L, 1);
	if (!npcType) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, static_cast<int>(npcType->info.soundVector.size()), 0);
	for (const auto &sound : npcType->info.soundVector) {
		++index;
		lua_createtable(L, 0, 1);
		lua_pushnumber(L, static_cast<lua_Number>(sound));
		lua_rawseti(L, -2, index);
	}
	return 1;
}
