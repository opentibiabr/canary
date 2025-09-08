/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "items/items_definitions.hpp"
#include "items/thing.hpp"

class Item;
class Creature;

static constexpr int32_t INDEX_WHEREEVER = -1;

class Cylinder : virtual public Thing {
public:
	/**
	 * Query if the cylinder can add an object
	 * \param index points to the destination index (inventory slot/container position)
	 * -1 is a internal value and means add to a empty position, with no destItem
	 * \param thing the object to move/add
	 * \param count is the amount that we want to move/add
	 * \param flags if FLAG_CHILDISOWNER if set the query is from a child-cylinder (check cap etc.)
	 * if FLAG_NOLIMIT is set blocking items/container limits is ignored
	 * \param actor the creature trying to add the thing
	 * \returns ReturnValue holds the return value
	 */
	virtual ReturnValue queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor = nullptr) = 0;

	/**
	 * Query the cylinder how much it can accept
	 * \param index points to the destination index (inventory slot/container position)
	 * -1 is a internal value and means add to a empty position, with no destItem
	 * \param thing the object to move/add
	 * \param count is the amount that we want to move/add
	 * \param maxQueryCount is the max amount that the cylinder can accept
	 * \param flags optional flags to modify the default behaviour
	 * \returns ReturnValue holds the return value
	 */
	virtual ReturnValue queryMaxCount(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t &maxQueryCount, uint32_t flags) = 0;

	/**
	 * Query if the cylinder can remove an object
	 * \param thing the object to move/remove
	 * \param count is the amount that we want to remove
	 * \param flags optional flags to modify the default behaviour
	 * \returns ReturnValue holds the return value
	 */
	virtual ReturnValue queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor = nullptr) = 0;

	/**
	 * Query the destination cylinder
	 * \param index points to the destination index (inventory slot/container position),
	 * -1 is a internal value and means add to a empty position, with no destItem
	 * this method can change the index to point to the new cylinder index
	 * \param destItem is the destination object
	 * \param flags optional flags to modify the default behaviour
	 * this method can modify the flags
	 * \returns Cylinder returns the destination cylinder
	 */
	virtual std::shared_ptr<Cylinder> queryDestination(int32_t &index, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item> &destItem, uint32_t &flags) = 0;

	/**
	 * Add the object to the cylinder
	 * \param thing is the object to add
	 */
	virtual void addThing(const std::shared_ptr<Thing> &thing) = 0;

	/**
	 * Add the object to the cylinder
	 * \param index points to the destination index (inventory slot/container position)
	 * \param thing is the object to add
	 */
	virtual void addThing(int32_t index, const std::shared_ptr<Thing> &thing) = 0;

	/**
	 * Update the item count or type for an object
	 * \param thing is the object to update
	 * \param itemId is the new item id
	 * \param count is the new count value
	 */
	virtual void updateThing(const std::shared_ptr<Thing> &thing, uint16_t itemId, uint32_t count) = 0;

	/**
	 * Replace an object with a new
	 * \param index is the position to change (inventory slot/container position)
	 * \param thing is the object to update
	 */
	virtual void replaceThing(uint32_t index, const std::shared_ptr<Thing> &thing) = 0;

	/**
	 * Remove an object
	 * \param thing is the object to delete
	 * \param count is the new count value
	 */
	virtual void removeThing(const std::shared_ptr<Thing> &thing, uint32_t count) = 0;

	/**
	 * Is sent after an operation (move/add) to update internal values
	 * \param thing is the object that has been added
	 * \param index is the objects new index value
	 * \param link holds the relation the object has to the cylinder
	 */
	virtual void postAddNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &oldParent, int32_t index, const CylinderLink_t link = LINK_OWNER) = 0;

	/**
	 * Is sent after an operation (move/remove) to update internal values
	 * \param thing is the object that has been removed
	 * \param index is the previous index of the removed object
	 * \param link holds the relation the object has to the cylinder
	 */
	virtual void postRemoveNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &newParent, int32_t index, CylinderLink_t link = LINK_OWNER) = 0;

	/**
	 * Gets the index of an object
	 * \param thing the object to get the index value from
	 * \returns the index of the object, returns -1 if not found
	 */
	virtual int32_t getThingIndex(const std::shared_ptr<Thing> &thing) const;

	/**
	 * Returns the first index
	 * \returns the first index, if not implemented 0 is returned
	 */
	virtual size_t getFirstIndex() const;

	/**
	 * Returns the last index
	 * \returns the last index, if not implemented 0 is returned
	 */
	virtual size_t getLastIndex() const;

	/**
	 * Gets the object based on index
	 * \returns the object, returns nullptr if not found
	 */
	virtual std::shared_ptr<Thing> getThing(size_t index) const;

	/**
	 * Get the amount of items of a certain type
	 * \param itemId is the item type to the get the count of
	 * \param subType is the extra type an item can have such as charges/fluidtype, -1 means not used
	 * \returns the amount of items of the asked item type
	 */
	virtual uint32_t getItemTypeCount(uint16_t itemId, int32_t subType = -1) const;

	/**
	 * Get the amount of items of a all types
	 * \param countMap a map to put the itemID:count mapping in
	 * \returns a map mapping item id to count (same as first argument)
	 */
	virtual std::map<uint32_t, uint32_t> &getAllItemTypeCount(std::map<uint32_t, uint32_t> &countMap) const;

	/**
	 * Adds an object to the cylinder without sending to the client(s)
	 * \param thing is the object to add
	 */
	virtual void internalAddThing(const std::shared_ptr<Thing> &thing);

	/**
	 * Adds an object to the cylinder without sending to the client(s)
	 * \param thing is the object to add
	 * \param index points to the destination index (inventory slot/container position)
	 */
	virtual void internalAddThing(uint32_t index, const std::shared_ptr<Thing> &thing);

	virtual void startDecaying();
};

