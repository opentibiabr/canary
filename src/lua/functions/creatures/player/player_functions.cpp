/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/player/player_functions.hpp"

#include "account/account.hpp"
#include "creatures/appearance/mounts/mounts.hpp"
#include "creatures/combat/spells.hpp"
#include "creatures/creature.hpp"
#include "creatures/interactions/chat.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/players/achievement/player_achievement.hpp"
#include "creatures/players/cyclopedia/player_cyclopedia.hpp"
#include "creatures/players/cyclopedia/player_title.hpp"
#include "creatures/players/player.hpp"
#include "creatures/players/vip/player_vip.hpp"
#include "creatures/players/vocations/vocation.hpp"
#include "creatures/players/wheel/player_wheel.hpp"
#include "server/network/protocol/protocolgame.hpp"
#include "game/game.hpp"
#include "game/scheduling/save_manager.hpp"
#include "io/iobestiary.hpp"
#include "io/iologindata.hpp"
#include "io/ioprey.hpp"
#include "items/containers/depot/depotchest.hpp"
#include "items/containers/depot/depotlocker.hpp"
#include "items/containers/rewards/reward.hpp"
#include "items/item.hpp"
#include "map/spectators.hpp"
#include "kv/kv.hpp"

#include "enums/account_coins.hpp"
#include "enums/account_errors.hpp"
#include "enums/player_icons.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void PlayerFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Player", "Creature", PlayerFunctions::luaPlayerCreate);
	Lua::registerMetaMethod(L, "Player", "__eq", Lua::luaUserdataCompare);

	Lua::registerMethod(L, "Player", "resetCharmsBestiary", PlayerFunctions::luaPlayerResetCharmsMonsters);
	Lua::registerMethod(L, "Player", "unlockAllCharmRunes", PlayerFunctions::luaPlayerUnlockAllCharmRunes);
	Lua::registerMethod(L, "Player", "addCharmPoints", PlayerFunctions::luaPlayeraddCharmPoints);
	Lua::registerMethod(L, "Player", "isPlayer", PlayerFunctions::luaPlayerIsPlayer);

	Lua::registerMethod(L, "Player", "getGuid", PlayerFunctions::luaPlayerGetGuid);
	Lua::registerMethod(L, "Player", "getIp", PlayerFunctions::luaPlayerGetIp);
	Lua::registerMethod(L, "Player", "getAccountId", PlayerFunctions::luaPlayerGetAccountId);
	Lua::registerMethod(L, "Player", "getLastLoginSaved", PlayerFunctions::luaPlayerGetLastLoginSaved);
	Lua::registerMethod(L, "Player", "getLastLogout", PlayerFunctions::luaPlayerGetLastLogout);

	Lua::registerMethod(L, "Player", "getAccountType", PlayerFunctions::luaPlayerGetAccountType);
	Lua::registerMethod(L, "Player", "setAccountType", PlayerFunctions::luaPlayerSetAccountType);

	Lua::registerMethod(L, "Player", "isMonsterBestiaryUnlocked", PlayerFunctions::luaPlayerIsMonsterBestiaryUnlocked);
	Lua::registerMethod(L, "Player", "addBestiaryKill", PlayerFunctions::luaPlayerAddBestiaryKill);
	Lua::registerMethod(L, "Player", "charmExpansion", PlayerFunctions::luaPlayercharmExpansion);
	Lua::registerMethod(L, "Player", "getCharmMonsterType", PlayerFunctions::luaPlayergetCharmMonsterType);

	Lua::registerMethod(L, "Player", "isMonsterPrey", PlayerFunctions::luaPlayerisMonsterPrey);
	Lua::registerMethod(L, "Player", "getPreyCards", PlayerFunctions::luaPlayerGetPreyCards);
	Lua::registerMethod(L, "Player", "getPreyLootPercentage", PlayerFunctions::luaPlayerGetPreyLootPercentage);
	Lua::registerMethod(L, "Player", "getPreyExperiencePercentage", PlayerFunctions::luaPlayerGetPreyExperiencePercentage);
	Lua::registerMethod(L, "Player", "preyThirdSlot", PlayerFunctions::luaPlayerPreyThirdSlot);
	Lua::registerMethod(L, "Player", "taskHuntingThirdSlot", PlayerFunctions::luaPlayerTaskThirdSlot);
	Lua::registerMethod(L, "Player", "removePreyStamina", PlayerFunctions::luaPlayerRemovePreyStamina);
	Lua::registerMethod(L, "Player", "addPreyCards", PlayerFunctions::luaPlayerAddPreyCards);
	Lua::registerMethod(L, "Player", "removeTaskHuntingPoints", PlayerFunctions::luaPlayerRemoveTaskHuntingPoints);
	Lua::registerMethod(L, "Player", "getTaskHuntingPoints", PlayerFunctions::luaPlayerGetTaskHuntingPoints);
	Lua::registerMethod(L, "Player", "addTaskHuntingPoints", PlayerFunctions::luaPlayerAddTaskHuntingPoints);

	Lua::registerMethod(L, "Player", "getCapacity", PlayerFunctions::luaPlayerGetCapacity);
	Lua::registerMethod(L, "Player", "setCapacity", PlayerFunctions::luaPlayerSetCapacity);

	Lua::registerMethod(L, "Player", "isTraining", PlayerFunctions::luaPlayerGetIsTraining);
	Lua::registerMethod(L, "Player", "setTraining", PlayerFunctions::luaPlayerSetTraining);

	Lua::registerMethod(L, "Player", "getFreeCapacity", PlayerFunctions::luaPlayerGetFreeCapacity);

	Lua::registerMethod(L, "Player", "getKills", PlayerFunctions::luaPlayerGetKills);
	Lua::registerMethod(L, "Player", "setKills", PlayerFunctions::luaPlayerSetKills);

	Lua::registerMethod(L, "Player", "getReward", PlayerFunctions::luaPlayerGetReward);
	Lua::registerMethod(L, "Player", "removeReward", PlayerFunctions::luaPlayerRemoveReward);
	Lua::registerMethod(L, "Player", "getRewardList", PlayerFunctions::luaPlayerGetRewardList);

	Lua::registerMethod(L, "Player", "setDailyReward", PlayerFunctions::luaPlayerSetDailyReward);

	Lua::registerMethod(L, "Player", "sendInventory", PlayerFunctions::luaPlayerSendInventory);
	Lua::registerMethod(L, "Player", "sendLootStats", PlayerFunctions::luaPlayerSendLootStats);
	Lua::registerMethod(L, "Player", "updateSupplyTracker", PlayerFunctions::luaPlayerUpdateSupplyTracker);
	Lua::registerMethod(L, "Player", "updateKillTracker", PlayerFunctions::luaPlayerUpdateKillTracker);

	Lua::registerMethod(L, "Player", "getDepotLocker", PlayerFunctions::luaPlayerGetDepotLocker);
	Lua::registerMethod(L, "Player", "getDepotChest", PlayerFunctions::luaPlayerGetDepotChest);
	Lua::registerMethod(L, "Player", "getInbox", PlayerFunctions::luaPlayerGetInbox);

	Lua::registerMethod(L, "Player", "getSkullTime", PlayerFunctions::luaPlayerGetSkullTime);
	Lua::registerMethod(L, "Player", "setSkullTime", PlayerFunctions::luaPlayerSetSkullTime);
	Lua::registerMethod(L, "Player", "getDeathPenalty", PlayerFunctions::luaPlayerGetDeathPenalty);

	Lua::registerMethod(L, "Player", "getExperience", PlayerFunctions::luaPlayerGetExperience);
	Lua::registerMethod(L, "Player", "addExperience", PlayerFunctions::luaPlayerAddExperience);
	Lua::registerMethod(L, "Player", "removeExperience", PlayerFunctions::luaPlayerRemoveExperience);
	Lua::registerMethod(L, "Player", "getLevel", PlayerFunctions::luaPlayerGetLevel);

	Lua::registerMethod(L, "Player", "getMagicShieldCapacityFlat", PlayerFunctions::luaPlayerGetMagicShieldCapacityFlat);
	Lua::registerMethod(L, "Player", "getMagicShieldCapacityPercent", PlayerFunctions::luaPlayerGetMagicShieldCapacityPercent);

	Lua::registerMethod(L, "Player", "sendSpellCooldown", PlayerFunctions::luaPlayerSendSpellCooldown);
	Lua::registerMethod(L, "Player", "sendSpellGroupCooldown", PlayerFunctions::luaPlayerSendSpellGroupCooldown);

	Lua::registerMethod(L, "Player", "getMagicLevel", PlayerFunctions::luaPlayerGetMagicLevel);
	Lua::registerMethod(L, "Player", "getBaseMagicLevel", PlayerFunctions::luaPlayerGetBaseMagicLevel);
	Lua::registerMethod(L, "Player", "getMana", PlayerFunctions::luaPlayerGetMana);
	Lua::registerMethod(L, "Player", "addMana", PlayerFunctions::luaPlayerAddMana);
	Lua::registerMethod(L, "Player", "getMaxMana", PlayerFunctions::luaPlayerGetMaxMana);
	Lua::registerMethod(L, "Player", "setMaxMana", PlayerFunctions::luaPlayerSetMaxMana);
	Lua::registerMethod(L, "Player", "getManaSpent", PlayerFunctions::luaPlayerGetManaSpent);
	Lua::registerMethod(L, "Player", "addManaSpent", PlayerFunctions::luaPlayerAddManaSpent);

	Lua::registerMethod(L, "Player", "getBaseMaxHealth", PlayerFunctions::luaPlayerGetBaseMaxHealth);
	Lua::registerMethod(L, "Player", "getBaseMaxMana", PlayerFunctions::luaPlayerGetBaseMaxMana);

	Lua::registerMethod(L, "Player", "getSkillLevel", PlayerFunctions::luaPlayerGetSkillLevel);
	Lua::registerMethod(L, "Player", "getEffectiveSkillLevel", PlayerFunctions::luaPlayerGetEffectiveSkillLevel);
	Lua::registerMethod(L, "Player", "getSkillPercent", PlayerFunctions::luaPlayerGetSkillPercent);
	Lua::registerMethod(L, "Player", "getSkillTries", PlayerFunctions::luaPlayerGetSkillTries);
	Lua::registerMethod(L, "Player", "addSkillTries", PlayerFunctions::luaPlayerAddSkillTries);

	Lua::registerMethod(L, "Player", "setLevel", PlayerFunctions::luaPlayerSetLevel);
	Lua::registerMethod(L, "Player", "setMagicLevel", PlayerFunctions::luaPlayerSetMagicLevel);
	Lua::registerMethod(L, "Player", "setSkillLevel", PlayerFunctions::luaPlayerSetSkillLevel);

	Lua::registerMethod(L, "Player", "addOfflineTrainingTime", PlayerFunctions::luaPlayerAddOfflineTrainingTime);
	Lua::registerMethod(L, "Player", "getOfflineTrainingTime", PlayerFunctions::luaPlayerGetOfflineTrainingTime);
	Lua::registerMethod(L, "Player", "removeOfflineTrainingTime", PlayerFunctions::luaPlayerRemoveOfflineTrainingTime);

	Lua::registerMethod(L, "Player", "addOfflineTrainingTries", PlayerFunctions::luaPlayerAddOfflineTrainingTries);

	Lua::registerMethod(L, "Player", "getOfflineTrainingSkill", PlayerFunctions::luaPlayerGetOfflineTrainingSkill);
	Lua::registerMethod(L, "Player", "setOfflineTrainingSkill", PlayerFunctions::luaPlayerSetOfflineTrainingSkill);

	Lua::registerMethod(L, "Player", "getItemCount", PlayerFunctions::luaPlayerGetItemCount);
	Lua::registerMethod(L, "Player", "getStashItemCount", PlayerFunctions::luaPlayerGetStashItemCount);
	Lua::registerMethod(L, "Player", "getItemById", PlayerFunctions::luaPlayerGetItemById);

	Lua::registerMethod(L, "Player", "getVocation", PlayerFunctions::luaPlayerGetVocation);
	Lua::registerMethod(L, "Player", "setVocation", PlayerFunctions::luaPlayerSetVocation);
	Lua::registerMethod(L, "Player", "isPromoted", PlayerFunctions::luaPlayerIsPromoted);

	Lua::registerMethod(L, "Player", "getSex", PlayerFunctions::luaPlayerGetSex);
	Lua::registerMethod(L, "Player", "setSex", PlayerFunctions::luaPlayerSetSex);

	Lua::registerMethod(L, "Player", "getPronoun", PlayerFunctions::luaPlayerGetPronoun);
	Lua::registerMethod(L, "Player", "setPronoun", PlayerFunctions::luaPlayerSetPronoun);

	Lua::registerMethod(L, "Player", "getTown", PlayerFunctions::luaPlayerGetTown);
	Lua::registerMethod(L, "Player", "setTown", PlayerFunctions::luaPlayerSetTown);

	Lua::registerMethod(L, "Player", "getGuild", PlayerFunctions::luaPlayerGetGuild);
	Lua::registerMethod(L, "Player", "setGuild", PlayerFunctions::luaPlayerSetGuild);

	Lua::registerMethod(L, "Player", "getGuildLevel", PlayerFunctions::luaPlayerGetGuildLevel);
	Lua::registerMethod(L, "Player", "setGuildLevel", PlayerFunctions::luaPlayerSetGuildLevel);

	Lua::registerMethod(L, "Player", "getGuildNick", PlayerFunctions::luaPlayerGetGuildNick);
	Lua::registerMethod(L, "Player", "setGuildNick", PlayerFunctions::luaPlayerSetGuildNick);

	Lua::registerMethod(L, "Player", "getGroup", PlayerFunctions::luaPlayerGetGroup);
	Lua::registerMethod(L, "Player", "setGroup", PlayerFunctions::luaPlayerSetGroup);

	Lua::registerMethod(L, "Player", "setSpecialContainersAvailable", PlayerFunctions::luaPlayerSetSpecialContainersAvailable);
	Lua::registerMethod(L, "Player", "getStashCount", PlayerFunctions::luaPlayerGetStashCounter);
	Lua::registerMethod(L, "Player", "openStash", PlayerFunctions::luaPlayerOpenStash);

	Lua::registerMethod(L, "Player", "getStamina", PlayerFunctions::luaPlayerGetStamina);
	Lua::registerMethod(L, "Player", "setStamina", PlayerFunctions::luaPlayerSetStamina);

	Lua::registerMethod(L, "Player", "getSoul", PlayerFunctions::luaPlayerGetSoul);
	Lua::registerMethod(L, "Player", "addSoul", PlayerFunctions::luaPlayerAddSoul);
	Lua::registerMethod(L, "Player", "getMaxSoul", PlayerFunctions::luaPlayerGetMaxSoul);

	Lua::registerMethod(L, "Player", "getBankBalance", PlayerFunctions::luaPlayerGetBankBalance);
	Lua::registerMethod(L, "Player", "setBankBalance", PlayerFunctions::luaPlayerSetBankBalance);

	Lua::registerMethod(L, "Player", "getStorageValue", PlayerFunctions::luaPlayerGetStorageValue);
	Lua::registerMethod(L, "Player", "setStorageValue", PlayerFunctions::luaPlayerSetStorageValue);

	Lua::registerMethod(L, "Player", "getStorageValueByName", PlayerFunctions::luaPlayerGetStorageValueByName);
	Lua::registerMethod(L, "Player", "setStorageValueByName", PlayerFunctions::luaPlayerSetStorageValueByName);

	Lua::registerMethod(L, "Player", "addItem", PlayerFunctions::luaPlayerAddItem);
	Lua::registerMethod(L, "Player", "addItemEx", PlayerFunctions::luaPlayerAddItemEx);
	Lua::registerMethod(L, "Player", "addItemStash", PlayerFunctions::luaPlayerAddItemStash);
	Lua::registerMethod(L, "Player", "removeStashItem", PlayerFunctions::luaPlayerRemoveStashItem);
	Lua::registerMethod(L, "Player", "removeItem", PlayerFunctions::luaPlayerRemoveItem);
	Lua::registerMethod(L, "Player", "sendContainer", PlayerFunctions::luaPlayerSendContainer);
	Lua::registerMethod(L, "Player", "sendUpdateContainer", PlayerFunctions::luaPlayerSendUpdateContainer);

	Lua::registerMethod(L, "Player", "getMoney", PlayerFunctions::luaPlayerGetMoney);
	Lua::registerMethod(L, "Player", "addMoney", PlayerFunctions::luaPlayerAddMoney);
	Lua::registerMethod(L, "Player", "removeMoney", PlayerFunctions::luaPlayerRemoveMoney);

	Lua::registerMethod(L, "Player", "showTextDialog", PlayerFunctions::luaPlayerShowTextDialog);

	Lua::registerMethod(L, "Player", "sendTextMessage", PlayerFunctions::luaPlayerSendTextMessage);
	Lua::registerMethod(L, "Player", "sendChannelMessage", PlayerFunctions::luaPlayerSendChannelMessage);
	Lua::registerMethod(L, "Player", "sendPrivateMessage", PlayerFunctions::luaPlayerSendPrivateMessage);
	Lua::registerMethod(L, "Player", "channelSay", PlayerFunctions::luaPlayerChannelSay);
	Lua::registerMethod(L, "Player", "openChannel", PlayerFunctions::luaPlayerOpenChannel);

	Lua::registerMethod(L, "Player", "getSlotItem", PlayerFunctions::luaPlayerGetSlotItem);

	Lua::registerMethod(L, "Player", "getParty", PlayerFunctions::luaPlayerGetParty);

	Lua::registerMethod(L, "Player", "addOutfit", PlayerFunctions::luaPlayerAddOutfit);
	Lua::registerMethod(L, "Player", "addOutfitAddon", PlayerFunctions::luaPlayerAddOutfitAddon);
	Lua::registerMethod(L, "Player", "removeOutfit", PlayerFunctions::luaPlayerRemoveOutfit);
	Lua::registerMethod(L, "Player", "removeOutfitAddon", PlayerFunctions::luaPlayerRemoveOutfitAddon);
	Lua::registerMethod(L, "Player", "hasOutfit", PlayerFunctions::luaPlayerHasOutfit);
	Lua::registerMethod(L, "Player", "sendOutfitWindow", PlayerFunctions::luaPlayerSendOutfitWindow);

	Lua::registerMethod(L, "Player", "addMount", PlayerFunctions::luaPlayerAddMount);
	Lua::registerMethod(L, "Player", "removeMount", PlayerFunctions::luaPlayerRemoveMount);
	Lua::registerMethod(L, "Player", "hasMount", PlayerFunctions::luaPlayerHasMount);

	Lua::registerMethod(L, "Player", "addFamiliar", PlayerFunctions::luaPlayerAddFamiliar);
	Lua::registerMethod(L, "Player", "removeFamiliar", PlayerFunctions::luaPlayerRemoveFamiliar);
	Lua::registerMethod(L, "Player", "hasFamiliar", PlayerFunctions::luaPlayerHasFamiliar);
	Lua::registerMethod(L, "Player", "setFamiliarLooktype", PlayerFunctions::luaPlayerSetFamiliarLooktype);
	Lua::registerMethod(L, "Player", "getFamiliarLooktype", PlayerFunctions::luaPlayerGetFamiliarLooktype);

	Lua::registerMethod(L, "Player", "getPremiumDays", PlayerFunctions::luaPlayerGetPremiumDays);
	Lua::registerMethod(L, "Player", "addPremiumDays", PlayerFunctions::luaPlayerAddPremiumDays);
	Lua::registerMethod(L, "Player", "removePremiumDays", PlayerFunctions::luaPlayerRemovePremiumDays);

	Lua::registerMethod(L, "Player", "getTibiaCoins", PlayerFunctions::luaPlayerGetTibiaCoins);
	Lua::registerMethod(L, "Player", "addTibiaCoins", PlayerFunctions::luaPlayerAddTibiaCoins);
	Lua::registerMethod(L, "Player", "removeTibiaCoins", PlayerFunctions::luaPlayerRemoveTibiaCoins);

	Lua::registerMethod(L, "Player", "getTransferableCoins", PlayerFunctions::luaPlayerGetTransferableCoins);
	Lua::registerMethod(L, "Player", "addTransferableCoins", PlayerFunctions::luaPlayerAddTransferableCoins);
	Lua::registerMethod(L, "Player", "removeTransferableCoins", PlayerFunctions::luaPlayerRemoveTransferableCoins);

	Lua::registerMethod(L, "Player", "sendBlessStatus", PlayerFunctions::luaPlayerSendBlessStatus);
	Lua::registerMethod(L, "Player", "hasBlessing", PlayerFunctions::luaPlayerHasBlessing);
	Lua::registerMethod(L, "Player", "addBlessing", PlayerFunctions::luaPlayerAddBlessing);
	Lua::registerMethod(L, "Player", "removeBlessing", PlayerFunctions::luaPlayerRemoveBlessing);
	Lua::registerMethod(L, "Player", "getBlessingCount", PlayerFunctions::luaPlayerGetBlessingCount);

	Lua::registerMethod(L, "Player", "canLearnSpell", PlayerFunctions::luaPlayerCanLearnSpell);
	Lua::registerMethod(L, "Player", "learnSpell", PlayerFunctions::luaPlayerLearnSpell);
	Lua::registerMethod(L, "Player", "forgetSpell", PlayerFunctions::luaPlayerForgetSpell);
	Lua::registerMethod(L, "Player", "hasLearnedSpell", PlayerFunctions::luaPlayerHasLearnedSpell);

	Lua::registerMethod(L, "Player", "openImbuementWindow", PlayerFunctions::luaPlayerOpenImbuementWindow);
	Lua::registerMethod(L, "Player", "closeImbuementWindow", PlayerFunctions::luaPlayerCloseImbuementWindow);

	Lua::registerMethod(L, "Player", "sendTutorial", PlayerFunctions::luaPlayerSendTutorial);
	Lua::registerMethod(L, "Player", "addMapMark", PlayerFunctions::luaPlayerAddMapMark);

	Lua::registerMethod(L, "Player", "save", PlayerFunctions::luaPlayerSave);
	Lua::registerMethod(L, "Player", "popupFYI", PlayerFunctions::luaPlayerPopupFYI);

	Lua::registerMethod(L, "Player", "isPzLocked", PlayerFunctions::luaPlayerIsPzLocked);

	Lua::registerMethod(L, "Player", "getClient", PlayerFunctions::luaPlayerGetClient);

	Lua::registerMethod(L, "Player", "getHouse", PlayerFunctions::luaPlayerGetHouse);
	Lua::registerMethod(L, "Player", "sendHouseWindow", PlayerFunctions::luaPlayerSendHouseWindow);
	Lua::registerMethod(L, "Player", "setEditHouse", PlayerFunctions::luaPlayerSetEditHouse);

	Lua::registerMethod(L, "Player", "setGhostMode", PlayerFunctions::luaPlayerSetGhostMode);

	Lua::registerMethod(L, "Player", "getContainerId", PlayerFunctions::luaPlayerGetContainerId);
	Lua::registerMethod(L, "Player", "getContainerById", PlayerFunctions::luaPlayerGetContainerById);
	Lua::registerMethod(L, "Player", "getContainerIndex", PlayerFunctions::luaPlayerGetContainerIndex);

	Lua::registerMethod(L, "Player", "getInstantSpells", PlayerFunctions::luaPlayerGetInstantSpells);
	Lua::registerMethod(L, "Player", "canCast", PlayerFunctions::luaPlayerCanCast);

	Lua::registerMethod(L, "Player", "hasChaseMode", PlayerFunctions::luaPlayerHasChaseMode);
	Lua::registerMethod(L, "Player", "hasSecureMode", PlayerFunctions::luaPlayerHasSecureMode);
	Lua::registerMethod(L, "Player", "getFightMode", PlayerFunctions::luaPlayerGetFightMode);

	Lua::registerMethod(L, "Player", "getBaseXpGain", PlayerFunctions::luaPlayerGetBaseXpGain);
	Lua::registerMethod(L, "Player", "setBaseXpGain", PlayerFunctions::luaPlayerSetBaseXpGain);
	Lua::registerMethod(L, "Player", "getVoucherXpBoost", PlayerFunctions::luaPlayerGetVoucherXpBoost);
	Lua::registerMethod(L, "Player", "setVoucherXpBoost", PlayerFunctions::luaPlayerSetVoucherXpBoost);
	Lua::registerMethod(L, "Player", "getGrindingXpBoost", PlayerFunctions::luaPlayerGetGrindingXpBoost);
	Lua::registerMethod(L, "Player", "setGrindingXpBoost", PlayerFunctions::luaPlayerSetGrindingXpBoost);
	Lua::registerMethod(L, "Player", "getXpBoostPercent", PlayerFunctions::luaPlayerGetXpBoostPercent);
	Lua::registerMethod(L, "Player", "setXpBoostPercent", PlayerFunctions::luaPlayerSetXpBoostPercent);
	Lua::registerMethod(L, "Player", "getStaminaXpBoost", PlayerFunctions::luaPlayerGetStaminaXpBoost);
	Lua::registerMethod(L, "Player", "setStaminaXpBoost", PlayerFunctions::luaPlayerSetStaminaXpBoost);
	Lua::registerMethod(L, "Player", "getXpBoostTime", PlayerFunctions::luaPlayerGetXpBoostTime);
	Lua::registerMethod(L, "Player", "setXpBoostTime", PlayerFunctions::luaPlayerSetXpBoostTime);

	Lua::registerMethod(L, "Player", "getIdleTime", PlayerFunctions::luaPlayerGetIdleTime);
	Lua::registerMethod(L, "Player", "getFreeBackpackSlots", PlayerFunctions::luaPlayerGetFreeBackpackSlots);

	Lua::registerMethod(L, "Player", "isOffline", PlayerFunctions::luaPlayerIsOffline);

	Lua::registerMethod(L, "Player", "openMarket", PlayerFunctions::luaPlayerOpenMarket);

	Lua::registerMethod(L, "Player", "instantSkillWOD", PlayerFunctions::luaPlayerInstantSkillWOD);
	Lua::registerMethod(L, "Player", "upgradeSpellsWOD", PlayerFunctions::luaPlayerUpgradeSpellWOD);
	Lua::registerMethod(L, "Player", "revelationStageWOD", PlayerFunctions::luaPlayerRevelationStageWOD);
	Lua::registerMethod(L, "Player", "reloadData", PlayerFunctions::luaPlayerReloadData);
	Lua::registerMethod(L, "Player", "onThinkWheelOfDestiny", PlayerFunctions::luaPlayerOnThinkWheelOfDestiny);
	Lua::registerMethod(L, "Player", "avatarTimer", PlayerFunctions::luaPlayerAvatarTimer);
	Lua::registerMethod(L, "Player", "getWheelSpellAdditionalArea", PlayerFunctions::luaPlayerGetWheelSpellAdditionalArea);
	Lua::registerMethod(L, "Player", "getWheelSpellAdditionalTarget", PlayerFunctions::luaPlayerGetWheelSpellAdditionalTarget);
	Lua::registerMethod(L, "Player", "getWheelSpellAdditionalDuration", PlayerFunctions::luaPlayerGetWheelSpellAdditionalDuration);

	// Forge Functions
	Lua::registerMethod(L, "Player", "openForge", PlayerFunctions::luaPlayerOpenForge);
	Lua::registerMethod(L, "Player", "closeForge", PlayerFunctions::luaPlayerCloseForge);

	Lua::registerMethod(L, "Player", "addForgeDusts", PlayerFunctions::luaPlayerAddForgeDusts);
	Lua::registerMethod(L, "Player", "removeForgeDusts", PlayerFunctions::luaPlayerRemoveForgeDusts);
	Lua::registerMethod(L, "Player", "getForgeDusts", PlayerFunctions::luaPlayerGetForgeDusts);
	Lua::registerMethod(L, "Player", "setForgeDusts", PlayerFunctions::luaPlayerSetForgeDusts);

	Lua::registerMethod(L, "Player", "addForgeDustLevel", PlayerFunctions::luaPlayerAddForgeDustLevel);
	Lua::registerMethod(L, "Player", "removeForgeDustLevel", PlayerFunctions::luaPlayerRemoveForgeDustLevel);
	Lua::registerMethod(L, "Player", "getForgeDustLevel", PlayerFunctions::luaPlayerGetForgeDustLevel);

	Lua::registerMethod(L, "Player", "getForgeSlivers", PlayerFunctions::luaPlayerGetForgeSlivers);
	Lua::registerMethod(L, "Player", "getForgeCores", PlayerFunctions::luaPlayerGetForgeCores);
	Lua::registerMethod(L, "Player", "isUIExhausted", PlayerFunctions::luaPlayerIsUIExhausted);
	Lua::registerMethod(L, "Player", "updateUIExhausted", PlayerFunctions::luaPlayerUpdateUIExhausted);

	Lua::registerMethod(L, "Player", "setFaction", PlayerFunctions::luaPlayerSetFaction);
	Lua::registerMethod(L, "Player", "getFaction", PlayerFunctions::luaPlayerGetFaction);

	// Bosstiary Functions
	Lua::registerMethod(L, "Player", "getBosstiaryLevel", PlayerFunctions::luaPlayerGetBosstiaryLevel);
	Lua::registerMethod(L, "Player", "getBosstiaryKills", PlayerFunctions::luaPlayerGetBosstiaryKills);
	Lua::registerMethod(L, "Player", "addBosstiaryKill", PlayerFunctions::luaPlayerAddBosstiaryKill);
	Lua::registerMethod(L, "Player", "setBossPoints", PlayerFunctions::luaPlayerSetBossPoints);
	Lua::registerMethod(L, "Player", "setRemoveBossTime", PlayerFunctions::luaPlayerSetRemoveBossTime);
	Lua::registerMethod(L, "Player", "getSlotBossId", PlayerFunctions::luaPlayerGetSlotBossId);
	Lua::registerMethod(L, "Player", "getBossBonus", PlayerFunctions::luaPlayerGetBossBonus);
	Lua::registerMethod(L, "Player", "sendBosstiaryCooldownTimer", PlayerFunctions::luaPlayerBosstiaryCooldownTimer);

	Lua::registerMethod(L, "Player", "sendSingleSoundEffect", PlayerFunctions::luaPlayerSendSingleSoundEffect);
	Lua::registerMethod(L, "Player", "sendDoubleSoundEffect", PlayerFunctions::luaPlayerSendDoubleSoundEffect);

	Lua::registerMethod(L, "Player", "getName", PlayerFunctions::luaPlayerGetName);
	Lua::registerMethod(L, "Player", "changeName", PlayerFunctions::luaPlayerChangeName);

	Lua::registerMethod(L, "Player", "hasGroupFlag", PlayerFunctions::luaPlayerHasGroupFlag);
	Lua::registerMethod(L, "Player", "setGroupFlag", PlayerFunctions::luaPlayerSetGroupFlag);
	Lua::registerMethod(L, "Player", "removeGroupFlag", PlayerFunctions::luaPlayerRemoveGroupFlag);

	Lua::registerMethod(L, "Player", "setHazardSystemPoints", PlayerFunctions::luaPlayerAddHazardSystemPoints);
	Lua::registerMethod(L, "Player", "getHazardSystemPoints", PlayerFunctions::luaPlayerGetHazardSystemPoints);

	Lua::registerMethod(L, "Player", "setLoyaltyBonus", PlayerFunctions::luaPlayerSetLoyaltyBonus);
	Lua::registerMethod(L, "Player", "getLoyaltyBonus", PlayerFunctions::luaPlayerGetLoyaltyBonus);
	Lua::registerMethod(L, "Player", "getLoyaltyPoints", PlayerFunctions::luaPlayerGetLoyaltyPoints);
	Lua::registerMethod(L, "Player", "getLoyaltyTitle", PlayerFunctions::luaPlayerGetLoyaltyTitle);
	Lua::registerMethod(L, "Player", "setLoyaltyTitle", PlayerFunctions::luaPlayerSetLoyaltyTitle);

	Lua::registerMethod(L, "Player", "updateConcoction", PlayerFunctions::luaPlayerUpdateConcoction);
	Lua::registerMethod(L, "Player", "clearSpellCooldowns", PlayerFunctions::luaPlayerClearSpellCooldowns);

	Lua::registerMethod(L, "Player", "isVip", PlayerFunctions::luaPlayerIsVip);
	Lua::registerMethod(L, "Player", "getVipDays", PlayerFunctions::luaPlayerGetVipDays);
	Lua::registerMethod(L, "Player", "getVipTime", PlayerFunctions::luaPlayerGetVipTime);

	Lua::registerMethod(L, "Player", "kv", PlayerFunctions::luaPlayerKV);
	Lua::registerMethod(L, "Player", "getStoreInbox", PlayerFunctions::luaPlayerGetStoreInbox);

	Lua::registerMethod(L, "Player", "hasAchievement", PlayerFunctions::luaPlayerHasAchievement);
	Lua::registerMethod(L, "Player", "addAchievement", PlayerFunctions::luaPlayerAddAchievement);
	Lua::registerMethod(L, "Player", "removeAchievement", PlayerFunctions::luaPlayerRemoveAchievement);
	Lua::registerMethod(L, "Player", "getAchievementPoints", PlayerFunctions::luaPlayerGetAchievementPoints);
	Lua::registerMethod(L, "Player", "addAchievementPoints", PlayerFunctions::luaPlayerAddAchievementPoints);
	Lua::registerMethod(L, "Player", "removeAchievementPoints", PlayerFunctions::luaPlayerRemoveAchievementPoints);

	// Badge Functions
	Lua::registerMethod(L, "Player", "addBadge", PlayerFunctions::luaPlayerAddBadge);

	// Title Functions
	Lua::registerMethod(L, "Player", "addTitle", PlayerFunctions::luaPlayerAddTitle);
	Lua::registerMethod(L, "Player", "getTitles", PlayerFunctions::luaPlayerGetTitles);
	Lua::registerMethod(L, "Player", "setCurrentTitle", PlayerFunctions::luaPlayerSetCurrentTitle);

	// Store Summary
	Lua::registerMethod(L, "Player", "createTransactionSummary", PlayerFunctions::luaPlayerCreateTransactionSummary);

	Lua::registerMethod(L, "Player", "takeScreenshot", PlayerFunctions::luaPlayerTakeScreenshot);
	Lua::registerMethod(L, "Player", "sendIconBakragore", PlayerFunctions::luaPlayerSendIconBakragore);
	Lua::registerMethod(L, "Player", "removeIconBakragore", PlayerFunctions::luaPlayerRemoveIconBakragore);
	Lua::registerMethod(L, "Player", "sendCreatureAppear", PlayerFunctions::luaPlayerSendCreatureAppear);

	GroupFunctions::init(L);
	GuildFunctions::init(L);
	MountFunctions::init(L);
	PartyFunctions::init(L);
	VocationFunctions::init(L);
}

