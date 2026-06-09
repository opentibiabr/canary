/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/players/livestream/livestream.hpp"

#include "config/configmanager.hpp"
#include "creatures/players/player.hpp"
#include "database/databasemanager.hpp"
#include "database/databasetasks.hpp"
#include "enums/player_icons.hpp"
#include "kv/kv.hpp"
#include "server/network/message/networkmessage.hpp"
#include "utils/tools.hpp"

namespace {
	constexpr int64_t MESSAGE_COOLDOWN_MS = 5000;
	constexpr uint32_t MESSAGE_LIMIT = 3;
	constexpr size_t MIN_VIEWER_NAME_LENGTH = 3;
	constexpr size_t MAX_VIEWER_NAME_LENGTH = NETWORKMESSAGE_PLAYERNAME_MAXLENGTH;

	[[nodiscard]] uint16_t readU16(const uint8_t* buffer, size_t pos) {
		return static_cast<uint16_t>(buffer[pos] | (buffer[pos + 1] << 8));
	}

	[[nodiscard]] uint32_t readU32(const uint8_t* buffer, size_t pos) {
		return static_cast<uint32_t>(buffer[pos] | (buffer[pos + 1] << 8) | (buffer[pos + 2] << 16) | (buffer[pos + 3] << 24));
	}

	[[nodiscard]] bool isPrivateSpeakType(uint8_t type) {
		switch (static_cast<SpeakClasses>(type)) {
			case TALKTYPE_PRIVATE_FROM:
			case TALKTYPE_PRIVATE_TO:
			case TALKTYPE_PRIVATE_NP:
			case TALKTYPE_PRIVATE_PN:
			case TALKTYPE_PRIVATE_RED_FROM:
			case TALKTYPE_PRIVATE_RED_TO:
				return true;
			default:
				return false;
		}
	}

	[[nodiscard]] bool isChannelSpeakType(SpeakClasses type) {
		switch (type) {
			case TALKTYPE_CHANNEL_MANAGER:
			case TALKTYPE_CHANNEL_Y:
			case TALKTYPE_CHANNEL_O:
			case TALKTYPE_CHANNEL_R1:
			case TALKTYPE_CHANNEL_R2:
				return true;
			default:
				return false;
		}
	}

	[[nodiscard]] bool advanceSpeakMetadata(bool oldProtocol, const uint8_t* buffer, size_t end, uint32_t statementId, size_t &pos) {
		if (pos + 2 > end) {
			return true;
		}

		const auto nameLength = readU16(buffer, pos);
		if (nameLength <= NETWORKMESSAGE_PLAYERNAME_MAXLENGTH && pos + 2 + nameLength <= end) {
			pos += 2 + nameLength;
			if (!oldProtocol && statementId != 0) {
				++pos;
			}
			if (pos + 2 > end) {
				return false;
			}
			pos += 2;
			return true;
		}

		if (pos + 4 > end) {
			return false;
		}
		pos += 4;
		if (!oldProtocol && statementId != 0) {
			++pos;
		}
		return true;
	}
}

[[nodiscard]] LivestreamManager &LivestreamManager::getInstance() {
	static LivestreamManager instance;
	return instance;
}

[[nodiscard]] LivestreamManager &g_livestream() {
	return LivestreamManager::getInstance();
}

uint32_t LivestreamManager::getCasterGuid(const std::shared_ptr<Player> &caster) {
	return caster ? caster->getGUID() : 0;
}

LivestreamManager::Session &LivestreamManager::ensureSession(const std::shared_ptr<Player> &caster) {
	const auto guid = getCasterGuid(caster);
	auto [it, _] = sessions.try_emplace(guid);
	it->second.caster = caster;
	if (caster) {
		it->second.owner = caster->getClient();
	}
	return it->second;
}

LivestreamManager::Session* LivestreamManager::getSession(const std::shared_ptr<Player> &caster) {
	const auto guid = getCasterGuid(caster);
	if (guid == 0) {
		return nullptr;
	}

	auto it = sessions.find(guid);
	return it != sessions.end() ? &it->second : nullptr;
}

