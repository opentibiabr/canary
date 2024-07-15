/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "items/containers/container.hpp"
#include "creatures/creature.hpp"
#include "items/cylinder.hpp"
#include "declarations.hpp"
#include "items/containers/depot/depotchest.hpp"
#include "items/containers/depot/depotlocker.hpp"
#include "grouping/familiars.hpp"
#include "enums/forge_conversion.hpp"
#include "grouping/groups.hpp"
#include "grouping/guild.hpp"
#include "imbuements/imbuements.hpp"
#include "items/containers/inbox/inbox.hpp"
#include "io/ioguild.hpp"
#include "io/ioprey.hpp"
#include "creatures/appearance/mounts/mounts.hpp"
#include "creatures/appearance/outfit/outfit.hpp"
#include "grouping/party.hpp"
#include "server/network/protocol/protocolgame.hpp"
#include "items/containers/rewards/reward.hpp"
#include "items/containers/rewards/rewardchest.hpp"
#include "map/town.hpp"
#include "vocations/vocation.hpp"
#include "creatures/npcs/npc.hpp"
#include "game/bank/bank.hpp"
#include "enums/object_category.hpp"
#include "enums/player_cyclopedia.hpp"
#include "creatures/players/cyclopedia/player_badge.hpp"
#include "creatures/players/cyclopedia/player_cyclopedia.hpp"
#include "creatures/players/cyclopedia/player_title.hpp"
#include "creatures/players/vip/player_vip.hpp"

class House;
class NetworkMessage;
class Weapon;
class ProtocolGame;
class Party;
class Task;
class Bed;
class Guild;
class Imbuement;
class PreySlot;
class TaskHuntingSlot;
class Spell;
class PlayerWheel;
class PlayerAchievement;
class PlayerBadge;
class PlayerCyclopedia;
class PlayerTitle;
class PlayerVIP;
class Spectators;
class Account;

struct ModalWindow;
struct Achievement;
struct Badge;
struct Title;
struct VIPGroup;

struct ForgeHistory {
	ForgeAction_t actionType = ForgeAction_t::FUSION;
	uint8_t tier = 0;
	uint8_t bonus = 0;

	time_t createdAt;

	uint16_t historyId = 0;

	uint64_t cost = 0;
	uint64_t dustCost = 0;
	uint64_t coresCost = 0;
	uint64_t gained = 0;

	bool success = false;
	bool tierLoss = false;
	bool successCore = false;
	bool tierCore = false;
	bool convergence = false;

	std::string description;
	std::string firstItemName;
	std::string secondItemName;
};

struct OpenContainer {
	std::shared_ptr<Container> container;
	uint16_t index;
};

using MuteCountMap = std::map<uint32_t, uint32_t>;

static constexpr uint16_t PLAYER_MAX_SPEED = std::numeric_limits<uint16_t>::max();
static constexpr uint16_t PLAYER_MIN_SPEED = 10;
static constexpr uint8_t PLAYER_SOUND_HEALTH_CHANGE = 10;

class Player final : public Creature, public Cylinder, public Bankable {
public:
	class PlayerLock {
	public:
		explicit PlayerLock(const std::shared_ptr<Player> &p) :
			player(p) {
			player->mutex.lock();
		}

		PlayerLock(const PlayerLock &) = delete;

		~PlayerLock() {
			player->mutex.unlock();
		}

	private:
		const std::shared_ptr<Player> &player;
	};

	explicit Player(ProtocolGame_ptr p);
	~Player();

	// non-copyable
	Player(const Player &) = delete;
	Player &operator=(const Player &) = delete;

	std::shared_ptr<Player> getPlayer() override {
		return static_self_cast<Player>();
	}
	std::shared_ptr<const Player> getPlayer() const override {
		return static_self_cast<Player>();
	}

	static std::shared_ptr<Task> createPlayerTask(uint32_t delay, std::function<void(void)> f, std::string context);

	void setID() override;

	void setOnline(bool value) override {
		online = value;
	}
	bool isOnline() const override {
		return online;
	}

	static uint32_t getFirstID();
	static uint32_t getLastID();

	static MuteCountMap muteCountMap;

	const std::string &getName() const override {
		return name;
	}
	void setName(const std::string &name) {
		this->name = name;
	}
	const std::string &getTypeName() const override {
		return name;
	}
	const std::string &getNameDescription() const override {
		return name;
	}
	std::string getDescription(int32_t lookDistance) override;

	CreatureType_t getType() const override {
		return CREATURETYPE_PLAYER;
	}

	uint8_t getLastMount() const;
	uint8_t getCurrentMount() const;
	void setCurrentMount(uint8_t mountId);
	bool isMounted() const {
		return defaultOutfit.lookMount != 0;
	}
	bool toggleMount(bool mount);
	bool tameMount(uint8_t mountId);
	bool untameMount(uint8_t mountId);
	bool hasMount(const std::shared_ptr<Mount> mount) const;
	bool hasAnyMount() const;
	uint8_t getRandomMountId() const;
	void dismount();
	uint16_t getDodgeChance() const;

	uint8_t isRandomMounted() const {
		return randomMount;
	}
	void setRandomMount(uint8_t isMountRandomized) {
		randomMount = isMountRandomized;
	}

	void sendFYIBox(const std::string &message) {
		if (client) {
			client->sendFYIBox(message);
		}
	}

	void BestiarysendCharms() {
		if (client) {
			client->BestiarysendCharms();
		}
	}
	void addBestiaryKillCount(uint16_t raceid, uint32_t amount) {
		uint32_t oldCount = getBestiaryKillCount(raceid);
		uint32_t key = STORAGEVALUE_BESTIARYKILLCOUNT + raceid;
		addStorageValue(key, static_cast<int32_t>(oldCount + amount), true);
	}
	uint32_t getBestiaryKillCount(uint16_t raceid) const {
		uint32_t key = STORAGEVALUE_BESTIARYKILLCOUNT + raceid;
		auto value = getStorageValue(key);
		return value > 0 ? static_cast<uint32_t>(value) : 0;
	}

	void setGUID(uint32_t newGuid) {
		this->guid = newGuid;
	}
	uint32_t getGUID() const {
		return guid;
	}
	bool canSeeInvisibility() const override {
		return hasFlag(PlayerFlags_t::CanSenseInvisibility) || group->access;
	}

	void setDailyReward(uint8_t reward) {
		this->isDailyReward = reward;
	}

	void removeList() override;
	void addList() override;
	void removePlayer(bool displayEffect, bool forced = true);

	static uint64_t getExpForLevel(const uint32_t level) {
		return (((level - 6ULL) * level + 17ULL) * level - 12ULL) / 6ULL * 100ULL;
	}

	uint16_t getStaminaMinutes() const {
		return staminaMinutes;
	}

	void sendItemsPrice() {
		if (client) {
			client->sendItemsPrice();
		}
	}

	void sendForgingData() const {
		if (client) {
			client->sendForgingData();
		}
	}

	bool addOfflineTrainingTries(skills_t skill, uint64_t tries);

	void addOfflineTrainingTime(int32_t addTime) {
		offlineTrainingTime = std::min<int32_t>(12 * 3600 * 1000, offlineTrainingTime + addTime);
	}
	void removeOfflineTrainingTime(int32_t removeTime) {
		offlineTrainingTime = std::max<int32_t>(0, offlineTrainingTime - removeTime);
	}
	int32_t getOfflineTrainingTime() const {
		return offlineTrainingTime;
	}

	int8_t getOfflineTrainingSkill() const {
		return offlineTrainingSkill;
	}
	void setOfflineTrainingSkill(int8_t skill) {
		offlineTrainingSkill = skill;
	}

	uint64_t getBankBalance() const override {
		return bankBalance;
	}
	void setBankBalance(uint64_t balance) override {
		bankBalance = balance;
	}

	[[nodiscard]] std::shared_ptr<Guild> getGuild() const {
		return guild;
	}
	void setGuild(const std::shared_ptr<Guild> guild);

	[[nodiscard]] GuildRank_ptr getGuildRank() const {
		return guildRank;
	}
	void setGuildRank(GuildRank_ptr newGuildRank) {
		guildRank = newGuildRank;
	}

	bool isGuildMate(std::shared_ptr<Player> player) const;

	[[nodiscard]] const std::string &getGuildNick() const {
		return guildNick;
	}
	void setGuildNick(std::string nick) {
		guildNick = nick;
	}

	bool isInWar(std::shared_ptr<Player> player) const;
	bool isInWarList(uint32_t guild_id) const;

	void setLastWalkthroughAttempt(int64_t walkthroughAttempt) {
		lastWalkthroughAttempt = walkthroughAttempt;
	}
	void setLastWalkthroughPosition(Position walkthroughPosition) {
		lastWalkthroughPosition = walkthroughPosition;
	}

	std::shared_ptr<Inbox> getInbox() const {
		return inbox;
	}

	uint32_t getClientIcons();

	const GuildWarVector &getGuildWarVector() const {
		return guildWarVector;
	}

	const std::unordered_set<std::shared_ptr<MonsterType>> &getCyclopediaMonsterTrackerSet(bool isBoss) const {
		return isBoss ? m_bosstiaryMonsterTracker : m_bestiaryMonsterTracker;
	}

	void addMonsterToCyclopediaTrackerList(const std::shared_ptr<MonsterType> mtype, bool isBoss, bool reloadClient = false);

	void removeMonsterFromCyclopediaTrackerList(std::shared_ptr<MonsterType> mtype, bool isBoss, bool reloadClient = false);

	void sendBestiaryEntryChanged(uint16_t raceid) {
		if (client) {
			client->sendBestiaryEntryChanged(raceid);
		}
	}

	void refreshCyclopediaMonsterTracker(bool isBoss = false) {
		refreshCyclopediaMonsterTracker(getCyclopediaMonsterTrackerSet(isBoss), isBoss);
	}

	void refreshCyclopediaMonsterTracker(const std::unordered_set<std::shared_ptr<MonsterType>> &trackerList, bool isBoss) const {
		if (client) {
			client->refreshCyclopediaMonsterTracker(trackerList, isBoss);
		}
	}

	bool isBossOnBosstiaryTracker(const std::shared_ptr<MonsterType> &monsterType) const;

	std::shared_ptr<Vocation> getVocation() const {
		return vocation;
	}

	OperatingSystem_t getOperatingSystem() const {
		return operatingSystem;
	}
	void setOperatingSystem(OperatingSystem_t clientos) {
		operatingSystem = clientos;
	}

	bool isOldProtocol() {
		return client && client->oldProtocol;
	}

	uint32_t getProtocolVersion() const {
		if (!client) {
			return 0;
		}

		return client->getVersion();
	}

	bool hasSecureMode() const {
		return secureMode;
	}

	void setParty(std::shared_ptr<Party> newParty) {
		m_party = newParty;
	}
	std::shared_ptr<Party> getParty() const {
		return m_party;
	}

	int32_t getCleavePercent(bool useCharges = false) const;

	void setCleavePercent(int32_t value) {
		cleavePercent = std::max(0, cleavePercent + value);
	}

	int32_t getPerfectShotDamage(uint8_t range, bool useCharges = false) const;

	void setPerfectShotDamage(uint8_t range, int32_t damage) {
		int32_t actualDamage = getPerfectShotDamage(range);
		bool aboveZero = (actualDamage != 0);
		actualDamage += damage;
		if (actualDamage == 0 && aboveZero) {
			perfectShot.erase(range);
		} else {
			perfectShot[range] = actualDamage;
		}
	}

	int32_t getSpecializedMagicLevel(CombatType_t combat, bool useCharges = false) const;

	void setSpecializedMagicLevel(CombatType_t combat, int32_t value) {
		specializedMagicLevel[combatTypeToIndex(combat)] = std::max(0, specializedMagicLevel[combatTypeToIndex(combat)] + value);
	}

	int32_t getMagicShieldCapacityFlat(bool useCharges = false) const;

	void setMagicShieldCapacityFlat(int32_t value) {
		magicShieldCapacityFlat += value;
	}

	int32_t getMagicShieldCapacityPercent(bool useCharges = false) const;

	void setMagicShieldCapacityPercent(int32_t value) {
		magicShieldCapacityPercent += value;
	}

	int32_t getReflectPercent(CombatType_t combat, bool useCharges = false) const override;

	int32_t getReflectFlat(CombatType_t combat, bool useCharges = false) const override;

	PartyShields_t getPartyShield(std::shared_ptr<Player> player);
	bool isInviting(std::shared_ptr<Player> player) const;
	bool isPartner(std::shared_ptr<Player> player) const;
	void sendPlayerPartyIcons(std::shared_ptr<Player> player);
	bool addPartyInvitation(std::shared_ptr<Party> party);
	void removePartyInvitation(std::shared_ptr<Party> party);
	void clearPartyInvitations();

	void sendUnjustifiedPoints();

	GuildEmblems_t getGuildEmblem(std::shared_ptr<Player> player) const;

	uint64_t getSpentMana() const {
		return manaSpent;
	}

	bool hasFlag(PlayerFlags_t flag) const {
		return group->flags[static_cast<std::size_t>(flag)];
	}

