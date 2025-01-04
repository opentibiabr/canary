/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/appearance/outfit/outfit.hpp"
#include "creatures/players/cyclopedia/player_badge.hpp"
#include "creatures/players/cyclopedia/player_title.hpp"
#include "creatures/players/grouping/familiars.hpp"
#include "creatures/players/grouping/groups.hpp"
#include "lua/creature/raids.hpp"
#include "map/map.hpp"
#include "modal_window/modal_window.hpp"
#include "movement/position.hpp"

// Forward declaration for protobuf class
namespace Canary {
	namespace protobuf {
		namespace appearances {
			class Appearances;
		} // namespace appearances
	} // namespace protobuf
} // namespace Canary

class ServiceManager;
class Creature;
class Monster;
class Npc;
class Charm;
class IOPrey;
class IOWheel;
class ItemClassification;
class Guild;
class Mounts;
class Spectators;
class Player;
class Account;
class TeamFinder;
class NetworkMessage;
class Task;
class Container;
class ContainerIterator;
class Item;
class BedItem;
class WildcardTreeNode;

struct Achievement;
struct HighscoreCategory;
struct TextMessage;

enum ObjectCategory_t : uint8_t;
enum class ForgeAction_t : uint8_t;

using CreatureVector = std::vector<std::shared_ptr<Creature>>;

static constexpr uint16_t SERVER_BEAT = 0x32;
static constexpr int32_t EVENT_MS = 10000;
static constexpr int32_t EVENT_LIGHTINTERVAL_MS = 10000;
static constexpr int32_t EVENT_DECAYINTERVAL = 250;
static constexpr int32_t EVENT_DECAY_BUCKETS = 4;
static constexpr int32_t EVENT_FORGEABLEMONSTERCHECKINTERVAL = 300000;
static constexpr int32_t EVENT_LUA_GARBAGE_COLLECTION = 60000 * 10; // 10min

static constexpr std::chrono::minutes CACHE_EXPIRATION_TIME { 10 }; // 10min
static constexpr std::chrono::minutes HIGHSCORE_CACHE_EXPIRATION_TIME { 10 }; // 10min
static constexpr int32_t UPDATE_PLAYERS_ONLINE_DB = 60000 * 10; // 10min

struct QueryHighscoreCacheEntry {
	std::string query;
	uint32_t page;
	uint8_t entriesPerPage;
	std::chrono::time_point<std::chrono::steady_clock> timestamp;
};

struct HighscoreCacheEntry {
	std::vector<HighscoreCharacter> characters;
	uint32_t page;
	uint32_t entriesPerPage;
	std::chrono::time_point<std::chrono::system_clock> timestamp;
};

class Game {
public:
	Game();
	~Game();

	// Singleton - ensures we don't accidentally copy it.
	Game(const Game &) = delete;
	Game &operator=(const Game &) = delete;

	static Game &getInstance();

	void resetMonsters() const;
	void resetNpcs() const;

	void loadBoostedCreature();
	void start(ServiceManager* manager);

	void forceRemoveCondition(uint32_t creatureId, ConditionType_t type, ConditionId_t conditionId);

	void logCyclopediaStats();

	/**
	 * Load the main map
	 * \param filename Is the map custom name (Example: "map".otbm, not is necessary add extension .otbm)
	 * \returns true if the custom map was loaded successfully
	 */
	void loadMainMap(const std::string &filename);
	/**
	 * Load the custom map
	 * \param filename Is the map custom name (Example: "map".otbm, not is necessary add extension .otbm)
	 * \returns true if the custom map was loaded successfully
	 */
	void loadCustomMaps(const std::filesystem::path &customMapPath);
	void loadMap(const std::string &path, const Position &pos = Position());

	void getMapDimensions(uint32_t &width, uint32_t &height) const {
		width = map.width;
		height = map.height;
	}

	void setWorldType(WorldType_t type);
	WorldType_t getWorldType() const {
		return worldType;
	}

	const std::map<uint32_t, std::unique_ptr<TeamFinder>> &getTeamFinderList() const {
		return teamFinderMap;
	}

	const std::unique_ptr<TeamFinder> &getTeamFinder(const std::shared_ptr<Player> &player) const;

	const std::unique_ptr<TeamFinder> &getOrCreateTeamFinder(const std::shared_ptr<Player> &player);

	void removeTeamFinderListed(uint32_t leaderGuid);

	std::shared_ptr<Cylinder> internalGetCylinder(const std::shared_ptr<Player> &player, const Position &pos);
	std::shared_ptr<Thing> internalGetThing(const std::shared_ptr<Player> &player, const Position &pos, int32_t index, uint32_t itemId, StackPosType_t type);
	static void internalGetPosition(const std::shared_ptr<Item> &item, Position &pos, uint8_t &stackpos);

	static std::string getTradeErrorDescription(ReturnValue ret, const std::shared_ptr<Item> &item);

	std::shared_ptr<Creature> getCreatureByID(uint32_t id);

	std::shared_ptr<Monster> getMonsterByID(uint32_t id);

	std::shared_ptr<Npc> getNpcByID(uint32_t id);

	std::shared_ptr<Creature> getCreatureByName(const std::string &s);

	std::shared_ptr<Npc> getNpcByName(const std::string &s);

	std::shared_ptr<Player> getPlayerByID(uint32_t id, bool allowOffline = false);

	std::shared_ptr<Player> getPlayerByName(const std::string &s, bool allowOffline = false, bool isNewName = false);

	std::shared_ptr<Player> getPlayerByGUID(const uint32_t &guid, bool allowOffline = false);

	std::string getPlayerNameByGUID(const uint32_t &guid);

	ReturnValue getPlayerByNameWildcard(const std::string &s, std::shared_ptr<Player> &player);

	std::vector<std::shared_ptr<Player>> getPlayersByAccount(const std::shared_ptr<Account> &acc, bool allowOffline = false);

	bool internalPlaceCreature(const std::shared_ptr<Creature> &creature, const Position &pos, bool extendedPos = false, bool forced = false, bool creatureCheck = false);

	bool placeCreature(const std::shared_ptr<Creature> &creature, const Position &pos, bool extendedPos = false, bool force = false);

	bool removeCreature(const std::shared_ptr<Creature> &creature, bool isLogout = true);

	void addCreatureCheck(const std::shared_ptr<Creature> &creature);
	static void removeCreatureCheck(const std::shared_ptr<Creature> &creature);

	size_t getPlayersOnline() const {
		return players.size();
	}
	size_t getMonstersOnline() const {
		return monsters.size();
	}
	size_t getNpcsOnline() const {
		return npcs.size();
	}
	uint32_t getPlayersRecord() const {
		return playersRecord;
	}

