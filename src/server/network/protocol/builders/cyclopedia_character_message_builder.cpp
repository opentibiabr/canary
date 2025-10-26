#include "server/network/protocol/builders/cyclopedia_character_message_builder.hpp"

#include "core.hpp"
#include "creatures/appearance/mounts/mounts.hpp"
#include "creatures/appearance/outfit/outfit.hpp"
#include "creatures/combat/condition.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/players/components/player_achievement.hpp"
#include "creatures/players/components/player_cyclopedia.hpp"
#include "creatures/players/grouping/familiars.hpp"
#include "creatures/players/player.hpp"
#include "creatures/players/vocations/vocation.hpp"
#include "game/game.hpp"
#include "io/iologindata.hpp"
#include "io/ioprey.hpp"
#include "items/item.hpp"
#include "items/items_definitions.hpp"
#include "kv/kv.hpp"
#include "lib/logging/log_with_spd_log.hpp"
#include "server/network/message/outputmessage.hpp"
#include "server/network/protocol/builders/imbuement_damage_encoder.hpp"
#include "server/network/protocol/builders/imbuement_message_builder.hpp"
#include "server/network/protocol/protocolgame.hpp"
#include "utils/tools.hpp"
#include "enums/player_blessings.hpp"
#include "enums/player_cyclopedia.hpp"
#include "fmt/format.h"

namespace {
	void addCyclopediaSkills(const std::shared_ptr<Player> &player, NetworkMessage &msg, skills_t skill) {
		const auto skillTotal = player->getSkillLevel(skill);
		const auto &playerItem = player->getInventoryItem(CONST_SLOT_LEFT);
		double skillEquipment = 0.0;
		if (playerItem) {
			skillEquipment = playerItem->getSkill(skill);
		}

		double skillWheel = 0.0;
		const auto &playerWheel = player->wheel();
		if (skill == SKILL_LIFE_LEECH_AMOUNT) {
			skillWheel = playerWheel.getStat(WheelStat_t::LIFE_LEECH);
		} else if (skill == SKILL_MANA_LEECH_AMOUNT) {
			skillWheel = playerWheel.getStat(WheelStat_t::MANA_LEECH);
		} else if (skill == SKILL_CRITICAL_HIT_DAMAGE) {
			skillWheel = playerWheel.getStat(WheelStat_t::CRITICAL_DAMAGE);
			skillWheel += playerWheel.getMajorStatConditional("Combat Mastery", WheelMajor_t::CRITICAL_DMG_2);
			skillWheel += playerWheel.getMajorStatConditional("Ballistic Mastery", WheelMajor_t::CRITICAL_DMG);
			skillWheel += playerWheel.checkAvatarSkill(WheelAvatarSkill_t::CRITICAL_DAMAGE);
		}

		double skillImbuement = skillTotal - skillEquipment - skillWheel;

		msg.addDouble(skillTotal / 10000.);
		msg.addDouble(skillEquipment / 10000.);
		msg.addDouble(skillImbuement / 10000.);
		msg.addDouble(skillWheel / 10000.);
		msg.addDouble(0.00);
	}
} // namespace

void CyclopediaCharacterMessageBuilder::writeBaseInformation(NetworkMessage &msg, ProtocolGame &protocol, const std::shared_ptr<Player> &player) {
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_BASEINFORMATION);
	msg.addByte(0x00);
	msg.addString(player->getName());
	msg.addString(player->getVocation()->getVocName());
	msg.add<uint16_t>(player->getLevel());
	protocol.AddOutfit(msg, player->getDefaultOutfit(), false);

	msg.addByte(0x01);
	msg.addString(player->title().getCurrentTitleName());
}