const LivestreamManager::Session* LivestreamManager::getSession(const std::shared_ptr<Player> &caster) const {
	const auto guid = getCasterGuid(caster);
	if (guid == 0) {
		return nullptr;
	}

	auto it = sessions.find(guid);
	return it != sessions.end() ? &it->second : nullptr;
}

bool LivestreamManager::isBroadcasting(const std::shared_ptr<Player> &caster) const {
	const auto* session = getSession(caster);
	return session && session->broadcasting;
}

bool LivestreamManager::isViewer(const ProtocolGame_ptr &client) const {
	return client && viewerToCaster.contains(client.get());
}

std::shared_ptr<Player> LivestreamManager::getCasterForViewer(const ProtocolGame_ptr &client) const {
	if (!client) {
		return nullptr;
	}

	const auto it = viewerToCaster.find(client.get());
	if (it == viewerToCaster.end()) {
		return nullptr;
	}

	const auto sessionIt = sessions.find(it->second);
	if (sessionIt == sessions.end()) {
		return nullptr;
	}

	return sessionIt->second.caster.lock();
}

LivestreamState LivestreamManager::getState(const std::shared_ptr<Player> &caster) const {
	LivestreamState state;
	const auto* session = getSession(caster);
	if (!session) {
		return state;
	}

	state.description = session->description;
	state.broadcast = session->broadcasting;
	state.password = session->password;

	state.names.reserve(session->viewers.size());
	for (const auto &[_, viewer] : session->viewers) {
		(void)state.names.emplace_back(viewer.name);
	}

	state.mutes = session->mutes;
	state.bans.reserve(session->bans.size());
	for (const auto &[name, _] : session->bans) {
		(void)state.bans.emplace_back(name);
	}

	return state;
}

size_t LivestreamManager::getViewerCount(const std::shared_ptr<Player> &caster) const {
	const auto* session = getSession(caster);
	return session ? session->viewers.size() : 0;
}

std::string LivestreamManager::getPassword(const std::shared_ptr<Player> &caster) const {
	const auto* session = getSession(caster);
	return session ? session->password : std::string();
}

std::string LivestreamManager::getDescription(const std::shared_ptr<Player> &caster) const {
	const auto* session = getSession(caster);
	return session ? session->description : std::string();
}

std::string LivestreamManager::getBroadcastTimeString(const std::shared_ptr<Player> &caster) const {
	const auto* session = getSession(caster);
	if (!session || session->broadcastStarted == 0) {
		return "0 hours, 0 minutes and 0 seconds";
	}

	const auto seconds = std::max<int64_t>(0, (OTSYS_TIME() - session->broadcastStarted) / 1000);
	const auto hour = seconds / 3600;
	const auto minute = (seconds / 60) % 60;
	const auto second = seconds % 60;
	return fmt::format("{} hours, {} minutes and {} seconds", hour, minute, second);
}

std::vector<std::shared_ptr<Player>> LivestreamManager::getBroadcastingCasters(std::string_view password) const {
	std::vector<std::shared_ptr<Player>> casters;
	for (const auto &[_, session] : sessions) {
		auto caster = session.caster.lock();
		if (!caster || caster->isRemoved() || !session.broadcasting) {
			continue;
		}

		if (!password.empty() && std::string_view(session.password) != password) {
			continue;
		}

		(void)casters.emplace_back(std::move(caster));
	}

	(void)std::ranges::sort(casters, [this](const auto &lhs, const auto &rhs) {
		return getViewerCount(lhs) > getViewerCount(rhs);
	});
	return casters;
}

void LivestreamManager::setInitialState(const std::shared_ptr<Player> &caster, std::string_view password, std::string_view description, uint32_t liveRecord) {
	if (!caster) {
		return;
	}

	auto &session = ensureSession(caster);
	session.password.assign(password.begin(), password.end());
	session.description.assign(description.begin(), description.end());
	session.liveRecord = liveRecord;
}

