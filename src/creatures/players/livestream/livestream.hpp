/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <string_view>

#include "server/network/protocol/protocolgame.hpp"

class NetworkMessage;
class Player;

struct LivestreamViewerInfo {
	std::string name;
	uint32_t id = 0;
	uint32_t ip = 0;
};

struct LivestreamState {
	std::string description;
	bool broadcast = false;
	std::string password;
	std::vector<std::string> names;
	std::vector<std::string> mutes;
	std::vector<std::string> bans;
	std::vector<std::string> kick;
};

class LivestreamManager {
public:
	[[nodiscard]] static LivestreamManager &getInstance();

	[[nodiscard]] bool isBroadcasting(const std::shared_ptr<Player> &caster) const;
	[[nodiscard]] bool isViewer(const ProtocolGame_ptr &client) const;
	[[nodiscard]] std::shared_ptr<Player> getCasterForViewer(const ProtocolGame_ptr &client) const;
	[[nodiscard]] LivestreamState getState(const std::shared_ptr<Player> &caster) const;
	[[nodiscard]] size_t getViewerCount(const std::shared_ptr<Player> &caster) const;
	[[nodiscard]] std::string getPassword(const std::shared_ptr<Player> &caster) const;
	[[nodiscard]] std::string getDescription(const std::shared_ptr<Player> &caster) const;
	[[nodiscard]] std::string getBroadcastTimeString(const std::shared_ptr<Player> &caster) const;
	[[nodiscard]] std::vector<std::shared_ptr<Player>> getBroadcastingCasters(std::string_view password = "") const;

	void setInitialState(const std::shared_ptr<Player> &caster, std::string_view password, std::string_view description, uint32_t liveRecord);
	void applyState(const std::shared_ptr<Player> &caster, const LivestreamState &state);
	void stopBroadcast(const std::shared_ptr<Player> &caster, bool clearAll);
	bool canWatch(const std::shared_ptr<Player> &caster, const ProtocolGame_ptr &viewer, const std::string &password, std::string &reason) const;
	void addViewer(const std::shared_ptr<Player> &caster, const ProtocolGame_ptr &viewer, bool spy = false);
	void removeViewer(const ProtocolGame_ptr &viewer, bool spy = false);
	void handleChat(const ProtocolGame_ptr &client, const std::string &text);
	void broadcastPacket(const std::shared_ptr<Player> &caster, const ProtocolGame_ptr &owner, NetworkMessage &message);
	void updateViewerStorage(const std::shared_ptr<Player> &caster) const;

private:
	struct Session {
		std::weak_ptr<Player> caster;
		std::weak_ptr<ProtocolGame> owner;
		std::map<ProtocolGame_ptr, LivestreamViewerInfo> viewers;
		std::vector<std::string> mutes;
		std::map<std::string, uint32_t, std::less<>> bans;
		std::string password;
		std::string description;
		bool broadcasting = false;
		int64_t broadcastStarted = 0;
		uint32_t liveRecord = 0;
		uint32_t viewerCounter = 0;
	};

	[[nodiscard]] Session* getSession(const std::shared_ptr<Player> &caster);
	[[nodiscard]] const Session* getSession(const std::shared_ptr<Player> &caster) const;
	[[nodiscard]] static uint32_t getCasterGuid(const std::shared_ptr<Player> &caster);
	[[nodiscard]] static bool isMapRefreshPacket(uint8_t opcode);
	[[nodiscard]] static bool isForwardablePacket(const ProtocolGame_ptr &owner, const NetworkMessage &message);
	[[nodiscard]] static bool isForwardableSpeakPacket(const ProtocolGame_ptr &owner, const NetworkMessage &message);
	[[nodiscard]] static bool isForwardableTextMessage(const NetworkMessage &message);
	[[nodiscard]] static std::string normalizeViewerName(const std::string &name);

	Session &ensureSession(const std::shared_ptr<Player> &caster);
	void disconnectViewers(Session &session, bool clearMutes);
	void kickViewers(Session &session, const std::vector<std::string> &names);
	void setBans(Session &session, const std::vector<std::string> &bans);
	void sendChannelMessage(const Session &session, const std::string &author, const std::string &text, SpeakClasses type);
	void sendChannelEvent(const Session &session, const std::string &viewerName, ChannelEvent_t event);
	void showViewers(const ProtocolGame_ptr &client, const Session &session) const;
	void changeViewerName(const ProtocolGame_ptr &client, Session &session, LivestreamViewerInfo &viewer, const std::vector<std::string> &params);
	void handleViewerMessage(const ProtocolGame_ptr &client, const Session &session, const LivestreamViewerInfo &viewer, const std::string &text);

	std::unordered_map<uint32_t, Session> sessions;
	std::unordered_map<ProtocolGame*, uint32_t> viewerToCaster;
};

[[nodiscard]] LivestreamManager &g_livestream();
