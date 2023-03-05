/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_SERVER_NETWORK_PROTOCOL_PROTOCOLGAME_H_
#define SRC_SERVER_NETWORK_PROTOCOL_PROTOCOLGAME_H_

#include "server/network/protocol/protocol.h"
#include "creatures/interactions/chat.h"
#include "creatures/creature.h"

class NetworkMessage;
class Player;
class Game;
class House;
class Container;
class Tile;
class Connection;
class Quest;
class ProtocolGame;
class PreySlot;
class TaskHuntingSlot;
class TaskHuntingOption;
using ProtocolGame_ptr = std::shared_ptr<ProtocolGame>;

struct TextMessage {
		TextMessage() = default;
		TextMessage(MessageClasses initType, std::string initText) :
			type(initType), text(std::move(initText)) { }

		MessageClasses type = MESSAGE_STATUS;
		std::string text;
		Position position;
		uint16_t channelId;
		struct
		{
				int32_t value = 0;
				TextColor_t color;
		} primary, secondary;
};

class ProtocolGame final : public Protocol {
	public:
		// Static protocol information.
		enum { SERVER_SENDS_FIRST = true };
		// Not required as we send first.
		enum { PROTOCOL_IDENTIFIER = 0 };
		enum { USE_CHECKSUM = true };

		static const char* protocol_name() {
			return "gameworld protocol";
		}

		explicit ProtocolGame(Connection_ptr initConnection);

		void login(const std::string &name, uint32_t accnumber, OperatingSystem_t operatingSystem);
		void logout(bool displayEffect, bool forced);

		void AddItem(NetworkMessage &msg, const Item* item);
		void AddItem(NetworkMessage &msg, uint16_t id, uint8_t count, uint8_t tier);

		uint16_t getVersion() const {
			return version;
		}

	private:
		// Helpers so we don't need to bind every time
		template <typename Callable, typename... Args>
		void addGameTask(Callable function, Args &&... args);
		template <typename Callable, typename... Args>
		void addGameTaskTimed(uint32_t delay, Callable function, Args &&... args);

		ProtocolGame_ptr getThis() {
			return std::static_pointer_cast<ProtocolGame>(shared_from_this());
		}
		void connect(uint32_t playerId, OperatingSystem_t operatingSystem);
		void disconnectClient(const std::string &message) const;
		void writeToOutputBuffer(const NetworkMessage &msg);

		void release() override;

		void checkCreatureAsKnown(uint32_t id, bool &known, uint32_t &removedKnown);

		bool canSee(int32_t x, int32_t y, int32_t z) const;
		bool canSee(const Creature*) const;
		bool canSee(const Position &pos) const;

		// we have all the parse methods
		void parsePacket(NetworkMessage &msg) override;
		void parsePacketFromDispatcher(NetworkMessage msg, uint8_t recvbyte);
		void onRecvFirstMessage(NetworkMessage &msg) override;
		void onConnect() override;

		// Parse methods
		void parseAutoWalk(NetworkMessage &msg);
		void parseSetOutfit(NetworkMessage &msg);
		void parseSay(NetworkMessage &msg);
		void parseLookAt(NetworkMessage &msg);
		void parseLookInBattleList(NetworkMessage &msg);

		void parseQuickLoot(NetworkMessage &msg);
		void parseLootContainer(NetworkMessage &msg);
		void parseQuickLootBlackWhitelist(NetworkMessage &msg);

		// Depot search
		void sendDepotItems(const ItemsTierCountList &itemMap, uint16_t count);
		void sendCloseDepotSearch();
		void sendDepotSearchResultDetail(uint16_t itemId, uint8_t tier, uint32_t depotCount, const ItemVector &depotItems, uint32_t inboxCount, const ItemVector &inboxItems, uint32_t stashCount);
		void parseOpenDepotSearch();
		void parseCloseDepotSearch();
		void parseDepotSearchItemRequest(NetworkMessage &msg);
		void parseOpenParentContainer(NetworkMessage &msg);
		void parseRetrieveDepotSearch(NetworkMessage &msg);

		void parseInventoryImbuements(NetworkMessage &msg);
		void sendInventoryImbuements(std::map<Slots_t, Item*> items);

		void parseFightModes(NetworkMessage &msg);
		void parseAttack(NetworkMessage &msg);
		void parseFollow(NetworkMessage &msg);

		void sendSessionEndInformation(SessionEndInformations information);

