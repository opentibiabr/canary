#include "world/world_runtime_items.hpp"
#include "game/game.hpp"
#include "items/item.hpp"
#include "items/containers/container.hpp"
#include "items/tile.hpp"
#include "lib/logging/in_memory_logger.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <gtest/gtest.h>
#endif

class WorldRuntimeItemsTest : public ::testing::Test {
protected:
	static constexpr uint16_t itemId = 65010, containerId = 65011;
	static void SetUpTestSuite() {
		previous = DI::getTestContainer();
		InMemoryLogger::install(injector);
		DI::setTestContainer(&injector);
		auto &items = Item::items.getItems();
		originalSize = items.size();
		if (items.size() > itemId) {
			originalItem.emplace(std::move(items[itemId]));
		}
		if (items.size() > containerId) {
			originalContainer.emplace(std::move(items[containerId]));
		}
		if (items.size() <= containerId) {
			items.resize(containerId + 1);
		}
		items[itemId] = ItemType {};
		items[itemId].id = itemId;
		items[itemId].movable = true;
		items[itemId].pickupable = true;
		items[itemId].weight = 100;
		items[containerId] = ItemType {};
		items[containerId].id = containerId;
		items[containerId].group = ITEM_GROUP_CONTAINER;
		items[containerId].type = ITEM_TYPE_CONTAINER;
		items[containerId].maxItems = 3;
	}
	static void TearDownTestSuite() {
		auto &items = Item::items.getItems();
		if (originalItem) {
			items[itemId] = std::move(*originalItem);
		}
		if (originalContainer) {
			items[containerId] = std::move(*originalContainer);
		}
		items.resize(originalSize);
		DI::setTestContainer(previous);
	}
	static std::shared_ptr<Item> makeItem() {
		return std::make_shared<Item>(itemId, 1);
	}
	inline static di::extension::injector<> injector;
	inline static di::extension::injector<>* previous = nullptr;
	inline static size_t originalSize = 0;
	inline static std::optional<ItemType> originalItem, originalContainer;
};

TEST_F(WorldRuntimeItemsTest, AttributeRollbackRestoresAbsenceAndScalarTypes) {
	using world_layers::Value;
	const auto item = makeItem();
	item->setAttribute(ItemAttribute_t::ACTIONID, 123);
	item->setCustomAttribute("enabled", true);
	world_layers::Object object;
	object.aidOverride = true;
	object.attributes = {
		{ "text", Value { std::string("World text") } },
		{ "custom", Value { Value::Record { { "enabled", Value { int64_t(7) } }, { "new", Value { std::string("value") } } } } }
	};
	const auto values = world_runtime::overrides(object);
	const auto original = world_runtime::captureAttributes(item, values);
	world_runtime::applyAttributes(item, values);
	EXPECT_FALSE(item->hasAttribute(ItemAttribute_t::ACTIONID));
	EXPECT_EQ(item->getAttribute<std::string>(ItemAttribute_t::TEXT), "World text");
	ASSERT_NE(item->getCustomAttribute("enabled"), nullptr);
	EXPECT_TRUE(item->getCustomAttribute("enabled")->hasValue<int64_t>());
	world_runtime::applyAttributes(item, original);
	EXPECT_EQ(item->getAttribute<uint16_t>(ItemAttribute_t::ACTIONID), 123);
	EXPECT_FALSE(item->hasAttribute(ItemAttribute_t::TEXT));
	EXPECT_TRUE(item->getCustomAttribute("enabled")->hasValue<bool>());
	EXPECT_EQ(item->getCustomAttribute("new"), nullptr);
}

TEST_F(WorldRuntimeItemsTest, OrderedPlacementRejectsOverflowWithoutChangingContents) {
	const auto container = std::make_shared<Container>(containerId, 3);
	const auto first = makeItem(), second = makeItem(), third = makeItem(), extra = makeItem();
	ASSERT_TRUE(container->insertWorldItem(first, 0));
	ASSERT_TRUE(container->insertWorldItem(second, 0));
	ASSERT_TRUE(container->insertWorldItem(third, 1));
	EXPECT_EQ(container->getItemByIndex(0), second);
	EXPECT_EQ(container->getItemByIndex(1), third);
	EXPECT_EQ(container->getItemByIndex(2), first);
	EXPECT_FALSE(container->insertWorldItem(extra, 0));
	EXPECT_EQ(extra->getParent(), nullptr);
	EXPECT_EQ(container->size(), 3);
	EXPECT_FALSE(container->restoreWorldItemOrder({ first, first, second }));
	EXPECT_TRUE(container->restoreWorldItemOrder({ first, second, third }));
	EXPECT_EQ(container->getItemByIndex(0), first);
}

