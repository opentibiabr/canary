/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "server/network/protocol/protocollogin.hpp"
#include "server/network/message/outputmessage.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "account/account.hpp"
#include "io/iologindata.hpp"
#include "creatures/players/management/ban.hpp"
#include "game/game.hpp"
#include "core.hpp"
#include "enums/account_errors.hpp"

void ProtocolLogin::disconnectClient(const std::string &message) {
	auto output = OutputMessagePool::getOutputMessage();

	output->addByte(0x0B);
	output->addString(message, "ProtocolLogin::disconnectClient - message");
	send(output);

	disconnect();
}

void ProtocolLogin::getCharacterList(const std::string &accountDescriptor, const std::string &password) {
#if CLIENT_VERSION < 1012
	static uint32_t serverIp = INADDR_NONE;
	if (serverIp == INADDR_NONE) {
		std::string cfgIp = g_configManager().getString(IP, "ProtocolLogin::getCharacterList - getIP");
		serverIp = inet_addr(cfgIp.c_str());
		if (serverIp == INADDR_NONE) {
			struct hostent* he = gethostbyname(cfgIp.c_str());
			if (!he || he->h_addrtype != AF_INET) { // Only ipv4
				disconnectClient("ERROR: Cannot resolve hostname.");
				return;
			}
			memcpy(&serverIp, he->h_addr, sizeof(serverIp));
		}
	}
#endif

	Account account(accountDescriptor);
	account.setProtocolCompat(oldProtocol);

	if (oldProtocol && !g_configManager().getBoolean(OLD_PROTOCOL, __FUNCTION__)) {
		disconnectClient(fmt::format("Only protocol version {}.{} is allowed.", CLIENT_VERSION_UPPER, CLIENT_VERSION_LOWER));
		return;
	} else if (!oldProtocol) {
		disconnectClient(fmt::format("Only protocol version {}.{} or outdated 11.00 is allowed.", CLIENT_VERSION_UPPER, CLIENT_VERSION_LOWER));
		return;
	}

	if (account.load() != enumToValue(AccountErrors_t::Ok) || !account.authenticate(password)) {
		std::ostringstream ss;
		ss << (oldProtocol ? "Username" : "Email") << " or password is not correct.";
		disconnectClient(ss.str());
		return;
	}

	auto output = OutputMessagePool::getOutputMessage();
	const std::string &motd = g_configManager().getString(SERVER_MOTD, __FUNCTION__);
	if (!motd.empty()) {
		// Add MOTD
		output->addByte(0x14);

		std::ostringstream ss;
		ss << g_game().getMotdNum() << "\n"
		   << motd;
		output->addString(ss.str(), "ProtocolLogin::getCharacterList - ss.str()");
	}

#if CLIENT_VERSION >= 1074
	// Add session key
	output->addByte(0x28);
	output->addString(accountDescriptor + "\n" + password, "ProtocolLogin::getCharacterList - accountDescriptor + password");
#endif

	// Add char list
	auto [players, result] = account.getAccountPlayers();
	if (enumToValue(AccountErrors_t::Ok) != result) {
		g_logger().warn("Account[{}] failed to load players!", account.getID());
	}

	output->addByte(0x64);

#if CLIENT_VERSION >= 1012
	output->addByte(1); // number of worlds

	output->addByte(0); // world id
	output->addString(g_configManager().getString(SERVER_NAME, __FUNCTION__), "ProtocolLogin::getCharacterList - _configManager().getString(SERVER_NAME)");
	output->addString(g_configManager().getString(IP, __FUNCTION__), "ProtocolLogin::getCharacterList - g_configManager().getString(IP)");

	output->add<uint16_t>(g_configManager().getNumber(GAME_PORT, __FUNCTION__));

	output->addByte(0);
#else
	uint8_t size = std::min<size_t>(std::numeric_limits<uint8_t>::max(), players.size());
	output->addByte(size);
	for (const auto &[name, deletion] : players) {
		output->addString(name, "ProtocolLogin::getCharacterList - name");
		auto stringName = "ProtocolLogin::getCharacterList - ServerName";
		output->addString(g_configManager().getString(SERVER_NAME, stringName), stringName);
		output->add<uint32_t>(serverIp);
		output->add<uint16_t>(g_configManager().getNumber(GAME_PORT, "ProtocolLogin::getCharacterList - GamePort"));
	#if CLIENT_VERSION >= 971
		output->addByte(0);
		output->addString(name, "ProtocolLogin::getCharacterList - name");
	#endif
	}
#endif

	auto freePremiumEnabled = g_configManager().getBoolean(FREE_PREMIUM, "ProtocolLogin::getCharacterList - FreePremium");
#if CLIENT_VERSION >= 1080
	// Get premium days, check is premium and get lastday
	#if CLIENT_VERSION >= 1082
	output->addByte(account.getPremiumRemainingDays());
	#endif
	output->addByte(account.getPremiumLastDay() > getTimeNow());
	output->add<uint32_t>(account.getPremiumLastDay());
#else
	if (freePremiumEnabled) {
		output->add<uint16_t>(0xFFFF); // client displays free premium
	} else {
		output->add<uint16_t>(account.getPremiumRemainingDays());
	}
#endif

	send(output);

	disconnect();
}

void ProtocolLogin::onRecvFirstMessage(NetworkMessage &msg) {
	if (g_game().getGameState() == GAME_STATE_SHUTDOWN) {
		disconnect();
		return;
	}

	msg.skipBytes(2); // client OS

	uint16_t version = msg.get<uint16_t>();
#if CLIENT_VERSION >= 971
	version = msg.get<uint32_t>();
	msg.skipBytes(17);
	/*
	- Skipped bytes:
	- 4 bytes: client version (971+)
	- 12 bytes: dat, spr, pic signatures (4 bytes each)
	- 1 byte: preview world(971+)
	*/
	msg.skipBytes(17);
#else
	msg.skipBytes(12);
#endif
	/*
	 - Skipped bytes:
	 - 4 bytes: client version (971+)
	 - 12 bytes: dat, spr, pic signatures (4 bytes each)
	 - 1 byte: preview world(971+)
	 */

	// Old protocol support
	oldProtocol = version <= 1100;

#if CLIENT_VERSION >= 770
	if (!Protocol::RSA_decrypt(msg)) {
		auto message = "[ProtocolLogin::onRecvFirstMessage] - RSA Decrypt Failed";
		g_logger().warn(message);
		disconnectClient(message);
		return;
	}

	std::array<uint32_t, 4> key = { msg.get<uint32_t>(), msg.get<uint32_t>(), msg.get<uint32_t>(), msg.get<uint32_t>() };
	enableXTEAEncryption();
	setXTEAKey(key.data());

	#if CLIENT_VERSION >= 830
	setChecksumMethod(CHECKSUM_METHOD_ADLER32);
	#endif
#endif

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

#if CLIENT_VERSION >= 830
	std::string accountDescriptor = msg.getString();
#else
	std::string accountDescriptor = std::to_string(msg.get<uint32_t>());
#endif
	if (accountDescriptor.empty()) {
		std::ostringstream ss;
		ss << "Invalid " << (oldProtocol ? "username" : "email") << ".";
		disconnectClient(ss.str());
		return;
	}

	std::string password = msg.getString();
	if (password.empty()) {
		disconnectClient("Invalid password.");
		return;
	}

	g_dispatcher().addEvent([self = std::static_pointer_cast<ProtocolLogin>(shared_from_this()), accountDescriptor, password] {
		self->getCharacterList(accountDescriptor, password);
	},
							"ProtocolLogin::getCharacterList");
}
