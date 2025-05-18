/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "items/item.hpp"
#include "items/cylinder.hpp"

class Mailbox final : public Item, public Cylinder {
public:
	explicit Mailbox(uint16_t itemId) :
		Item(itemId) { }

	std::shared_ptr<Mailbox> getMailbox() override {
		return static_self_cast<Mailbox>();
	}

	std::shared_ptr<Cylinder> getCylinder() override {
		return getMailbox();
	}

	// cylinder implementations
	ReturnValue queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor = nullptr) override;
	ReturnValue queryMaxCount(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t &maxQueryCount, uint32_t flags) override;
	ReturnValue queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor = nullptr) override;
	std::shared_ptr<Cylinder> queryDestination(int32_t &index, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item> &destItem, uint32_t &flags) override;

	void addThing(const std::shared_ptr<Thing> &thing) override;
	void addThing(int32_t index, const std::shared_ptr<Thing> &thing) override;

	void updateThing(const std::shared_ptr<Thing> &thing, uint16_t itemId, uint32_t count) override;
	void replaceThing(uint32_t index, const std::shared_ptr<Thing> &thing) override;

	void removeThing(const std::shared_ptr<Thing> &thing, uint32_t count) override;

	void postAddNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &oldParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;
	void postRemoveNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &newParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;

private:
	bool getReceiver(const std::shared_ptr<Item> &item, std::string &name) const;
	bool sendItem(const std::shared_ptr<Item> &item) const;

	static bool canSend(const std::shared_ptr<Item> &item);
};
