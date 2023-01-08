/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "config/configmanager.h"
#include "game/scheduling/events_scheduler.hpp"
#include "lua/scripts/scripts.h"
#include "utils/pugicast.h"

bool EventsScheduler::loadScheduleEventFromXml() const
{
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY) + "/XML/events.xml";
	if (
		// Init-statement
		pugi::xml_parse_result result = doc.load_file(folder.c_str());
		// Condition
		!result
	)
	{
		printXMLError(__FUNCTION__, folder, result);
		consoleHandlerExit();
		return false;
	}

	int daysNow;
	time_t t = time(nullptr);
	const tm* timePtr = localtime(&t);
	int daysMath = ((timePtr->tm_year + 1900) * 365) + ((timePtr->tm_mon + 1) * 30) + (timePtr->tm_mday);

	for (auto schedNode : doc.child("events").children()) {
		std::string ss_d;
		std::stringstream ss;

		pugi::xml_attribute attr;
		if ((attr = schedNode.attribute("name"))) {
			ss_d = attr.as_string();
			ss << ss_d << " event";
		}

		int16_t year;
		int16_t day;
		int16_t month;

		if (!(attr = schedNode.attribute("enddate"))) {
			continue;
		} else {
			ss_d = attr.as_string();
			sscanf(ss_d.c_str(), "%hd/%hd/%hd", &month, &day, &year);
			daysNow = ((year * 365) + (month * 30) + day);
			if (daysMath > daysNow) {
				continue;
			}
		}

		if (!(attr = schedNode.attribute("startdate"))) {
			continue;
		} else {
			ss_d = attr.as_string();
			sscanf(ss_d.c_str(), "%hd/%hd/%hd", &month, &day, &year);
			daysNow = ((year * 365) + (month * 30) + day);
			if (daysMath < daysNow) {
				continue;
			}
		}

		if ((attr = schedNode.attribute("script")) && (!(g_scripts().loadEventSchedulerScripts(attr.as_string())))) {
				SPDLOG_WARN("{} - Can not load the file '{}' on '/events/scripts/scheduler/'",
				__FUNCTION__, attr.as_string());
				return false;
		}

		for (auto schedENode : schedNode.children()) {
			if ((schedENode.attribute("exprate"))) {
				uint16_t exprate = pugi::cast<uint16_t>(schedENode.attribute("exprate").value());
				g_eventsScheduler().setExpSchedule(exprate);
				ss << " exp: " << exprate << "%";
			}

			if ((schedENode.attribute("lootrate"))) {
				uint16_t lootrate = pugi::cast<uint16_t>(schedENode.attribute("lootrate").value());
				g_eventsScheduler().setLootSchedule(lootrate);
				ss << ", loot: " << lootrate << "%";
			}

			if ((schedENode.attribute("spawnrate"))) {
				uint32_t spawnrate = pugi::cast<uint32_t>(schedENode.attribute("spawnrate").value());
				g_eventsScheduler().setSpawnMonsterSchedule(spawnrate);
				ss << ", spawn: "  << spawnrate << "%";
			}

			if ((schedENode.attribute("skillrate"))) {
				uint16_t skillrate = pugi::cast<uint16_t>(schedENode.attribute("skillrate").value());
				g_eventsScheduler().setSkillSchedule(skillrate);
				ss << ", skill: " << skillrate << "%";
				break;
			}
		}
	}
	return true;
}
