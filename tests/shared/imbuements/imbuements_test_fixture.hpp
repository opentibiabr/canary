#pragma once

#include <filesystem>
#include <string>

#include <gtest/gtest.h>

#include "config/configmanager.hpp"
#include "creatures/players/imbuements/imbuements.hpp"
#include "creatures/players/vocations/vocation.hpp"
#include "lib/di/container.hpp"
#include "lib/logging/in_memory_logger.hpp"

namespace test::imbuements {

	class ImbuementsTestBase : public ::testing::Test {
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
			(void)g_configManager().setConfigFileLua("tests/fixture/config/imbuements_test.lua");
			ASSERT_TRUE(g_configManager().reload());
			ASSERT_TRUE(g_vocations().reload());
			ASSERT_TRUE(g_imbuements().reload());
		}

		void TearDown() override {
			(void)g_configManager().setConfigFileLua(previousConfigFile_);
			(void)g_configManager().reload();
			(void)g_vocations().reload();
			(void)g_imbuements().reload();
			std::filesystem::current_path(previousPath_);
		}

	private:
		std::filesystem::path repoRoot_ {};
		std::filesystem::path previousPath_ {};
		std::string previousConfigFile_ {};

		inline static di::extension::injector<> injector_ {};
		inline static bool ownsContainer_ = false;

		[[nodiscard]] static std::filesystem::path detectRepoRoot(std::filesystem::path start) {
			const auto configPath = std::filesystem::path("tests/fixture/config/imbuements_test.lua");
			const auto imbuementsPath = std::filesystem::path("tests/fixture/core/XML/imbuements.xml");
			const auto vocationsPath = std::filesystem::path("tests/fixture/core/XML/vocations.xml");

			while (!start.empty()) {
				std::error_code configEc;
				const auto configExists = std::filesystem::exists(start / configPath, configEc);

				std::error_code xmlEc;
				const auto imbuementsExists = std::filesystem::exists(start / imbuementsPath, xmlEc);
				const auto vocationsExists = std::filesystem::exists(start / vocationsPath, xmlEc);

				if (!configEc && !xmlEc && configExists && imbuementsExists && vocationsExists) {
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

} // namespace test::imbuements
