/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "otpch.h"

#include "server/network/protocol/protocollogin.h"

#include "server/network/message/outputmessage.h"
#include "security/rsa.h"
#include "game/scheduling/tasks.h"
#include "creatures/players/account/account.hpp"
#include "io/iologindata.h"
#include "creatures/players/management/ban.h"
#include "game/game.h"

#include <algorithm>
#include <limits>
#include <vector>

extern Game g_game;

void ProtocolLogin::disconnectClient(const std::string& message, uint16_t version)
{
	auto output = OutputMessagePool::getOutputMessage();

	output->addByte(version >= 1076 ? 0x0B : 0x0A);
	output->addString(message);
	send(output);

	disconnect();
}

#if GAME_FEATURE_SESSIONKEY > 0
#if GAME_FEATURE_LOGIN_EMAIL > 0
void ProtocolLogin::getCharacterList(const std::string& email, const std::string& password, std::string& token, uint32_t version)
#else
void ProtocolLogin::getCharacterList(const std::string& accountName, const std::string& password, const std::string& token, uint32_t version)
#endif
#else
void ProtocolLogin::getCharacterList(const std::string& accountName, const std::string& password, uint32_t version)
#endif
{
	#if !(GAME_FEATURE_LOGIN_EXTENDED > 0)
	static uint32_t serverIp = INADDR_NONE;
	if (serverIp == INADDR_NONE) {
		std::string cfgIp = g_configManager().getString(IP);
		serverIp = inet_addr(cfgIp.c_str());
		if (serverIp == INADDR_NONE) {
			struct hostent* he = gethostbyname(cfgIp.c_str());
			//Only ipv4
			if (!he || he->h_addrtype != AF_INET) {
				disconnectClient("ERROR: Cannot resolve hostname.", version);
				return;
			}
			memcpy(&serverIp, he->h_addr, sizeof(serverIp));
		}
	}
	#endif

	auto connection = getConnection();
	if (!connection) {
		return;
	}

	BanInfo banInfo;
	if (IOBan::isIpBanned(connection->getIP(), banInfo)) {
		if (banInfo.reason.empty()) {
			banInfo.reason = "(none)";
		}

		std::ostringstream ss;
		ss << "Your IP has been banned until " << formatDateShort(banInfo.expiresAt) << " by " << banInfo.bannedBy << ".\n\nReason specified:\n" << banInfo.reason;
		disconnectClient(ss.str(), version);
		return;
	}

	account::Account account;
	#if GAME_FEATURE_LOGIN_EMAIL > 0
	if (!IOLoginData::authenticateAccountPassword(email, password, &account)) {
		disconnectClient("Email or password is not correct.", version);
		SPDLOG_ERROR("There was a problem authenticating email or password for player email {}", email);
		return;
	}
	#else
	if (!IOLoginData::authenticateAccountPassword(accountName, password, &account)) {
		disconnectClient("Account name or password is not correct.", version);
		SPDLOG_ERROR("There was a problem authenticating account name or password for player account {}", accountName);
		return;
	}
	#endif

	auto output = OutputMessagePool::getOutputMessage();

	#if GAME_FEATURE_SESSIONKEY > 0
	uint32_t ticks = time(nullptr) / AUTHENTICATOR_PERIOD;
	std::string accountSecret;
	account.GetSecret(&accountSecret);
	if (!accountSecret.empty()) {
		if (token.empty() || !(token == generateToken(accountSecret, ticks) || token == generateToken(accountSecret, ticks - 1) || token == generateToken(accountSecret, ticks + 1))) {
			output->addByte(0x0D);
			output->addByte(0);
			send(output);
			disconnect();
			return;
		}
		output->addByte(0x0C);
		output->addByte(0);
	}
	#endif

	// Update premium days
	Game::updatePremium(account);

	// Check for MOTD
	const std::string& motd = g_configManager().getString(MOTD);
	if (!motd.empty()) {
		// Add MOTD
		output->addByte(0x14);

		std::ostringstream ss;
		ss << g_game.getMotdNum() << "\n" << motd;
		output->addString(ss.str());
	}

	#if GAME_FEATURE_SESSIONKEY > 0
	// Add session key
	output->addByte(0x28);
	#if GAME_FEATURE_LOGIN_EMAIL > 0
	output->addString(email + "\n" + password + "\n" + token + "\n" + std::to_string(ticks));
	#else
	output->addString(accountName + "\n" + password + "\n" + token + "\n" + std::to_string(ticks));
	#endif
	#endif

	// Add char list
	std::vector<account::Player> players;
	account.GetAccountPlayers(&players);
	output->addByte(0x64);

	#if GAME_FEATURE_LOGIN_EXTENDED > 0
	output->addByte(1); // number of worlds

	output->addByte(0); // world id
	output->addString(g_configManager().getString(SERVER_NAME));
	output->addString(g_configManager().getString(IP));
	output->add<uint16_t>(g_configManager().getShortNumber(GAME_PORT));
	output->addByte(0);

	uint8_t size = std::min<size_t>(std::numeric_limits<uint8_t>::max(), players.size());
	output->addByte(size);
	for (uint8_t i = 0; i < size; i++) {
		output->addByte(0);
		output->addString(players[i].name);
	}
	#else
	uint8_t size = std::min<size_t>(std::numeric_limits<uint8_t>::max(), players.size());
	output->addByte(size);
	for (uint8_t i = 0; i < size; i++) {
		output->addString(players[i].name);
		output->addString(g_configManager().getString(SERVER_NAME));
		output->add<uint32_t>(serverIp);
		output->add<uint16_t>(g_configManager().getNumber(GAME_PORT));
		#if GAME_FEATURE_PREVIEW_STATE > 0
		output->addByte(0);
		#endif
	}
	#endif

	// Add premium days
	#if GAME_FEATURE_LOGIN_PREMIUM_TIMESTAMP > 0
	#if GAME_FEATURE_LOGIN_PREMIUM_TYPE > 0
	output->addByte(0);
	#endif
	if (g_configManager().getBoolean(FREE_PREMIUM)) {
		output->addByte(1);
		output->add<uint32_t>(0);
	} else {
		uint32_t days;
		account.GetPremiumRemaningDays(&days);
		output->addByte(0);
		output->add<uint32_t>(time(nullptr) + (days * 86400));
	}
	#else
	if (g_configManager().getBoolean(FREE_PREMIUM))
	{
		output->add<uint16_t>(0xFFFF); //client displays free premium
	} else {
		output->add<uint16_t>(account.premiumDays);
	}
	#endif

	send(output);

	disconnect();
}

