/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/scheduling/events_scheduler.hpp"

#include "config/configmanager.hpp"
#include "lua/scripts/scripts.hpp"

#include <nlohmann/json.hpp>
#include <optional>
#include <string_view>

namespace {
	bool parseDateTime(const std::string &dateStr, const std::string &timeStr, std::time_t &result) {
		int month = 0;
		int day = 0;
		int year = 0;
		if (sscanf(dateStr.c_str(), "%d/%d/%d", &month, &day, &year) != 3) {
			return false;
		}
		int hour = 0;
		int minute = 0;
		int second = 0;
		if (!timeStr.empty()) {
			const int parsed = sscanf(timeStr.c_str(), "%d:%d:%d", &hour, &minute, &second);
			if (parsed < 2) {
				return false;
			}
			if (parsed == 2) {
				second = 0;
			}
		}
		if (hour < 0 || hour > 23 || minute < 0 || minute > 59 || second < 0 || second > 59) {
			return false;
		}
		std::tm tmDate {};
		tmDate.tm_year = year - 1900;
		tmDate.tm_mon = month - 1;
		tmDate.tm_mday = day;
		tmDate.tm_hour = hour;
		tmDate.tm_min = minute;
		tmDate.tm_sec = second;
		tmDate.tm_isdst = -1;
		const std::time_t timestamp = std::mktime(&tmDate);
		if (timestamp == static_cast<std::time_t>(-1)) {
			return false;
		}
		result = timestamp;
		return true;
	}

	const std::filesystem::path jsonEventSchedulerScriptsDir = "json/eventscheduler/scripts";

	struct EventSchedulerScriptSearchPaths {
		std::filesystem::path coreFolder;
		std::filesystem::path primaryDir;
	};

	std::optional<std::string> normalizeEventSchedulerScriptPath(std::string_view script, std::string_view caller) {
		std::filesystem::path path { std::string(script) };

		// Reject any rooted path (absolute paths, UNC paths, drive-relative "C:foo", etc.)
		if (path.is_absolute() || path.has_root_name() || path.has_root_directory()) {
			g_logger().warn("{} - Rejecting absolute path in script: '{}'", caller, script);
			return std::nullopt;
		}

		for (const auto &component : path) {
			const std::string componentStr = component.string();
			if (componentStr == ".." || componentStr.empty()) {
				g_logger().warn("{} - Rejecting path with invalid components (.. or empty) in script: '{}'", caller, script);
				return std::nullopt;
			}
		}

		std::filesystem::path normalizedPath = path.lexically_normal();
		std::string normalizedStr = normalizedPath.generic_string();
		while (normalizedStr.starts_with("./")) {
			normalizedStr = normalizedStr.substr(2);
		}

		if (normalizedStr.empty() || normalizedStr == ".") {
			g_logger().warn("{} - Rejecting empty script path after normalization: '{}'", caller, script);
			return std::nullopt;
		}

		return normalizedStr;
	}

	std::optional<std::filesystem::path> resolveEventSchedulerScriptFilePath(
		const EventSchedulerScriptSearchPaths &scriptSearchPaths,
		const std::filesystem::path &normalizedScript
	) {
		const std::filesystem::path basePath = std::filesystem::current_path() / scriptSearchPaths.coreFolder;
		std::filesystem::path primaryPath = basePath / scriptSearchPaths.primaryDir / normalizedScript;
		if (std::filesystem::exists(primaryPath) && std::filesystem::is_regular_file(primaryPath)) {
			return primaryPath;
		}

		return std::nullopt;
	}

