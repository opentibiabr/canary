/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"
#include "lua/functions/creatures/player/group_functions.hpp"
#include "lua/functions/creatures/player/guild_functions.hpp"
#include "lua/functions/creatures/player/mount_functions.hpp"
#include "lua/functions/creatures/player/party_functions.hpp"
#include "lua/functions/creatures/player/vocation_functions.hpp"

class PlayerFunctions final : LuaScriptInterface {
private:
	static void init(lua_State* L) {
		registerSharedClass(L, "Player", "Creature", PlayerFunctions::luaPlayerCreate);
		registerMetaMethod(L, "Player", "__eq", PlayerFunctions::luaUserdataCompare);

		registerMethod(L, "Player", "resetCharmsBestiary", PlayerFunctions::luaPlayerResetCharmsMonsters);
		registerMethod(L, "Player", "unlockAllCharmRunes", PlayerFunctions::luaPlayerUnlockAllCharmRunes);
		registerMethod(L, "Player", "addCharmPoints", PlayerFunctions::luaPlayeraddCharmPoints);
		registerMethod(L, "Player", "isPlayer", PlayerFunctions::luaPlayerIsPlayer);

		registerMethod(L, "Player", "getGuid", PlayerFunctions::luaPlayerGetGuid);
		registerMethod(L, "Player", "getIp", PlayerFunctions::luaPlayerGetIp);
		registerMethod(L, "Player", "getAccountId", PlayerFunctions::luaPlayerGetAccountId);
		registerMethod(L, "Player", "getLastLoginSaved", PlayerFunctions::luaPlayerGetLastLoginSaved);
		registerMethod(L, "Player", "getLastLogout", PlayerFunctions::luaPlayerGetLastLogout);

		registerMethod(L, "Player", "getAccountType", PlayerFunctions::luaPlayerGetAccountType);
		registerMethod(L, "Player", "setAccountType", PlayerFunctions::luaPlayerSetAccountType);

		registerMethod(L, "Player", "isMonsterBestiaryUnlocked", PlayerFunctions::luaPlayerIsMonsterBestiaryUnlocked);
		registerMethod(L, "Player", "addBestiaryKill", PlayerFunctions::luaPlayerAddBestiaryKill);
		registerMethod(L, "Player", "charmExpansion", PlayerFunctions::luaPlayercharmExpansion);
		registerMethod(L, "Player", "getCharmMonsterType", PlayerFunctions::luaPlayergetCharmMonsterType);

		registerMethod(L, "Player", "isMonsterPrey", PlayerFunctions::luaPlayerisMonsterPrey);
		registerMethod(L, "Player", "getPreyCards", PlayerFunctions::luaPlayerGetPreyCards);
		registerMethod(L, "Player", "getPreyLootPercentage", PlayerFunctions::luaPlayerGetPreyLootPercentage);
		registerMethod(L, "Player", "getPreyExperiencePercentage", PlayerFunctions::luaPlayerGetPreyExperiencePercentage);
		registerMethod(L, "Player", "preyThirdSlot", PlayerFunctions::luaPlayerPreyThirdSlot);
		registerMethod(L, "Player", "taskHuntingThirdSlot", PlayerFunctions::luaPlayerTaskThirdSlot);
		registerMethod(L, "Player", "removePreyStamina", PlayerFunctions::luaPlayerRemovePreyStamina);
		registerMethod(L, "Player", "addPreyCards", PlayerFunctions::luaPlayerAddPreyCards);
		registerMethod(L, "Player", "removeTaskHuntingPoints", PlayerFunctions::luaPlayerRemoveTaskHuntingPoints);
		registerMethod(L, "Player", "getTaskHuntingPoints", PlayerFunctions::luaPlayerGetTaskHuntingPoints);
		registerMethod(L, "Player", "addTaskHuntingPoints", PlayerFunctions::luaPlayerAddTaskHuntingPoints);

		registerMethod(L, "Player", "getCapacity", PlayerFunctions::luaPlayerGetCapacity);
		registerMethod(L, "Player", "setCapacity", PlayerFunctions::luaPlayerSetCapacity);

		registerMethod(L, "Player", "isTraining", PlayerFunctions::luaPlayerGetIsTraining);
		registerMethod(L, "Player", "setTraining", PlayerFunctions::luaPlayerSetTraining);

		registerMethod(L, "Player", "getFreeCapacity", PlayerFunctions::luaPlayerGetFreeCapacity);

		registerMethod(L, "Player", "getKills", PlayerFunctions::luaPlayerGetKills);
		registerMethod(L, "Player", "setKills", PlayerFunctions::luaPlayerSetKills);

		registerMethod(L, "Player", "getReward", PlayerFunctions::luaPlayerGetReward);
		registerMethod(L, "Player", "removeReward", PlayerFunctions::luaPlayerRemoveReward);
		registerMethod(L, "Player", "getRewardList", PlayerFunctions::luaPlayerGetRewardList);

		registerMethod(L, "Player", "setDailyReward", PlayerFunctions::luaPlayerSetDailyReward);

		registerMethod(L, "Player", "sendInventory", PlayerFunctions::luaPlayerSendInventory);
		registerMethod(L, "Player", "sendLootStats", PlayerFunctions::luaPlayerSendLootStats);
		registerMethod(L, "Player", "updateSupplyTracker", PlayerFunctions::luaPlayerUpdateSupplyTracker);
		registerMethod(L, "Player", "updateKillTracker", PlayerFunctions::luaPlayerUpdateKillTracker);

		registerMethod(L, "Player", "getDepotLocker", PlayerFunctions::luaPlayerGetDepotLocker);
		registerMethod(L, "Player", "getDepotChest", PlayerFunctions::luaPlayerGetDepotChest);
		registerMethod(L, "Player", "getInbox", PlayerFunctions::luaPlayerGetInbox);

		registerMethod(L, "Player", "getSkullTime", PlayerFunctions::luaPlayerGetSkullTime);
		registerMethod(L, "Player", "setSkullTime", PlayerFunctions::luaPlayerSetSkullTime);
		registerMethod(L, "Player", "getDeathPenalty", PlayerFunctions::luaPlayerGetDeathPenalty);

		registerMethod(L, "Player", "getExperience", PlayerFunctions::luaPlayerGetExperience);
		registerMethod(L, "Player", "addExperience", PlayerFunctions::luaPlayerAddExperience);
		registerMethod(L, "Player", "removeExperience", PlayerFunctions::luaPlayerRemoveExperience);
		registerMethod(L, "Player", "getLevel", PlayerFunctions::luaPlayerGetLevel);

		registerMethod(L, "Player", "getMagicShieldCapacityFlat", PlayerFunctions::luaPlayerGetMagicShieldCapacityFlat);
		registerMethod(L, "Player", "getMagicShieldCapacityPercent", PlayerFunctions::luaPlayerGetMagicShieldCapacityPercent);

		registerMethod(L, "Player", "sendSpellCooldown", PlayerFunctions::luaPlayerSendSpellCooldown);
		registerMethod(L, "Player", "sendSpellGroupCooldown", PlayerFunctions::luaPlayerSendSpellGroupCooldown);

		registerMethod(L, "Player", "getMagicLevel", PlayerFunctions::luaPlayerGetMagicLevel);
		registerMethod(L, "Player", "getBaseMagicLevel", PlayerFunctions::luaPlayerGetBaseMagicLevel);
		registerMethod(L, "Player", "getMana", PlayerFunctions::luaPlayerGetMana);
		registerMethod(L, "Player", "addMana", PlayerFunctions::luaPlayerAddMana);
		registerMethod(L, "Player", "getMaxMana", PlayerFunctions::luaPlayerGetMaxMana);
		registerMethod(L, "Player", "setMaxMana", PlayerFunctions::luaPlayerSetMaxMana);
		registerMethod(L, "Player", "getManaSpent", PlayerFunctions::luaPlayerGetManaSpent);
		registerMethod(L, "Player", "addManaSpent", PlayerFunctions::luaPlayerAddManaSpent);

		registerMethod(L, "Player", "getBaseMaxHealth", PlayerFunctions::luaPlayerGetBaseMaxHealth);
		registerMethod(L, "Player", "getBaseMaxMana", PlayerFunctions::luaPlayerGetBaseMaxMana);

		registerMethod(L, "Player", "getSkillLevel", PlayerFunctions::luaPlayerGetSkillLevel);
		registerMethod(L, "Player", "getEffectiveSkillLevel", PlayerFunctions::luaPlayerGetEffectiveSkillLevel);
		registerMethod(L, "Player", "getSkillPercent", PlayerFunctions::luaPlayerGetSkillPercent);
		registerMethod(L, "Player", "getSkillTries", PlayerFunctions::luaPlayerGetSkillTries);
		registerMethod(L, "Player", "addSkillTries", PlayerFunctions::luaPlayerAddSkillTries);

		registerMethod(L, "Player", "setLevel", PlayerFunctions::luaPlayerSetLevel);
		registerMethod(L, "Player", "setMagicLevel", PlayerFunctions::luaPlayerSetMagicLevel);
		registerMethod(L, "Player", "setSkillLevel", PlayerFunctions::luaPlayerSetSkillLevel);

		registerMethod(L, "Player", "addOfflineTrainingTime", PlayerFunctions::luaPlayerAddOfflineTrainingTime);
		registerMethod(L, "Player", "getOfflineTrainingTime", PlayerFunctions::luaPlayerGetOfflineTrainingTime);
		registerMethod(L, "Player", "removeOfflineTrainingTime", PlayerFunctions::luaPlayerRemoveOfflineTrainingTime);

		registerMethod(L, "Player", "addOfflineTrainingTries", PlayerFunctions::luaPlayerAddOfflineTrainingTries);

		registerMethod(L, "Player", "getOfflineTrainingSkill", PlayerFunctions::luaPlayerGetOfflineTrainingSkill);
		registerMethod(L, "Player", "setOfflineTrainingSkill", PlayerFunctions::luaPlayerSetOfflineTrainingSkill);

		registerMethod(L, "Player", "getItemCount", PlayerFunctions::luaPlayerGetItemCount);
		registerMethod(L, "Player", "getStashItemCount", PlayerFunctions::luaPlayerGetStashItemCount);
		registerMethod(L, "Player", "getItemById", PlayerFunctions::luaPlayerGetItemById);

		registerMethod(L, "Player", "getVocation", PlayerFunctions::luaPlayerGetVocation);
		registerMethod(L, "Player", "setVocation", PlayerFunctions::luaPlayerSetVocation);
		registerMethod(L, "Player", "isPromoted", PlayerFunctions::luaPlayerIsPromoted);

		registerMethod(L, "Player", "getSex", PlayerFunctions::luaPlayerGetSex);
		registerMethod(L, "Player", "setSex", PlayerFunctions::luaPlayerSetSex);

		registerMethod(L, "Player", "getPronoun", PlayerFunctions::luaPlayerGetPronoun);
		registerMethod(L, "Player", "setPronoun", PlayerFunctions::luaPlayerSetPronoun);

		registerMethod(L, "Player", "getTown", PlayerFunctions::luaPlayerGetTown);
		registerMethod(L, "Player", "setTown", PlayerFunctions::luaPlayerSetTown);

		registerMethod(L, "Player", "getGuild", PlayerFunctions::luaPlayerGetGuild);
		registerMethod(L, "Player", "setGuild", PlayerFunctions::luaPlayerSetGuild);

		registerMethod(L, "Player", "getGuildLevel", PlayerFunctions::luaPlayerGetGuildLevel);
		registerMethod(L, "Player", "setGuildLevel", PlayerFunctions::luaPlayerSetGuildLevel);

		registerMethod(L, "Player", "getGuildNick", PlayerFunctions::luaPlayerGetGuildNick);
		registerMethod(L, "Player", "setGuildNick", PlayerFunctions::luaPlayerSetGuildNick);

		registerMethod(L, "Player", "getGroup", PlayerFunctions::luaPlayerGetGroup);
		registerMethod(L, "Player", "setGroup", PlayerFunctions::luaPlayerSetGroup);

		registerMethod(L, "Player", "setSpecialContainersAvailable", PlayerFunctions::luaPlayerSetSpecialContainersAvailable);
		registerMethod(L, "Player", "getStashCount", PlayerFunctions::luaPlayerGetStashCounter);
		registerMethod(L, "Player", "openStash", PlayerFunctions::luaPlayerOpenStash);

		registerMethod(L, "Player", "getStamina", PlayerFunctions::luaPlayerGetStamina);
		registerMethod(L, "Player", "setStamina", PlayerFunctions::luaPlayerSetStamina);

		registerMethod(L, "Player", "getSoul", PlayerFunctions::luaPlayerGetSoul);
		registerMethod(L, "Player", "addSoul", PlayerFunctions::luaPlayerAddSoul);
		registerMethod(L, "Player", "getMaxSoul", PlayerFunctions::luaPlayerGetMaxSoul);

		registerMethod(L, "Player", "getBankBalance", PlayerFunctions::luaPlayerGetBankBalance);
		registerMethod(L, "Player", "setBankBalance", PlayerFunctions::luaPlayerSetBankBalance);

		registerMethod(L, "Player", "getStorageValue", PlayerFunctions::luaPlayerGetStorageValue);
		registerMethod(L, "Player", "setStorageValue", PlayerFunctions::luaPlayerSetStorageValue);

		registerMethod(L, "Player", "getStorageValueByName", PlayerFunctions::luaPlayerGetStorageValueByName);
		registerMethod(L, "Player", "setStorageValueByName", PlayerFunctions::luaPlayerSetStorageValueByName);

		registerMethod(L, "Player", "addItem", PlayerFunctions::luaPlayerAddItem);
		registerMethod(L, "Player", "addItemEx", PlayerFunctions::luaPlayerAddItemEx);
		registerMethod(L, "Player", "addItemStash", PlayerFunctions::luaPlayerAddItemStash);
		registerMethod(L, "Player", "removeStashItem", PlayerFunctions::luaPlayerRemoveStashItem);
		registerMethod(L, "Player", "removeItem", PlayerFunctions::luaPlayerRemoveItem);
		registerMethod(L, "Player", "sendContainer", PlayerFunctions::luaPlayerSendContainer);
		registerMethod(L, "Player", "sendUpdateContainer", PlayerFunctions::luaPlayerSendUpdateContainer);

		registerMethod(L, "Player", "getMoney", PlayerFunctions::luaPlayerGetMoney);
		registerMethod(L, "Player", "addMoney", PlayerFunctions::luaPlayerAddMoney);
		registerMethod(L, "Player", "removeMoney", PlayerFunctions::luaPlayerRemoveMoney);

		registerMethod(L, "Player", "showTextDialog", PlayerFunctions::luaPlayerShowTextDialog);

		registerMethod(L, "Player", "sendTextMessage", PlayerFunctions::luaPlayerSendTextMessage);
		registerMethod(L, "Player", "sendChannelMessage", PlayerFunctions::luaPlayerSendChannelMessage);
		registerMethod(L, "Player", "sendPrivateMessage", PlayerFunctions::luaPlayerSendPrivateMessage);
		registerMethod(L, "Player", "channelSay", PlayerFunctions::luaPlayerChannelSay);
		registerMethod(L, "Player", "openChannel", PlayerFunctions::luaPlayerOpenChannel);

		registerMethod(L, "Player", "getSlotItem", PlayerFunctions::luaPlayerGetSlotItem);

		registerMethod(L, "Player", "getParty", PlayerFunctions::luaPlayerGetParty);

		registerMethod(L, "Player", "addOutfit", PlayerFunctions::luaPlayerAddOutfit);
		registerMethod(L, "Player", "addOutfitAddon", PlayerFunctions::luaPlayerAddOutfitAddon);
		registerMethod(L, "Player", "removeOutfit", PlayerFunctions::luaPlayerRemoveOutfit);
		registerMethod(L, "Player", "removeOutfitAddon", PlayerFunctions::luaPlayerRemoveOutfitAddon);
		registerMethod(L, "Player", "hasOutfit", PlayerFunctions::luaPlayerHasOutfit);
		registerMethod(L, "Player", "sendOutfitWindow", PlayerFunctions::luaPlayerSendOutfitWindow);

		registerMethod(L, "Player", "addMount", PlayerFunctions::luaPlayerAddMount);
		registerMethod(L, "Player", "removeMount", PlayerFunctions::luaPlayerRemoveMount);
		registerMethod(L, "Player", "hasMount", PlayerFunctions::luaPlayerHasMount);

		registerMethod(L, "Player", "addFamiliar", PlayerFunctions::luaPlayerAddFamiliar);
		registerMethod(L, "Player", "removeFamiliar", PlayerFunctions::luaPlayerRemoveFamiliar);
		registerMethod(L, "Player", "hasFamiliar", PlayerFunctions::luaPlayerHasFamiliar);
		registerMethod(L, "Player", "setFamiliarLooktype", PlayerFunctions::luaPlayerSetFamiliarLooktype);
		registerMethod(L, "Player", "getFamiliarLooktype", PlayerFunctions::luaPlayerGetFamiliarLooktype);

		registerMethod(L, "Player", "getPremiumDays", PlayerFunctions::luaPlayerGetPremiumDays);
		registerMethod(L, "Player", "addPremiumDays", PlayerFunctions::luaPlayerAddPremiumDays);
		registerMethod(L, "Player", "removePremiumDays", PlayerFunctions::luaPlayerRemovePremiumDays);

		registerMethod(L, "Player", "getTibiaCoins", PlayerFunctions::luaPlayerGetTibiaCoins);
		registerMethod(L, "Player", "addTibiaCoins", PlayerFunctions::luaPlayerAddTibiaCoins);
		registerMethod(L, "Player", "removeTibiaCoins", PlayerFunctions::luaPlayerRemoveTibiaCoins);

		registerMethod(L, "Player", "getTransferableCoins", PlayerFunctions::luaPlayerGetTransferableCoins);
		registerMethod(L, "Player", "addTransferableCoins", PlayerFunctions::luaPlayerAddTransferableCoins);
		registerMethod(L, "Player", "removeTransferableCoins", PlayerFunctions::luaPlayerRemoveTransferableCoins);

		registerMethod(L, "Player", "hasBlessing", PlayerFunctions::luaPlayerHasBlessing);
		registerMethod(L, "Player", "addBlessing", PlayerFunctions::luaPlayerAddBlessing);
		registerMethod(L, "Player", "removeBlessing", PlayerFunctions::luaPlayerRemoveBlessing);
		registerMethod(L, "Player", "getBlessingCount", PlayerFunctions::luaPlayerGetBlessingCount);

		registerMethod(L, "Player", "canLearnSpell", PlayerFunctions::luaPlayerCanLearnSpell);
		registerMethod(L, "Player", "learnSpell", PlayerFunctions::luaPlayerLearnSpell);
		registerMethod(L, "Player", "forgetSpell", PlayerFunctions::luaPlayerForgetSpell);
		registerMethod(L, "Player", "hasLearnedSpell", PlayerFunctions::luaPlayerHasLearnedSpell);

		registerMethod(L, "Player", "openImbuementWindow", PlayerFunctions::luaPlayerOpenImbuementWindow);
		registerMethod(L, "Player", "closeImbuementWindow", PlayerFunctions::luaPlayerCloseImbuementWindow);

		registerMethod(L, "Player", "sendTutorial", PlayerFunctions::luaPlayerSendTutorial);
		registerMethod(L, "Player", "addMapMark", PlayerFunctions::luaPlayerAddMapMark);

		registerMethod(L, "Player", "save", PlayerFunctions::luaPlayerSave);
		registerMethod(L, "Player", "popupFYI", PlayerFunctions::luaPlayerPopupFYI);

		registerMethod(L, "Player", "isPzLocked", PlayerFunctions::luaPlayerIsPzLocked);

		registerMethod(L, "Player", "getClient", PlayerFunctions::luaPlayerGetClient);

		registerMethod(L, "Player", "getHouse", PlayerFunctions::luaPlayerGetHouse);
		registerMethod(L, "Player", "sendHouseWindow", PlayerFunctions::luaPlayerSendHouseWindow);
		registerMethod(L, "Player", "setEditHouse", PlayerFunctions::luaPlayerSetEditHouse);

		registerMethod(L, "Player", "setGhostMode", PlayerFunctions::luaPlayerSetGhostMode);

		registerMethod(L, "Player", "getContainerId", PlayerFunctions::luaPlayerGetContainerId);
		registerMethod(L, "Player", "getContainerById", PlayerFunctions::luaPlayerGetContainerById);
		registerMethod(L, "Player", "getContainerIndex", PlayerFunctions::luaPlayerGetContainerIndex);

		registerMethod(L, "Player", "getInstantSpells", PlayerFunctions::luaPlayerGetInstantSpells);
		registerMethod(L, "Player", "canCast", PlayerFunctions::luaPlayerCanCast);

		registerMethod(L, "Player", "hasChaseMode", PlayerFunctions::luaPlayerHasChaseMode);
		registerMethod(L, "Player", "hasSecureMode", PlayerFunctions::luaPlayerHasSecureMode);
		registerMethod(L, "Player", "getFightMode", PlayerFunctions::luaPlayerGetFightMode);

		registerMethod(L, "Player", "getBaseXpGain", PlayerFunctions::luaPlayerGetBaseXpGain);
		registerMethod(L, "Player", "setBaseXpGain", PlayerFunctions::luaPlayerSetBaseXpGain);
		registerMethod(L, "Player", "getVoucherXpBoost", PlayerFunctions::luaPlayerGetVoucherXpBoost);
		registerMethod(L, "Player", "setVoucherXpBoost", PlayerFunctions::luaPlayerSetVoucherXpBoost);
		registerMethod(L, "Player", "getGrindingXpBoost", PlayerFunctions::luaPlayerGetGrindingXpBoost);
		registerMethod(L, "Player", "setGrindingXpBoost", PlayerFunctions::luaPlayerSetGrindingXpBoost);
		registerMethod(L, "Player", "getXpBoostPercent", PlayerFunctions::luaPlayerGetXpBoostPercent);
		registerMethod(L, "Player", "setXpBoostPercent", PlayerFunctions::luaPlayerSetXpBoostPercent);
		registerMethod(L, "Player", "getStaminaXpBoost", PlayerFunctions::luaPlayerGetStaminaXpBoost);
		registerMethod(L, "Player", "setStaminaXpBoost", PlayerFunctions::luaPlayerSetStaminaXpBoost);
		registerMethod(L, "Player", "getXpBoostTime", PlayerFunctions::luaPlayerGetXpBoostTime);
		registerMethod(L, "Player", "setXpBoostTime", PlayerFunctions::luaPlayerSetXpBoostTime);

		registerMethod(L, "Player", "getIdleTime", PlayerFunctions::luaPlayerGetIdleTime);
		registerMethod(L, "Player", "getFreeBackpackSlots", PlayerFunctions::luaPlayerGetFreeBackpackSlots);

		registerMethod(L, "Player", "isOffline", PlayerFunctions::luaPlayerIsOffline);

		registerMethod(L, "Player", "openMarket", PlayerFunctions::luaPlayerOpenMarket);

		registerMethod(L, "Player", "instantSkillWOD", PlayerFunctions::luaPlayerInstantSkillWOD);
		registerMethod(L, "Player", "upgradeSpellsWOD", PlayerFunctions::luaPlayerUpgradeSpellWOD);
		registerMethod(L, "Player", "revelationStageWOD", PlayerFunctions::luaPlayerRevelationStageWOD);
		registerMethod(L, "Player", "reloadData", PlayerFunctions::luaPlayerReloadData);
		registerMethod(L, "Player", "onThinkWheelOfDestiny", PlayerFunctions::luaPlayerOnThinkWheelOfDestiny);
		registerMethod(L, "Player", "avatarTimer", PlayerFunctions::luaPlayerAvatarTimer);
		registerMethod(L, "Player", "getWheelSpellAdditionalArea", PlayerFunctions::luaPlayerGetWheelSpellAdditionalArea);
		registerMethod(L, "Player", "getWheelSpellAdditionalTarget", PlayerFunctions::luaPlayerGetWheelSpellAdditionalTarget);
		registerMethod(L, "Player", "getWheelSpellAdditionalDuration", PlayerFunctions::luaPlayerGetWheelSpellAdditionalDuration);

		// Forge Functions
		registerMethod(L, "Player", "openForge", PlayerFunctions::luaPlayerOpenForge);
		registerMethod(L, "Player", "closeForge", PlayerFunctions::luaPlayerCloseForge);

		registerMethod(L, "Player", "addForgeDusts", PlayerFunctions::luaPlayerAddForgeDusts);
		registerMethod(L, "Player", "removeForgeDusts", PlayerFunctions::luaPlayerRemoveForgeDusts);
		registerMethod(L, "Player", "getForgeDusts", PlayerFunctions::luaPlayerGetForgeDusts);
		registerMethod(L, "Player", "setForgeDusts", PlayerFunctions::luaPlayerSetForgeDusts);

		registerMethod(L, "Player", "addForgeDustLevel", PlayerFunctions::luaPlayerAddForgeDustLevel);
		registerMethod(L, "Player", "removeForgeDustLevel", PlayerFunctions::luaPlayerRemoveForgeDustLevel);
		registerMethod(L, "Player", "getForgeDustLevel", PlayerFunctions::luaPlayerGetForgeDustLevel);

		registerMethod(L, "Player", "getForgeSlivers", PlayerFunctions::luaPlayerGetForgeSlivers);
		registerMethod(L, "Player", "getForgeCores", PlayerFunctions::luaPlayerGetForgeCores);
		registerMethod(L, "Player", "isUIExhausted", PlayerFunctions::luaPlayerIsUIExhausted);
		registerMethod(L, "Player", "updateUIExhausted", PlayerFunctions::luaPlayerUpdateUIExhausted);

		registerMethod(L, "Player", "setFaction", PlayerFunctions::luaPlayerSetFaction);
		registerMethod(L, "Player", "getFaction", PlayerFunctions::luaPlayerGetFaction);

		// Bosstiary Functions
		registerMethod(L, "Player", "getBosstiaryLevel", PlayerFunctions::luaPlayerGetBosstiaryLevel);
		registerMethod(L, "Player", "getBosstiaryKills", PlayerFunctions::luaPlayerGetBosstiaryKills);
		registerMethod(L, "Player", "addBosstiaryKill", PlayerFunctions::luaPlayerAddBosstiaryKill);
		registerMethod(L, "Player", "setBossPoints", PlayerFunctions::luaPlayerSetBossPoints);
		registerMethod(L, "Player", "setRemoveBossTime", PlayerFunctions::luaPlayerSetRemoveBossTime);
		registerMethod(L, "Player", "getSlotBossId", PlayerFunctions::luaPlayerGetSlotBossId);
		registerMethod(L, "Player", "getBossBonus", PlayerFunctions::luaPlayerGetBossBonus);
		registerMethod(L, "Player", "sendBosstiaryCooldownTimer", PlayerFunctions::luaPlayerBosstiaryCooldownTimer);

		registerMethod(L, "Player", "sendSingleSoundEffect", PlayerFunctions::luaPlayerSendSingleSoundEffect);
		registerMethod(L, "Player", "sendDoubleSoundEffect", PlayerFunctions::luaPlayerSendDoubleSoundEffect);

		registerMethod(L, "Player", "getName", PlayerFunctions::luaPlayerGetName);
		registerMethod(L, "Player", "changeName", PlayerFunctions::luaPlayerChangeName);

		registerMethod(L, "Player", "hasGroupFlag", PlayerFunctions::luaPlayerHasGroupFlag);
		registerMethod(L, "Player", "setGroupFlag", PlayerFunctions::luaPlayerSetGroupFlag);
		registerMethod(L, "Player", "removeGroupFlag", PlayerFunctions::luaPlayerRemoveGroupFlag);

		registerMethod(L, "Player", "setHazardSystemPoints", PlayerFunctions::luaPlayerAddHazardSystemPoints);
		registerMethod(L, "Player", "getHazardSystemPoints", PlayerFunctions::luaPlayerGetHazardSystemPoints);

		registerMethod(L, "Player", "setLoyaltyBonus", PlayerFunctions::luaPlayerSetLoyaltyBonus);
		registerMethod(L, "Player", "getLoyaltyBonus", PlayerFunctions::luaPlayerGetLoyaltyBonus);
		registerMethod(L, "Player", "getLoyaltyPoints", PlayerFunctions::luaPlayerGetLoyaltyPoints);
		registerMethod(L, "Player", "getLoyaltyTitle", PlayerFunctions::luaPlayerGetLoyaltyTitle);
		registerMethod(L, "Player", "setLoyaltyTitle", PlayerFunctions::luaPlayerSetLoyaltyTitle);

		registerMethod(L, "Player", "updateConcoction", PlayerFunctions::luaPlayerUpdateConcoction);
		registerMethod(L, "Player", "clearSpellCooldowns", PlayerFunctions::luaPlayerClearSpellCooldowns);

		registerMethod(L, "Player", "isVip", PlayerFunctions::luaPlayerIsVip);
		registerMethod(L, "Player", "getVipDays", PlayerFunctions::luaPlayerGetVipDays);
		registerMethod(L, "Player", "getVipTime", PlayerFunctions::luaPlayerGetVipTime);

		registerMethod(L, "Player", "kv", PlayerFunctions::luaPlayerKV);
		registerMethod(L, "Player", "getStoreInbox", PlayerFunctions::luaPlayerGetStoreInbox);

		registerMethod(L, "Player", "hasAchievement", PlayerFunctions::luaPlayerHasAchievement);
		registerMethod(L, "Player", "addAchievement", PlayerFunctions::luaPlayerAddAchievement);
		registerMethod(L, "Player", "removeAchievement", PlayerFunctions::luaPlayerRemoveAchievement);
		registerMethod(L, "Player", "getAchievementPoints", PlayerFunctions::luaPlayerGetAchievementPoints);
		registerMethod(L, "Player", "addAchievementPoints", PlayerFunctions::luaPlayerAddAchievementPoints);
		registerMethod(L, "Player", "removeAchievementPoints", PlayerFunctions::luaPlayerRemoveAchievementPoints);

		// Badge Functions
		registerMethod(L, "Player", "addBadge", PlayerFunctions::luaPlayerAddBadge);

		// Title Functions
		registerMethod(L, "Player", "addTitle", PlayerFunctions::luaPlayerAddTitle);
		registerMethod(L, "Player", "getTitles", PlayerFunctions::luaPlayerGetTitles);
		registerMethod(L, "Player", "setCurrentTitle", PlayerFunctions::luaPlayerSetCurrentTitle);

		// Store Summary
		registerMethod(L, "Player", "createTransactionSummary", PlayerFunctions::luaPlayerCreateTransactionSummary);

		GroupFunctions::init(L);
		GuildFunctions::init(L);
		MountFunctions::init(L);
		PartyFunctions::init(L);
		VocationFunctions::init(L);
	}

