
#include "server/network/protocol/builders/prey_message_builder.hpp"

#include "config/configmanager.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/players/player.hpp"
#include "core.hpp"
#include "fmt/format.h"
#include "game/game.hpp"
#include "io/ioprey.hpp"
#include "lib/logging/log_with_spd_log.hpp"
#include "server/network/message/outputmessage.hpp"
#include "utils/tools.hpp"

void PreyMessageBuilder::writeTimeLeft(NetworkMessage &msg, const PreySlot &slot) {
	msg.addByte(0xE7);
	msg.addByte(static_cast<uint8_t>(slot.id));
	msg.add<uint16_t>(slot.bonusTimeLeft);
}

bool PreyMessageBuilder::writePreySlot(NetworkMessage &msg, const std::shared_ptr<Player> &player, const std::unique_ptr<PreySlot> &slot, bool oldProtocol) {
	if (!player || !slot) {
		return false;
	}

	msg.addByte(0xE8);

	std::vector<uint16_t> validRaceIds;
	validRaceIds.reserve(slot->raceIdList.size());

	for (uint16_t raceId : slot->raceIdList) {
		if (g_monsters().getMonsterTypeByRaceId(raceId)) {
			validRaceIds.emplace_back(raceId);
			continue;
		}

		g_logger().error("[PreyMessageBuilder::writePreySlot] - Unknown monster type raceid: {}, removing prey slot from player {}", raceId, player->getName());
		slot->removeMonsterType(raceId);

		msg.addByte(0);
		msg.addByte(1);
		msg.add<uint32_t>(0);
		msg.addByte(0);
		return true;
	}

	msg.addByte(static_cast<uint8_t>(slot->id));
	msg.addByte(static_cast<uint8_t>(slot->state));

	if (slot->state == PreyDataState_Locked) {
		msg.addByte(player->isPremium() ? 0x01 : 0x00);
	} else if (slot->state == PreyDataState_Inactive) {
		// Empty
	} else if (slot->state == PreyDataState_Active) {
		if (const auto mtype = g_monsters().getMonsterTypeByRaceId(slot->selectedRaceId)) {
			msg.addString(mtype->name);
			const Outfit_t outfit = mtype->info.outfit;
			msg.add<uint16_t>(outfit.lookType);
			if (outfit.lookType == 0) {
				msg.add<uint16_t>(outfit.lookTypeEx);
			} else {
				msg.addByte(outfit.lookHead);
				msg.addByte(outfit.lookBody);
				msg.addByte(outfit.lookLegs);
				msg.addByte(outfit.lookFeet);
				msg.addByte(outfit.lookAddons);
			}

			msg.addByte(static_cast<uint8_t>(slot->bonus));
			msg.add<uint16_t>(slot->bonusPercentage);
			msg.addByte(slot->bonusRarity);
			msg.add<uint16_t>(slot->bonusTimeLeft);
		}
	} else if (slot->state == PreyDataState_Selection) {
		msg.addByte(static_cast<uint8_t>(validRaceIds.size()));
		for (uint16_t raceId : validRaceIds) {
			const auto mtype = g_monsters().getMonsterTypeByRaceId(raceId);
			if (!mtype) {
				continue;
			}

			msg.addString(mtype->name);
			const Outfit_t outfit = mtype->info.outfit;
			msg.add<uint16_t>(outfit.lookType);
			if (outfit.lookType == 0) {
				msg.add<uint16_t>(outfit.lookTypeEx);
				continue;
			}

			msg.addByte(outfit.lookHead);
			msg.addByte(outfit.lookBody);
			msg.addByte(outfit.lookLegs);
			msg.addByte(outfit.lookFeet);
			msg.addByte(outfit.lookAddons);
		}
	} else if (slot->state == PreyDataState_SelectionChangeMonster) {
		msg.addByte(static_cast<uint8_t>(slot->bonus));
		msg.add<uint16_t>(slot->bonusPercentage);
		msg.addByte(slot->bonusRarity);
		msg.addByte(static_cast<uint8_t>(validRaceIds.size()));
		for (uint16_t raceId : validRaceIds) {
			const auto mtype = g_monsters().getMonsterTypeByRaceId(raceId);
			if (!mtype) {
				continue;
			}

			msg.addString(mtype->name);
			const Outfit_t outfit = mtype->info.outfit;
			msg.add<uint16_t>(outfit.lookType);
			if (outfit.lookType == 0) {
				msg.add<uint16_t>(outfit.lookTypeEx);
				continue;
			}

			msg.addByte(outfit.lookHead);
			msg.addByte(outfit.lookBody);
			msg.addByte(outfit.lookLegs);
			msg.addByte(outfit.lookFeet);
			msg.addByte(outfit.lookAddons);
		}
	} else if (slot->state == PreyDataState_ListSelection) {
		const std::map<uint16_t, std::string> bestiaryList = g_game().getBestiaryList();
		msg.add<uint16_t>(static_cast<uint16_t>(bestiaryList.size()));
		std::for_each(bestiaryList.begin(), bestiaryList.end(), [&msg](auto mType) {
			msg.add<uint16_t>(mType.first);
		});
	} else {
		g_logger().warn("[PreyMessageBuilder::writePreySlot] - Unknown prey state: {}", fmt::underlying(slot->state));
		return false;
	}

	if (oldProtocol) {
		auto currentTime = OTSYS_TIME();
		auto timeDiffMs = (slot->freeRerollTimeStamp > currentTime) ? (slot->freeRerollTimeStamp - currentTime) : 0;
		auto timeDiffMinutes = timeDiffMs / 60000;
		msg.add<uint16_t>(timeDiffMinutes ? timeDiffMinutes : 0);
	} else {
		msg.add<uint32_t>(std::max<uint32_t>(static_cast<uint32_t>(((slot->freeRerollTimeStamp - OTSYS_TIME()) / 1000)), 0));
		msg.addByte(static_cast<uint8_t>(slot->option));
	}

	return true;
}

