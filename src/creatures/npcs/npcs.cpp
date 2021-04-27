/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
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

#include "../../otpch.h"

#include "npcs.h"
#include "npc.h"
#include "../combat/spells.h"
#include "../combat/combat.h"
#include "../../items/weapons/weapons.h"
#include "../../config/configmanager.h"
#include "../../game/game.h"
#include "../creature.h"
#include "../../utils/enums.h"

#include "../../utils/pugicast.h"

extern Game g_game;
extern Spells* g_spells;
extern Npcs g_npcs;
extern ConfigManager g_config;

bool NpcType::canSpawn(const Position& pos)
{
	bool canSpawn = true;
	bool isDay = g_game.gameIsDay();

	if ((isDay && info.respawnType.period == RESPAWNPERIOD_NIGHT) ||
		(!isDay && info.respawnType.period == RESPAWNPERIOD_DAY)) {
		// It will ignore day and night if underground
		canSpawn = (pos.z > 7 && info.respawnType.underground);
	}

	return canSpawn;
}

bool NpcType::loadCallback(LuaScriptInterface* scriptInterface)
{
	int32_t id = scriptInterface->getEvent();
	if (id == -1) {
		SPDLOG_WARN("[NpcType::loadCallback] - Event not found");
		return false;
	}

	info.scriptInterface = scriptInterface;
	switch (info.eventType) {
		case NPCS_EVENT_THINK:
			info.thinkEvent = id;
			break;
		case NPCS_EVENT_APPEAR:
			info.creatureAppearEvent = id;
			break;
		case NPCS_EVENT_DISAPPEAR:
			info.creatureDisappearEvent = id;
			break;
		case NPCS_EVENT_MOVE:
			info.creatureMoveEvent = id;
			break;
		case NPCS_EVENT_SAY:
			info.creatureSayEvent = id;
			break;
		case NPCS_EVENT_PLAYER_BUY:
			info.playerBuyEvent = id;
			break;
		case NPCS_EVENT_PLAYER_SELL:
			info.playerSellEvent = id;
			break;
		case NPCS_EVENT_PLAYER_CHECK_ITEM:
			info.playerLookEvent = id;
			break;
		default:
			break;
	}

	return true;
}

NpcType* Npcs::getNpcType(const std::string& name, bool create /* = false*/)
{
	std::string key = asLowerCaseString(name);
	auto it = npcs.find(key);

	if (it != npcs.end()) {
		return it->second;
	}

	if (!create) {
		return nullptr;
	}

	npcs[key] = new NpcType(name);

	return npcs[key];
}