void CyclopediaCharacterMessageBuilder::writeGeneralStats(NetworkMessage &msg, ProtocolGame &protocol, const std::shared_ptr<Player> &player) {
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_GENERALSTATS);
	msg.addByte(0x00);

	msg.add<uint64_t>(player->getExperience());
	msg.add<uint16_t>(player->getLevel());
	msg.addByte(player->getLevelPercent());
	msg.add<uint16_t>(player->getBaseXpGain());
	msg.add<uint16_t>(player->getDisplayGrindingXpBoost());
	msg.add<uint16_t>(player->getDisplayXpBoostPercent());
	msg.add<uint16_t>(player->getStaminaXpBoost());
	msg.add<uint16_t>(player->getXpBoostTime());
	msg.addByte(player->getXpBoostTime() > 0 ? 0x00 : 0x01);
	msg.add<uint32_t>(std::min<int32_t>(player->getHealth(), std::numeric_limits<uint16_t>::max()));
	msg.add<uint32_t>(std::min<int32_t>(player->getMaxHealth(), std::numeric_limits<uint16_t>::max()));
	msg.add<uint32_t>(std::min<int32_t>(player->getMana(), std::numeric_limits<uint16_t>::max()));
	msg.add<uint32_t>(std::min<int32_t>(player->getMaxMana(), std::numeric_limits<uint16_t>::max()));
	msg.addByte(player->getSoul());
	msg.add<uint16_t>(player->getStaminaMinutes());

	std::shared_ptr<Condition> condition = player->getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT);
	msg.add<uint16_t>(condition ? condition->getTicks() / 1000 : 0x00);
	msg.add<uint16_t>(player->getOfflineTrainingTime() / 60 / 1000);
	msg.add<uint16_t>(player->getSpeed());
	msg.add<uint16_t>(player->getBaseSpeed());
	msg.add<uint32_t>(player->getCapacity());
	msg.add<uint32_t>(player->getBaseCapacity());
	msg.add<uint32_t>(player->hasFlag(PlayerFlags_t::HasInfiniteCapacity) ? 1000000 : player->getFreeCapacity());
	msg.addByte(8);
	msg.addByte(1);
	msg.add<uint16_t>(player->getMagicLevel());
	msg.add<uint16_t>(player->getBaseMagicLevel());
	msg.add<uint16_t>(player->getLoyaltyMagicLevel());
	msg.add<uint16_t>(player->getMagicLevelPercent() * 100);

	for (uint8_t i = SKILL_FIRST; i < SKILL_CRITICAL_HIT_CHANCE; ++i) {
		static const uint8_t HardcodedSkillIds[] = { 11, 9, 8, 10, 7, 6, 13 };
		const auto skill = static_cast<skills_t>(i);
		msg.addByte(HardcodedSkillIds[i]);
		msg.add<uint16_t>(std::min<int32_t>(player->getSkillLevel(skill), std::numeric_limits<uint16_t>::max()));
		msg.add<uint16_t>(player->getBaseSkill(skill));
		msg.add<uint16_t>(player->getLoyaltySkill(skill));
		msg.add<uint16_t>(player->getSkillPercent(skill) * 100);
	}

	auto bufferPosition = msg.getBufferPosition();
	msg.skipBytes(1);
	uint8_t total = 0;
	for (size_t i = 0; i < COMBAT_COUNT; i++) {
		auto specializedMagicLevel = player->getSpecializedMagicLevel(indexToCombatType(i));
		if (specializedMagicLevel > 0) {
			++total;
			msg.addByte(getCipbiaElement(indexToCombatType(i)));
			msg.add<uint16_t>(specializedMagicLevel);
		}
	}
	msg.setBufferPosition(bufferPosition);
	msg.addByte(total);
}

void CyclopediaCharacterMessageBuilder::writeRecentDeaths(NetworkMessage &msg, uint16_t page, uint16_t pages, const std::vector<RecentDeathEntry> &entries) {
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_RECENTDEATHS);
	msg.addByte(0x00);
	msg.add<uint16_t>(page);
	msg.add<uint16_t>(pages);
	msg.add<uint16_t>(entries.size());
	for (const RecentDeathEntry &entry : entries) {
		msg.add<uint32_t>(entry.timestamp);
		msg.addString(entry.cause);
	}
}

void CyclopediaCharacterMessageBuilder::writeRecentPvPKills(NetworkMessage &msg, uint16_t page, uint16_t pages, const std::vector<RecentPvPKillEntry> &entries) {
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_RECENTPVPKILLS);
	msg.addByte(0x00);
	msg.add<uint16_t>(page);
	msg.add<uint16_t>(pages);
	msg.add<uint16_t>(entries.size());
	for (const RecentPvPKillEntry &entry : entries) {
		msg.add<uint32_t>(entry.timestamp);
		msg.addString(entry.description);
		msg.addByte(entry.status);
	}
}

void CyclopediaCharacterMessageBuilder::writeAchievements(NetworkMessage &msg, const std::shared_ptr<Player> &player, uint16_t secretsUnlocked, const std::vector<std::pair<Achievement, uint32_t>> &achievementsUnlocked) {
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_ACHIEVEMENTS);
	msg.addByte(0x00);
	msg.add<uint16_t>(player->achiev().getPoints());
	msg.add<uint16_t>(secretsUnlocked);
	msg.add<uint16_t>(static_cast<uint16_t>(achievementsUnlocked.size()));
	for (const auto &[achievement, addedTimestamp] : achievementsUnlocked) {
		msg.add<uint16_t>(achievement.id);
		msg.add<uint32_t>(addedTimestamp);
		if (achievement.secret) {
			msg.addByte(0x01);
			msg.addString(achievement.name);
			msg.addString(achievement.description);
			msg.addByte(achievement.grade);
		} else {
			msg.addByte(0x00);
		}
	}
}