	void addItemsClassification(ItemClassification* itemsClassification) {
		itemsClassifications.push_back(itemsClassification);
	}
	ItemClassification* getItemsClassification(uint8_t id, bool create);

	LightInfo getWorldLightInfo() const;

	bool gameIsDay();

	ReturnValue internalMoveCreature(const std::shared_ptr<Creature> &creature, Direction direction, uint32_t flags = 0);
	ReturnValue internalMoveCreature(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &toTile, uint32_t flags = 0);

	ReturnValue checkMoveItemToCylinder(const std::shared_ptr<Player> &player, const std::shared_ptr<Cylinder> &fromCylinder, const std::shared_ptr<Cylinder> &toCylinder, const std::shared_ptr<Item> &item, Position toPos);
	ReturnValue internalMoveItem(std::shared_ptr<Cylinder> fromCylinder, std::shared_ptr<Cylinder> toCylinder, int32_t index, const std::shared_ptr<Item> &item, uint32_t count, std::shared_ptr<Item>* movedItem, uint32_t flags = 0, const std::shared_ptr<Creature> &actor = nullptr, const std::shared_ptr<Item> &tradeItem = nullptr, bool checkTile = true);

	std::tuple<ReturnValue, uint32_t, uint32_t> addItemBatch(const std::shared_ptr<Cylinder> &toCylinder, const std::vector<std::shared_ptr<Item>> &items, uint32_t flags = 0, bool dropOnMap = true, uint32_t autoContainerId = 0);
	std::tuple<ReturnValue, uint32_t, uint32_t> createItemBatch(const std::shared_ptr<Cylinder> &toCylinder, const std::vector<std::tuple<uint16_t, uint32_t, uint16_t>> &itemCounts, uint32_t flags = 0, bool dropOnMap = true, uint32_t autoContainerId = 0);
	std::tuple<ReturnValue, uint32_t, uint32_t> createItem(const std::shared_ptr<Cylinder> &toCylinder, uint16_t itemId, uint32_t count, uint16_t subType, uint32_t flags = 0, bool dropOnMap = true, uint32_t autoContainerId = 0);
	ReturnValue internalAddItem(std::shared_ptr<Cylinder> toCylinder, const std::shared_ptr<Item> &item, int32_t index = INDEX_WHEREEVER, uint32_t flags = 0, bool test = false);
	ReturnValue internalAddItem(std::shared_ptr<Cylinder> toCylinder, const std::shared_ptr<Item> &item, int32_t index, uint32_t flags, bool test, uint32_t &remainderCount);
	ReturnValue internalRemoveItem(const std::shared_ptr<Item> &item, int32_t count = -1, bool test = false, uint32_t flags = 0, bool force = false);

	ReturnValue internalPlayerAddItem(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, bool dropOnMap = true, Slots_t slot = CONST_SLOT_WHEREEVER);

	std::shared_ptr<Item> findItemOfType(const std::shared_ptr<Cylinder> &cylinder, uint16_t itemId, bool depthSearch = true, int32_t subType = -1) const;

	void createLuaItemsOnMap();

	bool removeMoney(const std::shared_ptr<Cylinder> &cylinder, uint64_t money, uint32_t flags = 0, bool useBank = false);

	void addMoney(const std::shared_ptr<Cylinder> &cylinder, uint64_t money, uint32_t flags = 0);

	std::shared_ptr<Item> transformItem(std::shared_ptr<Item> item, uint16_t newId, int32_t newCount = -1);

	ReturnValue internalTeleport(const std::shared_ptr<Thing> &thing, const Position &newPos, bool pushMove = true, uint32_t flags = 0);

	bool internalCreatureTurn(const std::shared_ptr<Creature> &creature, Direction dir);

	bool internalCreatureSay(const std::shared_ptr<Creature> &creature, SpeakClasses type, const std::string &text, bool ghostMode, Spectators* spectatorsPtr = nullptr, const Position* pos = nullptr);

	ObjectCategory_t getObjectCategory(const std::shared_ptr<Item> &item);
	ObjectCategory_t getObjectCategory(const ItemType &it);

	uint64_t getItemMarketPrice(const std::map<uint16_t, uint64_t> &itemMap, bool buyPrice) const;

	void loadPlayersRecord();
	void checkPlayersRecord();

	void sendSingleSoundEffect(const Position &pos, SoundEffect_t soundId, const std::shared_ptr<Creature> &actor = nullptr);
	void sendDoubleSoundEffect(const Position &pos, SoundEffect_t mainSoundEffect, SoundEffect_t secondarySoundEffect, const std::shared_ptr<Creature> &actor = nullptr);

	void sendGuildMotd(uint32_t playerId);
	void kickPlayer(uint32_t playerId, bool displayEffect);
	void playerReportBug(uint32_t playerId, const std::string &message, const Position &position, uint8_t category);
	void playerDebugAssert(uint32_t playerId, const std::string &assertLine, const std::string &date, const std::string &description, const std::string &comment);
	void playerPreyAction(uint32_t playerId, uint8_t slot, uint8_t action, uint8_t option, int8_t index, uint16_t raceId);
	void playerTaskHuntingAction(uint32_t playerId, uint8_t slot, uint8_t action, bool upgrade, uint16_t raceId);
	void playerNpcGreet(uint32_t playerId, uint32_t npcId);
	void playerAnswerModalWindow(uint32_t playerId, uint32_t modalWindowId, uint8_t button, uint8_t choice);
	void playerForgeFuseItems(
		uint32_t playerId,
		ForgeAction_t actionType,
		uint16_t firstItemId,
		uint8_t tier,
		uint16_t secondItemId,
		bool usedCore,
		bool reduceTierLoss,
		bool convergence
	);
	void playerForgeTransferItemTier(
		uint32_t playerId,
		ForgeAction_t actionType,
		uint16_t donorItemId,
		uint8_t tier,
		uint16_t receiveItemId,
		bool convergence
	);
	void playerForgeResourceConversion(uint32_t playerId, ForgeAction_t actionType);
	void playerBrowseForgeHistory(uint32_t playerId, uint8_t page);

	void playerBosstiarySlot(uint32_t playerId, uint8_t slotId, uint32_t selectedBossId);
	void playerSetMonsterPodium(uint32_t playerId, uint32_t monsterRaceId, const Position &pos, uint8_t stackPos, uint16_t itemId, uint8_t direction, const std::pair<uint8_t, uint8_t> &podiumAndMonsterVisible);
	void playerRotatePodium(uint32_t playerId, const Position &pos, uint8_t stackPos, uint16_t itemId);

	void playerRequestInventoryImbuements(uint32_t playerId, bool isTrackerOpen);

	bool addItemStoreInbox(const std::shared_ptr<Player> &player, uint32_t itemId);

