#include "server/network/protocol/builders/cyclopedia_house_message_builder.hpp"

#include "creatures/players/player.hpp"
#include "io/iologindata.hpp"
#include "map/house/house.hpp"
#include "server/network/message/outputmessage.hpp"
#include "utils/tools.hpp"
#include "enums/player_cyclopedia.hpp"

void CyclopediaHouseMessageBuilder::writeHouseList(NetworkMessage &msg, const std::shared_ptr<Player> &player, const HouseMap &houses) {
	msg.addByte(0xC7);
	msg.add<uint16_t>(houses.size());
	for (const auto &[clientId, houseData] : houses) {
		msg.add<uint32_t>(clientId);
		msg.addByte(0x01);

		auto houseState = houseData->getState();
		auto stateValue = magic_enum::enum_integer(houseState);
		msg.addByte(stateValue);
		if (houseState == CyclopediaHouseState::Available) {
			bool bidder = houseData->getBidderName() == player->getName();
			msg.addString(houseData->getBidderName());
			msg.addByte(bidder);
			uint8_t disableIndex = enumToValue(player->canBidHouse(clientId));
			msg.addByte(disableIndex);

			if (!houseData->getBidderName().empty()) {
				msg.add<uint32_t>(houseData->getBidEndDate());
				msg.add<uint64_t>(houseData->getHighestBid());
				if (bidder) {
					msg.add<uint64_t>(houseData->getBidHolderLimit());
				}
			}
		} else if (houseState == CyclopediaHouseState::Rented) {
			auto ownerName = IOLoginData::getNameByGuid(houseData->getOwner());
			msg.addString(ownerName);
			msg.add<uint32_t>(houseData->getPaidUntil());

			bool rented = ownerName.compare(player->getName()) == 0;
			msg.addByte(rented);
			if (rented) {
				msg.addByte(0);
				msg.addByte(0);
			}
		} else if (houseState == CyclopediaHouseState::Transfer) {
			auto ownerName = IOLoginData::getNameByGuid(houseData->getOwner());
			msg.addString(ownerName);
			msg.add<uint32_t>(houseData->getPaidUntil());

			bool isOwner = ownerName.compare(player->getName()) == 0;
			msg.addByte(isOwner);
			if (isOwner) {
				msg.addByte(0);
				msg.addByte(0);
			}
			msg.add<uint32_t>(houseData->getBidEndDate());
			msg.addString(houseData->getBidderName());
			msg.addByte(0);
			msg.add<uint64_t>(houseData->getInternalBid());

			bool isNewOwner = player->getName() == houseData->getBidderName();
			msg.addByte(isNewOwner);
			if (isNewOwner) {
				uint8_t disableIndex = enumToValue(player->canAcceptTransferHouse(clientId));
				msg.addByte(disableIndex);
				msg.addByte(0);
			}

			if (isOwner) {
				msg.addByte(0);
			}
		} else if (houseState == CyclopediaHouseState::MoveOut) {
			auto ownerName = IOLoginData::getNameByGuid(houseData->getOwner());
			msg.addString(ownerName);
			msg.add<uint32_t>(houseData->getPaidUntil());

			bool isOwner = ownerName.compare(player->getName()) == 0;
			msg.addByte(isOwner);
			if (isOwner) {
				msg.addByte(0);
				msg.addByte(0);
				msg.add<uint32_t>(houseData->getBidEndDate());
				msg.addByte(0);
			} else {
				msg.add<uint32_t>(houseData->getBidEndDate());
			}
		}
	}
}

void CyclopediaHouseMessageBuilder::writeHouseAuctionMessage(NetworkMessage &msg, uint32_t houseId, HouseAuctionType type, uint8_t index, bool bidSuccess) {
	const auto typeValue = enumToValue(type);

	msg.addByte(0xC3);
	msg.add<uint32_t>(houseId);
	msg.addByte(typeValue);
	if (bidSuccess && typeValue == 1) {
		msg.addByte(0x00);
	}
	msg.addByte(index);
}
