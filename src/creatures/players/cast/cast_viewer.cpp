/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/players/cast/cast_viewer.hpp"

#include "creatures/players/player.hpp"

#include "creatures/interactions/chat.hpp"
#include "config/configmanager.hpp"

#include "server/network/message/outputmessage.hpp"

#include "server/network/protocol/protocolgame.hpp"

CastViewer::CastViewer(std::shared_ptr<ProtocolGame> client) :
	m_owner(client) { }

CastViewer::~CastViewer() { }

void CastViewer::clear(bool full) {
	for (const auto &[client, _] : m_viewers) {
		client->sendSessionEndInformation(SESSION_END_LOGOUT);
	}

	m_viewers.clear();
	m_mutes.clear();
	removeCaster();

	m_id = 0;
	if (!full) {
		return;
	}

	m_bans.clear();
	m_castPassword = "";
	m_castBroadcast = false;
	m_castBroadcastTime = 0;
	m_castLiveRecord = 0;
}

bool CastViewer::checkPassword(const std::string &_password) {
	if (m_castPassword.empty()) {
		return true;
	}

	std::string t = _password;
	trimString(t);

	return t == m_castPassword;
}

void CastViewer::setKickViewer(std::vector<std::string> list) {
	for (const auto &it : list) {
		for (const auto &[client, clientInfo] : m_viewers) {
			if (asLowerCaseString(clientInfo.first) == it) {
				client->sendSessionEndInformation(SESSION_END_LOGOUT);
			}
		}
	}
}

const std::vector<std::string> &CastViewer::getMuteCastList() const {
	return m_mutes;
}

void CastViewer::setMuteViewer(std::vector<std::string> mutes) {
	m_mutes = mutes;
}

const std::map<std::string, uint32_t> &CastViewer::getBanCastList() const {
	return m_bans;
}

