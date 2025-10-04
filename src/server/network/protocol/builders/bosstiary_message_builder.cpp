#include "server/network/protocol/builders/bosstiary_message_builder.hpp"

#include "creatures/monsters/monsters.hpp"
#include "creatures/players/player.hpp"
#include "io/io_bosstiary.hpp"
#include "lib/logging/log_with_spd_log.hpp"
#include "server/network/message/outputmessage.hpp"

void BosstiaryMessageBuilder::writeMilestoneData(NetworkMessage &msg) {
	msg.add<uint16_t>(25);
	msg.add<uint16_t>(100);
	msg.add<uint16_t>(300);

	msg.add<uint16_t>(5);
	msg.add<uint16_t>(20);
	msg.add<uint16_t>(60);

	msg.add<uint16_t>(1);
	msg.add<uint16_t>(3);
	msg.add<uint16_t>(5);

	msg.add<uint16_t>(5);
	msg.add<uint16_t>(15);
	msg.add<uint16_t>(30);

	msg.add<uint16_t>(10);
	msg.add<uint16_t>(30);
	msg.add<uint16_t>(60);

	msg.add<uint16_t>(10);
	msg.add<uint16_t>(30);
	msg.add<uint16_t>(60);
}

void BosstiaryMessageBuilder::writeBossEntry(NetworkMessage &msg, uint32_t bossId, BosstiaryRarity_t bossRace, uint32_t killCount, bool isTracked) {
	msg.add<uint32_t>(bossId);
	msg.addByte(static_cast<uint8_t>(bossRace));
	msg.add<uint32_t>(killCount);
	msg.addByte(0);
	msg.addByte(isTracked ? 0x01 : 0x00);
}

void BosstiaryMessageBuilder::writeSlot(NetworkMessage &msg, uint8_t bossRace, uint32_t bossKillCount, uint16_t lootBonus, uint8_t killBonus, uint8_t inactiveFlag, uint32_t removePrice) {
	msg.addByte(bossRace);
	msg.add<uint32_t>(bossKillCount);
	msg.add<uint16_t>(lootBonus);
	msg.addByte(killBonus);
	msg.addByte(bossRace);
	msg.add<uint32_t>(inactiveFlag == 1 ? 0 : removePrice);
	msg.addByte(inactiveFlag);
}

void BosstiaryMessageBuilder::writeTrackedSlot(NetworkMessage &msg, const std::shared_ptr<Player> &player, uint32_t bossId, BosstiaryRarity_t bossRace, uint16_t currentBonus, uint32_t removePrice, uint32_t boostedBossId) {
	if (!player) {
		return;
	}

	const auto bossKillCount = player->getBestiaryKillCount(static_cast<uint16_t>(bossId));
	const auto bossLevel = g_ioBosstiary().getBossCurrentLevel(player, static_cast<uint16_t>(bossId));
	const uint16_t lootBonus = currentBonus + (bossLevel == 3 ? 25 : 0);
	const uint8_t inactiveFlag = bossId == boostedBossId ? 1 : 0;
	writeSlot(msg, static_cast<uint8_t>(bossRace), bossKillCount, lootBonus, 0, inactiveFlag, removePrice);
}

void BosstiaryMessageBuilder::writeBoostedSlot(NetworkMessage &msg, const std::shared_ptr<Player> &player, uint32_t bossId, BosstiaryRarity_t bossRace, uint16_t lootBonus, uint8_t bosstiaryMultiplier, uint8_t boostedKillBonus) {
	if (!player) {
		return;
	}

	const auto bossKillCount = player->getBestiaryKillCount(static_cast<uint16_t>(bossId));
	const uint8_t killBonus = static_cast<uint8_t>(bosstiaryMultiplier + boostedKillBonus);
	writeSlot(msg, static_cast<uint8_t>(bossRace), bossKillCount, lootBonus, killBonus, 0, 0);
}

void BosstiaryMessageBuilder::writeUnlockedList(NetworkMessage &msg, const std::vector<uint16_t> &bosses, uint32_t slotOneBossId, uint32_t slotTwoBossId) {
	const auto unlockCountBuffer = msg.getBufferPosition();
	uint16_t bossesCount = 0;
	msg.skipBytes(2);

	for (const auto bossId : bosses) {
		if (bossId == slotOneBossId || bossId == slotTwoBossId) {
			continue;
		}

		const auto mType = g_ioBosstiary().getMonsterTypeByBossRaceId(bossId);
		if (!mType) {
			g_logger().error("[{}] monster {} not found", __FUNCTION__, bossId);
			continue;
		}

		auto bossRace = mType->info.bosstiaryRace;
		if (bossRace < BosstiaryRarity_t::RARITY_BANE || bossRace > BosstiaryRarity_t::RARITY_NEMESIS) {
			g_logger().error("[{}] monster {} have wrong boss race {}", __FUNCTION__, mType->name, static_cast<uint8_t>(bossRace));
			continue;
		}

		msg.add<uint32_t>(bossId);
		msg.addByte(static_cast<uint8_t>(bossRace));
		++bossesCount;
	}

	msg.setBufferPosition(unlockCountBuffer);
	msg.add<uint16_t>(bossesCount);
}
