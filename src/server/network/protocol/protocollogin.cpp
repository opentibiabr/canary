/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

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
	output->addString(message);
	send(output);

	disconnect();
}

void ProtocolLogin::getCharacterList(const std::string &accountDescriptor, const std::string &password) {
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
		output->addString(ss.str());
	}

	// Add session key
	output->addByte(0x28);
	output->addString(accountDescriptor + "\n" + password);

	// Add char list
	auto [players, result] = account.getAccountPlayers();
	if (enumToValue(AccountErrors_t::Ok) != result) {
		g_logger().warn("Account[{}] failed to load players!", account.getID());
	}

	output->addByte(0x64);

	output->addByte(1); // number of worlds

	output->addByte(0); // world id
	output->addString(g_configManager().getString(SERVER_NAME, __FUNCTION__));
	output->addString(g_configManager().getString(IP, __FUNCTION__));

	output->add<uint16_t>(g_configManager().getNumber(GAME_PORT, __FUNCTION__));

	output->addByte(0);

	uint8_t size = std::min<size_t>(std::numeric_limits<uint8_t>::max(), players.size());
	output->addByte(size);
	for (const auto &[name, deletion] : players) {
		output->addByte(0);
		output->addString(name);
	}

	// Get premium days, check is premium and get lastday
	output->addByte(account.getPremiumRemainingDays());
	output->addByte(account.getPremiumLastDay() > getTimeNow());
	output->add<uint32_t>(account.getPremiumLastDay());

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

	std::string accountDescriptor = msg.getString();
	if (accountDescriptor.empty()) {
		std::ostringstream ss;
		ss << "Invalid " << (oldProtocol ? "username" : "email") << ".";
		disconnectClient(ss.str());
		return;
	}

	std::string password = msg.getString();
// Livestream system login for old protocols
#if FEATURE_LIVESTREAM > 0
	// Cast system login (show casting players on old protocol)
	if (accountDescriptor == "@livestream") {
		if (ProtocolGame::getLivestreamCasters().empty()) {
			disconnectClient("There are no players with the livestream on.");
			return;
		}

		auto thisPtr = std::static_pointer_cast<ProtocolLogin>(shared_from_this());
		g_dispatcher().addEvent([thisPtr, password]() {
			thisPtr->getLivestreamViewersList(password);
		},
		                        "ProtocolLogin::getLivestreamViewersList");

		return;
	}
#endif

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

#if FEATURE_LIVESTREAM > 0
void ProtocolLogin::getLivestreamViewersList(const std::string &password) {
	constexpr uint8_t HEADER_BYTE = 0x14;
	constexpr uint8_t SESSION_KEY_BYTE = 0x28;
	constexpr uint8_t NUMBER_OF_WORLDS = 1;
	constexpr int32_t MIN_RANDOM_VALUE = 1;
	constexpr int32_t MAX_RANDOM_VALUE = 100;

	auto output = OutputMessagePool::getOutputMessage();
	output->addByte(HEADER_BYTE);
	output->addString(fmt::format("{}\nWelcome to Cast System!", normal_random(MIN_RANDOM_VALUE, MAX_RANDOM_VALUE)), "ProtocolLogin::getLivestreamViewersList - Welcome to Cast System!')");

	output->addByte(SESSION_KEY_BYTE);
	output->addString(fmt::format("@livestream\n{}", password), "ProtocolLogin::getCharacterList - accountDescriptor + password");

	output->addByte(uint8_t());
	output->addByte(NUMBER_OF_WORLDS);

	output->addByte(uint8_t());
	output->addString(g_configManager().getString(SERVER_NAME, __FUNCTION__), "ProtocolLogin::getLivestreamViewersList - _configManager().getString(SERVER_NAME)");
	output->addString(g_configManager().getString(IP, __FUNCTION__), "ProtocolLogin::getLivestreamViewersList - g_configManager().getString(IP)");

	output->add<uint16_t>(g_configManager().getNumber(GAME_PORT, __FUNCTION__));

	output->addByte(uint8_t());

	std::vector<std::shared_ptr<Player>> players;

	for (const auto &it : ProtocolGame::getLivestreamCasters()) {
		std::shared_ptr<Player> player = it.first;
		if (!password.empty() && password != player->client->getLivestreamPassword()) {
			continue;
		}
		players.emplace_back(player);
	}

	uint8_t size = std::min<size_t>(std::numeric_limits<uint8_t>::max(), players.size());
	output->addByte(size);
	std::sort(players.begin(), players.end(), Player::sortByLivestreamViewerCount);

	for (const auto &player : players) {
		output->addByte(uint8_t());
		output->addString(player->getName(), "ProtocolLogin::getLivestreamViewersList - player->getName()");
	}

	output->addByte(uint8_t());
	output->addByte(uint8_t());
	output->add<uint32_t>(uint32_t());
	output->add<uint16_t>(uint16_t());

	send(std::move(output));
	disconnect();
}
#endif