void CastViewer::setBanViewer(std::vector<std::string> bans) {
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

bool CastViewer::checkBannedIP(uint32_t ip) const {
	for (const auto &it : m_bans) {
		if (it.second == ip) {
			return true;
		}
	}

	return false;
}

std::shared_ptr<ProtocolGame> CastViewer::getCastOwner() const {
	return m_owner;
}

void CastViewer::setCastOwner(std::shared_ptr<ProtocolGame> client) {
	m_owner = client;
}

void CastViewer::resetCastOwner() {
	m_owner.reset();
}

std::string CastViewer::getCastPassword() const {
	return m_castPassword;
}

void CastViewer::setCastPassword(const std::string &value) {
	m_castPassword = value;
}

bool CastViewer::isCastBroadcasting() const {
	return m_castBroadcast;
}

void CastViewer::setCastBroadcast(bool value) {
	m_castBroadcast = value;
}

std::string CastViewer::getCastBroadcastTimeString() const {
	int64_t seconds = getCastBroadcastTime() / 1000;
	uint16_t hour = floor(seconds / 60 / 60 % 24);
	uint16_t minute = floor(seconds / 60 % 60);
	uint16_t second = floor(seconds % 60);

	return fmt::format("{} hours, {} minutes and {} seconds", hour, minute, second);
}

int64_t CastViewer::getCastBroadcastTime() const {
	return OTSYS_TIME() - m_castBroadcastTime;
}

void CastViewer::setCastBroadcastTime(int64_t time) {
	m_castBroadcastTime = time;
}

std::string CastViewer::getCastDescription() const {
	return m_castDescription;
}

void CastViewer::setCastDescription(const std::string &desc) {
	m_castDescription = desc;
}

uint32_t CastViewer::getViewerId(std::shared_ptr<ProtocolGame> client) const {
	auto it = m_viewers.find(client);
	if (it != m_viewers.end()) {
		return it->second.second;
	}
	return 0;
}

// Inherited
void CastViewer::insertCaster() {
	if (m_owner) {
		m_owner->insertCaster();
	}
}

void CastViewer::removeCaster() {
	if (m_owner) {
		m_owner->removeCaster();
	}
}

bool CastViewer::canSee(const Position &pos) const {
	if (m_owner) {
		return m_owner->canSee(pos);
	}

	return false;
}

uint32_t CastViewer::getIP() const {
	if (m_owner) {
		return m_owner->getIP();
	}

	return 0;
}

void CastViewer::sendStats() {
	if (m_owner) {
		m_owner->sendStats();

		for (const auto &it : m_viewers) {
			it.first->sendStats();
		}
	}
}

void CastViewer::sendPing() {
	if (m_owner) {
		m_owner->sendPing();

		for (const auto &it : m_viewers) {
			it.first->sendPing();
		}
	}
}

void CastViewer::logout(bool displayEffect, bool forceLogout) {
	if (m_owner) {
		m_owner->logout(displayEffect, forceLogout);
	}
}

void CastViewer::sendAddContainerItem(uint8_t cid, uint16_t slot, std::shared_ptr<Item> item) {
	if (m_owner) {
		m_owner->sendAddContainerItem(cid, slot, item);

		for (const auto &it : m_viewers) {
			it.first->sendAddContainerItem(cid, slot, item);
		}
	}
}

void CastViewer::sendUpdateContainerItem(uint8_t cid, uint16_t slot, std::shared_ptr<Item> item) {
	if (m_owner) {
		m_owner->sendUpdateContainerItem(cid, slot, item);

		for (const auto &it : m_viewers) {
			it.first->sendUpdateContainerItem(cid, slot, item);
		}
	}
}

void CastViewer::sendRemoveContainerItem(uint8_t cid, uint16_t slot, std::shared_ptr<Item> lastItem) {
	if (m_owner) {
		m_owner->sendRemoveContainerItem(cid, slot, lastItem);

		for (const auto &it : m_viewers) {
			it.first->sendRemoveContainerItem(cid, slot, lastItem);
		}
	}
}

void CastViewer::sendUpdatedVIPStatus(uint32_t guid, VipStatus_t newStatus) {
	if (m_owner) {
		m_owner->sendUpdatedVIPStatus(guid, newStatus);

		for (const auto &it : m_viewers) {
			it.first->sendUpdatedVIPStatus(guid, newStatus);
		}
	}
}

void CastViewer::sendVIP(uint32_t guid, const std::string &name, const std::string &description, uint32_t icon, bool notify, VipStatus_t status) {
	if (m_owner) {
		m_owner->sendVIP(guid, name, description, icon, notify, status);

		for (const auto &it : m_viewers) {
			it.first->sendVIP(guid, name, description, icon, notify, status);
		}
	}
}

void CastViewer::sendVIPGroups() {
	if (m_owner) {
		m_owner->sendVIPGroups();

		for (const auto &it : m_viewers) {
			it.first->sendVIPGroups();
		}
	}
}

void CastViewer::sendClosePrivate(uint16_t channelId) {
	if (m_owner) {
		m_owner->sendClosePrivate(channelId);
	}
}

void CastViewer::sendFYIBox(const std::string &message) {
	if (m_owner) {
		m_owner->sendFYIBox(message);
	}
}

uint32_t CastViewer::getVersion() const {
	if (m_owner) {
		return m_owner->getVersion();
	}

	return 0;
}

void CastViewer::disconnect() {
	if (m_owner) {
		m_owner->sendSessionEndInformation(SESSION_END_LOGOUT);
	}
}

void CastViewer::sendCreatureSkull(std::shared_ptr<Creature> creature) const {
	if (m_owner) {
		m_owner->sendCreatureSkull(creature);

		for (const auto &it : m_viewers) {
			it.first->sendCreatureSkull(creature);
		}
	}
}

void CastViewer::sendAddTileItem(const Position &pos, uint32_t stackpos, std::shared_ptr<Item> item) {
	if (m_owner) {
		m_owner->sendAddTileItem(pos, stackpos, item);

		for (const auto &it : m_viewers) {
			it.first->sendAddTileItem(pos, stackpos, item);
		}
	}
}

void CastViewer::sendUpdateTileItem(const Position &pos, uint32_t stackpos, std::shared_ptr<Item> item) {
	if (m_owner) {
		m_owner->sendUpdateTileItem(pos, stackpos, item);

		for (const auto &it : m_viewers) {
			it.first->sendUpdateTileItem(pos, stackpos, item);
		}
	}
}

void CastViewer::sendRemoveTileThing(const Position &pos, int32_t stackpos) {
	if (m_owner) {
		m_owner->sendRemoveTileThing(pos, stackpos);

		for (const auto &it : m_viewers) {
			it.first->sendRemoveTileThing(pos, stackpos);
		}
	}
}

void CastViewer::sendUpdateTile(std::shared_ptr<Tile> tile, const Position &pos) {
	if (m_owner) {
		m_owner->sendUpdateTile(tile, pos);

		for (const auto &it : m_viewers) {
			it.first->sendUpdateTile(tile, pos);
		}
	}
}

void CastViewer::sendChannelMessage(const std::string &author, const std::string &message, SpeakClasses type, uint16_t channel) {
	if (m_owner) {
		m_owner->sendChannelMessage(author, message, type, channel);

		for (const auto &it : m_viewers) {
			it.first->sendChannelMessage(author, message, type, channel);
		}
	}
}

void CastViewer::sendMoveCreature(std::shared_ptr<Creature> creature, const Position &newPos, int32_t newStackPos, const Position &oldPos, int32_t oldStackPos, bool teleport) {
	if (m_owner) {
		m_owner->sendMoveCreature(creature, newPos, newStackPos, oldPos, oldStackPos, teleport);

		for (const auto &it : m_viewers) {
			it.first->sendMoveCreature(creature, newPos, newStackPos, oldPos, oldStackPos, teleport);
		}
	}
}

void CastViewer::sendCreatureTurn(std::shared_ptr<Creature> creature, int32_t stackpos) {
	if (m_owner) {
		m_owner->sendCreatureTurn(creature, stackpos);

		for (const auto &it : m_viewers) {
			it.first->sendCreatureTurn(creature, stackpos);
		}
	}
}

void CastViewer::sendForgeResult(ForgeAction_t actionType, uint16_t leftItemId, uint8_t leftTier, uint16_t rightItemId, uint8_t rightTier, bool success, uint8_t bonus, uint8_t coreCount, bool convergence) const {
	if (m_owner) {
		m_owner->sendForgeResult(actionType, leftItemId, leftTier, rightItemId, rightTier, success, bonus, coreCount, convergence);
	}
}

void CastViewer::sendPrivateMessage(std::shared_ptr<Player> speaker, SpeakClasses type, const std::string &text) {
	if (m_owner) {
		m_owner->sendPrivateMessage(speaker, type, text);
	}
}

void CastViewer::sendCreatureSquare(std::shared_ptr<Creature> creature, SquareColor_t color) {
	if (m_owner) {
		m_owner->sendCreatureSquare(creature, color);

		for (const auto &it : m_viewers) {
			it.first->sendCreatureSquare(creature, color);
		}
	}
}

void CastViewer::sendCreatureOutfit(std::shared_ptr<Creature> creature, const Outfit_t &outfit) {
	if (m_owner) {
		m_owner->sendCreatureOutfit(creature, outfit);

		for (const auto &it : m_viewers) {
			it.first->sendCreatureOutfit(creature, outfit);
		}
	}
}

void CastViewer::sendCreatureLight(std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->sendCreatureLight(creature);

		for (const auto &it : m_viewers) {
			it.first->sendCreatureLight(creature);
		}
	}
}