	void playerRewardChestCollect(uint32_t playerId, const Position &pos, uint16_t itemId, uint8_t stackPos, uint32_t maxMoveItems = 0);

	void playerReportRuleViolationReport(uint32_t playerId, const std::string &targetName, uint8_t reportType, uint8_t reportReason, const std::string &comment, const std::string &translation);

	void playerFriendSystemAction(const std::shared_ptr<Player> &player, uint8_t type, uint8_t titleId);

	void playerCyclopediaCharacterInfo(const std::shared_ptr<Player> &player, uint32_t characterID, CyclopediaCharacterInfoType_t characterInfoType, uint16_t entriesPerPage, uint16_t page);

	void playerHighscores(const std::shared_ptr<Player> &player, HighscoreType_t type, uint8_t category, uint32_t vocation, const std::string &worldName, uint16_t page, uint8_t entriesPerPage);
	static std::string getSkillNameById(uint8_t &skill);

	// House Auction
	void playerCyclopediaHousesByTown(uint32_t playerId, const std::string &townName);
	void playerCyclopediaHouseBid(uint32_t playerId, uint32_t houseId, uint64_t bidValue);
	void playerCyclopediaHouseMoveOut(uint32_t playerId, uint32_t houseId, uint32_t timestamp);
	void playerCyclopediaHouseCancelMoveOut(uint32_t playerId, uint32_t houseId);
	void playerCyclopediaHouseTransfer(uint32_t playerId, uint32_t houseId, uint32_t timestamp, const std::string &newOwnerName, uint64_t bidValue);
	void playerCyclopediaHouseCancelTransfer(uint32_t playerId, uint32_t houseId);
	void playerCyclopediaHouseAcceptTransfer(uint32_t playerId, uint32_t houseId);
	void playerCyclopediaHouseRejectTransfer(uint32_t playerId, uint32_t houseId);
	bool processBankAuction(std::shared_ptr<Player> player, const std::shared_ptr<House> &house, uint64_t bid, bool replace = false);

	void updatePlayerSaleItems(uint32_t playerId);

	bool internalStartTrade(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &partner, const std::shared_ptr<Item> &tradeItem);
	void internalCloseTrade(const std::shared_ptr<Player> &player);
	bool playerBroadcastMessage(const std::shared_ptr<Player> &player, const std::string &text) const;
	void broadcastMessage(const std::string &text, MessageClasses type) const;

	// Implementation of player invoked events
	void playerTeleport(uint32_t playerId, const Position &pos);
	void playerMoveThing(uint32_t playerId, const Position &fromPos, uint16_t itemId, uint8_t fromStackPos, const Position &toPos, uint8_t count);
	void playerMoveCreatureByID(uint32_t playerId, uint32_t movingCreatureId, const Position &movingCreatureOrigPos, const Position &toPos);
	void playerMoveCreature(const std::shared_ptr<Player> &playerId, const std::shared_ptr<Creature> &movingCreature, const Position &movingCreatureOrigPos, const std::shared_ptr<Tile> &toTile);
	void playerMoveItemByPlayerID(uint32_t playerId, const Position &fromPos, uint16_t itemId, uint8_t fromStackPos, const Position &toPos, uint8_t count);
	void playerMoveItem(const std::shared_ptr<Player> &player, const Position &fromPos, uint16_t itemId, uint8_t fromStackPos, const Position &toPos, uint8_t count, std::shared_ptr<Item> item, std::shared_ptr<Cylinder> toCylinder);
	void playerEquipItem(uint32_t playerId, uint16_t itemId, bool hasTier = false, uint8_t tier = 0);
	void playerMove(uint32_t playerId, Direction direction);
	void forcePlayerMove(uint32_t playerId, Direction direction);
	void playerCreatePrivateChannel(uint32_t playerId);
	void playerChannelInvite(uint32_t playerId, const std::string &name);
	void playerChannelExclude(uint32_t playerId, const std::string &name);
	void playerRequestChannels(uint32_t playerId);
	void playerOpenChannel(uint32_t playerId, uint16_t channelId);
	void playerCloseChannel(uint32_t playerId, uint16_t channelId);
	void playerOpenPrivateChannel(uint32_t playerId, std::string &receiver);
	void playerStowItem(uint32_t playerId, const Position &pos, uint16_t itemId, uint8_t stackpos, uint8_t count, bool allItems);
	void playerStashWithdraw(uint32_t playerId, uint16_t itemId, uint32_t count, uint8_t stackpos);
	void playerCloseNpcChannel(uint32_t playerId);
	void playerReceivePing(uint32_t playerId);
	void playerReceivePingBack(uint32_t playerId);
	void playerAutoWalk(uint32_t playerId, const std::vector<Direction> &listDir);
	void forcePlayerAutoWalk(uint32_t playerId, const std::vector<Direction> &listDir);
	void playerStopAutoWalk(uint32_t playerId);
	void playerUseItemEx(uint32_t playerId, const Position &fromPos, uint8_t fromStackPos, uint16_t fromItemId, const Position &toPos, uint8_t toStackPos, uint16_t toItemId);
	void playerUseItem(uint32_t playerId, const Position &pos, uint8_t stackPos, uint8_t index, uint16_t itemId);
	void playerUseWithCreature(uint32_t playerId, const Position &fromPos, uint8_t fromStackPos, uint32_t creatureId, uint16_t itemId);
	void playerCloseContainer(uint32_t playerId, uint8_t cid);
	void playerMoveUpContainer(uint32_t playerId, uint8_t cid);
	void playerUpdateContainer(uint32_t playerId, uint8_t cid);
	void playerRotateItem(uint32_t playerId, const Position &pos, uint8_t stackPos, uint16_t itemId);
	void playerConfigureShowOffSocket(uint32_t playerId, const Position &pos, uint8_t stackPos, uint16_t itemId);
	void playerSetShowOffSocket(uint32_t playerId, Outfit_t &outfit, const Position &pos, uint8_t stackPos, uint16_t itemId, uint8_t podiumVisible, uint8_t direction);
	void playerWrapableItem(uint32_t playerId, const Position &pos, uint8_t stackPos, uint16_t itemId);
	void playerWriteItem(uint32_t playerId, uint32_t windowTextId, const std::string &text);
	void playerBrowseField(uint32_t playerId, const Position &pos);
	void playerSeekInContainer(uint32_t playerId, uint8_t containerId, uint16_t index, uint8_t containerCategory);
	void playerUpdateHouseWindow(uint32_t playerId, uint8_t listId, uint32_t windowTextId, const std::string &text);
	void playerRequestTrade(uint32_t playerId, const Position &pos, uint8_t stackPos, uint32_t tradePlayerId, uint16_t itemId);
	void playerAcceptTrade(uint32_t playerId);
	void playerLookInTrade(uint32_t playerId, bool lookAtCounterOffer, uint8_t index);
	void playerBuyItem(uint32_t playerId, uint16_t itemId, uint8_t count, uint16_t amount, bool ignoreCap = false, bool inBackpacks = false);
	void playerSellItem(uint32_t playerId, uint16_t itemId, uint8_t count, uint16_t amount, bool ignoreEquipped = false);
	void playerCloseShop(uint32_t playerId);
	void playerLookInShop(uint32_t playerId, uint16_t itemId, uint8_t count);
	void playerCloseTrade(uint32_t playerId);
	void playerSetAttackedCreature(uint32_t playerId, uint32_t creatureId);
	void playerFollowCreature(uint32_t playerId, uint32_t creatureId);
	void playerCancelAttackAndFollow(uint32_t playerId);
	void playerSetFightModes(uint32_t playerId, FightMode_t fightMode, bool chaseMode, bool secureMode);
	void playerLookAt(uint32_t playerId, uint16_t itemId, const Position &pos, uint8_t stackPos);
	void playerLookInBattleList(uint32_t playerId, uint32_t creatureId);
	void playerQuickLootCorpse(const std::shared_ptr<Player> &player, const std::shared_ptr<Container> &corpse, const Position &position);
	void playerQuickLoot(uint32_t playerId, const Position &pos, uint16_t itemId, uint8_t stackPos, const std::shared_ptr<Item> &defaultItem = nullptr, bool lootAllCorpses = false, bool autoLoot = false);
	void playerLootAllCorpses(const std::shared_ptr<Player> &player, const Position &pos, bool lootAllCorpses);
	void playerSetManagedContainer(uint32_t playerId, ObjectCategory_t category, const Position &pos, uint16_t itemId, uint8_t stackPos, bool isLootContainer);
	void playerClearManagedContainer(uint32_t playerId, ObjectCategory_t category, bool isLootContainer);
	void playerOpenManagedContainer(uint32_t playerId, ObjectCategory_t category, bool isLootContainer);
	void playerSetQuickLootFallback(uint32_t playerId, bool fallback);
	void playerQuickLootBlackWhitelist(uint32_t playerId, QuickLootFilter_t filter, const std::vector<uint16_t> &itemIds);

