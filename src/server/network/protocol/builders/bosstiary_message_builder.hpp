#pragma once

class NetworkMessage;
class Player;

enum class BosstiaryRarity_t : uint8_t;

class BosstiaryMessageBuilder {
public:
	static void writeMilestoneData(NetworkMessage &msg);
	static void writeBossEntry(NetworkMessage &msg, uint32_t bossId, BosstiaryRarity_t bossRace, uint32_t killCount, bool isTracked);
	static void writeSlot(NetworkMessage &msg, uint8_t bossRace, uint32_t bossKillCount, uint16_t lootBonus, uint8_t killBonus, uint8_t inactiveFlag, uint32_t removePrice);
	static void writeTrackedSlot(NetworkMessage &msg, const std::shared_ptr<Player> &player, uint32_t bossId, BosstiaryRarity_t bossRace, uint16_t currentBonus, uint32_t removePrice, uint32_t boostedBossId);
	static void writeBoostedSlot(NetworkMessage &msg, const std::shared_ptr<Player> &player, uint32_t bossId, BosstiaryRarity_t bossRace, uint16_t lootBonus, uint8_t bosstiaryMultiplier, uint8_t boostedKillBonus);
	static void writeUnlockedList(NetworkMessage &msg, const std::vector<uint16_t> &bosses, uint32_t slotOneBossId, uint32_t slotTwoBossId);
};