void CyclopediaCharacterMessageBuilder::writeItemSummary(NetworkMessage &msg, const ItemsTierCountList &inventoryItems, const ItemsTierCountList &storeInboxItems, const StashItemList &stashItems, const ItemsTierCountList &depotBoxItems, const ItemsTierCountList &inboxItems) {
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_ITEMSUMMARY);
	msg.addByte(0x00);

	uint16_t inventoryItemsCount = 0;
	const auto startInventory = msg.getBufferPosition();
	msg.skipBytes(2);

	for (const auto &inventoryItems_it : inventoryItems) {
		for (const auto &[itemTier, itemCount] : inventoryItems_it.second) {
			const ItemType &it = Item::items[inventoryItems_it.first];
			msg.add<uint16_t>(inventoryItems_it.first);
			if (it.upgradeClassification > 0) {
				msg.addByte(itemTier);
			}
			msg.add<uint32_t>(itemCount);

			++inventoryItemsCount;
		}
	}

	const auto endInventory = msg.getBufferPosition();

	msg.setBufferPosition(startInventory);
	msg.add<uint16_t>(inventoryItemsCount);

	msg.setBufferPosition(endInventory);

	uint16_t storeInboxItemsCount = 0;
	const auto startStoreInbox = msg.getBufferPosition();
	msg.skipBytes(2);

	for (const auto &storeInboxItems_it : storeInboxItems) {
		for (const auto &[itemTier, itemCount] : storeInboxItems_it.second) {
			const ItemType &it = Item::items[storeInboxItems_it.first];
			msg.add<uint16_t>(storeInboxItems_it.first);
			if (it.upgradeClassification > 0) {
				msg.addByte(itemTier);
			}
			msg.add<uint32_t>(itemCount);

			++storeInboxItemsCount;
		}
	}

	const auto endStoreInbox = msg.getBufferPosition();

	msg.setBufferPosition(startStoreInbox);
	msg.add<uint16_t>(storeInboxItemsCount);

	msg.setBufferPosition(endStoreInbox);

	msg.add<uint16_t>(stashItems.size());

	for (const auto &[itemId, itemCount] : stashItems) {
		const ItemType &it = Item::items[itemId];
		msg.add<uint16_t>(itemId);
		if (it.upgradeClassification > 0) {
			msg.addByte(0x00);
		}
		msg.add<uint32_t>(itemCount);
	}

	uint16_t depotBoxItemsCount = 0;
	const auto startDepotBox = msg.getBufferPosition();
	msg.skipBytes(2);

	for (const auto &depotBoxItems_it : depotBoxItems) {
		for (const auto &[itemTier, itemCount] : depotBoxItems_it.second) {
			const ItemType &it = Item::items[depotBoxItems_it.first];
			msg.add<uint16_t>(depotBoxItems_it.first);
			if (it.upgradeClassification > 0) {
				msg.addByte(itemTier);
			}
			msg.add<uint32_t>(itemCount);

			++depotBoxItemsCount;
		}
	}

	const auto endDepotBox = msg.getBufferPosition();

	msg.setBufferPosition(startDepotBox);
	msg.add<uint16_t>(depotBoxItemsCount);

	msg.setBufferPosition(endDepotBox);

	uint16_t inboxItemsCount = 0;
	const auto startInbox = msg.getBufferPosition();
	msg.skipBytes(2);

	for (const auto &inboxItems_it : inboxItems) {
		for (const auto &[itemTier, itemCount] : inboxItems_it.second) {
			const ItemType &it = Item::items[inboxItems_it.first];
			msg.add<uint16_t>(inboxItems_it.first);
			if (it.upgradeClassification > 0) {
				msg.addByte(itemTier);
			}
			msg.add<uint32_t>(itemCount);

			++inboxItemsCount;
		}
	}

	msg.setBufferPosition(startInbox);
	msg.add<uint16_t>(inboxItemsCount);
}

