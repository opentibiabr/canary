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

#include "pch.hpp"

#include "server/network/protocol/protocollogin.h"
#include "server/network/message/outputmessage.h"
#include "game/scheduling/tasks.h"
#include "creatures/players/account/account.hpp"
#include "io/iologindata.h"
#include "creatures/players/management/ban.h"
#include "game/game.h"

void ProtocolLogin::disconnectClient(const std::string& message, uint16_t version)
{
	auto output = OutputMessagePool::getOutputMessage();

	output->addByte(__FUNCTION__, version >= 1076 ? 0x0B : 0x0A);
	output->addString(__FUNCTION__, message);
	send(output);

	disconnect();
}

void ProtocolLogin::getCharacterList(const std::string& email, const std::string& password, uint16_t version)
{
	account::Account account;
	if (!IOLoginData::authenticateAccountPassword(email, password, &account)) {
		disconnectClient("Email or password is not correct", version);
		return;
	}

	// Update premium days
	Game::updatePremium(account);

	auto output = OutputMessagePool::getOutputMessage();
	const std::string& motd = g_configManager().getString(MOTD);
	if (!motd.empty()) {
		// Add MOTD
		output->addByte(__FUNCTION__, 0x14);

		std::ostringstream ss;
		ss << g_game().getMotdNum() << "\n" << motd;
		output->addString(__FUNCTION__, ss.str());
	}

	// Add session key
	output->addByte(__FUNCTION__, 0x28);
	output->addString(__FUNCTION__, email + "\n" + password);

	// Add char list
	std::vector<account::Player> players;
	account.GetAccountPlayers(&players);
	output->addByte(__FUNCTION__, 0x64);

	output->addByte(__FUNCTION__, 1);  // number of worlds

	output->addByte(__FUNCTION__, 0);  // world id
	output->addString(__FUNCTION__, g_configManager().getString(SERVER_NAME));
	output->addString(__FUNCTION__, g_configManager().getString(IP));

	output->addU16(__FUNCTION__, g_configManager().getShortNumber(GAME_PORT));

	output->addByte(__FUNCTION__, 0);

	uint8_t size = std::min<size_t>(std::numeric_limits<uint8_t>::max(),
                                  players.size());
	output->addByte(__FUNCTION__, size);
	for (uint8_t i = 0; i < size; i++) {
		output->addByte(__FUNCTION__, 0);
		output->addString(__FUNCTION__, players[i].name);
	}

	// Add premium days
	output->addByte(__FUNCTION__, 0);
	if (g_configManager().getBoolean(FREE_PREMIUM)) {
		output->addByte(__FUNCTION__, 1);
		output->addU32(__FUNCTION__, 0);
	} else {
		uint32_t days;
		account.GetPremiumRemaningDays(&days);
		output->addByte(__FUNCTION__, 0);
		output->addU32(__FUNCTION__, static_cast<uint32_t>(getTimeNow() + (days * 86400)));
	}

	send(output);

	disconnect();
}

void ProtocolLogin::onRecvFirstMessage(NetworkMessage& msg)
{
	if (g_game().getGameState() == GAME_STATE_SHUTDOWN) {
		disconnect();
		return;
	}

	msg.skipBytes(2); // client OS

	uint16_t version = msg.get<uint16_t>();

	msg.skipBytes(17);
	/*
	 - Skipped bytes:
	 - 4 bytes: client version (971+)
	 - 12 bytes: dat, spr, pic signatures (4 bytes each)
	 - 1 byte: preview world(971+)
	 */

	if (!Protocol::RSA_decrypt(msg)) {
		SPDLOG_WARN("[ProtocolLogin::onRecvFirstMessage] - RSA Decrypt Failed");
		disconnect();
		return;
	}

	std::array<uint32_t, 4> key = {msg.get<uint32_t>(), msg.get<uint32_t>(), msg.get<uint32_t>(), msg.get<uint32_t>()};
	enableXTEAEncryption();
	setXTEAKey(key.data());

	setChecksumMethod(CHECKSUM_METHOD_ADLER32);

	if (g_game().getGameState() == GAME_STATE_STARTUP) {
		disconnectClient("Gameworld is starting up. Please wait.", version);
		return;
	}

	if (g_game().getGameState() == GAME_STATE_MAINTAIN) {
		disconnectClient("Gameworld is under maintenance.\nPlease re-connect in a while.", version);
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
		ss << "Your IP has been banned until " << formatDateShort(banInfo.expiresAt) << " by " << banInfo.bannedBy << ".\n\nReason specified:\n" << banInfo.reason;
		disconnectClient(ss.str(), version);
		return;
	}

	std::string email = msg.getString();
	if (email.empty()) {
		disconnectClient("Invalid email.", version);
		return;
	}

	std::string password = msg.getString();
	if (password.empty()) {
		disconnectClient("Invalid password.", version);
		return;
	}

	auto thisPtr = std::static_pointer_cast<ProtocolLogin>(shared_from_this());
	g_dispatcher().addTask(createTask(std::bind(&ProtocolLogin::getCharacterList, thisPtr, email, password, version)));
}
