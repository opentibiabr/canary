#pragma once

class Item;
class NetworkMessage;
class Player;

class ImbuementMessageBuilder {
public:
	static void writeImbuementInfo(NetworkMessage &msg, uint16_t imbuementId);
	static void buildOpenWindow(NetworkMessage &msg, const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, bool oldProtocol);
	static void writeInventorySlots(NetworkMessage &msg, const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item);
	static uint8_t writeImbuementIcons(NetworkMessage &msg, const std::shared_ptr<Item> &item);
};