void CastViewer::sendCreatureWalkthrough(std::shared_ptr<Creature> creature, bool walkthrough) {
	if (m_owner) {
		m_owner->sendCreatureWalkthrough(creature, walkthrough);

		for (const auto &it : m_viewers) {
			it.first->sendCreatureWalkthrough(creature, walkthrough);
		}
	}
}

void CastViewer::sendCreatureShield(std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->sendCreatureShield(creature);

		for (const auto &it : m_viewers) {
			it.first->sendCreatureShield(creature);
		}
	}
}

void CastViewer::sendContainer(uint8_t cid, std::shared_ptr<Container> container, bool hasParent, uint16_t firstIndex) {
	if (m_owner) {
		m_owner->sendContainer(cid, container, hasParent, firstIndex);

		for (const auto &it : m_viewers) {
			it.first->sendContainer(cid, container, hasParent, firstIndex);
		}
	}
}

void CastViewer::sendInventoryItem(Slots_t slot, std::shared_ptr<Item> item) {
	if (m_owner) {
		m_owner->sendInventoryItem(slot, item);

		for (const auto &it : m_viewers) {
			it.first->sendInventoryItem(slot, item);
		}
	}
}

void CastViewer::sendCancelMessage(const std::string &msg) const {
	if (m_owner) {
		m_owner->sendTextMessage(TextMessage(MESSAGE_FAILURE, msg));

		for (const auto &it : m_viewers) {
			it.first->sendTextMessage(TextMessage(MESSAGE_FAILURE, msg));
		}
	}
}

void CastViewer::sendCancelTarget() const {
	if (m_owner) {
		m_owner->sendCancelTarget();

		for (const auto &it : m_viewers) {
			it.first->sendCancelTarget();
		}
	}
}

void CastViewer::sendCancelWalk() const {
	if (m_owner) {
		m_owner->sendCancelWalk();

		for (const auto &it : m_viewers) {
			it.first->sendCancelWalk();
		}
	}
}

void CastViewer::sendChangeSpeed(std::shared_ptr<Creature> creature, uint32_t newSpeed) const {
	if (m_owner) {
		m_owner->sendChangeSpeed(creature, newSpeed);

		for (const auto &it : m_viewers) {
			it.first->sendChangeSpeed(creature, newSpeed);
		}
	}
}

void CastViewer::sendCreatureHealth(std::shared_ptr<Creature> creature) const {
	if (m_owner) {
		m_owner->sendCreatureHealth(creature);

		for (const auto &it : m_viewers) {
			it.first->sendCreatureHealth(creature);
		}
	}
}

void CastViewer::sendDistanceShoot(const Position &from, const Position &to, unsigned char type) const {
	if (m_owner) {
		m_owner->sendDistanceShoot(from, to, type);

		for (const auto &it : m_viewers) {
			it.first->sendDistanceShoot(from, to, type);
		}
	}
}

void CastViewer::sendCreatePrivateChannel(uint16_t channelId, const std::string &channelName) {
	if (m_owner) {
		m_owner->sendCreatePrivateChannel(channelId, channelName);
	}
}

void CastViewer::sendIcons(uint32_t icons) const {
	if (m_owner) {
		m_owner->sendIcons(icons);

		for (const auto &it : m_viewers) {
			it.first->sendIcons(icons);
		}
	}
}

void CastViewer::sendMagicEffect(const Position &pos, uint8_t type) const {
	if (m_owner) {
		m_owner->sendMagicEffect(pos, type);

		for (const auto &it : m_viewers) {
			it.first->sendMagicEffect(pos, type);
		}
	}
}

void CastViewer::sendSkills() const {
	if (m_owner) {
		m_owner->sendSkills();

		for (const auto &it : m_viewers) {
			it.first->sendSkills();
		}
	}
}

void CastViewer::sendTextMessage(MessageClasses mclass, const std::string &message) {
	if (m_owner) {
		m_owner->sendTextMessage(TextMessage(mclass, message));

		for (const auto &it : m_viewers) {
			it.first->sendTextMessage(TextMessage(mclass, message));
		}
	}
}

void CastViewer::sendTextMessage(const TextMessage &message) const {
	if (m_owner) {
		m_owner->sendTextMessage(message);

		for (const auto &it : m_viewers) {
			it.first->sendTextMessage(message);
		}
	}
}

void CastViewer::sendReLoginWindow(uint8_t unfairFightReduction) {
	if (m_owner) {
		m_owner->sendReLoginWindow(unfairFightReduction);
	}
}