	void playerRequestDepotItems(uint32_t playerId);
	void playerRequestCloseDepotSearch(uint32_t playerId);
	void playerRequestDepotSearchItem(uint32_t playerId, uint16_t itemId, uint8_t tier);
	void playerRequestDepotSearchRetrieve(uint32_t playerId, uint16_t itemId, uint8_t tier, uint8_t type);
	void playerRequestOpenContainerFromDepotSearch(uint32_t playerId, const Position &pos);
	void playerMoveThingFromDepotSearch(const std::shared_ptr<Player> &player, uint16_t itemId, uint8_t tier, uint8_t count, const Position &fromPos, const Position &toPos, bool allItems = false);

	void playerRequestAddVip(uint32_t playerId, const std::string &name);
	void playerRequestRemoveVip(uint32_t playerId, uint32_t guid);
	void playerRequestEditVip(uint32_t playerId, uint32_t guid, const std::string &description, uint32_t icon, bool notify, std::vector<uint8_t> vipGroupsId);
	void playerApplyImbuement(uint32_t playerId, uint16_t imbuementid, uint8_t slot, bool protectionCharm);
	void playerClearImbuement(uint32_t playerid, uint8_t slot);
	void playerCloseImbuementWindow(uint32_t playerid);
	void playerTurn(uint32_t playerId, Direction dir);
	void playerRequestOutfit(uint32_t playerId);
	void playerShowQuestLog(uint32_t playerId);
	void playerShowQuestLine(uint32_t playerId, uint16_t questId);
	void playerSay(uint32_t playerId, uint16_t channelId, SpeakClasses type, const std::string &receiver, const std::string &text);
	void playerChangeOutfit(uint32_t playerId, Outfit_t outfit, uint8_t isMountRandomized = 0);
	void playerInviteToParty(uint32_t playerId, uint32_t invitedId);
	void playerJoinParty(uint32_t playerId, uint32_t leaderId);
	void playerRevokePartyInvitation(uint32_t playerId, uint32_t invitedId);
	void playerPassPartyLeadership(uint32_t playerId, uint32_t newLeaderId);
	void playerLeaveParty(uint32_t playerId);
	void playerEnableSharedPartyExperience(uint32_t playerId, bool sharedExpActive);
	void playerToggleMount(uint32_t playerId, bool mount);
	void playerLeaveMarket(uint32_t playerId);
	void playerBrowseMarket(uint32_t playerId, uint16_t itemId, uint8_t tier);
	void playerBrowseMarketOwnOffers(uint32_t playerId);
	void playerBrowseMarketOwnHistory(uint32_t playerId);
	void playerCreateMarketOffer(uint32_t playerId, uint8_t type, uint16_t itemId, uint16_t amount, uint64_t price, uint8_t tier, bool anonymous);
	void playerCancelMarketOffer(uint32_t playerId, uint32_t timestamp, uint16_t counter);
	void playerAcceptMarketOffer(uint32_t playerId, uint32_t timestamp, uint16_t counter, uint16_t amount);

	void parsePlayerExtendedOpcode(uint32_t playerId, uint8_t opcode, const std::string &buffer);

	void playerOpenWheel(uint32_t playerId, uint32_t ownerId);
	void playerSaveWheel(uint32_t playerId, NetworkMessage &msg);
	void playerWheelGemAction(uint32_t playerId, NetworkMessage &msg);

	void updatePlayerHelpers(const std::shared_ptr<Player> &player);

	void shutdown();
	void dieSafely(const std::string &errorMsg);
	void addBestiaryList(uint16_t raceid, const std::string &name);
	const std::map<uint16_t, std::string> &getBestiaryList() const {
		return BestiaryList;
	}

	void setBoostedName(std::string name) {
		boostedCreature = name;
		g_logger().info("Boosted creature: {}", name);
	}

	std::string getBoostedMonsterName() const {
		return boostedCreature;
	}

	bool canThrowObjectTo(const Position &fromPos, const Position &toPos, SightLines_t lineOfSight = SightLine_CheckSightLine, int32_t rangex = MAP_MAX_CLIENT_VIEW_PORT_X, int32_t rangey = MAP_MAX_CLIENT_VIEW_PORT_Y);
	bool isSightClear(const Position &fromPos, const Position &toPos, bool sameFloor);

