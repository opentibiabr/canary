/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#if FEATURE_LIVESTREAM > 0

	#include "creatures/players/livestream/livestream.hpp"

	#include "creatures/players/player.hpp"
	#include "creatures/interactions/chat.hpp"
	#include "config/configmanager.hpp"
	#include "server/network/message/outputmessage.hpp"
	#include "server/network/protocol/protocolgame.hpp"
	#include "creatures/players/achievement/player_achievement.hpp"

Livestream::Livestream(std::shared_ptr<ProtocolGame> client) :
	m_owner(client) { }

Livestream::~Livestream() { }

void Livestream::clear(bool full) {
	for (const auto &[client, _] : m_viewers) {
		client->sendSessionEndInformation(SESSION_END_LOGOUT);
	}

	m_viewers.clear();
	m_mutes.clear();
	removeLivestreamCaster();

	m_viewerId = 0;
	m_viewerCounter = 0;
	if (!full) {
		return;
	}

	m_bans.clear();
	m_livestreamCasterPassword = "";
	m_livestreamCasterBroadcast = false;
	m_livestreamCasterBroadcastTime = 0;
	m_livestreamCasterLiveRecord = 0;
}

bool Livestream::checkPassword(const std::string &_password) {
	if (m_livestreamCasterPassword.empty()) {
		return true;
	}

	std::string t = _password;
	trimString(t);

	if (t.size() != m_livestreamCasterPassword.size()) {
		return false;
	}

	return std::ranges::equal(t, m_livestreamCasterPassword);
}

void Livestream::setKickViewer(std::vector<std::string> list) {
	for (const auto &it : list) {
		for (const auto &[client, clientInfo] : m_viewers) {
			if (asLowerCaseString(clientInfo.first) == it) {
				client->sendSessionEndInformation(SESSION_END_LOGOUT);
			}
		}
	}
}

const std::vector<std::string> &Livestream::getLivrestreamMutes() const {
	return m_mutes;
}

void Livestream::setMuteViewer(std::vector<std::string> mutes) {
	m_mutes = mutes;
}

const std::map<std::string, uint32_t> &Livestream::getLivestreamBans() const {
	return m_bans;
}

void Livestream::setBanViewer(std::vector<std::string> bans) {
	std::vector<std::string>::const_iterator it;
	for (auto bit = m_bans.begin(); bit != m_bans.end();) {
		it = std::find(bans.begin(), bans.end(), bit->first);
		if (it == bans.end()) {
			m_bans.erase(bit++);
		} else {
			++bit;
		}
	}

	for (it = bans.begin(); it != bans.end(); ++it) {
		for (const auto &[client, clientInfo] : m_viewers) {
			if (asLowerCaseString(clientInfo.first) != *it) {
				continue;
			}

			m_bans[*it] = client->getIP();
			client->sendSessionEndInformation(SESSION_END_LOGOUT);
		}
	}
}

bool Livestream::checkBannedIP(uint32_t ip) const {
	for (const auto &it : m_bans) {
		if (it.second == ip) {
			return true;
		}
	}

	return false;
}

std::shared_ptr<ProtocolGame> Livestream::getLivestreamOwner() const {
	return m_owner;
}

void Livestream::setLivestreamOwner(std::shared_ptr<ProtocolGame> client) {
	m_owner = client;
}

void Livestream::resetLivestreamOwner() {
	m_owner.reset();
}

std::string Livestream::getLivestreamPassword() const {
	return m_livestreamCasterPassword;
}

void Livestream::setLivestreamPassword(const std::string &value) {
	m_livestreamCasterPassword = value;
}

bool Livestream::isLivestreamBroadcasting() const {
	return m_livestreamCasterBroadcast;
}

void Livestream::setLivestreamBroadcasting(bool value) {
	m_livestreamCasterBroadcast = value;
}

std::string Livestream::getLivestreamBroadcastTimeString() const {
	int64_t seconds = getLivestreamBroadcastTime() / 1000;
	uint16_t hour = floor(seconds / 60 / 60 % 24);
	uint16_t minute = floor(seconds / 60 % 60);
	uint16_t second = floor(seconds % 60);

	return fmt::format("{} hours, {} minutes and {} seconds", hour, minute, second);
}

int64_t Livestream::getLivestreamBroadcastTime() const {
	return OTSYS_TIME() - m_livestreamCasterBroadcastTime;
}

void Livestream::setLivestreamBroadcastingTime(int64_t time) {
	m_livestreamCasterBroadcastTime = time;
}

uint32_t Livestream::getLivestreamLiveRecord() const {
	return m_livestreamCasterLiveRecord;
}

void Livestream::setLivestreamLiveRecord(uint32_t value) {
	m_livestreamCasterLiveRecord = value;
}

std::string Livestream::getLivestreamDescription() const {
	return m_livestreamCasterDescription;
}

void Livestream::setLivestreamDescription(const std::string &desc) {
	m_livestreamCasterDescription = desc;
}

uint32_t Livestream::getViewerId(std::shared_ptr<ProtocolGame> client) const {
	auto it = m_viewers.find(client);
	if (it != m_viewers.end()) {
		return it->second.second;
	}
	return 0;
}

// Inherited
void Livestream::insertLivestreamCaster() {
	if (m_owner) {
		m_owner->insertLivestreamCaster();
	}
}

void Livestream::removeLivestreamCaster() {
	if (m_owner) {
		m_owner->removeLivestreamCaster();
	}
}

bool Livestream::canSee(const Position &pos) const {
	if (m_owner) {
		return m_owner->canSee(pos);
	}

	return false;
}

uint32_t Livestream::getIP() const {
	if (m_owner) {
		return m_owner->getIP();
	}

	return 0;
}

void Livestream::sendStats() {
	if (m_owner) {
		m_owner->sendStats();

		for (const auto &it : m_viewers) {
			it.first->sendStats();
		}
	}
}