	void setFlag(PlayerFlags_t flag) const {
		group->flags[static_cast<std::size_t>(flag)] = true;
	}

	void removeFlag(PlayerFlags_t flag) const {
		group->flags[static_cast<std::size_t>(flag)] = false;
	}

	std::shared_ptr<BedItem> getBedItem() {
		return bedItem;
	}
	void setBedItem(std::shared_ptr<BedItem> b) {
		bedItem = b;
	}

	bool hasImbuingItem() {
		return imbuingItem != nullptr;
	}
	void setImbuingItem(std::shared_ptr<Item> item);

	void addBlessing(uint8_t index, uint8_t count) {
		if (blessings[index - 1] == 255) {
			return;
		}

		blessings[index - 1] += count;
	}
	void removeBlessing(uint8_t index, uint8_t count) {
		if (blessings[index - 1] == 0) {
			return;
		}

		blessings[index - 1] -= count;
	}
	bool hasBlessing(uint8_t index) const {
		return blessings[index - 1] != 0;
	}

	uint8_t getBlessingCount(uint8_t index, bool storeCount = false) const {
		if (!storeCount) {
			if (index > 0 && index <= blessings.size()) {
				return blessings[index - 1];
			} else {
				g_logger().error("[{}] - index outside range 0-10.", __FUNCTION__);
				return 0;
			}
		}
		auto amount = kv()->scoped("summary")->scoped("blessings")->scoped(fmt::format("{}", index))->get("amount");
		return amount ? static_cast<uint8_t>(amount->getNumber()) : 0;
	}
	std::string getBlessingsName() const;

	bool isOffline() const {
		return (getID() == 0);
	}
	void disconnect() {
		if (client) {
			client->disconnect();
		}
	}

	uint32_t getIP() const {
		return client ? client->getIP() : 0;
	}

	bool isDisconnected() const {
		return getIP() == 0;
	}

	void addContainer(uint8_t cid, std::shared_ptr<Container> container);
	void closeContainer(uint8_t cid);
	void setContainerIndex(uint8_t cid, uint16_t index);

	std::shared_ptr<Container> getContainerByID(uint8_t cid);
	int8_t getContainerID(std::shared_ptr<Container> container) const;
	uint16_t getContainerIndex(uint8_t cid) const;

	bool canOpenCorpse(uint32_t ownerId) const;

	void addStorageValue(const uint32_t key, const int32_t value, const bool isLogin = false);
	int32_t getStorageValue(const uint32_t key) const;

	int32_t getStorageValueByName(const std::string &storageName) const;
	void addStorageValueByName(const std::string &storageName, const int32_t value, const bool isLogin = false);

	std::shared_ptr<KV> kv() const {
		return g_kv().scoped("player")->scoped(fmt::format("{}", getGUID()));
	}

	void genReservedStorageRange();

	void setGroup(std::shared_ptr<Group> newGroup) {
		group = newGroup;
	}
	std::shared_ptr<Group> getGroup() const {
		return group;
	}

	void setInMarket(bool value) {
		inMarket = value;
	}
	bool isInMarket() const {
		return inMarket;
	}
	void setSpecialMenuAvailable(bool supplyStashBool, bool marketMenuBool, bool depotSearchBool) {
		// Closing depot search when player have special container disabled and it's still open.
		if (isDepotSearchOpen() && !depotSearchBool && depotSearch) {
			depotSearchOnItem = { 0, 0 };
			sendCloseDepotSearch();
		}

		// Menu option 'stow, stow container ...'
		// Menu option 'show in market'
		// Menu option to open depot search
		supplyStash = supplyStashBool;
		marketMenu = marketMenuBool;
		depotSearch = depotSearchBool;
		if (client) {
			client->sendSpecialContainersAvailable();
		}
	}
	bool isDepotSearchOpen() const {
		return depotSearchOnItem.first != 0;
	}
	bool isDepotSearchOpenOnItem(uint16_t itemId) const {
		return depotSearchOnItem.first == itemId;
	}
	void setDepotSearchIsOpen(uint16_t itemId, uint8_t tier) {
		depotSearchOnItem = { itemId, tier };
	}
	bool isDepotSearchAvailable() const {
		return depotSearch;
	}
	bool isSupplyStashMenuAvailable() {
		return supplyStash;
	}
	bool isMarketMenuAvailable() {
		return marketMenu;
	}
	bool isExerciseTraining() {
		return exerciseTraining;
	}
	void setExerciseTraining(bool isTraining) {
		exerciseTraining = isTraining;
	}
	void setLastDepotId(int16_t newId) {
		lastDepotId = newId;
	}
	int16_t getLastDepotId() const {
		return lastDepotId;
	}

	void resetIdleTime() {
		idleTime = 0;
	}

	bool isInGhostMode() const override {
		return ghostMode;
	}
	void switchGhostMode() {
		ghostMode = !ghostMode;
	}
	uint32_t getLevel() const {
		return level;
	}
	uint8_t getLevelPercent() const {
		return levelPercent;
	}
	uint32_t getMagicLevel() const;
	uint32_t getLoyaltyMagicLevel() const;
	uint32_t getBaseMagicLevel() const {
		return magLevel;
	}
	double_t getMagicLevelPercent() const {
		return magLevelPercent;
	}
	uint8_t getSoul() const {
		return soul;
	}
	bool isAccessPlayer() const;
	bool isPlayerGroup() const;
	bool isPremium() const;
	uint32_t getPremiumDays() const;
	time_t getPremiumLastDay() const;

	bool isVip() const {
		return g_configManager().getBoolean(VIP_SYSTEM_ENABLED, __FUNCTION__) && (getPremiumDays() > 0 || getPremiumLastDay() > getTimeNow());
	}

	void setTibiaCoins(int32_t v);
	void setTransferableTibiaCoins(int32_t v);

	uint16_t getHelpers() const;

	bool setVocation(uint16_t vocId);
	uint16_t getVocationId() const {
		return vocation->getId();
	}

	PlayerSex_t getSex() const {
		return sex;
	}
	PlayerPronoun_t getPronoun() const {
		return pronoun;
	}
	std::string getObjectPronoun() const {
		return getPlayerObjectPronoun(pronoun, sex, name);
	}
	std::string getSubjectPronoun() const {
		return getPlayerSubjectPronoun(pronoun, sex, name);
	}
	std::string getPossessivePronoun() const {
		return getPlayerPossessivePronoun(pronoun, sex, name);
	}
	std::string getReflexivePronoun() const {
		return getPlayerReflexivePronoun(pronoun, sex, name);
	}
	std::string getSubjectVerb(bool past = false) const {
		return getVerbForPronoun(pronoun, past);
	}
	void setSex(PlayerSex_t);
	void setPronoun(PlayerPronoun_t);
	uint64_t getExperience() const {
		return experience;
	}

	time_t getLastLoginSaved() const {
		return lastLoginSaved;
	}

	time_t getLastLogout() const {
		return lastLogout;
	}

	const Position &getLoginPosition() const {
		return loginPosition;
	}
	const Position &getTemplePosition() const {
		if (!town) {
			static auto emptyPosition = Position();
			return emptyPosition;
		}

		return town->getTemplePosition();
	}
	std::shared_ptr<Town> getTown() const {
		return town;
	}
	void setTown(const std::shared_ptr<Town> &newTown) {
		this->town = newTown;
	}

	void clearModalWindows();
	bool hasModalWindowOpen(uint32_t modalWindowId) const;
	void onModalWindowHandled(uint32_t modalWindowId);

	bool isPushable() override;
	uint32_t isMuted() const;
	void addMessageBuffer();
	void removeMessageBuffer();

	bool removeItemOfType(uint16_t itemId, uint32_t itemAmount, int32_t subType, bool ignoreEquipped = false);
	/**
	 * @param itemAmount is uint32_t because stash item is uint32_t max
	 */
	bool hasItemCountById(uint16_t itemId, uint32_t itemCount, bool checkStash) const;
	/**
	 * @param itemAmount is uint32_t because stash item is uint32_t max
	 */
	bool removeItemCountById(uint16_t itemId, uint32_t itemAmount, bool removeFromStash = true);

	void addItemOnStash(uint16_t itemId, uint32_t amount) {
		auto it = stashItems.find(itemId);
		if (it != stashItems.end()) {
			stashItems[itemId] += amount;
			return;
		}

		stashItems[itemId] = amount;
	}
	uint32_t getStashItemCount(uint16_t itemId) const {
		auto it = stashItems.find(itemId);
		if (it != stashItems.end()) {
			return it->second;
		}
		return 0;
	}
	bool withdrawItem(uint16_t itemId, uint32_t amount) {
		auto it = stashItems.find(itemId);
		if (it != stashItems.end()) {
			if (it->second > amount) {
				stashItems[itemId] -= amount;
			} else if (it->second == amount) {
				stashItems.erase(itemId);
			} else {
				return false;
			}
			return true;
		}
		return false;
	}
	StashItemList getStashItems() const {
		return stashItems;
	}

	uint32_t getBaseCapacity() const {
		if (hasFlag(PlayerFlags_t::CannotPickupItem)) {
			return 0;
		} else if (hasFlag(PlayerFlags_t::HasInfiniteCapacity)) {
			return std::numeric_limits<uint32_t>::max();
		}
		return capacity;
	}

	uint32_t getCapacity() const;

	uint32_t getBonusCapacity() const {
		if (hasFlag(PlayerFlags_t::CannotPickupItem) || hasFlag(PlayerFlags_t::HasInfiniteCapacity)) {
			return std::numeric_limits<uint32_t>::max();
		}
		return bonusCapacity;
	}

	uint32_t getFreeCapacity() const {
		if (hasFlag(PlayerFlags_t::CannotPickupItem)) {
			return 0;
		} else if (hasFlag(PlayerFlags_t::HasInfiniteCapacity)) {
			return std::numeric_limits<uint32_t>::max();
		} else {
			return std::max<int32_t>(0, getCapacity() - inventoryWeight);
		}
	}

	int32_t getMaxHealth() const override;
	uint32_t getMaxMana() const override;

	std::shared_ptr<Item> getInventoryItem(Slots_t slot) const;

	bool isItemAbilityEnabled(Slots_t slot) const {
		return inventoryAbilities[slot];
	}
	void setItemAbility(Slots_t slot, bool enabled) {
		inventoryAbilities[slot] = enabled;
	}

	void setVarSkill(skills_t skill, int32_t modifier) {
		varSkills[skill] += modifier;
	}

	void setVarStats(stats_t stat, int32_t modifier);
	int32_t getDefaultStats(stats_t stat) const;

	void addConditionSuppressions(const std::array<ConditionType_t, ConditionType_t::CONDITION_COUNT> &addCondition);
	void removeConditionSuppressions();

	std::shared_ptr<Reward> getReward(const uint64_t rewardId, const bool autoCreate);
	void removeReward(uint64_t rewardId);
	void getRewardList(std::vector<uint64_t> &rewards) const;
	std::shared_ptr<RewardChest> getRewardChest();

	std::vector<std::shared_ptr<Item>> getRewardsFromContainer(std::shared_ptr<Container> container) const;

	std::shared_ptr<DepotChest> getDepotChest(uint32_t depotId, bool autoCreate);
	std::shared_ptr<DepotLocker> getDepotLocker(uint32_t depotId);
	void onReceiveMail();
	bool isNearDepotBox();

	std::shared_ptr<Container> refreshManagedContainer(ObjectCategory_t category, std::shared_ptr<Container> container, bool isLootContainer, bool loading = false);
	std::shared_ptr<Container> getManagedContainer(ObjectCategory_t category, bool isLootContainer) const;
	void setMainBackpackUnassigned(std::shared_ptr<Container> container);

	bool canSee(const Position &pos) override;
	bool canSeeCreature(std::shared_ptr<Creature> creature) const override;

	bool canWalkthrough(std::shared_ptr<Creature> creature);
	bool canWalkthroughEx(std::shared_ptr<Creature> creature);

	RaceType_t getRace() const override {
		return RACE_BLOOD;
	}

	uint64_t getMoney() const;
	std::pair<uint64_t, uint64_t> getForgeSliversAndCores() const;

	// safe-trade functions
	void setTradeState(TradeState_t state) {
		tradeState = state;
	}
	TradeState_t getTradeState() const {
		return tradeState;
	}
	std::shared_ptr<Item> getTradeItem() {
		return tradeItem;
	}

	// shop functions
	void setShopOwner(std::shared_ptr<Npc> owner) {
		shopOwner = owner;
	}

	std::shared_ptr<Npc> getShopOwner() const {
		return shopOwner;
	}

	// follow functions
	bool setFollowCreature(std::shared_ptr<Creature> creature) override;
	void goToFollowCreature() override;

	// follow events
	void onFollowCreature(const std::shared_ptr<Creature> &) override;

	// walk events
	void onWalk(Direction &dir) override;
	void onWalkAborted() override;
	void onWalkComplete() override;

	void stopWalk();
	bool openShopWindow(std::shared_ptr<Npc> npc, const std::vector<ShopBlock> &shopItems = {});
	bool closeShopWindow();
	bool updateSaleShopList(std::shared_ptr<Item> item);
	bool hasShopItemForSale(uint16_t itemId, uint8_t subType) const;