void CyclopediaCharacterMessageBuilder::writeOutfitsMounts(NetworkMessage &msg, const std::shared_ptr<Player> &player) {
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITSMOUNTS);
	msg.addByte(0x00);
	Outfit_t currentOutfit = player->getDefaultOutfit();

	uint16_t outfitSize = 0;
	auto startOutfits = msg.getBufferPosition();
	msg.skipBytes(2);

	const auto outfits = Outfits::getInstance().getOutfits(player->getSex());
	for (const auto &outfit : outfits) {
		uint8_t addons;
		if (!player->getOutfitAddons(outfit, addons)) {
			continue;
		}
		const std::string from = outfit->from;
		++outfitSize;

		msg.add<uint16_t>(outfit->lookType);
		msg.addString(outfit->name);
		msg.addByte(addons);
		if (from == "store") {
			msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_STORE);
		} else if (from == "quest") {
			msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_QUEST);
		} else {
			msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_NONE);
		}
		if (outfit->lookType == currentOutfit.lookType) {
			msg.add<uint32_t>(1000);
		} else {
			msg.add<uint32_t>(0);
		}
	}
	if (outfitSize > 0) {
		msg.addByte(currentOutfit.lookHead);
		msg.addByte(currentOutfit.lookBody);
		msg.addByte(currentOutfit.lookLegs);
		msg.addByte(currentOutfit.lookFeet);
	}

	uint16_t mountSize = 0;
	auto startMounts = msg.getBufferPosition();
	msg.skipBytes(2);
	for (const auto &mount : g_game().mounts->getMounts()) {
		const std::string type = mount->type;
		if (player->hasMount(mount)) {
			++mountSize;

			msg.add<uint16_t>(mount->clientId);
			msg.addString(mount->name);
			if (type == "store") {
				msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_STORE);
			} else if (type == "quest") {
				msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_QUEST);
			} else {
				msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_NONE);
			}
			msg.add<uint32_t>(1000);
		}
	}
	if (mountSize > 0) {
		msg.addByte(currentOutfit.lookMountHead);
		msg.addByte(currentOutfit.lookMountBody);
		msg.addByte(currentOutfit.lookMountLegs);
		msg.addByte(currentOutfit.lookMountFeet);
	}

	uint16_t familiarsSize = 0;
	auto startFamiliars = msg.getBufferPosition();
	msg.skipBytes(2);
	const auto familiars = Familiars::getInstance().getFamiliars(player->getVocationId());
	for (const auto &familiar : familiars) {
		const std::string type = familiar->type;
		if (!player->getFamiliar(familiar)) {
			continue;
		}
		++familiarsSize;
		msg.add<uint16_t>(familiar->lookType);
		msg.addString(familiar->name);
		if (type == "quest") {
			msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_QUEST);
		} else {
			msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_NONE);
		}
		msg.add<uint32_t>(0);
	}

	msg.setBufferPosition(startOutfits);
	msg.add<uint16_t>(outfitSize);
	msg.setBufferPosition(startMounts);
	msg.add<uint16_t>(mountSize);
	msg.setBufferPosition(startFamiliars);
	msg.add<uint16_t>(familiarsSize);
}

void CyclopediaCharacterMessageBuilder::writeStoreSummary(NetworkMessage &msg, const std::shared_ptr<Player> &player) {
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_STORESUMMARY);
	msg.addByte(0x00);
	msg.add<uint32_t>(player->getXpBoostTime());
	auto remaining = player->kv()->get("daily-reward-xp-boost");
	msg.add<uint32_t>(remaining ? static_cast<uint32_t>(remaining->getNumber()) : 0);

	auto cyclopediaSummary = player->cyclopedia().getSummary();

	msg.addByte(static_cast<uint8_t>(magic_enum::enum_count<Blessings>()));
	for (auto bless : magic_enum::enum_values<Blessings>()) {
		std::string name = toStartCaseWithSpace(magic_enum::enum_name(bless).data());
		msg.addString(name);
		auto blessValue = enumToValue(bless);
		msg.addByte(player->hasBlessing(blessValue) ? player->getBlessingCount(blessValue) : 0x00);
	}

	uint8_t preySlotsUnlocked = 0;
	if (const auto &slotP = player->getPreySlotById(PreySlot_Three);
	    slotP && slotP->state != PreyDataState_Locked) {
		preySlotsUnlocked++;
	}
	if (const auto &slotH = player->getTaskHuntingSlotById(PreySlot_Three);
	    slotH && slotH->state != PreyTaskDataState_Locked) {
		preySlotsUnlocked++;
	}
	msg.addByte(preySlotsUnlocked);

	msg.addByte(cyclopediaSummary.m_preyWildcards);
	msg.addByte(cyclopediaSummary.m_instantRewards);
	msg.addByte(player->hasCharmExpansion() ? 0x01 : 0x00);
	msg.addByte(cyclopediaSummary.m_hirelings);

	std::vector<uint16_t> m_hSkills;
	for (const auto &it : g_game().getHirelingSkills()) {
		if (player->kv()->scoped("hireling-skills")->get(it.second)) {
			m_hSkills.emplace_back(it.first);
			g_logger().debug("skill id: {}, name: {}", it.first, it.second);
		}
	}
	msg.addByte(m_hSkills.size());
	for (const auto &id : m_hSkills) {
		msg.addByte(id - 1000);
	}

	msg.addByte(0x00);

	auto houseItems = player->cyclopedia().getResult(static_cast<uint8_t>(Summary_t::HOUSE_ITEMS));
	msg.add<uint16_t>(houseItems.size());
	for (const auto &hItem_it : houseItems) {
		const ItemType &it = Item::items[hItem_it.first];
		msg.add<uint16_t>(it.id);
		msg.addString(it.name);
		msg.addByte(hItem_it.second);
	}
}