void Livestream::sendPing() {
	if (m_owner) {
		m_owner->sendPing();

		for (const auto &it : m_viewers) {
			it.first->sendPing();
		}
	}
}

void Livestream::logout(bool displayEffect, bool forceLogout) {
	if (m_owner) {
		m_owner->logout(displayEffect, forceLogout);
	}
}

void Livestream::sendAddContainerItem(uint8_t cid, uint16_t slot, std::shared_ptr<Item> item) {
	if (m_owner) {
		m_owner->sendAddContainerItem(cid, slot, item);

		for (const auto &it : m_viewers) {
			it.first->sendAddContainerItem(cid, slot, item);
		}
	}
}

void Livestream::sendUpdateContainerItem(uint8_t cid, uint16_t slot, std::shared_ptr<Item> item) {
	if (m_owner) {
		m_owner->sendUpdateContainerItem(cid, slot, item);

		for (const auto &it : m_viewers) {
			it.first->sendUpdateContainerItem(cid, slot, item);
		}
	}
}

void Livestream::sendRemoveContainerItem(uint8_t cid, uint16_t slot, std::shared_ptr<Item> lastItem) {
	if (m_owner) {
		m_owner->sendRemoveContainerItem(cid, slot, lastItem);

		for (const auto &it : m_viewers) {
			it.first->sendRemoveContainerItem(cid, slot, lastItem);
		}
	}
}

void Livestream::sendUpdatedVIPStatus(uint32_t guid, VipStatus_t newStatus) {
	if (m_owner) {
		m_owner->sendUpdatedVIPStatus(guid, newStatus);
	}
}

void Livestream::sendVIP(uint32_t guid, const std::string &name, const std::string &description, uint32_t icon, bool notify, VipStatus_t status) {
	if (m_owner) {
		m_owner->sendVIP(guid, name, description, icon, notify, status);
	}
}

void Livestream::sendVIPGroups() {
	if (m_owner) {
		m_owner->sendVIPGroups();
	}
}

void Livestream::sendClosePrivate(uint16_t channelId) {
	if (m_owner) {
		m_owner->sendClosePrivate(channelId);
	}
}

void Livestream::sendFYIBox(const std::string &message) {
	if (m_owner) {
		m_owner->sendFYIBox(message);
	}
}

uint32_t Livestream::getVersion() const {
	if (m_owner) {
		return m_owner->getVersion();
	}

	return 0;
}

void Livestream::disconnect() {
	if (m_owner) {
		m_owner->sendSessionEndInformation(SESSION_END_LOGOUT);
	}
}

void Livestream::sendCreatureSkull(const std::shared_ptr<Creature> &creature) const {
	if (m_owner) {
		m_owner->sendCreatureSkull(creature);

		for (const auto &it : m_viewers) {
			it.first->sendCreatureSkull(creature);
		}
	}
}

void Livestream::sendAddTileItem(const Position &pos, uint32_t stackpos, std::shared_ptr<Item> item) {
	if (m_owner) {
		m_owner->sendAddTileItem(pos, stackpos, item);

		for (const auto &it : m_viewers) {
			it.first->sendAddTileItem(pos, stackpos, item);
		}
	}
}

void Livestream::sendUpdateTileItem(const Position &pos, uint32_t stackpos, std::shared_ptr<Item> item) {
	if (m_owner) {
		m_owner->sendUpdateTileItem(pos, stackpos, item);

		for (const auto &it : m_viewers) {
			it.first->sendUpdateTileItem(pos, stackpos, item);
		}
	}
}

void Livestream::sendRemoveTileThing(const Position &pos, int32_t stackpos) {
	if (m_owner) {
		m_owner->sendRemoveTileThing(pos, stackpos);

		for (const auto &it : m_viewers) {
			it.first->sendRemoveTileThing(pos, stackpos);
		}
	}
}

void Livestream::sendUpdateTileCreature(const Position &pos, uint32_t stackpos, const std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->sendUpdateTileCreature(pos, stackpos, creature);

		for (const auto &it : m_viewers) {
			it.first->sendUpdateTileCreature(pos, stackpos, creature);
		}
	}
}

void Livestream::sendUpdateTile(std::shared_ptr<Tile> tile, const Position &pos) {
	if (m_owner) {
		m_owner->sendUpdateTile(tile, pos);

		for (const auto &it : m_viewers) {
			it.first->sendUpdateTile(tile, pos);
		}
	}
}

void Livestream::sendChannelMessage(const std::string &author, const std::string &message, SpeakClasses type, uint16_t channel) {
	if (m_owner) {
		m_owner->sendChannelMessage(author, message, type, channel);

		for (const auto &it : m_viewers) {
			it.first->sendChannelMessage(author, message, type, channel);
		}
	}
}

void Livestream::sendMoveCreature(std::shared_ptr<Creature> creature, const Position &newPos, int32_t newStackPos, const Position &oldPos, int32_t oldStackPos, bool teleport) {
	if (m_owner) {
		m_owner->sendMoveCreature(creature, newPos, newStackPos, oldPos, oldStackPos, teleport);

		for (const auto &it : m_viewers) {
			it.first->sendMoveCreature(creature, newPos, newStackPos, oldPos, oldStackPos, teleport);
		}
	}
}

void Livestream::sendCreatureTurn(std::shared_ptr<Creature> creature, int32_t stackpos) {
	if (m_owner) {
		m_owner->sendCreatureTurn(creature, stackpos);

		for (const auto &it : m_viewers) {
			it.first->sendCreatureTurn(creature, stackpos);
		}
	}
}

void Livestream::sendForgeResult(ForgeAction_t actionType, uint16_t leftItemId, uint8_t leftTier, uint16_t rightItemId, uint8_t rightTier, bool success, uint8_t bonus, uint8_t coreCount, bool convergence) const {
	if (m_owner) {
		m_owner->sendForgeResult(actionType, leftItemId, leftTier, rightItemId, rightTier, success, bonus, coreCount, convergence);
	}
}