	static int luaPlayerCreate(lua_State* L);

	static int luaPlayerUnlockAllCharmRunes(lua_State* L);
	static int luaPlayerResetCharmsMonsters(lua_State* L);
	static int luaPlayeraddCharmPoints(lua_State* L);
	static int luaPlayerIsPlayer(lua_State* L);

	static int luaPlayerGetGuid(lua_State* L);
	static int luaPlayerGetIp(lua_State* L);
	static int luaPlayerGetAccountId(lua_State* L);
	static int luaPlayerGetLastLoginSaved(lua_State* L);
	static int luaPlayerGetLastLogout(lua_State* L);

	static int luaPlayerGetAccountType(lua_State* L);
	static int luaPlayerSetAccountType(lua_State* L);

	static int luaPlayerAddBestiaryKill(lua_State* L);
	static int luaPlayerIsMonsterBestiaryUnlocked(lua_State* L);
	static int luaPlayercharmExpansion(lua_State* L);
	static int luaPlayergetCharmMonsterType(lua_State* L);

	static int luaPlayerisMonsterPrey(lua_State* L);
	static int luaPlayerGetPreyCards(lua_State* L);
	static int luaPlayerGetPreyLootPercentage(lua_State* L);
	static int luaPlayerPreyThirdSlot(lua_State* L);
	static int luaPlayerTaskThirdSlot(lua_State* L);
	static int luaPlayerRemovePreyStamina(lua_State* L);
	static int luaPlayerAddPreyCards(lua_State* L);
	static int luaPlayerGetPreyExperiencePercentage(lua_State* L);
	static int luaPlayerRemoveTaskHuntingPoints(lua_State* L);
	static int luaPlayerGetTaskHuntingPoints(lua_State* L);
	static int luaPlayerAddTaskHuntingPoints(lua_State* L);