	bool loadEventSchedulerScript(
		std::string_view caller,
		std::string_view sourceFile,
		phmap::flat_hash_set<std::string> &loadedScripts,
		const std::string &eventScript,
		const EventSchedulerScriptSearchPaths &scriptSearchPaths,
		bool skipOnFailure
	) {
		if (eventScript.empty()) {
			return true;
		}

		const auto normalizedScriptOpt = normalizeEventSchedulerScriptPath(eventScript, caller);
		if (!normalizedScriptOpt) {
			return true;
		}

		const std::filesystem::path normalizedScript { *normalizedScriptOpt };
		const std::string normalizedScriptKey = normalizedScript.generic_string();
		if (loadedScripts.contains(normalizedScriptKey)) {
			g_logger().warn("{} - Script declaration '{}' is duplicated in '{}'", caller, normalizedScriptKey, sourceFile);
			return true;
		}
		loadedScripts.insert(normalizedScriptKey);

		const auto scriptPathOpt = resolveEventSchedulerScriptFilePath(scriptSearchPaths, normalizedScript);
		const std::string coreFolderKey = scriptSearchPaths.coreFolder.generic_string();
		const std::string primaryDirKey = scriptSearchPaths.primaryDir.generic_string();
		if (!scriptPathOpt) {
			g_logger().warn(
				"{} - Cannot find the file '{}' on '{}/{}/'{}",
				caller,
				normalizedScriptKey,
				coreFolderKey, primaryDirKey,
				skipOnFailure ? ", skipping" : ""
			);
			return skipOnFailure;
		}

		if (!g_scripts().loadEventSchedulerScripts(*scriptPathOpt)) {
			g_logger().warn(
				"{} - Cannot load the file '{}' on '{}/{}/'{}",
				caller,
				normalizedScriptKey,
				coreFolderKey, primaryDirKey,
				skipOnFailure ? ", skipping" : ""
			);
			return skipOnFailure;
		}

		return true;
	}
}

