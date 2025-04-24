/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/creature.hpp"
#include "enums/forge_conversion.hpp"
#include "game/bank/bank.hpp"
#include "grouping/guild.hpp"
#include "items/cylinder.hpp"
#include "game/movement/position.hpp"
#include "creatures/creatures_definitions.hpp"

// Player components are decoupled to reduce complexity. Keeping includes here aids in clarity and maintainability, but avoid including player.hpp in headers to prevent circular dependencies.
#include "creatures/players/animus_mastery/animus_mastery.hpp"
#include "creatures/players/components/player_achievement.hpp"
#include "creatures/players/components/player_badge.hpp"
#include "creatures/players/components/player_cyclopedia.hpp"
#include "creatures/players/components/player_title.hpp"
#include "creatures/players/components/wheel/player_wheel.hpp"
#include "creatures/players/components/player_vip.hpp"
#include "creatures/players/components/wheel/wheel_gems.hpp"
#include "creatures/players/components/player_attached_effects.hpp"

class House;
class NetworkMessage;
class Weapon;
class ProtocolGame;
class Party;
class Task;
class Guild;
class Imbuement;
class PreySlot;
class TaskHuntingSlot;
class Spell;
class Spectators;
class Account;
class RewardChest;
class Cylinder;
class Town;
class Reward;
class DepotChest;
class DepotLocker;
class Inbox;
class Vocation;
class Container;
class KV;
class BedItem;
class Npc;

struct ModalWindow;
struct Achievement;
struct VIPGroup;
struct Mount;
struct Wing;
struct Effect;
struct Shader;
struct Aura;
struct OutfitEntry;
struct Outfit;
struct FamiliarEntry;
struct Familiar;
struct Group;
struct Outfit_t;
struct TextMessage;
struct HighscoreCharacter;

enum class PlayerIcon : uint8_t;
enum class IconBakragore : uint8_t;
enum class HouseAuctionType : uint8_t;
enum class BidErrorMessage : uint8_t;
enum class TransferErrorMessage : uint8_t;
enum class AcceptTransferErrorMessage : uint8_t;
enum ObjectCategory_t : uint8_t;
enum PreySlot_t : uint8_t;
enum SpeakClasses : uint8_t;
enum ChannelEvent_t : uint8_t;
enum SquareColor_t : uint8_t;
enum Resource_t : uint8_t;