	static int luaPlayerGetCapacity(lua_State* L);
	static int luaPlayerSetCapacity(lua_State* L);

	static int luaPlayerGetIsTraining(lua_State* L);
	static int luaPlayerSetTraining(lua_State* L);

	static int luaPlayerGetKills(lua_State* L);
	static int luaPlayerSetKills(lua_State* L);

	static int luaPlayerGetFreeCapacity(lua_State* L);

	static int luaPlayerGetReward(lua_State* L);
	static int luaPlayerRemoveReward(lua_State* L);
	static int luaPlayerGetRewardList(lua_State* L);

	static int luaPlayerSetDailyReward(lua_State* L);

	static int luaPlayerSendInventory(lua_State* L);
	static int luaPlayerSendLootStats(lua_State* L);
	static int luaPlayerUpdateKillTracker(lua_State* L);
	static int luaPlayerUpdateSupplyTracker(lua_State* L);

	static int luaPlayerGetDepotLocker(lua_State* L);
	static int luaPlayerGetDepotChest(lua_State* L);
	static int luaPlayerGetInbox(lua_State* L);

	static int luaPlayerGetSkullTime(lua_State* L);
	static int luaPlayerSetSkullTime(lua_State* L);
	static int luaPlayerGetDeathPenalty(lua_State* L);