bool EventsScheduler::loadScheduleEventFromJson() {
	reset();
	g_kv().scoped("eventscheduler")->remove("forge-chance");
	g_kv().scoped("eventscheduler")->remove("double-bestiary");
	g_kv().scoped("eventscheduler")->remove("double-bosstiary");
	g_kv().scoped("eventscheduler")->remove("fast-exercise");
	g_kv().scoped("eventscheduler")->remove("boss-cooldown");

	using json = nlohmann::json;
	auto coreFolder = g_configManager().getString(CORE_DIRECTORY);
	auto folder = coreFolder + "/json/eventscheduler/events.json";
	std::ifstream file(folder);
	if (!file.is_open()) {
		g_logger().error("{} - Unable to open file '{}'", __FUNCTION__, folder);
		consoleHandlerExit();
		return false;
	}

	json eventsJson;
	try {
		file >> eventsJson;
	} catch (const json::parse_error &e) {
		g_logger().error("{} - JSON parsing error in file '{}': {}", __FUNCTION__, folder, e.what());
		consoleHandlerExit();
		return false;
	}

	const auto eventsIt = eventsJson.find("events");
	if (eventsIt == eventsJson.end() || !eventsIt->is_array()) {
		g_logger().error("{} - Missing or invalid 'events' array in '{}'", __FUNCTION__, folder);
		consoleHandlerExit();
		return false;
	}

	const auto now = getTimeNow();

	phmap::flat_hash_set<std::string> loadedScripts;
	std::map<std::string, EventRates> eventsOnSameDay;

	const EventSchedulerScriptSearchPaths scriptSearchPaths {
		std::filesystem::path(coreFolder),
		jsonEventSchedulerScriptsDir
	};

	for (const auto &event : *eventsIt) {
		std::string eventScript = event.contains("script") && !event["script"].is_null() ? event["script"].get<std::string>() : "";
		std::string eventName = event.value("name", "");

		if (!event.contains("startdate") || !event.contains("enddate")) {
			g_logger().warn("{} - Missing 'startdate' or 'enddate' for event '{}'", __FUNCTION__, eventName);
			continue;
		}

		const std::string defaultHour = event.contains("hour") && !event["hour"].is_null() ? event["hour"].get<std::string>() : std::string {};
		const std::string startHour = event.contains("starthour") && !event["starthour"].is_null() ? event["starthour"].get<std::string>() : (!defaultHour.empty() ? defaultHour : "00:00");
		const std::string endHour = event.contains("endhour") && !event["endhour"].is_null() ? event["endhour"].get<std::string>() : (!defaultHour.empty() ? defaultHour : "23:59:59");
		std::time_t startTime {};
		std::time_t endTime {};
		if (!parseDateTime(event["startdate"].get<std::string>(), startHour, startTime) || !parseDateTime(event["enddate"].get<std::string>(), endHour, endTime)) {
			g_logger().warn("{} - Invalid date or hour format for event '{}'", __FUNCTION__, eventName);
			continue;
		}
		if (endTime < startTime) {
			g_logger().warn("{} - Event '{}' end time is before start time", __FUNCTION__, eventName);
			continue;
		}

		if (now < startTime || now > endTime) {
			continue;
		}

		{
			if (!loadEventSchedulerScript(__FUNCTION__, folder, loadedScripts, eventScript, scriptSearchPaths, true)) {
				return false;
			}
		}

		EventRates currentEventRates;
		if (event.contains("ingame") && event["ingame"].is_object()) {
			const auto &ingame = event["ingame"];
			currentEventRates.exprate = static_cast<uint16_t>(ingame.value("exprate", 100));
			currentEventRates.lootrate = static_cast<uint32_t>(ingame.value("lootrate", 100));
			currentEventRates.bosslootrate = static_cast<uint32_t>(ingame.value("bosslootrate", 100));
			currentEventRates.spawnrate = static_cast<uint32_t>(ingame.value("spawnrate", 100));
			currentEventRates.skillrate = static_cast<uint16_t>(ingame.value("skillrate", 100));
			if (ingame.contains("forgechance")) {
				currentEventRates.forgeChance = static_cast<uint8_t>(ingame.value("forgechance", 100));
			} else if (ingame.contains("forge-chance")) {
				currentEventRates.forgeChance = static_cast<uint8_t>(ingame.value("forge-chance", 100));
			}
			currentEventRates.bosscooldown = static_cast<uint8_t>(ingame.value("bosscooldown", 100));
			currentEventRates.doubleBestiary = ingame.value("doublebestiary", false);
			currentEventRates.doubleBossTiary = ingame.value("doublebosstiary", false);
			if (ingame.contains("fastexercise")) {
				currentEventRates.fastExercise = ingame.value("fastexercise", false);
			} else if (ingame.contains("doubleexercise")) {
				currentEventRates.fastExercise = ingame.value("doubleexercise", false);
			}
		}

		bool applyExp = currentEventRates.exprate != 100;
		bool applyLoot = currentEventRates.lootrate != 100;
		bool applyBossLoot = currentEventRates.bosslootrate != 100;
		bool applySpawn = currentEventRates.spawnrate != 100;
		bool applySkill = currentEventRates.skillrate != 100;
		bool applyForge = currentEventRates.forgeChance != 100;
		bool applyDoubleBestiary = currentEventRates.doubleBestiary;
		bool applyDoubleBosstiary = currentEventRates.doubleBossTiary;
		bool applyFastExercise = currentEventRates.fastExercise;
		bool applyBossCooldown = currentEventRates.bosscooldown != 100;
		std::unordered_map<std::string, std::vector<std::string>> duplicatedRates;
		for (const auto &[existingEventName, rates] : eventsOnSameDay) {
			if (applyExp && rates.exprate != 100 && rates.exprate == currentEventRates.exprate) {
				duplicatedRates[existingEventName].emplace_back("exprate");
				applyExp = false;
			}
			if (applyLoot && rates.lootrate != 100 && rates.lootrate == currentEventRates.lootrate) {
				duplicatedRates[existingEventName].emplace_back("lootrate");
				applyLoot = false;
			}
			if (applyBossLoot && rates.bosslootrate != 100 && rates.bosslootrate == currentEventRates.bosslootrate) {
				duplicatedRates[existingEventName].emplace_back("bosslootrate");
				applyBossLoot = false;
			}
			if (applySpawn && rates.spawnrate != 100 && rates.spawnrate == currentEventRates.spawnrate) {
				duplicatedRates[existingEventName].emplace_back("spawnrate");
				applySpawn = false;
			}
			if (applySkill && rates.skillrate != 100 && rates.skillrate == currentEventRates.skillrate) {
				duplicatedRates[existingEventName].emplace_back("skillrate");
				applySkill = false;
			}
			if (applyForge && rates.forgeChance != 100 && rates.forgeChance == currentEventRates.forgeChance) {
				duplicatedRates[existingEventName].emplace_back("forge-chance");
				applyForge = false;
			}
			if (applyDoubleBestiary && rates.doubleBestiary && rates.doubleBestiary == currentEventRates.doubleBestiary) {
				duplicatedRates[existingEventName].emplace_back("double-bestiary");
				applyDoubleBestiary = false;
			}
			if (applyDoubleBosstiary && rates.doubleBossTiary && rates.doubleBossTiary == currentEventRates.doubleBossTiary) {
				duplicatedRates[existingEventName].emplace_back("double-bosstiary");
				applyDoubleBosstiary = false;
			}
			if (applyFastExercise && rates.fastExercise && rates.fastExercise == currentEventRates.fastExercise) {
				duplicatedRates[existingEventName].emplace_back("fast-exercise");
				applyFastExercise = false;
			}
			if (applyBossCooldown && rates.bosscooldown != 100 && rates.bosscooldown == currentEventRates.bosscooldown) {
				duplicatedRates[existingEventName].emplace_back("bosscooldown");
				applyBossCooldown = false;
			}
		}

		if (applyExp) {
			setExpSchedule(currentEventRates.exprate);
		}
		if (applyLoot) {
			setLootSchedule(currentEventRates.lootrate);
		}
		if (applyBossLoot) {
			setBossLootSchedule(currentEventRates.bosslootrate);
		}
		if (applySpawn) {
			setSpawnMonsterSchedule(currentEventRates.spawnrate);
		}
		if (applySkill) {
			setSkillSchedule(currentEventRates.skillrate);
		}
		if (applyForge) {
			g_kv().scoped("eventscheduler")->set("forge-chance", currentEventRates.forgeChance);
		}
		if (applyDoubleBestiary) {
			g_kv().scoped("eventscheduler")->set("double-bestiary", true);
		}
		if (applyDoubleBosstiary) {
			g_kv().scoped("eventscheduler")->set("double-bosstiary", true);
		}
		if (applyFastExercise) {
			g_kv().scoped("eventscheduler")->set("fast-exercise", true);
		}
		if (applyBossCooldown) {
			g_kv().scoped("eventscheduler")->set("boss-cooldown", currentEventRates.bosscooldown);
		}

		for (const auto &[duplicateEventName, rates] : duplicatedRates) {
			if (!rates.empty()) {
				std::string ratesString = join(rates, ", ");
				g_logger().warn("{} - Events '{}' and '{}' have the same rates [{}] on the same day.", __FUNCTION__, eventName, duplicateEventName, ratesString);
			}
		}

		eventsOnSameDay[eventName] = currentEventRates;
		eventScheduler.emplace_back(EventScheduler { eventName, startTime, endTime });
	}

	for (const auto &event : eventScheduler) {
		if (now >= event.startTime && now <= event.endTime) {
			g_logger().info("Active EventScheduler: {}", event.name);
		}
	}
	return true;
}

void EventsScheduler::reset() {
	expSchedule = 100;
	lootSchedule = 100;
	bossLootSchedule = 100;
	skillSchedule = 100;
	spawnMonsterSchedule = 100;
	eventScheduler.clear();
}

std::vector<std::string> EventsScheduler::getActiveEvents() const {
	std::vector<std::string> activeEvents;
	const auto now = getTimeNow();
	for (const auto &event : eventScheduler) {
		if (now >= event.startTime && now <= event.endTime) {
			activeEvents.emplace_back(event.name);
		}
	}
	return activeEvents;
}

std::string EventsScheduler::join(const std::vector<std::string> &vec, const std::string &delim) {
	std::stringstream result;
	for (size_t i = 0; i < vec.size(); ++i) {
		result << vec[i];
		if (i != vec.size() - 1) {
			result << delim;
		}
	}
	return result.str();
}
