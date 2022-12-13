/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

#ifndef SRC_GAME_GAME_H_
#define SRC_GAME_GAME_H_

#include "creatures/players/account/account.hpp"
#include "creatures/combat/combat.h"
#include "items/containers/container.h"
#include "creatures/players/grouping/groups.h"
#include "io/iobestiary.h"
#include "items/item.h"
#include "map/map.h"
#include "creatures/npcs/npc.h"
#include "movement/position.h"
#include "creatures/players/player.h"
#include "lua/creature/raids.h"
#include "creatures/players/grouping/team_finder.hpp"
#include "utils/wildcardtree.h"
#include "items/items_classification.hpp"
#include "protobuf/appearances.pb.h"

class ServiceManager;
class Creature;
class Monster;
class Npc;
class CombatInfo;
class Charm;
class IOPrey;
class ItemClassification;

static constexpr int32_t EVENT_MS = 10000;
static constexpr int32_t EVENT_LIGHTINTERVAL_MS = 10000;
static constexpr int32_t EVENT_DECAYINTERVAL = 250;
static constexpr int32_t EVENT_DECAY_BUCKETS = 4;
static constexpr int32_t EVENT_FORGEABLEMONSTERCHECKINTERVAL = 300000;

class Game
{
	public:
		Game();
		~Game();

		// Singleton - ensures we don't accidentally copy it.
		Game(const Game&) = delete;
		Game& operator=(const Game&) = delete;

		static Game& getInstance() {
			// Guaranteed to be destroyed
			static Game instance;
			// Instantiated on first use
			return instance;
		}

		void resetMonsters() const;
		void resetNpcs() const;

		void loadBoostedCreature();
		void start(ServiceManager* manager);

		void forceRemoveCondition(uint32_t creatureId, ConditionType_t type, ConditionId_t conditionId);

		/**
		* Load the main map
		 * \param filename Is the map custom name (Example: "map".otbm, not is necessary add extension .otbm)
		 * \returns true if the custom map was loaded successfully
		*/
		bool loadMainMap(const std::string& filename);
		/**
		* Load the custom map
		 * \param filename Is the map custom name (Example: "map".otbm, not is necessary add extension .otbm)
		 * \returns true if the custom map was loaded successfully
		*/
		bool loadCustomMap(const std::string& filename);
		void loadMap(const std::string& path);

		void getMapDimensions(uint32_t& width, uint32_t& height) const {
			width = map.width;
			height = map.height;
		}

		void setWorldType(WorldType_t type);
		WorldType_t getWorldType() const {
			return worldType;
		}

		std::map<uint32_t, TeamFinder*> getTeamFinderList() const {
			return teamFinderMap;
		}
		void registerTeamFinderAssemble(uint32_t leaderGuid, TeamFinder* teamFinder) {
			teamFinderMap[leaderGuid] = teamFinder;
		}
		void removeTeamFinderListed(uint32_t leaderGuid) {
			teamFinderMap.erase(leaderGuid);
		}

		Cylinder* internalGetCylinder(Player* player, const Position& pos) const;
		Thing* internalGetThing(Player* player, const Position& pos, int32_t index,
								uint32_t itemId, StackPosType_t type) const;
		static void internalGetPosition(Item* item, Position& pos, uint8_t& stackpos);

		static std::string getTradeErrorDescription(ReturnValue ret, Item* item);

		Creature* getCreatureByID(uint32_t id);

		Monster* getMonsterByID(uint32_t id);

		Npc* getNpcByID(uint32_t id);

		Player* getPlayerByID(uint32_t id);

		Creature* getCreatureByName(const std::string& s);

		Npc* getNpcByName(const std::string& s);

		Player* getPlayerByName(const std::string& s);

		Player* getPlayerByGUID(const uint32_t& guid);

		ReturnValue getPlayerByNameWildcard(const std::string& s, Player*& player);

		Player* getPlayerByAccount(uint32_t acc);

		bool internalPlaceCreature(Creature* creature, const Position& pos, bool extendedPos = false, bool forced = false, bool creatureCheck = false);

		bool placeCreature(Creature* creature, const Position& pos, bool extendedPos = false, bool force = false);

