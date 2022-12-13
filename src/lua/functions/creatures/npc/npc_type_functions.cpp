/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "pch.hpp"

#include "creatures/npcs/npcs.h"
#include "lua/functions/creatures/npc/npc_type_functions.hpp"
#include "lua/scripts/scripts.h"
#include "game/game.h"

void NpcTypeFunctions::createNpcTypeShopLuaTable(lua_State* L, const std::vector<ShopBlock>& shopVector) {
	lua_createtable(L, shopVector.size(), 0);

	int index = 0;
	for (const auto& shopBlock : shopVector) {
		lua_createtable(L, 0, 5);

		setField(L, "itemId", shopBlock.itemId);
		setField(L, "itemName", shopBlock.itemName);
		setField(L, "itemBuyPrice", shopBlock.itemBuyPrice);
		setField(L, "itemSellPrice", shopBlock.itemSellPrice);
		setField(L, "itemStorageKey", shopBlock.itemStorageKey);
		setField(L, "itemStorageValue", shopBlock.itemStorageValue);

		createNpcTypeShopLuaTable(L, shopBlock.childShop);
		lua_setfield(L, -2, "childShop");

		lua_rawseti(L, -2, ++index);
	}
}

int NpcTypeFunctions::luaNpcTypeCreate(lua_State* L) {
	// NpcType(name)
	NpcType* npcType = g_npcs().getNpcType(getString(L, 1), true);
	pushUserdata<NpcType>(L, npcType);
	setMetatable(L, -1, "NpcType");
	return 1;
}