		void sendItemInspection(uint16_t itemId, uint8_t itemCount, const Item* item, bool cyclopedia);
		void parseInspectionObject(NetworkMessage &msg);

		void parseCyclopediaCharacterInfo(NetworkMessage &msg);

		void parseHighscores(NetworkMessage &msg);
		void parseTaskHuntingAction(NetworkMessage &msg);
		void sendHighscoresNoData();
		void sendHighscores(const std::vector<HighscoreCharacter> &characters, uint8_t categoryId, uint32_t vocationId, uint16_t page, uint16_t pages);

		void parseTournamentLeaderboard(NetworkMessage &msg);

		void parseGreet(NetworkMessage &msg);
		void parseBugReport(NetworkMessage &msg);
		void parseDebugAssert(NetworkMessage &msg);
		void parsePreyAction(NetworkMessage &msg);
		void parseSendResourceBalance();
		void parseRuleViolationReport(NetworkMessage &msg);

		void parseBestiarysendRaces();
		void parseBestiarysendCreatures(NetworkMessage &msg);
		void BestiarysendCharms();
		void sendBestiaryEntryChanged(uint16_t raceid);
		void refreshBestiaryTracker(std::list<MonsterType*> trackerList);
		void sendTeamFinderList();
		void sendLeaderTeamFinder(bool reset);
		void createLeaderTeamFinder(NetworkMessage &msg);
		void parsePartyAnalyzerAction(NetworkMessage &msg) const;
		void parseLeaderFinderWindow(NetworkMessage &msg);
		void parseMemberFinderWindow(NetworkMessage &msg);
		void parseSendBuyCharmRune(NetworkMessage &msg);
		void parseBestiarysendMonsterData(NetworkMessage &msg);
		void addBestiaryTrackerList(NetworkMessage &msg);
		void parseObjectInfo(NetworkMessage &msg);

		void parseTeleport(NetworkMessage &msg);
		void parseThrow(NetworkMessage &msg);
		void parseUseItemEx(NetworkMessage &msg);
		void parseUseWithCreature(NetworkMessage &msg);
		void parseUseItem(NetworkMessage &msg);
		void parseCloseContainer(NetworkMessage &msg);
		void parseUpArrowContainer(NetworkMessage &msg);
		void parseUpdateContainer(NetworkMessage &msg);
		void parseTextWindow(NetworkMessage &msg);
		void parseHouseWindow(NetworkMessage &msg);

		void parseLookInShop(NetworkMessage &msg);
		void parsePlayerBuyOnShop(NetworkMessage &msg);
		void parsePlayerSellOnShop(NetworkMessage &msg);

		void parseQuestLine(NetworkMessage &msg);

		void parseInviteToParty(NetworkMessage &msg);
		void parseJoinParty(NetworkMessage &msg);
		void parseRevokePartyInvite(NetworkMessage &msg);
		void parsePassPartyLeadership(NetworkMessage &msg);
		void parseEnableSharedPartyExperience(NetworkMessage &msg);

		void parseToggleMount(NetworkMessage &msg);

		// Imbuements
		void parseApplyImbuement(NetworkMessage &msg);
		void parseClearImbuement(NetworkMessage &msg);
		void parseCloseImbuementWindow(NetworkMessage &msg);

		void parseModalWindowAnswer(NetworkMessage &msg);

		void parseBrowseField(NetworkMessage &msg);
		void parseSeekInContainer(NetworkMessage &msg);

		// trade methods
		void parseRequestTrade(NetworkMessage &msg);
		void parseLookInTrade(NetworkMessage &msg);

		// market methods
		void parseMarketLeave();
		void parseMarketBrowse(NetworkMessage &msg);
		void parseMarketCreateOffer(NetworkMessage &msg);
		void parseMarketCancelOffer(NetworkMessage &msg);
		void parseMarketAcceptOffer(NetworkMessage &msg);

		// VIP methods
		void parseAddVip(NetworkMessage &msg);
		void parseRemoveVip(NetworkMessage &msg);
		void parseEditVip(NetworkMessage &msg);

		void parseRotateItem(NetworkMessage &msg);
		void parseConfigureShowOffSocket(NetworkMessage &msg);
		void parseWrapableItem(NetworkMessage &msg);

		// Channel tabs
		void parseChannelInvite(NetworkMessage &msg);
		void parseChannelExclude(NetworkMessage &msg);
		void parseOpenChannel(NetworkMessage &msg);
		void parseOpenPrivateChannel(NetworkMessage &msg);
		void parseCloseChannel(NetworkMessage &msg);

