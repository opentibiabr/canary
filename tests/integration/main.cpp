#include "config/configmanager.hpp"
#include "game/game.hpp"
#include "items/item.hpp"
#include "database/database.hpp"
#include "lib/di/container.hpp"
#include "lib/logging/in_memory_logger.hpp"
#include "kv/in_memory_kv.hpp"
#include "lua/test_lua_environment.hpp"
#include "test_database.hpp"

#include <filesystem>

namespace {
	std::filesystem::path detectRepoRoot(std::filesystem::path start) {
		while (!start.empty()) {
			std::error_code ec1;
			std::error_code ec2;
			const bool hasConfig = std::filesystem::exists(start / "config.lua", ec1);
			const bool hasItems = std::filesystem::exists(start / "data/items/items.xml", ec2);
			if (!ec1 && !ec2 && hasConfig && hasItems) {
				return start;
			}
			if (!start.has_parent_path() || start.parent_path() == start) {
				break;
			}
			start = start.parent_path();
		}
		return {};
	}

	bool isGtestListMode(int argc, char** argv) {
		for (int i = 1; i < argc; ++i) {
			if (argv[i] != nullptr && std::string_view(argv[i]) == "--gtest_list_tests") {
				return true;
			}
		}
		return false;
	}
}

int main(int argc, char** argv) {
	::testing::InitGoogleTest(&argc, argv);

	static auto injector = std::make_unique<di::extension::injector<>>();
	InMemoryLogger::install(*injector);
	KVMemory::install(*injector);
	TestLuaEnvironment::install(*injector);
	DI::setTestContainer(injector.get());

	// gtest_discover_tests invokes the binary with --gtest_list_tests.
	// Keep discovery mode side-effect free: no DB bootstrap, no config reloads.
	if (isGtestListMode(argc, argv)) {
		const auto result = RUN_ALL_TESTS();
		DI::setTestContainer(nullptr);
		return result;
	}

	TestDatabase::init();
	(void)g_logger();
	(void)g_game();
	(void)g_database();

	const auto previousPath = std::filesystem::current_path();
	const auto repoRoot = detectRepoRoot(previousPath);
	if (!repoRoot.empty()) {
		std::filesystem::current_path(repoRoot);
	}

	auto &config = g_configManager();
	config.setConfigFileLua("config.lua");
	if (!config.reload()) {
		g_logger().error("[integration main] failed to reload config.lua");
	}

	if (!g_game().groups.load()) {
		g_logger().warn("[integration main] failed to load groups");
	}

	const auto appearancePath = (std::filesystem::path(config.getString(CORE_DIRECTORY)) / "items/appearances.dat").lexically_normal().string();
	if (g_game().loadAppearanceProtobuf(appearancePath) != ERROR_NONE) {
		g_logger().warn("[integration main] failed to load appearances.dat from {}", appearancePath);
	}

	if (!Item::items.reload()) {
		g_logger().warn("[integration main] failed to reload items.xml");
	}

	const auto result = RUN_ALL_TESTS();
	std::filesystem::current_path(previousPath);
	DI::setTestContainer(nullptr);
	return result;
}