void CastViewer::sendTextWindow(uint32_t windowTextId, std::shared_ptr<Item> item, uint16_t maxlen, bool canWrite) const {
	if (m_owner) {
		m_owner->sendTextWindow(windowTextId, item, maxlen, canWrite);
	}
}

void CastViewer::sendTextWindow(uint32_t windowTextId, uint32_t itemId, const std::string &text) const {
	if (m_owner) {
		m_owner->sendTextWindow(windowTextId, itemId, text);
	}
}

void CastViewer::sendToChannel(std::shared_ptr<Creature> creature, SpeakClasses type, const std::string &text, uint16_t channelId) {
	if (m_owner) {
		m_owner->sendToChannel(creature, type, text, channelId);
		for (const auto &it : m_viewers) {
			it.first->sendToChannel(creature, type, text, channelId);
		}
	}
}

void CastViewer::sendShop(std::shared_ptr<Npc> npc) const {
	if (m_owner) {
		m_owner->sendShop(npc);
	}
}

void CastViewer::sendSaleItemList(const std::vector<ShopBlock> &shopVector, const std::map<uint16_t, uint16_t> &inventoryMap) {
	if (m_owner) {
		m_owner->sendSaleItemList(shopVector, inventoryMap);
	}
}

void CastViewer::sendCloseShop() const {
	if (m_owner) {
		m_owner->sendCloseShop();
	}
}

void CastViewer::sendTradeItemRequest(const std::string &traderName, std::shared_ptr<Item> item, bool ack) const {
	if (m_owner) {
		m_owner->sendTradeItemRequest(traderName, item, ack);
	}
}

void CastViewer::sendTradeClose() const {
	if (m_owner) {
		m_owner->sendCloseTrade();
	}
}

void CastViewer::sendWorldLight(const LightInfo &lightInfo) {
	if (m_owner) {
		m_owner->sendWorldLight(lightInfo);

		for (const auto &it : m_viewers) {
			it.first->sendWorldLight(lightInfo);
		}
	}
}

void CastViewer::sendChannelsDialog() {
	if (m_owner) {
		m_owner->sendChannelsDialog();
	}
}

void CastViewer::sendOpenPrivateChannel(const std::string &receiver) {
	if (m_owner) {
		m_owner->sendOpenPrivateChannel(receiver);
	}
}

void CastViewer::sendOutfitWindow() {
	if (m_owner) {
		m_owner->sendOutfitWindow();
	}
}

void CastViewer::sendCloseContainer(uint8_t cid) {
	if (m_owner) {
		m_owner->sendCloseContainer(cid);

		for (const auto &it : m_viewers) {
			it.first->sendCloseContainer(cid);
		}
	}
}

void CastViewer::sendChannel(uint16_t channelId, const std::string &channelName, const std::map<uint32_t, std::shared_ptr<Player>>* channelUsers, const std::map<uint32_t, std::shared_ptr<Player>>* invitedUsers) {
	if (m_owner) {
		m_owner->sendChannel(channelId, channelName, channelUsers, invitedUsers);
	}
}

void CastViewer::sendTutorial(uint8_t tutorialId) {
	if (m_owner) {
		m_owner->sendTutorial(tutorialId);
	}
}

void CastViewer::sendAddMarker(const Position &pos, uint8_t markType, const std::string &desc) {
	if (m_owner) {
		m_owner->sendAddMarker(pos, markType, desc);
	}
}

void CastViewer::sendFightModes() {
	if (m_owner) {
		m_owner->sendFightModes();
	}
}

void CastViewer::writeToOutputBuffer(const NetworkMessage &message) {
	if (m_owner) {
		m_owner->writeToOutputBuffer(message);

		for (const auto &it : m_viewers) {
			it.first->writeToOutputBuffer(message);
		}
	}
}

void CastViewer::sendAddCreature(std::shared_ptr<Creature> creature, const Position &pos, int32_t stackpos, bool isLogin) {
	if (m_owner) {
		m_owner->sendAddCreature(creature, pos, stackpos, isLogin);

		for (const auto &it : m_viewers) {
			it.first->sendAddCreature(creature, pos, stackpos, isLogin);
		}
	}
}

void CastViewer::sendHouseWindow(uint32_t windowTextId, const std::string &text) {
	if (m_owner) {
		m_owner->sendHouseWindow(windowTextId, text);
	}
}

void CastViewer::sendCloseTrade() const {
	if (m_owner) {
		m_owner->sendCloseTrade();
	}
}

void CastViewer::sendBestiaryCharms() {
	if (m_owner) {
		m_owner->sendBestiaryCharms();
	}
}

void CastViewer::sendImbuementResult(const std::string message) {
	if (m_owner) {
		m_owner->sendImbuementResult(message);
	}
}

void CastViewer::closeImbuementWindow() {
	if (m_owner) {
		m_owner->closeImbuementWindow();
	}
}

void CastViewer::sendPodiumWindow(std::shared_ptr<Item> podium, const Position &position, uint16_t itemId, uint8_t stackpos) {
	if (m_owner) {
		m_owner->sendPodiumWindow(podium, position, itemId, stackpos);
	}
}

void CastViewer::sendCreatureIcon(std::shared_ptr<Creature> creature) {
	if (m_owner && !m_owner->oldProtocol) {
		m_owner->sendCreatureIcon(creature);
	}
}