	void changeSpeed(const std::shared_ptr<Creature> &creature, int32_t varSpeedDelta);
	void setCreatureSpeed(const std::shared_ptr<Creature> &creature, int32_t speed); // setCreatureSpeed
	void changePlayerSpeed(const std::shared_ptr<Player> &player, int32_t varSpeedDelta);
	void internalCreatureChangeOutfit(const std::shared_ptr<Creature> &creature, const Outfit_t &oufit);
	void internalCreatureChangeVisible(const std::shared_ptr<Creature> &creature, bool visible);
	void changeLight(const std::shared_ptr<Creature> &creature);
	void updateCreatureIcon(const std::shared_ptr<Creature> &creature);
	void reloadCreature(const std::shared_ptr<Creature> &creature);
	void updateCreatureSkull(const std::shared_ptr<Creature> &player) const;
	void updatePlayerShield(const std::shared_ptr<Player> &player);
	void updateCreatureType(const std::shared_ptr<Creature> &creature);
	void updateCreatureWalkthrough(const std::shared_ptr<Creature> &creature);

	GameState_t getGameState() const;
	void setGameState(GameState_t newState);

	// Events
	void checkCreatures();
	void checkLight();

	bool combatBlockHit(CombatDamage &damage, const std::shared_ptr<Creature> &attacker, const std::shared_ptr<Creature> &target, bool checkDefense, bool checkArmor, bool field);

	void combatGetTypeInfo(CombatType_t combatType, const std::shared_ptr<Creature> &target, TextColor_t &color, uint16_t &effect);

	// Hazard combat helpers
	void handleHazardSystemAttack(CombatDamage &damage, const std::shared_ptr<Player> &player, const std::shared_ptr<Monster> &monster, bool isPlayerAttacker);
	void notifySpectators(const CreatureVector &spectators, const Position &targetPos, const std::shared_ptr<Player> &attackerPlayer, const std::shared_ptr<Monster> &targetMonster);

	// Custom PvP System combat helpers
	void applyPvPDamage(CombatDamage &damage, const std::shared_ptr<Player> &attacker, const std::shared_ptr<Player> &target);
	float pvpLevelDifferenceDamageMultiplier(const std::shared_ptr<Player> &attacker, const std::shared_ptr<Player> &target);

	// Wheel of destiny combat helpers
	void applyWheelOfDestinyHealing(CombatDamage &damage, const std::shared_ptr<Player> &attackerPlayer, std::shared_ptr<Creature> target);
	void applyWheelOfDestinyEffectsToDamage(CombatDamage &damage, const std::shared_ptr<Player> &attackerPlayer, const std::shared_ptr<Creature> &target) const;
	int32_t applyHealthChange(const CombatDamage &damage, const std::shared_ptr<Creature> &target) const;

	bool combatChangeHealth(const std::shared_ptr<Creature> &attacker, const std::shared_ptr<Creature> &target, CombatDamage &damage, bool isEvent = false);
	void applyCharmRune(const std::shared_ptr<Monster> &targetMonster, const std::shared_ptr<Player> &attackerPlayer, const std::shared_ptr<Creature> &target, const int32_t &realDamage) const;
	void applyManaLeech(
		const std::shared_ptr<Player> &attackerPlayer, const std::shared_ptr<Monster> &targetMonster,
		const std::shared_ptr<Creature> &target, const CombatDamage &damage, const int32_t &realDamage
	) const;
	void applyLifeLeech(
		const std::shared_ptr<Player> &attackerPlayer, const std::shared_ptr<Monster> &targetMonster,
		const std::shared_ptr<Creature> &target, const CombatDamage &damage, const int32_t &realDamage
	) const;
	int32_t calculateLeechAmount(const int32_t &realDamage, const uint16_t &skillAmount, int targetsAffected) const;
	bool combatChangeMana(const std::shared_ptr<Creature> &attacker, const std::shared_ptr<Creature> &target, CombatDamage &damage);

	// Animation help functions
	void addCreatureHealth(const std::shared_ptr<Creature> &target);
	static void addCreatureHealth(const CreatureVector &spectators, const std::shared_ptr<Creature> &target);
	void addPlayerMana(const std::shared_ptr<Player> &target);
	void addPlayerVocation(const std::shared_ptr<Player> &target);
	void addMagicEffect(const Position &pos, uint16_t effect);
	static void addMagicEffect(const std::vector<std::shared_ptr<Player>> &players, const Position &pos, uint16_t effect);
	static void addMagicEffect(const CreatureVector &spectators, const Position &pos, uint16_t effect);
	void removeMagicEffect(const Position &pos, uint16_t effect);
	static void removeMagicEffect(const CreatureVector &spectators, const Position &pos, uint16_t effect);
	void addDistanceEffect(const Position &fromPos, const Position &toPos, uint16_t effect);
	static void addDistanceEffect(const CreatureVector &spectators, const Position &fromPos, const Position &toPos, uint16_t effect);

	int32_t getLightHour() const {
		return lightHour;
	}

	void loadItemsPrice();

	void loadMotdNum();
	void saveMotdNum() const;
	const std::string &getMotdHash() const {
		return motdHash;
	}
	uint32_t getMotdNum() const {
		return motdNum;
	}
	void incrementMotdNum() {
		motdNum++;
	}

	void sendOfflineTrainingDialog(const std::shared_ptr<Player> &player);

	const std::map<uint16_t, std::map<uint8_t, uint64_t>> &getItemsPrice() const {
		return itemsPriceMap;
	}
	const phmap::parallel_flat_hash_map<uint32_t, std::shared_ptr<Guild>> &getGuilds() const {
		return guilds;
	}
	const phmap::parallel_flat_hash_map<uint32_t, std::shared_ptr<Player>> &getPlayers() const {
		return players;
	}
	const auto &getMonsters() const {
		return monsters;
	}
	const auto &getNpcs() const {
		return npcs;
	}

	const std::vector<ItemClassification*> &getItemsClassifications() const {
		return itemsClassifications;
	}

	void addPlayer(const std::shared_ptr<Player> &player);
	void removePlayer(const std::shared_ptr<Player> &player);

	void addNpc(const std::shared_ptr<Npc> &npc);
	void removeNpc(const std::shared_ptr<Npc> &npc);

	void addMonster(const std::shared_ptr<Monster> &monster);
	void removeMonster(const std::shared_ptr<Monster> &monster);

	std::shared_ptr<Guild> getGuild(uint32_t id, bool allowOffline = false) const;
	std::shared_ptr<Guild> getGuildByName(const std::string &name, bool allowOffline = false) const;
	void addGuild(const std::shared_ptr<Guild> &guild);
	void removeGuild(uint32_t guildId);

	phmap::flat_hash_map<std::shared_ptr<Tile>, std::weak_ptr<Container>> browseFields;

	void internalRemoveItems(const std::vector<std::shared_ptr<Item>> &itemVector, uint32_t amount, bool stackable);