	void setChaseMode(bool mode);
	void setFightMode(FightMode_t mode) {
		fightMode = mode;
	}
	void setSecureMode(bool mode) {
		secureMode = mode;
	}

	Faction_t getFaction() const override {
		return faction;
	}

	void setFaction(Faction_t factionId) {
		faction = factionId;
	}
	// combat functions
	bool setAttackedCreature(std::shared_ptr<Creature> creature) override;
	bool isImmune(CombatType_t type) const override;
	bool isImmune(ConditionType_t type) const override;
	bool hasShield() const;
	bool isAttackable() const override;
	static bool lastHitIsPlayer(std::shared_ptr<Creature> lastHitCreature);

	// stash functions
	bool addItemFromStash(uint16_t itemId, uint32_t itemCount);
	void stowItem(std::shared_ptr<Item> item, uint32_t count, bool allItems);

	void changeHealth(int32_t healthChange, bool sendHealthChange = true) override;
	void changeMana(int32_t manaChange) override;
	void changeSoul(int32_t soulChange);

	bool isPzLocked() const {
		return pzLocked;
	}
	BlockType_t blockHit(std::shared_ptr<Creature> attacker, CombatType_t combatType, int32_t &damage, bool checkDefense = false, bool checkArmor = false, bool field = false) override;
	void doAttacking(uint32_t interval) override;
	bool hasExtraSwing() override {
		return lastAttack > 0 && !checkLastAttackWithin(getAttackSpeed());
	}

	uint16_t getSkillLevel(skills_t skill) const;
	uint16_t getLoyaltySkill(skills_t skill) const;
	uint16_t getBaseSkill(uint8_t skill) const {
		return skills[skill].level;
	}
	double_t getSkillPercent(skills_t skill) const {
		return skills[skill].percent;
	}

	bool getAddAttackSkill() const {
		return addAttackSkillPoint;
	}

	BlockType_t getLastAttackBlockType() const {
		return lastAttackBlockType;
	}

	uint64_t getLastConditionTime(ConditionType_t type) const {
		if (!lastConditionTime.contains(static_cast<uint8_t>(type))) {
			return 0;
		}
		return lastConditionTime.at(static_cast<uint8_t>(type));
	}

	void updateLastConditionTime(ConditionType_t type) {
		lastConditionTime[static_cast<uint8_t>(type)] = OTSYS_TIME();
	}

	bool checkLastConditionTimeWithin(ConditionType_t type, uint32_t interval) const {
		if (!lastConditionTime.contains(static_cast<uint8_t>(type))) {
			return false;
		}
		auto last = lastConditionTime.at(static_cast<uint8_t>(type));
		return last > 0 && ((OTSYS_TIME() - last) < interval);
	}

	uint64_t getLastAttack() const {
		return lastAttack;
	}

	bool checkLastAttackWithin(uint32_t interval) const {
		return lastAttack > 0 && ((OTSYS_TIME() - lastAttack) < interval);
	}

	void updateLastAttack() {
		if (lastAttack == 0) {
			lastAttack = OTSYS_TIME() - getAttackSpeed() - 1;
			return;
		}
		lastAttack = OTSYS_TIME();
	}

	uint64_t getLastAggressiveAction() const {
		return lastAggressiveAction;
	}

	bool checkLastAggressiveActionWithin(uint32_t interval) const {
		return lastAggressiveAction > 0 && ((OTSYS_TIME() - lastAggressiveAction) < interval);
	}

	void updateLastAggressiveAction() {
		lastAggressiveAction = OTSYS_TIME();
	}

	std::unordered_set<std::string> getNPCSkips();

	std::shared_ptr<Item> getWeapon(Slots_t slot, bool ignoreAmmo) const;
	std::shared_ptr<Item> getWeapon(bool ignoreAmmo = false) const;
	WeaponType_t getWeaponType() const;
	int32_t getWeaponSkill(std::shared_ptr<Item> item) const;
	void getShieldAndWeapon(std::shared_ptr<Item> &shield, std::shared_ptr<Item> &weapon) const;

	void drainHealth(std::shared_ptr<Creature> attacker, int32_t damage) override;
	void drainMana(std::shared_ptr<Creature> attacker, int32_t manaLoss) override;
	void addManaSpent(uint64_t amount);
	void addSkillAdvance(skills_t skill, uint64_t count);

	int32_t getArmor() const override;
	int32_t getDefense() const override;
	float getAttackFactor() const override;
	float getDefenseFactor() const override;
	float getMitigation() const override;
	double getMitigationMultiplier() const;

	void addInFightTicks(bool pzlock = false);

	uint64_t getGainedExperience(std::shared_ptr<Creature> attacker) const override;

	// combat event functions
	void onAddCondition(ConditionType_t type) override;
	void onAddCombatCondition(ConditionType_t type) override;
	void onEndCondition(ConditionType_t type) override;
	void onCombatRemoveCondition(std::shared_ptr<Condition> condition) override;
	void onAttackedCreature(std::shared_ptr<Creature> target) override;
	void onAttacked() override;
	void onAttackedCreatureDrainHealth(std::shared_ptr<Creature> target, int32_t points) override;
	void onTargetCreatureGainHealth(std::shared_ptr<Creature> target, int32_t points) override;
	bool onKilledPlayer(const std::shared_ptr<Player> &target, bool lastHit) override;
	bool onKilledMonster(const std::shared_ptr<Monster> &target) override;
	void onGainExperience(uint64_t gainExp, std::shared_ptr<Creature> target) override;
	void onGainSharedExperience(uint64_t gainExp, std::shared_ptr<Creature> target);
	void onAttackedCreatureBlockHit(BlockType_t blockType) override;
	void onBlockHit() override;
	void onTakeDamage(std::shared_ptr<Creature> attacker, int32_t damage) override;
	void onChangeZone(ZoneType_t zone) override;
	void onAttackedCreatureChangeZone(ZoneType_t zone) override;
	void onIdleStatus() override;
	void onPlacedCreature() override;

	LightInfo getCreatureLight() const override;

	Skulls_t getSkull() const override;
	Skulls_t getSkullClient(std::shared_ptr<Creature> creature) override;
	int64_t getSkullTicks() const {
		return skullTicks;
	}
	void setSkullTicks(int64_t ticks) {
		skullTicks = ticks;
	}

	bool hasAttacked(std::shared_ptr<Player> attacked) const;
	void addAttacked(std::shared_ptr<Player> attacked);
	void removeAttacked(std::shared_ptr<Player> attacked);
	void clearAttacked();
	void addUnjustifiedDead(std::shared_ptr<Player> attacked);
	void sendCreatureEmblem(std::shared_ptr<Creature> creature) const {
		if (client) {
			client->sendCreatureEmblem(creature);
		}
	}
	void sendCreatureSkull(std::shared_ptr<Creature> creature) const {
		if (client) {
			client->sendCreatureSkull(creature);
		}
	}
	void checkSkullTicks(int64_t ticks);

	bool canWear(uint16_t lookType, uint8_t addons) const;
	void addOutfit(uint16_t lookType, uint8_t addons);
	bool removeOutfit(uint16_t lookType);
	bool removeOutfitAddon(uint16_t lookType, uint8_t addons);
	bool getOutfitAddons(const std::shared_ptr<Outfit> &outfit, uint8_t &addons) const;

	bool canFamiliar(uint16_t lookType) const;
	void addFamiliar(uint16_t lookType);
	bool removeFamiliar(uint16_t lookType);
	bool getFamiliar(const std::shared_ptr<Familiar> &familiar) const;
	void setFamiliarLooktype(uint16_t familiarLooktype) {
		this->defaultOutfit.lookFamiliarsType = familiarLooktype;
	}

	bool canLogout();

	bool hasKilled(std::shared_ptr<Player> player) const;

	size_t getMaxDepotItems() const;

	// tile
	// send methods
	void sendAddTileItem(std::shared_ptr<Tile> itemTile, const Position &pos, std::shared_ptr<Item> item) {
		if (client) {
			int32_t stackpos = itemTile->getStackposOfItem(static_self_cast<Player>(), item);
			if (stackpos != -1) {
				client->sendAddTileItem(pos, stackpos, item);
			}
		}
	}
	void sendUpdateTileItem(std::shared_ptr<Tile> updateTile, const Position &pos, std::shared_ptr<Item> item) {
		if (client) {
			int32_t stackpos = updateTile->getStackposOfItem(static_self_cast<Player>(), item);
			if (stackpos != -1) {
				client->sendUpdateTileItem(pos, stackpos, item);
			}
		}
	}
	void sendRemoveTileThing(const Position &pos, int32_t stackpos) {
		if (stackpos != -1 && client) {
			client->sendRemoveTileThing(pos, stackpos);
		}
	}
	void sendUpdateTileCreature(const std::shared_ptr<Creature> creature) {
		if (client) {
			client->sendUpdateTileCreature(creature->getPosition(), creature->getTile()->getClientIndexOfCreature(static_self_cast<Player>(), creature), creature);
		}
	}
	void sendUpdateTile(std::shared_ptr<Tile> updateTile, const Position &pos) {
		if (client) {
			client->sendUpdateTile(updateTile, pos);
		}
	}

	void sendChannelMessage(const std::string &author, const std::string &text, SpeakClasses type, uint16_t channel) {
		if (client) {
			client->sendChannelMessage(author, text, type, channel);
		}
	}
	void sendChannelEvent(uint16_t channelId, const std::string &playerName, ChannelEvent_t channelEvent) {
		if (client) {
			client->sendChannelEvent(channelId, playerName, channelEvent);
		}
	}
	void sendCreatureAppear(std::shared_ptr<Creature> creature, const Position &pos, bool isLogin) {
		if (!creature) {
			return;
		}

		auto tile = creature->getTile();
		if (!tile) {
			return;
		}

		if (client) {
			client->sendAddCreature(creature, pos, tile->getStackposOfCreature(static_self_cast<Player>(), creature), isLogin);
		}
	}
	void sendCreatureMove(std::shared_ptr<Creature> creature, const Position &newPos, int32_t newStackPos, const Position &oldPos, int32_t oldStackPos, bool teleport) {
		if (client) {
			client->sendMoveCreature(creature, newPos, newStackPos, oldPos, oldStackPos, teleport);
		}
	}
	void sendCreatureTurn(std::shared_ptr<Creature> creature) {
		if (!creature) {
			return;
		}

		auto tile = creature->getTile();
		if (!tile) {
			return;
		}

		if (client && canSeeCreature(creature)) {
			int32_t stackpos = tile->getStackposOfCreature(static_self_cast<Player>(), creature);
			if (stackpos != -1) {
				client->sendCreatureTurn(creature, stackpos);
			}
		}
	}
	void sendCreatureSay(std::shared_ptr<Creature> creature, SpeakClasses type, const std::string &text, const Position* pos = nullptr) {
		if (client) {
			client->sendCreatureSay(creature, type, text, pos);
		}
	}
	void sendCreatureReload(std::shared_ptr<Creature> creature) {
		if (client) {
			client->reloadCreature(creature);
		}
	}
	void sendPrivateMessage(std::shared_ptr<Player> speaker, SpeakClasses type, const std::string &text) {
		if (client) {
			client->sendPrivateMessage(speaker, type, text);
		}
	}
	void sendCreatureSquare(std::shared_ptr<Creature> creature, SquareColor_t color) {
		if (client) {
			client->sendCreatureSquare(creature, color);
		}
	}
	void sendCreatureChangeOutfit(std::shared_ptr<Creature> creature, const Outfit_t &outfit) {
		if (client) {
			client->sendCreatureOutfit(creature, outfit);
		}
	}
	void sendCreatureChangeVisible(std::shared_ptr<Creature> creature, bool visible) {
		if (!client || !creature) {
			return;
		}

		if (creature->getPlayer()) {
			if (visible) {
				client->sendCreatureOutfit(creature, creature->getCurrentOutfit());
			} else {
				static Outfit_t outfit;
				client->sendCreatureOutfit(creature, outfit);
			}
		} else if (canSeeInvisibility()) {
			client->sendCreatureOutfit(creature, creature->getCurrentOutfit());
		} else {
			auto tile = creature->getTile();
			if (!tile) {
				return;
			}
			int32_t stackpos = tile->getStackposOfCreature(static_self_cast<Player>(), creature);
			if (stackpos == -1) {
				return;
			}

			if (visible) {
				client->sendAddCreature(creature, creature->getPosition(), stackpos, false);
			} else {
				client->sendRemoveTileThing(creature->getPosition(), stackpos);
			}
		}
	}
	void sendCreatureLight(std::shared_ptr<Creature> creature) {
		if (client) {
			client->sendCreatureLight(creature);
		}
	}
	void sendCreatureIcon(std::shared_ptr<Creature> creature) {
		if (client && !client->oldProtocol) {
			client->sendCreatureIcon(creature);
		}
	}
	void sendUpdateCreature(std::shared_ptr<Creature> creature) const {
		if (client) {
			client->sendUpdateCreature(creature);
		}
	}
	void sendCreatureWalkthrough(std::shared_ptr<Creature> creature, bool walkthrough) {
		if (client) {
			client->sendCreatureWalkthrough(creature, walkthrough);
		}
	}
	void sendCreatureShield(std::shared_ptr<Creature> creature) {
		if (client) {
			client->sendCreatureShield(creature);
		}
	}
	void sendCreatureType(std::shared_ptr<Creature> creature, uint8_t creatureType) {
		if (client) {
			client->sendCreatureType(creature, creatureType);
		}
	}
	void sendSpellCooldown(uint16_t spellId, uint32_t time) {
		if (client) {
			client->sendSpellCooldown(spellId, time);
		}
	}
	void sendSpellGroupCooldown(SpellGroup_t groupId, uint32_t time) {
		if (client) {
			client->sendSpellGroupCooldown(groupId, time);
		}
	}
	void sendUseItemCooldown(uint32_t time) const {
		if (client) {
			client->sendUseItemCooldown(time);
		}
	}
	void reloadCreature(std::shared_ptr<Creature> creature) {
		if (client) {
			client->reloadCreature(creature);
		}
	}
	void sendModalWindow(const ModalWindow &modalWindow);