void CyclopediaCharacterMessageBuilder::writeInspection(NetworkMessage &msg, ProtocolGame &protocol, const std::shared_ptr<Player> &player) {
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_INSPECTION);
	msg.addByte(0x00);
	uint8_t inventoryItems = 0;
	auto startInventory = msg.getBufferPosition();
	msg.skipBytes(1);
	for (std::underlying_type<Slots_t>::type slot = CONST_SLOT_FIRST; slot <= CONST_SLOT_LAST; slot++) {
		std::shared_ptr<Item> inventoryItem = player->getInventoryItem(static_cast<Slots_t>(slot));
		if (inventoryItem) {
			++inventoryItems;

			msg.addByte(slot);
			msg.addString(inventoryItem->getName());
			protocol.AddItem(msg, inventoryItem);

			auto startImbuements = msg.getBufferPosition();
			msg.skipBytes(1);
			auto itemImbuements = ImbuementMessageBuilder::writeImbuementIcons(msg, inventoryItem);
			auto endImbuements = msg.getBufferPosition();
			msg.setBufferPosition(startImbuements);
			msg.addByte(itemImbuements);
			msg.setBufferPosition(endImbuements);

			auto descriptions = Item::getDescriptions(Item::items[inventoryItem->getID()], inventoryItem);
			msg.addByte(descriptions.size());
			for (const auto &description : descriptions) {
				msg.addString(description.first);
				msg.addString(description.second);
			}
		}
	}
	msg.addString(player->getName());
	protocol.AddOutfit(msg, player->getDefaultOutfit(), false);

	uint8_t playerDescriptionSize = 0;
	auto playerDescriptionPosition = msg.getBufferPosition();
	msg.skipBytes(1);

	if (player->title().getCurrentTitle() != 0) {
		playerDescriptionSize++;
		msg.addString("Character Title");
		msg.addString(player->title().getCurrentTitleName());
	}

	playerDescriptionSize++;
	msg.addString("Level");
	msg.addString(std::to_string(player->getLevel()));

	playerDescriptionSize++;
	msg.addString("Vocation");
	msg.addString(player->getVocation()->getVocName());

	if (!player->getLoyaltyTitle().empty()) {
		playerDescriptionSize++;
		msg.addString("Loyalty Title");
		msg.addString(player->getLoyaltyTitle());
	}

	if (const auto spouseId = player->getMarriageSpouseId(); spouseId > 0) {
		if (const auto &spouse = g_game().getPlayerByID(spouseId, true); spouse) {
			playerDescriptionSize++;
			msg.addString("Married to");
			msg.addString(spouse->getName());
		}
	}

	for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
		if (const auto &slot = player->getPreySlotById(static_cast<PreySlot_t>(slotId));
		    slot && slot->isOccupied()) {
			playerDescriptionSize++;
			std::string activePrey = fmt::format("Active Prey {}", slotId + 1);
			msg.addString(activePrey);

			std::string desc;
			if (auto mtype = g_monsters().getMonsterTypeByRaceId(slot->selectedRaceId)) {
				desc.append(mtype->name);
			} else {
				desc.append("Unknown creature");
			}

			if (slot->bonus == PreyBonus_Damage) {
				desc.append(" (Improved Damage +");
			} else if (slot->bonus == PreyBonus_Defense) {
				desc.append(" (Improved Defense +");
			} else if (slot->bonus == PreyBonus_Experience) {
				desc.append(" (Improved Experience +");
			} else if (slot->bonus == PreyBonus_Loot) {
				desc.append(" (Improved Loot +");
			}
			desc.append(fmt::format("{}%, remaining", slot->bonusPercentage));
			uint8_t hours = slot->bonusTimeLeft / 3600;
			uint8_t minutes = (slot->bonusTimeLeft - (hours * 3600)) / 60;
			desc.append(fmt::format("{}:{}{}h", hours, (minutes < 10 ? "0" : ""), minutes));
			msg.addString(desc);
		}
	}

	playerDescriptionSize++;
	msg.addString("Outfit");
	if (const auto outfit = Outfits::getInstance().getOutfitByLookType(player, player->getDefaultOutfit().lookType)) {
		msg.addString(outfit->name);
	} else {
		msg.addString("unknown");
	}

	msg.setBufferPosition(startInventory);
	msg.addByte(inventoryItems);

	msg.setBufferPosition(playerDescriptionPosition);
	msg.addByte(playerDescriptionSize);
}