void LivestreamManager::applyState(const std::shared_ptr<Player> &caster, const LivestreamState &state) {
	if (!caster) {
		return;
	}

	auto &session = ensureSession(caster);
	const bool wasBroadcasting = session.broadcasting;
	const bool passwordChanged = session.password != state.password;
	if (passwordChanged && !state.password.empty()) {
		disconnectViewers(session, false);
	}

	if (!state.broadcast && wasBroadcasting) {
		disconnectViewers(session, false);
	}

	kickViewers(session, state.kick);
	session.mutes.clear();
	session.mutes.reserve(state.mutes.size());
	for (const auto &mute : state.mutes) {
		(void)session.mutes.emplace_back(normalizeViewerName(mute));
	}
	setBans(session, state.bans);

	if (!wasBroadcasting && state.broadcast) {
		session.broadcastStarted = OTSYS_TIME();
		session.owner = caster->getClient();
		if (auto owner = session.owner.lock()) {
			owner->sendChannel(CHANNEL_LIVESTREAM, "Livestream", nullptr, nullptr);
		}
	}

	session.broadcasting = state.broadcast;
	session.password = state.password;
	session.description = state.description;
	if (auto owner = session.owner.lock()) {
		owner->m_isLivestreamBroadcaster = session.broadcasting;
	}

	if (!session.broadcasting && session.viewers.empty() && session.password.empty() && session.description.empty()) {
		(void)sessions.erase(getCasterGuid(caster));
	}
}

void LivestreamManager::stopBroadcast(const std::shared_ptr<Player> &caster, bool clearAll) {
	auto* session = getSession(caster);
	if (!session) {
		return;
	}

	disconnectViewers(*session, true);
	session->broadcasting = false;
	session->broadcastStarted = 0;
	if (auto owner = session->owner.lock()) {
		owner->m_isLivestreamBroadcaster = false;
	}

	if (clearAll) {
		session->viewerCounter = 0;
		session->password.clear();
		session->description.clear();
		session->bans.clear();
		session->liveRecord = 0;
	}
}

bool LivestreamManager::canWatch(const std::shared_ptr<Player> &caster, const ProtocolGame_ptr &viewer, const std::string &password, std::string &reason) const {
	if (!caster || caster->isRemoved()) {
		reason = "Livestream unavailable.";
		return false;
	}

	const auto* session = getSession(caster);
	if (!session || !session->broadcasting) {
		reason = "This player is not currently streaming.";
		return false;
	}

	if (!caster->getClient()) {
		reason = "This player is no longer broadcasting.";
		return false;
	}

	const auto viewerIP = viewer ? viewer->getIP() : 0;
	const auto bannedByIP = std::ranges::any_of(session->bans, [viewerIP](const auto &ban) {
		return viewerIP != 0 && ban.second == viewerIP;
	});
	if (bannedByIP) {
		reason = "Access denied: You are banned from viewing this livestream.";
		return false;
	}

	if (!session->password.empty()) {
		auto trimmedPassword = password;
		trimString(trimmedPassword);
		if (trimmedPassword != session->password) {
			reason = "Incorrect password. Access to this livestream is protected.";
			return false;
		}
	}

	int32_t viewersByIP = 0;
	for (const auto &[_, viewerInfo] : session->viewers) {
		if (viewerInfo.ip == viewerIP) {
			++viewersByIP;
		}
	}

	const auto maxViewersPerIP = g_configManager().getNumber(LIVESTREAM_MAXIMUM_VIEWERS_PER_IP);
	if (maxViewersPerIP > 0 && viewersByIP >= maxViewersPerIP) {
		reason = "Livestream viewer limit per IP reached. Please try again later.";
		return false;
	}

	const auto maxViewers = caster->isPremium() ? g_configManager().getNumber(LIVESTREAM_PREMIUM_MAXIMUM_VIEWERS) : g_configManager().getNumber(LIVESTREAM_MAXIMUM_VIEWERS);
	if (maxViewers > 0 && static_cast<int32_t>(session->viewers.size()) >= maxViewers) {
		reason = "Livestream viewer limit reached. Please try again later.";
		return false;
	}

	const auto casterMinLevel = g_configManager().getNumber(LIVESTREAM_CASTER_MIN_LEVEL);
	if (casterMinLevel > 0 && caster->getLevel() < static_cast<uint32_t>(casterMinLevel)) {
		reason = "The caster does not meet the minimum level requirement to broadcast.";
		return false;
	}

	return true;
}

