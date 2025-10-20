#include "server/network/protocol/builders/imbuement_message_builder.hpp"

#include "creatures/players/imbuements/imbuements.hpp"
#include "creatures/players/player.hpp"
#include "creatures/combat/condition.hpp"
#include "items/item.hpp"
#include "items/items_definitions.hpp"
#include "items/tile.hpp"
#include "server/network/message/outputmessage.hpp"

void ImbuementMessageBuilder::writeImbuementInfo(NetworkMessage &msg, uint16_t imbuementId) {
	Imbuement* imbuement = g_imbuements().getImbuement(imbuementId);
	if (!imbuement) {
		msg.add<uint32_t>(imbuementId);
		msg.addString("");
		msg.addString("");
		msg.addString("");
		msg.add<uint16_t>(0);
		msg.add<uint32_t>(0);
		msg.addByte(0);
		msg.addByte(0);
		msg.add<uint32_t>(0);
		msg.addByte(0);
		msg.add<uint32_t>(0);
		return;
	}

	const BaseImbuement* baseImbuement = g_imbuements().getBaseByID(imbuement->getBaseID());
	const CategoryImbuement* categoryImbuement = g_imbuements().getCategoryByID(imbuement->getCategory());

	msg.add<uint32_t>(imbuementId);
	msg.addString(baseImbuement ? baseImbuement->name + " " + imbuement->getName() : imbuement->getName());
	msg.addString(imbuement->getDescription());
	msg.addString(categoryImbuement ? categoryImbuement->name + imbuement->getSubGroup() : imbuement->getSubGroup());

	msg.add<uint16_t>(imbuement->getIconID());
	msg.add<uint32_t>(baseImbuement ? baseImbuement->duration : 0);

	msg.addByte(imbuement->isPremium() ? 0x01 : 0x00);

	const auto &items = imbuement->getItems();
	msg.addByte(items.size());

	for (const auto &itm : items) {
		const ItemType &it = Item::items[itm.first];
		msg.add<uint16_t>(itm.first);
		msg.addString(it.name);
		msg.add<uint16_t>(itm.second);
	}

	msg.add<uint32_t>(baseImbuement ? baseImbuement->price : 0);
	msg.addByte(baseImbuement ? baseImbuement->percent : 0);
	msg.add<uint32_t>(baseImbuement ? baseImbuement->protectionPrice : 0);
}

void ImbuementMessageBuilder::buildOpenWindow(NetworkMessage &msg, const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, bool oldProtocol) {
	if (!item) {
		return;
	}

	msg.addByte(0xEB);
	msg.add<uint16_t>(item->getID());
	if (!oldProtocol && item->getClassification() > 0) {
		msg.addByte(0);
	}
	msg.addByte(item->getImbuementSlot());

	for (uint8_t slotId = 0; slotId < static_cast<uint8_t>(item->getImbuementSlot()); slotId++) {
		ImbuementInfo imbuementInfo;
		if (!item->getImbuementInfo(slotId, &imbuementInfo) || !imbuementInfo.imbuement) {
			msg.addByte(0x00);
			continue;
		}

		msg.addByte(0x01);
		writeImbuementInfo(msg, imbuementInfo.imbuement->getID());
		msg.add<uint32_t>(imbuementInfo.duration);

		const BaseImbuement* baseImbuement = g_imbuements().getBaseByID(imbuementInfo.imbuement->getBaseID());
		msg.add<uint32_t>(baseImbuement ? baseImbuement->removeCost : 0);
	}

	std::vector<Imbuement*> imbuements = g_imbuements().getImbuements(player, item);
	phmap::flat_hash_map<uint16_t, uint16_t> needItems;

	msg.add<uint16_t>(imbuements.size());
	for (const Imbuement* imbuement : imbuements) {
		writeImbuementInfo(msg, imbuement->getID());

		const auto items = imbuement->getItems();
		for (const auto &itm : items) {
			if (needItems.find(itm.first) == needItems.end()) {
				uint16_t count = 0;
				if (player) {
					count = static_cast<uint16_t>(player->getItemTypeCount(itm.first));
					uint32_t stashCount = player->getStashItemCount(Item::items[itm.first].id);
					if (stashCount > 0) {
						uint32_t total = static_cast<uint32_t>(count) + stashCount;
						if (total > 0xFFFF) {
							total = 0xFFFF;
						}
						count = static_cast<uint16_t>(total);
					}
				}
				needItems.emplace(itm.first, count);
			}
		}
	}

	msg.add<uint32_t>(needItems.size());
	for (const auto &itm : needItems) {
		msg.add<uint16_t>(itm.first);
		msg.add<uint16_t>(itm.second);
	}
}

void ImbuementMessageBuilder::writeInventorySlots(NetworkMessage &msg, const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item) {
	if (!item) {
		msg.addByte(0);
		return;
	}

	uint8_t slots = item->getImbuementSlot();
	msg.addByte(slots);
	if (slots == 0) {
		return;
	}

	for (uint8_t imbueSlot = 0; imbueSlot < slots; imbueSlot++) {
		ImbuementInfo imbuementInfo;
		if (!item->getImbuementInfo(imbueSlot, &imbuementInfo) || !imbuementInfo.imbuement) {
			msg.addByte(0x00);
			continue;
		}

		const Imbuement* imbuement = imbuementInfo.imbuement;
		const BaseImbuement* baseImbuement = g_imbuements().getBaseByID(imbuement->getBaseID());

		msg.addByte(0x01);
		msg.addString(baseImbuement ? baseImbuement->name + " " + imbuement->getName() : imbuement->getName());
		msg.add<uint16_t>(imbuement->getIconID());
		msg.add<uint32_t>(imbuementInfo.duration);

		std::shared_ptr<Tile> playerTile = player ? player->getTile() : nullptr;
		bool isInProtectionZone = playerTile && playerTile->hasFlag(TILESTATE_PROTECTIONZONE);
		bool isInFightMode = player && player->hasCondition(CONDITION_INFIGHT);
		const CategoryImbuement* categoryImbuement = g_imbuements().getCategoryByID(imbuement->getCategory());
		auto parent = item->getParent();

		if (categoryImbuement && categoryImbuement->agressive && (isInProtectionZone || !isInFightMode)) {
			msg.addByte(0);
			continue;
		}

		if (categoryImbuement && !categoryImbuement->agressive && parent && parent != player) {
			msg.addByte(0);
			continue;
		}

		msg.addByte(1);
	}
}

uint8_t ImbuementMessageBuilder::writeImbuementIcons(NetworkMessage &msg, const std::shared_ptr<Item> &item) {
	if (!item) {
		return 0;
	}

	uint8_t imbuementCount = 0;
	for (uint8_t slotId = 0; slotId < item->getImbuementSlot(); slotId++) {
		ImbuementInfo imbuementInfo;
		if (!item->getImbuementInfo(slotId, &imbuementInfo) || !imbuementInfo.imbuement) {
			continue;
		}

		msg.add<uint16_t>(imbuementInfo.imbuement->getIconID());
		imbuementCount++;
	}

	return imbuementCount;
}