void CyclopediaCharacterMessageBuilder::writeBadges(NetworkMessage &msg, const std::shared_ptr<Player> &player) {
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_BADGES);
	msg.addByte(0x00);
	msg.addByte(0x01);

	const auto loggedPlayer = g_game().getPlayerByName(player->getName());
	msg.addByte(loggedPlayer ? 0x01 : 0x00);
	msg.addByte(player->isPremium() ? 0x01 : 0x00);
	msg.addString(player->getLoyaltyTitle());

	uint8_t badgesSize = 0;
	auto badgesSizePosition = msg.getBufferPosition();
	msg.skipBytes(1);
	for (const auto &badge : g_game().getBadges()) {
		if (player->badge().hasBadge(badge.m_id)) {
			msg.add<uint32_t>(badge.m_id);
			msg.addString(badge.m_name);
			badgesSize++;
		}
	}

	msg.setBufferPosition(badgesSizePosition);
	msg.addByte(badgesSize);
}

void CyclopediaCharacterMessageBuilder::writeTitles(NetworkMessage &msg, const std::shared_ptr<Player> &player) {
	auto titles = g_game().getTitles();

	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_TITLES);
	msg.addByte(0x00);
	msg.addByte(player->title().getCurrentTitle());
	msg.addByte(static_cast<uint8_t>(titles.size()));
	for (const auto &title : titles) {
		msg.addByte(title.m_id);
		auto titleName = player->title().getNameBySex(player->getSex(), title.m_maleName, title.m_femaleName);
		msg.addString(titleName);
		msg.addString(title.m_description);
		msg.addByte(title.m_permanent ? 0x01 : 0x00);
		auto isUnlocked = player->title().isTitleUnlocked(title.m_id);
		msg.addByte(isUnlocked ? 0x01 : 0x00);
	}
}