		bool removeCreature(Creature* creature, bool isLogout = true);
		void executeDeath(uint32_t creatureId);

		void addCreatureCheck(Creature* creature);
		static void removeCreatureCheck(Creature* creature);

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
		uint16_t getItemsPriceCount() const {
			return itemsSaleCount;
		}

		void addItemsClassification(ItemClassification* itemsClassification) {
			itemsClassifications.push_back(itemsClassification);
		}
		ItemClassification* getItemsClassification(uint8_t id, bool create) {
			auto it = std::find_if(itemsClassifications.begin(), itemsClassifications.end(), [id](ItemClassification* it) {
				return it->id == id;
				});

			if (it != itemsClassifications.end()) {
				return *it;
			} else if (create) {
				ItemClassification* itemClassification = new ItemClassification(id);
				addItemsClassification(itemClassification);
				return itemClassification;
			}

			return nullptr;
		}

		LightInfo getWorldLightInfo() const;

		bool gameIsDay();

		ReturnValue internalMoveCreature(Creature* creature,
                                         Direction direction, uint32_t flags = 0);
		ReturnValue internalMoveCreature(Creature& creature,
                                         Tile& toTile, uint32_t flags = 0);

		ReturnValue internalMoveItem(Cylinder* fromCylinder, Cylinder* toCylinder,
                                     int32_t index, Item* item, uint32_t count,
                                     Item** internalMoveItem, uint32_t flags = 0,
                                     Creature* actor = nullptr,
                                     Item* tradeItem = nullptr);

		ReturnValue internalAddItem(Cylinder* toCylinder, Item* item,
                                     int32_t index = INDEX_WHEREEVER,
                                     uint32_t flags = 0, bool test = false);
		ReturnValue internalAddItem(Cylinder* toCylinder, Item* item, int32_t index,
                                     uint32_t flags, bool test, uint32_t& remainderCount);
		ReturnValue internalRemoveItem(Item* item, int32_t count = -1,
                                       bool test = false, uint32_t flags = 0);

		ReturnValue internalPlayerAddItem(Player* player, Item* item,
                                          bool dropOnMap = true,
                                          Slots_t slot = CONST_SLOT_WHEREEVER);

		Item* findItemOfType(const Cylinder* cylinder, uint16_t itemId,
                             bool depthSearch = true, int32_t subType = -1) const;

		void createLuaItemsOnMap();

		bool removeMoney(Cylinder* cylinder, uint64_t money,
                         uint32_t flags = 0, bool useBank = false);

		void addMoney(Cylinder* cylinder, uint64_t money, uint32_t flags = 0);

		Item* transformItem(Item* item, uint16_t newId, int32_t newCount = -1);

		ReturnValue internalTeleport(Thing* thing, const Position& newPos,
                                     bool pushMove = true, uint32_t flags = 0);

		bool internalCreatureTurn(Creature* creature, Direction dir);

		bool internalCreatureSay(Creature* creature, SpeakClasses type,
                                 const std::string& text,
                                 bool ghostMode,
                                 SpectatorHashSet* spectatorsPtr = nullptr,
                                 const Position* pos = nullptr);

		void internalQuickLootCorpse(Player* player, Container* corpse);

		ReturnValue internalQuickLootItem(Player* player, Item* item,
                    ObjectCategory_t category = OBJECTCATEGORY_DEFAULT);

		ObjectCategory_t getObjectCategory(const Item* item);

		uint64_t getItemMarketPrice(std::map<uint16_t, uint64_t> const &itemMap, bool buyPrice) const;

		void loadPlayersRecord();
		void checkPlayersRecord();

		void sendSingleSoundEffect(const Position& pos, SoundEffect_t soundId, Creature* actor = nullptr);
		void sendDoubleSoundEffect(const Position& pos, SoundEffect_t mainSoundEffect, SoundEffect_t secondarySoundEffect, Creature* actor = nullptr);

