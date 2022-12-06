/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "game/functions/game_reload.hpp"

#include "config/configmanager.h"
#include "lua/creature/events.h"
#include "creatures/players/imbuements/imbuements.h"
#include "lua/scripts/lua_environment.hpp"
#include "utils/magic_enum.hpp"
#include "lua/modules/modules.h"
#include "lua/scripts/scripts.h"

GameReload::GameReload() = default;
GameReload::~GameReload() = default;

bool GameReload::init(ReloadTypes reloadTypes)
{
	switch (reloadTypes) {
		case ReloadTypes::RELOAD_TYPE_ALL : return reloadAll();
		case ReloadTypes::RELOAD_TYPE_CHAT : return reloadChat();
		case ReloadTypes::RELOAD_TYPE_CONFIG : return reloadConfig();
		case ReloadTypes::RELOAD_TYPE_EVENTS : return reloadEvents();
		case ReloadTypes::RELOAD_TYPE_CORE : return reloadCore();
		case ReloadTypes::RELOAD_TYPE_IMBUEMENTS : return reloadImbuements();
		case ReloadTypes::RELOAD_TYPE_ITEMS : return reloadItems();
		case ReloadTypes::RELOAD_TYPE_MODULES : return reloadModules();
		case ReloadTypes::RELOAD_TYPE_MONSTERS : return reloadMonsters();
		case ReloadTypes::RELOAD_TYPE_MOUNTS : return reloadMounts();
		case ReloadTypes::RELOAD_TYPE_NPCS : return reloadNpcs();
		case ReloadTypes::RELOAD_TYPE_RAIDS : return reloadRaids();
		case ReloadTypes::RELOAD_TYPE_SCRIPTS : return reloadScripts();
		case ReloadTypes::RELOAD_TYPE_TALKACTION : return reloadTalkaction();
		default : return false;
	}
}

bool GameReload::reloadAll()
{
	if (reloadChat() || reloadConfig() || reloadEvents() ||
		reloadCore() || reloadImbuements() || reloadItems() ||
		reloadModules() || reloadMonsters() || reloadMounts() ||
		reloadNpcs() || reloadRaids() || reloadScripts() ||
		reloadTalkaction()
	)
	{
		return true;
	}
	return false;
}

bool GameReload::reloadChat()
{
	return g_chat().load();
}

bool GameReload::reloadConfig()
{
	return g_configManager().reload();
}

bool GameReload::reloadEvents()
{
	return g_events().loadFromXml();
}

bool GameReload::reloadTalkaction()
{
	auto coreFolder = g_configManager().getString(CORE_DIRECTORY);
	if (g_luaEnvironment.loadFile(coreFolder + "/scripts/talkactions.lua") == 0) {
		return true;
	}
	return false;
}

bool GameReload::reloadCore()
{
	auto coreFolder = g_configManager().getString(CORE_DIRECTORY);
	if (g_luaEnvironment.loadFile(coreFolder + "/core.lua") == 0) {
		return true;
	}
	return false;
}

bool GameReload::reloadImbuements()
{
	return g_imbuements().reload();
}

bool GameReload::reloadItems()
{
	return Item::items.reload();
}

bool GameReload::reloadModules()
{
	return g_modules().reload();
}

bool GameReload::reloadMonsters()
{
	// Reset monsters target
	g_game().resetMonsters();
	if (g_scripts().loadScripts("monster", false, true) && g_scripts().loadScripts("scripts/lib", true, true)) {
		return true;
	}
	return false;
}

bool GameReload::reloadMounts()
{
	return g_game().mounts.reload();
}

bool GameReload::reloadNpcs()
{
	if (g_npc().reset()) {
		return true;
	}

	return false;
}

bool GameReload::reloadRaids()
{
	return g_game().raids.reload() && g_game().raids.startup();
}

bool GameReload::reloadScripts()
{
	// Resets monster targets to prevent the spell from being incorrectly cleared from memory
	g_game().resetMonsters();
	g_scripts().clear();
	if (g_scripts().loadScripts("scripts", false, true)) {
		return true;
	}
	return false;
}

/*
* From here down have the private members functions
* These should only be used within the class itself
* If it is necessary to call elsewhere, seriously think about creating a function that calls this
* Changing this to public may cause some unexpected behavior or bug
*/
uint8_t GameReload::getReloadNumber(ReloadTypes reloadTypes)
{
	auto integer = magic_enum::enum_integer(reloadTypes);
	return static_cast<uint8_t>(integer);
}
