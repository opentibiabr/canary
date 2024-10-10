/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/functions/core/game/lua_enums.hpp"
#include "enums/forge_conversion.hpp"
#include "enums/player_icons.hpp"

class Creature;
class Player;
class Container;
class Tile;
class Item;
class Position;
class Party;
class Npc;
class ProtocolGame;
class NetworkMessage;
class MonsterType;
class PreySlot;
class TaskHuntingSlot;

struct TextMessage;
struct Achievement;
struct ModalWindow;

struct ViewerInfo {
	std::string name;
	uint32_t id = 0;
};

class Livestream {
public:
	explicit Livestream(std::shared_ptr<ProtocolGame> client);

	void clear(bool clearAll);
	bool checkPassword(const std::string &_password);
	void handle(const std::shared_ptr<ProtocolGame> &client, const std::string &text);
	size_t getLivestreamViewerCount();
	std::vector<std::string> getLivestreamViewers() const;
	std::vector<std::shared_ptr<Player>> getLivestreamViewersByIP(uint32_t ip) const;
	void setKickViewer(const std::vector<std::string> &list);
	const std::vector<std::string> &getLivestreamMutes() const;
	void setMuteViewer(std::vector<std::string> mutes);
	const std::map<std::string, uint32_t, std::less<>> &getLivestreamBans() const;
	void setBanViewer(const std::vector<std::string> &bans);
	bool checkBannedIP(uint32_t ip) const;
	std::shared_ptr<ProtocolGame> getLivestreamOwner() const;
	void setLivestreamOwner(std::shared_ptr<ProtocolGame> client);
	void resetLivestreamOwner();
	std::string getLivestreamPassword() const;
	void setLivestreamPassword(std::string_view value);
	bool isLivestreamBroadcasting() const;
	void setLivestreamBroadcasting(bool value);
	std::string getLivestreamBroadcastTimeString() const;
	void addViewer(const std::shared_ptr<ProtocolGame> &client, bool spy = false);
	void removeViewer(const std::shared_ptr<ProtocolGame> &client, bool spy = false);
	int64_t getLivestreamBroadcastTime() const;
	void setLivestreamBroadcastingTime(int64_t time);
	uint32_t getLivestreamLiveRecord() const;
	void setLivestreamLiveRecord(uint32_t value);
	std::string getLivestreamDescription() const;
	void setLivestreamDescription(std::string_view description);
	uint32_t getViewerId(const std::shared_ptr<ProtocolGame> &client) const;
	// inherited
	void insertLivestreamCaster();
	void removeLivestreamCaster();
	bool canSee(const Position &pos) const;
	uint32_t getIP() const;
	void sendStats();
	void sendPing();
	void logout(bool displayEffect, bool forceLogout);
	void sendAddContainerItem(uint8_t cid, uint16_t slot, const std::shared_ptr<Item> &item);
	void sendUpdateContainerItem(uint8_t cid, uint16_t slot, const std::shared_ptr<Item> &item);
	void sendRemoveContainerItem(uint8_t cid, uint16_t slot, const std::shared_ptr<Item> &lastItem);
	void sendUpdatedVIPStatus(uint32_t guid, VipStatus_t newStatus);
	void sendVIP(uint32_t guid, const std::string &name, const std::string &description, uint32_t icon, bool notify, VipStatus_t status);
	void sendVIPGroups();
	void sendClosePrivate(uint16_t channelId);
	void sendFYIBox(const std::string &message);
	uint32_t getVersion() const;
	void disconnect();
	void sendCreatureSkull(const std::shared_ptr<Creature> &creature) const;
	void sendAddTileItem(const Position &pos, uint32_t stackpos, const std::shared_ptr<Item> &item);
	void sendUpdateTileItem(const Position &pos, uint32_t stackpos, const std::shared_ptr<Item> &item);
	void sendRemoveTileThing(const Position &pos, int32_t stackpos);
	void sendUpdateTileCreature(const Position &pos, uint32_t stackpos, const std::shared_ptr<Creature> &creature);
	void sendUpdateTile(const std::shared_ptr<Tile> &tile, const Position &pos);
	void sendChannelMessage(const std::string &author, uint16_t playerLevel, const std::string &message, SpeakClasses type, uint16_t channel);
	void sendMoveCreature(const std::shared_ptr<Creature> &creature, const Position &newPos, int32_t newStackPos, const Position &oldPos, int32_t oldStackPos, bool teleport);
	void sendCreatureTurn(const std::shared_ptr<Creature> &creature, int32_t stackpos);
	void sendForgeResult(ForgeAction_t actionType, uint16_t leftItemId, uint8_t leftTier, uint16_t rightItemId, uint8_t rightTier, bool success, uint8_t bonus, uint8_t coreCount, bool convergence) const;
	void sendPrivateMessage(const std::shared_ptr<Player> &speaker, SpeakClasses type, const std::string &text);
	void sendCreatureSquare(const std::shared_ptr<Creature> &creature, SquareColor_t color);
	void sendCreatureOutfit(const std::shared_ptr<Creature> &creature, const Outfit_t &outfit);
	void sendCreatureLight(const std::shared_ptr<Creature> &creature);
	void sendCreatureWalkthrough(const std::shared_ptr<Creature> &creature, bool walkthrough);
	void sendCreatureShield(const std::shared_ptr<Creature> &creature);
	void sendContainer(uint8_t cid, const std::shared_ptr<Container> &container, bool hasParent, uint16_t firstIndex);
	void sendInventoryItem(Slots_t slot, const std::shared_ptr<Item> &item);
	void sendCancelMessage(const std::string &msg) const;
	void sendCancelTarget() const;
	void sendCancelWalk() const;
	void sendChangeSpeed(const std::shared_ptr<Creature> &creature, uint16_t newSpeed) const;
	void sendCreatureHealth(const std::shared_ptr<Creature> &creature) const;
	void sendDistanceShoot(const Position &from, const Position &to, unsigned char type) const;
	void sendCreatePrivateChannel(uint16_t channelId, const std::string &channelName);
	void sendIcons(const std::unordered_set<PlayerIcon> &iconSet, const IconBakragore iconBakragore) const;
	void sendIconBakragore(const IconBakragore icon);
	void sendMagicEffect(const Position &pos, uint8_t type) const;
	void sendSkills() const;
	void sendTextMessage(MessageClasses mclass, const std::string &message);
	void sendTextMessage(const TextMessage &message) const;
	void sendReLoginWindow(uint8_t unfairFightReduction);
	void sendTextWindow(uint32_t windowTextId, const std::shared_ptr<Item> &item, uint16_t maxlen, bool canWrite) const;
	void sendTextWindow(uint32_t windowTextId, uint32_t itemId, const std::string &text) const;
	void sendToChannel(const std::shared_ptr<Creature> &creature, SpeakClasses type, const std::string &text, uint16_t channelId);
	void sendShop(const std::shared_ptr<Npc> &npc) const;
	void sendSaleItemList(const std::vector<ShopBlock> &shopVector, const std::map<uint16_t, uint16_t> &inventoryMap);
	void sendCloseShop() const;
	void sendTradeItemRequest(const std::string &traderName, const std::shared_ptr<Item> &item, bool ack) const;
	void sendTradeClose() const;
	void sendWorldLight(const LightInfo &lightInfo);
	void sendChannelsDialog();
	void sendOpenPrivateChannel(const std::string &receiver);
	void sendOutfitWindow();
	void sendCloseContainer(uint8_t cid);
	void sendChannel(uint16_t channelId, const std::string &channelName, const std::map<uint32_t, std::shared_ptr<Player>>* channelUsers, const std::map<uint32_t, std::shared_ptr<Player>>* invitedUsers);
	void sendTutorial(uint8_t tutorialId);
	void sendAddMarker(const Position &pos, uint8_t markType, const std::string &desc);
	void sendFightModes();
	void writeToOutputBuffer(const NetworkMessage &message);
	void sendAddCreature(const std::shared_ptr<Creature> &creature, const Position &pos, int32_t stackpos, bool isLogin);
	void sendHouseWindow(uint32_t windowTextId, const std::string &text);
	void sendCloseTrade() const;
	void sendBestiaryCharms();
	void sendImbuementResult(const std::string &message);
	void closeImbuementWindow();
	void sendPodiumWindow(const std::shared_ptr<Item> &podium, const Position &position, uint16_t itemId, uint8_t stackpos);
	void sendCreatureIcon(const std::shared_ptr<Creature> &creature);
	void sendUpdateCreature(const std::shared_ptr<Creature> &creature);
	void sendCreatureType(const std::shared_ptr<Creature> &creature, uint8_t creatureType);
	void sendSpellCooldown(uint16_t spellId, uint32_t time);
	void sendSpellGroupCooldown(SpellGroup_t groupId, uint32_t time);
	void sendUseItemCooldown(uint32_t time);
	void reloadCreature(const std::shared_ptr<Creature> &creature);
	void sendBestiaryEntryChanged(uint16_t raceid);
	void refreshCyclopediaMonsterTracker(const std::unordered_set<std::shared_ptr<MonsterType>> &trackerList, bool isBoss) const;
	void sendClientCheck();
	void sendGameNews();
	void removeMagicEffect(const Position &pos, uint16_t type);
	void sendPingBack();
	void sendBasicData();
	void sendBlessStatus();
	void updatePartyTrackerAnalyzer(const std::shared_ptr<Party> &party);
	void createLeaderTeamFinder(NetworkMessage &msg);
	void sendLeaderTeamFinder(bool reset);
	void sendTeamFinderList();
	void sendCreatureHelpers(uint32_t creatureId, uint16_t helpers);
	void sendChannelEvent(uint16_t channelId, const std::string &playerName, ChannelEvent_t channelEvent);
	void sendDepotItems(const ItemsTierCountList &itemMap, uint16_t count);
	void sendCloseDepotSearch();
	using ItemVector = std::vector<std::shared_ptr<Item>>;
	void sendDepotSearchResultDetail(uint16_t itemId, uint8_t tier, uint32_t depotCount, const ItemVector &depotItems, uint32_t inboxCount, const ItemVector &inboxItems, uint32_t stashCount);
	void sendCoinBalance();
	void sendInventoryIds();
	void sendLootContainers();
	void sendSingleSoundEffect(const Position &pos, SoundEffect_t id, SourceEffect_t source);
	void sendDoubleSoundEffect(const Position &pos, SoundEffect_t mainSoundId, SourceEffect_t mainSource, SoundEffect_t secondarySoundId, SourceEffect_t secondarySource);
	void sendCreatureEmblem(const std::shared_ptr<Creature> &creature) const;
	void sendItemInspection(uint16_t itemId, uint8_t itemCount, const std::shared_ptr<Item> &item, bool cyclopedia);
	void sendCyclopediaCharacterNoData(CyclopediaCharacterInfoType_t characterInfoType, uint8_t errorCode);
	void sendCyclopediaCharacterBaseInformation();
	void sendCyclopediaCharacterGeneralStats();
	void sendCyclopediaCharacterCombatStats();
	void sendCyclopediaCharacterRecentDeaths(uint16_t page, uint16_t pages, const std::vector<RecentDeathEntry> &entries);
	void sendOpenForge();
	void sendForgeError(ReturnValue returnValue);
	void sendForgeHistory(uint8_t page) const;
	void closeForgeWindow() const;
	void sendBosstiaryCooldownTimer() const;
	void sendCyclopediaCharacterRecentPvPKills(
		uint16_t page, uint16_t pages,
		const std::vector<
			RecentPvPKillEntry> &entries
	);
	void sendCyclopediaCharacterAchievements(uint16_t secretsUnlocked, std::vector<std::pair<Achievement, uint32_t>> achievementsUnlocked);
	void sendCyclopediaCharacterItemSummary(const ItemsTierCountList &inventoryItems, const ItemsTierCountList &storeInboxItems, const StashItemList &supplyStashItems, const ItemsTierCountList &depotBoxItems, const ItemsTierCountList &inboxItems);
	void sendCyclopediaCharacterOutfitsMounts();
	void sendCyclopediaCharacterStoreSummary();
	void sendCyclopediaCharacterInspection();
	void sendCyclopediaCharacterBadges();
	void sendCyclopediaCharacterTitles();
	void sendHighscoresNoData();
	void sendHighscores(const std::vector<HighscoreCharacter> &characters, uint8_t categoryId, uint32_t vocationId, uint16_t page, uint16_t pages, uint32_t updateTimer);
	void sendMonsterPodiumWindow(const std::shared_ptr<Item> &podium, const Position &position, uint16_t itemId, uint8_t stackpos);
	void sendBosstiaryEntryChanged(uint32_t bossid);
	void sendInventoryImbuements(const std::map<Slots_t, std::shared_ptr<Item>> &items);
	void sendEnterWorld();
	void sendExperienceTracker(int64_t rawExp, int64_t finalExp);
	void sendItemsPrice();
	void sendForgingData();
	void sendKillTrackerUpdate(const std::shared_ptr<Container> &corpse, const std::string &name, const Outfit_t creatureOutfit);
	void sendMarketLeave();
	void sendMarketBrowseItem(uint16_t itemId, const MarketOfferList &buyOffers, const MarketOfferList &sellOffers, uint8_t tier);
	void sendMarketBrowseOwnOffers(const MarketOfferList &buyOffers, const MarketOfferList &sellOffers);
	void sendMarketBrowseOwnHistory(const HistoryMarketOfferList &buyOffers, const HistoryMarketOfferList &sellOffers);
	void sendMarketDetail(uint16_t itemId, uint8_t tier);
	void sendMarketAcceptOffer(const MarketOfferEx &offer);
	void sendMarketCancelOffer(const MarketOfferEx &offer);
	void sendMessageDialog(const std::string &message);
	void sendOpenStash();
	void sendTakeScreenshot(Screenshot_t screenshotType);
	void sendPartyCreatureUpdate(const std::shared_ptr<Creature> &creature);
	void sendPartyCreatureShield(const std::shared_ptr<Creature> &creature);
	void sendPartyCreatureSkull(const std::shared_ptr<Creature> &creature);
	void sendPartyCreatureHealth(const std::shared_ptr<Creature> &creature, uint8_t healthPercent);
	void sendPartyPlayerMana(const std::shared_ptr<Player> &player, uint8_t manaPercent);
	void sendPartyCreatureShowStatus(const std::shared_ptr<Creature> &creature, bool showStatus);
	void sendPartyPlayerVocation(const std::shared_ptr<Player> &player);
	void sendPlayerVocation(const std::shared_ptr<Player> &player);
	void sendPreyTimeLeft(const std::unique_ptr<PreySlot> &slot);
	void sendResourcesBalance(uint64_t money = 0, uint64_t bank = 0, uint64_t preyCards = 0, uint64_t taskHunting = 0, uint64_t forgeDust = 0, uint64_t forgeSliver = 0, uint64_t forgeCores = 0);
	void sendCreatureReload(const std::shared_ptr<Creature> &creature);
	void sendCreatureChangeOutfit(const std::shared_ptr<Creature> &creature, const Outfit_t &outfit);
	void sendPreyData(const std::unique_ptr<PreySlot> &slot);
	void sendSpecialContainersAvailable();
	void sendTaskHuntingData(const std::unique_ptr<TaskHuntingSlot> &slot);
	void sendTibiaTime(int32_t time);
	void sendUpdateInputAnalyzer(CombatType_t type, int32_t amount, const std::string &target);
	void sendRestingStatus(uint8_t protection);
	void AddItem(NetworkMessage &msg, const std::shared_ptr<Item> &item);
	void AddItem(NetworkMessage &msg, uint16_t id, uint8_t count, uint8_t tier);
	void parseSendBosstiary();
	void parseSendBosstiarySlots();
	void sendLootStats(const std::shared_ptr<Item> &item, uint8_t count);
	void sendUpdateSupplyTracker(const std::shared_ptr<Item> &item);
	void sendUpdateImpactTracker(CombatType_t type, int32_t amount);
	void openImbuementWindow(const std::shared_ptr<Item> &item);
	void sendMarketEnter(uint32_t depotId);
	void sendUnjustifiedPoints(const uint8_t &dayProgress, const uint8_t &dayLeft, const uint8_t &weekProgress, const uint8_t &weekLeft, const uint8_t &monthProgress, const uint8_t &monthLeft, const uint8_t &skullDuration);
	void sendModalWindow(const ModalWindow &modalWindow);
	void sendResourceBalance(Resource_t resourceType, uint64_t value);
	void sendOpenWheelWindow(uint32_t ownerId);
	void sendCreatureSay(const std::shared_ptr<Creature> &creature, SpeakClasses type, const std::string &text, const Position* pos = nullptr);
	void disconnectClient(const std::string &message) const;

