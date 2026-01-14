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

	const auto now = getTimeNow();

	phmap::flat_hash_set<std::string> loadedScripts;
	std::map<std::string, EventRates> eventsOnSameDay;

	for (const auto &event : eventsJson["events"]) {
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

		if (!eventScript.empty()) {
			if (loadedScripts.contains(eventScript)) {
				g_logger().warn("{} - Script declaration '{}' is duplicated in '{}'", __FUNCTION__, eventScript, folder);
				continue;
			}

			loadedScripts.insert(eventScript);
			std::filesystem::path filePath = std::filesystem::current_path() / coreFolder / "json" / "eventscheduler" / "scripts" / eventScript;

			if (!std::filesystem::exists(filePath) || !std::filesystem::is_regular_file(filePath)) {
				g_logger().warn("{} - Cannot find script file '{}'", __FUNCTION__, filePath.string());
				return false;
			}

			if (!g_scripts().loadEventSchedulerScripts(filePath)) {
				g_logger().warn("{} - Cannot load the file '{}' on '{}/json/eventscheduler/scripts/'", __FUNCTION__, eventScript, coreFolder);
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

bool EventsScheduler::loadScheduleEventFromXml() {
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY) + "/XML/events.xml";
	if (!doc.load_file(folder.c_str())) {
		printXMLError(__FUNCTION__, folder, doc.load_file(folder.c_str()));
		consoleHandlerExit();
		return false;
	}

	const auto now = getTimeNow();

	// Keep track of loaded scripts to check for duplicates
	phmap::flat_hash_set<std::string> loadedScripts;
	std::map<std::string, EventRates> eventsOnSameDay;
	for (const auto &eventNode : doc.child("events").children()) {
		std::string eventScript = eventNode.attribute("script").as_string();
		std::string eventName = eventNode.attribute("name").as_string();

		const auto startDateAttr = eventNode.attribute("startdate");
		const auto endDateAttr = eventNode.attribute("enddate");
		if (startDateAttr.empty() || endDateAttr.empty()) {
			g_logger().warn("{} - Missing 'startdate' or 'enddate' for event '{}'", __FUNCTION__, eventName);
			continue;
		}

		std::string defaultHour = eventNode.attribute("hour").empty() ? std::string {} : eventNode.attribute("hour").as_string();
		std::string startHour = eventNode.attribute("starthour").empty() ? (!defaultHour.empty() ? defaultHour : "00:00") : eventNode.attribute("starthour").as_string();
		std::string endHour = eventNode.attribute("endhour").empty() ? (!defaultHour.empty() ? defaultHour : "23:59:59") : eventNode.attribute("endhour").as_string();
		std::time_t startTime {};
		std::time_t endTime {};
		if (!parseDateTime(startDateAttr.as_string(), startHour, startTime) || !parseDateTime(endDateAttr.as_string(), endHour, endTime)) {
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

		if (!eventScript.empty() && loadedScripts.contains(eventScript)) {
			g_logger().warn("{} - Script declaration '{}' in duplicate 'data/XML/events.xml'.", __FUNCTION__, eventScript);
			continue;
		}

		loadedScripts.insert(eventScript);
		auto coreFolder = g_configManager().getString(CORE_DIRECTORY);
		std::filesystem::path filePath = std::filesystem::current_path() / coreFolder / "XML" / "events" / "scheduler" / "scripts" / eventScript;
		if (!g_scripts().loadEventSchedulerScripts(filePath)) {
			g_logger().warn("{} - Cannot load the file '{}' on '/events/scripts/scheduler/'", __FUNCTION__, eventScript);
			return false;
		}

		EventRates currentEventRates;
		for (const auto &ingameNode : eventNode.children()) {
			if (ingameNode.attribute("exprate")) {
				uint16_t exprate = static_cast<uint16_t>(ingameNode.attribute("exprate").as_uint());
				currentEventRates.exprate = exprate;
				g_eventsScheduler().setExpSchedule(exprate);
			}

			if (ingameNode.attribute("lootrate")) {
				uint16_t lootrate = static_cast<uint16_t>(ingameNode.attribute("lootrate").as_uint());
				currentEventRates.lootrate = lootrate;
				g_eventsScheduler().setLootSchedule(lootrate);
			}

			if (ingameNode.attribute("bosslootrate")) {
				uint16_t bosslootrate = static_cast<uint16_t>(ingameNode.attribute("bosslootrate").as_uint());
				currentEventRates.bosslootrate = bosslootrate;
				g_eventsScheduler().setBossLootSchedule(bosslootrate);
			}

			if (ingameNode.attribute("spawnrate")) {
				uint16_t spawnrate = static_cast<uint16_t>(ingameNode.attribute("spawnrate").as_uint());
				currentEventRates.spawnrate = spawnrate;
				g_eventsScheduler().setSpawnMonsterSchedule(spawnrate);
			}

			if (ingameNode.attribute("skillrate")) {
				uint16_t skillrate = static_cast<uint16_t>(ingameNode.attribute("skillrate").as_uint());
				currentEventRates.skillrate = skillrate;
				g_eventsScheduler().setSkillSchedule(skillrate);
			}
		}

		for (const auto &[existingName, rates] : eventsOnSameDay) {
			std::vector<std::string> modifiedRates;

			if (rates.exprate != 100 && currentEventRates.exprate != 100 && rates.exprate == currentEventRates.exprate) {
				modifiedRates.emplace_back("exprate");
			}
			if (rates.lootrate != 100 && currentEventRates.lootrate != 100 && rates.lootrate == currentEventRates.lootrate) {
				modifiedRates.emplace_back("lootrate");
			}
			if (rates.bosslootrate != 100 && currentEventRates.bosslootrate != 100 && rates.bosslootrate == currentEventRates.bosslootrate) {
				modifiedRates.emplace_back("bosslootrate");
			}
			if (rates.spawnrate != 100 && currentEventRates.spawnrate != 100 && rates.spawnrate == currentEventRates.spawnrate) {
				modifiedRates.emplace_back("spawnrate");
			}
			if (rates.skillrate != 100 && currentEventRates.skillrate != 100 && rates.skillrate == currentEventRates.skillrate) {
				modifiedRates.emplace_back("skillrate");
			}

			if (!modifiedRates.empty()) {
				std::string ratesString = join(modifiedRates, ", ");
				g_logger().warn("{} - Events '{}' and '{}' have the same rates [{}] on the same day.", __FUNCTION__, eventNode.attribute("name").as_string(), existingName.c_str(), ratesString);
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