void Livestream::sendPrivateMessage(std::shared_ptr<Player> speaker, SpeakClasses type, const std::string &text) {
	if (m_owner) {
		m_owner->sendPrivateMessage(speaker, type, text);
	}
}

void Livestream::sendCreatureSquare(std::shared_ptr<Creature> creature, SquareColor_t color) {
	if (m_owner) {
		m_owner->sendCreatureSquare(creature, color);

		for (const auto &it : m_viewers) {
			it.first->sendCreatureSquare(creature, color);
		}
	}
}

void Livestream::sendCreatureOutfit(std::shared_ptr<Creature> creature, const Outfit_t &outfit) {
	if (m_owner) {
		m_owner->sendCreatureOutfit(creature, outfit);

		for (const auto &it : m_viewers) {
			it.first->sendCreatureOutfit(creature, outfit);
		}
	}
}

void Livestream::sendCreatureLight(std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->sendCreatureLight(creature);

		for (const auto &it : m_viewers) {
			it.first->sendCreatureLight(creature);
		}
	}
}

void Livestream::sendCreatureWalkthrough(std::shared_ptr<Creature> creature, bool walkthrough) {
	if (m_owner) {
		m_owner->sendCreatureWalkthrough(creature, walkthrough);

		for (const auto &it : m_viewers) {
			it.first->sendCreatureWalkthrough(creature, walkthrough);
		}
	}
}

void Livestream::sendCreatureShield(std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->sendCreatureShield(creature);

		for (const auto &it : m_viewers) {
			it.first->sendCreatureShield(creature);
		}
	}
}

void Livestream::sendContainer(uint8_t cid, std::shared_ptr<Container> container, bool hasParent, uint16_t firstIndex) {
	if (m_owner) {
		m_owner->sendContainer(cid, container, hasParent, firstIndex);

		for (const auto &it : m_viewers) {
			it.first->sendContainer(cid, container, hasParent, firstIndex);
		}
	}
}

void Livestream::sendInventoryItem(Slots_t slot, std::shared_ptr<Item> item) {
	if (m_owner) {
		m_owner->sendInventoryItem(slot, item);

		for (const auto &it : m_viewers) {
			it.first->sendInventoryItem(slot, item);
		}
	}
}

void Livestream::sendCancelMessage(const std::string &msg) const {
	if (m_owner) {
		m_owner->sendTextMessage(TextMessage(MESSAGE_FAILURE, msg));

		for (const auto &it : m_viewers) {
			it.first->sendTextMessage(TextMessage(MESSAGE_FAILURE, msg));
		}
	}
}

void Livestream::sendCancelTarget() const {
	if (m_owner) {
		m_owner->sendCancelTarget();

		for (const auto &it : m_viewers) {
			it.first->sendCancelTarget();
		}
	}
}

void Livestream::sendCancelWalk() const {
	if (m_owner) {
		m_owner->sendCancelWalk();

		for (const auto &it : m_viewers) {
			it.first->sendCancelWalk();
		}
	}
}

void Livestream::sendChangeSpeed(std::shared_ptr<Creature> creature, uint32_t newSpeed) const {
	if (m_owner) {
		m_owner->sendChangeSpeed(creature, newSpeed);

		for (const auto &it : m_viewers) {
			it.first->sendChangeSpeed(creature, newSpeed);
		}
	}
}

void Livestream::sendCreatureHealth(std::shared_ptr<Creature> creature) const {
	if (m_owner) {
		m_owner->sendCreatureHealth(creature);

		for (const auto &it : m_viewers) {
			it.first->sendCreatureHealth(creature);
		}
	}
}

void Livestream::sendDistanceShoot(const Position &from, const Position &to, unsigned char type) const {
	if (m_owner) {
		m_owner->sendDistanceShoot(from, to, type);

		for (const auto &it : m_viewers) {
			it.first->sendDistanceShoot(from, to, type);
		}
	}
}

void Livestream::sendCreatePrivateChannel(uint16_t channelId, const std::string &channelName) {
	if (m_owner) {
		m_owner->sendCreatePrivateChannel(channelId, channelName);
	}
}

void Livestream::sendIcons(const std::unordered_set<PlayerIcon> &iconSet, const IconBakragore iconBakragore) const {
	if (m_owner) {
		m_owner->sendIcons(iconSet, iconBakragore);

		for (const auto &it : m_viewers) {
			it.first->sendIcons(iconSet, iconBakragore);

			std::unordered_set<PlayerIcon> iconSet;
			iconSet.insert(PlayerIcon::Rooted);
			it.first->sendIcons(iconSet, IconBakragore::None);
		}
	}
}

void Livestream::sendIconBakragore(const IconBakragore icon) {
	if (!m_owner) {
		return;
	}

	m_owner->sendIconBakragore(icon);
}

void Livestream::sendMagicEffect(const Position &pos, uint8_t type) const {
	if (m_owner) {
		m_owner->sendMagicEffect(pos, type);

		for (const auto &it : m_viewers) {
			it.first->sendMagicEffect(pos, type);
		}
	}
}

void Livestream::sendSkills() const {
	if (m_owner) {
		m_owner->sendSkills();
	}
}

void Livestream::sendTextMessage(MessageClasses mclass, const std::string &message) {
	if (m_owner) {
		m_owner->sendTextMessage(TextMessage(mclass, message));

		for (const auto &it : m_viewers) {
			it.first->sendTextMessage(TextMessage(mclass, message));
		}
	}
}

void Livestream::sendTextMessage(const TextMessage &message) const {
	if (m_owner) {
		m_owner->sendTextMessage(message);

		for (const auto &it : m_viewers) {
			it.first->sendTextMessage(message);
		}
	}
}

void Livestream::sendReLoginWindow(uint8_t unfairFightReduction) {
	if (m_owner) {
		m_owner->sendReLoginWindow(unfairFightReduction);
	}
}