void ProtocolLogin::onRecvFirstMessage(NetworkMessage& msg)
{
	if (g_game.getGameState() == GAME_STATE_SHUTDOWN) {
		disconnect();
		return;
	}

	msg.skipBytes(2); // client OS

	uint32_t clientVersion = static_cast<uint32_t>(msg.get<uint16_t>());
	if (clientVersion >= 971) {
		clientVersion = msg.get<uint32_t>();
		msg.skipBytes(13);
	} else {
		msg.skipBytes(12);
	}
	/*
	 * Skipped bytes:
	 * 4 bytes: protocolVersion(971+)
	 * 12 bytes: dat, spr, pic signatures (4 bytes each)
	 * 1 byte: preview world(971+)
	 */

	if (clientVersion >= 770) {
		if (!Protocol::RSA_decrypt(msg)) {
			disconnect();
			return;
		}

		uint32_t key[4] = {msg.get<uint32_t>(), msg.get<uint32_t>(), msg.get<uint32_t>(), msg.get<uint32_t>()};
		enableXTEAEncryption();
		setXTEAKey(key);

		if (clientVersion >= 830) {
			setChecksumMethod(CHECKSUM_METHOD_ADLER32);
		}
	}

	if (clientVersion != CLIENT_VERSION) {
		std::ostringstream ss;
		ss << "Only clients with protocol " << CLIENT_VERSION_UPPER << "." << CLIENT_VERSION_LOWER << " allowed!";
		disconnectClient(ss.str(), clientVersion);
		return;
	}

	if (g_game.getGameState() == GAME_STATE_STARTUP) {
		disconnectClient("Gameworld is starting up. Please wait.", clientVersion);
		return;
	}

	if (g_game.getGameState() == GAME_STATE_MAINTAIN) {
		disconnectClient("Gameworld is under maintenance.\nPlease re-connect in a while.", clientVersion);
		return;
	}

	#if GAME_FEATURE_ACCOUNT_NAME > 0
	std::string accountName = msg.getString();
	if (accountName.empty()) {
		disconnectClient("Invalid account name.", clientVersion);
		return;
	}
	#else
	std::string email = std::to_string(msg.get<uint32_t>());
	if (email.empty()) {
		disconnectClient("Invalid email.", clientVersion);
		return;
	}
	#endif
	

	std::string password = msg.getString();
	if (password.empty()) {
		disconnectClient("Invalid password.", clientVersion);
		return;
	}

	#if GAME_FEATURE_SESSIONKEY > 0
	std::string authToken = msg.getString();
	#if GAME_FEATURE_LOGIN_EMAIL > 0
	// read authenticator token and stay logged in flag from last 128 bytes
	msg.skipBytes((msg.getLength() - 128) - msg.getBufferPosition());
	if (!Protocol::RSA_decrypt(msg)) {
		disconnectClient("Invalid authentification token.", clientVersion);
		return;
	}

	auto thisPtr = std::static_pointer_cast<ProtocolLogin>(shared_from_this());
	g_dispatcher.addTask(createTask(std::bind(&ProtocolLogin::getCharacterList, thisPtr, std::move(email), std::move(password), std::move(authToken), clientVersion)));
	#else
	auto thisPtr = std::static_pointer_cast<ProtocolLogin>(shared_from_this());
	g_dispatcher.addTask(createTask(std::bind(&ProtocolLogin::getCharacterList, thisPtr, std::move(accountName), std::move(password), std::move(authToken), clientVersion)));
	#endif
	#else
	auto thisPtr = std::static_pointer_cast<ProtocolLogin>(shared_from_this());
	g_dispatcher.addTask(createTask(std::bind(&ProtocolLogin::getCharacterList, thisPtr, std::move(accountName), std::move(password), clientVersion)));
	#endif
}