using GuildWarVector = std::vector<uint32_t>;
using StashContainerList = std::vector<std::pair<std::shared_ptr<Item>, uint32_t>>;
using ItemVector = std::vector<std::shared_ptr<Item>>;
using UsersMap = std::map<uint32_t, std::shared_ptr<Player>>;
using InvitedMap = std::map<uint32_t, std::shared_ptr<Player>>;
using HouseMap = std::map<uint32_t, std::shared_ptr<House>>;

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

	explicit Player(std::shared_ptr<ProtocolGame> p);
	~Player() override;

	// non-copyable
	Player(const Player &) = delete;
	Player &operator=(const Player &) = delete;

	std::shared_ptr<Player> getPlayer() override {
		return static_self_cast<Player>();
	}
	std::shared_ptr<const Player> getPlayer() const override {
		return static_self_cast<Player>();
	}

	static std::shared_ptr<Task> createPlayerTask(uint32_t delay, std::function<void(void)> f, const std::string &context);

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
	bool hasMount(const std::shared_ptr<Mount> &mount) const;
	bool hasAnyMount() const;
	uint8_t getRandomMountId() const;
	void dismount();

	uint16_t getDodgeChance() const;

	uint8_t isRandomMounted() const;
	void setRandomMount(uint8_t isMountRandomized);

	void sendFYIBox(const std::string &message) const;

	void BestiarysendCharms() const;
	void addBestiaryKillCount(uint16_t raceid, uint32_t amount);
	uint32_t getBestiaryKillCount(uint16_t raceid) const;

	void setGUID(uint32_t newGuid);
	uint32_t getGUID() const;
	bool canSeeInvisibility() const override;

	void setDailyReward(uint8_t reward);

	void removeList() override;
	void addList() override;
	void removePlayer(bool displayEffect, bool forced = true);

	static uint64_t getExpForLevel(const uint32_t level);

	uint16_t getStaminaMinutes() const;

	void sendItemsPrice() const;

	void sendForgingData() const;

	bool addOfflineTrainingTries(skills_t skill, uint64_t tries);

	void addOfflineTrainingTime(int32_t addTime);
	void removeOfflineTrainingTime(int32_t removeTime);
	int32_t getOfflineTrainingTime() const;

	int8_t getOfflineTrainingSkill() const;
	void setOfflineTrainingSkill(int8_t skill);

	uint64_t getBankBalance() const override;
	void setBankBalance(uint64_t balance) override;

	[[nodiscard]] std::shared_ptr<Guild> getGuild() const;
	void setGuild(const std::shared_ptr<Guild> &guild);

	[[nodiscard]] GuildRank_ptr getGuildRank() const;
	void setGuildRank(GuildRank_ptr newGuildRank);

	bool isGuildMate(const std::shared_ptr<Player> &player) const;

	[[nodiscard]] const std::string &getGuildNick() const;
	void setGuildNick(std::string nick);

	bool isInWar(const std::shared_ptr<Player> &player) const;
	bool isInWarList(uint32_t guild_id) const;

	void setLastWalkthroughAttempt(int64_t walkthroughAttempt);
	void setLastWalkthroughPosition(Position walkthroughPosition);

	std::shared_ptr<Inbox> getInbox() const;

	std::unordered_set<PlayerIcon> getClientIcons();

	const GuildWarVector &getGuildWarVector() const {
		return guildWarVector;
	}

	const std::unordered_set<std::shared_ptr<MonsterType>> &getCyclopediaMonsterTrackerSet(bool isBoss) const;

	void addMonsterToCyclopediaTrackerList(const std::shared_ptr<MonsterType> &mtype, bool isBoss, bool reloadClient = false);

	void removeMonsterFromCyclopediaTrackerList(const std::shared_ptr<MonsterType> &mtype, bool isBoss, bool reloadClient = false);

	void sendBestiaryEntryChanged(uint16_t raceid) const;

	void refreshCyclopediaMonsterTracker(bool isBoss = false) const {
		refreshCyclopediaMonsterTracker(getCyclopediaMonsterTrackerSet(isBoss), isBoss);
	}

	void refreshCyclopediaMonsterTracker(const std::unordered_set<std::shared_ptr<MonsterType>> &trackerList, bool isBoss) const;

	bool isBossOnBosstiaryTracker(const std::shared_ptr<MonsterType> &monsterType) const;

	std::shared_ptr<Vocation> getVocation() const;

	OperatingSystem_t getOperatingSystem() const;
	void setOperatingSystem(OperatingSystem_t clientos);

	bool isOldProtocol() const;

	uint32_t getProtocolVersion() const;

	bool hasSecureMode() const;

	void setParty(std::shared_ptr<Party> newParty);
	std::shared_ptr<Party> getParty() const;

	int32_t getCleavePercent(bool useCharges = false) const;

	void setCleavePercent(int32_t value);

	int32_t getPerfectShotDamage(uint8_t range, bool useCharges = false) const;

	void setPerfectShotDamage(uint8_t range, int32_t damage);

	int32_t getSpecializedMagicLevel(CombatType_t combat, bool useCharges = false) const;

	void setSpecializedMagicLevel(CombatType_t combat, int32_t value);

	int32_t getMagicShieldCapacityFlat(bool useCharges = false) const;

	void setMagicShieldCapacityFlat(int32_t value);

	int32_t getMagicShieldCapacityPercent(bool useCharges = false) const;

	void setMagicShieldCapacityPercent(int32_t value);

	double_t getReflectPercent(CombatType_t combat, bool useCharges = false) const override;

	int32_t getReflectFlat(CombatType_t combat, bool useCharges = false) const override;

	PartyShields_t getPartyShield(const std::shared_ptr<Player> &player);
	bool isInviting(const std::shared_ptr<Player> &player) const;
	bool isPartner(const std::shared_ptr<Player> &player) const;
	void sendPlayerPartyIcons(const std::shared_ptr<Player> &player) const;
	bool addPartyInvitation(const std::shared_ptr<Party> &party);
	void removePartyInvitation(const std::shared_ptr<Party> &party);
	void clearPartyInvitations();

	void sendUnjustifiedPoints() const;

	GuildEmblems_t getGuildEmblem(const std::shared_ptr<Player> &player) const;

	uint64_t getSpentMana() const;

	bool hasFlag(PlayerFlags_t flag) const;

	void setFlag(PlayerFlags_t flag) const;

	void removeFlag(PlayerFlags_t flag) const;

	std::shared_ptr<BedItem> getBedItem();
	void setBedItem(std::shared_ptr<BedItem> b);

	bool hasImbuingItem() const;
	void setImbuingItem(const std::shared_ptr<Item> &item);

	void addBlessing(uint8_t index, uint8_t count);
	void removeBlessing(uint8_t index, uint8_t count);
	bool hasBlessing(uint8_t index) const;

	uint8_t getBlessingCount(uint8_t index, bool storeCount = false) const;
	std::string getBlessingsName() const;

	bool isOffline() const {
		return (getID() == 0);
	}
	void disconnect() const;

	uint32_t getIP() const;

	bool isDisconnected() const {
		return getIP() == 0;
	}

	void addContainer(uint8_t cid, const std::shared_ptr<Container> &container);
	void closeContainer(uint8_t cid);
	void setContainerIndex(uint8_t cid, uint16_t index);

	std::shared_ptr<Container> getContainerByID(uint8_t cid);
	int8_t getContainerID(const std::shared_ptr<Container> &container) const;
	uint16_t getContainerIndex(uint8_t cid) const;

	bool canOpenCorpse(uint32_t ownerId) const;

	void addStorageValue(uint32_t key, int32_t value, bool isLogin = false);
	int32_t getStorageValue(uint32_t key) const;

	int32_t getStorageValueByName(const std::string &storageName) const;
	void addStorageValueByName(const std::string &storageName, int32_t value, bool isLogin = false);

	std::shared_ptr<KV> kv() const;

	void genReservedStorageRange();

	void setGroup(std::shared_ptr<Group> newGroup) {
		group = std::move(newGroup);
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
	void setSpecialMenuAvailable(bool supplyStashBool, bool marketMenuBool, bool depotSearchBool);
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
	bool isSupplyStashMenuAvailable() const {
		return supplyStash;
	}
	bool isMarketMenuAvailable() const {
		return marketMenu;
	}
	bool isExerciseTraining() const {
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
	void setLevel(uint32_t newLevel) {
		level = newLevel;
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

	bool isVip() const;

	void setTibiaCoins(int32_t v);
	void setTransferableTibiaCoins(int32_t v);

	uint16_t getHelpers() const;

	bool setVocation(uint16_t vocId);
	uint16_t getVocationId() const;

	PlayerSex_t getSex() const {
		return sex;
	}
	PlayerPronoun_t getPronoun() const {
		return pronoun;
	}
	std::string getObjectPronoun() const;
	std::string getSubjectPronoun() const;
	std::string getPossessivePronoun() const;
	std::string getReflexivePronoun() const;
	std::string getSubjectVerb(bool past = false) const;
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
	const Position &getTemplePosition() const;
	std::shared_ptr<Town> getTown() const;
	void setTown(const std::shared_ptr<Town> &newTown);

	void clearModalWindows();
	bool hasModalWindowOpen(uint32_t modalWindowId) const;
	void onModalWindowHandled(uint32_t modalWindowId);

	bool isPushable() override;
	uint32_t isMuted() const;
	void addMessageBuffer();
	void removeMessageBuffer();

	bool removeItemOfType(uint16_t itemId, uint32_t itemAmount, int32_t subType, bool ignoreEquipped = false) const;
	/**
	 * @param itemAmount is uint32_t because stash item is uint32_t max
	 */
	bool hasItemCountById(uint16_t itemId, uint32_t itemCount, bool checkStash) const;
	/**
	 * @param itemAmount is uint32_t because stash item is uint32_t max
	 */
	bool removeItemCountById(uint16_t itemId, uint32_t itemAmount, bool removeFromStash = true);

	void addItemOnStash(uint16_t itemId, uint32_t amount);
	uint32_t getStashItemCount(uint16_t itemId) const;
	bool withdrawItem(uint16_t itemId, uint32_t amount);
	StashItemList getStashItems() const;

	uint32_t getBaseCapacity() const;

	uint32_t getCapacity() const;

	uint32_t getBonusCapacity() const;

	uint32_t getFreeCapacity() const;

	int32_t getMaxHealth() const override;
	uint32_t getMaxMana() const override;

	std::shared_ptr<Item> getInventoryItem(Slots_t slot) const;

	bool isItemAbilityEnabled(Slots_t slot) const;
	void setItemAbility(Slots_t slot, bool enabled);

	void setVarSkill(skills_t skill, int32_t modifier);

	void setVarStats(stats_t stat, int32_t modifier);
	int32_t getDefaultStats(stats_t stat) const;

	void addConditionSuppressions(const std::array<ConditionType_t, ConditionType_t::CONDITION_COUNT> &addCondition);
	void removeConditionSuppressions();

	std::shared_ptr<Reward> getReward(uint64_t rewardId, bool autoCreate);
	void removeReward(uint64_t rewardId);
	void getRewardList(std::vector<uint64_t> &rewards) const;
	std::shared_ptr<RewardChest> getRewardChest();

	std::vector<std::shared_ptr<Item>> getRewardsFromContainer(const std::shared_ptr<Container> &container) const;

	std::shared_ptr<DepotChest> getDepotChest(uint32_t depotId, bool autoCreate);
	std::shared_ptr<DepotLocker> getDepotLocker(uint32_t depotId);
	void onReceiveMail();
	bool isNearDepotBox();

	std::shared_ptr<Container> refreshManagedContainer(ObjectCategory_t category, const std::shared_ptr<Container> &container, bool isLootContainer, bool loading = false);
	std::shared_ptr<Container> getManagedContainer(ObjectCategory_t category, bool isLootContainer) const;
	void setMainBackpackUnassigned(const std::shared_ptr<Container> &container);

	bool canSee(const Position &pos) override;
	bool canSeeCreature(const std::shared_ptr<Creature> &creature) const override;

	bool canWalkthrough(const std::shared_ptr<Creature> &creature);
	bool canWalkthroughEx(const std::shared_ptr<Creature> &creature) const;

	RaceType_t getRace() const override;

	uint64_t getMoney() const;
	std::pair<uint64_t, uint64_t> getForgeSliversAndCores() const;

	// safe-trade functions
	void setTradeState(TradeState_t state);
	TradeState_t getTradeState() const;
	std::shared_ptr<Item> getTradeItem();

	// shop functions
	void setShopOwner(std::shared_ptr<Npc> owner);

	std::shared_ptr<Npc> getShopOwner() const;

	// follow functions
	bool setFollowCreature(const std::shared_ptr<Creature> &creature) override;
	void goToFollowCreature() override;

	// follow events
	void onFollowCreature(const std::shared_ptr<Creature> &) override;

	// walk events
	void onWalk(Direction &dir) override;
	void onWalkAborted() override;
	void onWalkComplete() override;

	void stopWalk();
	bool openShopWindow(const std::shared_ptr<Npc> &npc, const std::vector<ShopBlock> &shopItems = {});
	bool closeShopWindow();
	bool updateSaleShopList(const std::shared_ptr<Item> &item);
	void updateSaleShopList();
	void updateState();
	bool hasShopItemForSale(uint16_t itemId, uint8_t subType) const;

	void setChaseMode(bool mode);
	void setFightMode(FightMode_t mode);
	void setSecureMode(bool mode);

	Faction_t getFaction() const override;

	void setFaction(Faction_t factionId);
	// combat functions
	bool setAttackedCreature(const std::shared_ptr<Creature> &creature) override;
	bool isImmune(CombatType_t type) const override;
	bool isImmune(ConditionType_t type) const override;
	bool hasShield() const;
	bool isAttackable() const override;
	static bool lastHitIsPlayer(const std::shared_ptr<Creature> &lastHitCreature);

	// stash functions
	bool addItemFromStash(uint16_t itemId, uint32_t itemCount);
	void stowItem(const std::shared_ptr<Item> &item, uint32_t count, bool allItems);

	ReturnValue addItemBatchToPaginedContainer(
		const std::shared_ptr<Container> &container,
		uint16_t itemId,
		uint32_t totalCount,
		uint32_t &actuallyAdded,
		uint32_t flags = 0,
		uint8_t tier = 0
	);

	ReturnValue removeItem(const std::shared_ptr<Item> &item, uint32_t count = 0);

	void changeHealth(int32_t healthChange, bool sendHealthChange = true) override;
	void changeMana(int32_t manaChange) override;
	void changeSoul(int32_t soulChange);

	bool isPzLocked() const;
	BlockType_t blockHit(const std::shared_ptr<Creature> &attacker, const CombatType_t &combatType, int32_t &damage, bool checkDefense = false, bool checkArmor = false, bool field = false) override;
	void doAttacking(uint32_t interval) override;
	bool hasExtraSwing() override;

	uint16_t getSkillLevel(skills_t skill) const;
	uint16_t getLoyaltySkill(skills_t skill) const;
	uint16_t getBaseSkill(uint8_t skill) const;
	double_t getSkillPercent(skills_t skill) const;

	bool getAddAttackSkill() const;

	BlockType_t getLastAttackBlockType() const;

	uint64_t getLastConditionTime(ConditionType_t type) const;

	void updateLastConditionTime(ConditionType_t type);

	bool checkLastConditionTimeWithin(ConditionType_t type, uint32_t interval) const;

	uint64_t getLastAttack() const;

	bool checkLastAttackWithin(uint32_t interval) const;

	void updateLastAttack();

	uint64_t getLastAggressiveAction() const;

	bool checkLastAggressiveActionWithin(uint32_t interval) const;

	void updateLastAggressiveAction();

	std::shared_ptr<Item> getWeapon(Slots_t slot, bool ignoreAmmo) const;
	std::shared_ptr<Item> getWeapon(bool ignoreAmmo = false) const;
	WeaponType_t getWeaponType() const;
	int32_t getWeaponSkill(const std::shared_ptr<Item> &item) const;
	void getShieldAndWeapon(std::shared_ptr<Item> &shield, std::shared_ptr<Item> &weapon) const;

	void drainHealth(const std::shared_ptr<Creature> &attacker, int32_t damage) override;
	void drainMana(const std::shared_ptr<Creature> &attacker, int32_t manaLoss) override;
	void addManaSpent(uint64_t amount);
	void addSkillAdvance(skills_t skill, uint64_t count);

	int32_t getArmor() const override;
	int32_t getDefense() const override;
	float getAttackFactor() const override;
	float getDefenseFactor() const override;
	float getMitigation() const override;

	void addInFightTicks(bool pzlock = false);

	uint64_t getGainedExperience(const std::shared_ptr<Creature> &attacker) const override;

	// combat event functions
	void onAddCondition(ConditionType_t type) override;
	void onAddCombatCondition(ConditionType_t type) override;
	void onEndCondition(ConditionType_t type) override;
	void onCombatRemoveCondition(const std::shared_ptr<Condition> &condition) override;
	void onAttackedCreature(const std::shared_ptr<Creature> &target) override;
	void onAttacked() override;
	void onAttackedCreatureDrainHealth(const std::shared_ptr<Creature> &target, int32_t points) override;
	void onTargetCreatureGainHealth(const std::shared_ptr<Creature> &target, int32_t points) override;
	bool onKilledPlayer(const std::shared_ptr<Player> &target, bool lastHit) override;
	bool onKilledMonster(const std::shared_ptr<Monster> &target) override;
	void onGainExperience(uint64_t gainExp, const std::shared_ptr<Creature> &target) override;
	void onGainSharedExperience(uint64_t gainExp, const std::shared_ptr<Creature> &target);
	void onAttackedCreatureBlockHit(const BlockType_t &blockType) override;
	void onBlockHit() override;
	void onTakeDamage(const std::shared_ptr<Creature> &attacker, int32_t damage) override;
	void onChangeZone(ZoneType_t zone) override;
	void onAttackedCreatureChangeZone(ZoneType_t zone) override;
	void onIdleStatus() override;
	void onPlacedCreature() override;

	LightInfo getCreatureLight() const override;

	Skulls_t getSkull() const override;
	Skulls_t getSkullClient(const std::shared_ptr<Creature> &creature) override;
	int64_t getSkullTicks() const;
	void setSkullTicks(int64_t ticks);

	bool hasAttacked(const std::shared_ptr<Player> &attacked) const;
	void addAttacked(const std::shared_ptr<Player> &attacked);
	void removeAttacked(const std::shared_ptr<Player> &attacked);
	void clearAttacked();
	void addUnjustifiedDead(const std::shared_ptr<Player> &attacked);
	void sendCreatureEmblem(const std::shared_ptr<Creature> &creature) const;
	void sendCreatureSkull(const std::shared_ptr<Creature> &creature) const;
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
	void setFamiliarLooktype(uint16_t familiarLooktype);

	bool canLogout();

	bool hasKilled(const std::shared_ptr<Player> &player) const;

	size_t getMaxDepotItems() const;

	// tile
	// send methods
	// tile
	// send methods
	void sendAddTileItem(const std::shared_ptr<Tile> &itemTile, const Position &pos, const std::shared_ptr<Item> &item);
	void sendUpdateTileItem(const std::shared_ptr<Tile> &updateTile, const Position &pos, const std::shared_ptr<Item> &item);
	void sendRemoveTileThing(const Position &pos, int32_t stackpos) const;
	void sendUpdateTileCreature(const std::shared_ptr<Creature> &creature);
	void sendUpdateTile(const std::shared_ptr<Tile> &updateTile, const Position &pos) const;

	void sendChannelMessage(const std::string &author, const std::string &text, SpeakClasses type, uint16_t channel) const;
	void sendChannelEvent(uint16_t channelId, const std::string &playerName, ChannelEvent_t channelEvent) const;
	void sendCreatureAppear(const std::shared_ptr<Creature> &creature, const Position &pos, bool isLogin);
	void sendCreatureMove(const std::shared_ptr<Creature> &creature, const Position &newPos, int32_t newStackPos, const Position &oldPos, int32_t oldStackPos, bool teleport) const;
	void sendCreatureTurn(const std::shared_ptr<Creature> &creature);
	void sendCreatureSay(const std::shared_ptr<Creature> &creature, SpeakClasses type, const std::string &text, const Position* pos = nullptr) const;
	void sendCreatureReload(const std::shared_ptr<Creature> &creature) const;
	void sendPrivateMessage(const std::shared_ptr<Player> &speaker, SpeakClasses type, const std::string &text) const;
	void sendCreatureSquare(const std::shared_ptr<Creature> &creature, SquareColor_t color) const;
	void sendCreatureChangeOutfit(const std::shared_ptr<Creature> &creature, const Outfit_t &outfit) const;
	void sendCreatureChangeVisible(const std::shared_ptr<Creature> &creature, bool visible);
	void sendCreatureLight(const std::shared_ptr<Creature> &creature) const;
	void sendCreatureIcon(const std::shared_ptr<Creature> &creature) const;
	void sendUpdateCreature(const std::shared_ptr<Creature> &creature) const;
	void sendCreatureWalkthrough(const std::shared_ptr<Creature> &creature, bool walkthrough) const;
	void sendCreatureShield(const std::shared_ptr<Creature> &creature) const;
	void sendCreatureType(const std::shared_ptr<Creature> &creature, uint8_t creatureType) const;
	void sendSpellCooldown(uint16_t spellId, uint32_t time) const;
	void sendSpellGroupCooldown(SpellGroup_t groupId, uint32_t time) const;
	void sendUseItemCooldown(uint32_t time) const;
	void reloadCreature(const std::shared_ptr<Creature> &creature) const;
	void sendModalWindow(const ModalWindow &modalWindow);

	// container
	void closeAllExternalContainers();
	// container
	void sendAddContainerItem(const std::shared_ptr<Container> &container, std::shared_ptr<Item> item);
	void sendUpdateContainerItem(const std::shared_ptr<Container> &container, uint16_t slot, const std::shared_ptr<Item> &newItem);
	void sendRemoveContainerItem(const std::shared_ptr<Container> &container, uint16_t slot);
	void sendContainer(uint8_t cid, const std::shared_ptr<Container> &container, bool hasParent, uint16_t firstIndex) const;

	// inventory
	void sendDepotItems(const ItemsTierCountList &itemMap, uint16_t count) const;
	void sendCloseDepotSearch() const;
	void sendDepotSearchResultDetail(uint16_t itemId, uint8_t tier, uint32_t depotCount, const ItemVector &depotItems, uint32_t inboxCount, const ItemVector &inboxItems, uint32_t stashCount) const;
	void sendCoinBalance() const;
	void sendInventoryItem(Slots_t slot, const std::shared_ptr<Item> &item) const;
	void sendInventoryIds() const;

	void openPlayerContainers();

	// Quickloot
	void sendLootContainers() const;

	void sendSingleSoundEffect(const Position &pos, SoundEffect_t id, SourceEffect_t source) const;

	void sendDoubleSoundEffect(const Position &pos, SoundEffect_t mainSoundId, SourceEffect_t mainSource, SoundEffect_t secondarySoundId, SourceEffect_t secondarySource) const;

	SoundEffect_t getAttackSoundEffect() const;
	SoundEffect_t getHitSoundEffect() const;

	// event methods
	void onUpdateTileItem(const std::shared_ptr<Tile> &tile, const Position &pos, const std::shared_ptr<Item> &oldItem, const ItemType &oldType, const std::shared_ptr<Item> &newItem, const ItemType &newType) override;
	void onRemoveTileItem(const std::shared_ptr<Tile> &tile, const Position &pos, const ItemType &iType, const std::shared_ptr<Item> &item) override;

	void onCreatureAppear(const std::shared_ptr<Creature> &creature, bool isLogin) override;
	void onRemoveCreature(const std::shared_ptr<Creature> &creature, bool isLogout) override;
	void onCreatureMove(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &newTile, const Position &newPos, const std::shared_ptr<Tile> &oldTile, const Position &oldPos, bool teleport) override;

	void onEquipInventory();
	void onDeEquipInventory();

	void onAttackedCreatureDisappear(bool isLogout) override;
	void onFollowCreatureDisappear(bool isLogout) override;

	// container
	// container
	void onAddContainerItem(const std::shared_ptr<Item> &item);
	void onUpdateContainerItem(const std::shared_ptr<Container> &container, const std::shared_ptr<Item> &oldItem, const std::shared_ptr<Item> &newItem);
	void onRemoveContainerItem(const std::shared_ptr<Container> &container, const std::shared_ptr<Item> &item);

	void onCloseContainer(const std::shared_ptr<Container> &container);
	void onSendContainer(const std::shared_ptr<Container> &container);
	// close container and its child containers
	void autoCloseContainers(const std::shared_ptr<Container> &container);

	// inventory
	// inventory
	void onUpdateInventoryItem(const std::shared_ptr<Item> &oldItem, const std::shared_ptr<Item> &newItem);
	void onRemoveInventoryItem(const std::shared_ptr<Item> &item);

	void sendCancelMessage(const std::string &msg) const;
	void sendCancelMessage(ReturnValue message) const;
	void sendCancelTarget() const;
	void sendCancelWalk() const;
	void sendChangeSpeed(const std::shared_ptr<Creature> &creature, uint16_t newSpeed) const;
	void sendCreatureHealth(const std::shared_ptr<Creature> &creature) const;
	void sendPartyCreatureUpdate(const std::shared_ptr<Creature> &creature) const;
	void sendPartyCreatureShield(const std::shared_ptr<Creature> &creature) const;
	void sendPartyCreatureSkull(const std::shared_ptr<Creature> &creature) const;
	void sendPartyCreatureHealth(const std::shared_ptr<Creature> &creature, uint8_t healthPercent) const;
	void sendPartyPlayerMana(const std::shared_ptr<Player> &player, uint8_t manaPercent) const;
	void sendPartyCreatureShowStatus(const std::shared_ptr<Creature> &creature, bool showStatus) const;
	void sendPartyPlayerVocation(const std::shared_ptr<Player> &player) const;
	void sendPlayerVocation(const std::shared_ptr<Player> &player) const;
	void sendDistanceShoot(const Position &from, const Position &to, uint16_t type) const;
	void sendHouseWindow(const std::shared_ptr<House> &house, uint32_t listId) const;
	void sendCreatePrivateChannel(uint16_t channelId, const std::string &channelName) const;
	void sendClosePrivate(uint16_t channelId);
	void sendIcons();
	void sendIconBakragore(IconBakragore icon) const;
	void removeBakragoreIcons();
	void removeBakragoreIcon(const IconBakragore icon);
	void sendClientCheck() const;
	void sendGameNews() const;
	void sendMagicEffect(const Position &pos, uint16_t type) const;
	void removeMagicEffect(const Position &pos, uint16_t type) const;
	void sendPing();
	void sendPingBack() const;
	void sendStats();
	void sendBasicData() const;
	void sendBlessStatus() const;
	void sendSkills() const;
	void sendTextMessage(MessageClasses mclass, const std::string &message) const;
	void sendTextMessage(const TextMessage &message) const;
	void sendReLoginWindow(uint8_t unfairFightReduction) const;
	void sendTextWindow(const std::shared_ptr<Item> &item, uint16_t maxlen, bool canWrite) const;
	void sendToChannel(const std::shared_ptr<Creature> &creature, SpeakClasses type, const std::string &text, uint16_t channelId) const;
	void sendShop(const std::shared_ptr<Npc> &npc) const;
	void sendSaleItemList(const std::map<uint16_t, uint16_t> &inventoryMap) const;
	void sendCloseShop() const;
	void sendMarketEnter(uint32_t depotId) const;
	void sendMarketLeave();
	void sendMarketBrowseItem(uint16_t itemId, const MarketOfferList &buyOffers, const MarketOfferList &sellOffers, uint8_t tier) const;
	void sendMarketBrowseOwnOffers(const MarketOfferList &buyOffers, const MarketOfferList &sellOffers) const;
	void sendMarketBrowseOwnHistory(const HistoryMarketOfferList &buyOffers, const HistoryMarketOfferList &sellOffers) const;
	void sendMarketDetail(uint16_t itemId, uint8_t tier) const;
	void sendMarketAcceptOffer(const MarketOfferEx &offer) const;
	void sendMarketCancelOffer(const MarketOfferEx &offer) const;
	void sendTradeItemRequest(const std::string &traderName, const std::shared_ptr<Item> &item, bool ack) const;
	void sendTradeClose() const;
	void sendWorldLight(LightInfo lightInfo) const;
	void sendTibiaTime(int32_t time) const;
	void sendChannelsDialog() const;
	void sendOpenPrivateChannel(const std::string &receiver) const;
	void sendExperienceTracker(int64_t rawExp, int64_t finalExp) const;
	void sendOutfitWindow() const;
	// House Auction
	BidErrorMessage canBidHouse(uint32_t houseId);
	TransferErrorMessage canTransferHouse(uint32_t houseId, uint32_t newOwnerGUID);
	AcceptTransferErrorMessage canAcceptTransferHouse(uint32_t houseId);
	void sendCyclopediaHouseList(const HouseMap &houses) const;
	void sendResourceBalance(Resource_t resourceType, uint64_t value) const;
	void sendHouseAuctionMessage(uint32_t houseId, HouseAuctionType type, uint8_t index, bool bidSuccess = false) const;
	// Imbuements
	void onApplyImbuement(const Imbuement* imbuement, const std::shared_ptr<Item> &item, uint8_t slot, bool protectionCharm);
	void onClearImbuement(const std::shared_ptr<Item> &item, uint8_t slot);
	void openImbuementWindow(const std::shared_ptr<Item> &item);
	void sendImbuementResult(const std::string &message) const;
	void closeImbuementWindow() const;
	void sendPodiumWindow(const std::shared_ptr<Item> &podium, const Position &position, uint16_t itemId, uint8_t stackpos) const;
	void sendCloseContainer(uint8_t cid) const;

	void sendChannel(uint16_t channelId, const std::string &channelName, const UsersMap* channelUsers, const InvitedMap* invitedUsers) const;
	void sendTutorial(uint8_t tutorialId) const;
	void sendAddMarker(const Position &pos, uint8_t markType, const std::string &desc) const;
	void sendItemInspection(uint16_t itemId, uint8_t itemCount, const std::shared_ptr<Item> &item, bool cyclopedia) const;
	void sendCyclopediaCharacterNoData(CyclopediaCharacterInfoType_t characterInfoType, uint8_t errorCode) const;
	void sendCyclopediaCharacterBaseInformation() const;
	void sendCyclopediaCharacterGeneralStats() const;
	void sendCyclopediaCharacterCombatStats() const;
	void sendCyclopediaCharacterRecentDeaths(uint16_t page, uint16_t pages, const std::vector<RecentDeathEntry> &entries) const;
	void sendCyclopediaCharacterRecentPvPKills(uint16_t page, uint16_t pages, const std::vector<RecentPvPKillEntry> &entries) const;
	void sendCyclopediaCharacterAchievements(uint16_t secretsUnlocked, const std::vector<std::pair<Achievement, uint32_t>> &achievementsUnlocked) const;
	void sendCyclopediaCharacterItemSummary(const ItemsTierCountList &inventoryItems, const ItemsTierCountList &storeInboxItems, const StashItemList &supplyStashItems, const ItemsTierCountList &depotBoxItems, const ItemsTierCountList &inboxItems) const;
	void sendCyclopediaCharacterOutfitsMounts() const;
	void sendCyclopediaCharacterStoreSummary() const;
	void sendCyclopediaCharacterInspection() const;
	void sendCyclopediaCharacterBadges() const;
	void sendCyclopediaCharacterTitles() const;
	void sendHighscoresNoData() const;
	void sendHighscores(const std::vector<HighscoreCharacter> &characters, uint8_t categoryId, uint32_t vocationId, uint16_t page, uint16_t pages, uint32_t updateTimer) const;
	void addAsyncOngoingTask(uint64_t flags);
	bool hasAsyncOngoingTask(uint64_t flags) const;
	void resetAsyncOngoingTask(uint64_t flags);
	void sendEnterWorld() const;
	void sendFightModes() const;
	void sendNetworkMessage(NetworkMessage &message) const;

	void receivePing();

	void sendOpenStash(bool isNpc = false) const;

	void sendTakeScreenshot(Screenshot_t screenshotType) const;

	void onThink(uint32_t interval) override;

	void postAddNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &oldParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;
	void postRemoveNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &newParent, int32_t index, CylinderLink_t link = LINK_OWNER) override;

	void setNextAction(int64_t time);
	bool canDoAction() const;

	void setNextPotionAction(int64_t time);
	bool canDoPotionAction() const;

	void setNextNecklaceAction(int64_t time);
	bool canEquipNecklace() const;

	void setNextRingAction(int64_t time);
	bool canEquipRing() const;

	void setLoginProtection(int64_t time);
	bool isLoginProtected() const;
	void resetLoginProtection();

	void setProtection(bool status);
	bool isProtected();

	void cancelPush();

	void setModuleDelay(uint8_t byteortype, int16_t delay);

	bool canRunModule(uint8_t byteortype);

	uint32_t getNextActionTime() const;
	uint32_t getNextPotionActionTime() const;

	std::shared_ptr<Item> getWriteItem(uint32_t &windowTextId, uint16_t &maxWriteLen);
	void setWriteItem(const std::shared_ptr<Item> &item, uint16_t maxWriteLen = 0);

	std::shared_ptr<House> getEditHouse(uint32_t &windowTextId, uint32_t &listId);
	void setEditHouse(const std::shared_ptr<House> &house, uint32_t listId = 0);

	void learnInstantSpell(const std::string &spellName);
	void forgetInstantSpell(const std::string &spellName);
	bool hasLearnedInstantSpell(const std::string &spellName) const;

	void updateRegeneration() const;

	void setScheduledSaleUpdate(bool scheduled);

	bool getScheduledSaleUpdate() const;

	bool inPushEvent() const;

	void pushEvent(bool b);

	bool walkExhausted() const;

	void setWalkExhaust(int64_t value);

	const std::map<uint8_t, OpenContainer> &getOpenContainers() const;

	uint16_t getBaseXpGain() const;
	void setBaseXpGain(uint16_t value);
	uint16_t getVoucherXpBoost() const;
	void setVoucherXpBoost(uint16_t value);
	uint16_t getGrindingXpBoost() const;
	uint16_t getDisplayGrindingXpBoost() const;
	void setGrindingXpBoost(uint16_t value);
	uint16_t getXpBoostPercent() const;
	uint16_t getDisplayXpBoostPercent() const;
	void setXpBoostPercent(uint16_t percent);
	uint16_t getStaminaXpBoost() const;
	void setStaminaXpBoost(uint16_t value);

	void setXpBoostTime(uint16_t timeLeft);

	uint16_t getXpBoostTime() const;

	int32_t getIdleTime() const;

	void setTraining(bool value);

	void addItemImbuementStats(const Imbuement* imbuement);
	void removeItemImbuementStats(const Imbuement* imbuement);
	void updateImbuementTrackerStats() const;

	// User Interface action exhaustion
	bool isUIExhausted(uint32_t exhaustionTime = 250) const;
	void updateUIExhausted();

	bool isQuickLootListedItem(const std::shared_ptr<Item> &item) const;

	bool updateKillTracker(const std::shared_ptr<Container> &corpse, const std::string &playerName, const Outfit_t &creatureOutfit) const;

	void updatePartyTrackerAnalyzer() const;

	void sendLootStats(const std::shared_ptr<Item> &item, uint8_t count);
	void updateSupplyTracker(const std::shared_ptr<Item> &item);
	void updateImpactTracker(CombatType_t type, int32_t amount) const;

	void updateInputAnalyzer(CombatType_t type, int32_t amount, const std::string &target) const;

	void createLeaderTeamFinder(NetworkMessage &msg) const;
	void sendLeaderTeamFinder(bool reset) const;
	void sendTeamFinderList() const;
	void sendCreatureHelpers(uint32_t creatureId, uint16_t helpers) const;

	void setItemCustomPrice(uint16_t itemId, uint64_t price);
	uint32_t getCharmPoints() const;
	void setCharmPoints(uint32_t points);
	bool hasCharmExpansion() const;
	void setCharmExpansion(bool onOff);
	void setUsedRunesBit(int32_t bit);
	int32_t getUsedRunesBit() const;
	void setUnlockedRunesBit(int32_t bit);
	int32_t getUnlockedRunesBit() const;
	void setImmuneCleanse(ConditionType_t conditiontype);
	bool isImmuneCleanse(ConditionType_t conditiontype) const;
	void setImmuneFear();
	bool isImmuneFear() const;
	uint16_t parseRacebyCharm(charmRune_t charmId, bool set, uint16_t newRaceid);

	uint64_t getItemCustomPrice(uint16_t itemId, bool buyPrice = false) const;
	uint16_t getFreeBackpackSlots() const;

	bool canAutoWalk(const Position &toPosition, const std::function<void()> &function, uint32_t delay = 500);

	void sendMessageDialog(const std::string &message) const;

	// Account
	bool setAccount(uint32_t accountId);
	uint8_t getAccountType() const;
	uint32_t getAccountId() const;
	std::shared_ptr<Account> getAccount() const;

	// Prey system
	void initializePrey();
	void removePreySlotById(PreySlot_t slotid);

	void sendPreyData() const;

	void sendPreyTimeLeft(const std::unique_ptr<PreySlot> &slot) const;

	void reloadPreySlot(PreySlot_t slotid);

	const std::unique_ptr<PreySlot> &getPreySlotById(PreySlot_t slotid);

	bool setPreySlotClass(std::unique_ptr<PreySlot> &slot);

	bool usePreyCards(uint16_t amount);

	void addPreyCards(uint64_t amount);

	uint64_t getPreyCards() const;

	uint32_t getPreyRerollPrice() const;

	std::vector<uint16_t> getPreyBlackList() const;

	const std::unique_ptr<PreySlot> &getPreyWithMonster(uint16_t raceId) const;

	// Task hunting system
	void initializeTaskHunting();
	bool isCreatureUnlockedOnTaskHunting(const std::shared_ptr<MonsterType> &mtype) const;

	bool setTaskHuntingSlotClass(std::unique_ptr<TaskHuntingSlot> &slot);

	void reloadTaskSlot(PreySlot_t slotid);

	const std::unique_ptr<TaskHuntingSlot> &getTaskHuntingSlotById(PreySlot_t slotid);

	std::vector<uint16_t> getTaskHuntingBlackList() const;

	void sendTaskHuntingData() const;

	void addTaskHuntingPoints(uint64_t amount);

	bool useTaskHuntingPoints(uint64_t amount);

	uint64_t getTaskHuntingPoints() const;

	uint32_t getTaskHuntingRerollPrice() const;

	const std::unique_ptr<TaskHuntingSlot> &getTaskHuntingWithCreature(uint16_t raceId) const;

	uint32_t getLoyaltyPoints() const;

	void setLoyaltyBonus(uint16_t bonus);
	void setLoyaltyTitle(std::string title);
	std::string getLoyaltyTitle() const;
	uint16_t getLoyaltyBonus() const;

	/*******************************************************************************
	 * Depot search system
	 ******************************************************************************/
	void requestDepotItems();
	void requestDepotSearchItem(uint16_t itemId, uint8_t tier);
	void retrieveAllItemsFromDepotSearch(uint16_t itemId, uint8_t tier, bool isDepot);
	void openContainerFromDepotSearch(const Position &pos);
	std::shared_ptr<Item> getItemFromDepotSearch(uint16_t itemId, const Position &pos);

	std::pair<std::vector<std::shared_ptr<Item>>, std::map<uint16_t, std::map<uint8_t, uint32_t>>> requestLockerItems(const std::shared_ptr<DepotLocker> &depotLocker, bool sendToClient = false, uint8_t tier = 0) const;

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
	) const;

	bool saySpell(
		SpeakClasses type,
		const std::string &text,
		bool ghostMode,
		const Spectators* spectatorsPtr = nullptr,
		const Position* pos = nullptr
	);

	// Forge system
	void forgeFuseItems(ForgeAction_t actionType, uint16_t firstItemid, uint8_t tier, uint16_t secondItemId, bool success, bool reduceTierLoss, bool convergence, uint8_t bonus, uint8_t coreCount);
	void forgeTransferItemTier(ForgeAction_t actionType, uint16_t donorItemId, uint8_t tier, uint16_t receiveItemId, bool convergence);
	void forgeResourceConversion(ForgeAction_t actionType);
	void forgeHistory(uint8_t page) const;

	void sendOpenForge() const;
	void sendForgeError(ReturnValue returnValue) const;
	void sendForgeResult(ForgeAction_t actionType, uint16_t leftItemId, uint8_t leftTier, uint16_t rightItemId, uint8_t rightTier, bool success, uint8_t bonus, uint8_t coreCount, bool convergence) const;
	void sendForgeHistory(uint8_t page) const;
	void closeForgeWindow() const;

	void setForgeDusts(uint64_t amount);
	void addForgeDusts(uint64_t amount);
	void removeForgeDusts(uint64_t amount);
	uint64_t getForgeDusts() const;

	void addForgeDustLevel(uint64_t amount);
	void removeForgeDustLevel(uint64_t amount);
	uint64_t getForgeDustLevel() const;

	std::vector<ForgeHistory> &getForgeHistory();

	void setForgeHistory(const ForgeHistory &history);

	void registerForgeHistoryDescription(ForgeHistory history);

	void setBossPoints(uint32_t amount);
	void addBossPoints(uint32_t amount);
	void removeBossPoints(uint32_t amount);
	uint32_t getBossPoints() const;
	void sendBosstiaryCooldownTimer() const;

	void setSlotBossId(uint8_t slotId, uint32_t bossId);
	uint32_t getSlotBossId(uint8_t slotId) const;

	void addRemoveTime();
	void setRemoveBossTime(uint8_t newRemoveTimes);
	uint8_t getRemoveTimes() const;

	void sendMonsterPodiumWindow(const std::shared_ptr<Item> &podium, const Position &position, uint16_t itemId, uint8_t stackpos) const;

	void sendBosstiaryEntryChanged(uint32_t bossid) const;

	void sendInventoryImbuements(const std::map<Slots_t, std::shared_ptr<Item>> &items) const;

	/*******************************************************************************
	 * Hazard system
	 ******************************************************************************/
	// Parser
	void parseAttackRecvHazardSystem(CombatDamage &damage, const std::shared_ptr<Monster> &monster);
	void parseAttackDealtHazardSystem(CombatDamage &damage, const std::shared_ptr<Monster> &monster) const;
	// Points increase:
	void setHazardSystemPoints(int32_t amount);
	// Points get:
	uint16_t getHazardSystemPoints() const;

	/*******************************************************************************/

	// Concoction system
	void updateConcoction(uint16_t itemId, uint16_t timeLeft);
	std::map<uint16_t, uint16_t> getActiveConcoctions() const;
	bool isConcoctionActive(Concoction_t concotion) const;

	bool checkAutoLoot(bool isBoss) const;

	QuickLootFilter_t getQuickLootFilter() const;

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
	PlayerWheel &wheel();
	const PlayerWheel &wheel() const;

	// Player achievement interface
	PlayerAchievement &achiev();
	const PlayerAchievement &achiev() const;

	// Player badge interface
	PlayerBadge &badge();
	const PlayerBadge &badge() const;

	// Player title interface
	PlayerTitle &title();
	const PlayerTitle &title() const;

	// Player summary interface
	PlayerCyclopedia &cyclopedia();
	const PlayerCyclopedia &cyclopedia() const;

	// Player vip interface
	PlayerVIP &vip();
	const PlayerVIP &vip() const;

	// Player animusMastery interface
	AnimusMastery &animusMastery();
	const AnimusMastery &animusMastery() const;

	// Player attached effects interface
	PlayerAttachedEffects &attachedEffects();
	const PlayerAttachedEffects &attachedEffects() const;

	void sendLootMessage(const std::string &message) const;

	std::shared_ptr<Container> getLootPouch();

	bool hasPermittedConditionInPZ() const;

	std::shared_ptr<Container> getStoreInbox() const;

	bool canSpeakWithHireling(uint8_t speechbubble);

	uint16_t getPlayerVocationEnum() const;

	void sendPlayerTyping(const std::shared_ptr<Creature> &creature, uint8_t typing) const;

private:
	friend class PlayerLock;
	std::mutex mutex;

	static uint32_t playerFirstID;
	static uint32_t playerLastID;

	std::vector<std::shared_ptr<Condition>> getMuteConditions() const;

	void checkTradeState(const std::shared_ptr<Item> &item);
	bool hasCapacity(const std::shared_ptr<Item> &item, uint32_t count) const;

	void checkLootContainers(const std::shared_ptr<Container> &item);

	void gainExperience(uint64_t exp, const std::shared_ptr<Creature> &target);
	void addExperience(const std::shared_ptr<Creature> &target, uint64_t exp, bool sendText = false);
	void removeExperience(uint64_t exp, bool sendText = false);

	void updateInventoryWeight();
	/**
	 * @brief Starts checking the imbuements in the item so that the time decay is performed
	 * Registers the player in an unordered_map in game.h so that the function can be initialized by the task
	 */
	void updateInventoryImbuement();

	void setNextWalkActionTask(const std::shared_ptr<Task> &task);
	void setNextWalkTask(const std::shared_ptr<Task> &task);
	void setNextActionTask(const std::shared_ptr<Task> &task, bool resetIdleTime = true);
	void setNextActionPushTask(const std::shared_ptr<Task> &task);
	void setNextPotionActionTask(const std::shared_ptr<Task> &task);

	void death(const std::shared_ptr<Creature> &lastHitCreature) override;
	bool spawn();
	void despawn();
	bool dropCorpse(const std::shared_ptr<Creature> &lastHitCreature, const std::shared_ptr<Creature> &mostDamageCreature, bool lastHitUnjustified, bool mostDamageUnjustified) override;
	std::shared_ptr<Item> getCorpse(const std::shared_ptr<Creature> &lastHitCreature, const std::shared_ptr<Creature> &mostDamageCreature) override;

	// cylinder implementations
	ReturnValue queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor = nullptr) override;
	ReturnValue queryMaxCount(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t &maxQueryCount, uint32_t flags) override;
	ReturnValue queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &actor = nullptr) override;
	std::shared_ptr<Cylinder> queryDestination(int32_t &index, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item> &destItem, uint32_t &flags) override;

	void addThing(const std::shared_ptr<Thing> &) override { }
	void addThing(int32_t index, const std::shared_ptr<Thing> &thing) override;

	void updateThing(const std::shared_ptr<Thing> &thing, uint16_t itemId, uint32_t count) override;
	void replaceThing(uint32_t index, const std::shared_ptr<Thing> &thing) override;

	void removeThing(const std::shared_ptr<Thing> &thing, uint32_t count) override;

	int32_t getThingIndex(const std::shared_ptr<Thing> &thing) const override;
	size_t getFirstIndex() const override;
	size_t getLastIndex() const override;
	uint32_t getItemTypeCount(uint16_t itemId, int32_t subType = -1) const override;
	void stashContainer(const StashContainerList &itemDict);
	ItemsTierCountList getInventoryItemsId(bool ignoreStoreInbox = false) const;

	// This function is a override function of base class
	std::map<uint32_t, uint32_t> &getAllItemTypeCount(std::map<uint32_t, uint32_t> &countMap) const override;
	// Function from player class with correct type sizes (uint16_t)
	std::map<uint16_t, uint16_t> &getAllSaleItemIdAndCount(std::map<uint16_t, uint16_t> &countMap) const;
	void getAllItemTypeCountAndSubtype(std::map<uint32_t, uint32_t> &countMap) const;
	std::shared_ptr<Item> getForgeItemFromId(uint16_t itemId, uint8_t tier) const;
	std::shared_ptr<Thing> getThing(size_t index) const override;

	void internalAddThing(const std::shared_ptr<Thing> &thing) override;
	void internalAddThing(uint32_t index, const std::shared_ptr<Thing> &thing) override;

	void addHuntingTaskKill(const std::shared_ptr<MonsterType> &mType);
	void addBestiaryKill(const std::shared_ptr<MonsterType> &mType);
	void addBosstiaryKill(const std::shared_ptr<MonsterType> &mType);

	phmap::flat_hash_set<uint32_t> attackedSet {};

	std::map<uint8_t, OpenContainer> openContainers;
	std::map<uint32_t, std::shared_ptr<DepotLocker>> depotLockerMap;
	std::map<uint32_t, std::shared_ptr<DepotChest>> depotChests;
	std::map<uint8_t, int64_t> moduleDelayMap;
	std::map<uint32_t, int32_t> storageMap;
	std::map<uint16_t, uint64_t> itemPriceMap;

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
	int64_t nextNecklaceAction = 0;
	int64_t nextRingAction = 0;
	int64_t lastQuickLootNotification = 0;
	int64_t lastWalking = 0;
	int64_t loginProtectionTime = 0;
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
	std::shared_ptr<ProtocolGame> client = nullptr;
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
	QuickLootFilter_t quickLootFilter {};
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
	bool m_isDead = false;
	bool imbuementTrackerWindowOpen = false;
	bool shouldForceLogout = true;
	bool connProtected = false;

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
	void updateBaseSpeed();

	bool isPromoted() const;

	uint32_t getAttackSpeed() const;

	static double_t getPercentLevel(uint64_t count, uint64_t nextLevelCount);
	double getLostPercent() const;
	uint64_t getLostExperience() const override {
		return skillLoss ? static_cast<uint64_t>(experience * getLostPercent()) : 0;
	}

	bool isSuppress(ConditionType_t conditionType, bool attackerPlayer) const override;

	uint16_t getLookCorpse() const override;
	void getPathSearchParams(const std::shared_ptr<Creature> &creature, FindPathParams &fpp) override;

	void setDead(bool isDead);
	bool isDead() const override;

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
	friend class PlayerAttachedEffects;

	PlayerWheel m_wheelPlayer;
	PlayerAchievement m_playerAchievement;
	PlayerBadge m_playerBadge;
	PlayerCyclopedia m_playerCyclopedia;
	PlayerTitle m_playerTitle;
	PlayerVIP m_playerVIP;
	AnimusMastery m_animusMastery;
	PlayerAttachedEffects m_playerAttachedEffects;

	std::mutex quickLootMutex;

	std::shared_ptr<Account> account;
	bool online = true;

	bool hasQuiverEquipped() const;

	bool hasWeaponDistanceEquipped() const;

	std::shared_ptr<Item> getQuiverAmmoOfType(const ItemType &it) const;

	std::array<double_t, COMBAT_COUNT> getFinalDamageReduction() const;
	void calculateDamageReductionFromEquipedItems(std::array<double_t, COMBAT_COUNT> &combatReductionMap) const;
	void calculateDamageReductionFromItem(std::array<double_t, COMBAT_COUNT> &combatReductionMap, const std::shared_ptr<Item> &item) const;
	void updateDamageReductionFromItemImbuement(std::array<double_t, COMBAT_COUNT> &combatReductionMap, const std::shared_ptr<Item> &item, uint16_t combatTypeIndex) const;
	void updateDamageReductionFromItemAbility(std::array<double_t, COMBAT_COUNT> &combatReductionMap, const std::shared_ptr<Item> &item, uint16_t combatTypeIndex) const;
	double_t calculateDamageReduction(double_t currentTotal, int16_t resistance) const;

	void removeEmptyRewards();
	bool hasOtherRewardContainerOpen(const std::shared_ptr<Container> &container) const;

	void checkAndShowBlessingMessage();

	void setMarriageSpouse(const int32_t spouseId) {
		marriageSpouse = spouseId;
	}
	int32_t getMarriageSpouse() const {
		return marriageSpouse;
	}
};