void Livestream::sendTextWindow(uint32_t windowTextId, std::shared_ptr<Item> item, uint16_t maxlen, bool canWrite) const {
	if (m_owner) {
		m_owner->sendTextWindow(windowTextId, item, maxlen, canWrite);
	}
}

void Livestream::sendTextWindow(uint32_t windowTextId, uint32_t itemId, const std::string &text) const {
	if (m_owner) {
		m_owner->sendTextWindow(windowTextId, itemId, text);
	}
}

void Livestream::sendToChannel(std::shared_ptr<Creature> creature, SpeakClasses type, const std::string &text, uint16_t channelId) {
	if (m_owner) {
		m_owner->sendToChannel(creature, type, text, channelId);
		for (const auto &it : m_viewers) {
			it.first->sendToChannel(creature, type, text, channelId);
		}
	}
}

void Livestream::sendShop(std::shared_ptr<Npc> npc) const {
	if (m_owner) {
		m_owner->sendShop(npc);
	}
}

void Livestream::sendSaleItemList(const std::vector<ShopBlock> &shopVector, const std::map<uint16_t, uint16_t> &inventoryMap) {
	if (m_owner) {
		m_owner->sendSaleItemList(shopVector, inventoryMap);
	}
}

void Livestream::sendCloseShop() const {
	if (m_owner) {
		m_owner->sendCloseShop();
	}
}

void Livestream::sendTradeItemRequest(const std::string &traderName, std::shared_ptr<Item> item, bool ack) const {
	if (m_owner) {
		m_owner->sendTradeItemRequest(traderName, item, ack);
	}
}

void Livestream::sendTradeClose() const {
	if (m_owner) {
		m_owner->sendCloseTrade();
	}
}

void Livestream::sendWorldLight(const LightInfo &lightInfo) {
	if (m_owner) {
		m_owner->sendWorldLight(lightInfo);

		for (const auto &it : m_viewers) {
			it.first->sendWorldLight(lightInfo);
		}
	}
}

void Livestream::sendChannelsDialog() {
	if (m_owner) {
		m_owner->sendChannelsDialog();
	}
}

void Livestream::sendOpenPrivateChannel(const std::string &receiver) {
	if (m_owner) {
		m_owner->sendOpenPrivateChannel(receiver);
	}
}

void Livestream::sendOutfitWindow() {
	if (m_owner) {
		m_owner->sendOutfitWindow();
	}
}

void Livestream::sendCloseContainer(uint8_t cid) {
	if (m_owner) {
		m_owner->sendCloseContainer(cid);

		for (const auto &it : m_viewers) {
			it.first->sendCloseContainer(cid);
		}
	}
}

void Livestream::sendChannel(uint16_t channelId, const std::string &channelName, const std::map<uint32_t, std::shared_ptr<Player>>* channelUsers, const std::map<uint32_t, std::shared_ptr<Player>>* invitedUsers) {
	if (m_owner) {
		m_owner->sendChannel(channelId, channelName, channelUsers, invitedUsers);
	}
}

void Livestream::sendTutorial(uint8_t tutorialId) {
	if (m_owner) {
		m_owner->sendTutorial(tutorialId);
	}
}

void Livestream::sendAddMarker(const Position &pos, uint8_t markType, const std::string &desc) {
	if (m_owner) {
		m_owner->sendAddMarker(pos, markType, desc);
	}
}

void Livestream::sendFightModes() {
	if (m_owner) {
		m_owner->sendFightModes();
	}
}

void Livestream::writeToOutputBuffer(const NetworkMessage &message) {
	if (m_owner) {
		m_owner->writeToOutputBuffer(message);

		for (const auto &it : m_viewers) {
			it.first->writeToOutputBuffer(message);
		}
	}
}

void Livestream::sendAddCreature(std::shared_ptr<Creature> creature, const Position &pos, int32_t stackpos, bool isLogin) {
	if (m_owner) {
		m_owner->sendAddCreature(creature, pos, stackpos, isLogin);

		for (const auto &it : m_viewers) {
			it.first->sendAddCreature(creature, pos, stackpos, isLogin);
		}
	}
}

void Livestream::sendHouseWindow(uint32_t windowTextId, const std::string &text) {
	if (m_owner) {
		m_owner->sendHouseWindow(windowTextId, text);
	}
}

void Livestream::sendCloseTrade() const {
	if (m_owner) {
		m_owner->sendCloseTrade();
	}
}

void Livestream::sendBestiaryCharms() {
	if (m_owner) {
		m_owner->sendBestiaryCharms();
	}
}

void Livestream::sendImbuementResult(const std::string message) {
	if (m_owner) {
		m_owner->sendImbuementResult(message);
	}
}

void Livestream::closeImbuementWindow() {
	if (m_owner) {
		m_owner->closeImbuementWindow();
	}
}

void Livestream::sendPodiumWindow(std::shared_ptr<Item> podium, const Position &position, uint16_t itemId, uint8_t stackpos) {
	if (m_owner) {
		m_owner->sendPodiumWindow(podium, position, itemId, stackpos);
	}
}

void Livestream::sendCreatureIcon(std::shared_ptr<Creature> creature) {
	if (m_owner && !m_owner->oldProtocol) {
		m_owner->sendCreatureIcon(creature);
	}
}

void Livestream::sendUpdateCreature(std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->sendUpdateCreature(creature);
	}
}

void Livestream::sendCreatureType(std::shared_ptr<Creature> creature, uint8_t creatureType) {
	if (m_owner) {
		m_owner->sendCreatureType(creature, creatureType);
	}
}

void Livestream::sendSpellCooldown(uint16_t spellId, uint32_t time) {
	if (m_owner) {
		m_owner->sendSpellCooldown(spellId, time);
	}
}

void Livestream::sendSpellGroupCooldown(SpellGroup_t groupId, uint32_t time) {
	if (m_owner) {
		m_owner->sendSpellGroupCooldown(groupId, time);
	}
}

