#include "world/world_layers.hpp"
#include "world/world_validation.hpp"
#include "../../world_layers/map_fixture.hpp"
#include "../../world_layers/contract_v2.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <gtest/gtest.h>
#endif

namespace {
	world_layers::Project pilot() {
		world_layers::Project project;
		world_layers::Diagnostics diagnostics;
		const auto file = std::filesystem::path(TESTS_SOURCE_DIR) / "tests/world_layers/fixtures/world.world.json";
		EXPECT_TRUE(world_layers::loadProject(file, project, diagnostics));
		EXPECT_TRUE(diagnostics.empty());
		EXPECT_EQ(project.schemaVersion, 1);
		return project;
	}
}

TEST(WorldLayers, GeneralAuthoringContractPreservesSelectionAndInheritance) {
	std::filesystem::path scratch;
	const auto root = std::filesystem::path(TESTS_BINARY_DIR);
	ASSERT_TRUE(std::filesystem::create_directories(root) || std::filesystem::is_directory(root));
	for (unsigned index = 0; index < 10000; ++index) {
		const auto candidate = root / ("canary-world-v2-test-" + std::to_string(index));
		if (std::filesystem::create_directory(candidate)) {
			scratch = candidate;
			break;
		}
	}
	ASSERT_FALSE(scratch.empty());
	EXPECT_NO_THROW(runWorldV2Tests(scratch));
	std::error_code error;
	std::filesystem::remove_all(scratch, error);
}

TEST(WorldLayers, PreserveBlackKnightArrivalsAndFollowIdentity) {
	auto project = pilot();
	ASSERT_NE(project.find("black_knight.entry"), nullptr);
	ASSERT_NE(project.find("black_knight.exit"), nullptr);
	EXPECT_EQ(world_layers::destination(project, *project.find("black_knight.entry")), (world_layers::Position { 32874, 31948, 11 }));
	EXPECT_EQ(world_layers::destination(project, *project.find("black_knight.exit")), (world_layers::Position { 32874, 31942, 12 }));
	const auto original = project.find("black_knight.exit")->replaces;
	project.find("black_knight.exit")->position = { 32900, 32000, 10 };
	EXPECT_EQ(world_layers::destination(project, *project.find("black_knight.entry")), (world_layers::Position { 32900, 31993, 10 }));
	EXPECT_EQ(project.find("black_knight.exit")->replaces, original);
}

TEST(WorldLayers, AidCanRepeatButUidCannot) {
	auto project = pilot();
	auto* entry = project.find("black_knight.entry");
	auto* exit = project.find("black_knight.exit");
	ASSERT_NE(entry, nullptr);
	ASSERT_NE(exit, nullptr);
	entry->aid = exit->aid = 24873;
	world_layers::Diagnostics diagnostics;
	world_layers::validateProject(project, diagnostics);
	EXPECT_TRUE(diagnostics.empty());
	exit->uid = entry->uid;
	world_layers::validateProject(project, diagnostics);
	ASSERT_EQ(diagnostics.size(), 1);
	EXPECT_EQ(diagnostics.front().field, "/attributes/uid");
}

TEST(WorldLayers, RoundTripRetainsReplacementAndRelations) {
	auto project = pilot();
	ASSERT_EQ(project.layers.size(), 1);
	world_layers::Layer parsed;
	world_layers::Diagnostics diagnostics;
	ASSERT_TRUE(world_layers::parseLayer(world_layers::serializeLayer(project.layers.front()), "roundtrip.json", parsed, diagnostics));
	EXPECT_EQ(parsed.objects, project.layers.front().objects);
}

TEST(WorldLayers, RejectDuplicateJsonPropertiesAndUnknownComponents) {
	world_layers::Layer layer;
	world_layers::Diagnostics diagnostics;
	EXPECT_FALSE(world_layers::parseLayer(R"({"schemaVersion":1,"id":"first","id":"second","objects":[]})", "duplicate.json", layer, diagnostics));
	ASSERT_FALSE(diagnostics.empty());
	EXPECT_EQ(diagnostics.front().message, "Duplicate JSON property");
	diagnostics.clear();
	EXPECT_FALSE(world_layers::parseLayer(R"({"schemaVersion":3,"id":"future","objects":[]})", "future.json", layer, diagnostics));
	diagnostics.clear();
	EXPECT_FALSE(world_layers::parseLayer(R"({"schemaVersion":1,"id":"future","objects":[{"id":"entry","position":{"x":1,"y":1,"z":7},"origin":{"type":"layer","itemId":1949},"components":[{"type":"future"}]}]})", "future.json", layer, diagnostics));
}