	// container
	void closeAllExternalContainers();
	void sendAddContainerItem(std::shared_ptr<Container> container, std::shared_ptr<Item> item);
	void sendUpdateContainerItem(std::shared_ptr<Container> container, uint16_t slot, std::shared_ptr<Item> newItem);
	void sendRemoveContainerItem(std::shared_ptr<Container> container, uint16_t slot);
	void sendContainer(uint8_t cid, std::shared_ptr<Container> container, bool hasParent, uint16_t firstIndex) {
		if (client) {
			client->sendContainer(cid, container, hasParent, firstIndex);
		}
	}

	// inventory
	void sendDepotItems(const ItemsTierCountList &itemMap, uint16_t count) const {
		if (client) {
			client->sendDepotItems(itemMap, count);
		}
	}
	void sendCloseDepotSearch() const {
		if (client) {
			client->sendCloseDepotSearch();
		}
	}
	void sendDepotSearchResultDetail(uint16_t itemId, uint8_t tier, uint32_t depotCount, const ItemVector &depotItems, uint32_t inboxCount, const ItemVector &inboxItems, uint32_t stashCount) const {
		if (client) {
			client->sendDepotSearchResultDetail(itemId, tier, depotCount, depotItems, inboxCount, inboxItems, stashCount);
		}
	}
	void sendCoinBalance() {
		if (client) {
			client->sendCoinBalance();
		}
	}
	void sendInventoryItem(Slots_t slot, std::shared_ptr<Item> item) {
		if (client) {
			client->sendInventoryItem(slot, item);
		}
	}
	void sendInventoryIds() {
		if (client) {
			client->sendInventoryIds();
		}
	}

	void openPlayerContainers();

	// Quickloot
	void sendLootContainers() {
		if (client) {
			client->sendLootContainers();
		}
	}

	void sendSingleSoundEffect(const Position &pos, SoundEffect_t id, SourceEffect_t source) {
		if (client) {
			client->sendSingleSoundEffect(pos, id, source);
		}
	}

	void sendDoubleSoundEffect(const Position &pos, SoundEffect_t mainSoundId, SourceEffect_t mainSource, SoundEffect_t secondarySoundId, SourceEffect_t secondarySource) {
		if (client) {
			client->sendDoubleSoundEffect(pos, mainSoundId, mainSource, secondarySoundId, secondarySource);
		}
	}

	SoundEffect_t getAttackSoundEffect() const;
	SoundEffect_t getHitSoundEffect() const;

	// event methods
	void onUpdateTileItem(std::shared_ptr<Tile> tile, const Position &pos, std::shared_ptr<Item> oldItem, const ItemType &oldType, std::shared_ptr<Item> newItem, const ItemType &newType) override;
	void onRemoveTileItem(std::shared_ptr<Tile> tile, const Position &pos, const ItemType &iType, std::shared_ptr<Item> item) override;

	void onCreatureAppear(std::shared_ptr<Creature> creature, bool isLogin) override;
	void onRemoveCreature(std::shared_ptr<Creature> creature, bool isLogout) override;
	void onCreatureMove(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &newTile, const Position &newPos, const std::shared_ptr<Tile> &oldTile, const Position &oldPos, bool teleport) override;

	void onEquipInventory();
	void onDeEquipInventory();

	void onAttackedCreatureDisappear(bool isLogout) override;
	void onFollowCreatureDisappear(bool isLogout) override;

	// container
	void onAddContainerItem(std::shared_ptr<Item> item);
	void onUpdateContainerItem(std::shared_ptr<Container> container, std::shared_ptr<Item> oldItem, std::shared_ptr<Item> newItem);
	void onRemoveContainerItem(std::shared_ptr<Container> container, std::shared_ptr<Item> item);

	void onCloseContainer(std::shared_ptr<Container> container);
	void onSendContainer(std::shared_ptr<Container> container);
	void autoCloseContainers(std::shared_ptr<Container> container);

	// inventory
	void onUpdateInventoryItem(std::shared_ptr<Item> oldItem, std::shared_ptr<Item> newItem);
	void onRemoveInventoryItem(std::shared_ptr<Item> item);

	void sendCancelMessage(const std::string &msg) const {
		if (client) {
			client->sendTextMessage(TextMessage(MESSAGE_FAILURE, msg));
		}
	}
	void sendCancelMessage(ReturnValue message) const;
	void sendCancelTarget() const {
		if (client) {
			client->sendCancelTarget();
		}
	}
	void sendCancelWalk() const {
		if (client) {
			client->sendCancelWalk();
		}
	}
	void sendChangeSpeed(std::shared_ptr<Creature> creature, uint16_t newSpeed) const {
		if (client) {
			client->sendChangeSpeed(creature, newSpeed);
		}
	}
	void sendCreatureHealth(std::shared_ptr<Creature> creature) const {
		if (client) {
			client->sendCreatureHealth(creature);
		}
	}
	void sendPartyCreatureUpdate(std::shared_ptr<Creature> creature) const {
		if (client) {
			client->sendPartyCreatureUpdate(creature);
		}
	}
	void sendPartyCreatureShield(std::shared_ptr<Creature> creature) const {
		if (client) {
			client->sendPartyCreatureShield(creature);
		}
	}
	void sendPartyCreatureSkull(std::shared_ptr<Creature> creature) const {
		if (client) {
			client->sendPartyCreatureSkull(creature);
		}
	}
	void sendPartyCreatureHealth(std::shared_ptr<Creature> creature, uint8_t healthPercent) const {
		if (client) {
			client->sendPartyCreatureHealth(creature, healthPercent);
		}
	}
	void sendPartyPlayerMana(std::shared_ptr<Player> player, uint8_t manaPercent) const {
		if (client) {
			client->sendPartyPlayerMana(player, manaPercent);
		}
	}
	void sendPartyCreatureShowStatus(std::shared_ptr<Creature> creature, bool showStatus) const {
		if (client) {
			client->sendPartyCreatureShowStatus(creature, showStatus);
		}
	}
	void sendPartyPlayerVocation(std::shared_ptr<Player> player) const {
		if (client) {
			client->sendPartyPlayerVocation(player);
		}
	}
	void sendPlayerVocation(std::shared_ptr<Player> player) const {
		if (client) {
			client->sendPlayerVocation(player);
		}
	}
	void sendDistanceShoot(const Position &from, const Position &to, uint16_t type) const {
		if (client) {
			client->sendDistanceShoot(from, to, type);
		}
	}
	void sendHouseWindow(std::shared_ptr<House> house, uint32_t listId) const;
	void sendCreatePrivateChannel(uint16_t channelId, const std::string &channelName) {
		if (client) {
			client->sendCreatePrivateChannel(channelId, channelName);
		}
	}
	void sendClosePrivate(uint16_t channelId);
	void sendIcons() {
		if (client) {
			client->sendIcons(getClientIcons());
		}
	}
	void sendClientCheck() const {
		if (client) {
			client->sendClientCheck();
		}
	}
	void sendGameNews() const {
		if (client) {
			client->sendGameNews();
		}
	}
	void sendMagicEffect(const Position &pos, uint16_t type) const {
		if (client) {
			client->sendMagicEffect(pos, type);
		}
	}
	void removeMagicEffect(const Position &pos, uint16_t type) const {
		if (client) {
			client->removeMagicEffect(pos, type);
		}
	}
	void sendPing();
	void sendPingBack() const {
		if (client) {
			client->sendPingBack();
		}
	}
	void sendStats();
	void sendBasicData() const {
		if (client) {
			client->sendBasicData();
		}
	}
	void sendBlessStatus() const {
		if (client) {
			client->sendBlessStatus();
		}
	}
	void sendSkills() const {
		if (client) {
			client->sendSkills();
		}
	}
	void sendTextMessage(MessageClasses mclass, const std::string &message) const {
		if (client) {
			client->sendTextMessage(TextMessage(mclass, message));
		}
	}
	void sendTextMessage(const TextMessage &message) const {
		if (client) {
			client->sendTextMessage(message);
		}
	}
	void sendReLoginWindow(uint8_t unfairFightReduction) const {
		if (client) {
			client->sendReLoginWindow(unfairFightReduction);
		}
	}
	void sendTextWindow(std::shared_ptr<Item> item, uint16_t maxlen, bool canWrite) const {
		if (client) {
			client->sendTextWindow(windowTextId, item, maxlen, canWrite);
		}
	}
	void sendToChannel(std::shared_ptr<Creature> creature, SpeakClasses type, const std::string &text, uint16_t channelId) const {
		if (client) {
			client->sendToChannel(creature, type, text, channelId);
		}
	}
	void sendShop(std::shared_ptr<Npc> npc) const {
		if (client) {
			client->sendShop(npc);
		}
	}
	void sendSaleItemList(const std::map<uint16_t, uint16_t> &inventoryMap) const;
	void sendCloseShop() const {
		if (client) {
			client->sendCloseShop();
		}
	}
	void sendMarketEnter(uint32_t depotId);
	void sendMarketLeave() {
		inMarket = false;
		if (client) {
			client->sendMarketLeave();
		}
	}
	void sendMarketBrowseItem(uint16_t itemId, const MarketOfferList &buyOffers, const MarketOfferList &sellOffers, uint8_t tier) const {
		if (client) {
			client->sendMarketBrowseItem(itemId, buyOffers, sellOffers, tier);
		}
	}
	void sendMarketBrowseOwnOffers(const MarketOfferList &buyOffers, const MarketOfferList &sellOffers) const {
		if (client) {
			client->sendMarketBrowseOwnOffers(buyOffers, sellOffers);
		}
	}
	void sendMarketBrowseOwnHistory(const HistoryMarketOfferList &buyOffers, const HistoryMarketOfferList &sellOffers) const {
		if (client) {
			client->sendMarketBrowseOwnHistory(buyOffers, sellOffers);
		}
	}
	void sendMarketDetail(uint16_t itemId, uint8_t tier) const {
		if (client) {
			client->sendMarketDetail(itemId, tier);
		}
	}
	void sendMarketAcceptOffer(const MarketOfferEx &offer) const {
		if (client) {
			client->sendMarketAcceptOffer(offer);
		}
	}
	void sendMarketCancelOffer(const MarketOfferEx &offer) const {
		if (client) {
			client->sendMarketCancelOffer(offer);
		}
	}
	void sendTradeItemRequest(const std::string &traderName, std::shared_ptr<Item> item, bool ack) const {
		if (client) {
			client->sendTradeItemRequest(traderName, item, ack);
		}
	}
	void sendTradeClose() const {
		if (client) {
			client->sendCloseTrade();
		}
	}
	void sendWorldLight(LightInfo lightInfo) {
		if (client) {
			client->sendWorldLight(lightInfo);
		}
	}
	void sendTibiaTime(int32_t time) {
		if (client) {
			client->sendTibiaTime(time);
		}
	}
	void sendChannelsDialog() {
		if (client) {
			client->sendChannelsDialog();
		}
	}
	void sendOpenPrivateChannel(const std::string &receiver) {
		if (client) {
			client->sendOpenPrivateChannel(receiver);
		}
	}
	void sendExperienceTracker(int64_t rawExp, int64_t finalExp) const {
		if (client) {
			client->sendExperienceTracker(rawExp, finalExp);
		}
	}
	void sendOutfitWindow() {
		if (client) {
			client->sendOutfitWindow();
		}
	}
	// Imbuements
	void onApplyImbuement(Imbuement* imbuement, std::shared_ptr<Item> item, uint8_t slot, bool protectionCharm);
	void onClearImbuement(std::shared_ptr<Item> item, uint8_t slot);
	void openImbuementWindow(std::shared_ptr<Item> item);
	void sendImbuementResult(const std::string message) {
		if (client) {
			client->sendImbuementResult(message);
		}
	}
	void closeImbuementWindow() const {
		if (client) {
			client->closeImbuementWindow();
		}
	}
	void sendPodiumWindow(std::shared_ptr<Item> podium, const Position &position, uint16_t itemId, uint8_t stackpos) {
		if (client) {
			client->sendPodiumWindow(podium, position, itemId, stackpos);
		}
	}
	void sendCloseContainer(uint8_t cid) {
		if (client) {
			client->sendCloseContainer(cid);
		}
	}

