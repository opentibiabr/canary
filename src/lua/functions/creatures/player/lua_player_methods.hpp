/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_LUA_FUNCTIONS_CREATURES_PLAYER_LUA_PLAYER_METHODS_HPP_
#define SRC_LUA_FUNCTIONS_CREATURES_PLAYER_LUA_PLAYER_METHODS_HPP_

#include "lua/scripts/luascript.h"
#include "lua/functions/creatures/player/group_functions.hpp"
#include "lua/functions/creatures/player/guild_functions.hpp"
#include "lua/functions/creatures/player/mount_functions.hpp"
#include "lua/functions/creatures/player/party_functions.hpp"
#include "lua/functions/creatures/player/vocation_functions.hpp"

class LuaPlayer final : LuaScriptInterface
{
public:
	static void init(lua_State* L);

protected:
	static const std::vector<LuaFunction> luaFunctions;
	// Register functions in the lua interface using lua bridge library
	static void registerLuaFunction(lua_State* L, const char* functionName, lua_CFunction function);
	// Get Player userdata from lua interface
	static Player* getPlayerUserdata(lua_State* L, int32_t arg = -1);

private:
	static int create(lua_State* L);
	static int unlockAllCharmRunes(lua_State* L);
	static int resetCharmsBestiary(lua_State* L);
	static int addCharmPoints(lua_State* L);
	static int isPlayer(lua_State* L);

	static int getGuid(lua_State* L);
	static int getIp(lua_State* L);
	static int getAccountId(lua_State* L);
	static int getLastLoginSaved(lua_State* L);
	static int getLastLogout(lua_State* L);

	static int getAccountType(lua_State* L);
	static int setAccountType(lua_State* L);

	static int addBestiaryKill(lua_State* L);
	static int isMonsterBestiaryUnlocked(lua_State* L);
	static int charmExpansion(lua_State* L);
	static int getCharmMonsterType(lua_State* L);

	static int getPreyCards(lua_State* L);
	static int getPreyLootPercentage(lua_State* L);
	static int preyThirdSlot(lua_State* L);
	static int taskHuntingThirdSlot(lua_State* L);
	static int removePreyStamina(lua_State* L);
	static int addPreyCards(lua_State* L);
	static int getPreyExperiencePercentage(lua_State* L);
	static int removeTaskHuntingPoints(lua_State* L);
	static int getTaskHuntingPoints(lua_State* L);
	static int addTaskHuntingPoints(lua_State* L);

	static int getCapacity(lua_State* L);
	static int setCapacity(lua_State* L);

	static int getIsTraining(lua_State* L);
	static int setTraining(lua_State* L);

	static int getKills(lua_State* L);
	static int setKills(lua_State* L);

	static int getFreeCapacity(lua_State* L);

	static int getReward(lua_State* L);
	static int removeReward(lua_State* L);
	static int getRewardList(lua_State* L);

	static int setDailyReward(lua_State* L);

	static int sendInventory(lua_State* L);
	static int sendLootStats(lua_State* L);
	static int updateKillTracker(lua_State* L);
	static int updateSupplyTracker(lua_State* L);

	static int getDepotLocker(lua_State* L);
	static int getDepotChest(lua_State* L);
	static int getInbox(lua_State* L);

	static int getSkullTime(lua_State* L);
	static int setSkullTime(lua_State* L);
	static int getDeathPenalty(lua_State* L);

	static int getExperience(lua_State* L);
	static int addExperience(lua_State* L);
	static int removeExperience(lua_State* L);
	static int getLevel(lua_State* L);

	static int getMagicLevel(lua_State* L);
	static int getBaseMagicLevel(lua_State* L);
	static int getMana(lua_State* L);
	static int addMana(lua_State* L);
	static int getMaxMana(lua_State* L);
	static int setMaxMana(lua_State* L);
	static int getManaSpent(lua_State* L);
	static int addManaSpent(lua_State* L);

	static int getName(lua_State* L);
	static int getId(lua_State* L);
	static int getPosition(lua_State* L);
	static int teleportTo(lua_State* L);

	static int getBaseMaxHealth(lua_State* L);
	static int getBaseMaxMana(lua_State* L);

	static int getSkillLevel(lua_State* L);
	static int getEffectiveSkillLevel(lua_State* L);
	static int getSkillPercent(lua_State* L);
	static int getSkillTries(lua_State* L);
	static int addSkillTries(lua_State* L);

	static int setMagicLevel(lua_State* L);
	static int setSkillLevel(lua_State* L);

	static int addOfflineTrainingTime(lua_State* L);
	static int getOfflineTrainingTime(lua_State* L);
	static int removeOfflineTrainingTime(lua_State* L);

	static int addOfflineTrainingTries(lua_State* L);

	static int getOfflineTrainingSkill(lua_State* L);
	static int setOfflineTrainingSkill(lua_State* L);

	static int getItemCount(lua_State* L);
	static int getStashItemCount(lua_State* L);
	static int getItemById(lua_State* L);

	static int getVocation(lua_State* L);
	static int setVocation(lua_State* L);

	static int getSex(lua_State* L);
	static int setSex(lua_State* L);

	static int getTown(lua_State* L);
	static int setTown(lua_State* L);

	static int getGuild(lua_State* L);
	static int setGuild(lua_State* L);

	static int getGuildLevel(lua_State* L);
	static int setGuildLevel(lua_State* L);

