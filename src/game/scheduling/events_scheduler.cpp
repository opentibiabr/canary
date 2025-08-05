/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/scheduling/events_scheduler.hpp"

#include "config/configmanager.hpp"
#include "lua/scripts/scripts.hpp"

#include <nlohmann/json.hpp>

bool EventsScheduler::loadScheduleEventFromJson() {
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

	time_t t = time(nullptr);
	const tm* timePtr = localtime(&t);
	int daysMath = ((timePtr->tm_year + 1900) * 365) + ((timePtr->tm_mon + 1) * 30) + (timePtr->tm_mday);

	phmap::flat_hash_set<std::string_view> loadedScripts;
	std::map<std::string, EventRates> eventsOnSameDay;

	for (const auto &event : eventsJson["events"]) {
		std::string eventScript = event.contains("script") && !event["script"].is_null() ? event["script"].get<std::string>() : "";
		std::string eventName = event.value("name", "");

		if (!event.contains("startdate") || !event.contains("enddate")) {
			g_logger().warn("{} - Missing 'startdate' or 'enddate' for event '{}'", __FUNCTION__, eventName);
			continue;
		}

		int startYear, startMonth, startDay, endYear, endMonth, endDay;
		if (sscanf(event["startdate"].get<std::string>().c_str(), "%d/%d/%d", &startMonth, &startDay, &startYear) != 3 || sscanf(event["enddate"].get<std::string>().c_str(), "%d/%d/%d", &endMonth, &endDay, &endYear) != 3) {
			g_logger().warn("{} - Invalid date format for event '{}'", __FUNCTION__, eventName);
			continue;
		}

		int startDays = (startYear * 365) + (startMonth * 30) + startDay;
		int endDays = (endYear * 365) + (endMonth * 30) + endDay;

		if (daysMath < startDays || daysMath > endDays) {
			continue;
		}

		if (!eventScript.empty()) {
			if (loadedScripts.contains(eventScript)) {
				g_logger().warn("{} - Script declaration '{}' is duplicated in '{}'", __FUNCTION__, eventScript, folder);
				continue;
			}

			loadedScripts.insert(eventScript);
			std::filesystem::path filePath = std::filesystem::current_path() / coreFolder / "json" / "scripts" / eventScript;

			if (!std::filesystem::exists(filePath) || !std::filesystem::is_regular_file(filePath)) {
				g_logger().warn("{} - Cannot find script file '{}'", __FUNCTION__, filePath.string());
				return false;
			}

			if (!g_scripts().loadEventSchedulerScripts(filePath)) {
				g_logger().warn("{} - Cannot load the file '{}' on '{}/scripts/'", __FUNCTION__, eventScript, coreFolder);
				return false;
			}
		}

		EventRates currentEventRates = {
			static_cast<uint16_t>(event.contains("ingame") && event["ingame"].contains("exprate") ? event["ingame"].value("exprate", 100) : 100),
			static_cast<uint32_t>(event.contains("ingame") && event["ingame"].contains("lootrate") ? event["ingame"].value("lootrate", 100) : 100),
			static_cast<uint32_t>(event.contains("ingame") && event["ingame"].contains("bosslootrate") ? event["ingame"].value("bosslootrate", 100) : 100),
			static_cast<uint32_t>(event.contains("ingame") && event["ingame"].contains("spawnrate") ? event["ingame"].value("spawnrate", 100) : 100),
			static_cast<uint16_t>(event.contains("ingame") && event["ingame"].contains("skillrate") ? event["ingame"].value("skillrate", 100) : 100),
			static_cast<uint8_t>(event.contains("ingame") && event["ingame"].contains("forgechance") ? event["ingame"].value("forge-chance", 100) : 100),
			static_cast<uint8_t>(event.contains("ingame") && event["ingame"].contains("bosscooldown") ? event["ingame"].value("bosscooldown", 100) : 100),
			event.contains("ingame") && event["ingame"].contains("doublebestiary") ? event["ingame"].value("doublebestiary", false) : false,
			event.contains("ingame") && event["ingame"].contains("doublebosstiary") ? event["ingame"].value("doublebosstiary", false) : false,
			event.contains("ingame") && event["ingame"].contains("fastexercise") ? event["ingame"].value("fastexercise", false) : false,
		};

		for (const auto &[existingEventName, rates] : eventsOnSameDay) {
			std::vector<std::string> modifiedRates;

			if (rates.exprate != 100 && currentEventRates.exprate != 100 && rates.exprate == currentEventRates.exprate) {
				modifiedRates.emplace_back("exprate");
				g_eventsScheduler().setExpSchedule(rates.exprate);
			}
			if (rates.lootrate != 100 && currentEventRates.lootrate != 100 && rates.lootrate == currentEventRates.lootrate) {
				modifiedRates.emplace_back("lootrate");
				g_eventsScheduler().setLootSchedule(rates.lootrate);
			}
			if (rates.bosslootrate != 100 && currentEventRates.bosslootrate != 100 && rates.bosslootrate == currentEventRates.bosslootrate) {
				modifiedRates.emplace_back("bosslootrate");
				g_eventsScheduler().setBossLootSchedule(rates.bosslootrate);
			}
			if (rates.spawnrate != 100 && currentEventRates.spawnrate != 100 && rates.spawnrate == currentEventRates.spawnrate) {
				modifiedRates.emplace_back("spawnrate");
				g_eventsScheduler().setSpawnMonsterSchedule(rates.spawnrate);
			}
			if (rates.skillrate != 100 && currentEventRates.skillrate != 100 && rates.skillrate == currentEventRates.skillrate) {
				modifiedRates.emplace_back("skillrate");
				g_eventsScheduler().setSkillSchedule(rates.skillrate);
			}

			// KV changes
			if (rates.forgeChance != 100 && currentEventRates.forgeChance != 100 && rates.forgeChance == currentEventRates.forgeChance) {
				modifiedRates.emplace_back("forge-chance");
				g_kv().scoped("eventscheduler")->set("forge-chance", rates.forgeChance - 100);
			}

			if (rates.doubleBestiary != false && currentEventRates.doubleBestiary != false && rates.doubleBestiary == currentEventRates.doubleBestiary) {
				modifiedRates.emplace_back("double-bestiary");
				g_kv().scoped("eventscheduler")->set("double-bestiary", true);
			}

			if (rates.doubleBossTiary != false && currentEventRates.doubleBossTiary != false && rates.doubleBossTiary == currentEventRates.doubleBossTiary) {
				modifiedRates.emplace_back("double-bosstiary");
				g_kv().scoped("eventscheduler")->set("double-bosstiary", true);
			}

			if (rates.fastExercise != false && currentEventRates.fastExercise != false && rates.fastExercise == currentEventRates.fastExercise) {
				modifiedRates.emplace_back("fast-exercise");
				g_kv().scoped("eventscheduler")->set("fast-exercise", true);
			}

			if (rates.bosscooldown != 100 && currentEventRates.bosscooldown != 100 && rates.bosscooldown == currentEventRates.bosscooldown) {
				modifiedRates.emplace_back("bosscooldown");
				g_kv().scoped("eventscheduler")->set("boss-cooldown", rates.bosscooldown - 100);
			}

			if (!modifiedRates.empty()) {
				std::string ratesString = join(modifiedRates, ", ");
				g_logger().warn("{} - Events '{}' and '{}' have the same rates [{}] on the same day.", __FUNCTION__, eventName, existingEventName, ratesString);
			}
		}

		eventsOnSameDay[eventName] = currentEventRates;
		eventScheduler.emplace_back(EventScheduler(eventName, startDays, endDays));
	}

	for (const auto &event : eventScheduler) {
		if (daysMath >= event.startDays && daysMath <= event.endDays) {
			g_logger().info("Active EventScheduler: {}", event.name);
		}
	}
	return true;
}