void LivestreamManager::addViewer(const std::shared_ptr<Player> &caster, const ProtocolGame_ptr &viewer, bool spy) {
	if (!caster || !viewer) {
		return;
	}

	auto &session = ensureSession(caster);
	if (session.viewers.contains(viewer)) {
		return;
	}

	++session.viewerCounter;
	auto viewerName = fmt::format("Viewer-{}", session.viewerCounter);
	(void)session.viewers.try_emplace(viewer, LivestreamViewerInfo { viewerName, session.viewerCounter, viewer->getIP() });
	viewerToCaster[viewer.get()] = caster->getGUID();

	if (spy) {
		return;
	}

	sendChannelEvent(session, viewerName, CHANNELEVENT_JOIN);
	if (session.viewers.size() > session.liveRecord) {
		session.liveRecord = static_cast<uint32_t>(session.viewers.size());
		if (auto liveCaster = session.caster.lock()) {
			liveCaster->kv()->scoped("livestream-system")->set("live-record", static_cast<int>(session.liveRecord));
		}
		if (auto owner = session.owner.lock()) {
			owner->sendTextMessage(TextMessage(MESSAGE_LOOK, fmt::format("New record: {} people are watching your livestream now.", session.liveRecord)));
		}
	}
}

void LivestreamManager::removeViewer(const ProtocolGame_ptr &viewer, bool spy) {
	if (!viewer) {
		return;
	}

	const auto indexIt = viewerToCaster.find(viewer.get());
	if (indexIt == viewerToCaster.end()) {
		return;
	}

	const auto sessionIt = sessions.find(indexIt->second);
	if (sessionIt == sessions.end()) {
		(void)viewerToCaster.erase(indexIt);
		return;
	}

	auto &session = sessionIt->second;
	auto viewerIt = session.viewers.find(viewer);
	if (viewerIt == session.viewers.end()) {
		(void)viewerToCaster.erase(indexIt);
		return;
	}

	const auto viewerName = viewerIt->second.name;
	(void)std::erase(session.mutes, normalizeViewerName(viewerName));
	(void)session.viewers.erase(viewerIt);
	(void)viewerToCaster.erase(indexIt);

	if (!spy) {
		sendChannelEvent(session, viewerName, CHANNELEVENT_LEAVE);
	}
}

void LivestreamManager::handleChat(const ProtocolGame_ptr &client, const std::string &text) {
	if (!client || text.empty()) {
		return;
	}

	const auto indexIt = viewerToCaster.find(client.get());
	if (indexIt == viewerToCaster.end()) {
		const auto caster = client->player;
		auto* session = getSession(caster);
		if (session && session->broadcasting) {
			sendChannelMessage(*session, caster->getName(), text, TALKTYPE_CHANNEL_R1);
		}
		return;
	}

	auto sessionIt = sessions.find(indexIt->second);
	if (sessionIt == sessions.end()) {
		return;
	}

	auto &session = sessionIt->second;
	auto viewerIt = session.viewers.find(client);
	if (viewerIt == session.viewers.end()) {
		return;
	}

	if (text[0] == '/') {
		const auto params = explodeString(text.substr(1), " ", 1);
		if (params.empty()) {
			return;
		}

		if (strcasecmp(params[0].c_str(), "show") == 0) {
			showViewers(client, session);
		} else if (strcasecmp(params[0].c_str(), "name") == 0) {
			changeViewerName(client, session, viewerIt->second, params);
		} else {
			client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "Available commands: /name, /show."));
		}
		return;
	}

	handleViewerMessage(client, session, viewerIt->second, text);
}

