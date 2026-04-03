/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "config/configmanager.hpp"
#include "game/scheduling/events_scheduler.hpp"
#include "injection_fixture.hpp"
#include "kv/kv.hpp"
#include "kv/kv_definitions.hpp"
#include "../../shared/game/events_scheduler_test_fixture.hpp"
#include "../../shared/game/events_scheduler_test_helpers.hpp"

using test::events_scheduler::EventsSchedulerTestBase;
using test::events_scheduler::expectActiveEventsContain;
using test::events_scheduler::expectEventScopeBool;
using test::events_scheduler::expectEventScopeInt;
using test::events_scheduler::expectEventScopeMissing;
using test::events_scheduler::expectScheduleRates;
using test::events_scheduler::expectSingleActiveEvent;

namespace {
	bool toLocalTime(std::time_t time, std::tm &out) {
#if defined(_WIN32) || defined(_WIN64)
		return localtime_s(&out, &time) == 0;
#else
		return localtime_r(&time, &out) != nullptr;
#endif
	}
} // namespace

class EventsSchedulerJsonTest : public EventsSchedulerTestBase {
protected:
	InjectionFixture fixture_ {};
};

TEST_F(EventsSchedulerJsonTest, LoadsRatesAndKeyValuesFromJson) {
	writeEventsJson(originalEventsJson_);
	ASSERT_TRUE(g_eventsScheduler().loadScheduleEventFromJson());

	expectScheduleRates(150, 200u, 125u, 175u, 130);

	expectEventScopeInt("forge-chance", 120);
	expectEventScopeInt("boss-cooldown", 150);
	expectEventScopeBool("double-bestiary", true);
	expectEventScopeBool("double-bosstiary", true);
	expectEventScopeBool("fast-exercise", true);

	expectSingleActiveEvent("Test Event Scheduler");
}

TEST_F(EventsSchedulerJsonTest, SkipsDuplicateRatesWhenEventsOverlap) {
	writeEventsJson(R"json({
	"events": [
		{
			"name": "Duplicate Event A",
			"startdate": "01/01/2000",
			"enddate": "12/31/2099",
			"ingame": {
				"exprate": 150
			}
		},
		{
			"name": "Duplicate Event B",
			"startdate": "01/01/2000",
			"enddate": "12/31/2099",
			"ingame": {
				"exprate": 150
			}
		}
	]
})json");

	ASSERT_TRUE(g_eventsScheduler().loadScheduleEventFromJson());

	expectScheduleRates(150, 100u, 100u, 100u, 100);

	expectActiveEventsContain({ "Duplicate Event A", "Duplicate Event B" });
}

TEST_F(EventsSchedulerJsonTest, ReloadingClearsPreviousModifiers) {
	writeEventsJson(R"json({
	"events": [
		{
			"name": "Initial Modifiers",
			"startdate": "01/01/2000",
			"enddate": "12/31/2099",
			"ingame": {
				"exprate": 125,
				"lootrate": 140,
				"bosslootrate": 150,
				"spawnrate": 160,
				"skillrate": 135,
				"forge-chance": 130,
				"doublebestiary": true,
				"doublebosstiary": true,
				"fastexercise": true,
				"bosscooldown": 140
			}
		}
	]
})json");

	ASSERT_TRUE(g_eventsScheduler().loadScheduleEventFromJson());

	expectScheduleRates(125, 140u, 150u, 160u, 135);

	expectEventScopeInt("forge-chance", 130);
	expectEventScopeBool("double-bestiary", true);
	expectEventScopeBool("double-bosstiary", true);
	expectEventScopeBool("fast-exercise", true);
	expectEventScopeInt("boss-cooldown", 140);

	writeEventsJson(R"json({
	"events": [
		{
			"name": "Reset Event",
			"startdate": "01/01/2000",
			"enddate": "12/31/2099"
		}
	]
})json");

	ASSERT_TRUE(g_eventsScheduler().loadScheduleEventFromJson());

	expectScheduleRates(100, 100u, 100u, 100u, 100);

	expectEventScopeMissing({ "forge-chance", "double-bestiary", "double-bosstiary", "fast-exercise", "boss-cooldown" });
}

TEST_F(EventsSchedulerJsonTest, RespectsEventHoursFromJson) {
	const auto now = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
	auto activeStartTs = now - 1800;
	auto activeEndTs = now + 1800;
	auto inactiveStartTs = now - 7200;
	auto inactiveEndTs = now - 1800;

	std::tm activeStartInfo {};
	ASSERT_TRUE(toLocalTime(activeStartTs, activeStartInfo));
	std::tm activeEndInfo {};
	ASSERT_TRUE(toLocalTime(activeEndTs, activeEndInfo));
	std::tm inactiveStartInfo {};
	ASSERT_TRUE(toLocalTime(inactiveStartTs, inactiveStartInfo));
	std::tm inactiveEndInfo {};
	ASSERT_TRUE(toLocalTime(inactiveEndTs, inactiveEndInfo));

	const auto formatDate = [](const std::tm &timeInfo) {
		std::ostringstream stream;
		stream << std::put_time(&timeInfo, "%m/%d/%Y");
		return stream.str();
	};

	const auto formatTime = [](const std::tm &timeInfo) {
		std::ostringstream stream;
		stream << std::put_time(&timeInfo, "%H:%M:%S");
		return stream.str();
	};

	std::ostringstream json;
	json << "{\n"
			"\t\"events\": [\n"
			"\t\t{\n"
			"\t\t\t\"name\": \"Active With Hours\",\n"
			"\t\t\t\"startdate\": \""
		 << formatDate(activeStartInfo) << "\",\n"
										   "\t\t\t\"enddate\": \""
		 << formatDate(activeEndInfo) << "\",\n"
										 "\t\t\t\"starthour\": \""
		 << formatTime(activeStartInfo) << "\",\n"
										   "\t\t\t\"endhour\": \""
		 << formatTime(activeEndInfo) << "\",\n"
										 "\t\t\t\"ingame\": {\n"
										 "\t\t\t\t\"exprate\": 160\n"
										 "\t\t\t}\n"
										 "\t\t},\n"
										 "\t\t{\n"
										 "\t\t\t\"name\": \"Expired With Hours\",\n"
										 "\t\t\t\"startdate\": \""
		 << formatDate(inactiveStartInfo) << "\",\n"
											 "\t\t\t\"enddate\": \""
		 << formatDate(inactiveEndInfo) << "\",\n"
										   "\t\t\t\"starthour\": \""
		 << formatTime(inactiveStartInfo) << "\",\n"
											 "\t\t\t\"endhour\": \""
		 << formatTime(inactiveEndInfo) << "\",\n"
										   "\t\t\t\"ingame\": {\n"
										   "\t\t\t\t\"exprate\": 180\n"
										   "\t\t\t}\n"
										   "\t\t}\n"
										   "\t]\n"
										   "}";

	writeEventsJson(json.str());

	ASSERT_TRUE(g_eventsScheduler().loadScheduleEventFromJson());

	expectScheduleRates(160, 100u, 100u, 100u, 100);

	expectSingleActiveEvent("Active With Hours");
	const auto activeEvents = g_eventsScheduler().getActiveEvents();
	EXPECT_EQ(activeEvents.end(), std::ranges::find(activeEvents, "Expired With Hours"));
}