bool EventsScheduler::loadScheduleEventFromXml() {
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY) + "/XML/events.xml";
	if (!doc.load_file(folder.c_str())) {
		printXMLError(__FUNCTION__, folder, doc.load_file(folder.c_str()));
		consoleHandlerExit();
		return false;
	}

	time_t t = time(nullptr);
	const tm* timePtr = localtime(&t);
	int daysMath = ((timePtr->tm_year + 1900) * 365) + ((timePtr->tm_mon + 1) * 30) + (timePtr->tm_mday);

	// Keep track of loaded scripts to check for duplicates
	phmap::flat_hash_set<std::string_view> loadedScripts;
	std::map<std::string, EventRates> eventsOnSameDay;
	for (const auto &eventNode : doc.child("events").children()) {
		std::string eventScript = eventNode.attribute("script").as_string();
		std::string eventName = eventNode.attribute("name").as_string();

		int16_t startYear;
		int16_t startMonth;
		int16_t startDay;
		int16_t endYear;
		int16_t endMonth;
		int16_t endDay;
		sscanf(eventNode.attribute("startdate").as_string(), "%hd/%hd/%hd", &startMonth, &startDay, &startYear);
		sscanf(eventNode.attribute("enddate").as_string(), "%hd/%hd/%hd", &endMonth, &endDay, &endYear);
		int startDays = ((startYear * 365) + (startMonth * 30) + startDay);
		int endDays = ((endYear * 365) + (endMonth * 30) + endDay);

		if (daysMath < startDays || daysMath > endDays) {
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

		for (const auto &[eventName, rates] : eventsOnSameDay) {
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
				g_logger().warn("{} - Events '{}' and '{}' have the same rates [{}] on the same day.", __FUNCTION__, eventNode.attribute("name").as_string(), eventName.c_str(), ratesString);
			}
		}

		eventsOnSameDay[eventName] = currentEventRates;
		eventScheduler.emplace_back(EventScheduler(eventName, startDays, endDays));
	}

	for (const auto &event : eventScheduler) {
		if (daysMath >= event.startDays && daysMath <= event.endDays) {
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