void PreyMessageBuilder::writePreyPrices(NetworkMessage &msg, const std::shared_ptr<Player> &player, bool oldProtocol) {
	if (!player) {
		return;
	}

	msg.addByte(0xE9);
	msg.add<uint32_t>(player->getPreyRerollPrice());
	if (!oldProtocol) {
		msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(PREY_BONUS_REROLL_PRICE)));
		msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(PREY_SELECTION_LIST_PRICE)));
		msg.add<uint32_t>(player->getTaskHuntingRerollPrice());
		msg.add<uint32_t>(player->getTaskHuntingRerollPrice());
		msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(TASK_HUNTING_SELECTION_LIST_PRICE)));
		msg.addByte(static_cast<uint8_t>(g_configManager().getNumber(TASK_HUNTING_BONUS_REROLL_PRICE)));
	}
}

bool PreyMessageBuilder::writeTaskSlot(NetworkMessage &msg, const std::shared_ptr<Player> &player, const std::unique_ptr<TaskHuntingSlot> &slot) {
	if (!player || !slot) {
		return false;
	}

	msg.addByte(0xBB);
	msg.addByte(static_cast<uint8_t>(slot->id));
	msg.addByte(static_cast<uint8_t>(slot->state));

	if (slot->state == PreyTaskDataState_Locked) {
		msg.addByte(player->isPremium() ? 0x01 : 0x00);
	} else if (slot->state == PreyTaskDataState_Inactive) {
		// Empty
	} else if (slot->state == PreyTaskDataState_Selection) {
		const std::shared_ptr<Player> &user = player;
		msg.add<uint16_t>(static_cast<uint16_t>(slot->raceIdList.size()));
		std::for_each(slot->raceIdList.begin(), slot->raceIdList.end(), [&msg, &user](uint16_t raceid) {
			msg.add<uint16_t>(raceid);
			msg.addByte(user->isCreatureUnlockedOnTaskHunting(g_monsters().getMonsterTypeByRaceId(raceid)) ? 0x01 : 0x00);
		});
	} else if (slot->state == PreyTaskDataState_ListSelection) {
		const std::shared_ptr<Player> &user = player;
		const std::map<uint16_t, std::string> bestiaryList = g_game().getBestiaryList();
		msg.add<uint16_t>(static_cast<uint16_t>(bestiaryList.size()));
		std::for_each(bestiaryList.begin(), bestiaryList.end(), [&msg, &user](auto mType) {
			msg.add<uint16_t>(mType.first);
			msg.addByte(user->isCreatureUnlockedOnTaskHunting(g_monsters().getMonsterType(mType.second)) ? 0x01 : 0x00);
		});
	} else if (slot->state == PreyTaskDataState_Active) {
		if (const auto &option = g_ioprey().getTaskRewardOption(slot)) {
			msg.add<uint16_t>(slot->selectedRaceId);
			if (slot->upgrade) {
				msg.addByte(0x01);
				msg.add<uint16_t>(option->secondKills);
			} else {
				msg.addByte(0x00);
				msg.add<uint16_t>(option->firstKills);
			}
			msg.add<uint16_t>(slot->currentKills);
			msg.addByte(slot->rarity);
		} else {
			g_logger().warn("[PreyMessageBuilder::writeTaskSlot] - Unknown slot option {} on player {}", fmt::underlying(slot->id), player->getName());
			return false;
		}
	} else if (slot->state == PreyTaskDataState_Completed) {
		if (const auto &option = g_ioprey().getTaskRewardOption(slot)) {
			msg.add<uint16_t>(slot->selectedRaceId);
			if (slot->upgrade) {
				msg.addByte(0x01);
				msg.add<uint16_t>(option->secondKills);
				msg.add<uint16_t>(std::min<uint16_t>(slot->currentKills, option->secondKills));
			} else {
				msg.addByte(0x00);
				msg.add<uint16_t>(option->firstKills);
				msg.add<uint16_t>(std::min<uint16_t>(slot->currentKills, option->firstKills));
			}
			msg.addByte(slot->rarity);
		} else {
			g_logger().warn("[PreyMessageBuilder::writeTaskSlot] - Unknown slot option {} on player {}", fmt::underlying(slot->id), player->getName());
			return false;
		}
	} else {
		g_logger().warn("[PreyMessageBuilder::writeTaskSlot] - Unknown task hunting state: {}", fmt::underlying(slot->state));
		return false;
	}

	msg.add<uint32_t>(std::max<uint32_t>(static_cast<uint32_t>(((slot->freeRerollTimeStamp - OTSYS_TIME()) / 1000)), 0));
	return true;
}
