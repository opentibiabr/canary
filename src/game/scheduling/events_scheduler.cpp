/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "config/configmanager.h"
#include "game/scheduling/events_scheduler.hpp"
#include "lua/scripts/scripts.h"
#include "utils/pugicast.h"

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
	int count = 0;
	std::set<std::string_view, std::less<>> loadedScripts;
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

		++count;
		if (count >= 2) {
			SPDLOG_WARN("{} - More than one event scheduled for the same day.", __FUNCTION__);
		}

		if (!eventScript.empty() && loadedScripts.contains(eventScript)) {
			SPDLOG_WARN("{} - Script declaration '{}' in duplicate 'data/XML/events.xml'.", __FUNCTION__, eventScript);
			continue;
		}

		loadedScripts.insert(eventScript);
		if (!eventScript.empty() && !g_scripts().loadEventSchedulerScripts(eventScript)) {
			SPDLOG_WARN("{} - Can not load the file '{}' on '/events/scripts/scheduler/'", __FUNCTION__, eventScript);
			return false;
		}

		for (const auto &ingameNode : eventNode.children()) {
			if (ingameNode.attribute("exprate")) {
				g_eventsScheduler().setExpSchedule(static_cast<uint16_t>(ingameNode.attribute("exprate").as_uint()));
			}

			if (ingameNode.attribute("lootrate")) {
				g_eventsScheduler().setLootSchedule(ingameNode.attribute("lootrate").as_uint());
			}

			if (ingameNode.attribute("spawnrate")) {
				g_eventsScheduler().setSpawnMonsterSchedule(ingameNode.attribute("spawnrate").as_uint());
			}

			if (ingameNode.attribute("skillrate")) {
				g_eventsScheduler().setSkillSchedule(static_cast<uint16_t>(ingameNode.attribute("skillrate").as_uint()));
			}
		}
		eventScheduler.push_back(EventScheduler(eventName, startDays, endDays));
	}

	for (const auto &event : eventScheduler) {
		if (daysMath >= event.startDays && daysMath <= event.endDays) {
			SPDLOG_INFO("Active EventScheduler: {}", event.name);
		}
	}
	return true;
}
