/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class NpcTypeFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "NpcType", "", NpcTypeFunctions::luaNpcTypeCreate);
		registerMetaMethod(L, "NpcType", "__eq", NpcTypeFunctions::luaUserdataCompare);

		registerMethod(L, "NpcType", "isPushable", NpcTypeFunctions::luaNpcTypeIsPushable);
		registerMethod(L, "NpcType", "floorChange", NpcTypeFunctions::luaNpcTypeFloorChange);

		registerMethod(L, "NpcType", "canSpawn", NpcTypeFunctions::luaNpcTypeCanSpawn);

		registerMethod(L, "NpcType", "canPushItems", NpcTypeFunctions::luaNpcTypeCanPushItems);
		registerMethod(L, "NpcType", "canPushCreatures", NpcTypeFunctions::luaNpcTypeCanPushCreatures);

		registerMethod(L, "NpcType", "name", NpcTypeFunctions::luaNpcTypeName);

		registerMethod(L, "NpcType", "nameDescription", NpcTypeFunctions::luaNpcTypeNameDescription);

		registerMethod(L, "NpcType", "health", NpcTypeFunctions::luaNpcTypeHealth);
		registerMethod(L, "NpcType", "maxHealth", NpcTypeFunctions::luaNpcTypeMaxHealth);

		registerMethod(L, "NpcType", "getVoices", NpcTypeFunctions::luaNpcTypeGetVoices);
		registerMethod(L, "NpcType", "addVoice", NpcTypeFunctions::luaNpcTypeAddVoice);

		registerMethod(L, "NpcType", "getCreatureEvents", NpcTypeFunctions::luaNpcTypeGetCreatureEvents);
		registerMethod(L, "NpcType", "registerEvent", NpcTypeFunctions::luaNpcTypeRegisterEvent);

		registerMethod(L, "NpcType", "eventType", NpcTypeFunctions::luaNpcTypeEventType);
		registerMethod(L, "NpcType", "onThink", NpcTypeFunctions::luaNpcTypeEventOnCallback);
		registerMethod(L, "NpcType", "onAppear", NpcTypeFunctions::luaNpcTypeEventOnCallback);
		registerMethod(L, "NpcType", "onDisappear", NpcTypeFunctions::luaNpcTypeEventOnCallback);
		registerMethod(L, "NpcType", "onMove", NpcTypeFunctions::luaNpcTypeEventOnCallback);
		registerMethod(L, "NpcType", "onSay", NpcTypeFunctions::luaNpcTypeEventOnCallback);
		registerMethod(L, "NpcType", "onCloseChannel", NpcTypeFunctions::luaNpcTypeEventOnCallback);
		registerMethod(L, "NpcType", "onBuyItem", NpcTypeFunctions::luaNpcTypeEventOnCallback);
		registerMethod(L, "NpcType", "onSellItem", NpcTypeFunctions::luaNpcTypeEventOnCallback);
		registerMethod(L, "NpcType", "onCheckItem", NpcTypeFunctions::luaNpcTypeEventOnCallback);

		registerMethod(L, "NpcType", "outfit", NpcTypeFunctions::luaNpcTypeOutfit);
		registerMethod(L, "NpcType", "baseSpeed", NpcTypeFunctions::luaNpcTypeBaseSpeed);
		registerMethod(L, "NpcType", "walkInterval", NpcTypeFunctions::luaNpcTypeWalkInterval);
		registerMethod(L, "NpcType", "walkRadius", NpcTypeFunctions::luaNpcTypeWalkRadius);
		registerMethod(L, "NpcType", "light", NpcTypeFunctions::luaNpcTypeLight);

		registerMethod(L, "NpcType", "yellChance", NpcTypeFunctions::luaNpcTypeYellChance);
		registerMethod(L, "NpcType", "yellSpeedTicks", NpcTypeFunctions::luaNpcTypeYellSpeedTicks);

		registerMethod(L, "NpcType", "respawnTypePeriod", NpcTypeFunctions::luaNpcTypeRespawnTypePeriod);
		registerMethod(L, "NpcType", "respawnTypeIsUnderground", NpcTypeFunctions::luaNpcTypeRespawnTypeIsUnderground);
		registerMethod(L, "NpcType", "speechBubble", NpcTypeFunctions::luaNpcTypeSpeechBubble);
		registerMethod(L, "NpcType", "currency", NpcTypeFunctions::luaNpcTypeCurrency);

		registerMethod(L, "NpcType", "addShopItem", NpcTypeFunctions::luaNpcTypeAddShopItem);

		registerMethod(L, "NpcType", "soundChance", NpcTypeFunctions::luaNpcTypeSoundChance);
		registerMethod(L, "NpcType", "soundSpeedTicks", NpcTypeFunctions::luaNpcTypeSoundSpeedTicks);
		registerMethod(L, "NpcType", "addSound", NpcTypeFunctions::luaNpcTypeAddSound);
		registerMethod(L, "NpcType", "getSounds", NpcTypeFunctions::luaNpcTypeGetSounds);
	}

private:
	static void createNpcTypeShopLuaTable(lua_State* L, const std::vector<ShopBlock> &shopVector);
	static int luaNpcTypeCreate(lua_State* L);
	static int luaNpcTypeIsPushable(lua_State* L);
	static int luaNpcTypeFloorChange(lua_State* L);

	static int luaNpcTypeRespawnType(lua_State* L);
	static int luaNpcTypeCanSpawn(lua_State* L);

	static int luaNpcTypeCanPushItems(lua_State* L);
	static int luaNpcTypeCanPushCreatures(lua_State* L);

	static int luaNpcTypeName(lua_State* L);
	static int luaNpcTypeNameDescription(lua_State* L);

	static int luaNpcTypeHealth(lua_State* L);
	static int luaNpcTypeMaxHealth(lua_State* L);

	static int luaNpcTypeGetVoices(lua_State* L);
	static int luaNpcTypeAddVoice(lua_State* L);

	static int luaNpcTypeGetCreatureEvents(lua_State* L);
	static int luaNpcTypeRegisterEvent(lua_State* L);

	static int luaNpcTypeEventOnCallback(lua_State* L);
	static int luaNpcTypeEventType(lua_State* L);

	static int luaNpcTypeOutfit(lua_State* L);
	static int luaNpcTypeBaseSpeed(lua_State* L);
	static int luaNpcTypeWalkInterval(lua_State* L);
	static int luaNpcTypeWalkRadius(lua_State* L);
	static int luaNpcTypeLight(lua_State* L);

	static int luaNpcTypeYellChance(lua_State* L);
	static int luaNpcTypeYellSpeedTicks(lua_State* L);

	static int luaNpcTypeRespawnTypePeriod(lua_State* L);
	static int luaNpcTypeRespawnTypeIsUnderground(lua_State* L);

	static int luaNpcTypeSpeechBubble(lua_State* L);

	static int luaNpcTypeCurrency(lua_State* L);

	static int luaNpcTypeAddShopItem(lua_State* L);

	static int luaNpcTypeSoundChance(lua_State* L);
	static int luaNpcTypeSoundSpeedTicks(lua_State* L);
	static int luaNpcTypeAddSound(lua_State* L);
	static int luaNpcTypeGetSounds(lua_State* L);

	friend class GameFunctions;
};