void CastViewer::sendUpdateCreature(std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->sendUpdateCreature(creature);
	}
}

void CastViewer::sendCreatureType(std::shared_ptr<Creature> creature, uint8_t creatureType) {
	if (m_owner) {
		m_owner->sendCreatureType(creature, creatureType);
	}
}

void CastViewer::sendSpellCooldown(uint16_t spellId, uint32_t time) {
	if (m_owner) {
		m_owner->sendSpellCooldown(spellId, time);
	}
}

void CastViewer::sendSpellGroupCooldown(SpellGroup_t groupId, uint32_t time) {
	if (m_owner) {
		m_owner->sendSpellGroupCooldown(groupId, time);
	}
}

void CastViewer::sendUseItemCooldown(uint32_t time) {
	if (m_owner) {
		m_owner->sendUseItemCooldown(time);
	}
}

void CastViewer::reloadCreature(std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->reloadCreature(creature);
	}
}

void CastViewer::sendBestiaryEntryChanged(uint16_t raceid) {
	if (m_owner) {
		m_owner->sendBestiaryEntryChanged(raceid);
	}
}

void CastViewer::refreshCyclopediaMonsterTracker(const std::unordered_set<std::shared_ptr<MonsterType>> &trackerList, bool isBoss) const {
	if (m_owner) {
		m_owner->refreshCyclopediaMonsterTracker(trackerList, isBoss);
	}
}

void CastViewer::sendClientCheck() {
	if (m_owner) {
		m_owner->sendClientCheck();
	}
}

void CastViewer::sendGameNews() {
	if (m_owner) {
		m_owner->sendGameNews();
	}
}

void CastViewer::removeMagicEffect(const Position &pos, uint16_t type) {
	if (m_owner) {
		m_owner->removeMagicEffect(pos, type);
	}
}

void CastViewer::sendPingBack() {
	if (m_owner) {
		m_owner->sendPingBack();

		for (const auto &it : m_viewers) {
			it.first->sendPingBack();
		}
	}
}

void CastViewer::sendBasicData() {
	if (m_owner) {
		m_owner->sendBasicData();
	}
}

void CastViewer::sendBlessStatus() {
	if (m_owner) {
		m_owner->sendBlessStatus();
	}
}

void CastViewer::updatePartyTrackerAnalyzer(const std::shared_ptr<Party> party) {
	if (m_owner && party) {
		m_owner->updatePartyTrackerAnalyzer(party);
	}
}

void CastViewer::createLeaderTeamFinder(NetworkMessage &msg) {
	if (m_owner) {
		m_owner->createLeaderTeamFinder(msg);
	}
}

void CastViewer::sendLeaderTeamFinder(bool reset) {
	if (m_owner) {
		m_owner->sendLeaderTeamFinder(reset);
	}
}

void CastViewer::sendTeamFinderList() {
	if (m_owner) {
		m_owner->sendTeamFinderList();
	}
}

void CastViewer::sendCreatureHelpers(uint32_t creatureId, uint16_t helpers) {
	if (m_owner) {
		m_owner->sendCreatureHelpers(creatureId, helpers);
	}
}

void CastViewer::sendChannelEvent(uint16_t channelId, const std::string &playerName, ChannelEvent_t channelEvent) {
	if (m_owner) {
		m_owner->sendChannelEvent(channelId, playerName, channelEvent);
	}
}

void CastViewer::sendDepotItems(const ItemsTierCountList &itemMap, uint16_t count) {
	if (m_owner) {
		m_owner->sendDepotItems(itemMap, count);
	}
}

void CastViewer::sendCloseDepotSearch() {
	if (m_owner) {
		m_owner->sendCloseDepotSearch();
	}
}

using ItemVector = std::vector<std::shared_ptr<Item>>;
void CastViewer::sendDepotSearchResultDetail(uint16_t itemId, uint8_t tier, uint32_t depotCount, const ItemVector &depotItems, uint32_t inboxCount, const ItemVector &inboxItems, uint32_t stashCount) {
	if (m_owner) {
		m_owner->sendDepotSearchResultDetail(itemId, tier, depotCount, depotItems, inboxCount, inboxItems, stashCount);
	}
}

void CastViewer::sendCoinBalance() {
	if (m_owner) {
		m_owner->sendCoinBalance();
	}
}

void CastViewer::sendInventoryIds() {
	if (m_owner) {
		m_owner->sendInventoryIds();
	}
}

void CastViewer::sendLootContainers() {
	if (m_owner) {
		m_owner->sendLootContainers();
	}
}

void CastViewer::sendSingleSoundEffect(const Position &pos, SoundEffect_t id, SourceEffect_t source) {
	if (m_owner) {
		m_owner->sendSingleSoundEffect(pos, id, source);
	}
}

void CastViewer::sendDoubleSoundEffect(const Position &pos, SoundEffect_t mainSoundId, SourceEffect_t mainSource, SoundEffect_t secondarySoundId, SourceEffect_t secondarySource) {
	if (m_owner) {
		m_owner->sendDoubleSoundEffect(pos, mainSoundId, mainSource, secondarySoundId, secondarySource);
	}
}

void CastViewer::sendCreatureEmblem(std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->sendCreatureEmblem(creature);
	}
}

