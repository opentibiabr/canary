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

#include "pch.hpp"

#include "creatures/players/imbuements/imbuements.h"
#include "lua/global/globalevent.h"
#include "items/weapons/weapons.h"
#include "lua/creature/movement.h"
#include "lua/scripts/scripts.h"
#include "creatures/combat/spells.h"

Scripts::Scripts() :
	scriptInterface("Scripts Interface") {
	scriptInterface.initState();
}

Scripts::~Scripts() {
	scriptInterface.reInitState();
}

void Scripts::clear() const {
	g_actions().clear();
	g_creatureEvents().clear();
	g_talkActions().clear();
	g_globalEvents().clear();
	g_spells().clear();
	g_moveEvents().clear();
	g_weapons().clear();
}

bool Scripts::loadEventSchedulerScripts(const std::string& fileName) {
	namespace fs = boost::filesystem;

	auto coreFolder = g_configManager().getString(CORE_DIRECTORY);
	const auto dir = fs::current_path() / coreFolder / "events" / "scripts" / "scheduler";
	if(!fs::exists(dir) || !fs::is_directory(dir)) {
		SPDLOG_WARN("{} - Can not load folder 'scheduler' on {}/events/scripts'", __FUNCTION__, coreFolder);
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

bool Scripts::loadScripts(std::string folderName, bool isLib, bool reload) {
	namespace fs = boost::filesystem;

	auto datapackFolder = g_configManager().getString(DATA_DIRECTORY);
	const auto dir = fs::current_path() / datapackFolder / folderName;
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
				if (g_configManager().getBoolean(SCRIPTS_CONSOLE_LOGS)) {
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
				if (g_configManager().getBoolean(SCRIPTS_CONSOLE_LOGS)) {
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

		if (g_configManager().getBoolean(SCRIPTS_CONSOLE_LOGS)) {
			if (!reload) {
				SPDLOG_INFO("{} [loaded]", it->filename().string());
			} else {
				SPDLOG_INFO("{} [reloaded]", it->filename().string());
			}
		}
	}

	return true;
}
