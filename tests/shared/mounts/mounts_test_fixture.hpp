/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <filesystem>

#include "config/configmanager.hpp"
#include "lib/di/container.hpp"
#include "lib/logging/in_memory_logger.hpp"

namespace test::mounts {

	class MountsTestBase : public ::testing::Test {
	protected:
		static void SetUpTestSuite() {
			if (DI::getTestContainer() == nullptr) {
				InMemoryLogger::install(injector_);
				DI::setTestContainer(&injector_);
				ownsContainer_ = true;
			}
		}

		static void TearDownTestSuite() {
			if (ownsContainer_ && DI::getTestContainer() == &injector_) {
				DI::setTestContainer(nullptr);
			}
		}

		void SetUp() override {
			previousPath_ = std::filesystem::current_path();
			repoRoot_ = detectRepoRoot(previousPath_);
			ASSERT_FALSE(repoRoot_.empty()) << "Could not locate repository root";
			std::filesystem::current_path(repoRoot_);

			previousConfigFile_ = g_configManager().getConfigFileLua();
			(void)g_configManager().setConfigFileLua("tests/fixture/config/mounts_test.lua");
			ASSERT_TRUE(g_configManager().reload());
		}

		void TearDown() override {
			// Best-effort restore — `previousConfigFile_` is the production
			// config path (usually `config.lua`), which does not exist in
			// the unit-test working directory. Reload() will fail here and
			// that's fine: the test's SetUp re-establishes the fixture
			// config for each test, so leakage between tests is bounded.
			// Asserting the reload would turn a known best-effort path
			// into a false failure across the whole suite.
			(void)g_configManager().setConfigFileLua(previousConfigFile_);
			(void)g_configManager().reload();
			std::filesystem::current_path(previousPath_);
		}

	private:
		std::filesystem::path repoRoot_ {};
		std::filesystem::path previousPath_ {};
		std::string previousConfigFile_ {};

		inline static di::extension::injector<> injector_ {};
		inline static bool ownsContainer_ = false;

		[[nodiscard]] static std::filesystem::path detectRepoRoot(std::filesystem::path start) {
			const auto configPath = std::filesystem::path("tests/fixture/config/mounts_test.lua");
			const auto mountsPath = std::filesystem::path("tests/fixture/core/XML/mounts.xml");

			while (!start.empty()) {
				std::error_code ec1;
				std::error_code ec2;
				const auto configExists = std::filesystem::exists(start / configPath, ec1);
				const auto mountsExists = std::filesystem::exists(start / mountsPath, ec2);

				if (!ec1 && !ec2 && configExists && mountsExists) {
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

} // namespace test::mounts