void CastViewer::sendItemInspection(uint16_t itemId, uint8_t itemCount, std::shared_ptr<Item> item, bool cyclopedia) {
	if (m_owner) {
		m_owner->sendItemInspection(itemId, itemCount, item, cyclopedia);
	}
}

void CastViewer::sendCyclopediaCharacterNoData(CyclopediaCharacterInfoType_t characterInfoType, uint8_t errorCode) {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterNoData(characterInfoType, errorCode);
	}
}

void CastViewer::sendCyclopediaCharacterBaseInformation() {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterBaseInformation();
	}
}

void CastViewer::sendCyclopediaCharacterGeneralStats() {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterGeneralStats();
	}
}

void CastViewer::sendCyclopediaCharacterCombatStats() {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterCombatStats();
	}
}

void CastViewer::sendCyclopediaCharacterRecentDeaths(uint16_t page, uint16_t pages, const std::vector<RecentDeathEntry> &entries) {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterRecentDeaths(page, pages, entries);
	}
}

void CastViewer::sendOpenForge() {
	if (m_owner) {
		m_owner->sendOpenForge();
	}
}

void CastViewer::sendForgeError(ReturnValue returnValue) {
	if (m_owner) {
		m_owner->sendForgeError(returnValue);
	}
}

void CastViewer::sendForgeHistory(uint8_t page) const {
	if (m_owner) {
		m_owner->sendForgeHistory(page);
	}
}

void CastViewer::closeForgeWindow() const {
	if (m_owner) {
		m_owner->closeForgeWindow();
	}
}

void CastViewer::sendBosstiaryCooldownTimer() const {
	if (m_owner) {
		m_owner->sendBosstiaryCooldownTimer();
	}
}

void CastViewer::sendCyclopediaCharacterRecentPvPKills(uint16_t page, uint16_t pages, const std::vector<RecentPvPKillEntry> &entries) {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterRecentPvPKills(page, pages, entries);
	}
}

void CastViewer::sendCyclopediaCharacterAchievements(int16_t secretsUnlocked, std::vector<std::pair<Achievement, uint32_t>> achievementsUnlocked) {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterAchievements(secretsUnlocked, achievementsUnlocked);
	}
}

void CastViewer::sendCyclopediaCharacterItemSummary(const ItemsTierCountList &inventoryItems, const ItemsTierCountList &storeInboxItems, const StashItemList &supplyStashItems, const ItemsTierCountList &depotBoxItems, const ItemsTierCountList &inboxItems) {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterItemSummary(inventoryItems, storeInboxItems, supplyStashItems, depotBoxItems, inboxItems);
	}
}

void CastViewer::sendCyclopediaCharacterOutfitsMounts() {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterOutfitsMounts();
	}
}

void CastViewer::sendCyclopediaCharacterStoreSummary() {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterStoreSummary();
	}
}

void CastViewer::sendCyclopediaCharacterInspection() {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterInspection();
	}
}

void CastViewer::sendCyclopediaCharacterBadges() {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterBadges();
	}
}

void CastViewer::sendCyclopediaCharacterTitles() {
	if (m_owner) {
		m_owner->sendCyclopediaCharacterTitles();
	}
}

void CastViewer::sendHighscoresNoData() {
	if (m_owner) {
		m_owner->sendHighscoresNoData();
	}
}

void CastViewer::sendHighscores(const std::vector<HighscoreCharacter> &characters, uint8_t categoryId, uint32_t vocationId, uint16_t page, uint16_t pages, uint32_t updateTimer) {
	if (m_owner) {
		m_owner->sendHighscores(characters, categoryId, vocationId, page, pages, updateTimer);
	}
}

void CastViewer::sendMonsterPodiumWindow(std::shared_ptr<Item> podium, const Position &position, uint16_t itemId, uint8_t stackpos) {
	if (m_owner) {
		m_owner->sendMonsterPodiumWindow(podium, position, itemId, stackpos);
	}
}

void CastViewer::sendBosstiaryEntryChanged(uint32_t bossid) {
	if (m_owner) {
		m_owner->sendBosstiaryEntryChanged(bossid);
	}
}

void CastViewer::sendInventoryImbuements(const std::map<Slots_t, std::shared_ptr<Item>> items) {
	if (m_owner) {
		m_owner->sendInventoryImbuements(items);

		for (const auto &it : m_viewers) {
			it.first->sendInventoryImbuements(items);
		}
	}
}

void CastViewer::sendEnterWorld() {
	if (m_owner) {
		m_owner->sendEnterWorld();
	}
}

void CastViewer::sendExperienceTracker(int64_t rawExp, int64_t finalExp) {
	if (m_owner) {
		m_owner->sendExperienceTracker(rawExp, finalExp);
	}
}

void CastViewer::sendItemsPrice() {
	if (m_owner) {
		m_owner->sendItemsPrice();
	}
}

void CastViewer::sendForgingData() {
	if (m_owner) {
		m_owner->sendForgingData();
	}
}

void CastViewer::sendKillTrackerUpdate(std::shared_ptr<Container> corpse, const std::string &name, const Outfit_t creatureOutfit) {
	if (m_owner) {
		m_owner->sendKillTrackerUpdate(corpse, name, creatureOutfit);
	}
}

void CastViewer::sendMarketLeave() {
	if (m_owner) {
		m_owner->sendMarketLeave();
	}
}

