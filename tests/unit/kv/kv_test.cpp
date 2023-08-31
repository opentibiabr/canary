/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#include "pch.hpp"

#include <boost/ut.hpp>

#include "kv/kv.hpp"
#include "utils/tools.hpp"
#include "injection_fixture.hpp"

suite<"kv"> kvTest = [] {
	InjectionFixture injectionFixture {};

	test("Set and get integer value") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		kv.set("keyInt", 42);
		expect(eq(kv.get<int>("keyInt"), 42));
	};

	test("Set and get string value") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		kv.set("keyString", std::string("hello"));
		expect(eq(kv.get<std::string>("keyString"), std::string("hello")));
	};

	test("Set and get double value") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		kv.set("keyDouble", 3.14);
		expect(eq(kv.get<double>("keyDouble"), 3.14));
	};

	test("Overwrite existing key") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		kv.set("keyInt", 42);
		kv.set("keyInt", 43);
		expect(eq(kv.get<int>("keyInt"), 43));
	};

	test("Multiple key-value pairs") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		kv.set("key1", 1);
		kv.set("key2", 2);
		kv.set("key3", 3);
		expect(eq(kv.get<int>("key1"), 1));
		expect(eq(kv.get<int>("key2"), 2));
		expect(eq(kv.get<int>("key3"), 3));
	};

	test("non-existant key") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		expect(!kv.get("non-existant").has_value());
		// default values
		expect(eq(kv.get<int>("non-existant"), 0));
		expect(eq(kv.get<std::string>("non-existant"), std::string("")));
		expect(kv.get<MapType>("non-existant").empty());
		expect(kv.get<ArrayType>("non-existant").empty());
	};

	test("Set and get MapType value") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		ValueWrapper mapValue { { "key1", 1 }, { "key2", 2 } };
		kv.set("keyMap", mapValue);
		expect(eq(kv.get<MapType>("keyMap"), mapValue.getVariant()));
	};

	test("Set and get ArrayType value") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		ValueWrapper arrayValue(ArrayType({ 1, 2, 3 }));
		kv.set("keyArray", arrayValue);
		expect(eq(kv.get<ArrayType>("keyArray"), arrayValue.getVariant()));
	};

	test("Mixed types in MapType") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		ValueWrapper mixedMap { { "keyInt", 1 }, { "keyString", std::string("hello") }, { "keyDouble", 3.14 } };
		kv.set("keyMixedMap", mixedMap);
		expect(eq(kv.get<MapType>("keyMixedMap"), mixedMap.getVariant()));
	};

	test("Nested MapType and ArrayType") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		ValueWrapper nestedMap { { "keyArray", ValueWrapper { 1, 2 } }, { "keyInnerMap", ValueWrapper { { "key3", 3 } } } };
		kv.set("keyNested", nestedMap);
		expect(eq(kv.get<MapType>("keyNested"), nestedMap.getVariant()));
	};

	test("Scoped KV") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		auto scoped = kv.scoped("scope-name");
		scoped->set("key1", 1);
		expect(eq(scoped->get<int>("key1"), 1));
		expect(eq(kv.get<int>("scope-name.key1"), 1));
	};
};
