/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "server/network/protocol/protocollogin.h"
#include "server/network/message/outputmessage.h"
#include "game/scheduling/dispatcher.hpp"
#include "creatures/players/account/account.hpp"
#include "io/iologindata.h"
#include "creatures/players/management/ban.h"
#include "game/game.h"
#include "core.hpp"

void ProtocolLogin::disconnectClient(const std::string &message) {
	auto output = OutputMessagePool::getOutputMessage();

	output->addByte(0x0B);
	output->addString(message);
	send(output);

	disconnect();
}

void ProtocolLogin::getCharacterList(const std::string &accountIdentifier, const std::string &password) {
	account::Account account;
	account.setProtocolCompat(oldProtocol);

	if (oldProtocol && !g_configManager().getBoolean(OLD_PROTOCOL)) {
		disconnectClient(fmt::format("Only protocol version {}.{} is allowed.", CLIENT_VERSION_UPPER, CLIENT_VERSION_LOWER));
		return;
	} else if (!oldProtocol) {
		disconnectClient(fmt::format("Only protocol version {}.{} or outdated 11.00 is allowed.", CLIENT_VERSION_UPPER, CLIENT_VERSION_LOWER));
		return;
	}

	if (!IOLoginData::authenticateAccountPassword(accountIdentifier, password, &account)) {
		std::ostringstream ss;
		ss << (oldProtocol ? "Username" : "Email") << " or password is not correct.";
		disconnectClient(ss.str());
		return;
	}

	// Update premium days
	Game::updatePremium(account);

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

	// Add session key
	output->addByte(0x28);
	output->addString(accountIdentifier + "\n" + password);

	// Add char list
	std::vector<account::Player> players;
	account.GetAccountPlayers(&players);
	output->addByte(0x64);

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

	// Add premium days
	output->addByte(0);
	uint32_t days;
	account.GetPremiumRemaningDays(&days);
	output->addByte(0);
	output->add<uint32_t>(time(nullptr) + (days * 86400));

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

	// Old protocol support
	oldProtocol = version == 1100;

	msg.skipBytes(17);
	/*
	 - Skipped bytes:
	 - 4 bytes: client version (971+)
	 - 12 bytes: dat, spr, pic signatures (4 bytes each)
	 - 1 byte: preview world(971+)
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

	std::string accountIdentifier = msg.getString();
	if (accountIdentifier.empty()) {
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

	auto thisPtr = std::static_pointer_cast<ProtocolLogin>(shared_from_this());
	g_dispatcher().addTask(std::bind(&ProtocolLogin::getCharacterList, thisPtr, accountIdentifier, password));
}