void Livestream::sendUseItemCooldown(uint32_t time) {
	if (m_owner) {
		m_owner->sendUseItemCooldown(time);
	}
}

void Livestream::reloadCreature(std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->reloadCreature(creature);
	}
}

void Livestream::sendBestiaryEntryChanged(uint16_t raceid) {
	if (m_owner) {
		m_owner->sendBestiaryEntryChanged(raceid);
	}
}

void Livestream::refreshCyclopediaMonsterTracker(const std::unordered_set<std::shared_ptr<MonsterType>> &trackerList, bool isBoss) const {
	if (m_owner) {
		m_owner->refreshCyclopediaMonsterTracker(trackerList, isBoss);
	}
}

void Livestream::sendClientCheck() {
	if (m_owner) {
		m_owner->sendClientCheck();
	}
}

void Livestream::sendGameNews() {
	if (m_owner) {
		m_owner->sendGameNews();
	}
}

void Livestream::removeMagicEffect(const Position &pos, uint16_t type) {
	if (m_owner) {
		m_owner->removeMagicEffect(pos, type);
	}
}

void Livestream::sendPingBack() {
	if (m_owner) {
		m_owner->sendPingBack();

		for (const auto &it : m_viewers) {
			it.first->sendPingBack();
		}
	}
}

void Livestream::sendBasicData() {
	if (m_owner) {
		m_owner->sendBasicData();
	}
}

void Livestream::sendBlessStatus() {
	if (m_owner) {
		m_owner->sendBlessStatus();
	}
}

void Livestream::updatePartyTrackerAnalyzer(const std::shared_ptr<Party> party) {
	if (m_owner && party) {
		m_owner->updatePartyTrackerAnalyzer(party);
	}
}

void Livestream::createLeaderTeamFinder(NetworkMessage &msg) {
	if (m_owner) {
		m_owner->createLeaderTeamFinder(msg);
	}
}

void Livestream::sendLeaderTeamFinder(bool reset) {
	if (m_owner) {
		m_owner->sendLeaderTeamFinder(reset);
	}
}

void Livestream::sendTeamFinderList() {
	if (m_owner) {
		m_owner->sendTeamFinderList();
	}
}

void Livestream::sendCreatureHelpers(uint32_t creatureId, uint16_t helpers) {
	if (m_owner) {
		m_owner->sendCreatureHelpers(creatureId, helpers);
	}
}

void Livestream::sendChannelEvent(uint16_t channelId, const std::string &playerName, ChannelEvent_t channelEvent) {
	if (m_owner) {
		m_owner->sendChannelEvent(channelId, playerName, channelEvent);
	}
}

void Livestream::sendDepotItems(const ItemsTierCountList &itemMap, uint16_t count) {
	if (m_owner) {
		m_owner->sendDepotItems(itemMap, count);
	}
}

void Livestream::sendCloseDepotSearch() {
	if (m_owner) {
		m_owner->sendCloseDepotSearch();
	}
}

using ItemVector = std::vector<std::shared_ptr<Item>>;
void Livestream::sendDepotSearchResultDetail(uint16_t itemId, uint8_t tier, uint32_t depotCount, const ItemVector &depotItems, uint32_t inboxCount, const ItemVector &inboxItems, uint32_t stashCount) {
	if (m_owner) {
		m_owner->sendDepotSearchResultDetail(itemId, tier, depotCount, depotItems, inboxCount, inboxItems, stashCount);
	}
}

void Livestream::sendCoinBalance() {
	if (m_owner) {
		m_owner->sendCoinBalance();
	}
}

void Livestream::sendInventoryIds() {
	if (m_owner) {
		m_owner->sendInventoryIds();
	}
}

void Livestream::sendLootContainers() {
	if (m_owner) {
		m_owner->sendLootContainers();
	}
}

void Livestream::sendSingleSoundEffect(const Position &pos, SoundEffect_t id, SourceEffect_t source) {
	if (m_owner) {
		m_owner->sendSingleSoundEffect(pos, id, source);
	}
}

void Livestream::sendDoubleSoundEffect(const Position &pos, SoundEffect_t mainSoundId, SourceEffect_t mainSource, SoundEffect_t secondarySoundId, SourceEffect_t secondarySource) {
	if (m_owner) {
		m_owner->sendDoubleSoundEffect(pos, mainSoundId, mainSource, secondarySoundId, secondarySource);
	}
}

void Livestream::sendCreatureEmblem(const std::shared_ptr<Creature> &creature) const {
	if (m_owner) {
		m_owner->sendCreatureEmblem(creature);
	}
}

void Livestream::sendItemInspection(uint16_t itemId, uint8_t itemCount, std::shared_ptr<Item> item, bool cyclopedia) {
	if (m_owner) {
		m_owner->sendItemInspection(itemId, itemCount, item, cyclopedia);
	}
}

void Livestream::sendCyclopediaCharacterNoData(CyclopediaCharacterInfoType_t characterInfoType, uint8_t errorCode) {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterNoData(characterInfoType, errorCode);
	}
}

void Livestream::sendCyclopediaCharacterBaseInformation() {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterBaseInformation();
	}
}

void Livestream::sendCyclopediaCharacterGeneralStats() {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterGeneralStats();
	}
}

void Livestream::sendCyclopediaCharacterCombatStats() {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterCombatStats();
	}
}

void Livestream::sendCyclopediaCharacterRecentDeaths(uint16_t page, uint16_t pages, const std::vector<RecentDeathEntry> &entries) {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterRecentDeaths(page, pages, entries);
	}
}

void Livestream::sendOpenForge() {
	if (m_owner) {
		m_owner->sendOpenForge();
	}
}

void Livestream::sendForgeError(ReturnValue returnValue) {
	if (m_owner) {
		m_owner->sendForgeError(returnValue);
	}
}

