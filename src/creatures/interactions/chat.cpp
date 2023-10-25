/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/interactions/chat.hpp"
#include "game/game.hpp"
#include "utils/pugicast.hpp"
#include "game/scheduling/dispatcher.hpp"

bool PrivateChatChannel::isInvited(uint32_t guid) const {
	if (guid == getOwner()) {
		return true;
	}
	return invites.find(guid) != invites.end();
}

bool PrivateChatChannel::removeInvite(uint32_t guid) {
	return invites.erase(guid) != 0;
}

void PrivateChatChannel::invitePlayer(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &invitePlayer) {
	auto result = invites.emplace(invitePlayer->getGUID(), invitePlayer);
	if (!result.second) {
		return;
	}

	std::ostringstream ss;
	ss << player->getName() << " invites you to " << player->getPossessivePronoun() << " private chat channel.";
	invitePlayer->sendTextMessage(MESSAGE_PARTY_MANAGEMENT, ss.str());

	ss.str(std::string());
	ss << invitePlayer->getName() << " has been invited.";
	player->sendTextMessage(MESSAGE_PARTY_MANAGEMENT, ss.str());

	for (const auto &it : users) {
		it.second->sendChannelEvent(id, invitePlayer->getName(), CHANNELEVENT_INVITE);
	}
}

void PrivateChatChannel::excludePlayer(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &excludePlayer) {
	if (!removeInvite(excludePlayer->getGUID())) {
		return;
	}

	removeUser(excludePlayer);

	std::ostringstream ss;
	ss << excludePlayer->getName() << " has been excluded.";
	player->sendTextMessage(MESSAGE_PARTY_MANAGEMENT, ss.str());

	excludePlayer->sendClosePrivate(id);

	for (const auto &it : users) {
		it.second->sendChannelEvent(id, excludePlayer->getName(), CHANNELEVENT_EXCLUDE);
	}
}

void PrivateChatChannel::closeChannel() const {
	for (const auto &it : users) {
		it.second->sendClosePrivate(id);
	}
}

bool ChatChannel::addUser(const std::shared_ptr<Player> &player) {
	if (users.find(player->getID()) != users.end()) {
		return false;
	}

	if (!executeOnJoinEvent(player)) {
		return false;
	}

	// TODO: Move to script when guild channels can be scripted
	if (id == CHANNEL_GUILD) {
		const auto guild = player->getGuild();
		if (guild && !guild->getMotd().empty()) {
			g_dispatcher().scheduleEvent(150, std::bind(&Game::sendGuildMotd, &g_game(), player->getID()), "Game::sendGuildMotd");
		}
	}

	if (!publicChannel) {
		for (const auto &it : users) {
			it.second->sendChannelEvent(id, player->getName(), CHANNELEVENT_JOIN);
		}
	}

	users[player->getID()] = player;
	return true;
}

bool ChatChannel::removeUser(const std::shared_ptr<Player> &player) {
	auto iter = users.find(player->getID());
	if (iter == users.end()) {
		return false;
	}

	users.erase(iter);

	if (!publicChannel) {
		for (const auto &it : users) {
			it.second->sendChannelEvent(id, player->getName(), CHANNELEVENT_LEAVE);
		}
	}

	executeOnLeaveEvent(player);
	return true;
}

bool ChatChannel::hasUser(const std::shared_ptr<Player> &player) {
	return users.find(player->getID()) != users.end();
}

void ChatChannel::sendToAll(const std::string &message, SpeakClasses type) const {
	for (const auto &it : users) {
		it.second->sendChannelMessage("", message, type, id);
	}
}

bool ChatChannel::talk(const std::shared_ptr<Player> &fromPlayer, SpeakClasses type, const std::string &text) {
	if (users.find(fromPlayer->getID()) == users.end()) {
		return false;
	}

	for (const auto &it : users) {
		it.second->sendToChannel(fromPlayer, type, text, id);
	}
	return true;
}