		// Imbuement info
		void addImbuementInfo(NetworkMessage &msg, uint16_t imbuementId) const;

		// Send functions
		void sendChannelMessage(const std::string &author, const std::string &text, SpeakClasses type, uint16_t channel);
		void sendChannelEvent(uint16_t channelId, const std::string &playerName, ChannelEvent_t channelEvent);
		void sendClosePrivate(uint16_t channelId);
		void sendCreatePrivateChannel(uint16_t channelId, const std::string &channelName);
		void sendChannelsDialog();
		void sendChannel(uint16_t channelId, const std::string &channelName, const UsersMap* channelUsers, const InvitedMap* invitedUsers);
		void sendOpenPrivateChannel(const std::string &receiver);
		void sendExperienceTracker(int64_t rawExp, int64_t finalExp);
		void sendToChannel(const Creature* creature, SpeakClasses type, const std::string &text, uint16_t channelId);
		void sendPrivateMessage(const Player* speaker, SpeakClasses type, const std::string &text);
		void sendIcons(uint32_t icons);
		void sendFYIBox(const std::string &message);

		void openImbuementWindow(Item* item);
		void sendImbuementResult(const std::string message);
		void closeImbuementWindow();

		void sendItemsPrice();

		// Forge System
		void sendForgingData();
		void sendOpenForge();
		void sendForgeError(const ReturnValue returnValue);
		void closeForgeWindow();
		void parseForgeEnter(NetworkMessage &msg);
		void parseForgeBrowseHistory(NetworkMessage &msg);
		void sendForgeFusionItem(
			uint16_t itemId,
			uint8_t tier,
			bool success,
			uint8_t bonus,
			uint8_t coreCount
		);
		void sendTransferItemTier(uint16_t firstItem, uint8_t tier, uint16_t secondItem);
		void sendForgeHistory(uint8_t page);
		void sendForgeSkillStats(NetworkMessage &msg) const;

		void sendBosstiaryData();
		void parseSendBosstiary();
		void parseSendBosstiarySlots();
		void parseBosstiarySlot(NetworkMessage &msg);
		void sendBossPodiumWindow(const Item* podium, const Position &position, uint16_t itemId, uint8_t stackPos);
		void parseSetBossPodium(NetworkMessage &msg) const;
		void sendBosstiaryCooldownTimer();
		void sendBosstiaryEntryChanged(uint32_t bossid);

		void sendWheelOfDestinyGiftOfLifeCooldown();

		void sendDistanceShoot(const Position &from, const Position &to, uint8_t type);
		void sendMagicEffect(const Position &pos, uint8_t type);
		void sendRestingStatus(uint8_t protection);
		void sendCreatureHealth(const Creature* creature);
		void sendPartyCreatureUpdate(const Creature* target);
		void sendPartyCreatureShield(const Creature* target);
		void sendPartyCreatureSkull(const Creature* target);
		void sendPartyCreatureHealth(const Creature* target, uint8_t healthPercent);
		void sendPartyPlayerMana(const Player* target, uint8_t manaPercent);
		void sendPartyCreatureShowStatus(const Creature* target, bool showStatus);
		void sendPartyPlayerVocation(const Player* target);
		void sendPlayerVocation(const Player* target);
		void sendSkills();
		void sendPing();
		void sendPingBack();
		void sendCreatureTurn(const Creature* creature, uint32_t stackpos);
		void sendCreatureSay(const Creature* creature, SpeakClasses type, const std::string &text, const Position* pos = nullptr);

		// Unjust Panel
		void sendUnjustifiedPoints(const uint8_t &dayProgress, const uint8_t &dayLeft, const uint8_t &weekProgress, const uint8_t &weekLeft, const uint8_t &monthProgress, const uint8_t &monthLeft, const uint8_t &skullDuration);

		void sendCancelWalk();
		void sendChangeSpeed(const Creature* creature, uint16_t speed);
		void sendCancelTarget();
		void sendCreatureOutfit(const Creature* creature, const Outfit_t &outfit);
		void sendStats();
		void sendBasicData();
		void sendTextMessage(const TextMessage &message);
		void sendReLoginWindow(uint8_t unfairFightReduction);

		void sendTutorial(uint8_t tutorialId);
		void sendAddMarker(const Position &pos, uint8_t markType, const std::string &desc);

		void sendTournamentLeaderboard();

