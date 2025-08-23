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
		expect(eq(kv.get("keyInt")->get<int>(), 42));
	};

	test("Set and get boolean value") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		kv.set("keyBool", true);
		expect(eq(kv.get("keyBool")->get<bool>(), true));
	};

	test("Set and get string value") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		kv.set("keyString", std::string("hello"));
		expect(eq(kv.get("keyString")->get<std::string>(), std::string("hello")));
	};

	test("Set and get double value") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		kv.set("keyDouble", 3.14);
		expect(eq(kv.get("keyDouble")->get<double>(), 3.14));
	};

	test("Overwrite existing key") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		kv.set("keyInt", 42);
		kv.set("keyInt", 43);
		expect(eq(kv.get("keyInt")->get<int>(), 43));
	};

	test("Multiple key-value pairs") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		kv.set("key1", 1);
		kv.set("key2", 2);
		kv.set("key3", 3);
		expect(eq(kv.get("key1")->get<int>(), 1));
		expect(eq(kv.get("key2")->get<int>(), 2));
		expect(eq(kv.get("key3")->get<int>(), 3));
	};

	test("non-existant key") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		expect(!kv.get("non-existant").has_value());
		expect(!kv.get("non-existant2").has_value());
	};

	test("Set and get MapType value") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		ValueWrapper mapValue { { "key1", 1 }, { "key2", 2 } };
		kv.set("keyMap", mapValue);
		expect(eq(kv.get("keyMap")->get<MapType>(), mapValue.getVariant()));
	};

	test("Set and get ArrayType value") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		ValueWrapper arrayValue(ArrayType({ 1, 2, 3 }));
		kv.set("keyArray", arrayValue);
		expect(eq(kv.get("keyArray")->get<ArrayType>(), arrayValue.getVariant()));
	};

	test("Mixed types in MapType") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		ValueWrapper mixedMap { { "keyInt", 1 }, { "keyString", std::string("hello") }, { "keyDouble", 3.14 } };
		kv.set("keyMixedMap", mixedMap);
		expect(eq(kv.get("keyMixedMap")->get<MapType>(), mixedMap.getVariant()));
	};

	test("Nested MapType and ArrayType") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		ValueWrapper nestedMap { { "keyArray", ValueWrapper { 1, 2 } }, { "keyInnerMap", ValueWrapper { { "key3", 3 } } } };
		kv.set("keyNested", nestedMap);
		expect(eq(kv.get("keyNested")->get<MapType>(), nestedMap.getVariant()));
	};

	test("Scoped KV") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		auto scoped = kv.scoped("scope-name");
		scoped->set("key1", 1);
		expect(eq(scoped->get("key1")->get<int>(), 1));
		expect(eq(kv.get("scope-name.key1")->get<int>(), 1));
	};

	test("Nested Scoped KV") = [&injectionFixture] {
		auto [kv] = injectionFixture.get<KVStore>();
		auto scoped = kv.scoped("scope-name");
		auto nestedScoped = scoped->scoped("nested-scope-name");
		auto nestedScoped2 = nestedScoped->scoped("nested-scope-name2");
		nestedScoped2->set("key1", 1);
		expect(eq(nestedScoped2->get("key1")->get<int>(), 1));
		expect(eq(nestedScoped->get("nested-scope-name2.key1")->get<int>(), 1));
		expect(eq(scoped->get("nested-scope-name.nested-scope-name2.key1")->get<int>(), 1));
		expect(eq(kv.get("scope-name.nested-scope-name.nested-scope-name2.key1")->get<int>(), 1));
	};

	test("Removing an element")
		= [&injectionFixture] {
			  auto [kv] = injectionFixture.get<KVStore>();
			  kv.set("key1", 1);
			  kv.set("key2", 2);
			  expect(eq(kv.get("key1")->get<int>(), 1));
			  expect(eq(kv.get("key2")->get<int>(), 2));
			  kv.set("key1", ValueWrapper::deleted());
			  expect(!kv.get("key1").has_value());
			  expect(eq(kv.get("key2")->get<int>(), 2));
			  kv.remove("key2");
			  expect(!kv.get("key2").has_value());
		  };

	test("Keys skip deleted entries")
		= [&injectionFixture] {
			  auto [kv] = injectionFixture.get<KVStore>();
			  kv.set("key1", 1);
			  kv.set("key2", 2);
			  kv.remove("key1");
			  auto keys = kv.keys();
			  expect(!keys.contains("key1"));
			  expect(keys.contains("key2"));
		  };
};