TEST_F(WorldRuntimeItemsTest, PersistencePreviewDoesNotRegisterUidOrConsumeSource) {
	const auto original = makeItem();
	world_runtime::mark(original, "library", "library.book");
	original->setAttribute(ItemAttribute_t::TEXT, std::string("History"));
	PropWriteStream output;
	output.write<uint8_t>(ATTR_UNIQUE_ID);
	output.write<uint16_t>(57999);
	output.write<uint8_t>(ATTR_SLEEPERGUID);
	output.write<uint32_t>(123456);
	original->serializeAttr(output);
	output.write<uint8_t>(0);
	size_t size;
	const auto data = output.getStream(size);
	PropStream input;
	input.init(data, size);
	const auto previousOwner = g_game().getUniqueItem(57999);
	const auto preview = makeItem();
	ASSERT_TRUE(preview->inspectAttributes(input));
	EXPECT_EQ(input.size(), size);
	EXPECT_EQ(g_game().getUniqueItem(57999), previousOwner);
	EXPECT_FALSE(preview->hasAttribute(ItemAttribute_t::UNIQUEID));
	EXPECT_EQ(world_runtime::marker(preview, "library"), "library.book");
	EXPECT_EQ(world_runtime::marker(preview, "different"), "");
}

TEST_F(WorldRuntimeItemsTest, BaseFingerprintIgnoresInternalOwnershipMetadata) {
	const auto item = makeItem();
	std::unordered_map<uint64_t, std::shared_ptr<Item>> instances;
	const auto before = world_runtime::snapshot(item, instances);
	world_runtime::mark(item, "library", "library.book");
	const auto after = world_runtime::snapshot(item, instances);
	EXPECT_EQ(world_layers::selectorFingerprint({ before }), world_layers::selectorFingerprint({ after }));
}

TEST_F(WorldRuntimeItemsTest, OccurrencesUseAuthoredOrderInsteadOfGameplayOrder) {
	const auto firstDown = makeItem();
	const auto secondDown = makeItem();
	const auto bottom = makeItem();
	const auto upper = makeItem();
	TileItemVector gameplay;
	gameplay.push_back(secondDown);
	gameplay.push_back(firstDown);
	gameplay.increaseDownItemCount();
	gameplay.increaseDownItemCount();
	gameplay.push_back(bottom);
	gameplay.push_back(upper);
	const auto authored = world_runtime::mapOrderedItems(gameplay);
	EXPECT_EQ(authored, (std::vector<std::shared_ptr<Item>> { bottom, upper, firstDown, secondDown }));
	EXPECT_EQ(gameplay.getTopDownItem(), secondDown);
	EXPECT_EQ(gameplay.getTopTopItem(), upper);
}

TEST_F(WorldRuntimeItemsTest, BaseSelectionRetainsAuthoredTypesAcrossNativeFieldConversion) {
	const std::pair<uint16_t, uint16_t> conversions[] = {
		{ ITEM_FIREFIELD_PVP_FULL, ITEM_FIREFIELD_PERSISTENT_FULL },
		{ ITEM_FIREFIELD_PVP_MEDIUM, ITEM_FIREFIELD_PERSISTENT_MEDIUM },
		{ ITEM_FIREFIELD_PVP_SMALL, ITEM_FIREFIELD_PERSISTENT_SMALL },
		{ ITEM_ENERGYFIELD_PVP, ITEM_ENERGYFIELD_PERSISTENT },
		{ ITEM_POISONFIELD_PVP, ITEM_POISONFIELD_PERSISTENT },
		{ ITEM_MAGICWALL, ITEM_MAGICWALL_PERSISTENT },
		{ ITEM_WILDGROWTH, ITEM_WILDGROWTH_PERSISTENT }
	};
	for (const auto &[authored, effective] : conversions) {
		SCOPED_TRACE(authored);
		auto &type = Item::items.getItems()[effective];
		struct RestoreType {
			ItemType &target;
			ItemType previous;
			~RestoreType() {
				target = std::move(previous);
			}
		} restore { type, std::move(type) };
		type = ItemType {};
		type.id = effective;
		Position position { 100, 100, 7 };
		const auto item = Item::CreateItem(authored, position);
		ASSERT_NE(item, nullptr);
		EXPECT_EQ(item->getID(), effective);
		std::unordered_map<uint64_t, std::shared_ptr<Item>> instances;
		const auto base = world_runtime::snapshot(item, instances, false, true);
		const auto live = world_runtime::snapshot(item, instances);
		world_layers::Selector selector;
		selector.itemId = authored;
		world_layers::MapItem selected;
		std::string error;
		EXPECT_TRUE(world_layers::resolveSelector(selector, { base }, selected, error));
		EXPECT_EQ(selected.key, reinterpret_cast<uintptr_t>(item.get()));
		EXPECT_EQ(live.itemId, effective);
		const auto clone = item->clone();
		ASSERT_NE(clone, nullptr);
		EXPECT_EQ(clone->getMapSourceId(), effective);
	}
}