		void sendGuildMotd(uint32_t playerId);
		void kickPlayer(uint32_t playerId, bool displayEffect);
		void playerReportBug(uint32_t playerId, const std::string& message,
                             const Position& position, uint8_t category);
		void playerDebugAssert(uint32_t playerId, const std::string& assertLine,
                               const std::string& date, const std::string& description,
                               const std::string& comment);
		void playerPreyAction(uint32_t playerId, uint8_t slot, uint8_t action, uint8_t option, int8_t index, uint16_t raceId);
		void playerTaskHuntingAction(uint32_t playerId, uint8_t slot, uint8_t action, bool upgrade, uint16_t raceId);
		void playerNpcGreet(uint32_t playerId, uint32_t npcId);
		void playerAnswerModalWindow(uint32_t playerId, uint32_t modalWindowId,
                                     uint8_t button, uint8_t choice);
		void playerForgeFuseItems(
			uint32_t playerId,
			uint16_t itemId,
			uint8_t tier,
			bool usedCore,
			bool reduceTierLoss
		);
		void playerForgeTransferItemTier(
			uint32_t playerId,
			uint16_t donorItemId,
			uint8_t tier,
			uint16_t receiveItemId
		);
		void playerForgeResourceConversion(uint32_t playerId, uint8_t action);
		void playerBrowseForgeHistory(uint32_t playerId, uint8_t page);
		void playerReportRuleViolationReport(uint32_t playerId,
                                             const std::string& targetName,
                                             uint8_t reportType, uint8_t reportReason,
                                             const std::string& comment,
                                             const std::string& translation);

		void playerCyclopediaCharacterInfo(Player* player, uint32_t characterID, CyclopediaCharacterInfoType_t characterInfoType, uint16_t entriesPerPage, uint16_t page);

		void playerHighscores(Player* player, HighscoreType_t type, uint8_t category, uint32_t vocation, const std::string& worldName, uint16_t page, uint8_t entriesPerPage);

		void playerTournamentLeaderboard(uint32_t playerId, uint8_t leaderboardType);

		void updatePlayerSaleItems(uint32_t playerId);

		bool internalStartTrade(Player* player, Player* partner, Item* tradeItem);
		void internalCloseTrade(Player* player);
		bool playerBroadcastMessage(Player* player, const std::string& text) const;
		void broadcastMessage(const std::string& text, MessageClasses type) const;