bool ChatChannel::executeCanJoinEvent(const std::shared_ptr<Player> &player) {
	if (canJoinEvent == -1) {
		return true;
	}

	// canJoin(player)
	LuaScriptInterface* scriptInterface = g_chat().getScriptInterface();
	if (!scriptInterface->reserveScriptEnv()) {
		g_logger().error("[CanJoinChannelEvent::execute - Player {}, on channel {}] "
						 "Call stack overflow. Too many lua script calls being nested.",
						 player->getName(), getName());
		return false;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	env->setScriptId(canJoinEvent, scriptInterface);

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(canJoinEvent);
	LuaScriptInterface::pushUserdata(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	return scriptInterface->callFunction(1);
}

bool ChatChannel::executeOnJoinEvent(const std::shared_ptr<Player> &player) {
	if (onJoinEvent == -1) {
		return true;
	}

	// onJoin(player)
	LuaScriptInterface* scriptInterface = g_chat().getScriptInterface();
	if (!scriptInterface->reserveScriptEnv()) {
		g_logger().error("[OnJoinChannelEvent::execute - Player {}, on channel {}] "
						 "Call stack overflow. Too many lua script calls being nested",
						 player->getName(), getName());
		return false;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	env->setScriptId(onJoinEvent, scriptInterface);

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(onJoinEvent);
	LuaScriptInterface::pushUserdata(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	return scriptInterface->callFunction(1);
}

bool ChatChannel::executeOnLeaveEvent(const std::shared_ptr<Player> &player) {
	if (onLeaveEvent == -1) {
		return true;
	}

	// onLeave(player)
	LuaScriptInterface* scriptInterface = g_chat().getScriptInterface();
	if (!scriptInterface->reserveScriptEnv()) {
		g_logger().error("[OnLeaveChannelEvent::execute - Player {}, on channel {}] "
						 "Call stack overflow. Too many lua script calls being nested.",
						 player->getName(), getName());
		return false;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	env->setScriptId(onLeaveEvent, scriptInterface);

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(onLeaveEvent);
	LuaScriptInterface::pushUserdata(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	return scriptInterface->callFunction(1);
}

bool ChatChannel::executeOnSpeakEvent(const std::shared_ptr<Player> &player, SpeakClasses &type, const std::string &message) {
	if (onSpeakEvent == -1) {
		return true;
	}

	// onSpeak(player, type, message)
	LuaScriptInterface* scriptInterface = g_chat().getScriptInterface();
	if (!scriptInterface->reserveScriptEnv()) {
		g_logger().error("[OnSpeakChannelEvent::execute - Player {}, type {}] "
						 "Call stack overflow. Too many lua script calls being nested.",
						 player->getName(), fmt::underlying(type));
		return false;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	env->setScriptId(onSpeakEvent, scriptInterface);

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(onSpeakEvent);
	LuaScriptInterface::pushUserdata(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, type);
	LuaScriptInterface::pushString(L, message);

	bool result = false;
	int size0 = lua_gettop(L);
	int ret = scriptInterface->protectedCall(L, 3, 1);
	if (ret != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else if (lua_gettop(L) > 0) {
		if (lua_isboolean(L, -1)) {
			result = LuaScriptInterface::getBoolean(L, -1);
		} else if (lua_isnumber(L, -1)) {
			result = true;
			type = LuaScriptInterface::getNumber<SpeakClasses>(L, -1);
		}
		lua_pop(L, 1);
	}

	if ((lua_gettop(L) + 4) != size0) {
		LuaScriptInterface::reportError(nullptr, "Stack size changed!");
	}
	scriptInterface->resetScriptEnv();
	return result;
}

Chat::Chat() :
	scriptInterface("Chat Interface"),
	dummyPrivate(std::make_shared<PrivateChatChannel>(CHANNEL_PRIVATE, "Private Chat Channel")) {
	scriptInterface.initState();
}

bool Chat::load() {
	pugi::xml_document doc;
	auto coreFolder = g_configManager().getString(CORE_DIRECTORY);
	auto folder = coreFolder + "/chatchannels/chatchannels.xml";
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	for (auto channelNode : doc.child("channels").children()) {
		uint16_t channelId = pugi::cast<uint16_t>(channelNode.attribute("id").value());
		std::string channelName = channelNode.attribute("name").as_string();
		bool isPublic = channelNode.attribute("public").as_bool();
		pugi::xml_attribute scriptAttribute = channelNode.attribute("script");

		auto it = normalChannels.find(channelId);
		if (it != normalChannels.end()) {
			const auto &channel = it->second;
			channel->publicChannel = isPublic;
			channel->name = channelName;

			if (scriptAttribute) {
				if (scriptInterface.loadFile(coreFolder + "/chatchannels/scripts/" + std::string(scriptAttribute.as_string()), scriptAttribute.as_string()) == 0) {
					channel->onSpeakEvent = scriptInterface.getEvent("onSpeak");
					channel->canJoinEvent = scriptInterface.getEvent("canJoin");
					channel->onJoinEvent = scriptInterface.getEvent("onJoin");
					channel->onLeaveEvent = scriptInterface.getEvent("onLeave");
				} else {
					g_logger().warn("[Chat::load] - Can not load script: {}", scriptAttribute.as_string());
				}
			}

			UsersMap tempUserMap = std::move(channel->users);
			for (const auto &pair : tempUserMap) {
				channel->addUser(pair.second);
			}
			continue;
		}

		const auto &channel(std::make_shared<ChatChannel>(channelId, channelName));
		channel->publicChannel = isPublic;

		if (scriptAttribute) {
			if (scriptInterface.loadFile(coreFolder + "/chatchannels/scripts/" + std::string(scriptAttribute.as_string()), scriptAttribute.as_string()) == 0) {
				channel->onSpeakEvent = scriptInterface.getEvent("onSpeak");
				channel->canJoinEvent = scriptInterface.getEvent("canJoin");
				channel->onJoinEvent = scriptInterface.getEvent("onJoin");
				channel->onLeaveEvent = scriptInterface.getEvent("onLeave");
			} else {
				g_logger().warn("[Chat::load] Can not load script: {}", scriptAttribute.as_string());
			}
		}

		normalChannels[channel->id] = channel;
	}
	return true;
}

std::shared_ptr<ChatChannel> Chat::createChannel(const std::shared_ptr<Player> &player, uint16_t channelId) {
	if (getChannel(player, channelId) != nullptr) {
		return nullptr;
	}

	switch (channelId) {
		case CHANNEL_GUILD: {
			const auto guild = player->getGuild();
			if (guild != nullptr) {
				auto ret = guildChannels.emplace(std::make_pair(guild->getId(), std::make_shared<ChatChannel>(channelId, guild->getName())));
				return ret.first->second;
			}
			break;
		}

		case CHANNEL_PARTY: {
			auto party = player->getParty();
			if (party != nullptr) {
				auto ret = partyChannels.emplace(std::make_pair(party, std::make_shared<ChatChannel>(channelId, "Party")));
				return ret.first->second;
			}
			break;
		}

		case CHANNEL_PRIVATE: {
			// only 1 private channel for each premium player
			if (!player->isPremium() || (getPrivateChannel(player) != nullptr)) {
				return nullptr;
			}

			// find a free private channel slot
			for (uint16_t i = 100; i < 10000; ++i) {
				auto ret = privateChannels.emplace(std::make_pair(i, std::make_shared<PrivateChatChannel>(i, player->getName() + "'s Channel")));
				if (ret.second) { // second is a bool that indicates that a new channel has been placed in the map
					const auto &newChannel = (*ret.first).second;
					newChannel->setOwner(player->getGUID());
					return newChannel;
				}
			}
			break;
		}

		default:
			break;
	}
	return nullptr;
}

bool Chat::deleteChannel(const std::shared_ptr<Player> &player, uint16_t channelId) {
	switch (channelId) {
		case CHANNEL_GUILD: {
			const auto guild = player->getGuild();
			if (guild == nullptr) {
				return false;
			}

			auto it = guildChannels.find(guild->getId());
			if (it == guildChannels.end()) {
				return false;
			}

			guildChannels.erase(it);
			break;
		}

		case CHANNEL_PARTY: {
			auto party = player->getParty();
			if (party == nullptr) {
				return false;
			}

			auto it = partyChannels.find(party);
			if (it == partyChannels.end()) {
				return false;
			}

			partyChannels.erase(it);
			break;
		}

		default: {
			auto it = privateChannels.find(channelId);
			if (it == privateChannels.end()) {
				return false;
			}

			it->second->closeChannel();

			privateChannels.erase(it);
			break;
		}
	}
	return true;
}

std::shared_ptr<ChatChannel> Chat::addUserToChannel(const std::shared_ptr<Player> &player, uint16_t channelId) {
	const auto &channel = getChannel(player, channelId);
	if ((channel != nullptr) && channel->addUser(player)) {
		return channel;
	}
	return nullptr;
}

bool Chat::removeUserFromChannel(const std::shared_ptr<Player> &player, uint16_t channelId) {
	const auto &channel = getChannel(player, channelId);
	if ((channel == nullptr) || !channel->removeUser(player)) {
		return false;
	}

	if (channel->getOwner() == player->getGUID()) {
		deleteChannel(player, channelId);
	}
	return true;
}

void Chat::removeUserFromAllChannels(const std::shared_ptr<Player> &player) {
	for (auto &it : normalChannels) {
		it.second->removeUser(player);
	}

	for (auto &it : partyChannels) {
		it.second->removeUser(player);
	}

	for (auto &it : guildChannels) {
		it.second->removeUser(player);
	}

	auto it = privateChannels.begin();
	while (it != privateChannels.end()) {
		const auto &channel = it->second;
		channel->removeInvite(player->getGUID());
		channel->removeUser(player);
		if (channel->getOwner() == player->getGUID()) {
			channel->closeChannel();
			it = privateChannels.erase(it);
		} else {
			++it;
		}
	}
}

bool Chat::talkToChannel(const std::shared_ptr<Player> &player, SpeakClasses type, const std::string &text, uint16_t channelId) {
	const auto &channel = getChannel(player, channelId);
	if (channel == nullptr) {
		return false;
	}

	if (channelId == CHANNEL_GUILD) {
		GuildRank_ptr rank = player->getGuildRank();
		if (rank && rank->level > 1) {
			type = TALKTYPE_CHANNEL_O;
		} else if (type != TALKTYPE_CHANNEL_Y) {
			type = TALKTYPE_CHANNEL_Y;
		}
	} else if (type != TALKTYPE_CHANNEL_Y && (channelId == CHANNEL_PRIVATE || channelId == CHANNEL_PARTY)) {
		type = TALKTYPE_CHANNEL_Y;
	}

	if (!channel->executeOnSpeakEvent(player, type, text)) {
		return false;
	}

	return channel->talk(player, type, text);
}

ChannelList Chat::getChannelList(const std::shared_ptr<Player> &player) {
	ChannelList list;
	if (player->getGuild()) {
		auto channel = getChannel(player, CHANNEL_GUILD);
		if (channel) {
			list.push_back(channel);
		} else {
			channel = createChannel(player, CHANNEL_GUILD);
			if (channel) {
				list.push_back(channel);
			}
		}
	}

	if (player->getParty()) {
		auto channel = getChannel(player, CHANNEL_PARTY);
		if (channel) {
			list.push_back(channel);
		} else {
			channel = createChannel(player, CHANNEL_PARTY);
			if (channel) {
				list.push_back(channel);
			}
		}
	}

	for (const auto &it : normalChannels) {
		const auto &channel = getChannel(player, it.first);
		if (channel) {
			list.push_back(channel);
		}
	}

	bool hasPrivate = false;
	for (auto &it : privateChannels) {
		if (const auto &channel = it.second) {
			uint32_t guid = player->getGUID();
			if (channel->isInvited(guid)) {
				list.push_back(channel);
			}

			if (channel->getOwner() == guid) {
				hasPrivate = true;
			}
		}
	}

	if (!hasPrivate && player->isPremium()) {
		list.push_front(dummyPrivate);
	}
	return list;
}

std::shared_ptr<ChatChannel> Chat::getChannel(const std::shared_ptr<Player> &player, uint16_t channelId) {
	switch (channelId) {
		case CHANNEL_GUILD: {
			const auto guild = player->getGuild();
			if (guild != nullptr) {
				auto it = guildChannels.find(guild->getId());
				if (it != guildChannels.end()) {
					return it->second;
				}
			}
			break;
		}

		case CHANNEL_PARTY: {
			auto party = player->getParty();
			if (party != nullptr) {
				auto it = partyChannels.find(party);
				if (it != partyChannels.end()) {
					return it->second;
				}
			}
			break;
		}

		default: {
			auto it = normalChannels.find(channelId);
			if (it != normalChannels.end()) {
				const auto &channel = it->second;
				if (!channel->executeCanJoinEvent(player)) {
					return nullptr;
				}
				return channel;
			}

			auto it2 = privateChannels.find(channelId);
			if (it2 != privateChannels.end() && it2->second->isInvited(player->getGUID())) {
				return it2->second;
			}
			break;
		}
	}
	return nullptr;
}

std::shared_ptr<ChatChannel> Chat::getGuildChannelById(uint32_t guildId) {
	auto it = guildChannels.find(guildId);
	if (it == guildChannels.end()) {
		return nullptr;
	}
	return it->second;
}

std::shared_ptr<ChatChannel> Chat::getChannelById(uint16_t channelId) {
	auto it = normalChannels.find(channelId);
	if (it == normalChannels.end()) {
		return nullptr;
	}
	return it->second;
}

std::shared_ptr<PrivateChatChannel> Chat::getPrivateChannel(const std::shared_ptr<Player> &player) {
	for (auto &it : privateChannels) {
		if (it.second->getOwner() == player->getGUID()) {
			return it.second;
		}
	}
	return nullptr;
}
