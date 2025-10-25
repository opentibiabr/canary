/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#include "pch.hpp"

#include <gtest/gtest.h>

#include "kv/kv.hpp"
#include "utils/tools.hpp"
#include "injection_fixture.hpp"

class KVTest : public ::testing::Test {
public:
	InjectionFixture &fixture() {
		return fixture_;
	}

private:
	InjectionFixture fixture_ {};
};

TEST_F(KVTest, SetAndGetIntegerValue) {
	auto [kv] = fixture().get<KVStore>();
	kv.set("keyInt", 42);
	ASSERT_TRUE(kv.get("keyInt").has_value());
	EXPECT_EQ(42, kv.get("keyInt")->get<int>());
}

TEST_F(KVTest, SetAndGetBooleanValue) {
	auto [kv] = fixture().get<KVStore>();
	kv.set("keyBool", true);
	ASSERT_TRUE(kv.get("keyBool").has_value());
	EXPECT_TRUE(kv.get("keyBool")->get<bool>());
}

TEST_F(KVTest, SetAndGetStringValue) {
	auto [kv] = fixture().get<KVStore>();
	kv.set("keyString", std::string("hello"));
	ASSERT_TRUE(kv.get("keyString").has_value());
	EXPECT_EQ(std::string("hello"), kv.get("keyString")->get<std::string>());
}

TEST_F(KVTest, SetAndGetDoubleValue) {
	auto [kv] = fixture().get<KVStore>();
	kv.set("keyDouble", 3.14);
	ASSERT_TRUE(kv.get("keyDouble").has_value());
	EXPECT_DOUBLE_EQ(3.14, kv.get("keyDouble")->get<double>());
}

TEST_F(KVTest, OverwriteExistingKey) {
	auto [kv] = fixture().get<KVStore>();
	kv.set("keyInt", 42);
	kv.set("keyInt", 43);
	ASSERT_TRUE(kv.get("keyInt").has_value());
	EXPECT_EQ(43, kv.get("keyInt")->get<int>());
}

TEST_F(KVTest, MultipleKeyValuePairs) {
	auto [kv] = fixture().get<KVStore>();
	kv.set("key1", 1);
	kv.set("key2", 2);
	kv.set("key3", 3);
	ASSERT_TRUE(kv.get("key1").has_value());
	ASSERT_TRUE(kv.get("key2").has_value());
	ASSERT_TRUE(kv.get("key3").has_value());
	EXPECT_EQ(1, kv.get("key1")->get<int>());
	EXPECT_EQ(2, kv.get("key2")->get<int>());
	EXPECT_EQ(3, kv.get("key3")->get<int>());
}

TEST_F(KVTest, NonExistantKey) {
	auto [kv] = fixture().get<KVStore>();
	EXPECT_FALSE(kv.get("non-existant").has_value());
	EXPECT_FALSE(kv.get("non-existant2").has_value());
}

TEST_F(KVTest, SetAndGetMapTypeValue) {
	auto [kv] = fixture().get<KVStore>();
	ValueWrapper mapValue { { "key1", 1 }, { "key2", 2 } };
	kv.set("keyMap", mapValue);
	ASSERT_TRUE(kv.get("keyMap").has_value());
	EXPECT_EQ(kv.get("keyMap")->get<MapType>(), mapValue.getVariant());
}

TEST_F(KVTest, SetAndGetArrayTypeValue) {
	auto [kv] = fixture().get<KVStore>();
	ValueWrapper arrayValue(ArrayType({ 1, 2, 3 }));
	kv.set("keyArray", arrayValue);
	ASSERT_TRUE(kv.get("keyArray").has_value());
	EXPECT_EQ(kv.get("keyArray")->get<ArrayType>(), arrayValue.getVariant());
}

TEST_F(KVTest, MixedTypesInMapType) {
	auto [kv] = fixture().get<KVStore>();
	ValueWrapper mixedMap { { "keyInt", 1 }, { "keyString", std::string("hello") }, { "keyDouble", 3.14 } };
	kv.set("keyMixedMap", mixedMap);
	ASSERT_TRUE(kv.get("keyMixedMap").has_value());
	EXPECT_EQ(kv.get("keyMixedMap")->get<MapType>(), mixedMap.getVariant());
}

TEST_F(KVTest, NestedMapTypeAndArrayType) {
	auto [kv] = fixture().get<KVStore>();
	ValueWrapper nestedMap { { "keyArray", ValueWrapper { 1, 2 } }, { "keyInnerMap", ValueWrapper { { "key3", 3 } } } };
	kv.set("keyNested", nestedMap);
	ASSERT_TRUE(kv.get("keyNested").has_value());
	EXPECT_EQ(kv.get("keyNested")->get<MapType>(), nestedMap.getVariant());
}

TEST_F(KVTest, ScopedKv) {
	auto [kv] = fixture().get<KVStore>();
	auto scoped = kv.scoped("scope-name");
	scoped->set("key1", 1);
	ASSERT_TRUE(scoped->get("key1").has_value());
	ASSERT_TRUE(kv.get("scope-name.key1").has_value());
	EXPECT_EQ(1, scoped->get("key1")->get<int>());
	EXPECT_EQ(1, kv.get("scope-name.key1")->get<int>());
}

TEST_F(KVTest, NestedScopedKv) {
	auto [kv] = fixture().get<KVStore>();
	auto scoped = kv.scoped("scope-name");
	auto nestedScoped = scoped->scoped("nested-scope-name");
	auto nestedScoped2 = nestedScoped->scoped("nested-scope-name2");
	nestedScoped2->set("key1", 1);
	ASSERT_TRUE(nestedScoped2->get("key1").has_value());
	ASSERT_TRUE(nestedScoped->get("nested-scope-name2.key1").has_value());
	ASSERT_TRUE(scoped->get("nested-scope-name.nested-scope-name2.key1").has_value());
	ASSERT_TRUE(kv.get("scope-name.nested-scope-name.nested-scope-name2.key1").has_value());
	EXPECT_EQ(1, nestedScoped2->get("key1")->get<int>());
	EXPECT_EQ(1, nestedScoped->get("nested-scope-name2.key1")->get<int>());
	EXPECT_EQ(1, scoped->get("nested-scope-name.nested-scope-name2.key1")->get<int>());
	EXPECT_EQ(1, kv.get("scope-name.nested-scope-name.nested-scope-name2.key1")->get<int>());
}

TEST_F(KVTest, RemovingAnElement) {
	auto [kv] = fixture().get<KVStore>();
	kv.set("key1", 1);
	kv.set("key2", 2);
	ASSERT_TRUE(kv.get("key1").has_value());
	ASSERT_TRUE(kv.get("key2").has_value());
	kv.set("key1", ValueWrapper::deleted());
	EXPECT_FALSE(kv.get("key1").has_value());
	ASSERT_TRUE(kv.get("key2").has_value());
	EXPECT_EQ(2, kv.get("key2")->get<int>());
	kv.remove("key2");
	EXPECT_FALSE(kv.get("key2").has_value());
}

TEST_F(KVTest, KeysSkipDeletedEntries) {
	auto [kv] = fixture().get<KVStore>();
	kv.set("key1", 1);
	kv.set("key2", 2);
	kv.remove("key1");
	auto keys = kv.keys();
	EXPECT_FALSE(keys.contains("key1"));
	EXPECT_TRUE(keys.contains("key2"));
}