		//Implementation of player invoked events
		void playerTeleport(uint32_t playerId, const Position& pos);
		void playerMoveThing(uint32_t playerId, const Position& fromPos, uint16_t itemId, uint8_t fromStackPos,
                              const Position& toPos, uint8_t count);
		void playerMoveCreatureByID(uint32_t playerId, uint32_t movingCreatureId, const Position& movingCreatureOrigPos, const Position& toPos);
		void playerMoveCreature(Player* playerId, Creature* movingCreature, const Position& movingCreatureOrigPos, Tile* toTile);
		void playerMoveItemByPlayerID(uint32_t playerId, const Position& fromPos, uint16_t itemId, uint8_t fromStackPos, const Position& toPos, uint8_t count);
		void playerMoveItem(Player* player, const Position& fromPos,
							uint16_t itemId, uint8_t fromStackPos, const Position& toPos, uint8_t count, Item* item, Cylinder* toCylinder);
		void playerEquipItem(uint32_t playerId, uint16_t itemId, bool hasTier = false, uint8_t tier = 0);
		void playerMove(uint32_t playerId, Direction direction);
		void playerCreatePrivateChannel(uint32_t playerId);
		void playerChannelInvite(uint32_t playerId, const std::string& name);
		void playerChannelExclude(uint32_t playerId, const std::string& name);
		void playerRequestChannels(uint32_t playerId);
		void playerOpenChannel(uint32_t playerId, uint16_t channelId);
		void playerCloseChannel(uint32_t playerId, uint16_t channelId);
		void playerOpenPrivateChannel(uint32_t playerId, std::string& receiver);
		void playerStowItem(uint32_t playerId, const Position& pos, uint16_t itemId, uint8_t stackpos, uint8_t count, bool allItems);
		void playerStashWithdraw(uint32_t playerId, uint16_t itemId, uint32_t count, uint8_t stackpos);
		void playerCloseNpcChannel(uint32_t playerId);
		void playerReceivePing(uint32_t playerId);
		void playerReceivePingBack(uint32_t playerId);
		void playerAutoWalk(uint32_t playerId, const std::forward_list<Direction>& listDir);
		void playerStopAutoWalk(uint32_t playerId);
		void playerUseItemEx(uint32_t playerId, const Position& fromPos, uint8_t fromStackPos,
                              uint16_t fromItemId, const Position& toPos, uint8_t toStackPos, uint16_t toItemId);
		void playerUseItem(uint32_t playerId, const Position& pos, uint8_t stackPos, uint8_t index, uint16_t itemId);
		void playerUseWithCreature(uint32_t playerId, const Position& fromPos, uint8_t fromStackPos, uint32_t creatureId, uint16_t itemId);
		void playerCloseContainer(uint32_t playerId, uint8_t cid);
		void playerMoveUpContainer(uint32_t playerId, uint8_t cid);
		void playerUpdateContainer(uint32_t playerId, uint8_t cid);
		void playerRotateItem(uint32_t playerId, const Position& pos, uint8_t stackPos, const uint16_t itemId);
		void playerConfigureShowOffSocket(uint32_t playerId, const Position& pos, uint8_t stackPos, const uint16_t itemId);
		void playerSetShowOffSocket(uint32_t playerId, Outfit_t& outfit, const Position& pos, uint8_t stackPos, const uint16_t itemId, uint8_t podiumVisible, uint8_t direction);
		void playerWrapableItem(uint32_t playerId, const Position& pos, uint8_t stackPos, const uint16_t itemId);
		void playerWriteItem(uint32_t playerId, uint32_t windowTextId, const std::string& text);
		void playerBrowseField(uint32_t playerId, const Position& pos);
		void playerSeekInContainer(uint32_t playerId, uint8_t containerId, uint16_t index);
		void playerUpdateHouseWindow(uint32_t playerId, uint8_t listId, uint32_t windowTextId, const std::string& text);
		void playerRequestTrade(uint32_t playerId, const Position& pos, uint8_t stackPos,
								uint32_t tradePlayerId, uint16_t itemId);
		void playerAcceptTrade(uint32_t playerId);
		void playerLookInTrade(uint32_t playerId, bool lookAtCounterOffer, uint8_t index);
		void playerBuyItem(uint32_t playerId, uint16_t itemId, uint8_t count, uint16_t amount,
								bool ignoreCap = false, bool inBackpacks = false);
		void playerSellItem(uint32_t playerId, uint16_t itemId, uint8_t count,
								uint16_t amount, bool ignoreEquipped = false);
		void playerCloseShop(uint32_t playerId);
		void playerLookInShop(uint32_t playerId, uint16_t itemId, uint8_t count);
		void playerCloseTrade(uint32_t playerId);
		void playerSetAttackedCreature(uint32_t playerId, uint32_t creatureId);
		void playerFollowCreature(uint32_t playerId, uint32_t creatureId);
		void playerCancelAttackAndFollow(uint32_t playerId);
		void playerSetFightModes(uint32_t playerId, FightMode_t fightMode, bool chaseMode, bool secureMode);
		void playerLookAt(uint32_t playerId, uint16_t itemId, const Position& pos, uint8_t stackPos);
		void playerLookInBattleList(uint32_t playerId, uint32_t creatureId);
		void playerQuickLoot(uint32_t playerId, const Position& pos, uint16_t itemId, uint8_t stackPos,
								Item* defaultItem = nullptr, bool lootAllCorpses = false, bool autoLoot = false);
		void playerLootAllCorpses(Player* player, const Position& pos, bool lootAllCorpses);
		void playerSetLootContainer(uint32_t playerId, ObjectCategory_t category,
								const Position& pos, uint16_t itemId, uint8_t stackPos);
		void playerClearLootContainer(uint32_t playerId, ObjectCategory_t category);;
		void playerOpenLootContainer(uint32_t playerId, ObjectCategory_t category);
		void playerSetQuickLootFallback(uint32_t playerId, bool fallback);
		void playerQuickLootBlackWhitelist(uint32_t playerId,
								QuickLootFilter_t filter, const std::vector<uint16_t> itemIds);