	static int luaPlayerGetExperience(lua_State* L);
	static int luaPlayerAddExperience(lua_State* L);
	static int luaPlayerRemoveExperience(lua_State* L);
	static int luaPlayerGetLevel(lua_State* L);

	static int luaPlayerGetMagicShieldCapacityFlat(lua_State* L);
	static int luaPlayerGetMagicShieldCapacityPercent(lua_State* L);

	static int luaPlayerSendSpellCooldown(lua_State* L);
	static int luaPlayerSendSpellGroupCooldown(lua_State* L);

	static int luaPlayerGetMagicLevel(lua_State* L);
	static int luaPlayerGetBaseMagicLevel(lua_State* L);
	static int luaPlayerGetMana(lua_State* L);
	static int luaPlayerAddMana(lua_State* L);
	static int luaPlayerGetMaxMana(lua_State* L);
	static int luaPlayerSetMaxMana(lua_State* L);
	static int luaPlayerGetManaSpent(lua_State* L);
	static int luaPlayerAddManaSpent(lua_State* L);

	static int luaPlayerGetBaseMaxHealth(lua_State* L);
	static int luaPlayerGetBaseMaxMana(lua_State* L);

	static int luaPlayerGetSkillLevel(lua_State* L);
	static int luaPlayerGetEffectiveSkillLevel(lua_State* L);
	static int luaPlayerGetSkillPercent(lua_State* L);
	static int luaPlayerGetSkillTries(lua_State* L);
	static int luaPlayerAddSkillTries(lua_State* L);