void Livestream::sendForgeHistory(uint8_t page) const {
	if (m_owner) {
		m_owner->sendForgeHistory(page);
	}
}

void Livestream::closeForgeWindow() const {
	if (m_owner) {
		m_owner->closeForgeWindow();
	}
}

void Livestream::sendBosstiaryCooldownTimer() const {
	if (m_owner) {
		m_owner->sendBosstiaryCooldownTimer();
	}
}

void Livestream::sendCyclopediaCharacterRecentPvPKills(uint16_t page, uint16_t pages, const std::vector<RecentPvPKillEntry> &entries) {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterRecentPvPKills(page, pages, entries);
	}
}

void Livestream::sendCyclopediaCharacterAchievements(int16_t secretsUnlocked, std::vector<std::pair<Achievement, uint32_t>> achievementsUnlocked) {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterAchievements(secretsUnlocked, achievementsUnlocked);
	}
}

void Livestream::sendCyclopediaCharacterItemSummary(const ItemsTierCountList &inventoryItems, const ItemsTierCountList &storeInboxItems, const StashItemList &supplyStashItems, const ItemsTierCountList &depotBoxItems, const ItemsTierCountList &inboxItems) {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterItemSummary(inventoryItems, storeInboxItems, supplyStashItems, depotBoxItems, inboxItems);
	}
}

void Livestream::sendCyclopediaCharacterOutfitsMounts() {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterOutfitsMounts();
	}
}

void Livestream::sendCyclopediaCharacterStoreSummary() {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterStoreSummary();
	}
}

void Livestream::sendCyclopediaCharacterInspection() {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterInspection();
	}
}

void Livestream::sendCyclopediaCharacterBadges() {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterBadges();
	}
}

void Livestream::sendCyclopediaCharacterTitles() {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterTitles();
	}
}

void Livestream::sendHighscoresNoData() {
	if (m_owner) {
		m_owner->sendHighscoresNoData();
	}
}

void Livestream::sendHighscores(const std::vector<HighscoreCharacter> &characters, uint8_t categoryId, uint32_t vocationId, uint16_t page, uint16_t pages, uint32_t updateTimer) {
	if (m_owner) {
		m_owner->sendHighscores(characters, categoryId, vocationId, page, pages, updateTimer);
	}
}

void Livestream::sendMonsterPodiumWindow(std::shared_ptr<Item> podium, const Position &position, uint16_t itemId, uint8_t stackpos) {
	if (m_owner) {
		m_owner->sendMonsterPodiumWindow(podium, position, itemId, stackpos);
	}
}

void Livestream::sendBosstiaryEntryChanged(uint32_t bossid) {
	if (m_owner) {
		m_owner->sendBosstiaryEntryChanged(bossid);
	}
}

void Livestream::sendInventoryImbuements(const std::map<Slots_t, std::shared_ptr<Item>> items) {
	if (m_owner) {
		m_owner->sendInventoryImbuements(items);

		for (const auto &it : m_viewers) {
			it.first->sendInventoryImbuements(items);
		}
	}
}

void Livestream::sendEnterWorld() {
	if (m_owner) {
		m_owner->sendEnterWorld();
	}
}

void Livestream::sendExperienceTracker(int64_t rawExp, int64_t finalExp) {
	if (m_owner) {
		m_owner->sendExperienceTracker(rawExp, finalExp);
	}
}

void Livestream::sendItemsPrice() {
	if (m_owner) {
		m_owner->sendItemsPrice();
	}
}

void Livestream::sendForgingData() {
	if (m_owner) {
		m_owner->sendForgingData();
	}
}

void Livestream::sendKillTrackerUpdate(std::shared_ptr<Container> corpse, const std::string &name, const Outfit_t creatureOutfit) {
	if (m_owner) {
		m_owner->sendKillTrackerUpdate(corpse, name, creatureOutfit);
	}
}

void Livestream::sendMarketLeave() {
	if (m_owner) {
		m_owner->sendMarketLeave();
	}
}

void Livestream::sendMarketBrowseItem(uint16_t itemId, const MarketOfferList &buyOffers, const MarketOfferList &sellOffers, uint8_t tier) {
	if (m_owner) {
		m_owner->sendMarketBrowseItem(itemId, buyOffers, sellOffers, tier);
	}
}

void Livestream::sendMarketBrowseOwnOffers(const MarketOfferList &buyOffers, const MarketOfferList &sellOffers) {
	if (m_owner) {
		m_owner->sendMarketBrowseOwnOffers(buyOffers, sellOffers);
	}
}

void Livestream::sendMarketBrowseOwnHistory(const HistoryMarketOfferList &buyOffers, const HistoryMarketOfferList &sellOffers) {
	if (m_owner) {
		m_owner->sendMarketBrowseOwnHistory(buyOffers, sellOffers);
	}
}

void Livestream::sendMarketDetail(uint16_t itemId, uint8_t tier) {
	if (m_owner) {
		m_owner->sendMarketDetail(itemId, tier);
	}
}

void Livestream::sendMarketAcceptOffer(const MarketOfferEx &offer) {
	if (m_owner) {
		m_owner->sendMarketAcceptOffer(offer);
	}
}

void Livestream::sendMarketCancelOffer(const MarketOfferEx &offer) {
	if (m_owner) {
		m_owner->sendMarketCancelOffer(offer);
	}
}

void Livestream::sendMessageDialog(const std::string &message) {
	if (m_owner) {
		m_owner->sendMessageDialog(message);
	}
}

void Livestream::sendOpenStash() {
	if (m_owner) {
		m_owner->sendOpenStash();
	}
}

void Livestream::sendTakeScreenshot(Screenshot_t screenshotType) {
	if (m_owner) {
		m_owner->sendTakeScreenshot(screenshotType);
	}
}

void Livestream::sendPartyCreatureUpdate(std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->sendPartyCreatureUpdate(creature);
	}
}