void CastViewer::sendMarketBrowseItem(uint16_t itemId, const MarketOfferList &buyOffers, const MarketOfferList &sellOffers, uint8_t tier) {
	if (m_owner) {
		m_owner->sendMarketBrowseItem(itemId, buyOffers, sellOffers, tier);
	}
}

void CastViewer::sendMarketBrowseOwnOffers(const MarketOfferList &buyOffers, const MarketOfferList &sellOffers) {
	if (m_owner) {
		m_owner->sendMarketBrowseOwnOffers(buyOffers, sellOffers);
	}
}

void CastViewer::sendMarketBrowseOwnHistory(const HistoryMarketOfferList &buyOffers, const HistoryMarketOfferList &sellOffers) {
	if (m_owner) {
		m_owner->sendMarketBrowseOwnHistory(buyOffers, sellOffers);
	}
}

void CastViewer::sendMarketDetail(uint16_t itemId, uint8_t tier) {
	if (m_owner) {
		m_owner->sendMarketDetail(itemId, tier);
	}
}

void CastViewer::sendMarketAcceptOffer(const MarketOfferEx &offer) {
	if (m_owner) {
		m_owner->sendMarketAcceptOffer(offer);
	}
}

void CastViewer::sendMarketCancelOffer(const MarketOfferEx &offer) {
	if (m_owner) {
		m_owner->sendMarketCancelOffer(offer);
	}
}

void CastViewer::sendMessageDialog(const std::string &message) {
	if (m_owner) {
		m_owner->sendMessageDialog(message);
	}
}

void CastViewer::sendOpenStash() {
	if (m_owner) {
		m_owner->sendOpenStash();
	}
}

void CastViewer::sendPartyCreatureUpdate(std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->sendPartyCreatureUpdate(creature);
	}
}

void CastViewer::sendPartyCreatureShield(std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->sendPartyCreatureShield(creature);
	}
}

void CastViewer::sendPartyCreatureSkull(std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->sendPartyCreatureSkull(creature);
	}
}

void CastViewer::sendPartyCreatureHealth(std::shared_ptr<Creature> creature, uint8_t healthPercent) {
	if (m_owner) {
		m_owner->sendPartyCreatureHealth(creature, healthPercent);
	}
}

void CastViewer::sendPartyPlayerMana(std::shared_ptr<Player> player, uint8_t manaPercent) {
	if (m_owner) {
		m_owner->sendPartyPlayerMana(player, manaPercent);
	}
}

void CastViewer::sendPartyCreatureShowStatus(std::shared_ptr<Creature> creature, bool showStatus) {
	if (m_owner) {
		m_owner->sendPartyCreatureShowStatus(creature, showStatus);
	}
}

void CastViewer::sendPartyPlayerVocation(std::shared_ptr<Player> player) {
	if (m_owner) {
		m_owner->sendPartyPlayerVocation(player);
	}
}

void CastViewer::sendPlayerVocation(std::shared_ptr<Player> player) {
	if (m_owner) {
		m_owner->sendPlayerVocation(player);
	}
}

void CastViewer::sendPreyTimeLeft(const std::unique_ptr<PreySlot> &slot) {
	if (m_owner) {
		m_owner->sendPreyTimeLeft(slot);
	}
}

void CastViewer::sendResourcesBalance(uint64_t money, uint64_t bank, uint64_t preyCards, uint64_t taskHunting, uint64_t forgeDust, uint64_t forgeSliver, uint64_t forgeCores) {
	if (m_owner) {
		m_owner->sendResourcesBalance(money, bank, preyCards, taskHunting, forgeDust, forgeSliver, forgeCores);
	}
}

void CastViewer::sendCreatureReload(std::shared_ptr<Creature> creature) {
	if (m_owner) {
		m_owner->reloadCreature(creature);
	}
}

void CastViewer::sendCreatureChangeOutfit(std::shared_ptr<Creature> creature, const Outfit_t &outfit) {
	if (m_owner) {
		m_owner->sendCreatureOutfit(creature, outfit);

		for (const auto &it : m_viewers) {
			it.first->sendCreatureOutfit(creature, outfit);
		}
	}
}

void CastViewer::sendPreyData(const std::unique_ptr<PreySlot> &slot) {
	if (m_owner) {
		m_owner->sendPreyData(slot);
	}
}

void CastViewer::sendSpecialContainersAvailable() {
	if (m_owner) {
		m_owner->sendSpecialContainersAvailable();
	}
}

void CastViewer::sendTaskHuntingData(const std::unique_ptr<TaskHuntingSlot> &slot) {
	if (m_owner) {
		m_owner->sendTaskHuntingData(slot);
	}
}

void CastViewer::sendTibiaTime(int32_t time) {
	if (m_owner) {
		m_owner->sendTibiaTime(time);
	}
}

void CastViewer::sendUpdateInputAnalyzer(CombatType_t type, int32_t amount, std::string target) {
	if (m_owner) {
		m_owner->sendUpdateInputAnalyzer(type, amount, target);
	}
}

void CastViewer::sendRestingStatus(uint8_t protection) {
	if (m_owner) {
		m_owner->sendRestingStatus(protection);
	}
}

void CastViewer::AddItem(NetworkMessage &msg, std::shared_ptr<Item> item) {
	if (m_owner) {
		m_owner->AddItem(msg, item);
	}
}

void CastViewer::AddItem(NetworkMessage &msg, uint16_t id, uint8_t count, uint8_t tier) {
	if (m_owner) {
		m_owner->AddItem(msg, id, count, tier);
	}
}

