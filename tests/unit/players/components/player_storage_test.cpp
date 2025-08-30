/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include <boost/ut.hpp>

#include "creatures/players/player.hpp"
#include "creatures/players/components/player_storage.hpp"
#include "creatures/appearance/outfit/outfit.hpp"
#include "creatures/players/grouping/familiars.hpp"
#include "utils/const.hpp"

using namespace boost::ut;

suite<"player_storage"> playerStorageTests = [] {
	test("add and get storage value") = [] {
		auto player = std::make_shared<Player>();
		auto &storage = player->storage();
		const uint32_t key = 50000;

		storage.add(key, 42, /*shouldStorageUpdate=*/true);

		expect(storage.has(key));
		expect(eq(storage.get(key), 42));
		expect(eq(storage.getStorageMap().size(), std::size_t { 1 }));
		expect(eq(storage.getModifiedKeys().count(key), std::size_t { 1 }));
	};

	test("remove storage value") = [] {
		auto player = std::make_shared<Player>();
		auto &storage = player->storage();
		const uint32_t key = 50001;

		storage.add(key, 7, /*shouldStorageUpdate=*/true);
		expect(storage.has(key));

		expect(storage.remove(key));
		expect(!storage.has(key));
		expect(eq(storage.getRemovedKeys().count(key), std::size_t { 1 }));
		expect(eq(storage.getModifiedKeys().count(key), std::size_t { 0 }));
	};

	test("pass-through range is persisted (mounts)") = [] {
		auto player = std::make_shared<Player>();
		auto &s = player->storage();
		const uint32_t key = PSTRG_MOUNTS_RANGE_START + 1;

		s.add(key, 123, /*shouldStorageUpdate=*/true);

		expect(s.has(key));
		expect(eq(s.get(key), 123));
		expect(eq(s.getModifiedKeys().count(key), std::size_t { 1 }));
	};

	test("pass-through range is persisted (wing/effect/aura/shader)") = [] {
		auto player = std::make_shared<Player>();
		auto &s = player->storage();

		const uint32_t keys[] = {
			PSTRG_WING_RANGE_START + 1,
			PSTRG_EFFECT_RANGE_START + 1,
			PSTRG_AURA_RANGE_START + 1,
			PSTRG_SHADER_RANGE_START + 1,
		};

		int v = 10;
		for (auto k : keys) {
			s.add(k, v++, /*shouldStorageUpdate=*/true);
			expect(s.has(k));
			expect(eq(s.get(k), v - 1));
			expect(eq(s.getModifiedKeys().count(k), std::size_t { 1 }));
		}
	};

	test("outfits side-effect only via public API (canWear)") = [] {
		auto player = std::make_shared<Player>();
		auto &s = player->storage();

		const auto beforeOutfits = player->getOutfits().size();
		const uint32_t key = PSTRG_OUTFITS_RANGE_START + 1;
		const uint32_t lookType = 50u;
		const uint8_t addons = 3u;

		s.add(key, (lookType << 16) | addons, /*shouldStorageUpdate=*/true);
		expect(eq(player->getOutfits().size(), beforeOutfits + 1));
		const auto &os = player->getOutfits();
		auto it = std::find_if(os.begin(), os.end(), [&](const auto &e) { return e.lookType == lookType; });
		expect(it != os.end());
		expect((it->addons & addons) == addons);
	};

	test("familiars side-effect does not persist storage entry") = [] {
		auto player = std::make_shared<Player>();
		auto &s = player->storage();

		const auto before = player->getFamiliars().size();
		const uint32_t key = PSTRG_FAMILIARS_RANGE_START + 1;
		const uint32_t lookType = 77u;

		s.add(key, (lookType << 16), /*shouldStorageUpdate=*/true);

		expect(eq(player->getFamiliars().size(), before + 1));
		expect(eq(s.getStorageMap().size(), std::size_t { 0 }));
	};

	test("unknown reserved key persists and does not block flow") = [] {
		auto player = std::make_shared<Player>();
		auto &s = player->storage();

		const uint32_t key = PSTRG_RESERVED_RANGE_START + 900000u;

		s.add(key, 321, /*shouldStorageUpdate=*/true);

		expect(s.has(key));
		expect(eq(s.get(key), 321));
	};

	test("get returns -1 for missing key") = [] {
		auto player = std::make_shared<Player>();
		auto &s = player->storage();

		expect(eq(s.get(999999u), -1));
		expect(!s.has(999999u));
	};
};
