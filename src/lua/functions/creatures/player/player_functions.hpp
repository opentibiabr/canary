/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/functions/creatures/player/group_functions.hpp"
#include "lua/functions/creatures/player/guild_functions.hpp"
#include "lua/functions/creatures/player/mount_functions.hpp"
#include "lua/functions/creatures/player/party_functions.hpp"
#include "lua/functions/creatures/player/vocation_functions.hpp"

enum class PlayerIcon : uint8_t;
enum class IconBakragore : uint8_t;

class PlayerFunctions {
	static void init(lua_State* L);

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

	static int luaPlayerSendBlessStatus(lua_State* L);
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
	static int luaPlayerWheelUnlockScroll(lua_State* L);

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

	static int luaPlayerTakeScreenshot(lua_State* L);
	static int luaPlayerSendIconBakragore(lua_State* L);
	static int luaPlayerRemoveIconBakragore(lua_State* L);

	static int luaPlayerSendCreatureAppear(lua_State* L);

	static int luaPlayerAddAnimusMastery(lua_State* L);
	static int luaPlayerRemoveAnimusMastery(lua_State* L);
	static int luaPlayerHasAnimusMastery(lua_State* L);

	friend class CreatureFunctions;
};
