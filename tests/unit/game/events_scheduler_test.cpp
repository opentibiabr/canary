#include "pch.hpp"

#include <gtest/gtest.h>

#include "config/configmanager.hpp"
#include "game/scheduling/events_scheduler.hpp"
#include "injection_fixture.hpp"
#include "kv/kv.hpp"
#include "kv/kv_definitions.hpp"

class EventsSchedulerJsonTest : public ::testing::Test {
protected:
	void SetUp() override {
		previousPath_ = std::filesystem::current_path();
		const auto sourceDir = std::filesystem::path(__FILE__).parent_path();
		const auto repoRoot = sourceDir.parent_path().parent_path().parent_path();
		std::filesystem::current_path(repoRoot);

		eventsJsonPath_ = repoRoot / "tests/fixture/core/json/eventscheduler/events.json";
		originalEventsJson_ = readEventsJson();

		previousConfigFile_ = g_configManager().getConfigFileLua();
		g_configManager().setConfigFileLua("tests/fixture/config/events_scheduler_test.lua");
		ASSERT_TRUE(g_configManager().reload());

		g_eventsScheduler().reset();
		g_kv().flush();
	}

	void TearDown() override {
		g_eventsScheduler().reset();
		g_kv().flush();
		writeEventsJson(originalEventsJson_);
		g_configManager().setConfigFileLua(previousConfigFile_);
		std::filesystem::current_path(previousPath_);
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

	InjectionFixture fixture_ {};
	std::filesystem::path previousPath_ {};
	std::string previousConfigFile_ {};
	std::filesystem::path eventsJsonPath_ {};
	std::string originalEventsJson_ {};
};

TEST_F(EventsSchedulerJsonTest, LoadsRatesAndKeyValuesFromJson) {
	writeEventsJson(originalEventsJson_);
	ASSERT_TRUE(g_eventsScheduler().loadScheduleEventFromJson());

	EXPECT_EQ(150, g_eventsScheduler().getExpSchedule());
	EXPECT_EQ(200u, g_eventsScheduler().getLootSchedule());
	EXPECT_EQ(125u, g_eventsScheduler().getBossLootSchedule());
	EXPECT_EQ(175u, g_eventsScheduler().getSpawnMonsterSchedule());
	EXPECT_EQ(130, g_eventsScheduler().getSkillSchedule());

	const auto forgeChance = g_kv().scoped("eventscheduler")->get("forge-chance");
	ASSERT_TRUE(forgeChance.has_value());
	EXPECT_EQ(20, forgeChance->get<IntType>());

	const auto bossCooldown = g_kv().scoped("eventscheduler")->get("boss-cooldown");
	ASSERT_TRUE(bossCooldown.has_value());
	EXPECT_EQ(50, bossCooldown->get<IntType>());

	const auto doubleBestiary = g_kv().scoped("eventscheduler")->get("double-bestiary");
	ASSERT_TRUE(doubleBestiary.has_value());
	EXPECT_TRUE(doubleBestiary->get<BooleanType>());

	const auto doubleBosstiary = g_kv().scoped("eventscheduler")->get("double-bosstiary");
	ASSERT_TRUE(doubleBosstiary.has_value());
	EXPECT_TRUE(doubleBosstiary->get<BooleanType>());

	const auto fastExercise = g_kv().scoped("eventscheduler")->get("fast-exercise");
	ASSERT_TRUE(fastExercise.has_value());
	EXPECT_TRUE(fastExercise->get<BooleanType>());

	const auto activeEvents = g_eventsScheduler().getActiveEvents();
	ASSERT_FALSE(activeEvents.empty());
	EXPECT_EQ("Test Event Scheduler", activeEvents.front());
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

	EXPECT_EQ(150, g_eventsScheduler().getExpSchedule());
	EXPECT_EQ(100u, g_eventsScheduler().getLootSchedule());
	EXPECT_EQ(100u, g_eventsScheduler().getBossLootSchedule());
	EXPECT_EQ(100u, g_eventsScheduler().getSpawnMonsterSchedule());
	EXPECT_EQ(100, g_eventsScheduler().getSkillSchedule());

	const auto activeEvents = g_eventsScheduler().getActiveEvents();
	EXPECT_EQ(2u, activeEvents.size());
	EXPECT_NE(activeEvents.end(), std::find(activeEvents.begin(), activeEvents.end(), "Duplicate Event A"));
	EXPECT_NE(activeEvents.end(), std::find(activeEvents.begin(), activeEvents.end(), "Duplicate Event B"));
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

	EXPECT_EQ(125, g_eventsScheduler().getExpSchedule());
	EXPECT_EQ(140u, g_eventsScheduler().getLootSchedule());
	EXPECT_EQ(150u, g_eventsScheduler().getBossLootSchedule());
	EXPECT_EQ(160u, g_eventsScheduler().getSpawnMonsterSchedule());
	EXPECT_EQ(135, g_eventsScheduler().getSkillSchedule());

	auto eventScope = g_kv().scoped("eventscheduler");
	const auto forgeChance = eventScope->get("forge-chance");
	ASSERT_TRUE(forgeChance.has_value());
	EXPECT_EQ(30, forgeChance->get<IntType>());
	EXPECT_TRUE(eventScope->get("double-bestiary")->get<BooleanType>());
	EXPECT_TRUE(eventScope->get("double-bosstiary")->get<BooleanType>());
	EXPECT_TRUE(eventScope->get("fast-exercise")->get<BooleanType>());
	EXPECT_EQ(40, eventScope->get("boss-cooldown")->get<IntType>());

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

	EXPECT_EQ(100, g_eventsScheduler().getExpSchedule());
	EXPECT_EQ(100u, g_eventsScheduler().getLootSchedule());
	EXPECT_EQ(100u, g_eventsScheduler().getBossLootSchedule());
	EXPECT_EQ(100u, g_eventsScheduler().getSpawnMonsterSchedule());
	EXPECT_EQ(100, g_eventsScheduler().getSkillSchedule());

	auto resetScope = g_kv().scoped("eventscheduler");
	EXPECT_FALSE(resetScope->get("forge-chance").has_value());
	EXPECT_FALSE(resetScope->get("double-bestiary").has_value());
	EXPECT_FALSE(resetScope->get("double-bosstiary").has_value());
	EXPECT_FALSE(resetScope->get("fast-exercise").has_value());
	EXPECT_FALSE(resetScope->get("boss-cooldown").has_value());
}

TEST_F(EventsSchedulerJsonTest, RespectsEventHoursFromJson) {
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

	EXPECT_EQ(160, g_eventsScheduler().getExpSchedule());
	EXPECT_EQ(100u, g_eventsScheduler().getLootSchedule());

	const auto activeEvents = g_eventsScheduler().getActiveEvents();
	ASSERT_EQ(1u, activeEvents.size());
	EXPECT_EQ("Active With Hours", activeEvents.front());
	EXPECT_EQ(activeEvents.end(), std::find(activeEvents.begin(), activeEvents.end(), "Expired With Hours"));
}
