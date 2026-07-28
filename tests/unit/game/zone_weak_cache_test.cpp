/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/zones/zone.hpp"

TEST(ZoneWeakCacheTest, RemovesExpiredOwnersWithoutChangingKeyOrdering) {
	weak::set<int> cache;
	auto expiredOwner = std::make_shared<int>(1);
	cache.insert(expiredOwner);
	expiredOwner.reset();

	auto liveOwner = std::make_shared<int>(2);
	cache.insert(liveOwner);

	const auto locked = weak::lock(cache);
	ASSERT_EQ(locked.size(), 1);
	EXPECT_EQ(locked.front(), liveOwner);
	EXPECT_EQ(cache.size(), 1);
}