		void playerRequestDepotItems(uint32_t playerId);
		void playerRequestCloseDepotSearch(uint32_t playerId);
		void playerRequestDepotSearchItem(uint32_t playerId, uint16_t itemId, uint8_t tier);
		void playerRequestDepotSearchRetrieve(uint32_t playerId, uint16_t itemId, uint8_t tier, uint8_t type);
		void playerRequestOpenContainerFromDepotSearch(uint32_t playerId, const Position& pos);
		void playerMoveThingFromDepotSearch(Player* player,
											uint16_t itemId,
											uint8_t tier,
											uint8_t count,
											const Position& fromPos,
											const Position& toPos,
											bool allItems = false);

		void playerRequestAddVip(uint32_t playerId, const std::string& name);
		void playerRequestRemoveVip(uint32_t playerId, uint32_t guid);
		void playerRequestEditVip(uint32_t playerId, uint32_t guid, const std::string& description, uint32_t icon, bool notify);
		void playerApplyImbuement(uint32_t playerId, uint16_t imbuementid, uint8_t slot, bool protectionCharm);
		void playerClearImbuement(uint32_t playerid, uint8_t slot);
		void playerCloseImbuementWindow(uint32_t playerid);
		void playerTurn(uint32_t playerId, Direction dir);
		void playerRequestOutfit(uint32_t playerId);
		void playerShowQuestLog(uint32_t playerId);
		void playerShowQuestLine(uint32_t playerId, uint16_t questId);
		void playerSay(uint32_t playerId, uint16_t channelId, SpeakClasses type,
                      const std::string& receiver, const std::string& text);
		void playerChangeOutfit(uint32_t playerId, Outfit_t outfit);
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

		void parsePlayerExtendedOpcode(uint32_t playerId, uint8_t opcode, const std::string& buffer);

		static void updatePremium(account::Account& account);

		void cleanup();
		void shutdown();
		void dieSafely(std::string errorMsg);
		void ReleaseCreature(Creature* creature);
		void ReleaseItem(Item* item);
		void addBestiaryList(uint16_t raceid, std::string name);
		const std::map<uint16_t, std::string>& getBestiaryList() const { return BestiaryList; }

		void setBoostedName(std::string name) {
			boostedCreature = name;
		}

		std::string getBoostedMonsterName() const {
			return boostedCreature;
		}

		bool canThrowObjectTo(const Position& fromPos, const Position& toPos, bool checkLineOfSight = true,
                              int32_t rangex = Map::maxClientViewportX, int32_t rangey = Map::maxClientViewportY) const;
		bool isSightClear(const Position& fromPos, const Position& toPos, bool sameFloor) const;

		void changeSpeed(Creature* creature, int32_t varSpeedDelta);
		void changePlayerSpeed(Player& player, int32_t varSpeedDelta);
		void internalCreatureChangeOutfit(Creature* creature, const Outfit_t& oufit);
		void internalCreatureChangeVisible(Creature* creature, bool visible);
		void changeLight(const Creature* creature);
		void updateCreatureIcon(const Creature* creature);
		void reloadCreature(const Creature* creature);
		void updateCreatureSkull(const Creature* player);
		void updatePlayerShield(Player* player);
		void updateCreatureType(Creature* creature);
		void updateCreatureWalkthrough(const Creature* creature);

		GameState_t getGameState() const;
		void setGameState(GameState_t newState);
		void saveGameState();

		// Events
		void checkCreatureWalk(uint32_t creatureId);
		void updateCreatureWalk(uint32_t creatureId);
		void checkCreatureAttack(uint32_t creatureId);
		void checkCreatures(size_t index);
		void checkLight();

		bool combatBlockHit(CombatDamage& damage, Creature* attacker, Creature* target, bool checkDefense, bool checkArmor, bool field);

		void combatGetTypeInfo(CombatType_t combatType, Creature* target, TextColor_t& color, uint8_t& effect);

		bool combatChangeHealth(Creature* attacker, Creature* target, CombatDamage& damage, bool isEvent = false);
		bool combatChangeMana(Creature* attacker, Creature* target, CombatDamage& damage);

