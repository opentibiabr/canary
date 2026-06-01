/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/scripts/scripts.hpp"

#include "lib/di/container.hpp"
#include "config/configmanager.hpp"
#include "creatures/combat/spells.hpp"
#include "creatures/monsters/monsters.hpp"
#include "items/weapons/weapons.hpp"
#include "lua/callbacks/events_callbacks.hpp"
#include "lua/creature/creatureevent.hpp"
#include "lua/creature/movement.hpp"
#include "lua/creature/talkaction.hpp"
#include "lua/global/globalevent.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <optional>
#endif

namespace {
	[[nodiscard]] LuaBytecodeCacheStats subtractLuaBytecodeCacheStats(const LuaBytecodeCacheStats &after, const LuaBytecodeCacheStats &before) {
		return LuaBytecodeCacheStats {
			.packHits = after.packHits - before.packHits,
			.fileHits = after.fileHits - before.fileHits,
			.misses = after.misses - before.misses,
			.writes = after.writes - before.writes,
			.packInvalidations = after.packInvalidations - before.packInvalidations,
			.fileInvalidations = after.fileInvalidations - before.fileInvalidations,
		};
	}
}

Scripts::Scripts() :
	scriptInterface("Scripts Interface") {
	scriptInterface.initState();
}

Scripts &Scripts::getInstance() {
	static Scripts instance;
	return instance;
}

void Scripts::clearAllScripts() const {
	g_actions().clear();
	g_creatureEvents().clear();
	g_talkActions().clear();
	g_globalEvents().clear();
	g_spells().clear();
	g_moveEvents().clear();
	g_weapons().clear();
	g_callbacks().clear();
	g_monsters().clear();
}

bool Scripts::loadEventSchedulerScripts(const std::filesystem::path &filePath) {
	if (!std::filesystem::exists(filePath) || !std::filesystem::is_regular_file(filePath)) {
		g_logger().warn("{} - Cannot load file '{}'", __FUNCTION__, filePath.string());
		return false;
	}

	if (filePath.extension() == ".lua") {
		if (scriptInterface.loadFile(filePath.string(), filePath.filename().string()) == -1) {
			g_logger().error(filePath.string());
			g_logger().error(scriptInterface.getLastLuaError());
			return false;
		}
		return true;
	}

	return false;
}

bool Scripts::loadScripts(std::string_view folderName, bool isLib, bool reload) {
	Benchmark loadScriptsBenchmark;
	const auto dir = std::filesystem::current_path() / folderName;
	const auto startupLoadTelemetry = g_configManager().getBoolean(LUA_STARTUP_LOAD_TELEMETRY);
	const auto scriptsConsoleLogs = g_configManager().getBoolean(SCRIPTS_CONSOLE_LOGS);
	const auto bytecodeCacheEnabled = g_configManager().getBoolean(LUA_SCRIPT_BYTECODE_CACHE);
	const auto bytecodeStatsBefore = startupLoadTelemetry && bytecodeCacheEnabled ? LuaScriptInterface::getBytecodeCacheStats() : LuaBytecodeCacheStats {};

	// Checks if the folder exists and is really a folder
	if (!std::filesystem::exists(dir) || !std::filesystem::is_directory(dir)) {
		g_logger().error("Can not load folder {}", folderName);
		return false;
	}

	// Declare a string variable to store the last directory
	std::string lastDirectory;
	uint64_t scannedEntries = 0;
	uint64_t luaFiles = 0;
	uint64_t loadedFiles = 0;
	uint64_t skippedFiles = 0;
	uint64_t disabledFiles = 0;
	uint64_t failedFiles = 0;
	uintmax_t luaBytes = 0;

	// Recursive iterate through all entries in the directory
	for (const auto &entry : std::filesystem::recursive_directory_iterator(dir)) {
		++scannedEntries;
		// Get the filename of the entry as a string
		const auto &realPath = entry.path();

		if (!entry.is_regular_file() || realPath.extension() != ".lua") {
			// Skip this entry if it is not a regular file or does not have a .lua extension
			++skippedFiles;
			continue;
		}

		++luaFiles;
		std::optional<LuaScriptFileMetadata> sourceMetadata;
		if (startupLoadTelemetry || bytecodeCacheEnabled) {
			std::error_code metadataError;
			const auto fileSize = entry.file_size(metadataError);
			if (!metadataError) {
				if (startupLoadTelemetry) {
					luaBytes += fileSize;
				}

				if (bytecodeCacheEnabled) {
					metadataError.clear();
					const auto lastWriteTime = entry.last_write_time(metadataError);
					if (!metadataError) {
						sourceMetadata = LuaScriptFileMetadata { fileSize, lastWriteTime };
					}
				}
			}
		}

		// Filename, example: "demon.lua"
		const auto file = realPath.filename().string();

		// Check if file start with "#"
		if (!file.empty() && file.front() == '#') {
			// Send log of disabled script
			if (scriptsConsoleLogs) {
				g_logger().info("[script]: {} [disabled]", file);
			}
			++disabledFiles;
			// Skip for next loop and ignore disabled file
			continue;
		}

		const auto parentPath = realPath.parent_path();
		std::string fileFolder = parentPath.filename().string();

		// If the file is a library file or if the file's parent directory is not "lib" or "events"
		if (isLib || (fileFolder != "lib" && fileFolder != "events")) {
			// If console logs are enabled and the file is not a library file
			if (scriptsConsoleLogs) {
				// Script folder, example: "actions"
				std::string scriptFolder = parentPath.string();

				// If the current directory is different from the last directory that was logged
				if (lastDirectory.empty() || lastDirectory != scriptFolder) {
					// Update the last directory variable and log the directory name
					g_logger().info("Loading folder: [{}]", fileFolder);
				}
				lastDirectory = std::move(scriptFolder);
			}

			const auto scriptPath = realPath.string();
			// If the function 'loadFile' returns -1, then there was an error loading the file
			if (scriptInterface.loadFile(scriptPath, file, sourceMetadata ? &*sourceMetadata : nullptr) == -1) {
				// Log the error and the file path, and skip to the next iteration of the loop.
				g_logger().error(scriptPath);
				g_logger().error(scriptInterface.getLastLuaError());
				++failedFiles;
				continue;
			}
			++loadedFiles;
		} else {
			++skippedFiles;
			continue;
		}

		if (scriptsConsoleLogs) {
			if (!reload) {
				g_logger().info("[script loaded]: {}", file);
			} else {
				g_logger().info("[script reloaded]: {}", file);
			}
		}
	}

	if (startupLoadTelemetry) {
		g_logger().info(
			"Loaded scripts from '{}' in {:.3f} ms (entries: {}, lua: {}, loaded: {}, disabled: {}, skipped: {}, failed: {}, bytes: {})",
			folderName,
			loadScriptsBenchmark.duration(),
			scannedEntries,
			luaFiles,
			loadedFiles,
			disabledFiles,
			skippedFiles,
			failedFiles,
			luaBytes
		);

		if (bytecodeCacheEnabled) {
			const auto bytecodeStats = subtractLuaBytecodeCacheStats(LuaScriptInterface::getBytecodeCacheStats(), bytecodeStatsBefore);
			g_logger().info(
				"Lua bytecode cache for '{}': pack hits: {}, file hits: {}, misses: {}, writes: {}, pack invalidations: {}, file invalidations: {}",
				folderName,
				bytecodeStats.packHits,
				bytecodeStats.fileHits,
				bytecodeStats.misses,
				bytecodeStats.writes,
				bytecodeStats.packInvalidations,
				bytecodeStats.fileInvalidations
			);
		}
	}

	return true;
}