	static int getGuildNick(lua_State* L);
	static int setGuildNick(lua_State* L);

	static int getGroup(lua_State* L);
	static int setGroup(lua_State* L);

	static int isSupplyStashAvailable(lua_State* L);
	static int getStashCounter(lua_State* L);
	static int openStash(lua_State* L);
	static int setSpecialContainersAvailable(lua_State* L);

	static int getStamina(lua_State* L);
	static int setStamina(lua_State* L);

	static int getSoul(lua_State* L);
	static int addSoul(lua_State* L);
	static int getMaxSoul(lua_State* L);

	static int getBankBalance(lua_State* L);
	static int setBankBalance(lua_State* L);

	static int getStorageValue(lua_State* L);
	static int setStorageValue(lua_State* L);

	static int addItem(lua_State* L);
	static int addItemEx(lua_State* L);
	static int removeStashItem(lua_State* L);
	static int removeItem(lua_State* L);
	static int sendContainer(lua_State* L);

	static int getMoney(lua_State* L);
	static int addMoney(lua_State* L);
	static int removeMoney(lua_State* L);

	static int showTextDialog(lua_State* L);

	static int sendTextMessage(lua_State* L);
	static int sendChannelMessage(lua_State* L);
	static int sendPrivateMessage(lua_State* L);

	static int channelSay(lua_State* L);
	static int openChannel(lua_State* L);

	static int getSlotItem(lua_State* L);

	static int getParty(lua_State* L);

	static int addOutfit(lua_State* L);
	static int addOutfitAddon(lua_State* L);
	static int removeOutfit(lua_State* L);
	static int removeOutfitAddon(lua_State* L);
	static int hasOutfit(lua_State* L);
	static int sendOutfitWindow(lua_State* L);

	static int addMount(lua_State* L);
	static int removeMount(lua_State* L);
	static int hasMount(lua_State* L);

	static int addFamiliar(lua_State* L);
	static int removeFamiliar(lua_State* L);
	static int hasFamiliar(lua_State* L);
	static int setFamiliarLooktype(lua_State* L);
	static int getFamiliarLooktype(lua_State* L);

	static int getPremiumDays(lua_State* L);
	static int addPremiumDays(lua_State* L);
	static int removePremiumDays(lua_State* L);

	static int getTibiaCoins(lua_State* L);
	static int addTibiaCoins(lua_State* L);
	static int removeTibiaCoins(lua_State* L);

	static int hasBlessing(lua_State* L);
	static int addBlessing(lua_State* L);
	static int removeBlessing(lua_State* L);

	static int getBlessingCount(lua_State * L);

	static int canLearnSpell(lua_State* L);
	static int learnSpell(lua_State* L);
	static int forgetSpell(lua_State* L);
	static int hasLearnedSpell(lua_State* L);

	static int openImbuementWindow(lua_State* L);
	static int closeImbuementWindow(lua_State* L);

	static int sendTutorial(lua_State* L);
	static int addMapMark(lua_State* L);

	static int save(lua_State* L);
	static int popupFYI(lua_State* L);

	static int isPzLocked(lua_State* L);
	static int isOffline(lua_State* L);

	static int getContainers(lua_State* L);
	static int setLootContainer(lua_State* L);
	static int getLootContainer(lua_State* L);

	static int getClient(lua_State* L);

	static int getHouse(lua_State* L);
	static int sendHouseWindow(lua_State* L);
	static int setEditHouse(lua_State* L);

	static int setGhostMode(lua_State* L);

	static int getContainerId(lua_State* L);
	static int getContainerById(lua_State* L);
	static int getContainerIndex(lua_State* L);

	static int getInstantSpells(lua_State* L);
	static int canCast(lua_State* L);

	static int hasChaseMode(lua_State* L);
	static int hasSecureMode(lua_State* L);
	static int getFightMode(lua_State* L);

	static int getBaseXpGain(lua_State *L);
	static int setBaseXpGain(lua_State *L);
	static int getVoucherXpBoost(lua_State *L);
	static int setVoucherXpBoost(lua_State *L);
	static int getGrindingXpBoost(lua_State *L);
	static int setGrindingXpBoost(lua_State *L);
	static int getStoreXpBoost(lua_State *L);
	static int setStoreXpBoost(lua_State *L);
	static int getStaminaXpBoost(lua_State *L);
	static int setStaminaXpBoost(lua_State *L);
	static int getExpBoostStamina(lua_State* L);
	static int setExpBoostStamina(lua_State* L);

	static int getIdleTime(lua_State* L);
	static int getFreeBackpackSlots(lua_State* L);

	static int openMarket(lua_State* L);

	static int openForge(lua_State* L);
	static int closeForge(lua_State* L);
	static int sendForgeError(lua_State* L);

	static int addForgeDusts(lua_State* L);
	static int removeForgeDusts(lua_State* L);
	static int getForgeDusts(lua_State* L);
	static int setForgeDusts(lua_State *L);

	static int addForgeDustLevel(lua_State *L);
	static int removeForgeDustLevel(lua_State *L);
	static int getForgeDustLevel(lua_State *L);

	static int getForgeSlivers(lua_State* L);
	static int getForgeCores(lua_State* L);

	static int setFaction(lua_State* L);
	static int getFaction(lua_State* L);

	friend class CreatureFunctions;
};

#endif  // SRC_LUA_FUNCTIONS_CREATURES_PLAYER_LUA_PLAYER_METHODS_HPP_
