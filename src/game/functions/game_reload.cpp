/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "game/functions/game_reload.hpp"

#include "config/configmanager.hpp"
#include "lua/creature/events.hpp"
#include "creatures/players/imbuements/imbuements.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "lua/modules/modules.hpp"
#include "lua/scripts/scripts.hpp"
#include "game/zones/zone.hpp"

GameReload::GameReload() = default;
GameReload::~GameReload() = default;

bool GameReload::init(Reload_t reloadTypes) const {
	switch (reloadTypes) {
		case Reload_t::RELOAD_TYPE_ALL:
			return reloadAll();
		case Reload_t::RELOAD_TYPE_CHAT:
			return reloadChat();
		case Reload_t::RELOAD_TYPE_CONFIG:
			return reloadConfig();
		case Reload_t::RELOAD_TYPE_EVENTS:
			return reloadEvents();
		case Reload_t::RELOAD_TYPE_CORE:
			return reloadCore();
		case Reload_t::RELOAD_TYPE_IMBUEMENTS:
			return reloadImbuements();
		case Reload_t::RELOAD_TYPE_ITEMS:
			return reloadItems();
		case Reload_t::RELOAD_TYPE_MODULES:
			return reloadModules();
		case Reload_t::RELOAD_TYPE_MONSTERS:
			return reloadMonsters();
		case Reload_t::RELOAD_TYPE_MOUNTS:
			return reloadMounts();
		case Reload_t::RELOAD_TYPE_NPCS:
			return reloadNpcs();
		case Reload_t::RELOAD_TYPE_RAIDS:
			return reloadRaids();
		case Reload_t::RELOAD_TYPE_SCRIPTS:
			return reloadScripts();
		case Reload_t::RELOAD_TYPE_GROUPS:
			return reloadGroups();
		default:
			return false;
	}
}

uint8_t GameReload::getReloadNumber(Reload_t reloadTypes) const {
	return magic_enum::enum_integer(reloadTypes);
}

/*
 * From here down have the private members functions
 * These should only be used within the class itself
 * If it is necessary to call elsewhere, seriously think about creating a function that calls this
 * Changing this to public may cause some unexpected behavior or bug
 */
bool GameReload::reloadAll() const {
	std::vector<bool> reloadResults;
	reloadResults.reserve(magic_enum::enum_count<Reload_t>());

	for (auto value : magic_enum::enum_values<Reload_t>()) {
		if (value == Reload_t::RELOAD_TYPE_ALL) {
			continue;
		}

		reloadResults.push_back(init(value));
	}

	return std::ranges::any_of(reloadResults, [](bool result) { return result; });
}

bool GameReload::reloadChat() const {
	return g_chat().load();
}

bool GameReload::reloadConfig() const {
	return g_configManager().reload();
}

bool GameReload::reloadEvents() const {
	return g_events().loadFromXml();
}

bool GameReload::reloadCore() const {
	if (auto coreFolder = g_configManager().getString(CORE_DIRECTORY);
		g_luaEnvironment().loadFile(coreFolder + "/core.lua", "core.lua") == 0) {
		// Reload scripts lib
		auto datapackFolder = g_configManager().getString(DATA_DIRECTORY);
		if (!g_scripts().loadScripts(datapackFolder + "/scripts/lib", true, false)) {
			return false;
		}

		return true;
	}
	return false;
}

bool GameReload::reloadImbuements() const {
	return g_imbuements().reload();
}

bool GameReload::reloadItems() const {
	return Item::items.reload();
}

bool GameReload::reloadModules() const {
	return g_modules().reload();
}

bool GameReload::reloadMonsters() const {
	// Clear registered MonsterType vector
	g_monsters().clear();
	// Resets monster spells to prevent the spell from being incorrectly cleared from memory
	auto datapackFolder = g_configManager().getString(DATA_DIRECTORY);
	if (!g_scripts().loadScripts(datapackFolder + "/scripts/lib", true, false)) {
		return false;
	}

	if (g_scripts().loadScripts(datapackFolder + "/monster", false, true) && g_scripts().loadScripts(datapackFolder + "/scripts/lib", true, true)) {
		return true;
	}
	return false;
}

bool GameReload::reloadMounts() const {
	return g_game().mounts.reload();
}

bool GameReload::reloadNpcs() const {
	return g_npcs().reload();
}

bool GameReload::reloadRaids() const {
	return g_game().raids.reload() && g_game().raids.startup();
}

bool GameReload::reloadScripts() const {
	g_scripts().clearAllScripts();
	Zone::clearZones();
	// Reset scripts lib to prevent the objects from being incorrectly cleared from memory
	auto datapackFolder = g_configManager().getString(DATA_DIRECTORY);
	g_scripts().loadScripts(datapackFolder + "/scripts/lib", true, false);
	auto coreFolder = g_configManager().getString(CORE_DIRECTORY);
	g_scripts().loadScripts(datapackFolder + "/scripts", false, true);
	g_scripts().loadScripts(coreFolder + "/scripts", false, true);

	// It should come last, after everything else has been cleaned up.
	reloadMonsters();
	reloadNpcs();
	return true;
}

bool GameReload::reloadGroups() const {
	return g_game().groups.reload();
}