int PlayerFunctions::luaPlayerSendInventory(lua_State* L) {
	// player:sendInventory()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->sendInventoryIds();
	Lua::pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerSendLootStats(lua_State* L) {
	// player:sendLootStats(item, count)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &item = Lua::getUserdataShared<Item>(L, 2);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	const auto count = Lua::getNumber<uint8_t>(L, 3, 0);
	if (count == 0) {
		lua_pushnil(L);
		return 1;
	}

	player->sendLootStats(item, count);
	Lua::pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerUpdateSupplyTracker(lua_State* L) {
	// player:updateSupplyTracker(item)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &item = Lua::getUserdataShared<Item>(L, 2);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	player->updateSupplyTracker(item);
	Lua::pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerUpdateKillTracker(lua_State* L) {
	// player:updateKillTracker(creature, corpse)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &monster = Lua::getUserdataShared<Creature>(L, 2);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	const auto &corpse = Lua::getUserdataShared<Container>(L, 3);
	if (!corpse) {
		lua_pushnil(L);
		return 1;
	}

	player->updateKillTracker(corpse, monster->getName(), monster->getCurrentOutfit());
	Lua::pushBoolean(L, true);

	return 1;
}

// Player
int PlayerFunctions::luaPlayerCreate(lua_State* L) {
	// Player(id or guid or name or userdata)
	std::shared_ptr<Player> player;
	if (Lua::isNumber(L, 2)) {
		const uint32_t id = Lua::getNumber<uint32_t>(L, 2);
		if (id >= Player::getFirstID() && id <= Player::getLastID()) {
			player = g_game().getPlayerByID(id);
		} else {
			player = g_game().getPlayerByGUID(id);
		}
	} else if (Lua::isString(L, 2)) {
		ReturnValue ret = g_game().getPlayerByNameWildcard(Lua::getString(L, 2), player);
		if (ret != RETURNVALUE_NOERROR) {
			lua_pushnil(L);
			lua_pushnumber(L, ret);
			return 2;
		}
	} else if (Lua::isUserdata(L, 2)) {
		if (Lua::getUserdataType(L, 2) != LuaData_t::Player) {
			lua_pushnil(L);
			return 1;
		}
		player = Lua::getUserdataShared<Player>(L, 2);
	} else {
		player = nullptr;
	}

	if (player) {
		Lua::pushUserdata<Player>(L, player);
		Lua::setMetatable(L, -1, "Player");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerResetCharmsMonsters(lua_State* L) {
	// player:resetCharmsBestiary()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->setCharmPoints(0);
		player->setCharmExpansion(false);
		player->setUsedRunesBit(0);
		player->setUnlockedRunesBit(0);
		for (int8_t i = CHARM_WOUND; i <= CHARM_LAST; i++) {
			player->parseRacebyCharm(static_cast<charmRune_t>(i), true, 0);
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerUnlockAllCharmRunes(lua_State* L) {
	// player:unlockAllCharmRunes()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		for (int8_t i = CHARM_WOUND; i <= CHARM_LAST; i++) {
			const auto charm = g_iobestiary().getBestiaryCharm(static_cast<charmRune_t>(i));
			if (charm) {
				const int32_t value = g_iobestiary().bitToggle(player->getUnlockedRunesBit(), charm, true);
				player->setUnlockedRunesBit(value);
			}
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayeraddCharmPoints(lua_State* L) {
	// player:addCharmPoints()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		int16_t charms = Lua::getNumber<int16_t>(L, 2);
		if (charms >= 0) {
			g_iobestiary().addCharmPoints(player, static_cast<uint16_t>(charms));
		} else {
			charms = -charms;
			g_iobestiary().addCharmPoints(player, static_cast<uint16_t>(charms), true);
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerIsPlayer(lua_State* L) {
	// player:isPlayer()
	Lua::pushBoolean(L, Lua::getUserdataShared<Player>(L, 1) != nullptr);
	return 1;
}

int PlayerFunctions::luaPlayerGetGuid(lua_State* L) {
	// player:getGuid()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getGUID());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetIp(lua_State* L) {
	// player:getIp()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getIP());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetAccountId(lua_State* L) {
	// player:getAccountId()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player || player->getAccountId() == 0) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, player->getAccountId());

	return 1;
}

int PlayerFunctions::luaPlayerGetLastLoginSaved(lua_State* L) {
	// player:getLastLoginSaved()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getLastLoginSaved());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetLastLogout(lua_State* L) {
	// player:getLastLogout()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getLastLogout());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetAccountType(lua_State* L) {
	// player:getAccountType()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getAccountType());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetAccountType(lua_State* L) {
	// player:setAccountType(accountType)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		lua_pushnil(L);
		return 1;
	}

	if (player->getAccount()->setAccountType(Lua::getNumber<AccountType>(L, 2)) != AccountErrors_t::Ok) {
		lua_pushnil(L);
		return 1;
	}

	if (player->getAccount()->save() != AccountErrors_t::Ok) {
		lua_pushnil(L);
		return 1;
	}

	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerAddBestiaryKill(lua_State* L) {
	// player:addBestiaryKill(name[, amount = 1])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const auto &mtype = g_monsters().getMonsterType(Lua::getString(L, 2));
		if (mtype) {
			g_iobestiary().addBestiaryKill(player, mtype, Lua::getNumber<uint32_t>(L, 3, 1));
			Lua::pushBoolean(L, true);
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerIsMonsterBestiaryUnlocked(lua_State* L) {
	// player:isMonsterBestiaryUnlocked(raceId)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player == nullptr) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	const auto raceId = Lua::getNumber<uint16_t>(L, 2, 0);
	if (!g_monsters().getMonsterTypeByRaceId(raceId)) {
		Lua::reportErrorFunc("Monster race id not exists");
		Lua::pushBoolean(L, false);
		return 0;
	}

	for (const uint16_t finishedRaceId : g_iobestiary().getBestiaryFinished(player)) {
		if (raceId == finishedRaceId) {
			Lua::pushBoolean(L, true);
			return 1;
		}
	}

	Lua::pushBoolean(L, false);
	return 0;
}

int PlayerFunctions::luaPlayergetCharmMonsterType(lua_State* L) {
	// player:getCharmMonsterType(charmRune_t)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const charmRune_t charmid = Lua::getNumber<charmRune_t>(L, 2);
		const uint16_t raceid = player->parseRacebyCharm(charmid, false, 0);
		if (raceid > 0) {
			const auto &mtype = g_monsters().getMonsterTypeByRaceId(raceid);
			if (mtype) {
				Lua::pushUserdata<MonsterType>(L, mtype);
				Lua::setMetatable(L, -1, "MonsterType");
			} else {
				lua_pushnil(L);
			}
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemovePreyStamina(lua_State* L) {
	// player:removePreyStamina(amount)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		g_ioprey().checkPlayerPreys(player, Lua::getNumber<uint8_t>(L, 2, 1));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddPreyCards(lua_State* L) {
	// player:addPreyCards(amount)
	if (const auto &player = Lua::getUserdataShared<Player>(L, 1)) {
		player->addPreyCards(Lua::getNumber<uint64_t>(L, 2, 0));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetPreyCards(lua_State* L) {
	// player:getPreyCards()
	if (const auto &player = Lua::getUserdataShared<Player>(L, 1)) {
		lua_pushnumber(L, static_cast<lua_Number>(player->getPreyCards()));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetPreyExperiencePercentage(lua_State* L) {
	// player:getPreyExperiencePercentage(raceId)
	if (const auto &player = Lua::getUserdataShared<Player>(L, 1)) {
		if (const std::unique_ptr<PreySlot> &slot = player->getPreyWithMonster(Lua::getNumber<uint16_t>(L, 2, 0));
		    slot && slot->isOccupied() && slot->bonus == PreyBonus_Experience && slot->bonusTimeLeft > 0) {
			lua_pushnumber(L, static_cast<lua_Number>(100 + slot->bonusPercentage));
		} else {
			lua_pushnumber(L, 100);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemoveTaskHuntingPoints(lua_State* L) {
	// player:removeTaskHuntingPoints(amount)
	if (const auto &player = Lua::getUserdataShared<Player>(L, 1)) {
		Lua::pushBoolean(L, player->useTaskHuntingPoints(Lua::getNumber<uint64_t>(L, 2, 0)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetTaskHuntingPoints(lua_State* L) {
	// player:getTaskHuntingPoints()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player == nullptr) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	lua_pushnumber(L, static_cast<double>(player->getTaskHuntingPoints()));
	return 1;
}

int PlayerFunctions::luaPlayerAddTaskHuntingPoints(lua_State* L) {
	// player:addTaskHuntingPoints(amount)
	if (const auto &player = Lua::getUserdataShared<Player>(L, 1)) {
		const auto points = Lua::getNumber<uint64_t>(L, 2);
		player->addTaskHuntingPoints(Lua::getNumber<uint64_t>(L, 2));
		lua_pushnumber(L, static_cast<lua_Number>(points));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetPreyLootPercentage(lua_State* L) {
	// player:getPreyLootPercentage(raceid)
	if (const auto &player = Lua::getUserdataShared<Player>(L, 1)) {
		if (const std::unique_ptr<PreySlot> &slot = player->getPreyWithMonster(Lua::getNumber<uint16_t>(L, 2, 0));
		    slot && slot->isOccupied() && slot->bonus == PreyBonus_Loot) {
			lua_pushnumber(L, slot->bonusPercentage);
		} else {
			lua_pushnumber(L, 0);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerisMonsterPrey(lua_State* L) {
	// player:isMonsterPrey(raceid)
	if (const auto &player = Lua::getUserdataShared<Player>(L, 1)) {
		if (const std::unique_ptr<PreySlot> &slot = player->getPreyWithMonster(Lua::getNumber<uint16_t>(L, 2, 0));
		    slot && slot->isOccupied()) {
			Lua::pushBoolean(L, true);
		} else {
			Lua::pushBoolean(L, false);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerPreyThirdSlot(lua_State* L) {
	// get: player:preyThirdSlot() set: player:preyThirdSlot(bool)
	if (const auto &player = Lua::getUserdataShared<Player>(L, 1);
	    const auto &slot = player->getPreySlotById(PreySlot_Three)) {
		if (!slot) {
			lua_pushnil(L);
		} else if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, slot->state != PreyDataState_Locked);
		} else {
			if (Lua::getBoolean(L, 2, false)) {
				slot->eraseBonus();
				slot->state = PreyDataState_Selection;
				slot->reloadMonsterGrid(player->getPreyBlackList(), player->getLevel());
				player->reloadPreySlot(PreySlot_Three);
			} else {
				slot->state = PreyDataState_Locked;
			}

			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int PlayerFunctions::luaPlayerTaskThirdSlot(lua_State* L) {
	// get: player:taskHuntingThirdSlot() set: player:taskHuntingThirdSlot(bool)
	if (const auto &player = Lua::getUserdataShared<Player>(L, 1);
	    const auto &slot = player->getTaskHuntingSlotById(PreySlot_Three)) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, slot->state != PreyTaskDataState_Locked);
		} else {
			if (Lua::getBoolean(L, 2, false)) {
				slot->eraseTask();
				slot->reloadReward();
				slot->state = PreyTaskDataState_Selection;
				slot->reloadMonsterGrid(player->getTaskHuntingBlackList(), player->getLevel());
				player->reloadTaskSlot(PreySlot_Three);
			} else {
				slot->state = PreyTaskDataState_Locked;
			}

			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayercharmExpansion(lua_State* L) {
	// get: player:charmExpansion() set: player:charmExpansion(bool)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, player->hasCharmExpansion());
		} else {
			player->setCharmExpansion(Lua::getBoolean(L, 2, false));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetCapacity(lua_State* L) {
	// player:getCapacity()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getCapacity());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetCapacity(lua_State* L) {
	// player:setCapacity(capacity)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->capacity = Lua::getNumber<uint32_t>(L, 2);
		player->sendStats();
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetTraining(lua_State* L) {
	// player:setTraining(value)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const bool value = Lua::getBoolean(L, 2, false);
		player->setTraining(value);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetIsTraining(lua_State* L) {
	// player:isTraining()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::pushBoolean(L, false);
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	lua_pushnumber(L, player->isExerciseTraining());
	return 1;
}

int PlayerFunctions::luaPlayerGetFreeCapacity(lua_State* L) {
	// player:getFreeCapacity()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getFreeCapacity());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetKills(lua_State* L) {
	// player:getKills()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, player->unjustifiedKills.size(), 0);
	int idx = 0;
	for (const auto &kill : player->unjustifiedKills) {
		lua_createtable(L, 3, 0);
		lua_pushnumber(L, kill.target);
		lua_rawseti(L, -2, 1);
		lua_pushnumber(L, kill.time);
		lua_rawseti(L, -2, 2);
		Lua::pushBoolean(L, kill.unavenged);
		lua_rawseti(L, -2, 3);
		lua_rawseti(L, -2, ++idx);
	}

	return 1;
}

int PlayerFunctions::luaPlayerSetKills(lua_State* L) {
	// player:setKills(kills)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	luaL_checktype(L, 2, LUA_TTABLE);
	std::vector<Kill> newKills;

	lua_pushnil(L);
	while (lua_next(L, 2) != 0) {
		// -2 is index, -1 is value
		luaL_checktype(L, -1, LUA_TTABLE);
		lua_rawgeti(L, -1, 1); // push target
		lua_rawgeti(L, -2, 2); // push time
		lua_rawgeti(L, -3, 3); // push unavenged
		newKills.emplace_back(luaL_checknumber(L, -3), luaL_checknumber(L, -2), Lua::getBoolean(L, -1));
		lua_pop(L, 4);
	}

	player->unjustifiedKills = std::move(newKills);
	player->sendUnjustifiedPoints();
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetReward(lua_State* L) {
	// player:getReward(rewardId[, autoCreate = false])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint64_t rewardId = Lua::getNumber<uint64_t>(L, 2);
	const bool autoCreate = Lua::getBoolean(L, 3, false);
	if (const auto &reward = player->getReward(rewardId, autoCreate)) {
		Lua::pushUserdata<Item>(L, reward);
		Lua::setItemMetatable(L, -1, reward);
	} else {
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemoveReward(lua_State* L) {
	// player:removeReward(rewardId)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t rewardId = Lua::getNumber<uint32_t>(L, 2);
	player->removeReward(rewardId);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetRewardList(lua_State* L) {
	// player:getRewardList()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	std::vector<uint64_t> rewardVec;
	player->getRewardList(rewardVec);
	lua_createtable(L, rewardVec.size(), 0);

	int index = 0;
	for (const auto &rewardId : rewardVec) {
		lua_pushnumber(L, static_cast<lua_Number>(rewardId));
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetDailyReward(lua_State* L) {
	// player:setDailyReward(value)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->setDailyReward(Lua::getNumber<uint8_t>(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetDepotLocker(lua_State* L) {
	// player:getDepotLocker(depotId)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t depotId = Lua::getNumber<uint32_t>(L, 2);
	const auto &depotLocker = player->getDepotLocker(depotId);
	if (depotLocker) {
		depotLocker->setParent(player);
		Lua::pushUserdata<Item>(L, depotLocker);
		Lua::setItemMetatable(L, -1, depotLocker);
	} else {
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetStashCounter(lua_State* L) {
	// player:getStashCount()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t sizeStash = getStashSize(player->getStashItems());
		lua_pushnumber(L, sizeStash);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetDepotChest(lua_State* L) {
	// player:getDepotChest(depotId[, autoCreate = false])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t depotId = Lua::getNumber<uint32_t>(L, 2);
	const bool autoCreate = Lua::getBoolean(L, 3, false);
	const auto &depotChest = player->getDepotChest(depotId, autoCreate);
	if (depotChest) {
		player->setLastDepotId(depotId);
		Lua::pushUserdata<Item>(L, depotChest);
		Lua::setItemMetatable(L, -1, depotChest);
	} else {
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetInbox(lua_State* L) {
	// player:getInbox()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &inbox = player->getInbox();
	if (inbox) {
		Lua::pushUserdata<Item>(L, inbox);
		Lua::setItemMetatable(L, -1, inbox);
	} else {
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetSkullTime(lua_State* L) {
	// player:getSkullTime()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getSkullTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetSkullTime(lua_State* L) {
	// player:setSkullTime(skullTime)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->setSkullTicks(Lua::getNumber<int64_t>(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetDeathPenalty(lua_State* L) {
	// player:getDeathPenalty()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, static_cast<uint32_t>(player->getLostPercent() * 100));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetExperience(lua_State* L) {
	// player:getExperience()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getExperience());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddExperience(lua_State* L) {
	// player:addExperience(experience[, sendText = false])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const int64_t experience = Lua::getNumber<int64_t>(L, 2);
		const bool sendText = Lua::getBoolean(L, 3, false);
		player->addExperience(nullptr, experience, sendText);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemoveExperience(lua_State* L) {
	// player:removeExperience(experience[, sendText = false])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const int64_t experience = Lua::getNumber<int64_t>(L, 2);
		const bool sendText = Lua::getBoolean(L, 3, false);
		player->removeExperience(experience, sendText);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetLevel(lua_State* L) {
	// player:getLevel()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getLevel());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetMagicShieldCapacityFlat(lua_State* L) {
	// player:getMagicShieldCapacityFlat(useCharges)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMagicShieldCapacityFlat(Lua::getBoolean(L, 2, false)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetMagicShieldCapacityPercent(lua_State* L) {
	// player:getMagicShieldCapacityPercent(useCharges)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMagicShieldCapacityPercent(Lua::getBoolean(L, 2, false)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSendSpellCooldown(lua_State* L) {
	// player:sendSpellCooldown(spellId, time)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	const uint8_t spellId = Lua::getNumber<uint32_t>(L, 2, 1);
	const auto time = Lua::getNumber<uint32_t>(L, 3, 0);

	player->sendSpellCooldown(spellId, time);
	Lua::pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerSendSpellGroupCooldown(lua_State* L) {
	// player:sendSpellGroupCooldown(groupId, time)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	const auto groupId = Lua::getNumber<SpellGroup_t>(L, 2, SPELLGROUP_ATTACK);
	const auto time = Lua::getNumber<uint32_t>(L, 3, 0);

	player->sendSpellGroupCooldown(groupId, time);
	Lua::pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerGetMagicLevel(lua_State* L) {
	// player:getMagicLevel()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMagicLevel());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetBaseMagicLevel(lua_State* L) {
	// player:getBaseMagicLevel()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getBaseMagicLevel());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetMana(lua_State* L) {
	// player:getMana()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMana());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddMana(lua_State* L) {
	// player:addMana(manaChange[, animationOnLoss = false])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const int32_t manaChange = Lua::getNumber<int32_t>(L, 2);
	const bool animationOnLoss = Lua::getBoolean(L, 3, false);
	if (!animationOnLoss && manaChange < 0) {
		player->changeMana(manaChange);
	} else {
		CombatDamage damage;
		damage.primary.value = manaChange;
		damage.origin = ORIGIN_NONE;
		g_game().combatChangeMana(nullptr, player, damage);
	}
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetMaxMana(lua_State* L) {
	// player:getMaxMana()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMaxMana());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetMaxMana(lua_State* L) {
	// player:setMaxMana(maxMana)
	const auto &player = Lua::getPlayer(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	player->manaMax = Lua::getNumber<int32_t>(L, 2);
	player->mana = std::min<int32_t>(player->mana, player->manaMax);
	g_game().addPlayerMana(player);
	player->sendStats();
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetManaSpent(lua_State* L) {
	// player:getManaSpent()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getSpentMana());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddManaSpent(lua_State* L) {
	// player:addManaSpent(amount)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->addManaSpent(Lua::getNumber<uint64_t>(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetBaseMaxHealth(lua_State* L) {
	// player:getBaseMaxHealth()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->healthMax);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetBaseMaxMana(lua_State* L) {
	// player:getBaseMaxMana()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->manaMax);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetSkillLevel(lua_State* L) {
	// player:getSkillLevel(skillType)
	const skills_t skillType = Lua::getNumber<skills_t>(L, 2);
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player && skillType <= SKILL_LAST) {
		lua_pushnumber(L, player->skills[skillType].level);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetEffectiveSkillLevel(lua_State* L) {
	// player:getEffectiveSkillLevel(skillType)
	const skills_t skillType = Lua::getNumber<skills_t>(L, 2);
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player && skillType <= SKILL_LAST) {
		lua_pushnumber(L, player->getSkillLevel(skillType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetSkillPercent(lua_State* L) {
	// player:getSkillPercent(skillType)
	const skills_t skillType = Lua::getNumber<skills_t>(L, 2);
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player && skillType <= SKILL_LAST) {
		lua_pushnumber(L, player->skills[skillType].percent);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetSkillTries(lua_State* L) {
	// player:getSkillTries(skillType)
	const skills_t skillType = Lua::getNumber<skills_t>(L, 2);
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player && skillType <= SKILL_LAST) {
		lua_pushnumber(L, player->skills[skillType].tries);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddSkillTries(lua_State* L) {
	// player:addSkillTries(skillType, tries)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const skills_t skillType = Lua::getNumber<skills_t>(L, 2);
		const uint64_t tries = Lua::getNumber<uint64_t>(L, 3);
		player->addSkillAdvance(skillType, tries);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetLevel(lua_State* L) {
	// player:setLevel(level)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t level = Lua::getNumber<uint16_t>(L, 2);
		player->level = level;
		player->experience = Player::getExpForLevel(level);
		player->sendStats();
		player->sendSkills();
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetMagicLevel(lua_State* L) {
	// player:setMagicLevel(level[, manaSpent])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t level = Lua::getNumber<uint16_t>(L, 2);
		player->magLevel = level;
		if (Lua::getNumber<uint64_t>(L, 3, 0) > 0) {
			const uint64_t manaSpent = Lua::getNumber<uint64_t>(L, 3);
			const uint64_t nextReqMana = player->vocation->getReqMana(level + 1);
			player->manaSpent = manaSpent;
			player->magLevelPercent = Player::getPercentLevel(manaSpent, nextReqMana);
		} else {
			player->manaSpent = 0;
			player->magLevelPercent = 0;
		}
		player->sendStats();
		player->sendSkills();
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetSkillLevel(lua_State* L) {
	// player:setSkillLevel(skillType, level[, tries])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const skills_t skillType = Lua::getNumber<skills_t>(L, 2);
		const uint16_t level = Lua::getNumber<uint16_t>(L, 3);
		player->skills[skillType].level = level;
		if (Lua::getNumber<uint64_t>(L, 4, 0) > 0) {
			const uint64_t tries = Lua::getNumber<uint64_t>(L, 4);
			const uint64_t nextReqTries = player->vocation->getReqSkillTries(skillType, level + 1);
			player->skills[skillType].tries = tries;
			player->skills[skillType].percent = Player::getPercentLevel(tries, nextReqTries);
		} else {
			player->skills[skillType].tries = 0;
			player->skills[skillType].percent = 0;
		}
		player->sendStats();
		player->sendSkills();
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddOfflineTrainingTime(lua_State* L) {
	// player:addOfflineTrainingTime(time)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const int32_t time = Lua::getNumber<int32_t>(L, 2);
		player->addOfflineTrainingTime(time);
		player->sendStats();
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetOfflineTrainingTime(lua_State* L) {
	// player:getOfflineTrainingTime()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getOfflineTrainingTime());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemoveOfflineTrainingTime(lua_State* L) {
	// player:removeOfflineTrainingTime(time)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const int32_t time = Lua::getNumber<int32_t>(L, 2);
		player->removeOfflineTrainingTime(time);
		player->sendStats();
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddOfflineTrainingTries(lua_State* L) {
	// player:addOfflineTrainingTries(skillType, tries)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const skills_t skillType = Lua::getNumber<skills_t>(L, 2);
		const uint64_t tries = Lua::getNumber<uint64_t>(L, 3);
		Lua::pushBoolean(L, player->addOfflineTrainingTries(skillType, tries));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetOfflineTrainingSkill(lua_State* L) {
	// player:getOfflineTrainingSkill()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getOfflineTrainingSkill());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetOfflineTrainingSkill(lua_State* L) {
	// player:setOfflineTrainingSkill(skillId)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const int8_t skillId = Lua::getNumber<int8_t>(L, 2);
		player->setOfflineTrainingSkill(skillId);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerOpenStash(lua_State* L) {
	// player:openStash(isNpc)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	const bool isNpc = Lua::getBoolean(L, 2, false);
	if (player) {
		player->sendOpenStash(isNpc);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int PlayerFunctions::luaPlayerGetItemCount(lua_State* L) {
	// player:getItemCount(itemId[, subType = -1])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (Lua::isNumber(L, 2)) {
		itemId = Lua::getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(Lua::getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	const auto subType = Lua::getNumber<int32_t>(L, 3, -1);
	lua_pushnumber(L, player->getItemTypeCount(itemId, subType));
	return 1;
}

int PlayerFunctions::luaPlayerGetStashItemCount(lua_State* L) {
	// player:getStashItemCount(itemId)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (Lua::isNumber(L, 2)) {
		itemId = Lua::getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(Lua::getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	const ItemType &itemType = Item::items[itemId];
	if (itemType.id == 0) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, player->getStashItemCount(itemType.id));
	return 1;
}

int PlayerFunctions::luaPlayerGetItemById(lua_State* L) {
	// player:getItemById(itemId, deepSearch[, subType = -1])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (Lua::isNumber(L, 2)) {
		itemId = Lua::getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(Lua::getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}
	const bool deepSearch = Lua::getBoolean(L, 3);
	const auto subType = Lua::getNumber<int32_t>(L, 4, -1);

	const auto &item = g_game().findItemOfType(player, itemId, deepSearch, subType);
	if (item) {
		Lua::pushUserdata<Item>(L, item);
		Lua::setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetVocation(lua_State* L) {
	// player:getVocation()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		Lua::pushUserdata<Vocation>(L, player->getVocation());
		Lua::setMetatable(L, -1, "Vocation");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetVocation(lua_State* L) {
	// player:setVocation(id or name or userdata)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Vocation> vocation;
	if (Lua::isNumber(L, 2)) {
		vocation = g_vocations().getVocation(Lua::getNumber<uint16_t>(L, 2));
	} else if (Lua::isString(L, 2)) {
		vocation = g_vocations().getVocation(g_vocations().getVocationId(Lua::getString(L, 2)));
	} else if (Lua::isUserdata(L, 2)) {
		vocation = Lua::getUserdataShared<Vocation>(L, 2);
	} else {
		vocation = nullptr;
	}

	if (!vocation) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	player->setVocation(vocation->getId());
	player->sendSkills();
	player->sendStats();
	player->sendBasicData();
	player->wheel()->sendGiftOfLifeCooldown();
	g_game().reloadCreature(player);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerIsPromoted(lua_State* L) {
	// player:isPromoted()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		Lua::pushBoolean(L, player->isPromoted());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetSex(lua_State* L) {
	// player:getSex()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getSex());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetSex(lua_State* L) {
	// player:setSex(newSex)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const PlayerSex_t newSex = Lua::getNumber<PlayerSex_t>(L, 2);
		player->setSex(newSex);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetPronoun(lua_State* L) {
	// player:getPronoun()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getPronoun());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetPronoun(lua_State* L) {
	// player:setPronoun(newPronoun)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const PlayerPronoun_t newPronoun = Lua::getNumber<PlayerPronoun_t>(L, 2);
		player->setPronoun(newPronoun);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetTown(lua_State* L) {
	// player:getTown()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		Lua::pushUserdata<Town>(L, player->getTown());
		Lua::setMetatable(L, -1, "Town");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetTown(lua_State* L) {
	// player:setTown(town)
	const auto &town = Lua::getUserdataShared<Town>(L, 2);
	if (!town) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->setTown(town);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetGuild(lua_State* L) {
	// player:getGuild()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &guild = player->getGuild();
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	Lua::pushUserdata<Guild>(L, guild);
	Lua::setMetatable(L, -1, "Guild");
	return 1;
}

int PlayerFunctions::luaPlayerSetGuild(lua_State* L) {
	// player:setGuild(guild)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &guild = Lua::getUserdataShared<Guild>(L, 2);
	player->setGuild(guild);

	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetGuildLevel(lua_State* L) {
	// player:getGuildLevel()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player && player->getGuild()) {
		lua_pushnumber(L, player->getGuildRank()->level);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetGuildLevel(lua_State* L) {
	// player:setGuildLevel(level)
	const uint8_t level = Lua::getNumber<uint8_t>(L, 2);
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player || !player->getGuild()) {
		lua_pushnil(L);
		return 1;
	}

	const auto &rank = player->getGuild()->getRankByLevel(level);
	if (!rank) {
		Lua::pushBoolean(L, false);
	} else {
		player->setGuildRank(rank);
		Lua::pushBoolean(L, true);
	}

	return 1;
}

int PlayerFunctions::luaPlayerGetGuildNick(lua_State* L) {
	// player:getGuildNick()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		Lua::pushString(L, player->getGuildNick());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetGuildNick(lua_State* L) {
	// player:setGuildNick(nick)
	const std::string &nick = Lua::getString(L, 2);
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->setGuildNick(nick);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetGroup(lua_State* L) {
	// player:getGroup()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		Lua::pushUserdata<Group>(L, player->getGroup());
		Lua::setMetatable(L, -1, "Group");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetGroup(lua_State* L) {
	// player:setGroup(group)
	const auto &group = Lua::getUserdataShared<Group>(L, 2);
	if (!group) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->setGroup(group);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetSpecialContainersAvailable(lua_State* L) {
	// player:setSpecialContainersAvailable(stashMenu, marketMenu, depotSearchMenu)
	const bool supplyStashMenu = Lua::getBoolean(L, 2, false);
	const bool marketMenu = Lua::getBoolean(L, 3, false);
	const bool depotSearchMenu = Lua::getBoolean(L, 4, false);
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->setSpecialMenuAvailable(supplyStashMenu, marketMenu, depotSearchMenu);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetStamina(lua_State* L) {
	// player:getStamina()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getStaminaMinutes());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetStamina(lua_State* L) {
	// player:setStamina(stamina)
	const uint16_t stamina = Lua::getNumber<uint16_t>(L, 2);
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->staminaMinutes = std::min<uint16_t>(2520, stamina);
		player->sendStats();
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetSoul(lua_State* L) {
	// player:getSoul()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getSoul());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddSoul(lua_State* L) {
	// player:addSoul(soulChange)
	const int32_t soulChange = Lua::getNumber<int32_t>(L, 2);
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->changeSoul(soulChange);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetMaxSoul(lua_State* L) {
	// player:getMaxSoul()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player && player->vocation) {
		lua_pushnumber(L, player->vocation->getSoulMax());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetBankBalance(lua_State* L) {
	// player:getBankBalance()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getBankBalance());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetBankBalance(lua_State* L) {
	// player:setBankBalance(bankBalance)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->setBankBalance(Lua::getNumber<uint64_t>(L, 2));
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetStorageValue(lua_State* L) {
	// player:getStorageValue(key)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t key = Lua::getNumber<uint32_t>(L, 2);
	lua_pushnumber(L, player->getStorageValue(key));
	return 1;
}

int PlayerFunctions::luaPlayerSetStorageValue(lua_State* L) {
	// player:setStorageValue(key, value)
	const int32_t value = Lua::getNumber<int32_t>(L, 3);
	const uint32_t key = Lua::getNumber<uint32_t>(L, 2);
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (IS_IN_KEYRANGE(key, RESERVED_RANGE)) {
		std::ostringstream ss;
		ss << "Accessing reserved range: " << key;
		Lua::reportErrorFunc(ss.str());
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (key == 0) {
		Lua::reportErrorFunc("Storage key is nil");
		return 1;
	}

	if (player) {
		player->addStorageValue(key, value);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetStorageValueByName(lua_State* L) {
	// player:getStorageValueByName(name)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	g_logger().warn("The function 'player:getStorageValueByName' is deprecated and will be removed in future versions, please use KV system");
	const auto name = Lua::getString(L, 2);
	lua_pushnumber(L, player->getStorageValueByName(name));
	return 1;
}

int PlayerFunctions::luaPlayerSetStorageValueByName(lua_State* L) {
	// player:setStorageValueByName(storageName, value)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	g_logger().warn("The function 'player:setStorageValueByName' is deprecated and will be removed in future versions, please use KV system");
	const auto storageName = Lua::getString(L, 2);
	const int32_t value = Lua::getNumber<int32_t>(L, 3);

	player->addStorageValueByName(storageName, value);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerAddItem(lua_State* L) {
	// player:addItem(itemId, count = 1, canDropOnMap = true, subType = 1, slot = CONST_SLOT_WHEREEVER, tier = 0)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	uint16_t itemId;
	if (Lua::isNumber(L, 2)) {
		itemId = Lua::getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(Lua::getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	const auto count = Lua::getNumber<int32_t>(L, 3, 1);
	auto subType = Lua::getNumber<int32_t>(L, 5, 1);

	const ItemType &it = Item::items[itemId];

	int32_t itemCount = 1;
	const int parameters = lua_gettop(L);
	if (parameters >= 4) {
		itemCount = std::max<int32_t>(1, count);
	} else if (it.hasSubType()) {
		if (it.stackable) {
			itemCount = std::ceil(count / static_cast<float_t>(it.stackSize));
		}

		subType = count;
	} else {
		itemCount = std::max<int32_t>(1, count);
	}

	const bool hasTable = itemCount > 1;
	if (hasTable) {
		lua_newtable(L);
	} else if (itemCount == 0) {
		lua_pushnil(L);
		return 1;
	}

	const bool canDropOnMap = Lua::getBoolean(L, 4, true);
	const auto slot = Lua::getNumber<Slots_t>(L, 6, CONST_SLOT_WHEREEVER);
	const auto tier = Lua::getNumber<uint8_t>(L, 7, 0);
	for (int32_t i = 1; i <= itemCount; ++i) {
		int32_t stackCount = subType;
		if (it.stackable) {
			stackCount = std::min<int32_t>(stackCount, it.stackSize);
			subType -= stackCount;
		}

		const auto &item = Item::CreateItem(itemId, stackCount);
		if (!item) {
			if (!hasTable) {
				lua_pushnil(L);
			}
			return 1;
		}

		if (tier > 0) {
			item->setTier(tier);
		}

		ReturnValue ret = g_game().internalPlayerAddItem(player, item, canDropOnMap, slot);
		if (ret != RETURNVALUE_NOERROR) {
			if (!hasTable) {
				lua_pushnil(L);
			}

			player->sendCancelMessage(ret);
			return 1;
		}

		if (hasTable) {
			lua_pushnumber(L, i);
			Lua::pushUserdata<Item>(L, item);
			Lua::setItemMetatable(L, -1, item);
			lua_settable(L, -3);
		} else {
			Lua::pushUserdata<Item>(L, item);
			Lua::setItemMetatable(L, -1, item);
		}
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddItemEx(lua_State* L) {
	// player:addItemEx(item[, canDropOnMap = false[, index = INDEX_WHEREEVER[, flags = 0]]])
	// player:addItemEx(item[, canDropOnMap = true[, slot = CONST_SLOT_WHEREEVER]])
	const auto &item = Lua::getUserdataShared<Item>(L, 2);
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	if (item->getParent() != VirtualCylinder::virtualCylinder) {
		Lua::reportErrorFunc("Item already has a parent");
		Lua::pushBoolean(L, false);
		return 1;
	}

	const bool canDropOnMap = Lua::getBoolean(L, 3, false);
	ReturnValue returnValue;
	if (canDropOnMap) {
		const auto slot = Lua::getNumber<Slots_t>(L, 4, CONST_SLOT_WHEREEVER);
		returnValue = g_game().internalPlayerAddItem(player, item, true, slot);
	} else {
		const auto index = Lua::getNumber<int32_t>(L, 4, INDEX_WHEREEVER);
		const auto flags = Lua::getNumber<uint32_t>(L, 5, 0);
		returnValue = g_game().internalAddItem(player, item, index, flags);
	}

	if (returnValue == RETURNVALUE_NOERROR) {
		ScriptEnvironment::removeTempItem(item);
	}
	lua_pushnumber(L, returnValue);
	return 1;
}

int PlayerFunctions::luaPlayerAddItemStash(lua_State* L) {
	// player:addItemStash(itemId, count = 1)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto itemId = Lua::getNumber<uint16_t>(L, 2);
	const auto count = Lua::getNumber<uint32_t>(L, 3, 1);

	player->addItemOnStash(itemId, count);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerRemoveStashItem(lua_State* L) {
	// player:removeStashItem(itemId, count)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (Lua::isNumber(L, 2)) {
		itemId = Lua::getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(Lua::getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	const ItemType &itemType = Item::items[itemId];
	if (itemType.id == 0) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t count = Lua::getNumber<uint32_t>(L, 3);
	Lua::pushBoolean(L, player->withdrawItem(itemType.id, count));
	return 1;
}

int PlayerFunctions::luaPlayerRemoveItem(lua_State* L) {
	// player:removeItem(itemId, count[, subType = -1[, ignoreEquipped = false]])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (Lua::isNumber(L, 2)) {
		itemId = Lua::getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(Lua::getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	const uint32_t count = Lua::getNumber<uint32_t>(L, 3);
	const auto subType = Lua::getNumber<int32_t>(L, 4, -1);
	const bool ignoreEquipped = Lua::getBoolean(L, 5, false);
	Lua::pushBoolean(L, player->removeItemOfType(itemId, count, subType, ignoreEquipped));
	return 1;
}

int PlayerFunctions::luaPlayerSendContainer(lua_State* L) {
	// player:sendContainer(container)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &container = Lua::getUserdataShared<Container>(L, 2);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	player->sendContainer(static_cast<uint8_t>(container->getID()), container, container->hasParent(), static_cast<uint8_t>(container->getFirstIndex()));
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSendUpdateContainer(lua_State* L) {
	// player:sendUpdateContainer(container)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &container = Lua::getUserdataShared<Container>(L, 2);
	if (!container) {
		Lua::reportErrorFunc("Container is nullptr");
		return 1;
	}

	player->onSendContainer(container);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetMoney(lua_State* L) {
	// player:getMoney()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMoney());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddMoney(lua_State* L) {
	// player:addMoney(money)
	const uint64_t money = Lua::getNumber<uint64_t>(L, 2);
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		g_game().addMoney(player, money);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemoveMoney(lua_State* L) {
	// player:removeMoney(money[, flags = 0[, useBank = true]])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const uint64_t money = Lua::getNumber<uint64_t>(L, 2);
		const auto flags = Lua::getNumber<int32_t>(L, 3, 0);
		const bool useBank = Lua::getBoolean(L, 4, true);
		Lua::pushBoolean(L, g_game().removeMoney(player, money, flags, useBank));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerShowTextDialog(lua_State* L) {
	// player:showTextDialog(id or name or userdata[, text[, canWrite[, length]]])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	auto length = Lua::getNumber<int32_t>(L, 5, -1);
	const bool canWrite = Lua::getBoolean(L, 4, false);
	std::string text;

	const int parameters = lua_gettop(L);
	if (parameters >= 3) {
		text = Lua::getString(L, 3);
	}

	std::shared_ptr<Item> item;
	if (Lua::isNumber(L, 2)) {
		item = Item::CreateItem(Lua::getNumber<uint16_t>(L, 2));
	} else if (Lua::isString(L, 2)) {
		item = Item::CreateItem(Item::items.getItemIdByName(Lua::getString(L, 2)));
	} else if (Lua::isUserdata(L, 2)) {
		if (Lua::getUserdataType(L, 2) != LuaData_t::Item) {
			Lua::pushBoolean(L, false);
			return 1;
		}

		item = Lua::getUserdataShared<Item>(L, 2);
	} else {
		item = nullptr;
	}

	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (length < 0) {
		length = Item::items[item->getID()].maxTextLen;
	}

	if (!text.empty()) {
		item->setAttribute(ItemAttribute_t::TEXT, text);
		length = std::max<int32_t>(text.size(), length);
	}

	item->setParent(player);
	player->setWriteItem(item, length);
	player->sendTextWindow(item, length, canWrite);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSendTextMessage(lua_State* L) {
	// player:sendTextMessage(type, text[, position, primaryValue = 0, primaryColor = TEXTCOLOR_NONE[, secondaryValue = 0, secondaryColor = TEXTCOLOR_NONE]])
	// player:sendTextMessage(type, text, channelId)

	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const int parameters = lua_gettop(L);

	TextMessage message(Lua::getNumber<MessageClasses>(L, 2), Lua::getString(L, 3));
	if (parameters == 4) {
		const uint16_t channelId = Lua::getNumber<uint16_t>(L, 4);
		const auto &channel = g_chat().getChannel(player, channelId);
		if (!channel || !channel->hasUser(player)) {
			Lua::pushBoolean(L, false);
			return 1;
		}
		message.channelId = channelId;
	} else {
		if (parameters >= 6) {
			message.position = Lua::getPosition(L, 4);
			message.primary.value = Lua::getNumber<int32_t>(L, 5);
			message.primary.color = Lua::getNumber<TextColor_t>(L, 6);
		}

		if (parameters >= 8) {
			message.secondary.value = Lua::getNumber<int32_t>(L, 7);
			message.secondary.color = Lua::getNumber<TextColor_t>(L, 8);
		}
	}

	player->sendTextMessage(message);
	Lua::pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerSendChannelMessage(lua_State* L) {
	// player:sendChannelMessage(author, text, type, channelId)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint16_t channelId = Lua::getNumber<uint16_t>(L, 5);
	const SpeakClasses type = Lua::getNumber<SpeakClasses>(L, 4);
	const std::string &text = Lua::getString(L, 3);
	const std::string &author = Lua::getString(L, 2);
	player->sendChannelMessage(author, text, type, channelId);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSendPrivateMessage(lua_State* L) {
	// player:sendPrivateMessage(speaker, text[, type])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &speaker = Lua::getUserdataShared<Player>(L, 2);
	const std::string &text = Lua::getString(L, 3);
	const auto type = Lua::getNumber<SpeakClasses>(L, 4, TALKTYPE_PRIVATE_FROM);
	player->sendPrivateMessage(speaker, type, text);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerChannelSay(lua_State* L) {
	// player:channelSay(speaker, type, text, channelId)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &speaker = Lua::getCreature(L, 2);
	const SpeakClasses type = Lua::getNumber<SpeakClasses>(L, 3);
	const std::string &text = Lua::getString(L, 4);
	const uint16_t channelId = Lua::getNumber<uint16_t>(L, 5);
	player->sendToChannel(speaker, type, text, channelId);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerOpenChannel(lua_State* L) {
	// player:openChannel(channelId)
	const uint16_t channelId = Lua::getNumber<uint16_t>(L, 2);
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		g_game().playerOpenChannel(player->getID(), channelId);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetSlotItem(lua_State* L) {
	// player:getSlotItem(slot)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t slot = Lua::getNumber<uint32_t>(L, 2);
	const auto &thing = player->getThing(slot);
	if (!thing) {
		lua_pushnil(L);
		return 1;
	}

	const auto &item = thing->getItem();
	if (item) {
		Lua::pushUserdata<Item>(L, item);
		Lua::setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetParty(lua_State* L) {
	// player:getParty()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &party = player->getParty();
	if (party) {
		Lua::pushUserdata<Party>(L, party);
		Lua::setMetatable(L, -1, "Party");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddOutfit(lua_State* L) {
	// player:addOutfit(lookType or name, addon = 0)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		auto addon = Lua::getNumber<uint8_t>(L, 3, 0);
		if (lua_isnumber(L, 2)) {
			player->addOutfit(Lua::getNumber<uint16_t>(L, 2), addon);
		} else if (lua_isstring(L, 2)) {
			const std::string &outfitName = Lua::getString(L, 2);
			const auto &outfit = Outfits::getInstance().getOutfitByName(player->getSex(), outfitName);
			if (!outfit) {
				Lua::reportErrorFunc("Outfit not found");
				return 1;
			}

			player->addOutfit(outfit->lookType, addon);
		}

		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddOutfitAddon(lua_State* L) {
	// player:addOutfitAddon(lookType, addon)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t lookType = Lua::getNumber<uint16_t>(L, 2);
		const uint8_t addon = Lua::getNumber<uint8_t>(L, 3);
		player->addOutfit(lookType, addon);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemoveOutfit(lua_State* L) {
	// player:removeOutfit(lookType)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t lookType = Lua::getNumber<uint16_t>(L, 2);
		Lua::pushBoolean(L, player->removeOutfit(lookType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemoveOutfitAddon(lua_State* L) {
	// player:removeOutfitAddon(lookType, addon)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t lookType = Lua::getNumber<uint16_t>(L, 2);
		const uint8_t addon = Lua::getNumber<uint8_t>(L, 3);
		Lua::pushBoolean(L, player->removeOutfitAddon(lookType, addon));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerHasOutfit(lua_State* L) {
	// player:hasOutfit(lookType[, addon = 0])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t lookType = Lua::getNumber<uint16_t>(L, 2);
		const auto addon = Lua::getNumber<uint8_t>(L, 3, 0);
		Lua::pushBoolean(L, player->canWear(lookType, addon));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSendOutfitWindow(lua_State* L) {
	// player:sendOutfitWindow()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->sendOutfitWindow();
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddMount(lua_State* L) {
	// player:addMount(mountId or mountName)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t mountId;
	if (Lua::isNumber(L, 2)) {
		mountId = Lua::getNumber<uint8_t>(L, 2);
	} else {
		const auto &mount = g_game().mounts->getMountByName(Lua::getString(L, 2));
		if (!mount) {
			lua_pushnil(L);
			return 1;
		}
		mountId = mount->id;
	}
	Lua::pushBoolean(L, player->tameMount(mountId));
	return 1;
}

int PlayerFunctions::luaPlayerRemoveMount(lua_State* L) {
	// player:removeMount(mountId or mountName)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t mountId;
	if (Lua::isNumber(L, 2)) {
		mountId = Lua::getNumber<uint8_t>(L, 2);
	} else {
		const auto &mount = g_game().mounts->getMountByName(Lua::getString(L, 2));
		if (!mount) {
			lua_pushnil(L);
			return 1;
		}
		mountId = mount->id;
	}
	Lua::pushBoolean(L, player->untameMount(mountId));
	return 1;
}

int PlayerFunctions::luaPlayerHasMount(lua_State* L) {
	// player:hasMount(mountId or mountName)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Mount> mount = nullptr;
	if (Lua::isNumber(L, 2)) {
		mount = g_game().mounts->getMountByID(Lua::getNumber<uint8_t>(L, 2));
	} else {
		mount = g_game().mounts->getMountByName(Lua::getString(L, 2));
	}

	if (mount) {
		Lua::pushBoolean(L, player->hasMount(mount));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddFamiliar(lua_State* L) {
	// player:addFamiliar(lookType)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->addFamiliar(Lua::getNumber<uint16_t>(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemoveFamiliar(lua_State* L) {
	// player:removeFamiliar(lookType)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t lookType = Lua::getNumber<uint16_t>(L, 2);
		Lua::pushBoolean(L, player->removeFamiliar(lookType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerHasFamiliar(lua_State* L) {
	// player:hasFamiliar(lookType)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t lookType = Lua::getNumber<uint16_t>(L, 2);
		Lua::pushBoolean(L, player->canFamiliar(lookType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetFamiliarLooktype(lua_State* L) {
	// player:setFamiliarLooktype(lookType)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->setFamiliarLooktype(Lua::getNumber<uint16_t>(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetFamiliarLooktype(lua_State* L) {
	// player:getFamiliarLooktype()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->defaultOutfit.lookFamiliarsType);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetPremiumDays(lua_State* L) {
	// player:getPremiumDays()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player && player->getAccount()) {
		lua_pushnumber(L, player->getAccount()->getPremiumRemainingDays());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddPremiumDays(lua_State* L) {
	// player:addPremiumDays(days)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		lua_pushnil(L);
		return 1;
	}

	const auto premiumDays = player->getAccount()->getPremiumRemainingDays();

	if (premiumDays == std::numeric_limits<uint16_t>::max()) {
		return 1;
	}

	const int32_t addDays = std::min<int32_t>(0xFFFE - premiumDays, Lua::getNumber<uint16_t>(L, 2));
	if (addDays <= 0) {
		return 1;
	}

	player->getAccount()->addPremiumDays(addDays);

	if (player->getAccount()->save() != AccountErrors_t::Ok) {
		return 1;
	}

	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerRemovePremiumDays(lua_State* L) {
	// player:removePremiumDays(days)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		lua_pushnil(L);
		return 1;
	}

	const auto premiumDays = player->getAccount()->getPremiumRemainingDays();

	if (premiumDays == std::numeric_limits<uint16_t>::max()) {
		return 1;
	}

	const int32_t removeDays = std::min<int32_t>(0xFFFE - premiumDays, Lua::getNumber<uint16_t>(L, 2));
	if (removeDays <= 0) {
		return 1;
	}

	player->getAccount()->addPremiumDays(-removeDays);

	if (player->getAccount()->save() != AccountErrors_t::Ok) {
		return 1;
	}

	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetTibiaCoins(lua_State* L) {
	// player:getTibiaCoins()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	auto [coins, result] = player->getAccount()->getCoins(CoinType::Normal);

	if (result == AccountErrors_t::Ok) {
		lua_pushnumber(L, coins);
	}

	return 1;
}

int PlayerFunctions::luaPlayerAddTibiaCoins(lua_State* L) {
	// player:addTibiaCoins(coins)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (player->account->addCoins(CoinType::Normal, Lua::getNumber<uint32_t>(L, 2)) != AccountErrors_t::Ok) {
		Lua::reportErrorFunc("Failed to add coins");
		lua_pushnil(L);
		return 1;
	}

	if (player->getAccount()->save() != AccountErrors_t::Ok) {
		Lua::reportErrorFunc("Failed to save account");
		lua_pushnil(L);
		return 1;
	}

	Lua::pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerRemoveTibiaCoins(lua_State* L) {
	// player:removeTibiaCoins(coins)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (player->account->removeCoins(CoinType::Normal, Lua::getNumber<uint32_t>(L, 2)) != AccountErrors_t::Ok) {
		Lua::reportErrorFunc("Failed to remove coins");
		return 1;
	}

	if (player->getAccount()->save() != AccountErrors_t::Ok) {
		Lua::reportErrorFunc("Failed to save account");
		lua_pushnil(L);
		return 1;
	}

	Lua::pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerGetTransferableCoins(lua_State* L) {
	// player:getTransferableCoins()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	auto [coins, result] = player->getAccount()->getCoins(CoinType::Transferable);

	if (result == AccountErrors_t::Ok) {
		lua_pushnumber(L, coins);
	}

	return 1;
}

int PlayerFunctions::luaPlayerAddTransferableCoins(lua_State* L) {
	// player:addTransferableCoins(coins)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (player->account->addCoins(CoinType::Transferable, Lua::getNumber<uint32_t>(L, 2)) != AccountErrors_t::Ok) {
		Lua::reportErrorFunc("failed to add transferable coins");
		lua_pushnil(L);
		return 1;
	}

	if (player->getAccount()->save() != AccountErrors_t::Ok) {
		Lua::reportErrorFunc("failed to save account");
		lua_pushnil(L);
		return 1;
	}

	Lua::pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerRemoveTransferableCoins(lua_State* L) {
	// player:removeTransferableCoins(coins)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (player->account->removeCoins(CoinType::Transferable, Lua::getNumber<uint32_t>(L, 2)) != AccountErrors_t::Ok) {
		Lua::reportErrorFunc("failed to remove transferable coins");
		lua_pushnil(L);
		return 1;
	}

	if (player->getAccount()->save() != AccountErrors_t::Ok) {
		Lua::reportErrorFunc("failed to save account");
		lua_pushnil(L);
		return 1;
	}

	Lua::pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerSendBlessStatus(lua_State* L) {
	// player:sendBlessStatus()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	player->sendBlessStatus();
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerHasBlessing(lua_State* L) {
	// player:hasBlessing(blessing)
	const uint8_t blessing = Lua::getNumber<uint8_t>(L, 2);
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		Lua::pushBoolean(L, player->hasBlessing(blessing));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddBlessing(lua_State* L) {
	// player:addBlessing(blessing)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint8_t blessing = Lua::getNumber<uint8_t>(L, 2);
	const uint8_t count = Lua::getNumber<uint8_t>(L, 3);

	player->addBlessing(blessing, count);
	player->sendBlessStatus();
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerRemoveBlessing(lua_State* L) {
	// player:removeBlessing(blessing)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint8_t blessing = Lua::getNumber<uint8_t>(L, 2);
	const uint8_t count = Lua::getNumber<uint8_t>(L, 3);

	if (!player->hasBlessing(blessing)) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	player->removeBlessing(blessing, count);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetBlessingCount(lua_State* L) {
	// player:getBlessingCount(index[, storeCount = false])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	uint8_t index = Lua::getNumber<uint8_t>(L, 2);
	if (index == 0) {
		index = 1;
	}

	if (player) {
		lua_pushnumber(L, player->getBlessingCount(index, Lua::getBoolean(L, 3, false)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerCanLearnSpell(lua_State* L) {
	// player:canLearnSpell(spellName)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const std::string &spellName = Lua::getString(L, 2);
	const auto &spell = g_spells().getInstantSpellByName(spellName);
	if (!spell) {
		Lua::reportErrorFunc("Spell \"" + spellName + "\" not found");
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (player->hasFlag(PlayerFlags_t::IgnoreSpellCheck)) {
		Lua::pushBoolean(L, true);
		return 1;
	}

	const auto vocMap = spell->getVocMap();
	if (!vocMap.contains(player->getVocationId())) {
		Lua::pushBoolean(L, false);
	} else if (player->getLevel() < spell->getLevel()) {
		Lua::pushBoolean(L, false);
	} else if (player->getMagicLevel() < spell->getMagicLevel()) {
		Lua::pushBoolean(L, false);
	} else {
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int PlayerFunctions::luaPlayerLearnSpell(lua_State* L) {
	// player:learnSpell(spellName)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const std::string &spellName = Lua::getString(L, 2);
		player->learnInstantSpell(spellName);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerForgetSpell(lua_State* L) {
	// player:forgetSpell(spellName)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const std::string &spellName = Lua::getString(L, 2);
		player->forgetInstantSpell(spellName);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerHasLearnedSpell(lua_State* L) {
	// player:hasLearnedSpell(spellName)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const std::string &spellName = Lua::getString(L, 2);
		Lua::pushBoolean(L, player->hasLearnedInstantSpell(spellName));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSendTutorial(lua_State* L) {
	// player:sendTutorial(tutorialId)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const uint8_t tutorialId = Lua::getNumber<uint8_t>(L, 2);
		player->sendTutorial(tutorialId);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerOpenImbuementWindow(lua_State* L) {
	// player:openImbuementWindow(item)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &item = Lua::getUserdataShared<Item>(L, 2);
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	player->openImbuementWindow(item);
	return 1;
}

int PlayerFunctions::luaPlayerCloseImbuementWindow(lua_State* L) {
	// player:closeImbuementWindow()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	player->closeImbuementWindow();
	return 1;
}

int PlayerFunctions::luaPlayerAddMapMark(lua_State* L) {
	// player:addMapMark(position, type, description)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const Position &position = Lua::getPosition(L, 2);
		const uint8_t type = Lua::getNumber<uint8_t>(L, 3);
		const std::string &description = Lua::getString(L, 4);
		player->sendAddMarker(position, type, description);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSave(lua_State* L) {
	// player:save()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		if (!player->isOffline()) {
			player->loginPosition = player->getPosition();
		}
		Lua::pushBoolean(L, g_saveManager().savePlayer(player));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerPopupFYI(lua_State* L) {
	// player:popupFYI(message)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const std::string &message = Lua::getString(L, 2);
		player->sendFYIBox(message);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerIsPzLocked(lua_State* L) {
	// player:isPzLocked()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		Lua::pushBoolean(L, player->isPzLocked());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetClient(lua_State* L) {
	// player:getClient()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_createtable(L, 0, 2);
		Lua::setField(L, "version", player->getProtocolVersion());
		Lua::setField(L, "os", player->getOperatingSystem());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetHouse(lua_State* L) {
	// player:getHouse()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &house = g_game().map.houses.getHouseByPlayerId(player->getGUID());
	if (house) {
		Lua::pushUserdata<House>(L, house);
		Lua::setMetatable(L, -1, "House");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSendHouseWindow(lua_State* L) {
	// player:sendHouseWindow(house, listId)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &house = Lua::getUserdataShared<House>(L, 2);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t listId = Lua::getNumber<uint32_t>(L, 3);
	player->sendHouseWindow(house, listId);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSetEditHouse(lua_State* L) {
	// player:setEditHouse(house, listId)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &house = Lua::getUserdataShared<House>(L, 2);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t listId = Lua::getNumber<uint32_t>(L, 3);
	player->setEditHouse(house, listId);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSetGhostMode(lua_State* L) {
	// player:setGhostMode(enabled)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const bool enabled = Lua::getBoolean(L, 2);
	if (player->isInGhostMode() == enabled) {
		Lua::pushBoolean(L, true);
		return 1;
	}

	player->switchGhostMode();

	const auto &tile = player->getTile();
	const Position &position = player->getPosition();

	for (const auto &spectator : Spectators().find<Player>(position, true)) {
		const auto &tmpPlayer = spectator->getPlayer();
		if (tmpPlayer != player && !tmpPlayer->isAccessPlayer()) {
			if (enabled) {
				tmpPlayer->sendRemoveTileThing(position, tile->getStackposOfCreature(tmpPlayer, player));
			} else {
				tmpPlayer->sendCreatureAppear(player, position, true);
			}
		} else {
			tmpPlayer->sendCreatureChangeVisible(player, !enabled);
		}
	}

	if (player->isInGhostMode()) {
		for (const auto &it : g_game().getPlayers()) {
			if (!it.second->isAccessPlayer()) {
				it.second->vip()->notifyStatusChange(player, VipStatus_t::Offline);
			}
		}
	} else {
		for (const auto &it : g_game().getPlayers()) {
			if (!it.second->isAccessPlayer()) {
				it.second->vip()->notifyStatusChange(player, player->vip()->getStatus());
			}
		}
	}
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetContainerId(lua_State* L) {
	// player:getContainerId(container)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &container = Lua::getUserdataShared<Container>(L, 2);
	if (container) {
		lua_pushnumber(L, player->getContainerID(container));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetContainerById(lua_State* L) {
	// player:getContainerById(id)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &container = player->getContainerByID(Lua::getNumber<uint8_t>(L, 2));
	if (container) {
		Lua::pushUserdata<Container>(L, container);
		Lua::setMetatable(L, -1, "Container");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetContainerIndex(lua_State* L) {
	// player:getContainerIndex(id)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getContainerIndex(Lua::getNumber<uint8_t>(L, 2)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetInstantSpells(lua_State* L) {
	// player:getInstantSpells()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	std::vector<std::shared_ptr<InstantSpell>> spells;
	for (const auto &[key, spell] : g_spells().getInstantSpells()) {
		if (spell->canCast(player)) {
			spells.push_back(spell);
		}
	}

	lua_createtable(L, spells.size(), 0);

	int index = 0;
	for (const auto &spell : spells) {
		Lua::pushInstantSpell(L, *spell);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int PlayerFunctions::luaPlayerCanCast(lua_State* L) {
	// player:canCast(spell)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	const auto &spell = Lua::getUserdataShared<InstantSpell>(L, 2);
	if (player && spell) {
		Lua::pushBoolean(L, spell->canCast(player));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerHasChaseMode(lua_State* L) {
	// player:hasChaseMode()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		Lua::pushBoolean(L, player->chaseMode);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerHasSecureMode(lua_State* L) {
	// player:hasSecureMode()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		Lua::pushBoolean(L, player->secureMode);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetFightMode(lua_State* L) {
	// player:getFightMode()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->fightMode);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetBaseXpGain(lua_State* L) {
	// player:getBaseXpGain()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getBaseXpGain());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetBaseXpGain(lua_State* L) {
	// player:setBaseXpGain(value)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->setBaseXpGain(Lua::getNumber<uint16_t>(L, 2));
		player->sendStats();
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetVoucherXpBoost(lua_State* L) {
	// player:getVoucherXpBoost()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getVoucherXpBoost());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetVoucherXpBoost(lua_State* L) {
	// player:setVoucherXpBoost(value)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->setVoucherXpBoost(Lua::getNumber<uint16_t>(L, 2));
		player->sendStats();
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetGrindingXpBoost(lua_State* L) {
	// player:getGrindingXpBoost()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getGrindingXpBoost());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetGrindingXpBoost(lua_State* L) {
	// player:setGrindingXpBoost(value)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->setGrindingXpBoost(Lua::getNumber<uint16_t>(L, 2));
		player->sendStats();
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetXpBoostPercent(lua_State* L) {
	// player:getXpBoostPercent()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getXpBoostPercent());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetXpBoostPercent(lua_State* L) {
	// player:setXpBoostPercent(value)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t percent = Lua::getNumber<uint16_t>(L, 2);
		player->setXpBoostPercent(percent);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetStaminaXpBoost(lua_State* L) {
	// player:getStaminaXpBoost()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getStaminaXpBoost());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetStaminaXpBoost(lua_State* L) {
	// player:setStaminaXpBoost(value)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		player->setStaminaXpBoost(Lua::getNumber<uint16_t>(L, 2));
		player->sendStats();
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetXpBoostTime(lua_State* L) {
	// player:setXpBoostTime(timeLeft)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t timeLeft = Lua::getNumber<uint16_t>(L, 2);
		player->setXpBoostTime(timeLeft);
		player->sendStats();
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetXpBoostTime(lua_State* L) {
	// player:getXpBoostTime()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getXpBoostTime());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetIdleTime(lua_State* L) {
	// player:getIdleTime()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getIdleTime());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetFreeBackpackSlots(lua_State* L) {
	// player:getFreeBackpackSlots()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
	}

	lua_pushnumber(L, std::max<uint16_t>(0, player->getFreeBackpackSlots()));
	return 1;
}

int PlayerFunctions::luaPlayerIsOffline(lua_State* L) {
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player) {
		Lua::pushBoolean(L, player->isOffline());
	} else {
		Lua::pushBoolean(L, true);
	}

	return 1;
}

int PlayerFunctions::luaPlayerOpenMarket(lua_State* L) {
	// player:openMarket()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->sendMarketEnter(player->getLastDepotId());
	Lua::pushBoolean(L, true);
	return 1;
}

// Forge
int PlayerFunctions::luaPlayerOpenForge(lua_State* L) {
	// player:openForge()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	player->sendOpenForge();
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerCloseForge(lua_State* L) {
	// player:closeForge()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	player->closeForgeWindow();
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerAddForgeDusts(lua_State* L) {
	// player:addForgeDusts(amount)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	player->addForgeDusts(Lua::getNumber<uint64_t>(L, 2, 0));
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerRemoveForgeDusts(lua_State* L) {
	// player:removeForgeDusts(amount)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	player->removeForgeDusts(Lua::getNumber<uint64_t>(L, 2, 0));
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetForgeDusts(lua_State* L) {
	// player:getForgeDusts()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, static_cast<lua_Number>(player->getForgeDusts()));
	return 1;
}

int PlayerFunctions::luaPlayerSetForgeDusts(lua_State* L) {
	// player:setForgeDusts()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	player->setForgeDusts(Lua::getNumber<uint64_t>(L, 2, 0));
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerAddForgeDustLevel(lua_State* L) {
	// player:addForgeDustLevel(amount)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	player->addForgeDustLevel(Lua::getNumber<uint64_t>(L, 2, 1));
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerRemoveForgeDustLevel(lua_State* L) {
	// player:removeForgeDustLevel(amount)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	player->removeForgeDustLevel(Lua::getNumber<uint64_t>(L, 2, 1));
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetForgeDustLevel(lua_State* L) {
	// player:getForgeDustLevel()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, static_cast<lua_Number>(player->getForgeDustLevel()));
	return 1;
}

int PlayerFunctions::luaPlayerGetForgeSlivers(lua_State* L) {
	// player:getForgeSlivers()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	auto [sliver, core] = player->getForgeSliversAndCores();
	lua_pushnumber(L, static_cast<lua_Number>(sliver));
	return 1;
}

int PlayerFunctions::luaPlayerGetForgeCores(lua_State* L) {
	// player:getForgeCores()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	auto [sliver, core] = player->getForgeSliversAndCores();
	lua_pushnumber(L, static_cast<lua_Number>(core));
	return 1;
}

int PlayerFunctions::luaPlayerSetFaction(lua_State* L) {
	// player:setFaction(factionId)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player == nullptr) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	const Faction_t factionId = Lua::getNumber<Faction_t>(L, 2);
	player->setFaction(factionId);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetFaction(lua_State* L) {
	// player:getFaction()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (player == nullptr) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getFaction());
	return 1;
}

int PlayerFunctions::luaPlayerIsUIExhausted(lua_State* L) {
	// player:isUIExhausted()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	const uint16_t time = Lua::getNumber<uint16_t>(L, 2);
	Lua::pushBoolean(L, player->isUIExhausted(time));
	return 1;
}

int PlayerFunctions::luaPlayerUpdateUIExhausted(lua_State* L) {
	// player:updateUIExhausted(exhaustionTime = 250)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	player->updateUIExhausted();
	Lua::pushBoolean(L, true);
	return 1;
}

// Bosstiary Cooldown Timer
int PlayerFunctions::luaPlayerBosstiaryCooldownTimer(lua_State* L) {
	// player:sendBosstiaryCooldownTimer()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	player->sendBosstiaryCooldownTimer();
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetBosstiaryLevel(lua_State* L) {
	// player:getBosstiaryLevel(name)
	if (const auto &player = Lua::getUserdataShared<Player>(L, 1);
	    player) {
		const auto &mtype = g_monsters().getMonsterType(Lua::getString(L, 2));
		if (mtype) {
			const uint32_t bossId = mtype->info.raceid;
			if (bossId == 0) {
				lua_pushnil(L);
				return 0;
			}
			const auto level = g_ioBosstiary().getBossCurrentLevel(player, bossId);
			lua_pushnumber(L, level);
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetBosstiaryKills(lua_State* L) {
	// player:getBosstiaryKills(name)
	if (const auto &player = Lua::getUserdataShared<Player>(L, 1);
	    player) {
		const auto &mtype = g_monsters().getMonsterType(Lua::getString(L, 2));
		if (mtype) {
			const uint32_t bossId = mtype->info.raceid;
			if (bossId == 0) {
				lua_pushnil(L);
				return 0;
			}
			const uint32_t currentKills = player->getBestiaryKillCount(static_cast<uint16_t>(bossId));
			lua_pushnumber(L, currentKills);
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddBosstiaryKill(lua_State* L) {
	// player:addBosstiaryKill(name[, amount = 1])
	if (const auto &player = Lua::getUserdataShared<Player>(L, 1);
	    player) {
		const auto &mtype = g_monsters().getMonsterType(Lua::getString(L, 2));
		if (mtype) {
			g_ioBosstiary().addBosstiaryKill(player, mtype, Lua::getNumber<uint32_t>(L, 3, 1));
			Lua::pushBoolean(L, true);
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetBossPoints(lua_State* L) {
	// player:setBossPoints()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	player->setBossPoints(Lua::getNumber<uint32_t>(L, 2, 0));
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSetRemoveBossTime(lua_State* L) {
	// player:setRemoveBossTime()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	player->setRemoveBossTime(Lua::getNumber<uint8_t>(L, 2, 0));
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetSlotBossId(lua_State* L) {
	// player:getSlotBossId(slotId)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	const uint8_t slotId = Lua::getNumber<uint8_t>(L, 2);
	const auto bossId = player->getSlotBossId(slotId);
	lua_pushnumber(L, static_cast<lua_Number>(bossId));
	return 1;
}

int PlayerFunctions::luaPlayerGetBossBonus(lua_State* L) {
	// player:getBossBonus(slotId)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	const uint8_t slotId = Lua::getNumber<uint8_t>(L, 2);
	const auto bossId = player->getSlotBossId(slotId);

	const uint32_t playerBossPoints = player->getBossPoints();
	const uint16_t currentBonus = g_ioBosstiary().calculateLootBonus(playerBossPoints);

	const auto bossLevel = g_ioBosstiary().getBossCurrentLevel(player, bossId);
	const uint16_t bonusBoss = currentBonus + (bossLevel == 3 ? 25 : 0);

	lua_pushnumber(L, static_cast<lua_Number>(bonusBoss));
	return 1;
}

int PlayerFunctions::luaPlayerSendSingleSoundEffect(lua_State* L) {
	// player:sendSingleSoundEffect(soundId[, actor = true])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	const SoundEffect_t soundEffect = Lua::getNumber<SoundEffect_t>(L, 2);
	const bool actor = Lua::getBoolean(L, 3, true);

	player->sendSingleSoundEffect(player->getPosition(), soundEffect, actor ? SourceEffect_t::OWN : SourceEffect_t::GLOBAL);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSendDoubleSoundEffect(lua_State* L) {
	// player:sendDoubleSoundEffect(mainSoundId, secondarySoundId[, actor = true])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	const SoundEffect_t mainSoundEffect = Lua::getNumber<SoundEffect_t>(L, 2);
	const SoundEffect_t secondarySoundEffect = Lua::getNumber<SoundEffect_t>(L, 3);
	const bool actor = Lua::getBoolean(L, 4, true);

	player->sendDoubleSoundEffect(player->getPosition(), mainSoundEffect, actor ? SourceEffect_t::OWN : SourceEffect_t::GLOBAL, secondarySoundEffect, actor ? SourceEffect_t::OWN : SourceEffect_t::GLOBAL);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetName(lua_State* L) {
	// player:getName()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	Lua::pushString(L, player->getName());
	return 1;
}

int PlayerFunctions::luaPlayerChangeName(lua_State* L) {
	// player:changeName(newName)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}
	if (player->isOnline()) {
		player->removePlayer(true, true);
	}
	player->kv()->remove("namelock");
	const auto newName = Lua::getString(L, 2);
	player->setName(newName);
	g_saveManager().savePlayer(player);
	return 1;
}

int PlayerFunctions::luaPlayerHasGroupFlag(lua_State* L) {
	// player:hasGroupFlag(flag)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	Lua::pushBoolean(L, player->hasFlag(Lua::getNumber<PlayerFlags_t>(L, 2)));
	return 1;
}

int PlayerFunctions::luaPlayerSetGroupFlag(lua_State* L) {
	// player:setGroupFlag(flag)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	player->setFlag(Lua::getNumber<PlayerFlags_t>(L, 2));
	return 1;
}

int PlayerFunctions::luaPlayerRemoveGroupFlag(lua_State* L) {
	// player:removeGroupFlag(flag)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	player->removeFlag(Lua::getNumber<PlayerFlags_t>(L, 2));
	return 1;
}

// Hazard system
int PlayerFunctions::luaPlayerAddHazardSystemPoints(lua_State* L) {
	// player:setHazardSystemPoints(amount)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::pushBoolean(L, false);
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	player->setHazardSystemPoints(Lua::getNumber<int32_t>(L, 2, 0));
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetHazardSystemPoints(lua_State* L) {
	// player:getHazardSystemPoints()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::pushBoolean(L, false);
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	lua_pushnumber(L, player->getHazardSystemPoints());
	return 1;
}

int PlayerFunctions::luaPlayerSetLoyaltyBonus(lua_State* L) {
	// player:setLoyaltyBonus(amount)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->setLoyaltyBonus(Lua::getNumber<uint16_t>(L, 2));
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetLoyaltyBonus(lua_State* L) {
	// player:getLoyaltyBonus()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, player->getLoyaltyBonus());
	return 1;
}

int PlayerFunctions::luaPlayerGetLoyaltyPoints(lua_State* L) {
	// player:getLoyaltyPoints()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, player->getLoyaltyPoints());
	return 1;
}

int PlayerFunctions::luaPlayerGetLoyaltyTitle(lua_State* L) {
	// player:getLoyaltyTitle()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Lua::pushString(L, player->getLoyaltyTitle());
	return 1;
}

int PlayerFunctions::luaPlayerSetLoyaltyTitle(lua_State* L) {
	// player:setLoyaltyTitle(name)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->setLoyaltyTitle(Lua::getString(L, 2));
	Lua::pushBoolean(L, true);
	return 1;
}

// Wheel of destiny system
int PlayerFunctions::luaPlayerInstantSkillWOD(lua_State* L) {
	// player:instantSkillWOD(name[, value])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const std::string name = Lua::getString(L, 2);
	if (lua_gettop(L) == 2) {
		Lua::pushBoolean(L, player->wheel()->getInstant(name));
	} else {
		player->wheel()->setSpellInstant(name, Lua::getBoolean(L, 3));
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int PlayerFunctions::luaPlayerUpgradeSpellWOD(lua_State* L) {
	// player:upgradeSpellsWOD([name[, add]])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		player->wheel()->resetUpgradedSpells();
		return 1;
	}

	const std::string name = Lua::getString(L, 2);
	if (lua_gettop(L) == 2) {
		lua_pushnumber(L, static_cast<lua_Number>(player->wheel()->getSpellUpgrade(name)));
		return 1;
	}

	const bool add = Lua::getBoolean(L, 3);
	if (add) {
		player->wheel()->upgradeSpell(name);
	} else {
		player->wheel()->downgradeSpell(name);
	}

	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerRevelationStageWOD(lua_State* L) {
	// player:revelationStageWOD([name[, set]])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		player->wheel()->resetUpgradedSpells();
		return 1;
	}

	const std::string name = Lua::getString(L, 2);
	if (lua_gettop(L) == 2) {
		lua_pushnumber(L, static_cast<lua_Number>(player->wheel()->getStage(name)));
		return 1;
	}

	const bool value = Lua::getNumber<uint8_t>(L, 3);
	player->wheel()->setSpellInstant(name, value);

	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerReloadData(lua_State* L) {
	// player:reloadData()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->sendSkills();
	player->sendStats();
	player->sendBasicData();
	player->wheel()->sendGiftOfLifeCooldown();
	g_game().reloadCreature(player);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerOnThinkWheelOfDestiny(lua_State* L) {
	// player:onThinkWheelOfDestiny([force = false])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->wheel()->onThink(Lua::getBoolean(L, 2, false));
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerAvatarTimer(lua_State* L) {
	// player:avatarTimer([value])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, static_cast<lua_Number>(player->wheel()->getOnThinkTimer(WheelOnThink_t::AVATAR_SPELL)));
	} else {
		player->wheel()->setOnThinkTimer(WheelOnThink_t::AVATAR_SPELL, Lua::getNumber<int64_t>(L, 2));
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetWheelSpellAdditionalArea(lua_State* L) {
	// player:getWheelSpellAdditionalArea(spellname)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	const auto spellName = Lua::getString(L, 2);
	if (spellName.empty()) {
		Lua::reportErrorFunc("Spell name is empty");
		Lua::pushBoolean(L, false);
		return 0;
	}

	const auto &spell = g_spells().getInstantSpellByName(spellName);
	if (!spell) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	Lua::pushBoolean(L, player->wheel()->getSpellAdditionalArea(spellName));
	return 1;
}

int PlayerFunctions::luaPlayerGetWheelSpellAdditionalTarget(lua_State* L) {
	// player:getWheelSpellAdditionalTarget(spellname)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	const auto spellName = Lua::getString(L, 2);
	if (spellName.empty()) {
		Lua::reportErrorFunc("Spell name is empty");
		Lua::pushBoolean(L, false);
		return 0;
	}

	const auto &spell = g_spells().getInstantSpellByName(spellName);
	if (!spell) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->wheel()->getSpellAdditionalTarget(spellName));
	return 1;
}

int PlayerFunctions::luaPlayerGetWheelSpellAdditionalDuration(lua_State* L) {
	// player:getWheelSpellAdditionalDuration(spellname)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	const auto spellName = Lua::getString(L, 2);
	if (spellName.empty()) {
		Lua::reportErrorFunc("Spell name is empty");
		Lua::pushBoolean(L, false);
		return 0;
	}

	const auto &spell = g_spells().getInstantSpellByName(spellName);
	if (!spell) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->wheel()->getSpellAdditionalDuration(spellName));
	return 1;
}

int PlayerFunctions::luaPlayerUpdateConcoction(lua_State* L) {
	// player:updateConcoction(itemid, timeLeft)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	player->updateConcoction(Lua::getNumber<uint16_t>(L, 2), Lua::getNumber<uint16_t>(L, 3));
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerClearSpellCooldowns(lua_State* L) {
	// player:clearSpellCooldowns()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	player->clearCooldowns();
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerIsVip(lua_State* L) {
	// player:isVip()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	Lua::pushBoolean(L, player->isVip());
	return 1;
}

int PlayerFunctions::luaPlayerGetVipDays(lua_State* L) {
	// player:getVipDays()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	lua_pushnumber(L, player->getPremiumDays());
	return 1;
}

int PlayerFunctions::luaPlayerGetVipTime(lua_State* L) {
	// player:getVipTime()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	lua_pushinteger(L, player->getPremiumLastDay());
	return 1;
}

int PlayerFunctions::luaPlayerKV(lua_State* L) {
	// player:kv()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	Lua::pushUserdata<KV>(L, player->kv());
	Lua::setMetatable(L, -1, "KV");
	return 1;
}

int PlayerFunctions::luaPlayerGetStoreInbox(lua_State* L) {
	// player:getStoreInbox()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	if (const auto &item = player->getStoreInbox()) {
		Lua::pushUserdata<Item>(L, item);
		Lua::setItemMetatable(L, -1, item);
	} else {
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int PlayerFunctions::luaPlayerHasAchievement(lua_State* L) {
	// player:hasAchievement(id or name)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	uint16_t achievementId = 0;
	if (Lua::isNumber(L, 2)) {
		achievementId = Lua::getNumber<uint16_t>(L, 2);
	} else {
		achievementId = g_game().getAchievementByName(Lua::getString(L, 2)).id;
	}

	Lua::pushBoolean(L, player->achiev()->isUnlocked(achievementId));
	return 1;
}

int PlayerFunctions::luaPlayerAddAchievement(lua_State* L) {
	// player:addAchievement(id or name[, sendMessage = true])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	uint16_t achievementId = 0;
	if (Lua::isNumber(L, 2)) {
		achievementId = Lua::getNumber<uint16_t>(L, 2);
	} else {
		achievementId = g_game().getAchievementByName(Lua::getString(L, 2)).id;
	}

	const bool success = player->achiev()->add(achievementId, Lua::getBoolean(L, 3, true));
	if (success) {
		player->sendTakeScreenshot(SCREENSHOT_TYPE_ACHIEVEMENT);
	}

	Lua::pushBoolean(L, success);
	return 1;
}

int PlayerFunctions::luaPlayerRemoveAchievement(lua_State* L) {
	// player:removeAchievement(id or name)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	uint16_t achievementId = 0;
	if (Lua::isNumber(L, 2)) {
		achievementId = Lua::getNumber<uint16_t>(L, 2);
	} else {
		achievementId = g_game().getAchievementByName(Lua::getString(L, 2)).id;
	}

	Lua::pushBoolean(L, player->achiev()->remove(achievementId));
	return 1;
}

int PlayerFunctions::luaPlayerGetAchievementPoints(lua_State* L) {
	// player:getAchievementPoints()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	lua_pushnumber(L, player->achiev()->getPoints());
	return 1;
}

int PlayerFunctions::luaPlayerAddAchievementPoints(lua_State* L) {
	// player:addAchievementPoints(amount)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const auto points = Lua::getNumber<uint16_t>(L, 2);
	if (points > 0) {
		player->achiev()->addPoints(points);
	}
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerRemoveAchievementPoints(lua_State* L) {
	// player:removeAchievementPoints(amount)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const auto points = Lua::getNumber<uint16_t>(L, 2);
	if (points > 0) {
		player->achiev()->removePoints(points);
	}
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerAddBadge(lua_State* L) {
	// player:addBadge(id)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	player->badge()->add(Lua::getNumber<uint8_t>(L, 2, 0));
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerAddTitle(lua_State* L) {
	// player:addTitle(id)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	player->title()->manage(true, Lua::getNumber<uint8_t>(L, 2, 0));
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetTitles(lua_State* L) {
	// player:getTitles()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const auto playerTitles = player->title()->getUnlockedTitles();
	lua_createtable(L, static_cast<int>(playerTitles.size()), 0);

	int index = 0;
	for (const auto &title : playerTitles) {
		lua_createtable(L, 0, 3);
		Lua::setField(L, "id", title.first.m_id);
		Lua::setField(L, "name", player->title()->getNameBySex(player->getSex(), title.first.m_maleName, title.first.m_femaleName));
		Lua::setField(L, "description", title.first.m_description);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetCurrentTitle(lua_State* L) {
	// player:setCurrentTitle(id)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const auto &title = g_game().getTitleById(Lua::getNumber<uint8_t>(L, 2, 0));
	if (title.m_id == 0) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_VARIANT_NOT_FOUND));
		return 1;
	}

	player->title()->setCurrentTitle(title.m_id);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerCreateTransactionSummary(lua_State* L) {
	// player:createTransactionSummary(type, amount[, id = 0])
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const auto type = Lua::getNumber<uint8_t>(L, 2, 0);
	if (type == 0) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_VARIANT_NOT_FOUND));
		return 1;
	}

	const auto amount = Lua::getNumber<uint16_t>(L, 3, 1);
	const auto id = Lua::getString(L, 4, "");

	player->cyclopedia()->updateStoreSummary(type, amount, id);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerTakeScreenshot(lua_State* L) {
	// player:takeScreenshot(screenshotType)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto screenshotType = Lua::getNumber<Screenshot_t>(L, 2);
	player->sendTakeScreenshot(screenshotType);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSendIconBakragore(lua_State* L) {
	// player:sendIconBakragore()
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto iconType = Lua::getNumber<IconBakragore>(L, 2);
	player->sendIconBakragore(iconType);
	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerRemoveIconBakragore(lua_State* L) {
	// player:removeIconBakragore(iconType or nil for remove all bakragore icons)
	const auto &player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto iconType = Lua::getNumber<IconBakragore>(L, 2, IconBakragore::None);
	if (iconType == IconBakragore::None) {
		player->removeBakragoreIcons();
	} else {
		player->removeBakragoreIcon(iconType);
	}

	Lua::pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSendCreatureAppear(lua_State* L) {
	auto player = Lua::getUserdataShared<Player>(L, 1);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	bool isLogin = Lua::getBoolean(L, 2, false);
	player->sendCreatureAppear(player, player->getPosition(), isLogin);
	Lua::pushBoolean(L, true);
	return 1;
}
