#pragma once

#include "config/configmanager.hpp"
#include "game/scheduling/events_scheduler.hpp"
#include "kv/kv.hpp"
#include "kv/kv_definitions.hpp"

namespace test::events_scheduler {

	class EventsSchedulerTestBase : public ::testing::Test {
	protected:
		void SetUp() override {
			previousPath_ = std::filesystem::current_path();
			repoRoot_ = detectRepoRoot(std::filesystem::current_path());
			ASSERT_FALSE(repoRoot_.empty()) << "Could not locate repository root";
			std::filesystem::current_path(repoRoot_);

			fixtureEventsJsonPath_ = repoRoot_ / "tests/fixture/core/json/eventscheduler/events.json";
			eventsJsonPath_ = fixtureEventsJsonPath_;
			originalEventsJson_ = readEventsJson();

			const auto nowTicks = std::chrono::steady_clock::now().time_since_epoch().count();
			tempCoreDir_ = std::filesystem::temp_directory_path() / ("canary-events-scheduler-" + std::to_string(nowTicks));
			std::filesystem::create_directories(tempCoreDir_ / "json/eventscheduler");
			eventsJsonPath_ = tempCoreDir_ / "json/eventscheduler/events.json";
			writeEventsJson(originalEventsJson_);

			tempConfigFilePath_ = tempCoreDir_ / "events_scheduler_test.lua";
			{
				std::ofstream configFile(tempConfigFilePath_);
				ASSERT_TRUE(configFile.is_open());
				configFile << "coreDirectory = \"" << tempCoreDir_.generic_string() << "\"\n";
				configFile.flush();
			}

			previousConfigFile_ = g_configManager().getConfigFileLua();
			g_configManager().setConfigFileLua(tempConfigFilePath_.string());
			ASSERT_TRUE(g_configManager().reload());

			resetSchedulerState();
			onSetUp();
		}

		void TearDown() override {
			onTearDown();
			resetSchedulerState();
			g_configManager().setConfigFileLua(previousConfigFile_);
			std::error_code ec;
			std::filesystem::remove_all(tempCoreDir_, ec);
			std::filesystem::current_path(previousPath_);
		}

		virtual void onSetUp() { }
		virtual void onTearDown() { }

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

		[[nodiscard]] std::string readEventsJson() const {
			std::ifstream file(eventsJsonPath_);
			if (!file.is_open()) {
				ADD_FAILURE() << "Failed to open events fixture file: " << eventsJsonPath_;
				return {};
			}
			std::ostringstream buffer;
			buffer << file.rdbuf();
			return buffer.str();
		}

		void writeEventsJson(const std::string &content) const {
			std::ofstream file(eventsJsonPath_);
			ASSERT_TRUE(file.is_open());
			file << content;
			file.flush();
		}

		std::filesystem::path repoRoot_ {};
		std::filesystem::path previousPath_ {};
		std::filesystem::path fixtureEventsJsonPath_ {};
		std::filesystem::path eventsJsonPath_ {};
		std::filesystem::path tempCoreDir_ {};
		std::filesystem::path tempConfigFilePath_ {};
		std::string originalEventsJson_ {};
		std::string previousConfigFile_ {};

	private:
		[[nodiscard]] static std::filesystem::path detectRepoRoot(std::filesystem::path start) {
			const auto eventsRelative = std::filesystem::path("tests/fixture/core/json/eventscheduler/events.json");
			const auto configRelative = std::filesystem::path("tests/fixture/config/events_scheduler_test.lua");

			while (!start.empty()) {
				std::error_code eventsEc;
				const auto eventsExists = std::filesystem::exists(start / eventsRelative, eventsEc);

				std::error_code configEc;
				const auto configExists = std::filesystem::exists(start / configRelative, configEc);

				if (!eventsEc && !configEc && eventsExists && configExists) {
					return start;
				}

				if (!start.has_parent_path() || start.parent_path() == start) {
					break;
				}

				start = start.parent_path();
			}

			return {};
		}
	};

} // namespace test::events_scheduler
