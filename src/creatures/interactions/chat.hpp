/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

enum SpeakClasses : uint8_t;

class Party;
class Player;

using UsersMap = std::map<uint32_t, std::shared_ptr<Player>>;
using InvitedMap = std::map<uint32_t, std::shared_ptr<Player>>;

class ChatChannel {
public:
	ChatChannel() = default;
	ChatChannel(uint16_t channelId, std::string channelName);

	virtual ~ChatChannel() = default;

	bool addUser(const std::shared_ptr<Player> &player);
	bool removeUser(const std::shared_ptr<Player> &player);
	bool hasUser(const std::shared_ptr<Player> &player) const;

	bool talk(const std::shared_ptr<Player> &fromPlayer, SpeakClasses type, const std::string &text) const;
	void sendToAll(const std::string &message, SpeakClasses type) const;

	const std::string &getName() const;
	uint16_t getId() const;
	const UsersMap &getUsers() const;
	virtual const InvitedMap* getInvitedUsers() const;

	virtual uint32_t getOwner() const;

	bool isPublicChannel() const;

	bool executeOnJoinEvent(const std::shared_ptr<Player> &player) const;
	bool executeCanJoinEvent(const std::shared_ptr<Player> &player) const;
	bool executeOnLeaveEvent(const std::shared_ptr<Player> &player) const;
	bool executeOnSpeakEvent(const std::shared_ptr<Player> &player, SpeakClasses &type, const std::string &message) const;

protected:
	UsersMap users;

	std::string name;

	int32_t canJoinEvent = -1;
	int32_t onJoinEvent = -1;
	int32_t onLeaveEvent = -1;
	int32_t onSpeakEvent = -1;

	uint16_t id {};
	bool publicChannel = false;

	friend class Chat;
};

class PrivateChatChannel final : public ChatChannel {
public:
	PrivateChatChannel(uint16_t channelId, [[maybe_unused]] std::string channelName);

	uint32_t getOwner() const override;
	void setOwner(uint32_t newOwner);

	bool isInvited(uint32_t guid) const;

	void invitePlayer(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &invitePlayer);
	void excludePlayer(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &excludePlayer);

	bool removeInvite(uint32_t guid);

	void closeChannel() const;

	[[nodiscard]] const InvitedMap* getInvitedUsers() const override;

private:
	InvitedMap invites;
	uint32_t owner = 0;
};

using ChannelList = std::list<std::shared_ptr<ChatChannel>>;

class Chat {
public:
	Chat();

	// non-copyable
	Chat(const Chat &) = delete;
	Chat &operator=(const Chat &) = delete;

	static Chat &getInstance();

	bool load();

	std::shared_ptr<ChatChannel> createChannel(const std::shared_ptr<Player> &player, uint16_t channelId);
	bool deleteChannel(const std::shared_ptr<Player> &player, uint16_t channelId);

	std::shared_ptr<ChatChannel> addUserToChannel(const std::shared_ptr<Player> &player, uint16_t channelId);
	bool removeUserFromChannel(const std::shared_ptr<Player> &player, uint16_t channelId);
	void removeUserFromAllChannels(const std::shared_ptr<Player> &player);

	bool talkToChannel(const std::shared_ptr<Player> &player, SpeakClasses type, const std::string &text, uint16_t channelId);

	ChannelList getChannelList(const std::shared_ptr<Player> &player);

	std::shared_ptr<ChatChannel> getChannel(const std::shared_ptr<Player> &player, uint16_t channelId);
	std::shared_ptr<ChatChannel> getChannelById(uint16_t channelId);
	std::shared_ptr<ChatChannel> getGuildChannelById(uint32_t guildId);
	std::shared_ptr<PrivateChatChannel> getPrivateChannel(const std::shared_ptr<Player> &player) const;

	LuaScriptInterface* getScriptInterface();

private:
	std::map<uint16_t, std::shared_ptr<ChatChannel>> normalChannels;
	std::map<uint16_t, std::shared_ptr<PrivateChatChannel>> privateChannels;
	std::map<std::shared_ptr<Party>, std::shared_ptr<ChatChannel>> partyChannels;
	std::map<uint32_t, std::shared_ptr<ChatChannel>> guildChannels;

	LuaScriptInterface scriptInterface;

	std::shared_ptr<PrivateChatChannel> dummyPrivate;
};

constexpr auto g_chat = Chat::getInstance;
