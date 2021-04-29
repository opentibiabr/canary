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

#include "otpch.h"

#include "lua/creature/actions.h"
#include "creatures/interactions/chat.h"
#include "lua/creature/talkaction.h"
#include "creatures/combat/spells.h"
#include "lua/creature/movement.h"
#include "items/weapons/weapons.h"
#include "lua/global/globalevent.h"
#include "lua/creature/events.h"
#include "lua/scripts/scripts.h"
#include "lua/modules/modules.h"
#include "creatures/players/imbuements/imbuements.h"
#include <boost/filesystem.hpp>

Actions* g_actions = nullptr;
CreatureEvents* g_creatureEvents = nullptr;
Chat* g_chat = nullptr;
Events* g_events = nullptr;
GlobalEvents* g_globalEvents = nullptr;
Spells* g_spells = nullptr;
TalkActions* g_talkActions = nullptr;
MoveEvents* g_moveEvents = nullptr;
Weapons* g_weapons = nullptr;
Scripts* g_scripts = nullptr;
Modules* g_modules = nullptr;
Imbuements* g_imbuements = nullptr;

extern LuaEnvironment g_luaEnvironment;
extern ConfigManager g_config;

Scripts::Scripts() :
	scriptInterface("Scripts Interface")
{
	scriptInterface.initState();
}

Scripts::~Scripts()
{
	scriptInterface.reInitState();

	delete g_events;
	delete g_weapons;
	delete g_spells;
	delete g_actions;
	delete g_talkActions;
	delete g_moveEvents;
	delete g_chat;
	delete g_creatureEvents;
	delete g_globalEvents;
	delete g_scripts;
	delete g_imbuements;
}

bool Scripts::loadScriptSystems()
{
	g_chat = new Chat();

	// XML loads disabled start
	g_weapons = new Weapons();
	if (!g_weapons) {
		return false;
	}

	g_weapons->loadDefaults();

	g_spells = new Spells();
	if (!g_spells) {
		return false;
	}

	g_actions = new Actions();
	if (!g_actions) {
		return false;
	}

	g_talkActions = new TalkActions();
	if (!g_talkActions) {
		return false;
	}

	g_moveEvents = new MoveEvents();
	if (!g_moveEvents) {
		return false;
	}

	g_creatureEvents = new CreatureEvents();
	if (!g_creatureEvents) {
		return false;
	}

	g_globalEvents = new GlobalEvents();
	if (!g_globalEvents) {
		return false;
	}
	// XML loads disabled end

	return true;
}

bool Scripts::loadEventSchedulerScripts(const std::string& fileName)
{
	namespace fs = boost::filesystem;

	const auto dir = fs::current_path() / "data" / "events" / "scripts" / "scheduler";
	if(!fs::exists(dir) || !fs::is_directory(dir)) {
		SPDLOG_WARN("Can not load folder 'scheduler' on '/data/events/scripts'");
		return false;
	}

	fs::recursive_directory_iterator endit;
	for(fs::recursive_directory_iterator it(dir); it != endit; ++it) {
		if(fs::is_regular_file(*it) && it->path().extension() == ".lua") {
			if (it->path().filename().string() == fileName) {
				if(scriptInterface.loadFile(it->path().string()) == -1) {
					SPDLOG_ERROR(it->path().string());
					SPDLOG_ERROR(scriptInterface.getLastLuaError());
					continue;
				}
				return true;
			}
		}
	}
	return false;
}

bool Scripts::loadScripts(std::string folderName, bool isLib, bool reload)
{
	namespace fs = boost::filesystem;

	const auto dir = fs::current_path() / "data" / folderName;
	if(!fs::exists(dir) || !fs::is_directory(dir)) {
		SPDLOG_ERROR("Can not load folder {}", folderName);
		return false;
	}

	fs::recursive_directory_iterator endit;
	std::vector<fs::path> v;
	std::string disable = ("#");
	for(fs::recursive_directory_iterator it(dir); it != endit; ++it) {
		auto fn = it->path().parent_path().filename();
		if ((fn == "lib" && !isLib) || fn == "events") {
			continue;
		}
		if(fs::is_regular_file(*it) && it->path().extension() == ".lua") {
			size_t found = it->path().filename().string().find(disable);
			if (found != std::string::npos) {
				if (g_config.getBoolean(ConfigManager::SCRIPTS_CONSOLE_LOGS)) {
					SPDLOG_INFO("{} [disabled]", it->path().filename().string());
				}
				continue;
			}
			v.push_back(it->path());
		}
	}
	sort(v.begin(), v.end());
	std::string redir;
	for (auto it = v.begin(); it != v.end(); ++it) {
		const std::string scriptFile = it->string();
		if (!isLib) {
			if (redir.empty() || redir != it->parent_path().string()) {
				auto p = it->relative_path();
				if (g_config.getBoolean(ConfigManager::SCRIPTS_CONSOLE_LOGS)) {
					SPDLOG_INFO("[{}]", p.parent_path().filename().string());
				}
				redir = it->parent_path().string();
			}
		}

		if(scriptInterface.loadFile(scriptFile) == -1) {
			SPDLOG_ERROR(it->filename().string());
			SPDLOG_ERROR(scriptInterface.getLastLuaError());
			continue;
		}

		if (g_config.getBoolean(ConfigManager::SCRIPTS_CONSOLE_LOGS)) {
			if (!reload) {
				SPDLOG_INFO("{} [loaded]", it->filename().string());
			} else {
				SPDLOG_INFO("{} [reloaded]", it->filename().string());
			}
		}
	}

	return true;
}