	void sendChannel(uint16_t channelId, const std::string &channelName, const UsersMap* channelUsers, const InvitedMap* invitedUsers) {
		if (client) {
			client->sendChannel(channelId, channelName, channelUsers, invitedUsers);
		}
	}
	void sendTutorial(uint8_t tutorialId) {
		if (client) {
			client->sendTutorial(tutorialId);
		}
	}
	void sendAddMarker(const Position &pos, uint8_t markType, const std::string &desc) {
		if (client) {
			client->sendAddMarker(pos, markType, desc);
		}
	}
	void sendItemInspection(uint16_t itemId, uint8_t itemCount, std::shared_ptr<Item> item, bool cyclopedia) {
		if (client) {
			client->sendItemInspection(itemId, itemCount, item, cyclopedia);
		}
	}
	void sendCyclopediaCharacterNoData(CyclopediaCharacterInfoType_t characterInfoType, uint8_t errorCode) {
		if (client) {
			client->sendCyclopediaCharacterNoData(characterInfoType, errorCode);
		}
	}
	void sendCyclopediaCharacterBaseInformation() {
		if (client) {
			client->sendCyclopediaCharacterBaseInformation();
		}
	}
	void sendCyclopediaCharacterGeneralStats() {
		if (client) {
			client->sendCyclopediaCharacterGeneralStats();
		}
	}
	void sendCyclopediaCharacterCombatStats() {
		if (client) {
			client->sendCyclopediaCharacterCombatStats();
		}
	}
	void sendCyclopediaCharacterRecentDeaths(uint16_t page, uint16_t pages, const std::vector<RecentDeathEntry> &entries) {
		if (client) {
			client->sendCyclopediaCharacterRecentDeaths(page, pages, entries);
		}
	}
	void sendCyclopediaCharacterRecentPvPKills(uint16_t page, uint16_t pages, const std::vector<RecentPvPKillEntry> &entries) {
		if (client) {
			client->sendCyclopediaCharacterRecentPvPKills(page, pages, entries);
		}
	}
	void sendCyclopediaCharacterAchievements(uint16_t secretsUnlocked, std::vector<std::pair<Achievement, uint32_t>> achievementsUnlocked);
	void sendCyclopediaCharacterItemSummary(const ItemsTierCountList &inventoryItems, const ItemsTierCountList &storeInboxItems, const StashItemList &supplyStashItems, const ItemsTierCountList &depotBoxItems, const ItemsTierCountList &inboxItems) {
		if (client) {
			client->sendCyclopediaCharacterItemSummary(inventoryItems, storeInboxItems, supplyStashItems, depotBoxItems, inboxItems);
		}
	}
	void sendCyclopediaCharacterOutfitsMounts() {
		if (client) {
			client->sendCyclopediaCharacterOutfitsMounts();
		}
	}
	void sendCyclopediaCharacterStoreSummary() {
		if (client) {
			client->sendCyclopediaCharacterStoreSummary();
		}
	}
	void sendCyclopediaCharacterInspection() {
		if (client) {
			client->sendCyclopediaCharacterInspection();
		}
	}
	void sendCyclopediaCharacterBadges() {
		if (client) {
			client->sendCyclopediaCharacterBadges();
		}
	}
	void sendCyclopediaCharacterTitles() {
		if (client) {
			client->sendCyclopediaCharacterTitles();
		}
	}
	void sendHighscoresNoData() {
		if (client) {
			client->sendHighscoresNoData();
		}
	}
	void sendHighscores(const std::vector<HighscoreCharacter> &characters, uint8_t categoryId, uint32_t vocationId, uint16_t page, uint16_t pages, uint32_t updateTimer) {
		if (client) {
			client->sendHighscores(characters, categoryId, vocationId, page, pages, updateTimer);
		}
	}
	void addAsyncOngoingTask(uint64_t flags) {
		asyncOngoingTasks |= flags;
	}
	bool hasAsyncOngoingTask(uint64_t flags) const {
		return (asyncOngoingTasks & flags);
	}
	void resetAsyncOngoingTask(uint64_t flags) {
		asyncOngoingTasks &= ~(flags);
	}
	void sendEnterWorld() {
		if (client) {
			client->sendEnterWorld();
		}
	}
	void sendFightModes() {
		if (client) {
			client->sendFightModes();
		}
	}
	void sendNetworkMessage(const NetworkMessage &message) {
		if (client) {
			client->writeToOutputBuffer(message);
		}
	}

	void receivePing() {
		lastPong = OTSYS_TIME();
	}

	void sendOpenStash(bool isNpc = false) {
		if (client && ((getLastDepotId() != -1) || isNpc)) {
			client->sendOpenStash();
		}
	}

	void sendTakeScreenshot(Screenshot_t screenshotType) {
		if (client) {
			client->sendTakeScreenshot(screenshotType);
		}
	}

	void onThink(uint32_t interval) override;

	void postAddNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> oldParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;
	void postRemoveNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> newParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;

	void setNextAction(int64_t time) {
		if (time > nextAction) {
			nextAction = time;
		}
	}
	bool canDoAction() const {
		return nextAction <= OTSYS_TIME();
	}

	void setNextPotionAction(int64_t time) {
		if (time > nextPotionAction) {
			nextPotionAction = time;
		}
	}
	bool canDoPotionAction() const {
		return nextPotionAction <= OTSYS_TIME();
	}

	void cancelPush();

	void setModuleDelay(uint8_t byteortype, int16_t delay) {
		moduleDelayMap[byteortype] = OTSYS_TIME() + delay;
	}

	bool canRunModule(uint8_t byteortype) {
		if (!moduleDelayMap[byteortype]) {
			return true;
		}
		return moduleDelayMap[byteortype] <= OTSYS_TIME();
	}

	uint32_t getNextActionTime() const;
	uint32_t getNextPotionActionTime() const;

	std::shared_ptr<Item> getWriteItem(uint32_t &windowTextId, uint16_t &maxWriteLen);
	void setWriteItem(std::shared_ptr<Item> item, uint16_t maxWriteLen = 0);

	std::shared_ptr<House> getEditHouse(uint32_t &windowTextId, uint32_t &listId);
	void setEditHouse(std::shared_ptr<House> house, uint32_t listId = 0);

	void learnInstantSpell(const std::string &spellName);
	void forgetInstantSpell(const std::string &spellName);
	bool hasLearnedInstantSpell(const std::string &spellName) const;

	void updateRegeneration();

	void setScheduledSaleUpdate(bool scheduled) {
		scheduledSaleUpdate = scheduled;
	}

	bool getScheduledSaleUpdate() {
		return scheduledSaleUpdate;
	}

	bool inPushEvent() {
		return inEventMovePush;
	}

	void pushEvent(bool b) {
		inEventMovePush = b;
	}

	bool walkExhausted() {
		if (hasCondition(CONDITION_PARALYZE)) {
			return lastWalking > OTSYS_TIME();
		}

		return false;
	}

	void setWalkExhaust(int64_t value) {
		lastWalking = OTSYS_TIME() + value;
	}

	const std::map<uint8_t, OpenContainer> &getOpenContainers() const {
		return openContainers;
	}

	uint16_t getBaseXpGain() const {
		return baseXpGain;
	}
	void setBaseXpGain(uint16_t value) {
		baseXpGain = std::min<uint16_t>(std::numeric_limits<uint16_t>::max(), value);
	}
	uint16_t getVoucherXpBoost() const {
		return voucherXpBoost;
	}
	void setVoucherXpBoost(uint16_t value) {
		voucherXpBoost = std::min<uint16_t>(std::numeric_limits<uint16_t>::max(), value);
	}
	uint16_t getGrindingXpBoost() const {
		return grindingXpBoost;
	}
	void setGrindingXpBoost(uint16_t value) {
		grindingXpBoost = std::min<uint16_t>(std::numeric_limits<uint16_t>::max(), value);
	}
	uint16_t getXpBoostPercent() const {
		return xpBoostPercent;
	}
	void setXpBoostPercent(uint16_t percent) {
		xpBoostPercent = percent;
	}
	uint16_t getStaminaXpBoost() const {
		return staminaXpBoost;
	}
	void setStaminaXpBoost(uint16_t value) {
		staminaXpBoost = std::min<uint16_t>(std::numeric_limits<uint16_t>::max(), value);
	}

	void setXpBoostTime(uint16_t timeLeft) {
		// only allow time boosts of 12 hours or less
		if (timeLeft > 12 * 3600) {
			xpBoostTime = 12 * 3600;
			return;
		}
		xpBoostTime = timeLeft;
	}

	uint16_t getXpBoostTime() {
		return xpBoostTime;
	}

	int32_t getIdleTime() const {
		return idleTime;
	}

	void setTraining(bool value);

	void addItemImbuementStats(const Imbuement* imbuement);
	void removeItemImbuementStats(const Imbuement* imbuement);
	void updateImbuementTrackerStats() const;

	bool isUIExhausted(uint32_t exhaustionTime = 250) const;
	void updateUIExhausted();

	bool isQuickLootListedItem(std::shared_ptr<Item> item) const {
		if (!item) {
			return false;
		}

		auto it = std::find(quickLootListItemIds.begin(), quickLootListItemIds.end(), item->getID());
		return it != quickLootListItemIds.end();
	}

	bool updateKillTracker(std::shared_ptr<Container> corpse, const std::string &playerName, const Outfit_t creatureOutfit) const {
		if (client) {
			client->sendKillTrackerUpdate(corpse, playerName, creatureOutfit);
			return true;
		}

		return false;
	}

	void updatePartyTrackerAnalyzer() const {
		if (client && m_party) {
			client->updatePartyTrackerAnalyzer(m_party);
		}
	}

	void sendLootStats(std::shared_ptr<Item> item, uint8_t count);
	void updateSupplyTracker(std::shared_ptr<Item> item);
	void updateImpactTracker(CombatType_t type, int32_t amount) const;

	void updateInputAnalyzer(CombatType_t type, int32_t amount, std::string target) {
		if (client) {
			client->sendUpdateInputAnalyzer(type, amount, target);
		}
	}

	void createLeaderTeamFinder(NetworkMessage &msg) {
		if (client) {
			client->createLeaderTeamFinder(msg);
		}
	}
	void sendLeaderTeamFinder(bool reset) {
		if (client) {
			client->sendLeaderTeamFinder(reset);
		}
	}
	void sendTeamFinderList() {
		if (client) {
			client->sendTeamFinderList();
		}
	}
	void sendCreatureHelpers(uint32_t creatureId, uint16_t helpers) {
		if (client) {
			client->sendCreatureHelpers(creatureId, helpers);
		}
	}