void LivestreamManager::broadcastPacket(const std::shared_ptr<Player> &caster, const ProtocolGame_ptr &owner, NetworkMessage &message) {
	if (!caster || !owner || message.getLength() == 0) {
		return;
	}

	const auto opcode = message.getBuffer()[NetworkMessage::INITIAL_BUFFER_POSITION];
	const auto refreshMap = isMapRefreshPacket(opcode);
	if (!refreshMap && !isForwardablePacket(owner, message)) {
		return;
	}

	auto* session = getSession(caster);
	if (!session || !session->broadcasting || session->viewers.empty()) {
		return;
	}

	for (const auto &[viewer, _] : session->viewers) {
		if (!viewer) {
			continue;
		}

		if (!refreshMap) {
			viewer->writeToOutputBuffer(message);
			continue;
		}

		viewer->sendMapDescription(caster->getPosition());
		if (!viewer->oldProtocol) {
			const std::unordered_set<PlayerIcon> iconSet { PlayerIcon::Rooted };
			viewer->sendIcons(iconSet, IconBakragore::None);
		}
	}
}

void LivestreamManager::updateViewerStorage(const std::shared_ptr<Player> &caster) const {
	if (!caster) {
		return;
	}

	const auto* session = getSession(caster);
	if (!session || !session->broadcasting) {
		return;
	}

	if (!DatabaseManager::tableExists("active_livestream_casters")) {
		return;
	}

	g_databaseTasks().execute(fmt::format("UPDATE `active_livestream_casters` SET `livestream_viewers` = {} WHERE `caster_id` = {}", session->viewers.size(), caster->getGUID()));
}

bool LivestreamManager::isMapRefreshPacket(uint8_t opcode) {
	return opcode == 0x64; // Full map
}

bool LivestreamManager::isForwardablePacket(const ProtocolGame_ptr &owner, const NetworkMessage &message) {
	if (!owner || message.getLength() == 0) {
		return false;
	}

	const auto opcode = message.getBuffer()[NetworkMessage::INITIAL_BUFFER_POSITION];
	switch (opcode) {
		case 0x1D:
		case 0x1E:
		case 0x65:
		case 0x66:
		case 0x67:
		case 0x68:
		case 0x69:
		case 0x6A:
		case 0x6B:
		case 0x6C:
		case 0x6D:
		case 0x6E:
		case 0x6F:
		case 0x70:
		case 0x71:
		case 0x72:
		case 0x78:
		case 0x79:
		case 0x82:
		case 0x83:
		case 0x84:
		case 0x85:
		case 0x86:
		case 0x8B:
		case 0x8C:
		case 0x8D:
		case 0x8E:
		case 0x8F:
		case 0x90:
		case 0x91:
		case 0x92:
		case 0x93:
		case 0x95:
		case 0x96:
		case 0x97:
		case 0xA0:
		case 0xA1:
		case 0xA3:
		case 0xA7:
		case 0xB5:
		case 0xEF:
			return true;
		case 0xAA:
			return isForwardableSpeakPacket(owner, message);
		case 0xB4:
			return isForwardableTextMessage(message);
		default:
			return false;
	}
}

