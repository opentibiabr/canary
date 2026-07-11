/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "server/network/protocol/protocollogin.hpp"

#include "config/configmanager.hpp"
#include "security/login_session_manager.hpp"
#include "server/network/message/outputmessage.hpp"
#include "server/network/protocol/protocol_port_utils.hpp"
#include "server/network/protocol/protocol_session_hint.hpp"
#include "server/network/protocol/transport_codec.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "account/account.hpp"
#include "creatures/players/livestream/livestream.hpp"
#include "creatures/players/player.hpp"
#include "io/iologindata.hpp"
#include "creatures/players/management/ban.hpp"
#include "game/game.hpp"
#include "game/multichannel/channel_registry.hpp"
#include "core.hpp"
#include "enums/account_errors.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
#endif

void ProtocolLogin::disconnectClient(const std::string &message) const {
	const auto output = OutputMessagePool::getOutputMessage();

	output->addByte(0x0B);
	output->addString(message);
	send(output);

	disconnect();
}

void ProtocolLogin::getCharacterList(const std::string &accountDescriptor, const std::string &password) const {
	Account account(accountDescriptor);
	account.setProtocolCompat(oldProtocol);

	if (oldProtocol && !g_configManager().getBoolean(OLD_PROTOCOL)) {
		disconnectClient(ProtocolProfileRegistry::getUnsupportedClientProtocolMessage(false));
		return;
	}

	if (account.load() != AccountErrors_t::Ok || !account.authenticate(password)) {
		std::ostringstream ss;
		ss << (oldProtocol ? "Username" : "Email") << " or password is not correct.";
		disconnectClient(ss.str());
		return;
	}

	auto output = OutputMessagePool::getOutputMessage();
	const std::string &motd = g_configManager().getString(SERVER_MOTD);
	if (!motd.empty()) {
		// Add MOTD
		output->addByte(0x14);

		std::ostringstream ss;
		ss << g_game().getMotdNum() << "\n"
		   << motd;
		output->addString(ss.str());
	}

	// Add char list
	auto [players, result] = account.getAccountPlayers();
	if (AccountErrors_t::Ok != result) {
		g_logger().warn("Account[{}] failed to load players!", account.getID());
	}

	const auto* loginLayout = protocolProfile ? ProtocolProfileRegistry::resolveAccountLoginLayout(protocolProfile->id) : nullptr;
	const auto characterListLayout = loginLayout ? loginLayout->characterListLayout : AccountCharacterListLayout::WorldListWithSessionKey;

	// Modern, non-old-protocol clients configured for authType=="session" can
	// carry an opaque token in this same field instead of account+password
	// (see docs/systems/login-session-manager.md); every other combination
	// keeps sending the legacy string unchanged.
	std::string sessionKey = accountDescriptor + "\n" + password;
	if (loginLayout && loginLayout->sendsSessionKey && !oldProtocol && protocolProfile && g_configManager().getString(AUTH_TYPE) == "session") {
		std::vector<std::string> allowedCharacterNames;
		allowedCharacterNames.reserve(players.size());
		for (const auto &[name, deletion] : players) {
			allowedCharacterNames.emplace_back(name);
		}

		LoginSessionIssueParams issueParams;
		issueParams.accountId = account.getID();
		issueParams.allowedCharacterNames = std::move(allowedCharacterNames);
		issueParams.protocolProfile = protocolProfile->id;
		if (auto secureToken = LoginSessionManager::getInstance().issueToken(issueParams)) {
			sessionKey = std::move(*secureToken);
		}
	}

	if (loginLayout && loginLayout->sendsSessionKey) {
		// Add session key
		output->addByte(0x28);
		output->addString(sessionKey);
	}

	output->addByte(0x64);

	if (characterListLayout == AccountCharacterListLayout::LegacyCharacterList) {
		// Multi-channel cluster (see docs/multichannel/ARCHITECTURE.md §3.2):
		// the 8.60 layout has no separate world table, so each channel is
		// represented by repeating every character once per channel, each
		// row carrying that channel's own numeric IPv4/port. This never
		// creates a second `players` row - it's purely a login-list
		// presentation of the same account/character list once per channel.
		if (g_configManager().getBoolean(MULTICHANNEL_ENABLED)) {
			const auto channels = g_channelRegistry().getLoginListChannels();
			if (!channels.empty()) {
				struct LegacyChannelEndpoint {
					std::string name;
					uint32_t ip;
					uint16_t port;
				};
				std::vector<LegacyChannelEndpoint> endpoints;
				endpoints.reserve(channels.size());
				for (const auto &channel : channels) {
					const auto channelIp = protocol_port_utils::legacyIpStringToNumber(channel.externalHost);
					if (channelIp == 0) {
						g_logger().warn("[ProtocolLogin::getCharacterList] - Channel '{}' has a non-numeric external_host '{}'; legacy 8.60 clients require a numeric IPv4 address, skipping this channel for legacy login lists.", channel.name, channel.externalHost);
						continue;
					}
					endpoints.push_back({ channel.name, channelIp, static_cast<uint16_t>(channel.gamePort) });
				}

				if (endpoints.empty()) {
					g_logger().warn("[ProtocolLogin::getCharacterList] - No channel has a legacy-compatible numeric IP; falling back to single-channel legacy list.");
				} else {
					const std::size_t totalRows = std::min<std::size_t>(std::numeric_limits<uint8_t>::max(), players.size() * endpoints.size());
					output->addByte(static_cast<uint8_t>(totalRows));

					std::vector<std::string> characterNames;
					characterNames.reserve(players.size());
					std::size_t rowsWritten = 0;
					for (const auto &endpoint : endpoints) {
						for (const auto &[name, deletion] : players) {
							if (rowsWritten >= totalRows) {
								break;
							}
							output->addString(name);
							output->addString(endpoint.name);
							output->add<uint32_t>(endpoint.ip);
							output->add<uint16_t>(endpoint.port);
							++rowsWritten;
						}
					}
					for (const auto &[name, deletion] : players) {
						characterNames.emplace_back(name);
					}

					output->add<uint16_t>(std::min<uint32_t>(std::numeric_limits<uint16_t>::max(), account.getPremiumRemainingDays()));

					send(output);

					if (protocolProfile) {
						ProtocolSessionHintStore::getInstance().registerHint(getIP(), protocolProfile->id, sessionKey, characterNames);
					}

					disconnect();
					return;
				}
			}
		}

		const auto serverName = g_configManager().getString(SERVER_NAME);
		const auto configuredWorldIp = g_configManager().getString(IP);
		const auto worldIp = protocol_port_utils::legacyIpStringToNumber(configuredWorldIp);
		if (worldIp == 0) {
			g_logger().warn("Legacy character list cannot encode configured IP '{}'; old clients require a numeric IPv4 address.", configuredWorldIp);
			disconnectClient("Legacy 8.60 clients require the server IP to be a numeric IPv4 address.");
			return;
		}

		uint8_t size = std::min<size_t>(std::numeric_limits<uint8_t>::max(), players.size());
		output->addByte(size);

		const auto worldPort = protocolProfile ? protocol_port_utils::getGamePortForProfile(*protocolProfile) : protocol_port_utils::getModernGamePort();
		std::vector<std::string> characterNames;
		characterNames.reserve(size);
		for (const auto &[name, deletion] : players) {
			output->addString(name);
			output->addString(serverName);
			output->add<uint32_t>(worldIp);
			output->add<uint16_t>(worldPort);
			characterNames.emplace_back(name);
		}

		output->add<uint16_t>(std::min<uint32_t>(std::numeric_limits<uint16_t>::max(), account.getPremiumRemainingDays()));

		send(output);

		if (protocolProfile) {
			ProtocolSessionHintStore::getInstance().registerHint(getIP(), protocolProfile->id, sessionKey, characterNames);
		}

		disconnect();
		return;
	}

	// Multi-channel cluster (see docs/multichannel/ARCHITECTURE.md §3.2): this
	// layout already supports a world table plus a per-character world-id
	// byte, so a channel is just another world entry, and each character is
	// repeated once per channel with that channel's world index - no second
	// `players` row is ever created for this. Falls straight through to the
	// original single-world behavior when the flag is off or no channel is
	// registered yet, so single-channel installs are byte-for-byte
	// unaffected.
	if (g_configManager().getBoolean(MULTICHANNEL_ENABLED)) {
		const auto channels = g_channelRegistry().getLoginListChannels();
		if (!channels.empty()) {
			const auto worldCount = std::min<std::size_t>(std::numeric_limits<uint8_t>::max(), channels.size());
			output->addByte(static_cast<uint8_t>(worldCount));

			for (std::size_t index = 0; index < worldCount; ++index) {
				const auto &channel = channels[index];
				output->addByte(static_cast<uint8_t>(index)); // world id
				output->addString(channel.name);
				output->addString(channel.externalHost);
				output->add<uint16_t>(static_cast<uint16_t>(channel.gamePort));
				output->addByte(0); // preview/unknown flag, unused
			}

			const std::size_t totalRows = std::min<std::size_t>(std::numeric_limits<uint8_t>::max(), players.size() * worldCount);
			output->addByte(static_cast<uint8_t>(totalRows));

			std::vector<std::string> characterNames;
			characterNames.reserve(players.size());
			std::size_t rowsWritten = 0;
			for (std::size_t index = 0; index < worldCount && rowsWritten < totalRows; ++index) {
				for (const auto &[name, deletion] : players) {
					if (rowsWritten >= totalRows) {
						break;
					}
					output->addByte(static_cast<uint8_t>(index));
					output->addString(name);
					++rowsWritten;
				}
			}
			for (const auto &[name, deletion] : players) {
				characterNames.emplace_back(name);
			}

			output->addByte(account.getPremiumRemainingDays());
			output->addByte(account.getPremiumLastDay() > getTimeNow());
			output->add<uint32_t>(account.getPremiumLastDay());

			send(output);

			if (protocolProfile) {
				ProtocolSessionHintStore::getInstance().registerHint(getIP(), protocolProfile->id, sessionKey, characterNames);
			}

			disconnect();
			return;
		}
	}

	output->addByte(1); // number of worlds

	output->addByte(0); // world id
	output->addString(g_configManager().getString(SERVER_NAME));
	output->addString(g_configManager().getString(IP));

	output->add<uint16_t>(protocolProfile ? protocol_port_utils::getGamePortForProfile(*protocolProfile) : protocol_port_utils::getModernGamePort());

	output->addByte(0);

	uint8_t size = std::min<size_t>(std::numeric_limits<uint8_t>::max(), players.size());
	output->addByte(size);
	std::vector<std::string> characterNames;
	characterNames.reserve(size);
	for (const auto &[name, deletion] : players) {
		output->addByte(0);
		output->addString(name);
		characterNames.emplace_back(name);
	}

	// Get premium days, check is premium and get lastday
	output->addByte(account.getPremiumRemainingDays());
	output->addByte(account.getPremiumLastDay() > getTimeNow());
	output->add<uint32_t>(account.getPremiumLastDay());

	send(output);

	if (protocolProfile) {
		ProtocolSessionHintStore::getInstance().registerHint(getIP(), protocolProfile->id, sessionKey, characterNames);
	}

	disconnect();
}

