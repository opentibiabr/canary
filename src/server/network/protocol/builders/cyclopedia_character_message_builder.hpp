#pragma once

#include "creatures/creatures_definitions.hpp"

class ProtocolGame;
class NetworkMessage;
class Player;
struct Achievement;
struct RecentDeathEntry;
struct RecentPvPKillEntry;

class CyclopediaCharacterMessageBuilder {
public:
	static void writeBaseInformation(NetworkMessage &msg, ProtocolGame &protocol, const std::shared_ptr<Player> &player);
	static void writeGeneralStats(NetworkMessage &msg, ProtocolGame &protocol, const std::shared_ptr<Player> &player);
	static void writeRecentDeaths(NetworkMessage &msg, uint16_t page, uint16_t pages, const std::vector<RecentDeathEntry> &entries);
	static void writeRecentPvPKills(NetworkMessage &msg, uint16_t page, uint16_t pages, const std::vector<RecentPvPKillEntry> &entries);
	static void writeAchievements(NetworkMessage &msg, const std::shared_ptr<Player> &player, uint16_t secretsUnlocked, const std::vector<std::pair<Achievement, uint32_t>> &achievementsUnlocked);
	static void writeItemSummary(NetworkMessage &msg, const ItemsTierCountList &inventoryItems, const ItemsTierCountList &storeInboxItems, const StashItemList &stashItems, const ItemsTierCountList &depotBoxItems, const ItemsTierCountList &inboxItems);
	static void writeOutfitsMounts(NetworkMessage &msg, const std::shared_ptr<Player> &player);
	static void writeStoreSummary(NetworkMessage &msg, const std::shared_ptr<Player> &player);
	static void writeInspection(NetworkMessage &msg, ProtocolGame &protocol, const std::shared_ptr<Player> &player);
	static void writeBadges(NetworkMessage &msg, const std::shared_ptr<Player> &player);
	static void writeTitles(NetworkMessage &msg, const std::shared_ptr<Player> &player);
	static void writeOffenceStats(NetworkMessage &msg, ProtocolGame &protocol, const std::shared_ptr<Player> &player);
	static void writeDefenceStats(NetworkMessage &msg, ProtocolGame &protocol, const std::shared_ptr<Player> &player);
	static void writeMiscStats(NetworkMessage &msg, ProtocolGame &protocol, const std::shared_ptr<Player> &player);
};
