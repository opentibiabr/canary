/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include <gtest/gtest.h>

#include "creatures/players/imbuements/imbuement_storage_policy.hpp"

TEST(ImbuementStoragePolicyTest, ReadsTheConfiguredStorageId) {
	uint32_t requestedStorage = 0;
	const bool hidden = ImbuementStoragePolicy::shouldHide(true, 30059, 3, [&requestedStorage](uint32_t storageId) {
		requestedStorage = storageId;
		return -1;
	});

	EXPECT_TRUE(hidden);
	EXPECT_EQ(30059, requestedStorage);
}

TEST(ImbuementStoragePolicyTest, ShowsUnlockedImbuements) {
	EXPECT_FALSE(ImbuementStoragePolicy::shouldHide(true, 30059, 3, [](uint32_t) {
		return 1;
	}));
}

TEST(ImbuementStoragePolicyTest, SkipsStorageReadsWhenFilteringDoesNotApply) {
	int reads = 0;
	auto readStorage = [&reads](uint32_t) {
		++reads;
		return -1;
	};

	EXPECT_FALSE(ImbuementStoragePolicy::shouldHide(false, 30059, 3, readStorage));
	EXPECT_FALSE(ImbuementStoragePolicy::shouldHide(true, 0, 3, readStorage));
	EXPECT_FALSE(ImbuementStoragePolicy::shouldHide(true, 30059, 4, readStorage));
	EXPECT_EQ(0, reads);
}
