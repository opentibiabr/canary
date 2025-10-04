#pragma once

class CustomAttribute;
class Item;

class NetworkMessage;

class OutfitMessageBuilder {
public:
	static void build(NetworkMessage &msg, const std::shared_ptr<Item> &item, const CustomAttribute* attribute, const std::string &headKey, const std::string &bodyKey, const std::string &legsKey, const std::string &feetKey, bool addAddon = false, bool addByte = false);
};
