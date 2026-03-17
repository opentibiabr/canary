/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "game/scheduling/events_scheduler.hpp"
#include "kv/kv.hpp"
#include "kv/kv_definitions.hpp"

namespace test::events_scheduler {

	inline void expectScheduleRates(int expRate, uint32_t lootRate, uint32_t bossLootRate, uint32_t spawnRate, int skillRate) {
		EXPECT_EQ(expRate, g_eventsScheduler().getExpSchedule());
		EXPECT_EQ(lootRate, g_eventsScheduler().getLootSchedule());
		EXPECT_EQ(bossLootRate, g_eventsScheduler().getBossLootSchedule());
		EXPECT_EQ(spawnRate, g_eventsScheduler().getSpawnMonsterSchedule());
		EXPECT_EQ(skillRate, g_eventsScheduler().getSkillSchedule());
	}

	inline std::shared_ptr<KV> eventSchedulerScope() {
		return g_kv().scoped("eventscheduler");
	}

	inline void expectEventScopeInt(const std::string &key, int expected) {
		const auto value = eventSchedulerScope()->get(key);
		ASSERT_TRUE(value.has_value());
		EXPECT_EQ(expected, value->get<IntType>());
	}

	inline void expectEventScopeBool(const std::string &key, bool expected) {
		const auto value = eventSchedulerScope()->get(key);
		ASSERT_TRUE(value.has_value());
		EXPECT_EQ(expected, value->get<BooleanType>());
	}

	inline void expectEventScopeMissing(std::initializer_list<std::string> keys) {
		auto scope = eventSchedulerScope();
		for (const auto &key : keys) {
			EXPECT_FALSE(scope->get(key).has_value());
		}
	}

	inline void expectSingleActiveEvent(const std::string &eventName) {
		const auto activeEvents = g_eventsScheduler().getActiveEvents();
		ASSERT_EQ(1u, activeEvents.size());
		EXPECT_EQ(eventName, activeEvents.front());
	}

	inline void expectActiveEventsContain(const std::vector<std::string> &expectedEvents) {
		const auto activeEvents = g_eventsScheduler().getActiveEvents();
		ASSERT_EQ(expectedEvents.size(), activeEvents.size());
		for (const auto &eventName : expectedEvents) {
			EXPECT_NE(activeEvents.end(), std::ranges::find(activeEvents, eventName));
		}
	}

} // namespace test::events_scheduler
