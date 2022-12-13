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

#ifndef SRC_CREATURES_NPCS_NPCS_H_
#define SRC_CREATURES_NPCS_NPCS_H_

#include "creatures/creature.h"

class Shop {
	public:
		Shop() = default;

		// non-copyable
		Shop(const Shop&) = delete;
		Shop& operator=(const Shop&) = delete;

		ShopBlock shopBlock;
};

class NpcType
{
	struct NpcInfo {
		LuaScriptInterface* scriptInterface;

		Outfit_t outfit = {};
		RespawnType respawnType = {};

		LightInfo light = {};

		uint8_t speechBubble;

		uint16_t currencyId = ITEM_GOLD_COIN;

		uint32_t yellChance = 0;
		uint32_t yellSpeedTicks = 0;
		uint32_t baseSpeed = 55;
		uint32_t walkInterval = 2000;

		int32_t creatureAppearEvent = -1;
		int32_t creatureDisappearEvent = -1;
		int32_t creatureMoveEvent = -1;
		int32_t creatureSayEvent = -1;
		int32_t thinkEvent = -1;
		int32_t playerCloseChannel = -1;
		int32_t playerBuyEvent = -1;
		int32_t playerSellEvent = -1;
		int32_t playerLookEvent = -1;

		int64_t health = 100;
		int64_t healthMax = 100;

		int32_t walkRadius = 10;

		bool canPushItems = false;
		bool canPushCreatures = false;
		bool pushable = false;
		bool floorChange = false;
 
		uint32_t soundChance = 0;
		uint32_t soundSpeedTicks = 0;
		std::vector<SoundEffect_t> soundVector;

		std::vector<voiceBlock_t> voiceVector;
		std::vector<std::string> scripts;
		std::vector<ShopBlock> shopItemVector;

		NpcsEvent_t eventType = NPCS_EVENT_NONE;
	};

	public:
		NpcType() = default;
		explicit NpcType(const std::string &initName) : name(initName), typeName(initName), nameDescription(initName) {};

		// non-copyable
		NpcType(const NpcType&) = delete;
		NpcType& operator=(const NpcType&) = delete;

		std::string name;
		std::string typeName;
		std::string nameDescription;
		NpcInfo info;

		void loadShop(NpcType* npcType, ShopBlock shopBlock);

		bool loadCallback(LuaScriptInterface* scriptInterface);
		bool canSpawn(const Position& pos);
};

class Npcs
{
	public:
		Npcs() = default;
		// non-copyable
		Npcs(const Npcs&) = delete;
		Npcs& operator=(const Npcs&) = delete;

		static Npcs& getInstance() {
			// Guaranteed to be destroyed
			static Npcs instance;
			// Instantiated on first use
			return instance;
		}

		NpcType* getNpcType(const std::string& name, bool create = false);

		// Reset npcs informations on reload
		void reset() {
			npcs.clear();
			scriptInterface.reset();
		};

	private:
		std::unique_ptr<LuaScriptInterface> scriptInterface;
		std::map<std::string, NpcType*> npcs;
};

constexpr auto g_npcs = &Npcs::getInstance;

#endif  // SRC_CREATURES_NPCS_NPCS_H_