	void setItemCustomPrice(uint16_t itemId, uint64_t price) {
		itemPriceMap[itemId] = price;
	}
	uint32_t getCharmPoints() {
		return charmPoints;
	}
	void setCharmPoints(uint32_t points) {
		charmPoints = points;
	}
	bool hasCharmExpansion() {
		return charmExpansion;
	}
	void setCharmExpansion(bool onOff) {
		charmExpansion = onOff;
	}
	void setUsedRunesBit(int32_t bit) {
		UsedRunesBit = bit;
	}
	int32_t getUsedRunesBit() {
		return UsedRunesBit;
	}
	void setUnlockedRunesBit(int32_t bit) {
		UnlockedRunesBit = bit;
	}
	int32_t getUnlockedRunesBit() {
		return UnlockedRunesBit;
	}
	void setImmuneCleanse(ConditionType_t conditiontype) {
		cleanseCondition.first = conditiontype;
		cleanseCondition.second = OTSYS_TIME() + 10000;
	}
	bool isImmuneCleanse(ConditionType_t conditiontype) {
		uint64_t timenow = OTSYS_TIME();
		if ((cleanseCondition.first == conditiontype)
		    && (timenow <= cleanseCondition.second)) {
			return true;
		}
		return false;
	}
	void setImmuneFear();
	bool isImmuneFear() const;
	uint16_t parseRacebyCharm(charmRune_t charmId, bool set, uint16_t newRaceid) {
		uint16_t raceid = 0;
		switch (charmId) {
			case CHARM_WOUND:
				if (set) {
					charmRuneWound = newRaceid;
				} else {
					raceid = charmRuneWound;
				}
				break;
			case CHARM_ENFLAME:
				if (set) {
					charmRuneEnflame = newRaceid;
				} else {
					raceid = charmRuneEnflame;
				}
				break;
			case CHARM_POISON:
				if (set) {
					charmRunePoison = newRaceid;
				} else {
					raceid = charmRunePoison;
				}
				break;
			case CHARM_FREEZE:
				if (set) {
					charmRuneFreeze = newRaceid;
				} else {
					raceid = charmRuneFreeze;
				}
				break;
			case CHARM_ZAP:
				if (set) {
					charmRuneZap = newRaceid;
				} else {
					raceid = charmRuneZap;
				}
				break;
			case CHARM_CURSE:
				if (set) {
					charmRuneCurse = newRaceid;
				} else {
					raceid = charmRuneCurse;
				}
				break;
			case CHARM_CRIPPLE:
				if (set) {
					charmRuneCripple = newRaceid;
				} else {
					raceid = charmRuneCripple;
				}
				break;
			case CHARM_PARRY:
				if (set) {
					charmRuneParry = newRaceid;
				} else {
					raceid = charmRuneParry;
				}
				break;
			case CHARM_DODGE:
				if (set) {
					charmRuneDodge = newRaceid;
				} else {
					raceid = charmRuneDodge;
				}
				break;
			case CHARM_ADRENALINE:
				if (set) {
					charmRuneAdrenaline = newRaceid;
				} else {
					raceid = charmRuneAdrenaline;
				}
				break;
			case CHARM_NUMB:
				if (set) {
					charmRuneNumb = newRaceid;
				} else {
					raceid = charmRuneNumb;
				}
				break;
			case CHARM_CLEANSE:
				if (set) {
					charmRuneCleanse = newRaceid;
				} else {
					raceid = charmRuneCleanse;
				}
				break;
			case CHARM_BLESS:
				if (set) {
					charmRuneBless = newRaceid;
				} else {
					raceid = charmRuneBless;
				}
				break;
			case CHARM_SCAVENGE:
				if (set) {
					charmRuneScavenge = newRaceid;
				} else {
					raceid = charmRuneScavenge;
				}
				break;
			case CHARM_GUT:
				if (set) {
					charmRuneGut = newRaceid;
				} else {
					raceid = charmRuneGut;
				}
				break;
			case CHARM_LOW:
				if (set) {
					charmRuneLowBlow = newRaceid;
				} else {
					raceid = charmRuneLowBlow;
				}
				break;
			case CHARM_DIVINE:
				if (set) {
					charmRuneDivine = newRaceid;
				} else {
					raceid = charmRuneDivine;
				}
				break;
			case CHARM_VAMP:
				if (set) {
					charmRuneVamp = newRaceid;
				} else {
					raceid = charmRuneVamp;
				}
				break;
			case CHARM_VOID:
				if (set) {
					charmRuneVoid = newRaceid;
				} else {
					raceid = charmRuneVoid;
				}
				break;
			default:
				raceid = 0;
				break;
		}
		return raceid;
	}

	uint64_t getItemCustomPrice(uint16_t itemId, bool buyPrice = false) const;
	uint16_t getFreeBackpackSlots() const;

	bool canAutoWalk(const Position &toPosition, const std::function<void()> &function, uint32_t delay = 500);

	void sendMessageDialog(const std::string &message) const {
		if (client) {
			client->sendMessageDialog(message);
		}
	}

	// Account
	bool setAccount(uint32_t accountId);
	uint8_t getAccountType() const;
	uint32_t getAccountId() const;
	std::shared_ptr<Account> getAccount() const;

	// Prey system
	void initializePrey();
	void removePreySlotById(PreySlot_t slotid);

	void sendPreyData() const {
		if (client) {
			for (const std::unique_ptr<PreySlot> &slot : preys) {
				client->sendPreyData(slot);
			}

			client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards());
		}
	}

	void sendPreyTimeLeft(const std::unique_ptr<PreySlot> &slot) const {
		if (g_configManager().getBoolean(PREY_ENABLED, __FUNCTION__) && client) {
			client->sendPreyTimeLeft(slot);
		}
	}

	void reloadPreySlot(PreySlot_t slotid) {
		if (g_configManager().getBoolean(PREY_ENABLED, __FUNCTION__) && client) {
			client->sendPreyData(getPreySlotById(slotid));
			client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints());
		}
	}

	const std::unique_ptr<PreySlot> &getPreySlotById(PreySlot_t slotid) {
		if (auto it = std::find_if(preys.begin(), preys.end(), [slotid](const std::unique_ptr<PreySlot> &preyIt) {
				return preyIt->id == slotid;
			});
		    it != preys.end()) {
			return *it;
		}

		return PreySlotNull;
	}

	bool setPreySlotClass(std::unique_ptr<PreySlot> &slot) {
		if (getPreySlotById(slot->id)) {
			return false;
		}

		preys.emplace_back(std::move(slot));
		return true;
	}

	bool usePreyCards(uint16_t amount) {
		if (preyCards < amount) {
			return false;
		}

		preyCards -= amount;
		if (client) {
			client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints());
		}
		return true;
	}

	void addPreyCards(uint64_t amount) {
		preyCards += amount;
		if (client) {
			client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints());
		}
	}

	uint64_t getPreyCards() const {
		return preyCards;
	}

	uint32_t getPreyRerollPrice() const {
		return getLevel() * g_configManager().getNumber(PREY_REROLL_PRICE_LEVEL, __FUNCTION__);
	}

	std::vector<uint16_t> getPreyBlackList() const {
		std::vector<uint16_t> rt;
		for (const std::unique_ptr<PreySlot> &slot : preys) {
			if (slot) {
				if (slot->isOccupied()) {
					rt.push_back(slot->selectedRaceId);
				}
				for (uint16_t raceId : slot->raceIdList) {
					rt.push_back(raceId);
				}
			}
		}

		return rt;
	}

	const std::unique_ptr<PreySlot> &getPreyWithMonster(uint16_t raceId) const {
		if (!g_configManager().getBoolean(PREY_ENABLED, __FUNCTION__)) {
			return PreySlotNull;
		}

		if (auto it = std::find_if(preys.begin(), preys.end(), [raceId](const std::unique_ptr<PreySlot> &it) {
				return it->selectedRaceId == raceId;
			});
		    it != preys.end()) {
			return *it;
		}

		return PreySlotNull;
	}

	// Task hunting system
	void initializeTaskHunting();
	bool isCreatureUnlockedOnTaskHunting(const std::shared_ptr<MonsterType> mtype) const;

	bool setTaskHuntingSlotClass(std::unique_ptr<TaskHuntingSlot> &slot) {
		if (getTaskHuntingSlotById(slot->id)) {
			return false;
		}

		taskHunting.emplace_back(std::move(slot));
		return true;
	}

	void reloadTaskSlot(PreySlot_t slotid) {
		if (g_configManager().getBoolean(TASK_HUNTING_ENABLED, __FUNCTION__) && client) {
			client->sendTaskHuntingData(getTaskHuntingSlotById(slotid));
			client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints());
		}
	}

	const std::unique_ptr<TaskHuntingSlot> &getTaskHuntingSlotById(PreySlot_t slotid) {
		if (auto it = std::find_if(taskHunting.begin(), taskHunting.end(), [slotid](const std::unique_ptr<TaskHuntingSlot> &itTask) {
				return itTask->id == slotid;
			});
		    it != taskHunting.end()) {
			return *it;
		}

		return TaskHuntingSlotNull;
	}

	std::vector<uint16_t> getTaskHuntingBlackList() const {
		std::vector<uint16_t> rt;

		std::for_each(taskHunting.begin(), taskHunting.end(), [&rt](const std::unique_ptr<TaskHuntingSlot> &slot) {
			if (slot->isOccupied()) {
				rt.push_back(slot->selectedRaceId);
			} else {
				std::for_each(slot->raceIdList.begin(), slot->raceIdList.end(), [&rt](uint16_t raceId) {
					rt.push_back(raceId);
				});
			}
		});

		return rt;
	}

	void sendTaskHuntingData() const {
		if (client) {
			client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints());
			for (const std::unique_ptr<TaskHuntingSlot> &slot : taskHunting) {
				if (slot) {
					client->sendTaskHuntingData(slot);
				}
			}
		}
	}

	void addTaskHuntingPoints(uint64_t amount) {
		taskHuntingPoints += amount;
		if (client) {
			client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints());
		}
	}

	bool useTaskHuntingPoints(uint64_t amount) {
		if (taskHuntingPoints < amount) {
			return false;
		}

		taskHuntingPoints -= amount;
		if (client) {
			client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints());
		}
		return true;
	}

	uint64_t getTaskHuntingPoints() const {
		return taskHuntingPoints;
	}

	uint32_t getTaskHuntingRerollPrice() const {
		return getLevel() * g_configManager().getNumber(TASK_HUNTING_REROLL_PRICE_LEVEL, __FUNCTION__);
	}

	const std::unique_ptr<TaskHuntingSlot> &getTaskHuntingWithCreature(uint16_t raceId) const {
		if (!g_configManager().getBoolean(TASK_HUNTING_ENABLED, __FUNCTION__)) {
			return TaskHuntingSlotNull;
		}

		if (auto it = std::find_if(taskHunting.begin(), taskHunting.end(), [raceId](const std::unique_ptr<TaskHuntingSlot> &itTask) {
				return itTask->selectedRaceId == raceId;
			});
		    it != taskHunting.end()) {
			return *it;
		}

		return TaskHuntingSlotNull;
	}

	uint32_t getLoyaltyPoints() const {
		return loyaltyPoints;
	}

	void setLoyaltyBonus(uint16_t bonus) {
		loyaltyBonusPercent = bonus;
		sendSkills();
	}
	void setLoyaltyTitle(std::string title) {
		loyaltyTitle = title;
	}
	std::string getLoyaltyTitle() const {
		return loyaltyTitle;
	}
	uint16_t getLoyaltyBonus() const {
		return loyaltyBonusPercent;
	}

	// Depot search system
	void requestDepotItems();
	void requestDepotSearchItem(uint16_t itemId, uint8_t tier);
	void retrieveAllItemsFromDepotSearch(uint16_t itemId, uint8_t tier, bool isDepot);
	void openContainerFromDepotSearch(const Position &pos);
	std::shared_ptr<Item> getItemFromDepotSearch(uint16_t itemId, const Position &pos);

	std::pair<std::vector<std::shared_ptr<Item>>, std::map<uint16_t, std::map<uint8_t, uint32_t>>> requestLockerItems(std::shared_ptr<DepotLocker> depotLocker, bool sendToClient = false, uint8_t tier = 0) const;

	/**
	This function returns a pair of an array of items and a 16-bit integer from a DepotLocker instance, a 8-bit byte and a 16-bit integer.
	@param depotLocker The instance of DepotLocker from which to retrieve items.
	@param tier The 8-bit byte that specifies the level of the tier to search.
	@param itemId The 16-bit integer that specifies the ID of the item to search for.
	@return A pair of an array of items and a 16-bit integer, where the array of items is filled with all items from the
	locker with the specified id and the 16-bit integer is the total items found.
	*/
	std::pair<std::vector<std::shared_ptr<Item>>, uint16_t> getLockerItemsAndCountById(
		const std::shared_ptr<DepotLocker> &depotLocker,
		uint8_t tier,
		uint16_t itemId
	);

	bool saySpell(
		SpeakClasses type,
		const std::string &text,
		bool ghostMode,
		Spectators* spectatorsPtr = nullptr,
		const Position* pos = nullptr
	);

	// Forge system
	void forgeFuseItems(ForgeAction_t actionType, uint16_t firstItemid, uint8_t tier, uint16_t secondItemId, bool success, bool reduceTierLoss, bool convergence, uint8_t bonus, uint8_t coreCount);
	void forgeTransferItemTier(ForgeAction_t actionType, uint16_t donorItemId, uint8_t tier, uint16_t receiveItemId, bool convergence);
	void forgeResourceConversion(ForgeAction_t actionType);
	void forgeHistory(uint8_t page) const;

	void sendOpenForge() const {
		if (client) {
			client->sendOpenForge();
		}
	}
	void sendForgeError(ReturnValue returnValue) const {
		if (client) {
			client->sendForgeError(returnValue);
		}
	}
	void sendForgeResult(ForgeAction_t actionType, uint16_t leftItemId, uint8_t leftTier, uint16_t rightItemId, uint8_t rightTier, bool success, uint8_t bonus, uint8_t coreCount, bool convergence) const {
		if (client) {
			client->sendForgeResult(actionType, leftItemId, leftTier, rightItemId, rightTier, success, bonus, coreCount, convergence);
		}
	}
	void sendForgeHistory(uint8_t page) const {
		if (client) {
			client->sendForgeHistory(page);
		}
	}
	void closeForgeWindow() const {
		if (client) {
			client->closeForgeWindow();
		}
	}

	void setForgeDusts(uint64_t amount) {
		forgeDusts = amount;
		if (client) {
			client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints(), getForgeDusts());
		}
	}
	void addForgeDusts(uint64_t amount) {
		forgeDusts += amount;
		if (client) {
			client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints(), getForgeDusts());
		}
	}
	void removeForgeDusts(uint64_t amount) {
		forgeDusts = std::max<uint64_t>(0, forgeDusts - amount);
		if (client) {
			client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints(), getForgeDusts());
		}
	}
	uint64_t getForgeDusts() const {
		return forgeDusts;
	}

	void addForgeDustLevel(uint64_t amount) {
		forgeDustLevel += amount;
		if (client) {
			client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints(), getForgeDusts());
		}
	}
	void removeForgeDustLevel(uint64_t amount) {
		forgeDustLevel = std::max<uint64_t>(0, forgeDustLevel - amount);
		if (client) {
			client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints(), getForgeDusts());
		}
	}
	uint64_t getForgeDustLevel() const {
		return forgeDustLevel;
	}

	std::vector<ForgeHistory> &getForgeHistory() {
		return forgeHistoryVector;
	}

	void setForgeHistory(const ForgeHistory &history) {
		forgeHistoryVector.push_back(history);
	}

	void registerForgeHistoryDescription(ForgeHistory history);

	void setBossPoints(uint32_t amount) {
		bossPoints = amount;
	}
	void addBossPoints(uint32_t amount) {
		bossPoints += amount;
	}
	void removeBossPoints(uint32_t amount) {
		bossPoints = std::max<uint32_t>(0, bossPoints - amount);
	}
	uint32_t getBossPoints() const {
		return bossPoints;
	}
	void sendBosstiaryCooldownTimer() const {
		if (client) {
			client->sendBosstiaryCooldownTimer();
		}
	}

	void setSlotBossId(uint8_t slotId, uint32_t bossId) {
		if (slotId == 1) {
			bossIdSlotOne = bossId;
		} else {
			bossIdSlotTwo = bossId;
		}
		if (client) {
			client->parseSendBosstiarySlots();
		}
	}
	uint32_t getSlotBossId(uint8_t slotId) const {
		if (slotId == 1) {
			return bossIdSlotOne;
		} else {
			return bossIdSlotTwo;
		}
	}

	void addRemoveTime() {
		bossRemoveTimes = bossRemoveTimes + 1;
	}
	void setRemoveBossTime(uint8_t newRemoveTimes) {
		bossRemoveTimes = newRemoveTimes;
	}
	uint8_t getRemoveTimes() const {
		return bossRemoveTimes;
	}

	void sendMonsterPodiumWindow(std::shared_ptr<Item> podium, const Position &position, uint16_t itemId, uint8_t stackpos) const {
		if (client) {
			client->sendMonsterPodiumWindow(podium, position, itemId, stackpos);
		}
	}

	void sendBosstiaryEntryChanged(uint32_t bossid) {
		if (client) {
			client->sendBosstiaryEntryChanged(bossid);
		}
	}

	void sendInventoryImbuements(const std::map<Slots_t, std::shared_ptr<Item>> items) const {
		if (client) {
			client->sendInventoryImbuements(items);
		}
	}

	/*******************************************************************************
	 * Hazard system
	 ******************************************************************************/
	// Parser
	void parseAttackRecvHazardSystem(CombatDamage &damage, std::shared_ptr<Monster> monster);
	void parseAttackDealtHazardSystem(CombatDamage &damage, std::shared_ptr<Monster> monster);
	// Points increase:
	void setHazardSystemPoints(int32_t amount);
	// Points get:
	uint16_t getHazardSystemPoints() const {
		int32_t points = 0;
		points = getStorageValue(STORAGEVALUE_HAZARDCOUNT);
		if (points <= 0) {
			return 0;
		}
		return static_cast<uint16_t>(std::max<int32_t>(0, std::min<int32_t>(0xFFFF, points)));
	}

	/*******************************************************************************/

	// Concoction system
	void updateConcoction(uint16_t itemId, uint16_t timeLeft) {
		if (timeLeft == 0) {
			activeConcoctions.erase(itemId);
		} else {
			activeConcoctions[itemId] = timeLeft;
		}
	}
	std::map<uint16_t, uint16_t> getActiveConcoctions() const {
		return activeConcoctions;
	}
	bool isConcoctionActive(Concoction_t concotion) const {
		uint16_t itemId = static_cast<uint16_t>(concotion);
		if (!activeConcoctions.contains(itemId)) {
			return false;
		}
		auto timeLeft = activeConcoctions.at(itemId);
		return timeLeft > 0;
	}

	bool checkAutoLoot(bool isBoss) const {
		if (!g_configManager().getBoolean(AUTOLOOT, __FUNCTION__)) {
			return false;
		}
		if (g_configManager().getBoolean(VIP_SYSTEM_ENABLED, __FUNCTION__) && g_configManager().getBoolean(VIP_AUTOLOOT_VIP_ONLY, __FUNCTION__) && !isVip()) {
			return false;
		}

		auto featureKV = kv()->scoped("features")->get("autoloot");
		auto value = featureKV.has_value() ? featureKV->getNumber() : 0;
		if (value == 2) {
			return true;
		} else if (value == 1) {
			return !isBoss;
		}
		return false;
	}

	QuickLootFilter_t getQuickLootFilter() const {
		return quickLootFilter;
	}

	// Get specific inventory item from itemid
	std::vector<std::shared_ptr<Item>> getInventoryItemsFromId(uint16_t itemId, bool ignore = true) const;

	// this get all player store inbox items and return as ItemsTierCountList
	ItemsTierCountList getStoreInboxItemsId() const;
	// this get all player depot chest items and return as ItemsTierCountList
	ItemsTierCountList getDepotChestItemsId() const;
	// this get all player depot inbox items and return as ItemsTierCountList
	ItemsTierCountList getDepotInboxItemsId() const;

	// This get all player inventory items
	std::vector<std::shared_ptr<Item>> getAllInventoryItems(bool ignoreEquiped = false, bool ignoreItemWithTier = false) const;

	// This get all players slot items
	phmap::flat_hash_map<uint8_t, std::shared_ptr<Item>> getAllSlotItems() const;

	// Gets the equipped items with augment by type
	std::vector<std::shared_ptr<Item>> getEquippedAugmentItemsByType(Augment_t augmentType) const;

	// Gets the equipped items with augment
	std::vector<std::shared_ptr<Item>> getEquippedAugmentItems() const;

	/**
	 * @brief Get the equipped items of the player->
	 * @details This function returns a vector containing the items currently equipped by the player
	 * @return A vector of pointers to the equipped items.
	 */
	std::vector<std::shared_ptr<Item>> getEquippedItems() const;

	// Player wheel interface
	std::unique_ptr<PlayerWheel> &wheel();
	const std::unique_ptr<PlayerWheel> &wheel() const;

	// Player achievement interface
	std::unique_ptr<PlayerAchievement> &achiev();
	const std::unique_ptr<PlayerAchievement> &achiev() const;

	// Player badge interface
	std::unique_ptr<PlayerBadge> &badge();
	const std::unique_ptr<PlayerBadge> &badge() const;

	// Player title interface
	std::unique_ptr<PlayerTitle> &title();
	const std::unique_ptr<PlayerTitle> &title() const;

	// Player summary interface
	std::unique_ptr<PlayerCyclopedia> &cyclopedia();
	const std::unique_ptr<PlayerCyclopedia> &cyclopedia() const;

	// Player vip interface
	std::unique_ptr<PlayerVIP> &vip();
	const std::unique_ptr<PlayerVIP> &vip() const;

	void sendLootMessage(const std::string &message) const;

	std::shared_ptr<Container> getLootPouch();

	bool hasPermittedConditionInPZ() const;

	std::shared_ptr<Container> getStoreInbox() const;

	bool canSpeakWithHireling(uint8_t speechbubble);

	uint16_t getPlayerVocationEnum() const;