	static int luaPlayerSetLevel(lua_State* L);
	static int luaPlayerSetMagicLevel(lua_State* L);
	static int luaPlayerSetSkillLevel(lua_State* L);

	static int luaPlayerAddOfflineTrainingTime(lua_State* L);
	static int luaPlayerGetOfflineTrainingTime(lua_State* L);
	static int luaPlayerRemoveOfflineTrainingTime(lua_State* L);

	static int luaPlayerAddOfflineTrainingTries(lua_State* L);

	static int luaPlayerGetOfflineTrainingSkill(lua_State* L);
	static int luaPlayerSetOfflineTrainingSkill(lua_State* L);

	static int luaPlayerGetItemCount(lua_State* L);
	static int luaPlayerGetStashItemCount(lua_State* L);
	static int luaPlayerGetItemById(lua_State* L);

	static int luaPlayerGetVocation(lua_State* L);
	static int luaPlayerSetVocation(lua_State* L);
	static int luaPlayerIsPromoted(lua_State* L);

	static int luaPlayerGetSex(lua_State* L);
	static int luaPlayerSetSex(lua_State* L);

	static int luaPlayerGetPronoun(lua_State* L);
	static int luaPlayerSetPronoun(lua_State* L);

	static int luaPlayerGetTown(lua_State* L);
	static int luaPlayerSetTown(lua_State* L);

