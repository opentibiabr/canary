#include "io/iomap.hpp"
#include "map/map.hpp"

#include <gtest/gtest.h>

#include <algorithm>
#include <chrono>
#include <cstdlib>
#include <filesystem>
#include <string>

#ifndef CANARY_TEST_PYTHON_EXECUTABLE
	#define CANARY_TEST_PYTHON_EXECUTABLE "python3"
#endif

namespace {
	class TemporaryDirectory final {
	public:
		TemporaryDirectory() {
			const auto suffix = std::chrono::steady_clock::now().time_since_epoch().count();
			path = std::filesystem::temp_directory_path() / ("canary-otbm-loader-" + std::to_string(suffix));
			std::filesystem::create_directories(path);
		}

		~TemporaryDirectory() {
			std::error_code error;
			std::filesystem::remove_all(path, error);
		}

		TemporaryDirectory(const TemporaryDirectory &) = delete;
		TemporaryDirectory &operator=(const TemporaryDirectory &) = delete;

		std::filesystem::path path;
	};

	std::string shellQuote(const std::filesystem::path &value) {
#ifdef _WIN32
		std::string quoted = "\"";
		for (const char character : value.string()) {
			if (character == '\"') {
				quoted += "\\\"";
			} else {
				quoted += character;
			}
		}
		quoted += "\"";
		return quoted;
#else
		std::string quoted = "'";
		for (const char character : value.string()) {
			if (character == '\'') {
				quoted += "'\\''";
			} else {
				quoted += character;
			}
		}
		quoted += "'";
		return quoted;
#endif
	}
}

TEST(OTBMLoaderIntegrationTest, LoadsMapWrittenByPythonPatcherAndCompanionFiles) {
	TemporaryDirectory temporaryDirectory;
	const auto fixtureScript = std::filesystem::path(TESTS_SOURCE_DIR) / "tests/fixture/generate_otbm_loader_fixture.py";
	const auto pythonExecutable = std::filesystem::path(CANARY_TEST_PYTHON_EXECUTABLE);
	const std::string command = shellQuote(pythonExecutable) + " " + shellQuote(fixtureScript) + " --output-dir " + shellQuote(temporaryDirectory.path);

	ASSERT_EQ(std::system(command.c_str()), 0) << "Fixture generator failed: " << command;

	const auto editedMap = temporaryDirectory.path / "edited.otbm";
	ASSERT_TRUE(std::filesystem::is_regular_file(editedMap));
	ASSERT_TRUE(std::filesystem::is_regular_file(temporaryDirectory.path / "manifest.json"));

	Map map;
	map.load(editedMap.string());

	const auto patchedTile = map.getTile(Position(300, 600, 7));
	ASSERT_NE(patchedTile, nullptr) << "Canary did not materialize the patched tile";

	const auto town = map.towns.getTown(1);
	ASSERT_NE(town, nullptr);
	EXPECT_EQ(town->getName(), "Loader Smoke Town");
	EXPECT_EQ(town->getTemplePosition(), Position(300, 600, 7));

	const auto waypoint = map.waypoints.find("patch destination");
	ASSERT_NE(waypoint, map.waypoints.end());
	EXPECT_EQ(waypoint->second, Position(300, 600, 7));

	ASSERT_TRUE(IOMap::loadMonsters(&map));
	ASSERT_TRUE(IOMap::loadNpcs(&map));
	ASSERT_TRUE(IOMap::loadHouses(&map));
	ASSERT_TRUE(IOMap::loadZones(&map));

	EXPECT_EQ(map.spawnsMonster.getspawnMonsterList().size(), 1);
	EXPECT_EQ(map.spawnsNpc.getSpawnNpcList().size(), 1);

	const auto house = map.houses.getHouse(7);
	ASSERT_NE(house, nullptr);
	EXPECT_EQ(house->getName(), "Loader Smoke House");
	EXPECT_EQ(house->getEntryPosition(), Position(301, 601, 7));
	EXPECT_EQ(house->getTownId(), 1);

	const auto zone = Zone::getZone(9);
	ASSERT_NE(zone, nullptr);
	EXPECT_EQ(zone->getName(), "loader-smoke-zone");
	const auto positions = zone->getPositions();
	EXPECT_NE(std::ranges::find(positions, Position(300, 600, 7)), positions.end());
}