private:
	friend class PlayerLock;
	std::mutex mutex;

	static uint32_t playerFirstID;
	static uint32_t playerLastID;

	std::vector<std::shared_ptr<Condition>> getMuteConditions() const;

	void checkTradeState(std::shared_ptr<Item> item);
	bool hasCapacity(std::shared_ptr<Item> item, uint32_t count) const;

	void checkLootContainers(std::shared_ptr<Container> item);

	void gainExperience(uint64_t exp, std::shared_ptr<Creature> target);
	void addExperience(std::shared_ptr<Creature> target, uint64_t exp, bool sendText = false);
	void removeExperience(uint64_t exp, bool sendText = false);

	void updateInventoryWeight();
	/**
	 * @brief Starts checking the imbuements in the item so that the time decay is performed
	 * Registers the player in an unordered_map in game.h so that the function can be initialized by the task
	 */
	void updateInventoryImbuement();

	void setNextWalkActionTask(std::shared_ptr<Task> task);
	void setNextWalkTask(std::shared_ptr<Task> task);
	void setNextActionTask(std::shared_ptr<Task> task, bool resetIdleTime = true);
	void setNextActionPushTask(std::shared_ptr<Task> task);
	void setNextPotionActionTask(std::shared_ptr<Task> task);

	void death(std::shared_ptr<Creature> lastHitCreature) override;
	bool spawn();
	void despawn();
	bool dropCorpse(std::shared_ptr<Creature> lastHitCreature, std::shared_ptr<Creature> mostDamageCreature, bool lastHitUnjustified, bool mostDamageUnjustified) override;
	std::shared_ptr<Item> getCorpse(std::shared_ptr<Creature> lastHitCreature, std::shared_ptr<Creature> mostDamageCreature) override;

	// cylinder implementations
	ReturnValue queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, std::shared_ptr<Creature> actor = nullptr) override;
	ReturnValue queryMaxCount(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t &maxQueryCount, uint32_t flags) override;
	ReturnValue queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, std::shared_ptr<Creature> actor = nullptr) override;
	std::shared_ptr<Cylinder> queryDestination(int32_t &index, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item>* destItem, uint32_t &flags) override;

	void addThing(std::shared_ptr<Thing>) override { }
	void addThing(int32_t index, std::shared_ptr<Thing> thing) override;

	void updateThing(std::shared_ptr<Thing> thing, uint16_t itemId, uint32_t count) override;
	void replaceThing(uint32_t index, std::shared_ptr<Thing> thing) override;

	void removeThing(std::shared_ptr<Thing> thing, uint32_t count) override;

	int32_t getThingIndex(std::shared_ptr<Thing> thing) const override;
	size_t getFirstIndex() const override;
	size_t getLastIndex() const override;
	uint32_t getItemTypeCount(uint16_t itemId, int32_t subType = -1) const override;
	void stashContainer(StashContainerList itemDict);
	ItemsTierCountList getInventoryItemsId(bool ignoreStoreInbox = false) const;

	// This function is a override function of base class
	std::map<uint32_t, uint32_t> &getAllItemTypeCount(std::map<uint32_t, uint32_t> &countMap) const override;
	// Function from player class with correct type sizes (uint16_t)
	std::map<uint16_t, uint16_t> &getAllSaleItemIdAndCount(std::map<uint16_t, uint16_t> &countMap) const;
	void getAllItemTypeCountAndSubtype(std::map<uint32_t, uint32_t> &countMap) const;
	std::shared_ptr<Item> getForgeItemFromId(uint16_t itemId, uint8_t tier);
	std::shared_ptr<Thing> getThing(size_t index) const override;

	void internalAddThing(std::shared_ptr<Thing> thing) override;
	void internalAddThing(uint32_t index, std::shared_ptr<Thing> thing) override;

	void addHuntingTaskKill(const std::shared_ptr<MonsterType> &mType);
	void addBestiaryKill(const std::shared_ptr<MonsterType> &mType);
	void addBosstiaryKill(const std::shared_ptr<MonsterType> &mType);

	phmap::flat_hash_set<uint32_t> attackedSet;

	std::map<uint8_t, OpenContainer> openContainers;
	std::map<uint32_t, std::shared_ptr<DepotLocker>> depotLockerMap;
	std::map<uint32_t, std::shared_ptr<DepotChest>> depotChests;
	std::map<uint8_t, int64_t> moduleDelayMap;
	std::map<uint32_t, int32_t> storageMap;
	std::map<uint16_t, uint64_t> itemPriceMap;

	std::map<uint8_t, uint16_t> maxValuePerSkill = {
		{ SKILL_LIFE_LEECH_CHANCE, 100 },
		{ SKILL_MANA_LEECH_CHANCE, 100 },
		{ SKILL_CRITICAL_HIT_CHANCE, 100 * g_configManager().getNumber(CRITICALCHANCE, "std::map::maxValuePerSkill") }
	};

	std::map<uint64_t, std::shared_ptr<Reward>> rewardMap;

	std::map<ObjectCategory_t, std::pair<std::shared_ptr<Container>, std::shared_ptr<Container>>> m_managedContainers;
	std::vector<ForgeHistory> forgeHistoryVector;

	std::vector<uint16_t> quickLootListItemIds;

	std::vector<OutfitEntry> outfits;
	std::vector<FamiliarEntry> familiars;

	std::vector<std::unique_ptr<PreySlot>> preys;
	std::vector<std::unique_ptr<TaskHuntingSlot>> taskHunting;

	GuildWarVector guildWarVector;

	std::vector<std::shared_ptr<Party>> invitePartyList;
	std::vector<uint32_t> modalWindows;
	std::vector<std::string> learnedInstantSpellList;
	// TODO: This variable is only temporarily used when logging in, get rid of it somehow.
	std::vector<std::shared_ptr<Condition>> storedConditionList;

	std::unordered_set<std::shared_ptr<MonsterType>> m_bestiaryMonsterTracker;
	std::unordered_set<std::shared_ptr<MonsterType>> m_bosstiaryMonsterTracker;

	std::string name;
	std::string guildNick;
	std::string loyaltyTitle;

	Skill skills[SKILL_LAST + 1];
	LightInfo itemsLight;
	Position loginPosition;
	Position lastWalkthroughPosition;

	time_t lastLoginSaved = 0;
	time_t lastLogout = 0;

	uint64_t experience = 0;
	uint64_t manaSpent = 0;
	uint64_t lastAttack = 0;
	std::unordered_map<uint8_t, uint64_t> lastConditionTime;
	uint64_t lastAggressiveAction = 0;
	uint64_t bankBalance = 0;
	uint64_t lastQuestlogUpdate = 0;
	uint64_t preyCards = 0;
	uint64_t taskHuntingPoints = 0;
	uint32_t bossPoints = 0;
	uint32_t bossIdSlotOne = 0;
	uint32_t bossIdSlotTwo = 0;
	uint8_t bossRemoveTimes = 1;
	uint64_t forgeDusts = 0;
	uint64_t forgeDustLevel = 0;
	int64_t lastFailedFollow = 0;
	int64_t skullTicks = 0;
	int64_t lastWalkthroughAttempt = 0;
	int64_t lastToggleMount = 0;
	int64_t lastUIInteraction = 0;
	int64_t lastPing;
	int64_t lastPong;
	int64_t nextAction = 0;
	int64_t nextPotionAction = 0;
	int64_t lastQuickLootNotification = 0;
	int64_t lastWalking = 0;
	uint64_t asyncOngoingTasks = 0;

	std::vector<Kill> unjustifiedKills;

	std::shared_ptr<BedItem> bedItem = nullptr;
	std::shared_ptr<Guild> guild = nullptr;
	GuildRank_ptr guildRank;
	std::shared_ptr<Group> group = nullptr;
	std::shared_ptr<Inbox> inbox;
	std::shared_ptr<Item> imbuingItem = nullptr;
	std::shared_ptr<Item> tradeItem = nullptr;
	std::shared_ptr<Item> inventory[CONST_SLOT_LAST + 1] = {};
	std::shared_ptr<Item> writeItem = nullptr;
	std::shared_ptr<House> editHouse = nullptr;
	std::shared_ptr<Npc> shopOwner = nullptr;
	std::shared_ptr<Party> m_party = nullptr;
	std::shared_ptr<Player> tradePartner = nullptr;
	ProtocolGame_ptr client;
	std::shared_ptr<Task> walkTask;
	std::shared_ptr<Town> town;
	std::shared_ptr<Vocation> vocation = nullptr;
	std::shared_ptr<RewardChest> rewardChest = nullptr;

	uint32_t inventoryWeight = 0;
	uint32_t capacity = 40000;
	uint32_t bonusCapacity = 0;

	std::bitset<CombatType_t::COMBAT_COUNT> m_damageImmunities;
	std::bitset<ConditionType_t::CONDITION_COUNT> m_conditionImmunities;
	std::bitset<ConditionType_t::CONDITION_COUNT> m_conditionSuppressions;

	uint32_t level = 1;
	uint32_t magLevel = 0;
	uint32_t actionTaskEvent = 0;
	uint32_t actionTaskEventPush = 0;
	uint32_t actionPotionTaskEvent = 0;
	uint32_t nextStepEvent = 0;
	uint32_t walkTaskEvent = 0;
	uint32_t MessageBufferTicks = 0;
	uint32_t lastIP = 0;
	uint32_t guid = 0;
	uint32_t loyaltyPoints = 0;
	uint8_t isDailyReward = DAILY_REWARD_NOTCOLLECTED;
	uint32_t windowTextId = 0;
	uint32_t editListId = 0;
	uint32_t manaMax = 0;
	int32_t varSkills[SKILL_LAST + 1] = {};
	int32_t varStats[STAT_LAST + 1] = {};
	int32_t shopCallback = -1;
	int32_t MessageBufferCount = 0;
	int32_t bloodHitCount = 0;
	int32_t shieldBlockCount = 0;
	int8_t offlineTrainingSkill = SKILL_NONE;
	int32_t offlineTrainingTime = 0;
	int32_t idleTime = 0;
	int32_t m_deathTime = 0;
	uint32_t coinBalance = 0;
	uint32_t coinTransferableBalance = 0;
	uint16_t xpBoostTime = 0;
	uint8_t randomMount = 0;

	uint16_t lastStatsTrainingTime = 0;
	uint16_t staminaMinutes = 2520;
	std::vector<uint8_t> blessings = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
	uint16_t maxWriteLen = 0;
	uint16_t baseXpGain = 100;
	uint16_t voucherXpBoost = 0;
	uint16_t grindingXpBoost = 0;
	uint16_t xpBoostPercent = 0;
	uint16_t staminaXpBoost = 100;
	int16_t lastDepotId = -1;
	StashItemList stashItems; // [ItemID] = amount
	uint32_t movedItems = 0;

	// Depot search system
	bool depotSearch = false;
	std::pair<uint16_t, uint8_t> depotSearchOnItem;

	// Bestiary
	bool charmExpansion = false;
	uint16_t charmRuneWound = 0;
	uint16_t charmRuneEnflame = 0;
	uint16_t charmRunePoison = 0;
	uint16_t charmRuneFreeze = 0;
	uint16_t charmRuneZap = 0;
	uint16_t charmRuneCurse = 0;
	uint16_t charmRuneCripple = 0;
	uint16_t charmRuneParry = 0;
	uint16_t charmRuneDodge = 0;
	uint16_t charmRuneAdrenaline = 0;
	uint16_t charmRuneNumb = 0;
	uint16_t charmRuneCleanse = 0;
	uint16_t charmRuneBless = 0;
	uint16_t charmRuneScavenge = 0;
	uint16_t charmRuneGut = 0;
	uint16_t charmRuneLowBlow = 0;
	uint16_t charmRuneDivine = 0;
	uint16_t charmRuneVamp = 0;
	uint16_t charmRuneVoid = 0;
	uint32_t charmPoints = 0;
	int32_t UsedRunesBit = 0;
	int32_t UnlockedRunesBit = 0;
	std::pair<ConditionType_t, uint64_t> cleanseCondition = { CONDITION_NONE, 0 };

	std::pair<ConditionType_t, uint64_t> m_fearCondition = { CONDITION_NONE, 0 };

	uint8_t soul = 0;
	uint8_t levelPercent = 0;
	uint16_t loyaltyBonusPercent = 0;
	double_t magLevelPercent = 0;

	PlayerSex_t sex = PLAYERSEX_FEMALE;
	OperatingSystem_t operatingSystem = CLIENTOS_NONE;
	BlockType_t lastAttackBlockType = BLOCK_NONE;
	TradeState_t tradeState = TRADE_NONE;
	FightMode_t fightMode = FIGHTMODE_ATTACK;
	Faction_t faction = FACTION_PLAYER;
	QuickLootFilter_t quickLootFilter;
	PlayerPronoun_t pronoun = PLAYERPRONOUN_THEY;

	bool chaseMode = false;
	bool secureMode = true;
	bool inMarket = false;
	bool wasMounted = false;
	bool ghostMode = false;
	bool pzLocked = false;
	bool isConnecting = false;
	bool addAttackSkillPoint = false;
	bool inventoryAbilities[CONST_SLOT_LAST + 1] = {};
	bool quickLootFallbackToMainContainer = false;
	bool logged = false;
	bool scheduledSaleUpdate = false;
	bool inEventMovePush = false;
	bool supplyStash = false; // Menu option 'stow, stow container ...'
	bool marketMenu = false; // Menu option 'show in market'
	bool exerciseTraining = false;
	bool moved = false;
	bool dead = false;
	bool imbuementTrackerWindowOpen = false;

	// Hazard system
	int64_t lastHazardSystemCriticalHit = 0;
	bool reloadHazardSystemPointsCounter = true;
	// Hazard end

	// Concoctions
	// [ConcoctionID] = time
	std::map<uint16_t, uint16_t> activeConcoctions;

	int32_t specializedMagicLevel[COMBAT_COUNT] = { 0 };
	int32_t cleavePercent = 0;
	std::map<uint8_t, int32_t> perfectShot;
	int32_t magicShieldCapacityFlat = 0;
	int32_t magicShieldCapacityPercent = 0;

	int32_t marriageSpouse = -1;

	void updateItemsLight(bool internal = false);
	uint16_t getStepSpeed() const override {
		return std::max<uint16_t>(PLAYER_MIN_SPEED, std::min<uint16_t>(PLAYER_MAX_SPEED, getSpeed()));
	}
	void updateBaseSpeed() {
		if (baseSpeed >= PLAYER_MAX_SPEED) {
			return;
		}

		if (!hasFlag(PlayerFlags_t::SetMaxSpeed)) {
			baseSpeed = static_cast<uint16_t>(vocation->getBaseSpeed() + (level - 1));
		} else {
			baseSpeed = PLAYER_MAX_SPEED;
		}
	}

	bool isPromoted() const;

	bool onFistAttackSpeed = g_configManager().getBoolean(TOGGLE_ATTACK_SPEED_ONFIST, "Player.hpp::onFistAttackSpeed");
	uint32_t MAX_ATTACK_SPEED = g_configManager().getNumber(MAX_SPEED_ATTACKONFIST, "Player.hpp::MAX_ATTACK_SPEED");

	uint32_t getAttackSpeed() const {
		if (onFistAttackSpeed) {
			uint32_t baseAttackSpeed = vocation->getAttackSpeed();
			uint32_t skillLevel = getSkillLevel(SKILL_FIST);
			uint32_t attackSpeed = baseAttackSpeed - (skillLevel * g_configManager().getNumber(MULTIPLIER_ATTACKONFIST, __FUNCTION__));

			if (attackSpeed < MAX_ATTACK_SPEED) {
				attackSpeed = MAX_ATTACK_SPEED;
			}

			return static_cast<uint32_t>(attackSpeed);
		} else {
			return vocation->getAttackSpeed();
		}
	}

	static double_t getPercentLevel(uint64_t count, uint64_t nextLevelCount);
	double getLostPercent() const;
	uint64_t getLostExperience() const override {
		return skillLoss ? static_cast<uint64_t>(experience * getLostPercent()) : 0;
	}

	bool isSuppress(ConditionType_t conditionType, bool attackerPlayer) const override;
	void addConditionSuppression(const std::array<ConditionType_t, ConditionType_t::CONDITION_COUNT> &addConditions);

	uint16_t getLookCorpse() const override;
	void getPathSearchParams(const std::shared_ptr<Creature> &creature, FindPathParams &fpp) override;

	void setDead(bool isDead) {
		dead = isDead;
	}
	bool isDead() const {
		return dead;
	}

	void triggerMomentum();
	void clearCooldowns();
	void triggerTranscendance();

	friend class Game;
	friend class SaveManager;
	friend class Npc;
	friend class PlayerFunctions;
	friend class NetworkMessageFunctions;
	friend class Map;
	friend class Actions;
	friend class IOLoginData;
	friend class ProtocolGame;
	friend class MoveEvent;
	friend class BedItem;
	friend class PlayerWheel;
	friend class IOLoginDataLoad;
	friend class IOLoginDataSave;
	friend class PlayerAchievement;
	friend class PlayerBadge;
	friend class PlayerCyclopedia;
	friend class PlayerTitle;
	friend class PlayerVIP;

	std::unique_ptr<PlayerWheel> m_wheelPlayer;
	std::unique_ptr<PlayerAchievement> m_playerAchievement;
	std::unique_ptr<PlayerBadge> m_playerBadge;
	std::unique_ptr<PlayerCyclopedia> m_playerCyclopedia;
	std::unique_ptr<PlayerTitle> m_playerTitle;
	std::unique_ptr<PlayerVIP> m_playerVIP;

	std::mutex quickLootMutex;

	std::shared_ptr<Account> account;
	bool online = true;

	bool hasQuiverEquipped() const;

	bool hasWeaponDistanceEquipped() const;

	std::shared_ptr<Item> getQuiverAmmoOfType(const ItemType &it) const;

	std::array<double_t, COMBAT_COUNT> getFinalDamageReduction() const;
	void calculateDamageReductionFromEquipedItems(std::array<double_t, COMBAT_COUNT> &combatReductionMap) const;
	void calculateDamageReductionFromItem(std::array<double_t, COMBAT_COUNT> &combatReductionMap, std::shared_ptr<Item> item) const;
	void updateDamageReductionFromItemImbuement(std::array<double_t, COMBAT_COUNT> &combatReductionMap, std::shared_ptr<Item> item, uint16_t combatTypeIndex) const;
	void updateDamageReductionFromItemAbility(std::array<double_t, COMBAT_COUNT> &combatReductionMap, std::shared_ptr<Item> item, uint16_t combatTypeIndex) const;
	double_t calculateDamageReduction(double_t currentTotal, int16_t resistance) const;

	void removeEmptyRewards();
	bool hasOtherRewardContainerOpen(const std::shared_ptr<Container> container) const;

	void checkAndShowBlessingMessage();

	void setMarriageSpouse(const int32_t spouseId) {
		marriageSpouse = spouseId;
	}
	int32_t getMarriageSpouse() const {
		return marriageSpouse;
	}
};