	static int luaPlayerGetGuild(lua_State* L);
	static int luaPlayerSetGuild(lua_State* L);

	static int luaPlayerGetGuildLevel(lua_State* L);
	static int luaPlayerSetGuildLevel(lua_State* L);

	static int luaPlayerGetGuildNick(lua_State* L);
	static int luaPlayerSetGuildNick(lua_State* L);

	static int luaPlayerGetGroup(lua_State* L);
	static int luaPlayerSetGroup(lua_State* L);

	static int luaPlayerIsSupplyStashAvailable(lua_State* L);
	static int luaPlayerGetStashCounter(lua_State* L);
	static int luaPlayerOpenStash(lua_State* L);
	static int luaPlayerSetSpecialContainersAvailable(lua_State* L);

	static int luaPlayerGetStamina(lua_State* L);
	static int luaPlayerSetStamina(lua_State* L);

	static int luaPlayerGetSoul(lua_State* L);
	static int luaPlayerAddSoul(lua_State* L);
	static int luaPlayerGetMaxSoul(lua_State* L);

	static int luaPlayerGetBankBalance(lua_State* L);
	static int luaPlayerSetBankBalance(lua_State* L);

	static int luaPlayerGetStorageValue(lua_State* L);
	static int luaPlayerSetStorageValue(lua_State* L);
	static int luaPlayerGetStorageValueByName(lua_State* L);
	static int luaPlayerSetStorageValueByName(lua_State* L);