class VirtualCylinder final : public Cylinder {
public:
	static std::shared_ptr<VirtualCylinder> virtualCylinder;

	virtual ReturnValue queryAdd(int32_t, const std::shared_ptr<Thing> &, uint32_t, uint32_t, const std::shared_ptr<Creature> & = nullptr) override {
		return RETURNVALUE_NOTPOSSIBLE;
	}
	virtual ReturnValue queryMaxCount(int32_t, const std::shared_ptr<Thing> &, uint32_t, uint32_t &, uint32_t) override {
		return RETURNVALUE_NOTPOSSIBLE;
	}
	virtual ReturnValue queryRemove(const std::shared_ptr<Thing> &, uint32_t, uint32_t, const std::shared_ptr<Creature> & /*actor*/ = nullptr) override {
		return RETURNVALUE_NOTPOSSIBLE;
	}
	virtual std::shared_ptr<Cylinder> queryDestination(int32_t &, const std::shared_ptr<Thing> &, std::shared_ptr<Item> &, uint32_t &) override {
		return nullptr;
	}

	virtual void addThing(const std::shared_ptr<Thing> &) override { }
	virtual void addThing(int32_t, const std::shared_ptr<Thing> &) override { }
	virtual void updateThing(const std::shared_ptr<Thing> &, uint16_t, uint32_t) override { }
	virtual void replaceThing(uint32_t, const std::shared_ptr<Thing> &) override { }
	virtual void removeThing(const std::shared_ptr<Thing> &, uint32_t) override { }

	virtual void postAddNotification(const std::shared_ptr<Thing> &, const std::shared_ptr<Cylinder> &, int32_t, CylinderLink_t = LINK_OWNER) override { }
	virtual void postRemoveNotification(const std::shared_ptr<Thing> &, const std::shared_ptr<Cylinder> &, int32_t, CylinderLink_t = LINK_OWNER) override { }

	bool isPushable() override {
		return false;
	}
	int32_t getThrowRange() const override {
		return 1;
	}
	std::string getDescription(int32_t) override {
		return {};
	}
	bool isRemoved() override {
		return false;
	}
};
