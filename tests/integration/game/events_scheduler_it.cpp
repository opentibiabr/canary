#include <gtest/gtest.h>

#include "config/configmanager.hpp"
#include "game/scheduling/events_scheduler.hpp"
#include "kv/kv.hpp"
#include "kv/kv_definitions.hpp"
#include "../../shared/game/events_scheduler_test_helpers.hpp"

#include <algorithm>
#include <ctime>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <sstream>
#include <string>
#include <vector>

namespace it_events_scheduler {

	using test::events_scheduler::expectActiveEventsContain;
	using test::events_scheduler::expectEventScopeBool;
	using test::events_scheduler::expectEventScopeInt;
	using test::events_scheduler::expectEventScopeMissing;
	using test::events_scheduler::expectScheduleRates;
	using test::events_scheduler::expectSingleActiveEvent;

	class EventsSchedulerIntegrationTest : public ::testing::Test {
	protected:
		void SetUp() override {
			previousPath_ = std::filesystem::current_path();
			const auto sourceDir = std::filesystem::path(__FILE__).parent_path();
			repoRoot_ = sourceDir.parent_path().parent_path().parent_path();
			std::filesystem::current_path(repoRoot_);
			eventsJsonPath_ = repoRoot_ / "tests/fixture/core/json/eventscheduler/events.json";
			originalEventsJson_ = readEventsJson();
			previousConfigFile_ = g_configManager().getConfigFileLua();
			g_configManager().setConfigFileLua("tests/fixture/config/events_scheduler_test.lua");
			ASSERT_TRUE(g_configManager().reload());
			resetSchedulerState();
		}

		void TearDown() override {
			resetSchedulerState();
			writeEventsJson(originalEventsJson_);
			g_configManager().setConfigFileLua(previousConfigFile_);
			std::filesystem::current_path(previousPath_);
		}

		void resetSchedulerState() const {
			g_eventsScheduler().reset();
			clearEventKeyValues();
			g_kv().flush();
		}

		void clearEventKeyValues() const {
			auto scope = g_kv().scoped("eventscheduler");
			scope->remove("forge-chance");
			scope->remove("double-bestiary");
			scope->remove("double-bosstiary");
			scope->remove("fast-exercise");
			scope->remove("boss-cooldown");
		}

		std::string readEventsJson() const {
			std::ifstream file(eventsJsonPath_);
			EXPECT_TRUE(file.is_open());
			std::ostringstream buffer;
			buffer << file.rdbuf();
			return buffer.str();
		}

		void writeEventsJson(const std::string &content) const {
			std::ofstream file(eventsJsonPath_);
			EXPECT_TRUE(file.is_open());
			file << content;
			file.flush();
		}

		std::filesystem::path repoRoot_ {};
		std::filesystem::path previousPath_ {};
		std::filesystem::path eventsJsonPath_ {};
		std::string originalEventsJson_ {};
		std::string previousConfigFile_ {};
	};

	TEST_F(EventsSchedulerIntegrationTest, LoadsBonusesFromDefaultFixture) {
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

	TEST_F(EventsSchedulerIntegrationTest, AppliesModifiersFromMultipleActiveEvents) {
		writeEventsJson(R"json({
		"events": [
			{
				"name": "Rates Booster",
				"startdate": "01/01/2000",
				"enddate": "12/31/2099",
				"ingame": {
					"exprate": 150,
					"lootrate": 120,
					"bosslootrate": 130,
					"spawnrate": 140,
					"skillrate": 160,
					"forge-chance": 135,
					"bosscooldown": 90,
					"doublebestiary": true,
					"doublebosstiary": true,
					"fastexercise": true
				}
			},
			{
				"name": "Stacking Booster",
				"startdate": "01/01/2000",
				"enddate": "12/31/2099",
				"ingame": {
					"exprate": 200,
					"lootrate": 110,
					"bosslootrate": 140,
					"spawnrate": 150,
					"skillrate": 120,
					"forgechance": 145,
					"bosscooldown": 80,
					"doublebosstiary": true,
					"doubleexercise": true
				}
			},
			{
				"name": "Partial Booster",
				"startdate": "01/01/2000",
				"enddate": "12/31/2099",
				"ingame": {
					"lootrate": 150,
					"spawnrate": 110,
					"doublebestiary": true
				}
			}
		]
})json");

		ASSERT_TRUE(g_eventsScheduler().loadScheduleEventFromJson());

		expectScheduleRates(300, 198u, 182u, 231u, 192);

		expectEventScopeInt("forge-chance", 145);
		expectEventScopeInt("boss-cooldown", 80);
		expectEventScopeBool("double-bestiary", true);
		expectEventScopeBool("double-bosstiary", true);
		expectEventScopeBool("fast-exercise", true);

		expectActiveEventsContain({ "Rates Booster", "Stacking Booster", "Partial Booster" });
	}

