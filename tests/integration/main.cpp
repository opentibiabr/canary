#include "config/configmanager.hpp"
#include "game/game.hpp"
#include "items/item.hpp"
#include "database/database.hpp"
#include "lib/di/container.hpp"
#include "lib/logging/in_memory_logger.hpp"
#include "kv/in_memory_kv.hpp"
#include "lua/test_lua_environment.hpp"
#include "test_database.hpp"

#include <cstdlib>
#include <filesystem>
#include <iostream>

namespace {
	bool fileExists(const std::filesystem::path &path) {
		std::error_code ec;
		return std::filesystem::exists(path, ec) && !ec;
	}

	std::filesystem::path detectRepoRoot(std::filesystem::path start) {
		while (!start.empty()) {
			const bool hasConfig = fileExists(start / "config.lua") || fileExists(start / "config.lua.dist");
			const bool hasItems = fileExists(start / "data/items/items.xml");
			if (hasConfig && hasItems) {
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

	std::string getGtestFilter(int argc, char** argv) {
		constexpr std::string_view key = "--gtest_filter=";
		for (int i = 1; i < argc; ++i) {
			if (argv[i] == nullptr) {
				continue;
			}
			const std::string_view arg { argv[i] };
			if (arg.rfind(key, 0) == 0) {
				return std::string { arg.substr(key.size()) };
			}
		}
		return {};
	}

	bool isDbOnlyFilter(const std::string &filter) {
		if (filter.empty()) {
			return false;
		}
		return filter.find("RepositoryDBTest") != std::string::npos
			|| filter.find("AccountRepositoryDBTest") != std::string::npos
			|| filter.find("PlayerStorageRepositoryDBTest") != std::string::npos;
	}

	std::string detectConfigFile(const std::filesystem::path &repoRoot) {
		if (fileExists(repoRoot / "config.lua")) {
			return "config.lua";
		}
		if (fileExists(repoRoot / "config.lua.dist")) {
			return "config.lua.dist";
		}
		return {};
	}
}

int main(int argc, char** argv) {
	const bool gtestListMode = isGtestListMode(argc, argv);
	const auto gtestFilter = getGtestFilter(argc, argv);
	const bool dbOnlyFilter = isDbOnlyFilter(gtestFilter);
	::testing::InitGoogleTest(&argc, argv);

	// gtest_discover_tests invokes the binary with --gtest_list_tests.
	// Keep discovery mode side-effect free.
	if (gtestListMode) {
		return RUN_ALL_TESTS();
	}
	std::fprintf(stderr, "[integration main] start\n");
	std::fflush(stderr);

	// Keep the test injector alive until process termination.
	// Some static/global teardown paths still resolve services through DI
	// (e.g. LuaEnvironment from Game/LuaScriptInterface destructors).
	// Destroying the injector during shutdown can invalidate its provider map
	// while those destructors are still running, causing exit-time crashes.
	static auto* injector = new di::extension::injector<>();
	InMemoryLogger::install(*injector);
	KVMemory::install(*injector);
	TestLuaEnvironment::install(*injector);
	DI::setTestContainer(injector);

	(void)g_logger();
	(void)g_game();
	(void)g_database();

	const auto previousPath = std::filesystem::current_path();
	const auto repoRoot = detectRepoRoot(previousPath);
	if (repoRoot.empty()) {
		std::fprintf(stderr, "[integration main] repo root not found from %s\n", previousPath.string().c_str());
		std::fflush(stderr);
		return EXIT_FAILURE;
	}
	std::filesystem::current_path(repoRoot);
	std::fprintf(stderr, "[integration main] repoRoot=%s\n", std::filesystem::current_path().string().c_str());
	std::fflush(stderr);

	auto &config = g_configManager();
	const auto configFile = detectConfigFile(std::filesystem::current_path());
	if (configFile.empty()) {
		std::fprintf(stderr, "[integration main] no config file found (expected config.lua or config.lua.dist)\n");
		std::fflush(stderr);
		return EXIT_FAILURE;
	}
	config.setConfigFileLua(configFile);
	std::fprintf(stderr, "[integration main] config file=%s\n", configFile.c_str());
	std::fflush(stderr);
	if (!config.reload()) {
		g_logger().error("[integration main] failed to reload {}", configFile);
		std::fprintf(stderr, "[integration main] failed to reload %s\n", configFile.c_str());
		std::fflush(stderr);
		return EXIT_FAILURE;
	}
	std::fprintf(stderr, "[integration main] config reload done\n");
	std::fflush(stderr);

	if (!dbOnlyFilter) {
		if (!g_game().groups.load()) {
			std::fprintf(stderr, "[integration main] failed to load groups\n");
			std::fflush(stderr);
			return EXIT_FAILURE;
		}

		const auto appearancePath = (std::filesystem::path(config.getString(CORE_DIRECTORY)) / "items/appearances.dat").lexically_normal().string();
		if (g_game().loadAppearanceProtobuf(appearancePath) != ERROR_NONE) {
			std::fprintf(stderr, "[integration main] failed to load appearances.dat from %s\n", appearancePath.c_str());
			std::fflush(stderr);
			return EXIT_FAILURE;
		}

		if (!Item::items.reload()) {
			std::fprintf(stderr, "[integration main] failed to reload items.xml\n");
			std::fflush(stderr);
			return EXIT_FAILURE;
		}
		std::fprintf(stderr, "[integration main] assets load done\n");
	} else {
		std::fprintf(stderr, "[integration main] db-only filter detected (%s), skipping asset bootstrap\n", gtestFilter.c_str());
	}
	std::fflush(stderr);

	try {
		std::fprintf(stderr, "[integration main] TestDatabase::init begin\n");
		std::fflush(stderr);
		TestDatabase::init();
		std::fprintf(stderr, "[integration main] TestDatabase::init done\n");
		std::fflush(stderr);
	} catch (const std::exception &e) {
		std::fprintf(stderr, "[integration main] TestDatabase::init failed: %s\n", e.what());
		std::fflush(stderr);
		return EXIT_FAILURE;
	}

	const auto result = RUN_ALL_TESTS();
	std::filesystem::current_path(previousPath);
	std::cout << std::flush;
	std::cerr << std::flush;
	std::fflush(nullptr);
	std::_Exit(result);
}