void Livestream::sendPartyCreatureShield(std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->sendPartyCreatureShield(creature);
	}
}

void Livestream::sendPartyCreatureSkull(std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->sendPartyCreatureSkull(creature);
	}
}

void Livestream::sendPartyCreatureHealth(std::shared_ptr<Creature> creature, uint8_t healthPercent) {
	if (m_owner) {
		m_owner->sendPartyCreatureHealth(creature, healthPercent);
	}
}

void Livestream::sendPartyPlayerMana(std::shared_ptr<Player> player, uint8_t manaPercent) {
	if (m_owner) {
		m_owner->sendPartyPlayerMana(player, manaPercent);
	}
}

void Livestream::sendPartyCreatureShowStatus(std::shared_ptr<Creature> creature, bool showStatus) {
	if (m_owner) {
		m_owner->sendPartyCreatureShowStatus(creature, showStatus);
	}
}

void Livestream::sendPartyPlayerVocation(std::shared_ptr<Player> player) {
	if (m_owner) {
		m_owner->sendPartyPlayerVocation(player);
	}
}

void Livestream::sendPlayerVocation(std::shared_ptr<Player> player) {
	if (m_owner) {
		m_owner->sendPlayerVocation(player);
	}
}

void Livestream::sendPreyTimeLeft(const std::unique_ptr<PreySlot> &slot) {
	if (m_owner) {
		m_owner->sendPreyTimeLeft(slot);
	}
}

void Livestream::sendResourcesBalance(uint64_t money, uint64_t bank, uint64_t preyCards, uint64_t taskHunting, uint64_t forgeDust, uint64_t forgeSliver, uint64_t forgeCores) {
	if (m_owner) {
		m_owner->sendResourcesBalance(money, bank, preyCards, taskHunting, forgeDust, forgeSliver, forgeCores);
	}
}

void Livestream::sendCreatureReload(std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->reloadCreature(creature);
	}
}

void Livestream::sendCreatureChangeOutfit(std::shared_ptr<Creature> creature, const Outfit_t &outfit) {
	if (m_owner) {
		m_owner->sendCreatureOutfit(creature, outfit);
	}
}

void Livestream::sendPreyData(const std::unique_ptr<PreySlot> &slot) {
	if (m_owner) {
		m_owner->sendPreyData(slot);
	}
}

void Livestream::sendSpecialContainersAvailable() {
	if (m_owner) {
		m_owner->sendSpecialContainersAvailable();
	}
}

void Livestream::sendTaskHuntingData(const std::unique_ptr<TaskHuntingSlot> &slot) {
	if (m_owner) {
		m_owner->sendTaskHuntingData(slot);
	}
}

void Livestream::sendTibiaTime(int32_t time) {
	if (m_owner) {
		m_owner->sendTibiaTime(time);
	}
}

void Livestream::sendUpdateInputAnalyzer(CombatType_t type, int32_t amount, std::string target) {
	if (m_owner) {
		m_owner->sendUpdateInputAnalyzer(type, amount, target);
	}
}

void Livestream::sendRestingStatus(uint8_t protection) {
	if (m_owner) {
		m_owner->sendRestingStatus(protection);
	}
}

void Livestream::AddItem(NetworkMessage &msg, std::shared_ptr<Item> item) {
	if (m_owner) {
		m_owner->AddItem(msg, item);
	}
}

void Livestream::AddItem(NetworkMessage &msg, uint16_t id, uint8_t count, uint8_t tier) {
	if (m_owner) {
		m_owner->AddItem(msg, id, count, tier);
	}
}

void Livestream::parseSendBosstiary() {
	if (m_owner) {
		m_owner->parseSendBosstiary();
	}
}

void Livestream::parseSendBosstiarySlots() {
	if (m_owner) {
		m_owner->parseSendBosstiarySlots();
	}
}

void Livestream::sendLootStats(std::shared_ptr<Item> item, uint8_t count) {
	if (m_owner) {
		m_owner->sendLootStats(item, count);
	}
}

void Livestream::sendUpdateSupplyTracker(std::shared_ptr<Item> item) {
	if (m_owner) {
		m_owner->sendUpdateSupplyTracker(item);
	}
}

void Livestream::sendUpdateImpactTracker(CombatType_t type, int32_t amount) {
	if (m_owner) {
		m_owner->sendUpdateImpactTracker(type, amount);
	}
}

void Livestream::openImbuementWindow(std::shared_ptr<Item> item) {
	if (m_owner) {
		m_owner->openImbuementWindow(item);
	}
}

void Livestream::sendMarketEnter(uint32_t depotId) {
	if (m_owner) {
		m_owner->sendMarketEnter(depotId);
	}
}

void Livestream::sendUnjustifiedPoints(const uint8_t &dayProgress, const uint8_t &dayLeft, const uint8_t &weekProgress, const uint8_t &weekLeft, const uint8_t &monthProgress, const uint8_t &monthLeft, const uint8_t &skullDuration) {
	if (m_owner) {
		m_owner->sendUnjustifiedPoints(dayProgress, dayLeft, weekProgress, weekLeft, monthProgress, monthLeft, skullDuration);

		for (const auto &it : m_viewers) {
			it.first->sendUnjustifiedPoints(dayProgress, dayLeft, weekProgress, weekLeft, monthProgress, monthLeft, skullDuration);
		}
	}
}

void Livestream::sendModalWindow(const ModalWindow &modalWindow) {
	if (m_owner) {
		m_owner->sendModalWindow(modalWindow);
	}
}

void Livestream::sendResourceBalance(Resource_t resourceType, uint64_t value) {
	if (m_owner) {
		m_owner->sendResourceBalance(resourceType, value);
	}
}

void Livestream::sendOpenWheelWindow(uint32_t ownerId) {
	if (m_owner) {
		m_owner->sendOpenWheelWindow(ownerId);
	}
}

