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
		if (!eventScript.empty() && !g_scripts().loadEventSchedulerScripts(eventScript)) {
			g_logger().warn("{} - Can not load the file '{}' on '/events/scripts/scheduler/'", __FUNCTION__, eventScript);
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