	std::shared_ptr<BedItem> getBedBySleeper(uint32_t guid) const;
	void setBedSleeper(std::shared_ptr<BedItem> bed, uint32_t guid);
	void removeBedSleeper(uint32_t guid);

	std::shared_ptr<Item> getUniqueItem(uint16_t uniqueId);
	bool addUniqueItem(uint16_t uniqueId, std::shared_ptr<Item> item);
	void removeUniqueItem(uint16_t uniqueId);

	bool hasEffect(uint16_t effectId);
	bool hasDistanceEffect(uint16_t effectId);

	Groups groups;
	[[no_unique_address]] Familiars familiars;
	Map map;
	std::unique_ptr<Mounts> mounts;
	[[no_unique_address]] Outfits outfits;
	Raids raids;
	std::unique_ptr<Canary::protobuf::appearances::Appearances> m_appearancesPtr;

	auto getTilesToClean() const {
		return tilesToClean;
	}
	void addTileToClean(const std::shared_ptr<Tile> &tile) {
		tilesToClean.emplace(tile);
	}
	void removeTileToClean(const std::shared_ptr<Tile> &tile) {
		tilesToClean.erase(tile);
	}
	void clearTilesToClean() {
		tilesToClean.clear();
	}

	void playerInspectItem(const std::shared_ptr<Player> &player, const Position &pos);
	void playerInspectItem(const std::shared_ptr<Player> &player, uint16_t itemId, uint8_t itemCount, bool cyclopedia);

	void addCharmRune(const std::shared_ptr<Charm> &charm) {
		CharmList.push_back(charm);
		CharmList.shrink_to_fit();
	}

	std::vector<std::shared_ptr<Charm>> &getCharmList() {
		return CharmList;
	}

	FILELOADER_ERRORS loadAppearanceProtobuf(const std::string &file);
	bool isMagicEffectRegistered(uint16_t type) const {
		return std::ranges::find(registeredMagicEffects, type) != registeredMagicEffects.end();
	}

	bool isDistanceEffectRegistered(uint16_t type) const {
		return std::ranges::find(registeredDistanceEffects, type) != registeredDistanceEffects.end();
	}

	bool isLookTypeRegistered(uint16_t type) const {
		return std::ranges::find(registeredLookTypes, type) != registeredLookTypes.end();
	}

	void setCreateLuaItems(Position position, uint16_t itemId) {
		mapLuaItemsStored[position] = itemId;
	}

	auto getFiendishMonsters() const {
		return fiendishMonsters;
	}

	auto getInfluencedMonsters() const {
		return influencedMonsters;
	}

	bool removeForgeMonster(uint32_t id, ForgeClassifications_t monsterForgeClassification, bool create = true);
	bool removeInfluencedMonster(uint32_t id, bool create = false);
	bool removeFiendishMonster(uint32_t id, bool create = true);
	void updateFiendishMonsterStatus(uint32_t monsterId, const std::string &monsterName);
	void createFiendishMonsters();
	void createInfluencedMonsters();
	void updateForgeableMonsters();
	void checkForgeEventId(uint32_t monsterId);
	uint32_t makeFiendishMonster(uint32_t forgeableMonsterId = 0, bool createForgeableMonsters = false);
	uint32_t makeInfluencedMonster();

	bool addInfluencedMonster(const std::shared_ptr<Monster> &monster);
	void sendUpdateCreature(const std::shared_ptr<Creature> &creature);
	std::shared_ptr<Item> wrapItem(const std::shared_ptr<Item> &item, const std::shared_ptr<House> &house);

	/**
	 * @brief Adds a player to the unique login map.
	 * @details The function registers a player in the unique login map to ensure no duplicate logins.
	 * If the player pointer is null, it logs an error and returns.
	 *
	 * @param player A pointer to the Player object to add.
	 */
	void addPlayerUniqueLogin(const std::shared_ptr<Player> &player);

	/**
	 * @brief Gets a player from the unique login map using their name.
	 * @details The function attempts to find a player in the unique login map using their name.
	 * If the player's name is not found, the function returns a null pointer.
	 * If an empty string is provided, it logs an error and returns a null pointer.
	 *
	 * @param playerName The name of the player to search for.
	 * @return A pointer to the Player object if found, null otherwise.
	 */
	std::shared_ptr<Player> getPlayerUniqueLogin(const std::string &playerName) const;

	/**
	 * @brief Removes a player from the unique login map using their name.
	 * @details The function removes a player from the unique login map using their name.
	 * If an empty string is provided, it logs an error and returns.
	 *
	 * @param playerName The name of the player to remove.
	 */
	void removePlayerUniqueLogin(const std::string &playerName);

	/**
	 * @brief Removes a player from the unique login map.
	 * @details The function removes a player from the unique login map.
	 * If the player pointer is null, it logs an error and returns.
	 *
	 * @param player A pointer to the Player object to remove.
	 */
	void removePlayerUniqueLogin(const std::shared_ptr<Player> &player);
	void playerCheckActivity(const std::string &playerName, int interval);

	/**
	 * @brief Attemtps to retrieve an item from the stash.
	 *
	 * @details This function leverages the internalCollectManagedItems function with the OBJECTCATEGORY_STASHRETRIEVE category
	 * to determine if the player is capable of retrieving the stash items.
	 *
	 * @param player Pointer to the player object.
	 * @param item Pointer to the item to be checked.
	 * @return True if stash items can be retrieved, false otherwise.
	 */
	bool tryRetrieveStashItems(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item);

	ReturnValue beforeCreatureZoneChange(const std::shared_ptr<Creature> &creature, const std::unordered_set<std::shared_ptr<Zone>> &fromZones, const std::unordered_set<std::shared_ptr<Zone>> &toZones, bool force = false) const;
	void afterCreatureZoneChange(const std::shared_ptr<Creature> &creature, const std::unordered_set<std::shared_ptr<Zone>> &fromZones, const std::unordered_set<std::shared_ptr<Zone>> &toZones) const;

	std::unique_ptr<IOWheel> &getIOWheel();
	const std::unique_ptr<IOWheel> &getIOWheel() const;

	void setTransferPlayerHouseItems(uint32_t houseId, uint32_t playerId);
	void transferHouseItemsToDepot();

	const std::unordered_map<uint8_t, std::string> &getHighscoreCategoriesName() const;

	const std::vector<HighscoreCategory> &getHighscoreCategories() const;

	void registerAchievement(uint16_t id, const std::string &name, std::string description, bool secret, uint8_t grade, uint8_t points);
	Achievement getAchievementById(uint16_t id);
	Achievement getAchievementByName(const std::string &name);
	std::vector<Achievement> getSecretAchievements();
	std::vector<Achievement> getPublicAchievements();
	std::map<uint16_t, Achievement> getAchievements();