int NpcTypeFunctions::luaNpcTypeIsPushable(lua_State* L) {
	// get: npcType:isPushable() set: npcType:isPushable(bool)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, npcType->info.pushable);
		} else {
			npcType->info.pushable = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeFloorChange(lua_State* L) {
	// get: npcType:floorChange() set: npcType:floorChange(bool)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, npcType->info.floorChange);
		} else {
			npcType->info.floorChange = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeCanSpawn(lua_State* L) {
	// monsterType:canSpawn(pos)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	const Position& position = getPosition(L, 2);
	if (npcType) {
		pushBoolean(L, npcType->canSpawn(position));
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeCanPushItems(lua_State* L) {
	// get: npcType:canPushItems() set: npcType:canPushItems(bool)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, npcType->info.canPushItems);
		} else {
			npcType->info.canPushItems = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeCanPushCreatures(lua_State* L) {
	// get: npcType:canPushCreatures() set: npcType:canPushCreatures(bool)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, npcType->info.canPushCreatures);
		} else {
			npcType->info.canPushCreatures = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int32_t NpcTypeFunctions::luaNpcTypeName(lua_State* L) {
	// get: npcType:name() set: npcType:name(name)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			pushString(L, npcType->name);
		} else {
			npcType->name = getString(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeNameDescription(lua_State* L) {
	// get: npcType:nameDescription() set: npcType:nameDescription(desc)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			pushString(L, npcType->nameDescription);
		} else {
			npcType->nameDescription = getString(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeHealth(lua_State* L) {
	// get: npcType:health() set: npcType:health(health)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, npcType->info.health);
		} else {
			npcType->info.health = getNumber<int64_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeMaxHealth(lua_State* L) {
	// get: npcType:maxHealth() set: npcType:maxHealth(health)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, npcType->info.healthMax);
		} else {
			npcType->info.healthMax = getNumber<int64_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeAddShopItem(lua_State* L) {
	// npcType:addShopItem(shop)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (!npcType) {
		lua_pushnil(L);
		return 1;
	}

	Shop* shop = getUserdata<Shop>(L, 2);
	if (shop) {
		npcType->loadShop(npcType, shop->shopBlock);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeAddVoice(lua_State* L) {
	// npcType:addVoice(sentence, interval, chance, yell)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		voiceBlock_t voice;
		voice.text = getString(L, 2);
		npcType->info.yellSpeedTicks = getNumber<uint32_t>(L, 3);
		npcType->info.yellChance = getNumber<uint32_t>(L, 4);
		voice.yellText = getBoolean(L, 5);
		npcType->info.voiceVector.push_back(voice);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeGetVoices(lua_State* L) {
	// npcType:getVoices()
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (!npcType) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, npcType->info.voiceVector.size(), 0);
	for (const auto& voiceBlock : npcType->info.voiceVector) {
		lua_createtable(L, 0, 2);
		setField(L, "text", voiceBlock.text);
		setField(L, "yellText", voiceBlock.yellText);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeGetCreatureEvents(lua_State* L) {
	// npcType:getCreatureEvents()
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (!npcType) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, npcType->info.scripts.size(), 0);
	for (const std::string& creatureEvent : npcType->info.scripts) {
		pushString(L, creatureEvent);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeRegisterEvent(lua_State* L) {
	// npcType:registerEvent(name)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		npcType->info.scripts.push_back(getString(L, 2));
		pushBoolean(L, true);
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
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		if (npcType->loadCallback(&g_scripts().getScriptInterface())) {
			pushBoolean(L, true);
			return 1;
		 }
		pushBoolean(L, false);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeEventType(lua_State* L) {
	// npcType:eventType(event)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		npcType->info.eventType = getNumber<NpcsEvent_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeOutfit(lua_State* L) {
	// get: npcType:outfit() set: npcType:outfit(outfit)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			pushOutfit(L, npcType->info.outfit);
		} else {
			Outfit_t outfit = getOutfit(L, 2);
			if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && outfit.lookType != 0 && !g_game().isLookTypeRegistered(outfit.lookType)) {
				SPDLOG_WARN("[NpcTypeFunctions::luaNpcTypeOutfit] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", outfit.lookType);
				lua_pushnil(L);
			} else {
				npcType->info.outfit = getOutfit(L, 2);
				pushBoolean(L, true);
			}
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeBaseSpeed(lua_State* L) {
	// npcType:getBaseSpeed()
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, npcType->info.baseSpeed);
		} else {
			npcType->info.baseSpeed = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeWalkInterval(lua_State* L) {
	// get: npcType:walkInterval() set: npcType:walkInterval(interval)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, npcType->info.walkInterval);
		} else {
			npcType->info.walkInterval = getNumber<uint32_t>(L, 2);
			lua_pushboolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeWalkRadius(lua_State* L) {
	// get: npcType:walkRadius() set: npcType:walkRadius(id)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, npcType->info.walkRadius);
		} else {
			npcType->info.walkRadius = getNumber<int32_t>(L, 2);
			lua_pushboolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeLight(lua_State* L) {
	// get: npcType:light() set: npcType:light(color, level)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (!npcType) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, npcType->info.light.level);
		lua_pushnumber(L, npcType->info.light.color);
		return 2;
	} else {
		npcType->info.light.color = getNumber<uint8_t>(L, 2);
		npcType->info.light.level = getNumber<uint8_t>(L, 3);
		pushBoolean(L, true);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeYellChance(lua_State* L) {
	// get: npcType:yellChance() set: npcType:yellChance(chance)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			if (lua_gettop(L) == 1) {
			lua_pushnumber(L, npcType->info.yellChance);
		} else {
			npcType->info.yellChance = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
		}
		} else {
			npcType->info.yellChance = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeYellSpeedTicks(lua_State* L) {
	// get: npcType:yellSpeedTicks() set: npcType:yellSpeedTicks(rate)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, npcType->info.yellSpeedTicks);
		} else {
			npcType->info.yellSpeedTicks = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
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
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, npcType->info.respawnType.period);
		} else {
			npcType->info.respawnType.period = getNumber<RespawnPeriod_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeRespawnTypeIsUnderground(lua_State* L) {
	// npcType:respawnTypeIsUnderground()
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (npcType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, npcType->info.respawnType.underground);
		} else {
			npcType->info.respawnType.underground = getNumber<RespawnPeriod_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeSpeechBubble(lua_State* L) {
	// get = npcType:speechBubble()
	// set = npcType:speechBubble(newSpeechBubble)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (!npcType) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_TYPE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, npcType->info.speechBubble);
	} else {
		npcType->info.speechBubble = getNumber<uint8_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeCurrency(lua_State* L) {
	// get = npcType:currency()
	// set = npcType:currency(newCurrency)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (!npcType) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_TYPE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, npcType->info.currencyId);
	} else {
		npcType->info.currencyId = getNumber<uint16_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeSoundChance(lua_State* L) {
	// get: npcType:soundChance() set: npcType:soundChance(chance)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (!npcType) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_TYPE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, npcType->info.soundChance);
	} else {
		npcType->info.soundChance = getNumber<uint32_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeSoundSpeedTicks(lua_State* L) {
	// get: npcType:soundSpeedTicks() set: npcType:soundSpeedTicks(ticks)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (!npcType) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_TYPE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, npcType->info.soundSpeedTicks);
	} else {
		npcType->info.soundSpeedTicks = getNumber<uint32_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int NpcTypeFunctions::luaNpcTypeAddSound(lua_State* L) {
	// npcType:addSound(soundId)
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (!npcType) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_NPC_TYPE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	npcType->info.soundVector.push_back(getNumber<SoundEffect_t>(L, 2));
	pushBoolean(L, true);
	return 1;
}

int NpcTypeFunctions::luaNpcTypeGetSounds(lua_State* L) {
	// npcType:getSounds()
	NpcType* npcType = getUserdata<NpcType>(L, 1);
	if (!npcType) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, npcType->info.soundVector.size(), 0);
	for (const auto& sound : npcType->info.soundVector) {
		lua_createtable(L, 0, 1);
		lua_pushnumber(L, sound);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}