		void sendCyclopediaCharacterNoData(CyclopediaCharacterInfoType_t characterInfoType, uint8_t errorCode);
		void sendCyclopediaCharacterBaseInformation();
		void sendCyclopediaCharacterGeneralStats();
		void sendCyclopediaCharacterCombatStats();
		void sendCyclopediaCharacterRecentDeaths(uint16_t page, uint16_t pages, const std::vector<RecentDeathEntry> &entries);
		void sendCyclopediaCharacterRecentPvPKills(uint16_t page, uint16_t pages, const std::vector<RecentPvPKillEntry> &entries);
		void sendCyclopediaCharacterAchievements();
		void sendCyclopediaCharacterItemSummary();
		void sendCyclopediaCharacterOutfitsMounts();
		void sendCyclopediaCharacterStoreSummary();
		void sendCyclopediaCharacterInspection();
		void sendCyclopediaCharacterBadges();
		void sendCyclopediaCharacterTitles();

		void sendCreatureWalkthrough(const Creature* creature, bool walkthrough);
		void sendCreatureShield(const Creature* creature);
		void sendCreatureEmblem(const Creature* creature);
		void sendCreatureSkull(const Creature* creature);
		void sendCreatureType(const Creature* creature, uint8_t creatureType);

		void sendShop(Npc* npc);
		void sendCloseShop();
		void sendClientCheck();
		void sendGameNews();
		void sendResourcesBalance(uint64_t money = 0, uint64_t bank = 0, uint64_t preyCards = 0, uint64_t taskHunting = 0, uint64_t forgeDust = 0, uint64_t forgeSliver = 0, uint64_t forgeCores = 0);
		void sendResourceBalance(Resource_t resourceType, uint64_t value);
		void sendSaleItemList(const std::vector<ShopBlock> &shopVector, const std::map<uint16_t, uint16_t> &inventoryMap);
		void sendMarketEnter(uint32_t depotId);
		void updateCoinBalance();
		void sendMarketLeave();
		void sendMarketBrowseItem(uint16_t itemId, const MarketOfferList &buyOffers, const MarketOfferList &sellOffers, uint8_t tier);
		void sendMarketAcceptOffer(const MarketOfferEx &offer);
		void sendMarketBrowseOwnOffers(const MarketOfferList &buyOffers, const MarketOfferList &sellOffers);
		void sendMarketCancelOffer(const MarketOfferEx &offer);
		void sendMarketBrowseOwnHistory(const HistoryMarketOfferList &buyOffers, const HistoryMarketOfferList &sellOffers);
		void sendMarketDetail(uint16_t itemId, uint8_t tier);
		void sendTradeItemRequest(const std::string &traderName, const Item* item, bool ack);
		void sendCloseTrade();
		void updatePartyTrackerAnalyzer(const Party* party);

		void sendTextWindow(uint32_t windowTextId, Item* item, uint16_t maxlen, bool canWrite);
		void sendHouseWindow(uint32_t windowTextId, const std::string &text);
		void sendOutfitWindow();
		void sendPodiumWindow(const Item* podium, const Position &position, uint16_t itemId, uint8_t stackpos);

		void sendUpdatedVIPStatus(uint32_t guid, VipStatus_t newStatus);
		void sendVIP(uint32_t guid, const std::string &name, const std::string &description, uint32_t icon, bool notify, VipStatus_t status);

		void sendPendingStateEntered();
		void sendEnterWorld();

		void sendFightModes();

		void sendCreatureLight(const Creature* creature);
		void sendCreatureIcon(const Creature* creature);
		void sendUpdateCreature(const Creature* creature);
		void sendWorldLight(const LightInfo &lightInfo);
		void sendTibiaTime(int32_t time);

		void sendCreatureSquare(const Creature* creature, SquareColor_t color);

		void sendSpellCooldown(uint16_t spellId, uint32_t time);
		void sendSpellGroupCooldown(SpellGroup_t groupId, uint32_t time);
		void sendUseItemCooldown(uint32_t time);

		void sendCoinBalance();

		void sendPreyTimeLeft(const PreySlot* slot);
		void sendPreyData(const PreySlot* slot);
		void sendPreyPrices();

		// tiles
		void sendMapDescription(const Position &pos);

		void sendAddTileItem(const Position &pos, uint32_t stackpos, const Item* item);
		void sendUpdateTileItem(const Position &pos, uint32_t stackpos, const Item* item);
		void sendRemoveTileThing(const Position &pos, uint32_t stackpos);
		void sendUpdateTile(const Tile* tile, const Position &pos);