bool LivestreamManager::isForwardableSpeakPacket(const ProtocolGame_ptr &owner, const NetworkMessage &message) {
	const auto* buffer = message.getBuffer();
	const auto end = NetworkMessage::INITIAL_BUFFER_POSITION + message.getLength();
	auto pos = static_cast<size_t>(NetworkMessage::INITIAL_BUFFER_POSITION + 1);
	if (pos + 4 >= end) {
		return false;
	}

	const auto statementId = readU32(buffer, pos);
	pos += 4;
	if (pos >= end) {
		return false;
	}

	if (!advanceSpeakMetadata(owner->oldProtocol, buffer, end, statementId, pos)) {
		return false;
	}

	if (pos >= end) {
		return false;
	}

	const auto speakType = static_cast<SpeakClasses>(buffer[pos]);
	if (isChannelSpeakType(speakType)) {
		if (pos + 3 > end) {
			return false;
		}

		const auto channelId = readU16(buffer, pos + 1);
		if (channelId == CHANNEL_LIVESTREAM) {
			return false;
		}
	}

	return !isPrivateSpeakType(buffer[pos]);
}

bool LivestreamManager::isForwardableTextMessage(const NetworkMessage &message) {
	if (message.getLength() < 2) {
		return false;
	}

	const auto messageClass = static_cast<MessageClasses>(message.getBuffer()[NetworkMessage::INITIAL_BUFFER_POSITION + 1]);
	switch (messageClass) {
		case MESSAGE_DAMAGE_DEALT:
		case MESSAGE_DAMAGE_RECEIVED:
		case MESSAGE_DAMAGE_OTHERS:
		case MESSAGE_HEALED:
		case MESSAGE_HEALED_OTHERS:
		case MESSAGE_EXPERIENCE:
		case MESSAGE_EXPERIENCE_OTHERS:
			return true;
		default:
			return false;
	}
}

std::string LivestreamManager::normalizeViewerName(const std::string &name) {
	return asLowerCaseString(name);
}

void LivestreamManager::disconnectViewers(Session &session, bool clearMutes) {
	for (const auto &[viewer, _] : session.viewers) {
		if (viewer) {
			viewer->sendSessionEndInformation(SESSION_END_LOGOUT);
			(void)viewerToCaster.erase(viewer.get());
		}
	}

	session.viewers.clear();
	if (clearMutes) {
		session.mutes.clear();
	}
}

void LivestreamManager::kickViewers(Session &session, const std::vector<std::string> &names) {
	for (const auto &name : names) {
		const auto lowerName = normalizeViewerName(name);
		(void)std::erase_if(session.viewers, [this, &lowerName](const auto &entry) {
			if (normalizeViewerName(entry.second.name) != lowerName) {
				return false;
			}

			if (entry.first) {
				entry.first->sendSessionEndInformation(SESSION_END_LOGOUT);
				(void)viewerToCaster.erase(entry.first.get());
			}

			return true;
		});
	}
}

void LivestreamManager::setBans(Session &session, const std::vector<std::string> &bans) {
	std::set<std::string, std::less<>> normalizedBans;
	for (const auto &ban : bans) {
		(void)normalizedBans.emplace(normalizeViewerName(ban));
	}

	(void)std::erase_if(session.bans, [&normalizedBans](const auto &ban) {
		return !normalizedBans.contains(ban.first);
	});

	for (const auto &ban : normalizedBans) {
		(void)session.bans.try_emplace(ban, 0);
	}

	for (auto it = session.viewers.begin(); it != session.viewers.end();) {
		const auto normalizedViewerName = normalizeViewerName(it->second.name);
		if (!normalizedBans.contains(normalizedViewerName)) {
			++it;
			continue;
		}

		(void)session.bans.insert_or_assign(normalizedViewerName, it->second.ip);
		if (it->first) {
			it->first->sendSessionEndInformation(SESSION_END_LOGOUT);
			(void)viewerToCaster.erase(it->first.get());
		}
		it = session.viewers.erase(it);
	}
}

void LivestreamManager::sendChannelMessage(const Session &session, const std::string &author, const std::string &text, SpeakClasses type) {
	if (auto owner = session.owner.lock()) {
		owner->sendChannelMessage(author, text, type, CHANNEL_LIVESTREAM);
	}

	for (const auto &[viewer, _] : session.viewers) {
		if (viewer) {
			viewer->sendChannelMessage(author, text, type, CHANNEL_LIVESTREAM);
		}
	}
}