void CastViewer::parseSendBosstiary() {
	if (m_owner) {
		m_owner->parseSendBosstiary();
	}
}

void CastViewer::parseSendBosstiarySlots() {
	if (m_owner) {
		m_owner->parseSendBosstiarySlots();
	}
}

void CastViewer::sendLootStats(std::shared_ptr<Item> item, uint8_t count) {
	if (m_owner) {
		m_owner->sendLootStats(item, count);
	}
}

void CastViewer::sendUpdateSupplyTracker(std::shared_ptr<Item> item) {
	if (m_owner) {
		m_owner->sendUpdateSupplyTracker(item);
	}
}

void CastViewer::sendUpdateImpactTracker(CombatType_t type, int32_t amount) {
	if (m_owner) {
		m_owner->sendUpdateImpactTracker(type, amount);
	}
}

void CastViewer::openImbuementWindow(std::shared_ptr<Item> item) {
	if (m_owner) {
		m_owner->openImbuementWindow(item);
	}
}

void CastViewer::sendMarketEnter(uint32_t depotId) {
	if (m_owner) {
		m_owner->sendMarketEnter(depotId);
	}
}

void CastViewer::sendUnjustifiedPoints(const uint8_t &dayProgress, const uint8_t &dayLeft, const uint8_t &weekProgress, const uint8_t &weekLeft, const uint8_t &monthProgress, const uint8_t &monthLeft, const uint8_t &skullDuration) {
	if (m_owner) {
		m_owner->sendUnjustifiedPoints(dayProgress, dayLeft, weekProgress, weekLeft, monthProgress, monthLeft, skullDuration);

		for (const auto &it : m_viewers) {
			it.first->sendUnjustifiedPoints(dayProgress, dayLeft, weekProgress, weekLeft, monthProgress, monthLeft, skullDuration);
		}
	}
}

void CastViewer::sendModalWindow(const ModalWindow &modalWindow) {
	if (m_owner) {
		m_owner->sendModalWindow(modalWindow);
	}
}

void CastViewer::sendResourceBalance(Resource_t resourceType, uint64_t value) {
	if (m_owner) {
		m_owner->sendResourceBalance(resourceType, value);
	}
}

void CastViewer::sendOpenWheelWindow(uint32_t ownerId) {
	if (m_owner) {
		m_owner->sendOpenWheelWindow(ownerId);
	}
}

void CastViewer::sendCreatureSay(std::shared_ptr<Creature> creature, SpeakClasses type, const std::string &text, const Position* pos) {
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

void CastViewer::disconnectClient(const std::string &message) const {
	if (m_owner) {
		m_owner->disconnectClient(message);
	}
}

void CastViewer::addViewer(ProtocolGame_ptr client, bool spy) {
	if (m_viewers.find(client) != m_viewers.end()) {
		return;
	}

	auto viewerId = m_viewers.size() + 1;
	std::string guestString = fmt::format("Guest-{}", viewerId);

	m_viewers[client] = std::make_pair(guestString, m_id);

	if (!spy) {
		sendChannelMessage("", fmt::format("{} has entered the cast.", guestString), TALKTYPE_CHANNEL_O, CHANNEL_CAST);

		if (m_viewers.size() > m_castLiveRecord) {
			m_castLiveRecord = m_viewers.size();
			sendChannelMessage("", fmt::format("New record: {} people are watching your livestream now.", std::to_string(m_castLiveRecord)), TALKTYPE_CHANNEL_O, CHANNEL_CAST);
		}
	}
}

void CastViewer::removeViewer(ProtocolGame_ptr client, bool spy) {
	auto it = m_viewers.find(client);
	if (it == m_viewers.end()) {
		return;
	}

	auto mit = std::find(m_mutes.begin(), m_mutes.end(), it->second.first);
	if (mit != m_mutes.end()) {
		m_mutes.erase(mit);
	}

	if (!spy) {
		sendChannelMessage("", fmt::format("{} has left the cast.", it->second.first), TALKTYPE_CHANNEL_O, CHANNEL_CAST);
	}

	m_viewers.erase(it);
}

void CastViewer::handle(ProtocolGame_ptr client, const std::string &text, uint16_t channelId) {
	if (!m_owner) {
		return;
	}

	auto sit = m_viewers.find(client);
	if (sit == m_viewers.end()) {
		return;
	}

	const int64_t &now = OTSYS_TIME();
	if (client->m_castCooldownTime + 5000 < now) {
		client->m_castCooldownTime = now, client->m_castCount = 0;
	} else if (client->m_castCount++ >= 3) {
		client->sendTextMessage(TextMessage(MESSAGE_STATUS, fmt::format("Please wait a {} seconds to send another message.", ((client->m_castCooldownTime + 5000 - now) / 1000) + 1)));
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
						client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "It is not possible very long name."));
					}
				} else {
					client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "It is not possible very small name."));
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
		client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "You are mutated."));
	}
}

uint32_t CastViewer::getCastViewerCount() {
	return m_viewers.size();
}

std::vector<std::string> CastViewer::getViewers() const {
	std::vector<std::string> players;
	for (const auto &it : m_viewers) {
		players.push_back(it.second.first);
	}
	return players;
}

bool CastViewer::isOldProtocol() {
	return oldProtocol;
}
