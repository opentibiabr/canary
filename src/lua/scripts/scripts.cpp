/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
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

void Scripts::clearAllScripts() const {
	g_actions().clear();
	g_creatureEvents().clear();
	g_talkActions().clear();
	g_globalEvents().clear();
	g_spells().clear();
	g_moveEvents().clear();
	g_weapons().clear();
}

bool Scripts::loadEventSchedulerScripts(const std::string& fileName) {
	auto coreFolder = g_configManager().getString(CORE_DIRECTORY);
	const auto dir = std::filesystem::current_path() / coreFolder / "events" / "scripts" / "scheduler";
	if(!std::filesystem::exists(dir) || !std::filesystem::is_directory(dir)) {
		SPDLOG_WARN("{} - Can not load folder 'scheduler' on {}/events/scripts'", __FUNCTION__, coreFolder);
		return false;
	}

	std::filesystem::recursive_directory_iterator endit;
	for(std::filesystem::recursive_directory_iterator it(dir); it != endit; ++it) {
		if(std::filesystem::is_regular_file(*it) && it->path().extension() == ".lua") {
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
	// Build the full path of the folder that should be loaded
	auto datapackFolder = g_configManager().getString(DATA_DIRECTORY);
	const auto dir = std::filesystem::current_path() / datapackFolder / folderName;
	// Checks if the folder exists and is really a folder
	if (!std::filesystem::exists(dir) || !std::filesystem::is_directory(dir))
	{
		SPDLOG_ERROR("Can not load folder {}", folderName);
		return false;
	}

	// Declare a string variable to store the last directory
	std::string lastDirectory;
	// Recursive iterate through all entries in the directory
	for (const auto &entry: std::filesystem::recursive_directory_iterator(dir))
	{
		// Get the filename of the entry as a string
		const auto& realPath = entry.path();
		std::string fileFolder = realPath.parent_path().filename().string();
		// Script folder, example: "actions"
		std::string scriptFolder = realPath.parent_path().string();
		// Create a string_view for the fileFolder and scriptFolder strings
		std::string_view fileFolderView(fileFolder);
		std::string_view scriptFolderView(scriptFolder);
		// Filename, example: "demon.lua"
		std::string file(realPath.filename().string());
		if (!std::filesystem::is_regular_file(entry) || realPath.extension() != ".lua")
		{
			// Skip this entry if it is not a regular file or does not have a .lua extension
			continue;
		}

		// Check if file start with "#"
		if (std::string disable("#");
			file.front() == disable.front())
		{
			// Send log of disabled script
			if (g_configManager().getBoolean(SCRIPTS_CONSOLE_LOGS)) {
				SPDLOG_INFO("[script]: {} [disabled]", realPath.filename().string());
			}
			// Skip for next loop and ignore disabled file
			continue;
		}

		// If the file is a library file or if the file's parent directory is not "lib" or "events"
		if (isLib || (fileFolderView != "lib" && fileFolderView != "events"))
		{
			// If console logs are enabled and the file is not a library file
			if (g_configManager().getBoolean(SCRIPTS_CONSOLE_LOGS))
			{
			// If the current directory is different from the last directory that was logged
				if (lastDirectory.empty() || lastDirectory != scriptFolderView)
				{
					// Update the last directory variable and log the directory name
					SPDLOG_INFO("Loading folder: [{}]", realPath.parent_path().filename().string());
				}
				lastDirectory = realPath.parent_path().string();
			}

			// If the function 'loadFile' returns -1, then there was an error loading the file
			if (scriptInterface.loadFile(realPath.string()) == -1)
			{
				// Log the error and the file path, and skip to the next iteration of the loop.
				SPDLOG_ERROR(realPath.string());
				SPDLOG_ERROR(scriptInterface.getLastLuaError());
				continue;
			}
		}

		if (g_configManager().getBoolean(SCRIPTS_CONSOLE_LOGS)) {
			if (!reload) {
				SPDLOG_INFO("[script loaded]: {}", realPath.filename().string());
			} else {
				SPDLOG_INFO("[script reloaded]: {}", realPath.filename().string());
			}
		}
	}

	return true;
}