const AccountLoginLayout* ProtocolLogin::resolveLoginLayout(NetworkMessage &msg, uint16_t version) {
	const auto* loginLayout = ProtocolProfileRegistry::resolveAccountLoginLayout(version);
	if (!loginLayout) {
		disconnectClient(fmt::format("Unsupported client protocol version {}.", version));
		return nullptr;
	}

	protocolProfile = ProtocolProfileRegistry::getProfile(loginLayout->profileId);
	if (!protocolProfile || !ProtocolProfileRegistry::isProfileAllowed(protocolProfile->id)) {
		disconnectClient(fmt::format("Unsupported client protocol version {}.", version));
		return nullptr;
	}

	if (!loginLayout->hasAssetSignaturesBeforeRsa) {
		msg.skipBytes(loginLayout->bytesToSkipBeforeRsa);
		return loginLayout;
	}

	if (!msg.canRead(sizeof(uint32_t) * 3)) {
		disconnectClient(fmt::format("Invalid login packet for protocol version {}.", version));
		return nullptr;
	}

	const ClientAssetSignatures assetSignatures {
		.dat = msg.get<uint32_t>(),
		.spr = msg.get<uint32_t>(),
		.pic = msg.get<uint32_t>(),
	};

	protocolProfile = ProtocolProfileRegistry::resolveByClientVersionAndAssets(version, assetSignatures);
	if (!protocolProfile || !ProtocolProfileRegistry::isProfileAllowed(protocolProfile->id)) {
		disconnectClient(fmt::format("Unsupported client protocol version {}.", version));
		return nullptr;
	}

	loginLayout = ProtocolProfileRegistry::resolveAccountLoginLayout(protocolProfile->id);
	if (!loginLayout) {
		disconnectClient(fmt::format("Unsupported client protocol version {}.", version));
		return nullptr;
	}

	return loginLayout;
}

