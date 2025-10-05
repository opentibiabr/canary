#include "server/network/protocol/builders/outfit_message_builder.hpp"

#include "items/functions/item/custom_attribute.hpp"
#include "items/item.hpp"
#include "server/network/message/outputmessage.hpp"

void OutfitMessageBuilder::build(NetworkMessage &msg, const std::shared_ptr<Item> &item, const CustomAttribute* attribute, const std::string &headKey, const std::string &bodyKey, const std::string &legsKey, const std::string &feetKey, bool addAddon, bool addByte) {
	if (!attribute) {
		if (addByte) {
			msg.add<uint16_t>(0);
		}
		return;
	}

	auto look = attribute->getAttribute<uint16_t>();
	msg.add<uint16_t>(look);
	if (look == 0) {
		if (addByte) {
			msg.add<uint16_t>(0);
		}
		return;
	}

	const auto lookHead = item->getCustomAttribute(headKey);
	const auto lookBody = item->getCustomAttribute(bodyKey);
	const auto lookLegs = item->getCustomAttribute(legsKey);
	const auto lookFeet = item->getCustomAttribute(feetKey);

	msg.addByte(lookHead ? lookHead->getAttribute<uint8_t>() : 0);
	msg.addByte(lookBody ? lookBody->getAttribute<uint8_t>() : 0);
	msg.addByte(lookLegs ? lookLegs->getAttribute<uint8_t>() : 0);
	msg.addByte(lookFeet ? lookFeet->getAttribute<uint8_t>() : 0);

	if (!addAddon) {
		return;
	}

	const auto lookAddons = item->getCustomAttribute("LookAddons");
	msg.addByte(lookAddons ? lookAddons->getAttribute<uint8_t>() : 0);
}