	std::unordered_set<Badge> getBadges();
	Badge getBadgeById(uint8_t id);
	Badge getBadgeByName(const std::string &name);

	std::unordered_set<Title> getTitles();
	Title getTitleById(uint8_t id);
	Title getTitleByName(const std::string &name);

	const std::string &getSummaryKeyByType(uint8_t type);

	const std::map<uint8_t, std::string> &getBlessingNames();
	const std::unordered_map<uint16_t, std::string> &getHirelingSkills();
	const std::unordered_map<uint16_t, std::string> &getHirelingOutfits();

private:
	std::map<uint16_t, Achievement> m_achievements;
	std::map<std::string, uint16_t> m_achievementsNameToId;

	std::unordered_set<Badge> m_badges;
	std::unordered_set<Title> m_titles;

	std::vector<HighscoreCategory> m_highscoreCategories;
	std::unordered_map<uint8_t, std::string> m_highscoreCategoriesNames;

	std::unordered_map<uint8_t, std::string> m_summaryCategories;
	std::unordered_map<uint16_t, std::string> m_hirelingSkills;
	std::unordered_map<uint16_t, std::string> m_hirelingOutfits;

	std::map<uint32_t, int32_t> forgeMonsterEventIds;
	std::unordered_set<uint32_t> fiendishMonsters;
	std::unordered_set<uint32_t> influencedMonsters;
	void checkImbuements() const;
	bool playerSaySpell(const std::shared_ptr<Player> &player, SpeakClasses type, const std::string &text);
	void playerWhisper(const std::shared_ptr<Player> &player, const std::string &text);
	bool playerYell(const std::shared_ptr<Player> &player, const std::string &text);
	bool playerSpeakTo(const std::shared_ptr<Player> &player, SpeakClasses type, const std::string &receiver, const std::string &text);
	void playerSpeakToNpc(const std::shared_ptr<Player> &player, const std::string &text);
	std::shared_ptr<Task> createPlayerTask(uint32_t delay, std::function<void(void)> f, const std::string &context) const;

	/**
	 * @brief Finds the managed container for loot or obtain based on the given parameters.
	 *
	 * @param player Pointer to the player object.
	 * @param fallbackConsumed Reference to a boolean flag indicating whether a fallback has been consumed.
	 * @param category The category of the object.
	 *
	 * @note If it's enabled in config.lua to use the gold pouch to store any item, then the system will check whether the player has a loot pouch.
	 * @note If the player does have one, the loot pouch will be used instead of the managed containers.
	 *
	 * @return Pointer to the managed container or nullptr if not found.
	 */
	std::shared_ptr<Container> findManagedContainer(const std::shared_ptr<Player> &player, bool &fallbackConsumed, ObjectCategory_t category, bool isLootContainer);

	/**
	 * @brief Finds the next available sub-container within a container.
	 *
	 * @param containerIterator Iterator for the current container.
	 * @param lastSubContainer Reference to the last sub-container found.
	 * @param lootContainer Reference to the loot container being used.
	 * @return Pointer to the next available container or nullptr if not found.
	 */
	std::shared_ptr<Container> findNextAvailableContainer(ContainerIterator &containerIterator, std::shared_ptr<Container> &lastSubContainer, std::shared_ptr<Container> &lootContainer);

	/**
	 * @brief Handles the fallback logic for loot containers.
	 *
	 * @param player Pointer to the player object.
	 * @param lootContainer Reference to the loot container.
	 * @param containerIterator Iterator for the current container.
	 * @param fallbackConsumed Reference to a boolean flag indicating whether a fallback has been consumed.
	 * @return True if fallback logic was handled, false otherwise.
	 */
	bool handleFallbackLogic(const std::shared_ptr<Player> &player, std::shared_ptr<Container> &lootContainer, ContainerIterator &containerIterator, const bool &fallbackConsumed);

	/**
	 * @brief Processes the movement or addition of an item to a loot container.
	 *
	 * @param item Pointer to the item to be moved or added.
	 * @param lootContainer Pointer to the loot container.
	 * @param remainderCount Reference to the remaining count of the item.
	 * @param player Pointer to the player object.
	 * @return Return value indicating success or error.
	 */
	ReturnValue processMoveOrAddItemToLootContainer(const std::shared_ptr<Item> &item, const std::shared_ptr<Container> &lootContainer, uint32_t &remainderCount, const std::shared_ptr<Player> &player);

	/**
	 * @brief Processes loot items and places them into the appropriate containers.
	 *
	 * @param player Pointer to the player object.
	 * @param lootContainer Pointer to the loot container.
	 * @param item Pointer to the item being looted.
	 * @param fallbackConsumed Reference to a boolean flag indicating whether a fallback has been consumed.
	 * @return Return value indicating success or error.
	 */
	ReturnValue processLootItems(const std::shared_ptr<Player> &player, std::shared_ptr<Container> lootContainer, const std::shared_ptr<Item> &item, bool &fallbackConsumed);

	/**
	 * @brief Internally collects loot or obtain items from a given item and places them into the managed container.
	 *
	 * @param player Pointer to the player object.
	 * @param item Pointer to the item being collected.
	 * @param category Category of the item (default is OBJECTCATEGORY_DEFAULT).
	 * @return Return value indicating success or error.
	 */
	ReturnValue internalCollectManagedItems(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, ObjectCategory_t category, bool isLootContainer = true);

	/**
	 * @brief Collects items from the reward chest.
	 *
	 * @param player Pointer to the player object.
	 * @param maxMoveItems Maximum number of items to move (default is 0, which means no limit).
	 * @return Return value indicating success or error.
	 */
	ReturnValue collectRewardChestItems(const std::shared_ptr<Player> &player, uint32_t maxMoveItems = 0);

	phmap::flat_hash_map<std::string, QueryHighscoreCacheEntry> queryCache;
	phmap::flat_hash_map<std::string, HighscoreCacheEntry> highscoreCache;

	phmap::flat_hash_map<std::string, std::weak_ptr<Player>> m_uniqueLoginPlayerNames;
	phmap::parallel_flat_hash_map<uint32_t, std::shared_ptr<Player>> players;
	phmap::flat_hash_map<std::string, std::weak_ptr<Player>> mappedPlayerNames;
	phmap::parallel_flat_hash_map<uint32_t, std::shared_ptr<Guild>> guilds;
	phmap::flat_hash_map<uint16_t, std::shared_ptr<Item>> uniqueItems;
	phmap::parallel_flat_hash_map<uint32_t, std::string> m_playerNameCache;

	/* Items stored from the lua scripts positions
	 * For example: ActionFunctions::luaActionPosition
	 * This basically works so that the item is created after the map is loaded, because the scripts are loaded before the map is loaded, we will use this table to create items that don't exist in the map natively through each script
	 */
	std::map<Position, uint16_t> mapLuaItemsStored;