		// Animation help functions
		void addCreatureHealth(const Creature* target);
		static void addCreatureHealth(const SpectatorHashSet& spectators, const Creature* target);
		void addPlayerMana(const Player* target);
		void addPlayerVocation(const Player* target);
		void addMagicEffect(const Position& pos, uint8_t effect);
		static void addMagicEffect(const SpectatorHashSet& spectators, const Position& pos, uint8_t effect);
		void addDistanceEffect(const Position& fromPos, const Position& toPos, uint8_t effect);
		static void addDistanceEffect(const SpectatorHashSet& spectators, const Position& fromPos, const Position& toPos, uint8_t effect);

		int32_t getLightHour() const {
			return lightHour;
		}

		bool loadItemsPrice();

		void loadMotdNum();
		void saveMotdNum() const;
		const std::string& getMotdHash() const { return motdHash; }
		uint32_t getMotdNum() const { return motdNum; }
		void incrementMotdNum() { motdNum++; }

		void sendOfflineTrainingDialog(Player* player);

		const std::map<uint16_t, std::map<uint8_t, uint64_t>>& getItemsPrice() const { return itemsPriceMap; }
		const phmap::flat_hash_map<uint32_t, Player*>& getPlayers() const { return players; }
		const std::map<uint32_t, Monster*>& getMonsters() const {
			return monsters;
		}
		const std::map<uint32_t, Npc*>& getNpcs() const { return npcs; }

		const std::vector<ItemClassification*>& getItemsClassifications() const { return itemsClassifications; }

		void addPlayer(Player* player);
		void removePlayer(Player* player);

		void addNpc(Npc* npc);
		void removeNpc(Npc* npc);

		void addMonster(Monster* npc);
		void removeMonster(Monster* npc);

		Guild* getGuild(uint32_t id) const;
		void addGuild(Guild* guild);
		void removeGuild(uint32_t guildId);
		void decreaseBrowseFieldRef(const Position& pos);

		phmap::flat_hash_map<Tile*, Container*> browseFields;

		void internalRemoveItems(const std::vector<Item*> itemVector, uint32_t amount, bool stackable);

		BedItem* getBedBySleeper(uint32_t guid) const;
		void setBedSleeper(BedItem* bed, uint32_t guid);
		void removeBedSleeper(uint32_t guid);

		Item* getUniqueItem(uint16_t uniqueId);
		bool addUniqueItem(uint16_t uniqueId, Item* item);
		void removeUniqueItem(uint16_t uniqueId);

		bool hasEffect(uint8_t effectId);
		bool hasDistanceEffect(uint8_t effectId);

		Groups groups;
		Map map;
		Mounts mounts;
		Raids raids;
		Canary::protobuf::appearances::Appearances appearances;

		phmap::flat_hash_set<Tile*> getTilesToClean() const {
			return tilesToClean;
		}
		void addTileToClean(Tile* tile) {
			tilesToClean.emplace(tile);
		}
		void removeTileToClean(Tile* tile) {
			tilesToClean.erase(tile);
		}
		void clearTilesToClean() {
			tilesToClean.clear();
		}

		void playerInspectItem(Player* player, const Position& pos);
		void playerInspectItem(Player* player, uint16_t itemId, uint8_t itemCount, bool cyclopedia);

		void addCharmRune(Charm* charm)
		{
			CharmList.push_back(charm);
			CharmList.shrink_to_fit();
		}

		std::vector<Charm*> getCharmList() {
			return CharmList;
		}

		void increasePlayerActiveImbuements(uint32_t playerId) {
			setPlayerActiveImbuements(playerId, playersActiveImbuements[playerId] + 1);
		}

		void decreasePlayerActiveImbuements(uint32_t playerId) {
			setPlayerActiveImbuements(playerId, playersActiveImbuements[playerId] - 1);
		}

		void setPlayerActiveImbuements(uint32_t playerId, uint8_t value) {
			if (value <= 0) {
				playersActiveImbuements.erase(playerId);
				return;
			}
			
			playersActiveImbuements[playerId] = std::min<uint8_t>(255, value);
		}

		uint8_t getPlayerActiveImbuements(uint32_t playerId) {
			return playersActiveImbuements[playerId];
		}