	bool isOldProtocol();
	bool isLivestreamViewer() const;

private:
	void processCommand(const std::shared_ptr<ProtocolGame> &client, std::string_view text, std::map<std::shared_ptr<ProtocolGame>, ViewerInfo>::iterator sit);
	void showViewers(const std::shared_ptr<ProtocolGame> &client);
	void changeViewerName(const std::shared_ptr<ProtocolGame> &client, const std::vector<std::string> &CommandParam, std::map<std::shared_ptr<ProtocolGame>, ViewerInfo>::iterator sit);
	bool isNameAvailable(const std::string &name) const;
	void handleChatMessage(const std::string &playerName, const std::shared_ptr<ProtocolGame> &client, const std::string &text);
	void updateViewerName(const std::shared_ptr<ProtocolGame> &client, std::map<std::shared_ptr<ProtocolGame>, ViewerInfo>::iterator sit, const std::string &newName);

	friend class Player;
	std::map<std::shared_ptr<ProtocolGame>, ViewerInfo> m_viewers;
	std::vector<std::string> m_mutes;
	std::map<std::string, uint32_t, std::less<>> m_bans;
	std::shared_ptr<ProtocolGame> m_owner = nullptr;
	std::string m_livestreamCasterPassword;
	std::string m_livestreamCasterDescription;
	bool m_livestreamCasterBroadcast = false;
	int64_t m_livestreamCasterBroadcastTime = 0;
	uint32_t m_livestreamCasterLiveRecord = 0;
	uint32_t m_viewerId = 0;
	uint32_t m_viewerCounter = 0;
};
