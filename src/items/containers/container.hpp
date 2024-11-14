/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "items/cylinder.hpp"
#include "items/item.hpp"
#include "items/tile.hpp"

class Container;
class DepotChest;
class DepotLocker;
class RewardChest;
class Reward;

class ContainerIterator {
public:
	/**
	 * @brief Constructs a ContainerIterator with a specified container and maximum traversal depth.
	 *
	 * This constructor initializes the iterator to start iterating over the specified container
	 * and ensures that it will not traverse deeper than the specified maxDepth.
	 *
	 * @param container The root container to start iterating from.
	 * @param maxDepth The maximum depth of nested containers to traverse.
	 */
	ContainerIterator(const std::shared_ptr<Container> &container, size_t maxDepth);

	/**
	 * @brief Checks if there are more items to iterate over in the container.
	 *
	 * This function checks if there are more items to iterate over in the current container or
	 * in any of the nested sub-containers. If no items are left, the function will return false.
	 *
	 * @return true if there are more items to iterate over; false otherwise.
	 */
	bool hasNext() const;

	/**
	 * @brief Advances the iterator to the next item in the container.
	 *
	 * This function moves the iterator to the next item. If the current item is a sub-container,
	 * it adds that sub-container to the stack to iterate over its items as well.
	 * It also handles maximum depth and cycle detection to prevent infinite loops.
	 */
	void advance();

	/**
	 * @brief Returns the current item pointed to by the iterator.
	 *
	 * This function returns the current item in the container that the iterator points to.
	 * If there are no more items to iterate over, it returns nullptr.
	 *
	 * @return A shared pointer to the current item, or nullptr if no items are left.
	 */
	std::shared_ptr<Item> operator*() const;

	bool hasReachedMaxDepth() const;

	std::shared_ptr<Container> getCurrentContainer() const;
	size_t getCurrentIndex() const;

private:
	/**
	 * @brief Represents the state of the iterator at a given point in time.
	 *
	 * This structure is used to keep track of the current container,
	 * the index of the current item within that container, and the depth
	 * of traversal for nested containers. It is primarily used in the
	 * ContainerIterator to manage the state of the iteration as it traverses
	 * through containers and their sub-containers.
	 */
	struct IteratorState {
		/**
		 * @brief The container being iterated over.
		 */
		std::weak_ptr<Container> container;

		/**
		 * @brief The current index within the container's item list.
		 */
		size_t index;

		/**
		 * @brief The depth of traversal, indicating how deep the iteration is
		 * within nested sub-containers.
		 */
		size_t depth;

		/**
		 * @brief Constructs an IteratorState with the given container, index, and depth.
		 *
		 * @param c The container to iterate over.
		 * @param i The starting index within the container.
		 * @param d The depth of traversal.
		 */
		IteratorState(std::shared_ptr<Container> c, size_t i, size_t d) :
			container(c), index(i), depth(d) { }
	};

	/**
	 * @brief Stack of IteratorState objects representing the state of the iteration.
	 *
	 * This stack keeps track of the current position in each container and is
	 * used to traverse containers and their nested sub-containers in a depth-first manner.
	 * Each element in the stack represents a different level in the container hierarchy.
	 */
	mutable std::vector<IteratorState> states;

	/**
	 * @brief Set of containers that have already been visited during the iteration.
	 *
	 * This set is used to keep track of all containers that have been visited
	 * to avoid revisiting them and causing infinite loops or cycles. It ensures
	 * that each container is processed only once, preventing redundant processing
	 * and potential crashes due to cyclic references.
	 */
	mutable std::unordered_set<std::shared_ptr<Container>> visitedContainers;
	size_t maxTraversalDepth = 0;

	bool m_maxDepthReached = false;
	bool m_cycleDetected = false;

	friend class Container;
};

class Container : public Item, public Cylinder {
public:
	explicit Container(uint16_t type);
	Container(uint16_t type, uint16_t size, bool unlocked = true, bool pagination = false);
	~Container();

	static std::shared_ptr<Container> create(uint16_t type);
	static std::shared_ptr<Container> create(uint16_t type, uint16_t size, bool unlocked = true, bool pagination = false);
	static std::shared_ptr<Container> create(std::shared_ptr<Tile> type);

	// non-copyable
	Container(const Container &) = delete;
	Container &operator=(const Container &) = delete;

	std::shared_ptr<Item> clone() const override final;

	std::shared_ptr<Container> getContainer() override final {
		return static_self_cast<Container>();
	}

	std::shared_ptr<const Container> getContainer() const override final {
		return static_self_cast<Container>();
	}

	std::shared_ptr<Cylinder> getCylinder() override final {
		return getContainer();
	}

	std::shared_ptr<Container> getRootContainer();

	virtual std::shared_ptr<DepotLocker> getDepotLocker() {
		return nullptr;
	}

	virtual std::shared_ptr<RewardChest> getRewardChest() {
		return nullptr;
	}