	static int luaPlayerAddItem(lua_State* L);
	static int luaPlayerAddItemEx(lua_State* L);
	static int luaPlayerAddItemStash(lua_State* L);
	static int luaPlayerRemoveStashItem(lua_State* L);
	static int luaPlayerRemoveItem(lua_State* L);
	static int luaPlayerSendContainer(lua_State* L);
	static int luaPlayerSendUpdateContainer(lua_State* L);

	static int luaPlayerGetMoney(lua_State* L);
	static int luaPlayerAddMoney(lua_State* L);
	static int luaPlayerRemoveMoney(lua_State* L);

	static int luaPlayerShowTextDialog(lua_State* L);

	static int luaPlayerSendTextMessage(lua_State* L);
	static int luaPlayerSendChannelMessage(lua_State* L);
	static int luaPlayerSendPrivateMessage(lua_State* L);

	static int luaPlayerChannelSay(lua_State* L);
	static int luaPlayerOpenChannel(lua_State* L);

	static int luaPlayerGetSlotItem(lua_State* L);

	static int luaPlayerGetParty(lua_State* L);

	static int luaPlayerAddOutfit(lua_State* L);
	static int luaPlayerAddOutfitAddon(lua_State* L);
	static int luaPlayerRemoveOutfit(lua_State* L);
	static int luaPlayerRemoveOutfitAddon(lua_State* L);
	static int luaPlayerHasOutfit(lua_State* L);
	static int luaPlayerSendOutfitWindow(lua_State* L);

	static int luaPlayerAddMount(lua_State* L);
	static int luaPlayerRemoveMount(lua_State* L);
	static int luaPlayerHasMount(lua_State* L);

	static int luaPlayerAddFamiliar(lua_State* L);
	static int luaPlayerRemoveFamiliar(lua_State* L);
	static int luaPlayerHasFamiliar(lua_State* L);
	static int luaPlayerSetFamiliarLooktype(lua_State* L);
	static int luaPlayerGetFamiliarLooktype(lua_State* L);

	static int luaPlayerGetPremiumDays(lua_State* L);
	static int luaPlayerAddPremiumDays(lua_State* L);
	static int luaPlayerRemovePremiumDays(lua_State* L);

	static int luaPlayerGetTibiaCoins(lua_State* L);
	static int luaPlayerAddTibiaCoins(lua_State* L);
	static int luaPlayerRemoveTibiaCoins(lua_State* L);

	static int luaPlayerGetTransferableCoins(lua_State* L);
	static int luaPlayerAddTransferableCoins(lua_State* L);
	static int luaPlayerRemoveTransferableCoins(lua_State* L);

	static int luaPlayerHasBlessing(lua_State* L);
	static int luaPlayerAddBlessing(lua_State* L);
	static int luaPlayerRemoveBlessing(lua_State* L);

	static int luaPlayerGetBlessingCount(lua_State* L);

	static int luaPlayerCanLearnSpell(lua_State* L);
	static int luaPlayerLearnSpell(lua_State* L);
	static int luaPlayerForgetSpell(lua_State* L);
	static int luaPlayerHasLearnedSpell(lua_State* L);

	static int luaPlayerOpenImbuementWindow(lua_State* L);
	static int luaPlayerCloseImbuementWindow(lua_State* L);

	static int luaPlayerSendTutorial(lua_State* L);
	static int luaPlayerAddMapMark(lua_State* L);

	static int luaPlayerSave(lua_State* L);
	static int luaPlayerPopupFYI(lua_State* L);

	static int luaPlayerIsPzLocked(lua_State* L);
	static int luaPlayerIsOffline(lua_State* L);

	static int luaPlayerGetClient(lua_State* L);

	static int luaPlayerGetHouse(lua_State* L);
	static int luaPlayerSendHouseWindow(lua_State* L);
	static int luaPlayerSetEditHouse(lua_State* L);

