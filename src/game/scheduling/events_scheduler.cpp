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
    if (!doc.load_file(folder.c_str()))
    {
        printXMLError(__FUNCTION__, folder, doc.load_file(folder.c_str()));
        consoleHandlerExit();
        return false;
    }

    time_t t = time(nullptr);
    const tm* timePtr = localtime(&t);
    int daysMath = ((timePtr->tm_year + 1900) * 365) + ((timePtr->tm_mon + 1) * 30) + (timePtr->tm_mday);

    // Keep track of loaded scripts to check for duplicates
    std::set<std::string> loadedScripts;
    for (const auto& eventNode : doc.child("events").children()) {
        std::string eventScript = eventNode.attribute("script").as_string();

        int16_t startYear, startMonth, startDay;
        int16_t endYear, endMonth, endDay;
        sscanf(eventNode.attribute("startdate").as_string(), "%hd/%hd/%hd", &startMonth, &startDay, &startYear);
        sscanf(eventNode.attribute("enddate").as_string(), "%hd/%hd/%hd", &endMonth, &endDay, &endYear);
        int startDays = ((startYear * 365) + (startMonth * 30) + startDay);
        int endDays = ((endYear * 365) + (endMonth * 30) + endDay);

        if (daysMath < startDays || daysMath > endDays) {
            continue;
        }

        if (!eventScript.empty() && loadedScripts.count(eventScript) > 0) {
            SPDLOG_WARN("{} - Script declaration '{}' in duplicate 'data/XML/events.xml'.", __FUNCTION__, eventScript);
            continue;
        }

        loadedScripts.insert(eventScript);

        if (!eventScript.empty() && !g_scripts().loadEventSchedulerScripts(eventScript)) {
            SPDLOG_WARN("{} - Can not load the file '{}' on '/events/scripts/scheduler/'",
                        __FUNCTION__, eventScript);
            return false;
        }

		for (const auto& ingameNode : eventNode.children()) {
			if (ingameNode.attribute("exprate")) {
				g_eventsScheduler().setExpSchedule(ingameNode.attribute("exprate").as_uint());
			}

			if (ingameNode.attribute("lootrate")) {
				g_eventsScheduler().setLootSchedule(ingameNode.attribute("lootrate").as_uint());
			}

			if (ingameNode.attribute("spawnrate")) {
				g_eventsScheduler().setSpawnMonsterSchedule(ingameNode.attribute("spawnrate").as_uint());
			}

			if (ingameNode.attribute("skillrate")) {
				g_eventsScheduler().setSkillSchedule(ingameNode.attribute("skillrate").as_uint());
			}
		}
	}

    if(expSchedule == 0) {
       g_eventsScheduler().setExpSchedule(100);
    }
    if(lootSchedule == 0) {
      g_eventsScheduler().setLootSchedule(100);
    }
    if(spawnMonsterSchedule == 0) {
       g_eventsScheduler().setSpawnMonsterSchedule(100);
    }
    if(skillSchedule == 0) {
       g_eventsScheduler().setSkillSchedule(100);
    }

    SPDLOG_WARN("{}, {}, {}, {}", getExpSchedule(), getLootSchedule(), getSpawnMonsterSchedule(), getSkillSchedule());
	return true;
}
