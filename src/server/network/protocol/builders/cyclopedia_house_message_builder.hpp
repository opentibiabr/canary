#pragma once

class NetworkMessage;
class Player;
class House;

using HouseMap = std::map<uint32_t, std::shared_ptr<House>>;

enum class HouseAuctionType : uint8_t;

enum class CyclopediaHouseState : uint8_t;

class CyclopediaHouseMessageBuilder {
public:
	static void writeHouseList(NetworkMessage &msg, const std::shared_ptr<Player> &player, const HouseMap &houses);
	static void writeHouseAuctionMessage(NetworkMessage &msg, uint32_t houseId, HouseAuctionType type, uint8_t index, bool bidSuccess);
};