void CyclopediaCharacterMessageBuilder::writeOffenceStats(NetworkMessage &msg, ProtocolGame &protocol, const std::shared_ptr<Player> &player) {
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_OFFENCESTATS);
	msg.addByte(0x00);

	msg.addDouble(player->getSkillLevel(SKILL_CRITICAL_HIT_CHANCE) / 10000.);
	msg.addDouble(0.00);
	msg.addDouble(0.00);
	msg.addDouble(0.00);
	msg.addDouble(0.00);

	addCyclopediaSkills(player, msg, SKILL_CRITICAL_HIT_DAMAGE);
	addCyclopediaSkills(player, msg, SKILL_LIFE_LEECH_AMOUNT);
	addCyclopediaSkills(player, msg, SKILL_MANA_LEECH_AMOUNT);

	msg.addDouble(protocol.getForgeSkillStat(CONST_SLOT_LEFT));
	msg.addDouble(protocol.getForgeSkillStat(CONST_SLOT_LEFT, false));
	msg.addDouble(protocol.getForgeSkillStat(CONST_SLOT_LEFT) - protocol.getForgeSkillStat(CONST_SLOT_LEFT, false));
	msg.addDouble(0.00);

	msg.addDouble(player->getCleavePercent() / 100.);

	for (uint8_t range = 1; range <= 5; range++) {
		msg.add<uint16_t>(static_cast<uint16_t>(player->getPerfectShotDamage(range)));
	}

	const auto flatBonus = player->calculateFlatDamageHealing();
	msg.add<uint16_t>(flatBonus);
	msg.add<uint16_t>(flatBonus);
	msg.add<uint16_t>(0x00);

	std::shared_ptr<Item> weapon = player->getWeapon(true);
	if (weapon) {
		const ItemType &it = Item::items[weapon->getID()];
		if (it.weaponType == WEAPON_WAND) {
			msg.add<uint16_t>(it.maxHitChance);
			msg.add<uint16_t>(0);
			msg.add<uint16_t>(0);
			msg.addByte(0x00);
			msg.add<uint16_t>(0);
			msg.add<uint16_t>(0);
			msg.addByte(getCipbiaElement(it.combatType));
			msg.addDouble(0.0);
			msg.addByte(0x00);
			msg.addByte(0x00);
		} else if (it.weaponType == WEAPON_DISTANCE || it.weaponType == WEAPON_AMMO || it.weaponType == WEAPON_MISSILE) {
			int32_t physicalAttack = std::max<int32_t>(0, weapon->getAttack());
			int32_t elementalAttack = 0;
			if (it.abilities && it.abilities->elementType != COMBAT_NONE) {
				elementalAttack = std::max<int32_t>(0, it.abilities->elementDamage);
			}
			int32_t attackValue = physicalAttack + elementalAttack;
			if (it.weaponType == WEAPON_AMMO) {
				std::shared_ptr<Item> weaponItem = player->getWeapon(true);
				if (weaponItem) {
					attackValue += weaponItem->getAttack();
				}
			}

			int32_t distanceValue = player->getSkillLevel(SKILL_DISTANCE);
			int32_t attackSkill = player->getDistanceAttackSkill(distanceValue, attackValue);
			const auto attackRawTotal = player->attackRawTotal(flatBonus, attackValue, distanceValue);
			const auto attackTotal = player->attackTotal(flatBonus, attackValue, distanceValue);

			msg.add<uint16_t>(attackTotal);
			msg.add<uint16_t>(flatBonus);
			msg.add<uint16_t>(static_cast<uint16_t>(attackValue));
			msg.addByte(0x07);
			msg.add<uint16_t>(attackSkill);
			msg.add<uint16_t>(attackTotal - attackRawTotal);
			msg.addByte(CIPBIA_ELEMENTAL_PHYSICAL);

			if (it.abilities && it.abilities->elementType != COMBAT_NONE) {
				if (physicalAttack) {
					msg.addDouble(elementalAttack / static_cast<double>(attackValue));
				} else {
					msg.addDouble(0.0);
				}
				msg.addByte(getCipbiaElement(it.abilities->elementType));
			} else {
				ImbuementDamageEncoder::writeDamage(msg, player);
			}

			const auto distanceAccuracy = player->getDamageAccuracy(it);
			const auto distanceAccuracySize = distanceAccuracy.size();
			msg.addByte(distanceAccuracy.size());
			for (uint8_t i = 0; i < distanceAccuracySize; ++i) {
				msg.addByte(i + 1);
				msg.addDouble(distanceAccuracy[i] / 100.);
			}
		} else {
			int32_t physicalAttack = std::max<int32_t>(0, weapon->getAttack());
			int32_t elementalAttack = 0;
			if (it.abilities && it.abilities->elementType != COMBAT_NONE) {
				elementalAttack = std::max<int32_t>(0, it.abilities->elementDamage);
			}
			int32_t weaponAttack = physicalAttack + elementalAttack;
			int32_t weaponSkill = player->getWeaponSkill(weapon);
			int32_t attackSkill = player->getAttackSkill(weapon);
			uint8_t skillId = player->getWeaponSkillId(weapon);
			const auto attackRawTotal = player->attackRawTotal(flatBonus, weaponAttack, weaponSkill);
			const auto attackTotal = player->attackTotal(flatBonus, weaponAttack, weaponSkill);

			msg.add<uint16_t>(attackTotal);
			msg.add<uint16_t>(flatBonus);
			msg.add<uint16_t>(static_cast<uint16_t>(weaponAttack));
			msg.addByte(skillId);
			msg.add<uint16_t>(attackSkill);
			msg.add<uint16_t>(attackTotal - attackRawTotal);
			msg.addByte(CIPBIA_ELEMENTAL_PHYSICAL);

			if (it.abilities && it.abilities->elementType != COMBAT_NONE) {
				if (physicalAttack) {
					msg.addDouble(elementalAttack / static_cast<double>(weaponAttack));
				} else {
					msg.addDouble(0);
				}
				msg.addByte(getCipbiaElement(it.abilities->elementType));
			} else {
				ImbuementDamageEncoder::writeDamage(msg, player);
			}
			msg.addByte(0x00);
		}
	} else {
		uint16_t attackValue = 7;
		int32_t fistValue = player->getSkillLevel(SKILL_FIST);
		int32_t attackSkill = player->getDistanceAttackSkill(fistValue, attackValue);
		const auto attackRawTotal = player->attackRawTotal(flatBonus, attackValue, fistValue);
		const auto attackTotal = player->attackTotal(flatBonus, attackValue, fistValue);

		msg.add<uint16_t>(attackTotal);
		msg.add<uint16_t>(flatBonus);
		msg.add<uint16_t>(attackValue);
		msg.addByte(11);
		msg.add<uint16_t>(attackSkill);
		msg.add<uint16_t>(attackTotal - attackRawTotal);
		msg.addByte(CIPBIA_ELEMENTAL_PHYSICAL);

		msg.addDouble(0.0);
		msg.addByte(0x00);
		msg.addByte(0x00);
	}
}