	static int luaPlayerSetGhostMode(lua_State* L);

	static int luaPlayerGetContainerId(lua_State* L);
	static int luaPlayerGetContainerById(lua_State* L);
	static int luaPlayerGetContainerIndex(lua_State* L);

	static int luaPlayerGetInstantSpells(lua_State* L);
	static int luaPlayerCanCast(lua_State* L);

	static int luaPlayerHasChaseMode(lua_State* L);
	static int luaPlayerHasSecureMode(lua_State* L);
	static int luaPlayerGetFightMode(lua_State* L);

	static int luaPlayerGetBaseXpGain(lua_State* L);
	static int luaPlayerSetBaseXpGain(lua_State* L);
	static int luaPlayerGetVoucherXpBoost(lua_State* L);
	static int luaPlayerSetVoucherXpBoost(lua_State* L);
	static int luaPlayerGetGrindingXpBoost(lua_State* L);
	static int luaPlayerSetGrindingXpBoost(lua_State* L);
	static int luaPlayerGetXpBoostPercent(lua_State* L);
	static int luaPlayerSetXpBoostPercent(lua_State* L);
	static int luaPlayerGetStaminaXpBoost(lua_State* L);
	static int luaPlayerSetStaminaXpBoost(lua_State* L);
	static int luaPlayerGetXpBoostTime(lua_State* L);
	static int luaPlayerSetXpBoostTime(lua_State* L);

	static int luaPlayerGetIdleTime(lua_State* L);
	static int luaPlayerGetFreeBackpackSlots(lua_State* L);

	static int luaPlayerOpenMarket(lua_State* L);

	static int luaPlayerInstantSkillWOD(lua_State* L);
	static int luaPlayerUpgradeSpellWOD(lua_State* L);
	static int luaPlayerRevelationStageWOD(lua_State* L);
	static int luaPlayerReloadData(lua_State* L);
	static int luaPlayerOnThinkWheelOfDestiny(lua_State* L);
	static int luaPlayerAvatarTimer(lua_State* L);
	static int luaPlayerGetWheelSpellAdditionalArea(lua_State* L);
	static int luaPlayerGetWheelSpellAdditionalTarget(lua_State* L);
	static int luaPlayerGetWheelSpellAdditionalDuration(lua_State* L);

	static int luaPlayerOpenForge(lua_State* L);
	static int luaPlayerCloseForge(lua_State* L);
	static int luaPlayerSendForgeError(lua_State* L);

	static int luaPlayerAddForgeDusts(lua_State* L);
	static int luaPlayerRemoveForgeDusts(lua_State* L);
	static int luaPlayerGetForgeDusts(lua_State* L);
	static int luaPlayerSetForgeDusts(lua_State* L);

	static int luaPlayerAddForgeDustLevel(lua_State* L);
	static int luaPlayerRemoveForgeDustLevel(lua_State* L);
	static int luaPlayerGetForgeDustLevel(lua_State* L);

	static int luaPlayerGetForgeSlivers(lua_State* L);
	static int luaPlayerGetForgeCores(lua_State* L);
	static int luaPlayerIsUIExhausted(lua_State* L);
	static int luaPlayerUpdateUIExhausted(lua_State* L);

	static int luaPlayerSetFaction(lua_State* L);
	static int luaPlayerGetFaction(lua_State* L);

	static int luaPlayerGetBosstiaryLevel(lua_State* L);
	static int luaPlayerGetBosstiaryKills(lua_State* L);
	static int luaPlayerAddBosstiaryKill(lua_State* L);
	static int luaPlayerSetBossPoints(lua_State* L);
	static int luaPlayerSetRemoveBossTime(lua_State* L);
	static int luaPlayerGetSlotBossId(lua_State* L);
	static int luaPlayerGetBossBonus(lua_State* L);
	static int luaPlayerBosstiaryCooldownTimer(lua_State* L);

	static int luaPlayerSendSingleSoundEffect(lua_State* L);
	static int luaPlayerSendDoubleSoundEffect(lua_State* L);

	static int luaPlayerGetName(lua_State* L);
	static int luaPlayerChangeName(lua_State* L);

	static int luaPlayerHasGroupFlag(lua_State* L);
	static int luaPlayerSetGroupFlag(lua_State* L);
	static int luaPlayerRemoveGroupFlag(lua_State* L);

	// Hazard system
	static int luaPlayerAddHazardSystemPoints(lua_State* L);
	static int luaPlayerGetHazardSystemPoints(lua_State* L);

	// Loyalty system
	static int luaPlayerSetLoyaltyBonus(lua_State* L);
	static int luaPlayerGetLoyaltyBonus(lua_State* L);
	static int luaPlayerGetLoyaltyPoints(lua_State* L);
	static int luaPlayerGetLoyaltyTitle(lua_State* L);
	static int luaPlayerSetLoyaltyTitle(lua_State* L);

	// Concoction system
	static int luaPlayerUpdateConcoction(lua_State* L);
	static int luaPlayerClearSpellCooldowns(lua_State* L);

	static int luaPlayerIsVip(lua_State* L);
	static int luaPlayerGetVipDays(lua_State* L);
	static int luaPlayerGetVipTime(lua_State* L);

	static int luaPlayerKV(lua_State* L);
	static int luaPlayerGetStoreInbox(lua_State* L);

	static int luaPlayerHasAchievement(lua_State* L);
	static int luaPlayerAddAchievement(lua_State* L);
	static int luaPlayerRemoveAchievement(lua_State* L);
	static int luaPlayerGetAchievementPoints(lua_State* L);
	static int luaPlayerAddAchievementPoints(lua_State* L);
	static int luaPlayerRemoveAchievementPoints(lua_State* L);

	static int luaPlayerAddBadge(lua_State* L);

	static int luaPlayerAddTitle(lua_State* L);
	static int luaPlayerGetTitles(lua_State* L);
	static int luaPlayerSetCurrentTitle(lua_State* L);

	static int luaPlayerCreateTransactionSummary(lua_State* L);

	friend class CreatureFunctions;
};