void LivestreamManager::sendChannelEvent(const Session &session, const std::string &viewerName, ChannelEvent_t event) {
	if (auto owner = session.owner.lock()) {
		owner->sendChannelEvent(CHANNEL_LIVESTREAM, viewerName, event);
	}

	for (const auto &[viewer, _] : session.viewers) {
		if (viewer) {
			viewer->sendChannelEvent(CHANNEL_LIVESTREAM, viewerName, event);
		}
	}
}

void LivestreamManager::showViewers(const ProtocolGame_ptr &client, const Session &session) const {
	std::vector<std::string> names;
	names.reserve(session.viewers.size());
	for (const auto &[_, viewer] : session.viewers) {
		(void)names.emplace_back(viewer.name);
	}

	client->sendTextMessage(TextMessage(MESSAGE_STATUS, fmt::format("{} spectator{}, {}.", names.size(), names.size() == 1 ? "" : "s", fmt::join(names, ", "))));
}

void LivestreamManager::changeViewerName(const ProtocolGame_ptr &client, Session &session, LivestreamViewerInfo &viewer, const std::vector<std::string> &params) {
	if (params.size() <= 1) {
		client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "Please provide a new name."));
		return;
	}

	auto newName = params[1];
	trimString(newName);
	if (newName.empty()) {
		client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "Please provide a new name."));
		return;
	}

	if (newName.size() < MIN_VIEWER_NAME_LENGTH || newName.size() > MAX_VIEWER_NAME_LENGTH) {
		client->sendTextMessage(TextMessage(MESSAGE_FAILURE, fmt::format("Name must be between {} and {} letters.", MIN_VIEWER_NAME_LENGTH, MAX_VIEWER_NAME_LENGTH)));
		return;
	}

	const auto normalizedName = normalizeViewerName(newName);
	if (session.bans.contains(normalizedName)) {
		client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "This name is banned from this livestream."));
		return;
	}

	const auto nameUsed = std::ranges::any_of(session.viewers, [&normalizedName](const auto &entry) {
		return normalizeViewerName(entry.second.name) == normalizedName;
	});
	if (nameUsed) {
		client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "There is already someone with that name."));
		return;
	}

	sendChannelMessage(session, "", fmt::format("{} was renamed to {}.", viewer.name, newName), TALKTYPE_CHANNEL_O);
	auto muteIt = std::ranges::find(session.mutes, normalizeViewerName(viewer.name));
	if (muteIt != session.mutes.end()) {
		*muteIt = normalizedName;
	}

	viewer.name = newName;
	client->sendTextMessage(TextMessage(MESSAGE_STATUS, fmt::format("Name changed to '{}'.", newName)));
}

void LivestreamManager::handleViewerMessage(const ProtocolGame_ptr &client, const Session &session, const LivestreamViewerInfo &viewer, const std::string &text) {
	const auto now = OTSYS_TIME();
	if (client->m_livestreamMessageCooldownTime + MESSAGE_COOLDOWN_MS < now) {
		client->m_livestreamMessageCooldownTime = now;
		client->m_livestreamMessageCount = 0;
	}

	if (client->m_livestreamMessageCount >= MESSAGE_LIMIT) {
		client->sendTextMessage(TextMessage(MESSAGE_STATUS, fmt::format("Please wait {} seconds to send another message.", ((client->m_livestreamMessageCooldownTime + MESSAGE_COOLDOWN_MS - now) / 1000) + 1)));
		return;
	}

	++client->m_livestreamMessageCount;

	if (std::ranges::find(session.mutes, normalizeViewerName(viewer.name)) != session.mutes.end()) {
		client->sendTextMessage(TextMessage(MESSAGE_FAILURE, "You are muted."));
		return;
	}

	sendChannelMessage(session, viewer.name, text, TALKTYPE_CHANNEL_Y);
}