		FILELOADER_ERRORS loadAppearanceProtobuf(const std::string& file);
		bool isMagicEffectRegistered(uint8_t type) const {
			return std::find(registeredMagicEffects.begin(), registeredMagicEffects.end(), type) != registeredMagicEffects.end();
		}

		bool isDistanceEffectRegistered(uint8_t type) const {
			return std::find(registeredDistanceEffects.begin(), registeredDistanceEffects.end(), type) != registeredDistanceEffects.end();
		}

		bool isLookTypeRegistered(uint16_t type) const {
			return std::find(registeredLookTypes.begin(), registeredLookTypes.end(), type) != registeredLookTypes.end();
		}

		void setCreateLuaItems(Position position, uint16_t itemId) {
			mapLuaItemsStored[position] = itemId;
		}

		std::set<uint32_t> getFiendishMonsters() const {
			return fiendishMonsters;
		}

		std::set<uint32_t> getInfluencedMonsters() const {
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

		bool addInfluencedMonster(Monster *monster);
		void sendUpdateCreature(const Creature *creature);

	private:
		std::map<uint32_t, int32_t> forgeMonsterEventIds;
		std::set<uint32_t> fiendishMonsters;
		std::set<uint32_t> influencedMonsters;
		void checkImbuements();
		bool playerSaySpell(Player* player, SpeakClasses type, const std::string& text);
		void playerWhisper(Player* player, const std::string& text);
		bool playerYell(Player* player, const std::string& text);
		bool playerSpeakTo(Player* player, SpeakClasses type, const std::string& receiver, const std::string& text);
		void playerSpeakToNpc(Player* player, const std::string& text);

		phmap::flat_hash_map<uint32_t, Player*> players;
		phmap::flat_hash_map<uint32_t, uint8_t> playersActiveImbuements;
		phmap::flat_hash_map<std::string, Player*> mappedPlayerNames;
		phmap::flat_hash_map<uint32_t, Guild*> guilds;
		phmap::flat_hash_map<uint16_t, Item*> uniqueItems;
		std::map<uint32_t, uint32_t> stages;

		/* Items stored from the lua scripts positions
		 * For example: ActionFunctions::luaActionPosition
		 * This basically works so that the item is created after the map is loaded, because the scripts are loaded before the map is loaded, we will use this table to create items that don't exist in the map natively through each script
		*/
		std::map<Position, uint16_t> mapLuaItemsStored;

		std::map<uint16_t, std::string> BestiaryList;
		std::string boostedCreature = "";

		std::vector<Charm*> CharmList;
		std::vector<Creature*> ToReleaseCreatures;
		std::vector<Creature*> checkCreatureLists[EVENT_CREATURECOUNT];
		std::vector<Item*> ToReleaseItems;

		std::vector<uint8_t> registeredMagicEffects;
		std::vector<uint8_t> registeredDistanceEffects;
		std::vector<uint16_t> registeredLookTypes;

		size_t lastBucket = 0;
		size_t lastImbuedBucket = 0;

		WildcardTreeNode wildcardTree { false };

		std::map<uint32_t, Npc*> npcs;
		std::map<uint32_t, Monster*> monsters;
		std::vector<uint32_t> forgeableMonsters;

		std::map<uint32_t, TeamFinder*> teamFinderMap; // [leaderGUID] = TeamFinder*

		//list of items that are in trading state, mapped to the player
		std::map<Item*, uint32_t> tradeItems;

		std::map<uint32_t, BedItem*> bedSleepersMap;

		phmap::flat_hash_set<Tile*> tilesToClean;

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
		int32_t lightHourDelta = (LIGHT_DAY_LENGTH * (EVENT_LIGHTINTERVAL_MS/1000)) / DAY_LENGTH_SECONDS;

		ServiceManager* serviceManager = nullptr;

		void updatePlayersRecord() const;
		uint32_t playersRecord = 0;

		std::string motdHash;
		uint32_t motdNum = 0;

		std::map<uint16_t, std::map<uint8_t, uint64_t>> itemsPriceMap;
		uint16_t itemsSaleCount;

		std::vector<ItemClassification*> itemsClassifications;
};

constexpr auto g_game = &Game::getInstance;

#endif  // SRC_GAME_GAME_H_
