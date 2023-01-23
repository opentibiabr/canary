/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "lua/methods/player_functions_binding.hpp"

#include "utils/tools.h"

const std::unordered_map<std::string, lua_CFunction> LuaPlayerFunctionsBinding::getPlayerFunctionsMap(lua_State *L) {
	return {
		{"resetCharmsBestiary", LuaPlayerFunctions::resetCharmsBestiary},
		{"resetCharmsBestiary", LuaPlayerFunctions::resetCharmsBestiary},
		{"unlockAllCharmRunes", LuaPlayerFunctions::unlockAllCharmRunes},
		{"addCharmPoints", LuaPlayerFunctions::addCharmPoints},
		{"isPlayer", LuaPlayerFunctions::isPlayer},

		{"getGuid", LuaPlayerFunctions::getGuid},
		{"getIp", LuaPlayerFunctions::getIp},
		{"getAccountId", LuaPlayerFunctions::getAccountId},
		{"getLastLoginSaved", LuaPlayerFunctions::getLastLoginSaved},
		{"getLastLogout", LuaPlayerFunctions::getLastLogout},

		{"getAccountType", LuaPlayerFunctions::getAccountType},
		{"setAccountType", LuaPlayerFunctions::setAccountType},

		{"isMonsterBestiaryUnlocked", LuaPlayerFunctions::isMonsterBestiaryUnlocked},
		{"addBestiaryKill", LuaPlayerFunctions::addBestiaryKill},
		{"charmExpansion", LuaPlayerFunctions::charmExpansion},
		{"getCharmMonsterType", LuaPlayerFunctions::getCharmMonsterType},

		{"getPreyCards", LuaPlayerFunctions::getPreyCards},
		{"getPreyLootPercentage", LuaPlayerFunctions::getPreyLootPercentage},
		{"getPreyExperiencePercentage", LuaPlayerFunctions::getPreyExperiencePercentage},
		{"preyThirdSlot", LuaPlayerFunctions::preyThirdSlot},
		{"taskHuntingThirdSlot", LuaPlayerFunctions::taskHuntingThirdSlot},
		{"removePreyStamina", LuaPlayerFunctions::removePreyStamina},
		{"addPreyCards", LuaPlayerFunctions::addPreyCards},
		{"removeTaskHuntingPoints", LuaPlayerFunctions::removeTaskHuntingPoints},
		{"getTaskHuntingPoints", LuaPlayerFunctions::getTaskHuntingPoints},
		{"addTaskHuntingPoints", LuaPlayerFunctions::addTaskHuntingPoints},

		{"getCapacity", LuaPlayerFunctions::getCapacity},
		{"setCapacity", LuaPlayerFunctions::setCapacity},

		{"isTraining", LuaPlayerFunctions::getIsTraining},
		{"setTraining", LuaPlayerFunctions::setTraining},

		{"getFreeCapacity", LuaPlayerFunctions::getFreeCapacity},

		{"getKills", LuaPlayerFunctions::getKills},
		{"setKills", LuaPlayerFunctions::setKills},

		{"getReward", LuaPlayerFunctions::getReward},
		{"removeReward", LuaPlayerFunctions::removeReward},
		{"getRewardList", LuaPlayerFunctions::getRewardList},

		{"setDailyReward", LuaPlayerFunctions::setDailyReward},

		{"sendInventory", LuaPlayerFunctions::sendInventory},
		{"sendLootStats", LuaPlayerFunctions::sendLootStats},
		{"updateSupplyTracker", LuaPlayerFunctions::updateSupplyTracker},
		{"updateKillTracker", LuaPlayerFunctions::updateKillTracker},

		{"getDepotLocker", LuaPlayerFunctions::getDepotLocker},
		{"getDepotChest", LuaPlayerFunctions::getDepotChest},
		{"getInbox", LuaPlayerFunctions::getInbox},

		{"getSkullTime", LuaPlayerFunctions::getSkullTime},
		{"setSkullTime", LuaPlayerFunctions::setSkullTime},
		{"getDeathPenalty", LuaPlayerFunctions::getDeathPenalty},

		{"getExperience", LuaPlayerFunctions::getExperience},
		{"addExperience", LuaPlayerFunctions::addExperience},
		{"removeExperience", LuaPlayerFunctions::removeExperience},
		{"getLevel", LuaPlayerFunctions::getLevel},

		{"getMagicLevel", LuaPlayerFunctions::getMagicLevel},
		{"getBaseMagicLevel", LuaPlayerFunctions::getBaseMagicLevel},
		{"getMana", LuaPlayerFunctions::getMana},
		{"addMana", LuaPlayerFunctions::addMana},
		{"getMaxMana", LuaPlayerFunctions::getMaxMana},
		{"setMaxMana", LuaPlayerFunctions::setMaxMana},
		{"getManaSpent", LuaPlayerFunctions::getManaSpent},
		{"addManaSpent", LuaPlayerFunctions::addManaSpent},

		{"getName", LuaPlayerFunctions::getName},
		{"getId", LuaPlayerFunctions::getId},
		{"getPosition", LuaPlayerFunctions::getPosition},
		{"teleportTo", LuaPlayerFunctions::teleportTo},

		{"getBaseMaxHealth", LuaPlayerFunctions::getBaseMaxHealth},
		{"getBaseMaxMana", LuaPlayerFunctions::getBaseMaxMana},

		{"getSkillLevel", LuaPlayerFunctions::getSkillLevel},
		{"getEffectiveSkillLevel", LuaPlayerFunctions::getEffectiveSkillLevel},
		{"getSkillPercent", LuaPlayerFunctions::getSkillPercent},
		{"getSkillTries", LuaPlayerFunctions::getSkillTries},
		{"addSkillTries", LuaPlayerFunctions::addSkillTries},

		{"setMagicLevel", LuaPlayerFunctions::setMagicLevel},
		{"setSkillLevel", LuaPlayerFunctions::setSkillLevel},

		{"addOfflineTrainingTime", LuaPlayerFunctions::addOfflineTrainingTime},
		{"getOfflineTrainingTime", LuaPlayerFunctions::getOfflineTrainingTime},
		{"removeOfflineTrainingTime", LuaPlayerFunctions::removeOfflineTrainingTime},

		{"addOfflineTrainingTries", LuaPlayerFunctions::addOfflineTrainingTries},

		{"getOfflineTrainingSkill", LuaPlayerFunctions::getOfflineTrainingSkill},
		{"setOfflineTrainingSkill", LuaPlayerFunctions::setOfflineTrainingSkill},

		{"getItemCount", LuaPlayerFunctions::getItemCount},
		{"getStashItemCount", LuaPlayerFunctions::getStashItemCount},
		{"getItemById", LuaPlayerFunctions::getItemById},

		{"getVocation", LuaPlayerFunctions::getVocation},
		{"setVocation", LuaPlayerFunctions::setVocation},

		{"getSex", LuaPlayerFunctions::getSex},
		{"setSex", LuaPlayerFunctions::setSex},

		{"getTown", LuaPlayerFunctions::getTown},
		{"setTown", LuaPlayerFunctions::setTown},

		{"getGuild", LuaPlayerFunctions::getGuild},
		{"setGuild", LuaPlayerFunctions::setGuild},

		{"getGuildLevel", LuaPlayerFunctions::getGuildLevel},
		{"setGuildLevel", LuaPlayerFunctions::setGuildLevel},

		{"getGuildNick", LuaPlayerFunctions::getGuildNick},
		{"setGuildNick", LuaPlayerFunctions::setGuildNick},

		{"getGroup", LuaPlayerFunctions::getGroup},
		{"setGroup", LuaPlayerFunctions::setGroup},

		{"setSpecialContainersAvailable", LuaPlayerFunctions::setSpecialContainersAvailable},
		{"getStashCount", LuaPlayerFunctions::getStashCounter},
		{"openStash", LuaPlayerFunctions::openStash},

		{"getStamina", LuaPlayerFunctions::getStamina},
		{"setStamina", LuaPlayerFunctions::setStamina},

		{"getSoul", LuaPlayerFunctions::getSoul},
		{"addSoul", LuaPlayerFunctions::addSoul},
		{"getMaxSoul", LuaPlayerFunctions::getMaxSoul},

		{"getBankBalance", LuaPlayerFunctions::getBankBalance},
		{"setBankBalance", LuaPlayerFunctions::setBankBalance},

		{"getStorageValue", LuaPlayerFunctions::getStorageValue},
		{"setStorageValue", LuaPlayerFunctions::setStorageValue},

		{"addItem", LuaPlayerFunctions::addItem},
		{"addItemEx", LuaPlayerFunctions::addItemEx},
		{"removeStashItem", LuaPlayerFunctions::removeStashItem},
		{"removeItem", LuaPlayerFunctions::removeItem},
		{"sendContainer", LuaPlayerFunctions::sendContainer},

		{"getMoney", LuaPlayerFunctions::getMoney},
		{"addMoney", LuaPlayerFunctions::addMoney},
		{"removeMoney", LuaPlayerFunctions::removeMoney},

		{"showTextDialog", LuaPlayerFunctions::showTextDialog},

		{"sendTextMessage", LuaPlayerFunctions::sendTextMessage},
		{"sendChannelMessage", LuaPlayerFunctions::sendChannelMessage},
		{"sendPrivateMessage", LuaPlayerFunctions::sendPrivateMessage},
		{"channelSay", LuaPlayerFunctions::channelSay},
		{"openChannel", LuaPlayerFunctions::openChannel},

		{"getSlotItem", LuaPlayerFunctions::getSlotItem},

		{"getParty", LuaPlayerFunctions::getParty},

		{"addOutfit", LuaPlayerFunctions::addOutfit},
		{"addOutfitAddon", LuaPlayerFunctions::addOutfitAddon},
		{"removeOutfit", LuaPlayerFunctions::removeOutfit},
		{"removeOutfitAddon", LuaPlayerFunctions::removeOutfitAddon},
		{"hasOutfit", LuaPlayerFunctions::hasOutfit},
		{"sendOutfitWindow", LuaPlayerFunctions::sendOutfitWindow},

		{"addMount", LuaPlayerFunctions::addMount},
		{"removeMount", LuaPlayerFunctions::removeMount},
		{"hasMount", LuaPlayerFunctions::hasMount},

		{"addFamiliar", LuaPlayerFunctions::addFamiliar},
		{"removeFamiliar", LuaPlayerFunctions::removeFamiliar},
		{"hasFamiliar", LuaPlayerFunctions::hasFamiliar},
		{"setFamiliarLooktype", LuaPlayerFunctions::setFamiliarLooktype},
		{"getFamiliarLooktype", LuaPlayerFunctions::getFamiliarLooktype},

		{"getPremiumDays", LuaPlayerFunctions::getPremiumDays},
		{"addPremiumDays", LuaPlayerFunctions::addPremiumDays},
		{"removePremiumDays", LuaPlayerFunctions::removePremiumDays},

		{"getTibiaCoins", LuaPlayerFunctions::getTibiaCoins},
		{"addTibiaCoins", LuaPlayerFunctions::addTibiaCoins},
		{"removeTibiaCoins", LuaPlayerFunctions::removeTibiaCoins},

		{"hasBlessing", LuaPlayerFunctions::hasBlessing},
		{"addBlessing", LuaPlayerFunctions::addBlessing},
		{"removeBlessing", LuaPlayerFunctions::removeBlessing},
		{"getBlessingCount", LuaPlayerFunctions::getBlessingCount},

		{"canLearnSpell", LuaPlayerFunctions::canLearnSpell},
		{"learnSpell", LuaPlayerFunctions::learnSpell},
		{"forgetSpell", LuaPlayerFunctions::forgetSpell},
		{"hasLearnedSpell", LuaPlayerFunctions::hasLearnedSpell},

		{"openImbuementWindow", LuaPlayerFunctions::openImbuementWindow},
		{"closeImbuementWindow", LuaPlayerFunctions::closeImbuementWindow},

		{"sendTutorial", LuaPlayerFunctions::sendTutorial},
		{"addMapMark", LuaPlayerFunctions::addMapMark},

		{"save", LuaPlayerFunctions::save},
		{"popupFYI", LuaPlayerFunctions::popupFYI},

		{"isPzLocked", LuaPlayerFunctions::isPzLocked},

		{"getClient", LuaPlayerFunctions::getClient},

		{"getHouse", LuaPlayerFunctions::getHouse},
		{"sendHouseWindow", LuaPlayerFunctions::sendHouseWindow},
		{"setEditHouse", LuaPlayerFunctions::setEditHouse},

		{"setGhostMode", LuaPlayerFunctions::setGhostMode},

		{"getContainerId", LuaPlayerFunctions::getContainerId},
		{"getContainerById", LuaPlayerFunctions::getContainerById},
		{"getContainerIndex", LuaPlayerFunctions::getContainerIndex},

		{"getInstantSpells", LuaPlayerFunctions::getInstantSpells},
		{"canCast", LuaPlayerFunctions::canCast},

		{"hasChaseMode", LuaPlayerFunctions::hasChaseMode},
		{"hasSecureMode", LuaPlayerFunctions::hasSecureMode},
		{"getFightMode", LuaPlayerFunctions::getFightMode},

		{"getBaseXpGain", LuaPlayerFunctions::getBaseXpGain},
		{"setBaseXpGain", LuaPlayerFunctions::setBaseXpGain},
		{"getVoucherXpBoost", LuaPlayerFunctions::getVoucherXpBoost},
		{"setVoucherXpBoost", LuaPlayerFunctions::setVoucherXpBoost},
		{"getGrindingXpBoost", LuaPlayerFunctions::getGrindingXpBoost},
		{"setGrindingXpBoost", LuaPlayerFunctions::setGrindingXpBoost},
		{"getStoreXpBoost", LuaPlayerFunctions::getStoreXpBoost},
		{"setStoreXpBoost", LuaPlayerFunctions::setStoreXpBoost},
		{"getStaminaXpBoost", LuaPlayerFunctions::getStaminaXpBoost},
		{"setStaminaXpBoost", LuaPlayerFunctions::setStaminaXpBoost},
		{"getExpBoostStamina", LuaPlayerFunctions::getExpBoostStamina},
		{"setExpBoostStamina", LuaPlayerFunctions::setExpBoostStamina},

		{"getIdleTime", LuaPlayerFunctions::getIdleTime},
		{"getFreeBackpackSlots", LuaPlayerFunctions::getFreeBackpackSlots},

		{"isOffline", LuaPlayerFunctions::isOffline},

		{"openMarket", LuaPlayerFunctions::openMarket},

		// Forge Functions
		{"openForge", LuaPlayerFunctions::openForge},
		{"closeForge", LuaPlayerFunctions::closeForge},

		{"addForgeDusts", LuaPlayerFunctions::addForgeDusts},
		{"removeForgeDusts", LuaPlayerFunctions::removeForgeDusts},
		{"getForgeDusts", LuaPlayerFunctions::getForgeDusts},
		{"setForgeDusts", LuaPlayerFunctions::setForgeDusts},

		{"addForgeDustLevel", LuaPlayerFunctions::addForgeDustLevel},
		{"removeForgeDustLevel", LuaPlayerFunctions::removeForgeDustLevel},
		{"getForgeDustLevel", LuaPlayerFunctions::getForgeDustLevel},

		{"getForgeSlivers", LuaPlayerFunctions::getForgeSlivers},
		{"getForgeCores", LuaPlayerFunctions::getForgeCores},

		{"setFaction", LuaPlayerFunctions::setFaction},
		{"getFaction", LuaPlayerFunctions::getFaction}
	};
};

void LuaPlayerFunctionsBinding::init(lua_State *L)
{
	registerClass(L, "Player", "Creature", LuaPlayerFunctions::create);
	registerMetaMethod(L, "Player", "__eq", LuaFunctionsLoader::luaUserdataCompare);

	for (const auto &[functionName, functionReference]: getPlayerFunctionsMap(L))
	{
		registerFunction(L, "Player", functionName.c_str(), functionReference);
	}

	GroupFunctions::init(L);
	GuildFunctions::init(L);
	MountFunctions::init(L);
	PartyFunctions::init(L);
	VocationFunctions::init(L);
}