void ProtocolLogin::onRecvFirstMessage(NetworkMessage &msg) {
	if (g_game().getGameState() == GAME_STATE_SHUTDOWN) {
		disconnect();
		return;
	}

	msg.skipBytes(2); // client OS

	auto version = msg.get<uint16_t>();
	const auto* loginLayout = resolveLoginLayout(msg, version);
	if (!loginLayout) {
		return;
	}

	if (const auto connection = getConnection()) {
		connection->setTransportCodec(TransportCodecs::get(loginLayout->responseTransport), InitialTransportState::ResolvedFromPrelude);
	}

	// Old protocol support
	oldProtocol = protocolProfile->hasFeature(ProtocolFeature::OldProtocolCompat);
	/*
	 - Current/11.00 skips the remaining pre-RSA metadata:
	   4 bytes client version, 12 bytes dat/spr/pic signatures, 1 preview byte.
	 - 8.60 layouts read the dat/spr/pic signatures before RSA so the profile can
	   be resolved from the actual asset contract instead of the protocol number only.
	 */

	if (!Protocol::RSA_decrypt(msg)) {
		g_logger().warn("[ProtocolLogin::onRecvFirstMessage] - RSA Decrypt Failed");
		disconnect();
		return;
	}

	std::array<uint32_t, 4> key = { msg.get<uint32_t>(), msg.get<uint32_t>(), msg.get<uint32_t>(), msg.get<uint32_t>() };
	enableXTEAEncryption();
	setXTEAKey(key.data());

	setChecksumMethod(CHECKSUM_METHOD_ADLER32);

	if (g_game().getGameState() == GAME_STATE_STARTUP) {
		disconnectClient("Gameworld is starting up. Please wait.");
		return;
	}

	if (g_game().getGameState() == GAME_STATE_MAINTAIN) {
		disconnectClient("Gameworld is under maintenance.\nPlease re-connect in a while.");
		return;
	}

	BanInfo banInfo;
	auto curConnection = getConnection();
	if (!curConnection) {
		return;
	}

	if (IOBan::isIpBanned(curConnection->getIP(), banInfo)) {
		if (banInfo.reason.empty()) {
			banInfo.reason = "(none)";
		}

		std::ostringstream ss;
		ss << "Your IP has been banned until " << formatDateShort(banInfo.expiresAt) << " by " << banInfo.bannedBy << ".\n\nReason specified:\n"
		   << banInfo.reason;
		disconnectClient(ss.str());
		return;
	}

	std::string accountDescriptor = msg.getString();
	if (accountDescriptor.empty()) {
		std::ostringstream ss;
		ss << "Invalid " << (oldProtocol ? "username" : "email") << ".";
		disconnectClient(ss.str());
		return;
	}

	std::string password = msg.getString();
	if (accountDescriptor == "@livestream") {
		if (oldProtocol && !g_configManager().getBoolean(OLD_PROTOCOL)) {
			disconnectClient(ProtocolProfileRegistry::getUnsupportedClientProtocolMessage(false));
			return;
		}

		g_dispatcher().addEvent(
			[self = std::static_pointer_cast<ProtocolLogin>(shared_from_this()), password] {
				self->getLivestreamCharacterList(password);
			},
			"ProtocolLogin::getLivestreamCharacterList"
		);
		return;
	}

	if (password.empty()) {
		disconnectClient("Invalid password.");
		return;
	}

	g_dispatcher().addEvent(
		[self = std::static_pointer_cast<ProtocolLogin>(shared_from_this()), accountDescriptor, password] {
			self->getCharacterList(accountDescriptor, password);
		},
		__FUNCTION__
	);
}

void ProtocolLogin::getLivestreamCharacterList(const std::string &password) const {
	const auto casters = g_livestream().getBroadcastingCasters(password);
	if (casters.empty()) {
		disconnectClient("There are no players with the livestream on.");
		return;
	}

	auto output = OutputMessagePool::getOutputMessage();
	output->addByte(0x14);
	output->addString("Welcome to Livestream System!");

	output->addByte(0x28);
	output->addString(fmt::format("@livestream\n{}", password));

	output->addByte(0x64);
	output->addByte(0x01); // worlds
	output->addByte(0x00);
	output->addString(g_configManager().getString(SERVER_NAME));
	output->addString(g_configManager().getString(IP));
	output->add<uint16_t>(g_configManager().getNumber(GAME_PORT));
	output->addByte(0x00);

	const auto casterCount = static_cast<uint8_t>(std::min<size_t>(std::numeric_limits<uint8_t>::max(), casters.size()));
	output->addByte(casterCount);
	for (size_t index = 0; index < casterCount; ++index) {
		const auto &caster = casters[index];
		output->addByte(0x00);
		output->addString(caster->getName());
	}

	output->addByte(0x00);
	output->addByte(0x00);
	output->add<uint32_t>(0x00);

	send(output);
	disconnect();
}