	std::map<uint16_t, std::string> BestiaryList;
	std::string boostedCreature;

	std::vector<std::shared_ptr<Charm>> CharmList;

	std::vector<uint16_t> registeredMagicEffects;
	std::vector<uint16_t> registeredDistanceEffects;
	std::vector<uint16_t> registeredLookTypes;

	size_t lastBucket = 0;
	size_t lastImbuedBucket = 0;

	std::shared_ptr<WildcardTreeNode> wildcardTree = nullptr;

	std::vector<std::shared_ptr<Monster>> monsters;
	// This works only for unique monsters (bosses, quest monsters, etc)
	std::unordered_map<std::string, size_t> monstersNameIndex;
	std::unordered_map<uint32_t, size_t> monstersIdIndex;

	std::vector<std::shared_ptr<Npc>> npcs;
	// This works only for unique npcs (quest npcs, etc)
	std::unordered_map<std::string, size_t> npcsNameIndex;
	std::unordered_map<uint32_t, size_t> npcsIdIndex;

	std::vector<uint32_t> forgeableMonsters;

	std::map<uint32_t, std::unique_ptr<TeamFinder>> teamFinderMap; // [leaderGUID] = TeamFinder*

	std::map<uint32_t, uint32_t> transferHouseItemsToPlayer;

	// list of items that are in trading state, mapped to the player
	std::map<std::shared_ptr<Item>, uint32_t> tradeItems;

	std::map<uint32_t, std::shared_ptr<BedItem>> bedSleepersMap;

	std::unordered_set<std::shared_ptr<Tile>> tilesToClean;

	ModalWindow offlineTrainingWindow { std::numeric_limits<uint32_t>::max(), "Choose a Skill", "Please choose a skill:" };

	static constexpr int32_t DAY_LENGTH_SECONDS = 3600;
	static constexpr int32_t LIGHT_DAY_LENGTH = 1440;
	static constexpr int32_t LIGHT_LEVEL_DAY = 250;
	static constexpr int32_t LIGHT_LEVEL_NIGHT = 40;
	static constexpr int32_t SUNSET = 1050;
	static constexpr int32_t SUNRISE = 360;

	bool isDay = false;
	bool browseField = false;

	GameState_t gameState = GAME_STATE_NORMAL;
	WorldType_t worldType = WORLD_TYPE_PVP;

	LightState_t lightState = LIGHT_STATE_DAY;
	LightState_t currentLightState = lightState;
	uint8_t lightLevel = LIGHT_LEVEL_DAY;
	int32_t lightHour = SUNRISE + (SUNSET - SUNRISE) / 2;
	// (1440 total light of tibian day)/(3600 real seconds each tibian day) * 10 seconds event interval
	int32_t lightHourDelta = (LIGHT_DAY_LENGTH * (EVENT_LIGHTINTERVAL_MS / 1000)) / DAY_LENGTH_SECONDS;

	ServiceManager* serviceManager = nullptr;

	void updatePlayersRecord() const;
	uint32_t playersRecord = 0;

	std::string motdHash;
	uint32_t motdNum = 0;

	std::map<uint16_t, std::map<uint8_t, uint64_t>> itemsPriceMap;

	std::vector<ItemClassification*> itemsClassifications;

	bool isTryingToStow(const Position &toPos, const std::shared_ptr<Cylinder> &toCylinder) const;

	void sendDamageMessageAndEffects(
		const std::shared_ptr<Creature> &attacker, const std::shared_ptr<Creature> &target, const CombatDamage &damage, const Position &targetPos,
		const std::shared_ptr<Player> &attackerPlayer, const std::shared_ptr<Player> &targetPlayer, TextMessage &message,
		const CreatureVector &spectators, int32_t realDamage
	);

	void updatePlayerPartyHuntAnalyzer(const CombatDamage &damage, const std::shared_ptr<Player> &player) const;

	void sendEffects(
		const std::shared_ptr<Creature> &target, const CombatDamage &damage, const Position &targetPos,
		TextMessage &message, const CreatureVector &spectators
	);

	void sendMessages(
		const std::shared_ptr<Creature> &attacker, const std::shared_ptr<Creature> &target, const CombatDamage &damage,
		const Position &targetPos, const std::shared_ptr<Player> &attackerPlayer, const std::shared_ptr<Player> &targetPlayer,
		TextMessage &message, const CreatureVector &spectators, int32_t realDamage
	) const;

	bool shouldSendMessage(const TextMessage &message) const;

	void buildMessageAsAttacker(
		const std::shared_ptr<Creature> &target, const CombatDamage &damage, TextMessage &message,
		std::stringstream &ss, const std::string &damageString
	) const;

	void buildMessageAsTarget(
		const std::shared_ptr<Creature> &attacker, const CombatDamage &damage, const std::shared_ptr<Player> &attackerPlayer,
		const std::shared_ptr<Player> &targetPlayer, TextMessage &message, std::stringstream &ss,
		const std::string &damageString
	) const;

	void buildMessageAsSpectator(
		const std::shared_ptr<Creature> &attacker, const std::shared_ptr<Creature> &target, const CombatDamage &damage,
		const std::shared_ptr<Player> &targetPlayer, TextMessage &message, std::stringstream &ss,
		const std::string &damageString, std::string &spectatorMessage
	) const;

	void unwrapItem(const std::shared_ptr<Item> &item, uint16_t unWrapId, const std::shared_ptr<House> &house, const std::shared_ptr<Player> &player);

	// Variable members (m_)
	std::unique_ptr<IOWheel> m_IOWheel;

	void cacheQueryHighscore(const std::string &key, const std::string &query, uint32_t page, uint8_t entriesPerPage);
	void processHighscoreResults(const DBResult_ptr &result, uint32_t playerID, uint8_t category, uint32_t vocation, uint8_t entriesPerPage);

	std::string generateVocationConditionHighscore(uint32_t vocation);
	std::string generateHighscoreQueryForEntries(const std::string &categoryName, uint32_t page, uint8_t entriesPerPage, uint32_t vocation);
	std::string generateHighscoreQueryForOurRank(const std::string &categoryName, uint8_t entriesPerPage, uint32_t playerGUID, uint32_t vocation);
	std::string generateHighscoreOrGetCachedQueryForEntries(const std::string &categoryName, uint32_t page, uint8_t entriesPerPage, uint32_t vocation);
	std::string generateHighscoreOrGetCachedQueryForOurRank(const std::string &categoryName, uint8_t entriesPerPage, uint32_t playerGUID, uint32_t vocation);

	void updatePlayersOnline() const;
};

constexpr auto g_game = Game::getInstance;