		void sendAddCreature(const Creature* creature, const Position &pos, int32_t stackpos, bool isLogin);
		void sendMoveCreature(const Creature* creature, const Position &newPos, int32_t newStackPos, const Position &oldPos, int32_t oldStackPos, bool teleport);

		// containers
		void sendAddContainerItem(uint8_t cid, uint16_t slot, const Item* item);
		void sendUpdateContainerItem(uint8_t cid, uint16_t slot, const Item* item);
		void sendRemoveContainerItem(uint8_t cid, uint16_t slot, const Item* lastItem);

		void sendContainer(uint8_t cid, const Container* container, bool hasParent, uint16_t firstIndex);
		void sendCloseContainer(uint8_t cid);

		// quickloot
		void sendLootContainers();
		void sendLootStats(Item* item, uint8_t count);

		// inventory
		void sendInventoryItem(Slots_t slot, const Item* item);
		void sendInventoryIds();

		// messages
		void sendModalWindow(const ModalWindow &modalWindow);

		// analyzers
		void sendKillTrackerUpdate(Container* corpse, const std::string &name, const Outfit_t creatureOutfit);
		void sendUpdateSupplyTracker(const Item* item);
		void sendUpdateImpactTracker(CombatType_t type, int32_t amount);
		void sendUpdateInputAnalyzer(CombatType_t type, int32_t amount, std::string target);

		// Hazard system
		void reloadHazardSystemIcon(uint16_t reference);

		// Help functions
		// translate a tile to clientreadable format
		void GetTileDescription(const Tile* tile, NetworkMessage &msg);

		// Hotkey equip/dequip item
		void parseHotkeyEquip(NetworkMessage &msg);

		// translate a floor to clientreadable format
		void GetFloorDescription(NetworkMessage &msg, int32_t x, int32_t y, int32_t z, int32_t width, int32_t height, int32_t offset, int32_t &skip);

		// translate a map area to clientreadable format
		void GetMapDescription(int32_t x, int32_t y, int32_t z, int32_t width, int32_t height, NetworkMessage &msg);

		void AddCreature(NetworkMessage &msg, const Creature* creature, bool known, uint32_t remove);
		void AddPlayerStats(NetworkMessage &msg);
		void AddOutfit(NetworkMessage &msg, const Outfit_t &outfit, bool addMount = true);
		void AddPlayerSkills(NetworkMessage &msg);
		void sendBlessStatus();
		void sendPremiumTrigger();
		void sendMessageDialog(const std::string &message);
		void AddWorldLight(NetworkMessage &msg, LightInfo lightInfo);
		void AddCreatureLight(NetworkMessage &msg, const Creature* creature);

		// tiles
		static void RemoveTileThing(NetworkMessage &msg, const Position &pos, uint32_t stackpos);

		void sendTaskHuntingData(const TaskHuntingSlot* slot);

		void MoveUpCreature(NetworkMessage &msg, const Creature* creature, const Position &newPos, const Position &oldPos);
		void MoveDownCreature(NetworkMessage &msg, const Creature* creature, const Position &newPos, const Position &oldPos);

		// shop
		void AddHiddenShopItem(NetworkMessage &msg);
		void AddShopItem(NetworkMessage &msg, const ShopBlock &shopBlock);

		// otclient
		void parseExtendedOpcode(NetworkMessage &msg);

		// reloadCreature
		void reloadCreature(const Creature* creature);

		void getForgeInfoMap(const Item* item, std::map<uint16_t, std::map<uint8_t, uint16_t>> &itemsMap) const;

		friend class Player;

		phmap::flat_hash_set<uint32_t> knownCreatureSet;
		Player* player = nullptr;

		uint32_t eventConnect = 0;
		uint32_t challengeTimestamp = 0;
		uint16_t version = 0;
		int32_t clientVersion = 0;

		uint8_t challengeRandom = 0;

		bool debugAssertSent = false;
		bool acceptPackets = false;

		bool loggedIn = false;
		bool shouldAddExivaRestrictions = false;

		void sendInventory();

		void sendOpenStash();
		void parseStashWithdraw(NetworkMessage &msg);
		void sendSpecialContainersAvailable();
		void addBless();
		void parsePacketDead(uint8_t recvbyte);
};

#endif // SRC_SERVER_NETWORK_PROTOCOL_PROTOCOLGAME_H_
