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
#include "lua/modules/modules.h"
#include "lua/scripts/scripts.h"

GameReload::GameReload() = default;
GameReload::~GameReload() = default;

bool GameReload::init(Reload_t reloadTypes) const
{
	switch (reloadTypes) {
		case Reload_t::RELOAD_TYPE_ALL : return reloadAll();
		case Reload_t::RELOAD_TYPE_CHAT : return reloadChat();
		case Reload_t::RELOAD_TYPE_CONFIG : return reloadConfig();
		case Reload_t::RELOAD_TYPE_EVENTS : return reloadEvents();
		case Reload_t::RELOAD_TYPE_CORE : return reloadCore();
		case Reload_t::RELOAD_TYPE_IMBUEMENTS : return reloadImbuements();
		case Reload_t::RELOAD_TYPE_ITEMS : return reloadItems();
		case Reload_t::RELOAD_TYPE_MODULES : return reloadModules();
		case Reload_t::RELOAD_TYPE_MONSTERS : return reloadMonsters();
		case Reload_t::RELOAD_TYPE_MOUNTS : return reloadMounts();
		case Reload_t::RELOAD_TYPE_NPCS : return reloadNpcs();
		case Reload_t::RELOAD_TYPE_RAIDS : return reloadRaids();
		case Reload_t::RELOAD_TYPE_SCRIPTS : return reloadScripts();
		case Reload_t::RELOAD_TYPE_TALKACTION : return reloadTalkaction();
		default : return false;
	}
}

uint8_t GameReload::getReloadNumber(Reload_t reloadTypes) const
{
	return magic_enum::enum_integer(reloadTypes);
}

/*
* From here down have the private members functions
* These should only be used within the class itself
* If it is necessary to call elsewhere, seriously think about creating a function that calls this
* Changing this to public may cause some unexpected behavior or bug
*/
bool GameReload::reloadAll() const
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

bool GameReload::reloadChat() const
{
	return g_chat().load();
}

bool GameReload::reloadConfig() const
{
	return g_configManager().reload();
}

bool GameReload::reloadEvents() const
{
	return g_events().loadFromXml();
}

bool GameReload::reloadCore() const
{
	if (auto coreFolder = g_configManager().getString(CORE_DIRECTORY);
		g_luaEnvironment.loadFile(coreFolder + "/core.lua") == 0)
	{
		// Reload scripts lib
		if (!g_scripts().loadScripts("scripts/lib", true, false)) {
			return false;
		}

		return true;
	}
	return false;
}

bool GameReload::reloadImbuements() const
{
	return g_imbuements().reload();
}

bool GameReload::reloadItems() const
{
	return Item::items.reload();
}

bool GameReload::reloadModules() const
{
	return g_modules().reload();
}

bool GameReload::reloadMonsters() const
{
	// Resets monster spells to prevent the spell from being incorrectly cleared from memory
	if (!g_scripts().loadScripts("scripts/lib", true, false)) {
		return false;
	}

	if (g_scripts().loadScripts("monster", false, true) && g_scripts().loadScripts("scripts/lib", true, true)) {
		return true;
	}
	return false;
}

bool GameReload::reloadMounts() const
{
	return g_game().mounts.reload();
}

bool GameReload::reloadNpcs() const
{
	if (g_npc().reset()) {
		if (!g_scripts().loadScripts("scripts/lib", true, false)) {
			return false;
		}
		return true;
	}

	return false;
}

bool GameReload::reloadRaids() const
{
	return g_game().raids.reload() && g_game().raids.startup();
}

bool GameReload::reloadScripts() const
{
	// Resets monster spells to prevent the spell from being incorrectly cleared from memory
	if (!g_scripts().loadScripts("scripts/lib", true, false)) {
		return false;
	}
	g_scripts().clear();

	if (g_scripts().loadScripts("scripts", false, true)) {
		return true;
	}
	return false;
}

bool GameReload::reloadTalkaction() const
{
	if (auto coreFolder = g_configManager().getString(CORE_DIRECTORY);
		g_luaEnvironment.loadFile(coreFolder + "/scripts/talkactions.lua") == 0)
	{
		return true;
	}
	return false;
}