void CyclopediaCharacterMessageBuilder::writeDefenceStats(NetworkMessage &msg, ProtocolGame &protocol, const std::shared_ptr<Player> &player) {
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_DEFENCESTATS);
	msg.addByte(0x00);

	const double dodgeTotal = protocol.getForgeSkillStat(CONST_SLOT_ARMOR) + player->wheel().getStat(WheelStat_t::DODGE);
	msg.addDouble(dodgeTotal);
	msg.addDouble(protocol.getForgeSkillStat(CONST_SLOT_ARMOR, false));
	msg.addDouble(protocol.getForgeSkillStat(CONST_SLOT_ARMOR) - protocol.getForgeSkillStat(CONST_SLOT_ARMOR, false));
	msg.addDouble(0.00);
	msg.addDouble(player->wheel().getStat(WheelStat_t::DODGE));

	msg.add<uint32_t>(player->getMagicShieldCapacityFlat() * (1 + player->getMagicShieldCapacityPercent()));
	msg.add<uint16_t>(static_cast<uint16_t>(player->getMagicShieldCapacityFlat()));
	msg.addDouble(player->getMagicShieldCapacityPercent());

	msg.add<uint16_t>(static_cast<uint16_t>(player->getReflectFlat(COMBAT_PHYSICALDAMAGE)));

	msg.add<uint16_t>(player->getArmor());

	const auto shieldingSkill = player->getSkillLevel(SKILL_SHIELD);
	const uint16_t defenseWheel = player->wheel().getMajorStatConditional("Combat Mastery", WheelMajor_t::DEFENSE);
	msg.add<uint16_t>(player->getDefense(true));
	msg.add<uint16_t>(player->getDefenseEquipment());
	msg.addByte(0x06);
	msg.add<uint16_t>(shieldingSkill);
	msg.add<uint16_t>(defenseWheel);
	msg.add<uint16_t>(0);

	const auto wheelMultiplier = player->wheel().getMitigationMultiplier();
	msg.addDouble(player->getMitigation() / 100.);
	msg.addDouble(0.0);
	msg.addDouble(player->getDefenseEquipment() / 10000.);
	msg.addDouble(player->getSkillLevel(SKILL_SHIELD) * player->getVocation()->mitigationFactor / 10000.);
	msg.addDouble(wheelMultiplier / 100.);
	msg.addDouble(player->getCombatTacticsMitigation());

	uint8_t combats = 0;
	auto startCombats = msg.getBufferPosition();
	msg.skipBytes(1);

	ImbuementDamageEncoder::writeAbsorbValues(player, msg, combats);

	auto endCombats = msg.getBufferPosition();
	msg.setBufferPosition(startCombats);
	msg.addByte(combats);
	msg.setBufferPosition(endCombats);
}

void CyclopediaCharacterMessageBuilder::writeMiscStats(NetworkMessage &msg, ProtocolGame &protocol, const std::shared_ptr<Player> &player) {
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_MISCSTATS);
	msg.addByte(0x00);

	const double momentumTotal = protocol.getForgeSkillStat(CONST_SLOT_HEAD) + player->wheel().getBonusData().momentum;
	msg.addDouble(momentumTotal);
	msg.addDouble(protocol.getForgeSkillStat(CONST_SLOT_HEAD, false));
	msg.addDouble(protocol.getForgeSkillStat(CONST_SLOT_HEAD) - protocol.getForgeSkillStat(CONST_SLOT_HEAD, false));
	msg.addDouble(player->wheel().getBonusData().momentum);
	msg.addDouble(0.00);

	msg.addDouble(protocol.getForgeSkillStat(CONST_SLOT_LEGS));
	msg.addDouble(protocol.getForgeSkillStat(CONST_SLOT_LEGS), false);
	msg.addDouble(protocol.getForgeSkillStat(CONST_SLOT_LEGS) - protocol.getForgeSkillStat(CONST_SLOT_LEGS, false));
	msg.addDouble(0.09);

	msg.addDouble(protocol.getForgeSkillStat(CONST_SLOT_FEET, false));
	msg.addDouble(protocol.getForgeSkillStat(CONST_SLOT_FEET, false));
	msg.addDouble(0.00);

	uint8_t haveBlesses = 0;
	for (auto bless : magic_enum::enum_values<Blessings>()) {
		if (bless == Blessings::TwistOfFate) {
			continue;
		}

		if (player->hasBlessing(enumToValue(bless))) {
			++haveBlesses;
		}
	}

	msg.addByte(haveBlesses);
	msg.addByte(magic_enum::enum_count<Blessings>() - 1);

	auto activeConcoctions = player->getActiveConcoctions();
	msg.addByte(activeConcoctions.size());
	for (const auto &concoction : activeConcoctions) {
		if (concoction.second == 0) {
			continue;
		}
		msg.add<uint16_t>(concoction.first);
		msg.addByte(0x00);
		msg.addByte(0x00);
		msg.add<uint32_t>(concoction.second);
	}

	msg.addByte(0x00);
}