TEST(WorldLayers, DiagnoseMissingReferencesAndArrivalOverflow) {
	auto project = pilot();
	auto* entry = project.find("black_knight.entry");
	ASSERT_NE(entry, nullptr);
	ASSERT_TRUE(entry->teleport.has_value());
	entry->teleport->destination = "missing.object";
	world_layers::Diagnostics diagnostics;
	world_layers::validateProject(project, diagnostics);
	ASSERT_EQ(diagnostics.size(), 1);
	EXPECT_EQ(diagnostics.front().field, "/components/destination");
	entry->teleport->destination = "black_knight.exit";
	entry->teleport->destinationOffset.z = -15;
	diagnostics.clear();
	world_layers::validateProject(project, diagnostics);
	ASSERT_EQ(diagnostics.size(), 1);
	EXPECT_EQ(diagnostics.front().field, "/components/destinationOffset");
}

TEST(WorldLayers, OnlyConsumedOriginalsMayKeepTheirUid) {
	auto project = pilot();
	WorldMapFixture map(project);
	world_layers::ApplicationPlan plan;
	world_layers::Diagnostics diagnostics;
	ASSERT_TRUE(world_layers::validateMap(project, map, plan, diagnostics));
	EXPECT_EQ(plan.originals.size(), 2);
	map.ids.push_back({ 38012, 999, { 100, 100, 7 } });
	diagnostics.clear();
	EXPECT_FALSE(world_layers::validateMap(project, map, plan, diagnostics));
	EXPECT_NE(diagnostics.back().message.find("UID 38012"), std::string::npos);
}

TEST(WorldLayers, RejectAmbiguousOriginalAndOccupiedOrMissingTile) {
	auto project = pilot();
	WorldMapFixture map(project);
	const auto* entry = project.find("black_knight.entry");
	ASSERT_NE(entry, nullptr);
	auto &tile = map.tiles[WorldMapFixture::key(entry->position)];
	tile.items.push_back({ 999, 1949, 0, true, {} });
	world_layers::ApplicationPlan plan;
	world_layers::Diagnostics diagnostics;
	EXPECT_FALSE(world_layers::validateMap(project, map, plan, diagnostics));
	EXPECT_TRUE(plan.objects.empty());
	tile.items.pop_back();
	tile.house = true;
	diagnostics.clear();
	EXPECT_FALSE(world_layers::validateMap(project, map, plan, diagnostics));
	tile.house = false;
	tile.ground = false;
	diagnostics.clear();
	EXPECT_FALSE(world_layers::validateMap(project, map, plan, diagnostics));
}

TEST(WorldLayers, RejectEffectiveTeleportCyclesIncludingBaseMap) {
	auto project = pilot();
	WorldMapFixture map(project);
	const auto entry = project.find("black_knight.entry");
	ASSERT_NE(entry, nullptr);
	const auto destination = world_layers::destination(project, *entry);
	ASSERT_TRUE(destination.has_value());
	const auto arrival = *destination;
	map.tiles[WorldMapFixture::key(arrival)].items.push_back({ 999, 1949, 0, true, entry->position });
	world_layers::ApplicationPlan plan;
	world_layers::Diagnostics diagnostics;
	EXPECT_FALSE(world_layers::validateMap(project, map, plan, diagnostics));
	EXPECT_TRUE(std::any_of(diagnostics.begin(), diagnostics.end(), [](const auto &error) { return error.message == "Effective teleport cycle"; }));
}

TEST(WorldLayers, RejectInvalidArrivalAfterFollowingBaseTeleport) {
	auto project = pilot();
	WorldMapFixture map(project);
	const auto* entry = project.find("black_knight.entry");
	ASSERT_NE(entry, nullptr);
	const auto arrival = world_layers::destination(project, *entry);
	ASSERT_TRUE(arrival.has_value());
	map.tiles[WorldMapFixture::key(*arrival)].items.push_back({ 999, 1949, 0, true, { 65000, 65000, 7 } });
	world_layers::ApplicationPlan plan;
	world_layers::Diagnostics diagnostics;
	EXPECT_FALSE(world_layers::validateMap(project, map, plan, diagnostics));
	EXPECT_TRUE(std::any_of(diagnostics.begin(), diagnostics.end(), [](const auto &error) { return error.message == "Arrival requires an existing, unblocked, non-house tile with ground"; }));
}
