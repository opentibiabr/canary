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

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <ranges>
#endif

#include "creatures/players/player.hpp"
#include "creatures/players/components/player_storage.hpp"
#include "creatures/appearance/outfit/outfit.hpp"
#include "creatures/players/grouping/familiars.hpp"
#include "utils/const.hpp"

#include "injection_fixture.hpp"

using namespace boost::ut;

static void reg_add_and_get_storage_value() {
	test("add and get storage value") = [] {
		auto player = std::make_shared<Player>();
		auto &storage = player->storage();
		const uint32_t key = 50000;

		storage.ingest({});
		storage.add(key, 42, /*shouldStorageUpdate=*/true);

		expect(storage.has(key));
		expect(eq(storage.get(key), 42));
		expect(eq(storage.getStorageMap().size(), std::size_t { 1 }));
		auto d = storage.delta();
		expect(eq(d.upserts.size(), std::size_t { 1 }));
		expect(eq(d.upserts.at(key), 42));
		storage.clearDirty();
	};
}

static void reg_remove_storage_value() {
	test("remove storage value") = [] {
		auto player = std::make_shared<Player>();
		auto &storage = player->storage();
		const uint32_t key = 50001;

		storage.ingest({});
		storage.add(key, 7, /*shouldStorageUpdate=*/true);
		expect(storage.has(key));

		expect(storage.remove(key));
		expect(!storage.has(key));
		auto d = storage.delta();
		expect(eq(d.deletions.size(), std::size_t { 1 }));
		expect(std::ranges::find(d.deletions, key) != d.deletions.end());
		storage.clearDirty();
	};
}

static void reg_passthrough_mounts() {
	test("pass-through range is persisted (mounts)") = [] {
		auto player = std::make_shared<Player>();
		auto &storage = player->storage();
		const uint32_t key = PSTRG_MOUNTS_RANGE_START + 1;

		storage.ingest({});
		storage.add(key, 123, /*shouldStorageUpdate=*/true);

		expect(storage.has(key));
		expect(eq(storage.get(key), 123));
		expect(eq(storage.getModifiedKeys().count(key), std::size_t { 1 }));
	};
}

static void reg_passthrough_wing_effect_aura_shader() {
	test("pass-through range is persisted (wing/effect/aura/shader)") = [] {
		auto player = std::make_shared<Player>();
		auto &storage = player->storage();

		storage.ingest({});
		constexpr std::array<uint32_t, 4> keys {
			PSTRG_WING_RANGE_START + 1,
			PSTRG_EFFECT_RANGE_START + 1,
			PSTRG_AURA_RANGE_START + 1,
			PSTRG_SHADER_RANGE_START + 1,
		};

		int v = 10;
		for (auto k : keys) {
			storage.add(k, v, /*shouldStorageUpdate=*/true);
			v++;
			expect(storage.has(k));
			expect(eq(storage.get(k), v - 1));
			expect(eq(storage.getModifiedKeys().count(k), std::size_t { 1 }));
		}
	};
}

static void reg_outfits_side_effect() {
	test("outfits side-effect only via public API") = [] {
		auto player = std::make_shared<Player>();
		auto &storage = player->storage();

		storage.ingest({});
		const auto beforeOutfits = player->getOutfits().size();
		const uint32_t key = PSTRG_OUTFITS_RANGE_START + 1;
		const uint32_t lookType = 50u;
		const uint8_t addons = 3u;

		storage.add(key, (lookType << 16) | addons, /*shouldStorageUpdate=*/true);
		expect(eq(player->getOutfits().size(), beforeOutfits + 1));
		const auto &os = player->getOutfits();
		auto it = std::ranges::find_if(os, [&](const auto &e) { return e.lookType == lookType; });
		expect(it != os.end());
		expect((it->addons & addons) == addons);
	};
}

static void reg_familiars_side_effect() {
	test("familiars side-effect does not persist storage entry") = [] {
		auto player = std::make_shared<Player>();
		auto &storage = player->storage();

		storage.ingest({});
		const auto before = player->getFamiliars().size();
		const uint32_t key = PSTRG_FAMILIARS_RANGE_START + 1;
		const uint32_t lookType = 77u;

		storage.add(key, (lookType << 16), /*shouldStorageUpdate=*/true);

		expect(eq(player->getFamiliars().size(), before + 1));
		expect(eq(storage.getStorageMap().size(), std::size_t { 0 }));
	};
}

static void reg_unknown_reserved_key() {
	test("unknown reserved key persists and does not block flow") = [] {
		auto player = std::make_shared<Player>();
		auto &storage = player->storage();

		storage.ingest({});
		const uint32_t key = PSTRG_RESERVED_RANGE_START + 900000u;

		storage.add(key, 321, /*shouldStorageUpdate=*/true);

		expect(storage.has(key));
		expect(eq(storage.get(key), 321));
	};
}

static void reg_get_missing_key() {
	test("get returns -1 for missing key") = [] {
		auto player = std::make_shared<Player>();
		auto &storage = player->storage();

		storage.ingest({});
		expect(eq(storage.get(999999u), -1));
		expect(!storage.has(999999u));
	};
}

suite<"player_storage"> playerStorageTests = [] {
	static di::extension::injector<> injector {};
	InMemoryLogger::install(injector);
	DI::setTestContainer(&injector);

	reg_add_and_get_storage_value();
	reg_remove_storage_value();
	reg_passthrough_mounts();
	reg_passthrough_wing_effect_aura_shader();
	reg_outfits_side_effect();
	reg_familiars_side_effect();
	reg_unknown_reserved_key();
	reg_get_missing_key();
};
