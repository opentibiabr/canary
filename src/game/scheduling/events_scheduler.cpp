/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "otpch.h"

#include "game/scheduling/events_scheduler.hpp"
#include "game/game.h"
#include "lua/scripts/scripts.h"

bool EventsScheduler::loadScheduleEventFromXml() const
{
	pugi::xml_document doc;
	if (pugi::xml_parse_result result = doc.load_file("data/XML/events.xml"); !result) {
		printXMLError("Error - EventsScheduler::loadScheduleEventFromXml", "data/XML/events.xml", result);
		consoleHandlerExit();
		return false;
	}

	int daysNow;
	auto date = Game::getDate();
	int daysMath = ((static_cast<int>(date.year()) + 1900) * 365) + ((static_cast<unsigned int>(date.month()) + 1) * 30) + (static_cast<unsigned int>(date.day()));

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
				SPDLOG_WARN("Can not load the file '{}' on '/events/scripts/scheduler/'",
				attr.as_string());
				return false;
		}

		for (auto schedENode : schedNode.children()) {
			if ((schedENode.attribute("exprate"))) {
				auto exprate = static_cast<uint16_t>(schedENode.attribute("exprate").as_uint());
				g_eventsScheduler().setExpSchedule(exprate);
				ss << " exp: " << exprate << "%";
			}

			if ((schedENode.attribute("lootrate"))) {
				auto lootrate = static_cast<uint16_t>(schedENode.attribute("lootrate").as_uint());
				g_eventsScheduler().setLootSchedule(lootrate);
				ss << ", loot: " << lootrate << "%";
			}

			if ((schedENode.attribute("spawnrate"))) {
				uint32_t spawnrate = schedENode.attribute("spawnrate").as_uint();
				g_eventsScheduler().setSpawnMonsterSchedule(spawnrate);
				ss << ", spawn: "  << spawnrate << "%";
			}

			if ((schedENode.attribute("skillrate"))) {
				auto skillrate = static_cast<uint16_t>(schedENode.attribute("skillrate").as_uint());
				g_eventsScheduler().setSkillSchedule(skillrate);
				ss << ", skill: " << skillrate << "%";
				break;
			}
		}
	}
	return true;
}