void Livestream::sendCreatureSay(std::shared_ptr<Creature> creature, SpeakClasses type, const std::string &text, const Position* pos) {
	if (m_owner) {
		m_owner->sendCreatureSay(creature, type, text, pos);

		if (type == TALKTYPE_PRIVATE_FROM) {
			return;
		}

		for (const auto &it : m_viewers) {
			it.first->sendCreatureSay(creature, type, text, pos);
		}
	}
}

void Livestream::disconnectClient(const std::string &message) const {
	if (m_owner) {
		m_owner->disconnectClient(message);
	}
}

void Livestream::addViewer(ProtocolGame_ptr client, bool spy) {
	if (m_viewers.find(client) != m_viewers.end()) {
		return;
	}

	auto viewerId = ++m_viewerCounter;

	std::string guestString = fmt::format("Viewer-{}", viewerId);

	m_viewers[client] = std::make_pair(guestString, m_viewerId);

	if (!spy) {
		sendChannelEvent(CHANNEL_CAST, guestString, CHANNELEVENT_JOIN);

		if (m_viewers.size() > m_livestreamCasterLiveRecord) {
			m_livestreamCasterLiveRecord = m_viewers.size();
			if (m_owner->player) {
				m_owner->player->kv()->scoped("livestream-system")->set("live-record", m_livestreamCasterLiveRecord);
			}
			m_owner->sendTextMessage(TextMessage(MESSAGE_LOOK, fmt::format("New record: {} people are watching your livestream now.", std::to_string(m_livestreamCasterLiveRecord))));
		}
	}
}

void Livestream::removeViewer(ProtocolGame_ptr client, bool spy) {
	auto it = m_viewers.find(client);
	if (it == m_viewers.end()) {
		return;
	}

	auto mit = std::find(m_mutes.begin(), m_mutes.end(), it->second.first);
	if (mit != m_mutes.end()) {
		m_mutes.erase(mit);
	}

	if (!spy) {
		sendChannelEvent(CHANNEL_CAST, it->second.first, CHANNELEVENT_LEAVE);
	}

	m_viewers.erase(it);
}

void Livestream::handle(ProtocolGame_ptr client, const std::string &text, uint16_t channelId) {
	if (!m_owner) {
		return;
	}

	auto sit = m_viewers.find(client);
	if (sit == m_viewers.end()) {
		return;
	}

	const int64_t &now = OTSYS_STEADY_TIME();
	if (client->m_livestreamMessageCooldownTime + 5000 < now) {
		client->m_livestreamMessageCooldownTime = now, client->m_livestreamMessageCount = 0;
	} else if (client->m_livestreamMessageCount++ >= 3) {
		client->sendTextMessage(TextMessage(MESSAGE_STATUS, fmt::format("Please wait {} seconds to send another message.", ((client->m_livestreamMessageCooldownTime + 5000 - now) / 1000) + 1)));
		return;
	}

	bool isCastChannel = channelId == CHANNEL_CAST;
	if (text[0] == '/') {
		std::vector<std::string> CommandParam = explodeString(text.substr(1, text.length()), " ", 1);
		if (strcasecmp(CommandParam[0].c_str(), "show") == 0) {
			auto viewersNames = std::views::transform(m_viewers, [](const auto &pair) {
				return pair.second.first;
			});
			std::string messageViewer = fmt::format("{} spectator{}, {}.", m_viewers.size(), m_viewers.size() > 1 ? "s" : "", fmt::join(viewersNames.begin(), viewersNames.end(), ", "));

			client->sendTextMessage(TextMessage(MESSAGE_STATUS, messageViewer));
		} else if (strcasecmp(CommandParam[0].c_str(), "name") == 0) {
			if (CommandParam.size() > 1) {
				if (CommandParam[1].length() > 2) {
					if (CommandParam[1].length() < 18) {
						bool found = false;
						for (auto it = m_viewers.begin(); it != m_viewers.end(); ++it) {
							if (strcasecmp(it->second.first.c_str(), CommandParam[1].c_str()) != 0) {
								continue;
							}

							found = true;
							break;
						}

						if (!found) {
							if (isCastChannel) {
								sendChannelMessage("", fmt::format("{} was renamed to {}.", sit->second.first, CommandParam[1]), TALKTYPE_CHANNEL_O, CHANNEL_CAST);
							}

							auto mit = std::find(m_mutes.begin(), m_mutes.end(), asLowerCaseString(sit->second.first));
							if (mit != m_mutes.end()) {
								(*mit) = asLowerCaseString(CommandParam[1]);
							}

							sit->second.first = CommandParam[1];
						} else {
							client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "There is already someone with that name."));
						}
					} else {
						client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "Name must be shorter than 18 letters."));
					}
				} else {
					client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "Name must be longer than 2 letters."));
				}
			}
		} else {
			client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "Available commands: /name, /show."));
		}

		return;
	}

	auto mit = std::find(m_mutes.begin(), m_mutes.end(), asLowerCaseString(sit->second.first));
	if (mit == m_mutes.end()) {
		if (isCastChannel) {
			sendChannelMessage(sit->second.first, text, TALKTYPE_CHANNEL_Y, CHANNEL_CAST);
		}
	} else {
		client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "You are muted."));
	}
}

uint32_t Livestream::getLivestreamViewerCount() {
	return m_viewers.size();
}

std::vector<std::string> Livestream::getLivestreamViewers() const {
	std::vector<std::string> players;
	for (const auto &it : m_viewers) {
		players.push_back(it.second.first);
	}
	return players;
}

std::vector<std::shared_ptr<Player>> Livestream::getLivestreamViewersByIP(uint32_t ip) const {
	std::vector<std::shared_ptr<Player>> players;
	for (const auto &[client, clientInfo] : m_viewers) {
		if (client->player) {
			players.push_back(client->player);
		}
	}
	return players;
}

bool Livestream::isOldProtocol() {
	return m_owner->oldProtocol;
}

#endif // FEATURE_LIVESTREAM