	virtual std::shared_ptr<Reward> getReward() {
		return nullptr;
	}
	virtual bool isInbox() const {
		return false;
	}
	virtual bool isDepotChest() const {
		return false;
	}

	Attr_ReadValue readAttr(AttrTypes_t attr, PropStream &propStream) override;
	bool unserializeItemNode(OTB::Loader &loader, const OTB::Node &node, PropStream &propStream, Position &itemPosition) override;
	std::string getContentDescription(bool oldProtocol);

	uint32_t getMaxCapacity() const;

	size_t size() const {
		return itemlist.size();
	}
	bool empty() const {
		return itemlist.empty();
	}
	uint32_t capacity() const {
		return maxSize;
	}

	ContainerIterator iterator();

	const ItemDeque &getItemList() const {
		return itemlist;
	}

	ItemDeque::const_reverse_iterator getReversedItems() const {
		return itemlist.rbegin();
	}
	ItemDeque::const_reverse_iterator getReversedEnd() const {
		return itemlist.rend();
	}

	bool countsToLootAnalyzerBalance();
	bool hasParent();
	void addItem(std::shared_ptr<Item> item);
	StashContainerList getStowableItems() const;
	bool isStoreInbox() const;
	bool isStoreInboxFiltered() const;
	std::deque<std::shared_ptr<Item>> getStoreInboxFilteredItems() const;
	std::vector<ContainerCategory_t> getStoreInboxValidCategories() const;
	std::shared_ptr<Item> getFilteredItemByIndex(size_t index) const;
	std::shared_ptr<Item> getItemByIndex(size_t index) const;
	bool isHoldingItem(std::shared_ptr<Item> item);
	bool isHoldingItemWithId(const uint16_t id);

	uint32_t getItemHoldingCount();
	uint32_t getContainerHoldingCount();
	uint16_t getFreeSlots();
	uint32_t getWeight() const override final;

	bool isUnlocked() const {
		return !this->isCorpse() && unlocked;
	}
	bool hasPagination() const {
		return pagination;
	}

	// cylinder implementations
	virtual ReturnValue queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, std::shared_ptr<Creature> actor = nullptr) override;
	ReturnValue queryMaxCount(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t &maxQueryCount, uint32_t flags) override final;
	ReturnValue queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, std::shared_ptr<Creature> actor = nullptr) override final;
	std::shared_ptr<Cylinder> queryDestination(int32_t &index, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item>* destItem, uint32_t &flags) override final;

	void addThing(std::shared_ptr<Thing> thing) override final;
	void addThing(int32_t index, std::shared_ptr<Thing> thing) override final;
	void addItemBack(std::shared_ptr<Item> item);

	void updateThing(std::shared_ptr<Thing> thing, uint16_t itemId, uint32_t count) override final;
	void replaceThing(uint32_t index, std::shared_ptr<Thing> thing) override final;

	void removeThing(std::shared_ptr<Thing> thing, uint32_t count) override final;

	int32_t getThingIndex(std::shared_ptr<Thing> thing) const override final;
	size_t getFirstIndex() const override final;
	size_t getLastIndex() const override final;
	uint32_t getItemTypeCount(uint16_t itemId, int32_t subType = -1) const override final;
	std::map<uint32_t, uint32_t> &getAllItemTypeCount(std::map<uint32_t, uint32_t> &countMap) const override final;
	std::shared_ptr<Thing> getThing(size_t index) const override final;

	ItemVector getItems(bool recursive = false);

	void postAddNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> oldParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;
	void postRemoveNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> newParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;

	void internalAddThing(std::shared_ptr<Thing> thing) override final;
	void internalAddThing(uint32_t index, std::shared_ptr<Thing> thing) override final;

	virtual void removeItem(std::shared_ptr<Thing> thing, bool sendUpdateToClient = false);

	uint32_t getOwnerId() const override final;

	bool isAnyKindOfRewardChest();
	bool isAnyKindOfRewardContainer();
	bool isBrowseFieldAndHoldsRewardChest();
	bool isInsideContainerWithId(const uint16_t id);

protected:
	std::ostringstream &getContentDescription(std::ostringstream &os, bool oldProtocol);

	uint32_t m_maxItems;
	uint32_t maxSize;
	uint32_t totalWeight = 0;
	ItemDeque itemlist;
	uint32_t serializationCount = 0;

	bool unlocked;
	bool pagination;

	friend class MapCache;

private:
	void onAddContainerItem(std::shared_ptr<Item> item);
	void onUpdateContainerItem(uint32_t index, std::shared_ptr<Item> oldItem, std::shared_ptr<Item> newItem);
	void onRemoveContainerItem(uint32_t index, std::shared_ptr<Item> item);

	std::shared_ptr<Container> getParentContainer();
	std::shared_ptr<Container> getTopParentContainer();
	void updateItemWeight(int32_t diff);

	friend class ContainerIterator;
	friend class IOMapSerialize;
};