	TEST_F(EventsSchedulerIntegrationTest, SkipsEventsOutsideConfiguredWindow) {
		auto now = std::time(nullptr);
		auto activeStartTs = now - 1800;
		auto activeEndTs = now + 1800;
		auto inactiveStartTs = now - 7200;
		auto inactiveEndTs = now - 1800;

		const auto* activeStartInfoPtr = std::localtime(&activeStartTs);
		ASSERT_NE(activeStartInfoPtr, nullptr);
		const auto activeStartInfo = *activeStartInfoPtr;
		const auto* activeEndInfoPtr = std::localtime(&activeEndTs);
		ASSERT_NE(activeEndInfoPtr, nullptr);
		const auto activeEndInfo = *activeEndInfoPtr;
		const auto* inactiveStartInfoPtr = std::localtime(&inactiveStartTs);
		ASSERT_NE(inactiveStartInfoPtr, nullptr);
		const auto inactiveStartInfo = *inactiveStartInfoPtr;
		const auto* inactiveEndInfoPtr = std::localtime(&inactiveEndTs);
		ASSERT_NE(inactiveEndInfoPtr, nullptr);
		const auto inactiveEndInfo = *inactiveEndInfoPtr;

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
			 << "\t\"events\": [\n"
			 << "\t\t{\n"
			 << "\t\t\t\"name\": \"Active With Hours\",\n"
			 << "\t\t\t\"startdate\": \"" << formatDate(activeStartInfo) << "\",\n"
			 << "\t\t\t\"enddate\": \"" << formatDate(activeEndInfo) << "\",\n"
			 << "\t\t\t\"starthour\": \"" << formatTime(activeStartInfo) << "\",\n"
			 << "\t\t\t\"endhour\": \"" << formatTime(activeEndInfo) << "\",\n"
			 << "\t\t\t\"ingame\": {\n"
			 << "\t\t\t\t\"exprate\": 160\n"
			 << "\t\t\t}\n"
			 << "\t\t},\n"
			 << "\t\t{\n"
			 << "\t\t\t\"name\": \"Expired With Hours\",\n"
			 << "\t\t\t\"startdate\": \"" << formatDate(inactiveStartInfo) << "\",\n"
			 << "\t\t\t\"enddate\": \"" << formatDate(inactiveEndInfo) << "\",\n"
			 << "\t\t\t\"starthour\": \"" << formatTime(inactiveStartInfo) << "\",\n"
			 << "\t\t\t\"endhour\": \"" << formatTime(inactiveEndInfo) << "\",\n"
			 << "\t\t\t\"ingame\": {\n"
			 << "\t\t\t\t\"exprate\": 180\n"
			 << "\t\t\t}\n"
			 << "\t\t}\n"
			 << "\t]\n"
			 << "}";

		writeEventsJson(json.str());

		ASSERT_TRUE(g_eventsScheduler().loadScheduleEventFromJson());

		expectScheduleRates(160, 100u, 100u, 100u, 100);

		expectSingleActiveEvent("Active With Hours");
		const auto activeEvents = g_eventsScheduler().getActiveEvents();
		EXPECT_EQ(activeEvents.end(), std::find(activeEvents.begin(), activeEvents.end(), "Expired With Hours"));
	}

	TEST_F(EventsSchedulerIntegrationTest, ReloadingClearsPreviousModifiers) {
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

} // namespace it_events_scheduler
