/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
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

	// cylinder implementations
	ReturnValue queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, std::shared_ptr<Creature> actor = nullptr) override;
	ReturnValue queryMaxCount(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t &maxQueryCount, uint32_t flags) override;
	ReturnValue queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, std::shared_ptr<Creature> actor = nullptr) override;
	std::shared_ptr<Cylinder> queryDestination(int32_t &index, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item>* destItem, uint32_t &flags) override;

	void addThing(std::shared_ptr<Thing> thing) override;
	void addThing(int32_t index, std::shared_ptr<Thing> thing) override;

	void updateThing(std::shared_ptr<Thing> thing, uint16_t itemId, uint32_t count) override;
	void replaceThing(uint32_t index, std::shared_ptr<Thing> thing) override;

	void removeThing(std::shared_ptr<Thing> thing, uint32_t count) override;

	void postAddNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> oldParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;
	void postRemoveNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> newParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;

private:
	bool getReceiver(std::shared_ptr<Item> item, std::string &name) const;
	bool sendItem(std::shared_ptr<Item> item) const;

	static bool canSend(std::shared_ptr<Item> item);
};
