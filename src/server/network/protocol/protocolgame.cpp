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

#include "creatures/players/management/ban.h"
#include "core.hpp"
#include "declarations.hpp"
#include "game/game.h"
#include "creatures/players/imbuements/imbuements.h"
#include "io/iobestiary.h"
#include "io/iologindata.h"
#include "io/iomarket.h"
#include "lua/modules/modules.h"
#include "creatures/monsters/monster.h"
#include "creatures/monsters/monsters.h"
#include "server/network/message/outputmessage.h"
#include "creatures/players/player.h"
#include "creatures/players/grouping/familiars.h"
#include "server/network/protocol/protocolgame.h"
#include "game/scheduling/scheduler.h"
#include "creatures/combat/spells.h"
#include "creatures/players/management/waitlist.h"
#include "items/weapons/weapons.h"

/*
* NOTE: This namespace is used so that we can add functions without having to declare them in the ".hpp/.h" file
* Do not use functions only in the .cpp scope without having a namespace, it may conflict with functions in other files of the same name
*/

// This "getIteration" function will allow us to get the total number of iterations that run within a specific map
// Very useful to send the total amount in certain bytes in the ProtocolGame class
namespace InternalProtocol {
template <typename T>
uint16_t getIterationIncreaseCount(T& map) {
	uint16_t totalIterationCount = 0;
	for ([[maybe_unused]] const auto &[first, second] : map) {
		totalIterationCount++;
	}

	return totalIterationCount;
}

template <typename T>
uint16_t getVectorIterationIncreaseCount(T& vector) {
	uint16_t totalIterationCount = 0;
	for ([[maybe_unused]] const auto &vectorIteration : vector) {
		totalIterationCount++;
	}

	return totalIterationCount;
}

void sendMarketBrowseOffers(const std::string &function, NetworkMessage &msg, std::map<uint32_t, uint16_t> counterMap, const HistoryMarketOfferList& offers, uint32_t offersToSend)
{
	uint32_t i = 0;
	msg.addU32(function, offersToSend);
	for (auto it = offers.begin(); i < offersToSend; ++it, ++i)
	{
		uint16_t timeStamp = counterMap[it->timestamp];
		timeStamp++;
		msg.addU32(function, it->timestamp);
		msg.addU16(function, timeStamp);
		msg.addU16(function, it->itemId);
		if (Item::items[it->itemId].upgradeClassification > 0) {
			msg.addByte(function, it->tier);
		}
		msg.addU16(function, it->amount);
		msg.addU64(function, it->price);
		msg.addByte(function, it->state);
	}
	i = 0;
	counterMap.clear();
}

} // Namespace

ProtocolGame::ProtocolGame(Connection_ptr initConnection) : Protocol(initConnection) {
	version = CLIENT_VERSION;
}

template <typename Callable, typename... Args>
void ProtocolGame::addGameTask(Callable function, Args &&... args)
{
	g_dispatcher().addTask(createTask(std::bind(function, &g_game(), std::forward<Args>(args)...)));
}

template <typename Callable, typename... Args>
void ProtocolGame::addGameTaskTimed(uint32_t delay, Callable function, Args &&... args)
{
	g_dispatcher().addTask(createTask(delay, std::bind(function, &g_game(), std::forward<Args>(args)...)));
}

void ProtocolGame::AddItem(NetworkMessage &msg, uint16_t id, uint8_t count, uint8_t tier)
{
	const ItemType &it = Item::items[id];

	msg.addU16(__FUNCTION__, it.id);

	if (it.stackable)
	{
		msg.addByte(__FUNCTION__, count);
	}
	else if (it.isSplash() || it.isFluidContainer())
	{
		msg.addByte(__FUNCTION__, count);
	}
	else if (it.isContainer())
	{
		msg.addByte(__FUNCTION__, 0x00);
		msg.addByte(__FUNCTION__, 0x00);
	}
	if (it.isPodium) {
		msg.addU16(__FUNCTION__, 0);
		msg.addU16(__FUNCTION__, 0);
		msg.addU16(__FUNCTION__, 0);

		msg.addByte(__FUNCTION__, 2);
		msg.addByte(__FUNCTION__, 0x01);
	}
	if (it.upgradeClassification > 0) {
		msg.addByte(__FUNCTION__, tier);
	}
	if (it.expire || it.expireStop || it.clockExpire) {
		msg.addU32(__FUNCTION__, it.decayTime);
		msg.addByte(__FUNCTION__, 0x01); // Brand-new
	}
	if (it.wearOut) {
		msg.addU32(__FUNCTION__, it.charges);
		msg.addByte(__FUNCTION__, 0x01); // Brand-new
	}
}

void ProtocolGame::AddItem(NetworkMessage &msg, const Item *item)
{
	if (!item)
	{
		return;
	}

	const ItemType &it = Item::items[item->getID()];

	msg.addU16(__FUNCTION__, it.id);

	if (it.stackable)
	{
		msg.addByte(__FUNCTION__, std::min<uint16_t>(0xFF, item->getItemCount()));
	}
	else if (it.isSplash() || it.isFluidContainer())
	{
		msg.addByte(__FUNCTION__, static_cast<uint8_t>(item->getFluidType()));  
	}
	else if (it.isContainer())
	{
		const Container *container = item->getContainer();
		if (container && container->getHoldingPlayer() == player)
		{
			uint32_t lootFlags = 0;
			for (auto itt : player->quickLootContainers)
			{
				if (itt.second == container)
				{
					lootFlags |= 1 << itt.first;
				}
			}

			if (lootFlags != 0)
			{
				msg.addByte(__FUNCTION__, 0x01);
				msg.addU32(__FUNCTION__, lootFlags);
			}
			else
			{
				msg.addByte(__FUNCTION__, 0x00);
			}
		}
		else
		{
			msg.addByte(__FUNCTION__, 0x00);
		}

		// Quiver ammo count
		if (container && item->isQuiver() && player->getThing(CONST_SLOT_RIGHT) == item) {
			uint16_t ammoTotal = 0;
			for (Item* listItem : container->getItemList()) {
				if (player->getLevel() >= Item::items[listItem->getID()].minReqLevel) {
					ammoTotal += listItem->getItemCount();
				}
			}
			msg.addByte(__FUNCTION__, 0x01);
			msg.addU32(__FUNCTION__, ammoTotal);
		}
		else
		{
			msg.addByte(__FUNCTION__, 0x00);
		}
	}

	if (it.isPodium) {
		const ItemAttributes::CustomAttribute* podiumVisible = item->getCustomAttribute("PodiumVisible");
		const ItemAttributes::CustomAttribute* lookType = item->getCustomAttribute("LookType");
		const ItemAttributes::CustomAttribute* lookMount = item->getCustomAttribute("LookMount");
		const ItemAttributes::CustomAttribute* lookDirection = item->getCustomAttribute("LookDirection");

		if (lookType) {
			uint16_t look = static_cast<uint16_t>(boost::get<int64_t>(lookType->value));
			msg.addU16(__FUNCTION__, look);

			if(look != 0) {
				const ItemAttributes::CustomAttribute* lookHead = item->getCustomAttribute("LookHead");
				const ItemAttributes::CustomAttribute* lookBody = item->getCustomAttribute("LookBody");
				const ItemAttributes::CustomAttribute* lookLegs = item->getCustomAttribute("LookLegs");
				const ItemAttributes::CustomAttribute* lookFeet = item->getCustomAttribute("LookFeet");

				msg.addByte(__FUNCTION__, lookHead ? static_cast<uint8_t>(boost::get<int64_t>(lookHead->value)) : 0);
				msg.addByte(__FUNCTION__, lookBody ? static_cast<uint8_t>(boost::get<int64_t>(lookBody->value)) : 0);
				msg.addByte(__FUNCTION__, lookLegs ? static_cast<uint8_t>(boost::get<int64_t>(lookLegs->value)) : 0);
				msg.addByte(__FUNCTION__, lookFeet ? static_cast<uint8_t>(boost::get<int64_t>(lookFeet->value)) : 0);

				const ItemAttributes::CustomAttribute* lookAddons = item->getCustomAttribute("LookAddons");
				msg.addByte(__FUNCTION__, lookAddons ? static_cast<uint8_t>(boost::get<int64_t>(lookAddons->value)) : 0);
			} else {
				msg.addU16(__FUNCTION__, 0);
			}
		} else {
			msg.addU16(__FUNCTION__, 0);
			msg.addU16(__FUNCTION__, 0);
		}

		if (lookMount) {
			uint16_t look = static_cast<uint16_t>(boost::get<int64_t>(lookMount->value));
			msg.addU16(__FUNCTION__, look);

			if (look != 0) {
				const ItemAttributes::CustomAttribute* lookHead = item->getCustomAttribute("LookMountHead");
				const ItemAttributes::CustomAttribute* lookBody = item->getCustomAttribute("LookMountBody");
				const ItemAttributes::CustomAttribute* lookLegs = item->getCustomAttribute("LookMountLegs");
				const ItemAttributes::CustomAttribute* lookFeet = item->getCustomAttribute("LookMountFeet");

				msg.addByte(__FUNCTION__, lookHead ? static_cast<uint8_t>(boost::get<int64_t>(lookHead->value)) : 0);
				msg.addByte(__FUNCTION__, lookBody ? static_cast<uint8_t>(boost::get<int64_t>(lookBody->value)) : 0);
				msg.addByte(__FUNCTION__, lookLegs ? static_cast<uint8_t>(boost::get<int64_t>(lookLegs->value)) : 0);
				msg.addByte(__FUNCTION__, lookFeet ? static_cast<uint8_t>(boost::get<int64_t>(lookFeet->value)) : 0);
			}
		} else {
			msg.addU16(__FUNCTION__, 0);
		}

		msg.addByte(__FUNCTION__, lookDirection ? static_cast<uint8_t>(boost::get<int64_t>(lookDirection->value)) : 2);
		msg.addByte(__FUNCTION__, podiumVisible ? static_cast<uint8_t>(boost::get<int64_t>(podiumVisible->value)) : 0x01);
	}
	if (item->getClassification() > 0) {
		msg.addByte(__FUNCTION__, item->getTier());
	}
	// Timer
	if (it.expire || it.expireStop || it.clockExpire) {
		if (item->hasAttribute(ITEM_ATTRIBUTE_DURATION)) {
			msg.addU32(__FUNCTION__, item->getDuration() / 1000);
			msg.addByte(__FUNCTION__, (item->getDuration() / 1000) == it.decayTime ? 0x01 : 0x00); // Brand-new
		} else {
			msg.addU32(__FUNCTION__, it.decayTime);
			msg.addByte(__FUNCTION__, 0x01); // Brand-new
		}
	}

	// Charge
	if (it.wearOut) {
		if (item->getSubType() == 0) {
			msg.addU32(__FUNCTION__, it.charges);
			msg.addByte(__FUNCTION__, 0x01); // Brand-new
		} else {
			msg.addU32(__FUNCTION__, static_cast<uint32_t>(item->getSubType()));
			msg.addByte(__FUNCTION__, item->getSubType() == it.charges ? 0x01 : 0x00); // Brand-new
		}
	}
}

void ProtocolGame::release()
{
	//dispatcher thread
	if (player && player->client == shared_from_this())
	{
		player->client.reset();
		player->decrementReferenceCounter();
		player = nullptr;
	}

	OutputMessagePool::getInstance().removeProtocolFromAutosend(shared_from_this());
	Protocol::release();
}

void ProtocolGame::login(const std::string &name, uint32_t accountId, OperatingSystem_t operatingSystem)
{
	//dispatcher thread
	Player *foundPlayer = g_game().getPlayerByName(name);
	if (!foundPlayer || g_configManager().getBoolean(ALLOW_CLONES))
	{
		player = new Player(getThis());
		player->setName(name);

		player->incrementReferenceCounter();
		player->setID();

		if (!IOLoginData::preloadPlayer(player, name))
		{
			disconnectClient("Your character could not be loaded.");
			return;
		}

		if (IOBan::isPlayerNamelocked(player->getGUID()))
		{
			disconnectClient("Your character has been namelocked.");
			return;
		}

		if (g_game().getGameState() == GAME_STATE_CLOSING && !player->hasFlag(PlayerFlag_CanAlwaysLogin))
		{
			disconnectClient("The game is just going down.\nPlease try again later.");
			return;
		}

		if (g_game().getGameState() == GAME_STATE_CLOSED && !player->hasFlag(PlayerFlag_CanAlwaysLogin))
		{
			disconnectClient("Server is currently closed.\nPlease try again later.");
			return;
		}

		if (g_configManager().getBoolean(ONLY_PREMIUM_ACCOUNT) && !player->isPremium() && (player->getGroup()->id < account::GROUP_TYPE_GAMEMASTER || player->getAccountType() < account::ACCOUNT_TYPE_GAMEMASTER))
		{
			disconnectClient("Your premium time for this account is out.\n\nTo play please buy additional premium time from our website");
			return;
		}

		if (g_configManager().getBoolean(ONE_PLAYER_ON_ACCOUNT) && player->getAccountType() < account::ACCOUNT_TYPE_GAMEMASTER && g_game().getPlayerByAccount(player->getAccount()))
		{
			disconnectClient("You may only login with one character\nof your account at the same time.");
			return;
		}

		if (!player->hasFlag(PlayerFlag_CannotBeBanned))
		{
			BanInfo banInfo;
			if (IOBan::isAccountBanned(accountId, banInfo))
			{
				if (banInfo.reason.empty())
				{
					banInfo.reason = "(none)";
				}

				std::ostringstream ss;
				if (banInfo.expiresAt > 0)
				{
					ss << "Your account has been banned until " << formatDateShort(banInfo.expiresAt) << " by " << banInfo.bannedBy << ".\n\nReason specified:\n"
                      << banInfo.reason;
				}
				else
				{
					ss << "Your account has been permanently banned by " << banInfo.bannedBy << ".\n\nReason specified:\n"
                      << banInfo.reason;
				}
				disconnectClient(ss.str());
				return;
			}
		}

		WaitingList &waitingList = WaitingList::getInstance();
		if (!waitingList.clientLogin(player))
		{
			uint32_t currentSlot = waitingList.getClientSlot(player);
			uint32_t retryTime = WaitingList::getTime(currentSlot);
			std::ostringstream ss;

			ss << "Too many players online.\nYou are at place "
               << currentSlot << " on the waiting list.";

			auto output = OutputMessagePool::getOutputMessage();
			output->addByte(__FUNCTION__, 0x16);
			output->addString(__FUNCTION__, ss.str());
			output->addByte(__FUNCTION__, retryTime);
			send(output);
			disconnect();
			return;
		}

		if (!IOLoginData::loadPlayerById(player, player->getGUID()))
		{
			disconnectClient("Your character could not be loaded.");
			SPDLOG_WARN("Player {} could not be loaded", player->getName());
			return;
		}

		player->setOperatingSystem(operatingSystem);

		if (!g_game().placeCreature(player, player->getLoginPosition()) && !g_game().placeCreature(player, player->getTemplePosition(), false, true))
		{
			disconnectClient("Temple position is wrong. Please, contact the administrator.");
			SPDLOG_WARN("Player {} temple position is wrong", player->getName());
			return;
		}

		if (operatingSystem >= CLIENTOS_OTCLIENT_LINUX)
		{
			player->registerCreatureEvent("ExtendedOpcode");
		}

		player->lastIP = player->getIP();
		player->lastLoginSaved = std::max<time_t>(time(nullptr), player->lastLoginSaved + 1);
		acceptPackets = true;
	}
	else
	{
		if (eventConnect != 0 || !g_configManager().getBoolean(REPLACE_KICK_ON_LOGIN))
		{
			//Already trying to connect
			disconnectClient("You are already logged in.");
			return;
		}

		if (foundPlayer->client)
		{
			foundPlayer->disconnect();
			foundPlayer->isConnecting = true;

			eventConnect = g_scheduler().addEvent(createSchedulerTask(1000, std::bind(&ProtocolGame::connect, getThis(), foundPlayer->getID(), operatingSystem)));
		}
		else
		{
			connect(foundPlayer->getID(), operatingSystem);
		}
	}
	OutputMessagePool::getInstance().addProtocolToAutosend(shared_from_this());
}

void ProtocolGame::connect(uint32_t playerId, OperatingSystem_t operatingSystem)
{
	eventConnect = 0;

	Player *foundPlayer = g_game().getPlayerByID(playerId);
	if (!foundPlayer || foundPlayer->client)
	{
		disconnectClient("You are already logged in.");
		return;
	}

	if (isConnectionExpired())
	{
		//ProtocolGame::release() has been called at this point and the Connection object
		//no longer exists, so we return to prevent leakage of the Player.
		return;
	}

	player = foundPlayer;
	player->incrementReferenceCounter();

	g_chat().removeUserFromAllChannels(*player);
	player->clearModalWindows();
	player->setOperatingSystem(operatingSystem);
	player->isConnecting = false;

	player->client = getThis();
	player->openPlayerContainers();
	sendAddCreature(player, player->getPosition(), 0, true);
	player->lastIP = player->getIP();
	player->lastLoginSaved = std::max<time_t>(time(nullptr), player->lastLoginSaved + 1);
	player->resetIdleTime();
	acceptPackets = true;
}

void ProtocolGame::logout(bool displayEffect, bool forced)
{
	if (!player) {
		return;
	}

	bool removePlayer = !player->isRemoved() && !forced;
	if (removePlayer && !player->isAccessPlayer()) {
		if (player->getTile()->hasFlag(TILESTATE_NOLOGOUT)) {
			player->sendCancelMessage(RETURNVALUE_YOUCANNOTLOGOUTHERE);
			return;
		}

		if (!player->getTile()->hasFlag(TILESTATE_PROTECTIONZONE) && player->hasCondition(CONDITION_INFIGHT)) {
			player->sendCancelMessage(RETURNVALUE_YOUMAYNOTLOGOUTDURINGAFIGHT);
			return;
		}
	}

	if (removePlayer && !g_creatureEvents().playerLogout(player)) {
		return;
	}

	displayEffect = displayEffect && !player->isRemoved() && player->getHealth() > 0 && !player->isInGhostMode();
	if (displayEffect) {
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
	}

	sendSessionEndInformation(forced ? SESSION_END_FORCECLOSE : SESSION_END_LOGOUT);

	g_game().removeCreature(player, true);
}

void ProtocolGame::onRecvFirstMessage(NetworkMessage &msg)
{
	if (g_game().getGameState() == GAME_STATE_SHUTDOWN)
	{
		disconnect();
		return;
	}

	OperatingSystem_t operatingSystem = static_cast<OperatingSystem_t>(msg.get<uint16_t>());
	if (operatingSystem <= CLIENTOS_NEW_MAC) {
		setChecksumMethod(CHECKSUM_METHOD_SEQUENCE);
		enableCompression();
	} else {
		setChecksumMethod(CHECKSUM_METHOD_ADLER32);
	}
	

	version = msg.get<uint16_t>(); // Protocol version

	clientVersion = static_cast<int32_t>(msg.get<uint32_t>());

	msg.getString(); // Client version (String)

	msg.skipBytes(3); // U16 dat revision, U8 game preview state

	if (!Protocol::RSA_decrypt(msg))
	{
		SPDLOG_WARN("[ProtocolGame::onRecvFirstMessage] - RSA Decrypt Failed");
		disconnect();
		return;
	}

	std::array<uint32_t, 4> key = {msg.get<uint32_t>(), msg.get<uint32_t>(), msg.get<uint32_t>(), msg.get<uint32_t>()};
	enableXTEAEncryption();
	setXTEAKey(key.data());

	msg.skipBytes(1); // gamemaster flag

	std::string sessionKey = msg.getString();
	size_t pos = sessionKey.find('\n');
	if (pos == std::string::npos)
	{
		disconnectClient("You must enter your email.");
		return;
	}

	if (operatingSystem == CLIENTOS_NEW_LINUX)
	{
		// TODO: check what new info for linux is send
		msg.getString();
		msg.getString();
	}

	std::string email = sessionKey.substr(0, pos);
	if (email.empty())
	{
		disconnectClient("You must enter your email.");
		return;
	}

	std::string password = sessionKey.substr(pos + 1);
	std::string characterName = msg.getString();

	uint32_t timeStamp = msg.get<uint32_t>();
	uint8_t randNumber = msg.getByte();
	if (challengeTimestamp != timeStamp || challengeRandom != randNumber)
	{
		disconnect();
		return;
	}

	if (clientVersion != CLIENT_VERSION)
	{
		std::ostringstream ss;
		ss << "Only clients with protocol " << CLIENT_VERSION_UPPER << "." << CLIENT_VERSION_LOWER << " allowed!";
		disconnectClient(ss.str());
		return;
	}

	if (g_game().getGameState() == GAME_STATE_STARTUP)
	{
		disconnectClient("Gameworld is starting up. Please wait.");
		return;
	}

	if (g_game().getGameState() == GAME_STATE_MAINTAIN)
	{
		disconnectClient("Gameworld is under maintenance. Please re-connect in a while.");
		return;
	}

	BanInfo banInfo;
	if (IOBan::isIpBanned(getIP(), banInfo))
	{
		if (banInfo.reason.empty())
		{
			banInfo.reason = "(none)";
		}

		std::ostringstream ss;
		ss << "Your IP has been banned until " << formatDateShort(banInfo.expiresAt) << " by " << banInfo.bannedBy << ".\n\nReason specified:\n"
          << banInfo.reason;
		disconnectClient(ss.str());
		return;
	}

	uint32_t accountId;
	if (!IOLoginData::gameWorldAuthentication(email, password, characterName, &accountId)) {
		disconnectClient("Email or password is not correct.");
		return;
	}

	g_dispatcher().addTask(createTask(std::bind(&ProtocolGame::login, getThis(), characterName, accountId, operatingSystem)));
}

void ProtocolGame::onConnect()
{
	auto output = OutputMessagePool::getOutputMessage();
	static std::random_device rd;
	static std::ranlux24 generator(rd());
	static std::uniform_int_distribution<uint16_t> randNumber(0x00, 0xFF);

	// Skip checksum
	output->skipBytes(sizeof(uint32_t));

	// Packet length & type
	output->addU16(__FUNCTION__, 0x0006);
	output->addByte(__FUNCTION__, 0x1F);

	// Add timestamp & random number
	challengeTimestamp = static_cast<uint32_t>(getTimeNow());
	output->addU32(__FUNCTION__, challengeTimestamp);

	challengeRandom = randNumber(generator);
	output->addByte(__FUNCTION__, challengeRandom);

	// Go back and write checksum
	output->skipBytes(-12);
	// To support 11.10-, not have problems with 11.11+
	output->addU32(__FUNCTION__, adlerChecksum(output->getOutputBuffer() + sizeof(uint32_t), 8));

	send(std::move(output));
}

void ProtocolGame::disconnectClient(const std::string &message) const
{
	auto output = OutputMessagePool::getOutputMessage();
	output->addByte(__FUNCTION__, 0x14);
	output->addString(__FUNCTION__, message);
	send(output);
	disconnect();
}

void ProtocolGame::writeToOutputBuffer(const NetworkMessage &msg)
{
	auto out = getOutputBuffer(msg.getLength());
	out->append(msg);
}

void ProtocolGame::parsePacket(NetworkMessage& msg)
{
	if (!acceptPackets || g_game().getGameState() == GAME_STATE_SHUTDOWN || msg.getLength() <= 0) {
		return;
	}

	uint8_t recvbyte = msg.getByte();

	if (!player || player->isRemoved()) {
		if (recvbyte == 0x0F) {
			disconnect();
		}
		return;
	}

	if (player->isDead() || player->getHealth() <= 0) {
		g_dispatcher().addTask(createTask(std::bind(&ProtocolGame::parsePacketDead, getThis(), recvbyte)));
		return;
	}

	// Modules system
	if (player && recvbyte != 0xD3) {
		g_dispatcher().addTask(createTask(std::bind(&Modules::executeOnRecvbyte, &g_modules(), player->getID(), msg, recvbyte)));
	}

	g_dispatcher().addTask(createTask(std::bind(&ProtocolGame::parsePacketFromDispatcher, getThis(), msg, recvbyte)));
}

void ProtocolGame::parsePacketDead(uint8_t recvbyte)
{
	if (recvbyte == 0x14) {
		disconnect();
		g_dispatcher().addTask(createTask(std::bind(&IOLoginData::updateOnlineStatus, player->getGUID(), false)));
		return;
	}

	if (recvbyte == 0x0F) {
		if (!player) {
			return;
		}

		g_scheduler().addEvent(createSchedulerTask(100, std::bind(&ProtocolGame::sendPing, getThis())));

		if (!player->spawn()) {
			disconnect();
			addGameTask(&Game::removeCreature, player, true);
			return;
		}

		g_dispatcher().addTask(createTask(std::bind(&ProtocolGame::sendAddCreature, getThis(), player, player->getPosition(), 0, false)));
		g_dispatcher().addTask(createTask(std::bind(&ProtocolGame::addBless, getThis())));
		return;
	}

	if (recvbyte == 0x1D) {
		// keep the connection alive
		g_scheduler().addEvent(createSchedulerTask(100, std::bind(&ProtocolGame::sendPingBack, getThis())));
		return;
	}
}

void ProtocolGame::addBless()
{
	std::string bless = player->getBlessingsName();
	std::ostringstream lostBlesses;
	(bless.length() == 0) ? lostBlesses << "You lost all your blessings." : lostBlesses <<  "You are still blessed with " << bless;
	player->sendTextMessage(MESSAGE_EVENT_ADVANCE, lostBlesses.str());
	if (player->getLevel() < g_configManager().getNumber(ADVENTURERSBLESSING_LEVEL)) {
		for (uint8_t i = 2; i <= 6; i++) {
			if (!player->hasBlessing(i)) {
				player->addBlessing(i, 1);
			}
		}
		sendBlessStatus();
	}
}

void ProtocolGame::parsePacketFromDispatcher(NetworkMessage msg, uint8_t recvbyte)
{
	if (!acceptPackets || g_game().getGameState() == GAME_STATE_SHUTDOWN) {
		return;
	}

	if (!player || player->isRemoved() || player->getHealth() <= 0) {
		return;
	}

	switch (recvbyte) {
		case 0x14: g_dispatcher().addTask(createTask(std::bind(&ProtocolGame::logout, getThis(), true, false))); break;
		case 0x1D: addGameTask(&Game::playerReceivePingBack, player->getID()); break;
		case 0x1E: addGameTask(&Game::playerReceivePing, player->getID()); break;
		case 0x2a: addBestiaryTrackerList(msg); break;
		case 0x2B: parsePartyAnalyzerAction(msg); break;
		case 0x2c: parseLeaderFinderWindow(msg); break;
		case 0x2d: parseMemberFinderWindow(msg); break;
		case 0x28: parseStashWithdraw(msg); break;
		case 0x29: parseRetrieveDepotSearch(msg); break;
		case 0x32: parseExtendedOpcode(msg); break; //otclient extended opcode
		case 0x64: parseAutoWalk(msg); break;
		case 0x65: addGameTask(&Game::playerMove, player->getID(), DIRECTION_NORTH); break;
		case 0x66: addGameTask(&Game::playerMove, player->getID(), DIRECTION_EAST); break;
		case 0x67: addGameTask(&Game::playerMove, player->getID(), DIRECTION_SOUTH); break;
		case 0x68: addGameTask(&Game::playerMove, player->getID(), DIRECTION_WEST); break;
		case 0x69: addGameTask(&Game::playerStopAutoWalk, player->getID()); break;
		case 0x6A: addGameTask(&Game::playerMove, player->getID(), DIRECTION_NORTHEAST); break;
		case 0x6B: addGameTask(&Game::playerMove, player->getID(), DIRECTION_SOUTHEAST); break;
		case 0x6C: addGameTask(&Game::playerMove, player->getID(), DIRECTION_SOUTHWEST); break;
		case 0x6D: addGameTask(&Game::playerMove, player->getID(), DIRECTION_NORTHWEST); break;
		case 0x6F: addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerTurn, player->getID(), DIRECTION_NORTH); break;
		case 0x70: addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerTurn, player->getID(), DIRECTION_EAST); break;
		case 0x71: addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerTurn, player->getID(), DIRECTION_SOUTH); break;
		case 0x72: addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerTurn, player->getID(), DIRECTION_WEST); break;
		case 0x73: parseTeleport(msg); break;
		case 0x77: parseHotkeyEquip(msg); break;
		case 0x78: parseThrow(msg); break;
		case 0x79: parseLookInShop(msg); break;
		case 0x7A: parsePlayerBuyOnShop(msg); break;
		case 0x7B: parsePlayerSellOnShop(msg); break;
		case 0x7C: addGameTask(&Game::playerCloseShop, player->getID()); break;
		case 0x7D: parseRequestTrade(msg); break;
		case 0x7E: parseLookInTrade(msg); break;
		case 0x7F: addGameTask(&Game::playerAcceptTrade, player->getID()); break;
		case 0x80: addGameTask(&Game::playerCloseTrade, player->getID()); break;
		case 0x82: parseUseItem(msg); break;
		case 0x83: parseUseItemEx(msg); break;
		case 0x84: parseUseWithCreature(msg); break;
		case 0x85: parseRotateItem(msg); break;
		case 0x86: parseConfigureShowOffSocket(msg); break;
		case 0x87: parseCloseContainer(msg); break;
		case 0x88: parseUpArrowContainer(msg); break;
		case 0x89: parseTextWindow(msg); break;
		case 0x8A: parseHouseWindow(msg); break;
		case 0x8B: parseWrapableItem(msg); break;
		case 0x8C: parseLookAt(msg); break;
		case 0x8D: parseLookInBattleList(msg); break;
		case 0x8E: /* join aggression */ break;
		case 0x8F: parseQuickLoot(msg); break;
		case 0x90: parseLootContainer(msg); break;
		case 0x91: parseQuickLootBlackWhitelist(msg); break;
		case 0x92: parseOpenDepotSearch(); break;
		case 0x93: parseCloseDepotSearch(); break;
		case 0x94: parseDepotSearchItemRequest(msg); break;
		case 0x95: parseOpenParentContainer(msg); break;
		case 0x96: parseSay(msg); break;
		case 0x97: addGameTask(&Game::playerRequestChannels, player->getID()); break;
		case 0x98: parseOpenChannel(msg); break;
		case 0x99: parseCloseChannel(msg); break;
		case 0x9A: parseOpenPrivateChannel(msg); break;
		case 0x9E: addGameTask(&Game::playerCloseNpcChannel, player->getID()); break;
		case 0xA0: parseFightModes(msg); break;
		case 0xA1: parseAttack(msg); break;
		case 0xA2: parseFollow(msg); break;
		case 0xA3: parseInviteToParty(msg); break;
		case 0xA4: parseJoinParty(msg); break;
		case 0xA5: parseRevokePartyInvite(msg); break;
		case 0xA6: parsePassPartyLeadership(msg); break;
		case 0xA7: addGameTask(&Game::playerLeaveParty, player->getID()); break;
		case 0xA8: parseEnableSharedPartyExperience(msg); break;
		case 0xAA: addGameTask(&Game::playerCreatePrivateChannel, player->getID()); break;
		case 0xAB: parseChannelInvite(msg); break;
		case 0xAC: parseChannelExclude(msg); break;
		case 0xB1: parseHighscores(msg); break;
		case 0xBA: parseTaskHuntingAction(msg); break;
		case 0xBE: addGameTask(&Game::playerCancelAttackAndFollow, player->getID()); break;
		case 0xBF: parseForgeEnter(msg); break;
		case 0xC0: parseForgeBrowseHistory(msg); break;
		case 0xC7: parseTournamentLeaderboard(msg); break;
		case 0xC9: /* update tile */ break;
		case 0xCA: parseUpdateContainer(msg); break;
		case 0xCB: parseBrowseField(msg); break;
		case 0xCC: parseSeekInContainer(msg); break;
		case 0xCD: parseInspectionObject(msg); break;
		case 0xD2: addGameTask(&Game::playerRequestOutfit, player->getID()); break;
		//g_dispatcher().addTask(createTask(std::bind(&Modules::executeOnRecvbyte, g_modules, player, msg, recvbyte)));
		case 0xD3: g_dispatcher().addTask(createTask(std::bind(&ProtocolGame::parseSetOutfit, getThis(), msg))); break;
		case 0xD4: parseToggleMount(msg); break;
		case 0xD5: parseApplyImbuement(msg); break;
		case 0xD6: parseClearImbuement(msg); break;
		case 0xD7: parseCloseImbuementWindow(msg); break;
		case 0xDC: parseAddVip(msg); break;
		case 0xDD: parseRemoveVip(msg); break;
		case 0xDE: parseEditVip(msg); break;
		case 0xE1: parseBestiarysendRaces(); break;
		case 0xE2: parseBestiarysendCreatures(msg); break;
		case 0xE3: parseBestiarysendMonsterData(msg); break;
		case 0xE4: parseSendBuyCharmRune(msg); break;
		case 0xE5: parseCyclopediaCharacterInfo(msg); break;
		case 0xE6: parseBugReport(msg); break;
		case 0xE7: /* thank you */ break;
		case 0xE8: parseDebugAssert(msg); break;
		case 0xEB: parsePreyAction(msg); break;
		case 0xED: parseSendResourceBalance(); break;
		case 0xEE: parseGreet(msg); break;
		// Premium coins transfer
		// case 0xEF: parseCoinTransfer(msg); break;
		case 0xF0: addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerShowQuestLog, player->getID()); break;
		case 0xF1: parseQuestLine(msg); break;
		// case 0xF2: parseRuleViolationReport(msg); break;
		case 0xF3: /* get object info */ break;
		case 0xF4: parseMarketLeave(); break;
		case 0xF5: parseMarketBrowse(msg); break;
		case 0xF6: parseMarketCreateOffer(msg); break;
		case 0xF7: parseMarketCancelOffer(msg); break;
		case 0xF8: parseMarketAcceptOffer(msg); break;
		case 0xF9: parseModalWindowAnswer(msg); break;
		// case 0xFA: parseStoreOpen(msg); break;
		// case 0xFB: parseStoreRequestOffers(msg); break;
		// case 0xFC: parseStoreBuyOffer(msg) break;
		// case 0xFD: parseStoreOpenTransactionHistory(msg); break;
		// case 0xFE: parseStoreRequestTransactionHistory(msg); break;

		//case 0xDF, 0xE0, 0xE1, 0xFB, 0xFC, 0xFD, 0xFE Premium Shop.

		default:
			SPDLOG_DEBUG("Player: {} sent an unknown packet header: x0{}",
				player->getName(), static_cast<uint16_t>(recvbyte));
			break;
	}
}

void ProtocolGame::parseHotkeyEquip(NetworkMessage &msg)
{
	if (!player)
	{
		return;
	}
	uint16_t itemId = msg.get<uint16_t>();
	uint8_t tier = msg.get<uint8_t>();
	addGameTask(&Game::playerEquipItem, player->getID(), itemId, Item::items[itemId].upgradeClassification > 0, tier);
}

void ProtocolGame::GetTileDescription(const Tile *tile, NetworkMessage &msg)
{
	int32_t count;
	Item *ground = tile->getGround();
	if (ground)
	{
		AddItem(msg, ground);
		count = 1;
	}
	else
	{
		count = 0;
	}

	const TileItemVector *items = tile->getItemList();
	if (items)
	{
		for (auto it = items->getBeginTopItem(), end = items->getEndTopItem(); it != end; ++it)
		{
			AddItem(msg, *it);

			count++;
			if (count == 9 && tile->getPosition() == player->getPosition())
			{
				break;
			}
			else if (count == 10)
			{
				return;
			}
		}
	}

	const CreatureVector *creatures = tile->getCreatures();
	if (creatures)
	{
		bool playerAdded = false;
		for (const Creature *creature : boost::adaptors::reverse(*creatures))
		{
			if (!player->canSeeCreature(creature))
			{
				continue;
			}

			if (tile->getPosition() == player->getPosition() && count == 9 && !playerAdded)
			{
				creature = player;
			}

			if (creature->getID() == player->getID())
			{
				playerAdded = true;
			}

			bool known;
			uint32_t removedKnown;
			checkCreatureAsKnown(creature->getID(), known, removedKnown);
			AddCreature(msg, creature, known, removedKnown);

			if (++count == 10)
			{
				return;
			}
		}
	}

	if (items)
	{
		for (auto it = items->getBeginDownItem(), end = items->getEndDownItem(); it != end; ++it)
		{
			AddItem(msg, *it);

			if (++count == 10)
			{
				return;
			}
		}
	}
}

void ProtocolGame::GetMapDescription(int32_t x, int32_t y, int32_t z, int32_t width, int32_t height, NetworkMessage &msg)
{
	int32_t skip = -1;
	int32_t startz, endz, zstep;

	if (z > MAP_INIT_SURFACE_LAYER)
	{
		startz = z - MAP_LAYER_VIEW_LIMIT;
		endz = std::min<int32_t>(MAP_MAX_LAYERS - 1, z + MAP_LAYER_VIEW_LIMIT);
		zstep = 1;
	}
	else
	{
		startz = MAP_INIT_SURFACE_LAYER;
		endz = 0;
		zstep = -1;
	}

	for (int32_t nz = startz; nz != endz + zstep; nz += zstep)
	{
		GetFloorDescription(msg, x, y, nz, width, height, z - nz, skip);
	}

	if (skip >= 0)
	{
		msg.addByte(__FUNCTION__, skip);
		msg.addByte(__FUNCTION__, 0xFF);
	}
}

void ProtocolGame::GetFloorDescription(NetworkMessage &msg, int32_t x, int32_t y, int32_t z, int32_t width, int32_t height, int32_t offset, int32_t &skip)
{
	for (int32_t nx = 0; nx < width; nx++)
	{
		for (int32_t ny = 0; ny < height; ny++)
		{
			const Tile *tile = g_game().map.getTile(static_cast<uint16_t>(x + nx + offset), static_cast<uint16_t>(y + ny + offset), static_cast<uint8_t>(z));
			if (tile)
			{
				if (skip >= 0)
				{
					msg.addByte(__FUNCTION__, skip);
					msg.addByte(__FUNCTION__, 0xFF);
				}

				skip = 0;
				GetTileDescription(tile, msg);
			}
			else if (skip == 0xFE)
			{
				msg.addByte(__FUNCTION__, 0xFF);
				msg.addByte(__FUNCTION__, 0xFF);
				skip = -1;
			}
			else
			{
				++skip;
			}
		}
	}
}

void ProtocolGame::checkCreatureAsKnown(uint32_t id, bool &known, uint32_t &removedKnown)
{
	if (auto [creatureKnown, creatureInserted] = knownCreatureSet.insert(id);
	!creatureInserted)
	{
		known = true;
		return;
	}
	known = false;
	if (knownCreatureSet.size() > 1300)
	{
		// Look for a creature to remove
		for (auto it = knownCreatureSet.begin(), end = knownCreatureSet.end(); it != end; ++it) {
			if (*it == id) {
				continue;
			}
			// We need to protect party players from removing
			Creature* creature = g_game().getCreatureByID(*it);
			if (const Player* checkPlayer;
			creature && (checkPlayer = creature->getPlayer()) != nullptr)
			{
				if (player->getParty() != checkPlayer->getParty() && !canSee(creature)) {
					removedKnown = *it;
					knownCreatureSet.erase(it);
					return;
				}
			} else if (!canSee(creature)) {
				removedKnown = *it;
				knownCreatureSet.erase(it);
				return;
			}
		}

		// Bad situation. Let's just remove anyone.
		auto it = knownCreatureSet.begin();
		if (*it == id)
		{
			++it;
		}

		removedKnown = *it;
		knownCreatureSet.erase(it);
	}
	else
	{
		removedKnown = 0;
	}
}

bool ProtocolGame::canSee(const Creature *c) const
{
	if (!c || !player || c->isRemoved())
	{
		return false;
	}

	if (!player->canSeeCreature(c))
	{
		return false;
	}

	return canSee(c->getPosition());
}

bool ProtocolGame::canSee(const Position &pos) const
{
	return canSee(pos.x, pos.y, pos.z);
}

bool ProtocolGame::canSee(int32_t x, int32_t y, int32_t z) const
{
	if (!player)
	{
		return false;
	}

	const Position &myPos = player->getPosition();
	if (myPos.z <= MAP_INIT_SURFACE_LAYER)
	{
		//we are on ground level or above (7 -> 0)
		//view is from 7 -> 0
		if (z > MAP_INIT_SURFACE_LAYER)
		{
			return false;
		}
	}
	else if (myPos.z >= MAP_INIT_SURFACE_LAYER + 1)
	{
		//we are underground (8 -> 15)
		//view is +/- 2 from the floor we stand on
		if (std::abs(myPos.getZ() - z) > MAP_LAYER_VIEW_LIMIT)
		{
			return false;
		}
	}

	//negative offset means that the action taken place is on a lower floor than ourself
	const int8_t offsetz = myPos.getZ() - z;
	return (x >= myPos.getX() - Map::maxClientViewportX + offsetz) && (x <= myPos.getX() + (Map::maxClientViewportX + 1) + offsetz) &&
		(y >= myPos.getY() - Map::maxClientViewportY + offsetz) && (y <= myPos.getY() + (Map::maxClientViewportY + 1) + offsetz);
}

// Parse methods
void ProtocolGame::parseChannelInvite(NetworkMessage &msg)
{
	const std::string name = msg.getString();
	addGameTask(&Game::playerChannelInvite, player->getID(), name);
}

void ProtocolGame::parseChannelExclude(NetworkMessage &msg)
{
	const std::string name = msg.getString();
	addGameTask(&Game::playerChannelExclude, player->getID(), name);
}

void ProtocolGame::parseOpenChannel(NetworkMessage &msg)
{
	uint16_t channelId = msg.get<uint16_t>();
	addGameTask(&Game::playerOpenChannel, player->getID(), channelId);
}

void ProtocolGame::parseCloseChannel(NetworkMessage &msg)
{
	uint16_t channelId = msg.get<uint16_t>();
	addGameTask(&Game::playerCloseChannel, player->getID(), channelId);
}

void ProtocolGame::parseOpenPrivateChannel(NetworkMessage &msg)
{
	const std::string receiver = msg.getString();
	addGameTask(&Game::playerOpenPrivateChannel, player->getID(), receiver);
}

void ProtocolGame::parseAutoWalk(NetworkMessage &msg)
{
	uint8_t numdirs = msg.getByte();
	if (numdirs == 0 || (msg.getBufferPosition() + numdirs) != (msg.getLength() + 8))
	{
		return;
	}

	msg.skipBytes(numdirs);

	std::forward_list<Direction> path;
	for (uint8_t i = 0; i < numdirs; ++i)
	{
		uint8_t rawdir = msg.getPreviousByte();
		switch (rawdir)
		{
		case 1:
			path.push_front(DIRECTION_EAST);
			break;
		case 2:
			path.push_front(DIRECTION_NORTHEAST);
			break;
		case 3:
			path.push_front(DIRECTION_NORTH);
			break;
		case 4:
			path.push_front(DIRECTION_NORTHWEST);
			break;
		case 5:
			path.push_front(DIRECTION_WEST);
			break;
		case 6:
			path.push_front(DIRECTION_SOUTHWEST);
			break;
		case 7:
			path.push_front(DIRECTION_SOUTH);
			break;
		case 8:
			path.push_front(DIRECTION_SOUTHEAST);
			break;
		default:
			break;
		}
	}

	if (path.empty())
	{
		return;
	}

	addGameTask(&Game::playerAutoWalk, player->getID(), path);
}

void ProtocolGame::parseSetOutfit(NetworkMessage &msg)
{
	if (!player || player->isRemoved()) {
		return;
	}

	uint16_t startBufferPosition = msg.getBufferPosition();
	Module *outfitModule = g_modules().getEventByRecvbyte(0xD3, false);
	if (outfitModule)
	{
		outfitModule->executeOnRecvbyte(player, msg);
	}

	if (msg.getBufferPosition() == startBufferPosition)
	{
		uint8_t outfitType = 0;
		outfitType = msg.getByte();
		Outfit_t newOutfit;
		newOutfit.lookType = msg.get<uint16_t>();
		newOutfit.lookHead = std::min<uint8_t>(132, msg.getByte());
		newOutfit.lookBody = std::min<uint8_t>(132, msg.getByte());
		newOutfit.lookLegs = std::min<uint8_t>(132, msg.getByte());
		newOutfit.lookFeet = std::min<uint8_t>(132, msg.getByte());
		newOutfit.lookAddons = msg.getByte();
		if (outfitType == 0)
		{
			newOutfit.lookMount = msg.get<uint16_t>();
			newOutfit.lookMountHead = std::min<uint8_t>(132, msg.getByte());
			newOutfit.lookMountBody = std::min<uint8_t>(132, msg.getByte());
			newOutfit.lookMountLegs = std::min<uint8_t>(132, msg.getByte());
			newOutfit.lookMountFeet = std::min<uint8_t>(132, msg.getByte());
			newOutfit.lookFamiliarsType = msg.get<uint16_t>();
			g_game().playerChangeOutfit(player->getID(), newOutfit);
		}
		else if (outfitType == 1)
		{
			//This value probably has something to do with try outfit variable inside outfit window dialog
			//if try outfit is set to 2 it expects uint32_t value after mounted and disable mounts from outfit window dialog
			newOutfit.lookMount = 0;
			msg.get<uint32_t>();
		} else if (outfitType == 2) {
			Position pos = msg.getPosition();
			uint16_t itemId = msg.get<uint16_t>();
			uint8_t stackpos = msg.getByte();
			newOutfit.lookMount = msg.get<uint16_t>();
			newOutfit.lookMountHead = std::min<uint8_t>(132, msg.getByte());
			newOutfit.lookMountBody = std::min<uint8_t>(132, msg.getByte());
			newOutfit.lookMountLegs = std::min<uint8_t>(132, msg.getByte());
			newOutfit.lookMountFeet = std::min<uint8_t>(132, msg.getByte());
			uint8_t direction = std::max<uint8_t>(DIRECTION_NORTH, std::min<uint8_t>(DIRECTION_WEST, msg.getByte()));
			uint8_t podiumVisible = msg.getByte();
			g_game().playerSetShowOffSocket(player->getID(), newOutfit, pos, stackpos, itemId, podiumVisible, direction);
		}
	}
}

void ProtocolGame::parseToggleMount(NetworkMessage &msg)
{
	bool mount = msg.getByte() != 0;
	addGameTask(&Game::playerToggleMount, player->getID(), mount);
}

void ProtocolGame::parseApplyImbuement(NetworkMessage &msg)
{
	uint8_t slot = msg.getByte();
	uint32_t imbuementId = msg.get<uint32_t>();
	bool protectionCharm = msg.getByte() != 0x00;
	addGameTask(&Game::playerApplyImbuement, player->getID(), imbuementId, slot, protectionCharm);
}

void ProtocolGame::parseClearImbuement(NetworkMessage &msg)
{
	uint8_t slot = msg.getByte();
	addGameTask(&Game::playerClearImbuement, player->getID(), slot);
}

void ProtocolGame::parseCloseImbuementWindow(NetworkMessage &)
{
	addGameTask(&Game::playerCloseImbuementWindow, player->getID());
}

void ProtocolGame::parseUseItem(NetworkMessage &msg)
{
	Position pos = msg.getPosition();
	uint16_t itemId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	uint8_t index = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerUseItem, player->getID(), pos, stackpos, index, itemId);
}

void ProtocolGame::parseUseItemEx(NetworkMessage &msg)
{
	Position fromPos = msg.getPosition();
	uint16_t fromItemId = msg.get<uint16_t>();
	uint8_t fromStackPos = msg.getByte();
	Position toPos = msg.getPosition();
	uint16_t toItemId = msg.get<uint16_t>();
	uint8_t toStackPos = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerUseItemEx, player->getID(), fromPos, fromStackPos, fromItemId, toPos, toStackPos, toItemId);
}

void ProtocolGame::parseUseWithCreature(NetworkMessage &msg)
{
	Position fromPos = msg.getPosition();
	uint16_t itemId = msg.get<uint16_t>();
	uint8_t fromStackPos = msg.getByte();
	uint32_t creatureId = msg.get<uint32_t>();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerUseWithCreature, player->getID(), fromPos, fromStackPos, creatureId, itemId);
}

void ProtocolGame::parseCloseContainer(NetworkMessage &msg)
{
	uint8_t cid = msg.getByte();
	addGameTask(&Game::playerCloseContainer, player->getID(), cid);
}

void ProtocolGame::parseUpArrowContainer(NetworkMessage &msg)
{
	uint8_t cid = msg.getByte();
	addGameTask(&Game::playerMoveUpContainer, player->getID(), cid);
}

void ProtocolGame::parseUpdateContainer(NetworkMessage &msg)
{
	uint8_t cid = msg.getByte();
	addGameTask(&Game::playerUpdateContainer, player->getID(), cid);
}

void ProtocolGame::parseTeleport(NetworkMessage &msg)
{
	Position newPosition = msg.getPosition();
	addGameTask(&Game::playerTeleport, player->getID(), newPosition);
}

void ProtocolGame::parseThrow(NetworkMessage &msg)
{
	Position fromPos = msg.getPosition();
	uint16_t itemId = msg.get<uint16_t>();
	uint8_t fromStackpos = msg.getByte();
	Position toPos = msg.getPosition();
	uint8_t count = msg.getByte();

	if (toPos != fromPos)
	{
		addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerMoveThing, player->getID(), fromPos, itemId, fromStackpos, toPos, count);
	}
}

void ProtocolGame::parseLookAt(NetworkMessage &msg)
{
	Position pos = msg.getPosition();
	uint16_t itemId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerLookAt, player->getID(), itemId, pos, stackpos);
}

void ProtocolGame::parseLookInBattleList(NetworkMessage &msg)
{
	uint32_t creatureId = msg.get<uint32_t>();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerLookInBattleList, player->getID(), creatureId);
}

void ProtocolGame::parseQuickLoot(NetworkMessage &msg)
{
	Position pos = msg.getPosition();
	uint16_t itemId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	bool lootAllCorpses = msg.getByte();
	bool autoLoot = msg.getByte();
	addGameTask(&Game::playerQuickLoot, player->getID(), pos, itemId, stackpos, nullptr, lootAllCorpses, autoLoot);
}

void ProtocolGame::parseLootContainer(NetworkMessage &msg)
{
	uint8_t action = msg.getByte();
	if (action == 0)
	{
		ObjectCategory_t category = (ObjectCategory_t)msg.getByte();
		Position pos = msg.getPosition();
		uint16_t itemId = msg.get<uint16_t>();
		uint8_t stackpos = msg.getByte();
		addGameTask(&Game::playerSetLootContainer, player->getID(), category, pos, itemId, stackpos);
	}
	else if (action == 1)
	{
		ObjectCategory_t category = (ObjectCategory_t)msg.getByte();
		addGameTask(&Game::playerClearLootContainer, player->getID(), category);
	}
	else if (action == 2)
	{
		ObjectCategory_t category = (ObjectCategory_t)msg.getByte();
		addGameTask(&Game::playerOpenLootContainer, player->getID(), category);
	}
	else if (action == 3)
	{
		bool useMainAsFallback = msg.getByte() == 1;
		addGameTask(&Game::playerSetQuickLootFallback, player->getID(), useMainAsFallback);
	}
}

void ProtocolGame::parseQuickLootBlackWhitelist(NetworkMessage &msg)
{
	QuickLootFilter_t filter = (QuickLootFilter_t)msg.getByte();
	std::vector<uint16_t> listedItems;

	uint16_t size = msg.get<uint16_t>();
	listedItems.reserve(size);

	for (int i = 0; i < size; i++)
	{
		listedItems.push_back(msg.get<uint16_t>());
	}

	addGameTask(&Game::playerQuickLootBlackWhitelist, player->getID(), filter, listedItems);
}

void ProtocolGame::parseSay(NetworkMessage &msg)
{
	std::string receiver;
	uint16_t channelId;

	SpeakClasses type = static_cast<SpeakClasses>(msg.getByte());
	switch (type)
	{
	case TALKTYPE_PRIVATE_TO:
	case TALKTYPE_PRIVATE_RED_TO:
		receiver = msg.getString();
		channelId = 0;
		break;

	case TALKTYPE_CHANNEL_Y:
	case TALKTYPE_CHANNEL_R1:
		channelId = msg.get<uint16_t>();
		break;

	default:
		channelId = 0;
		break;
	}

	const std::string text = msg.getString();
	if (text.length() > 255)
	{
		return;
	}

	addGameTask(&Game::playerSay, player->getID(), channelId, type, receiver, text);
}

void ProtocolGame::parseFightModes(NetworkMessage &msg)
{
	uint8_t rawFightMode = msg.getByte();  // 1 - offensive, 2 - balanced, 3 - defensive
	uint8_t rawChaseMode = msg.getByte();  // 0 - stand while fightning, 1 - chase opponent
	uint8_t rawSecureMode = msg.getByte(); // 0 - can't attack unmarked, 1 - can attack unmarked
	// uint8_t rawPvpMode = msg.getByte(); // pvp mode introduced in 10.0

	FightMode_t fightMode;
	if (rawFightMode == 1)
	{
		fightMode = FIGHTMODE_ATTACK;
	}
	else if (rawFightMode == 2)
	{
		fightMode = FIGHTMODE_BALANCED;
	}
	else
	{
		fightMode = FIGHTMODE_DEFENSE;
	}

	addGameTask(&Game::playerSetFightModes, player->getID(), fightMode, rawChaseMode != 0, rawSecureMode != 0);
}

void ProtocolGame::parseAttack(NetworkMessage &msg)
{
	uint32_t creatureId = msg.get<uint32_t>();
	// msg.get<uint32_t>(); creatureId (same as above)
	addGameTask(&Game::playerSetAttackedCreature, player->getID(), creatureId);
}

void ProtocolGame::parseFollow(NetworkMessage &msg)
{
	uint32_t creatureId = msg.get<uint32_t>();
	// msg.get<uint32_t>(); creatureId (same as above)
	addGameTask(&Game::playerFollowCreature, player->getID(), creatureId);
}

void ProtocolGame::parseTextWindow(NetworkMessage &msg)
{
	uint32_t windowTextId = msg.get<uint32_t>();
	const std::string newText = msg.getString();
	addGameTask(&Game::playerWriteItem, player->getID(), windowTextId, newText);
}

void ProtocolGame::parseHouseWindow(NetworkMessage &msg)
{
	uint8_t doorId = msg.getByte();
	uint32_t id = msg.get<uint32_t>();
	const std::string text = msg.getString();
	addGameTask(&Game::playerUpdateHouseWindow, player->getID(), doorId, id, text);
}

void ProtocolGame::parseLookInShop(NetworkMessage &msg)
{
	uint16_t id = msg.get<uint16_t>();
	uint8_t count = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerLookInShop, player->getID(), id, count);
}

void ProtocolGame::parsePlayerBuyOnShop(NetworkMessage &msg)
{
	uint16_t id = msg.get<uint16_t>();
	uint8_t count = msg.getByte();
	uint16_t amount = msg.get<uint16_t>();
	bool ignoreCap = msg.getByte() != 0;
	bool inBackpacks = msg.getByte() != 0;
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerBuyItem, player->getID(), id, count, amount, ignoreCap, inBackpacks);
}

void ProtocolGame::parsePlayerSellOnShop(NetworkMessage &msg)
{
	uint16_t id = msg.get<uint16_t>();
	uint8_t count = std::max(msg.getByte(), (uint8_t) 1);
	uint16_t amount = msg.get<uint16_t>();
	bool ignoreEquipped = msg.getByte() != 0;

	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerSellItem, player->getID(), id, count, amount, ignoreEquipped);
}

void ProtocolGame::parseRequestTrade(NetworkMessage &msg)
{
	Position pos = msg.getPosition();
	uint16_t itemId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	uint32_t playerId = msg.get<uint32_t>();
	addGameTask(&Game::playerRequestTrade, player->getID(), pos, stackpos, playerId, itemId);
}

void ProtocolGame::parseLookInTrade(NetworkMessage &msg)
{
	bool counterOffer = (msg.getByte() == 0x01);
	uint8_t index = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerLookInTrade, player->getID(), counterOffer, index);
}

void ProtocolGame::parseAddVip(NetworkMessage &msg)
{
	const std::string name = msg.getString();
	addGameTask(&Game::playerRequestAddVip, player->getID(), name);
}

void ProtocolGame::parseRemoveVip(NetworkMessage &msg)
{
	uint32_t guid = msg.get<uint32_t>();
	addGameTask(&Game::playerRequestRemoveVip, player->getID(), guid);
}

void ProtocolGame::parseEditVip(NetworkMessage &msg)
{
	uint32_t guid = msg.get<uint32_t>();
	const std::string description = msg.getString();
	uint32_t icon = std::min<uint32_t>(10, msg.get<uint32_t>()); // 10 is max icon in 9.63
	bool notify = msg.getByte() != 0;
	addGameTask(&Game::playerRequestEditVip, player->getID(), guid, description, icon, notify);
}

void ProtocolGame::parseRotateItem(NetworkMessage &msg)
{
	Position pos = msg.getPosition();
	uint16_t itemId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerRotateItem, player->getID(), pos, stackpos, itemId);
}

void ProtocolGame::parseWrapableItem(NetworkMessage &msg)
{
	Position pos = msg.getPosition();
	uint16_t itemId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerWrapableItem, player->getID(), pos, stackpos, itemId);
}

void ProtocolGame::parseInspectionObject(NetworkMessage &msg)
{
	uint8_t inspectionType = msg.getByte();
	if (inspectionType == INSPECT_NORMALOBJECT)
	{
		Position pos = msg.getPosition();
		g_game().playerInspectItem(player, pos);
	}
	else if (inspectionType == INSPECT_NPCTRADE || inspectionType == INSPECT_CYCLOPEDIA)
	{
		uint16_t itemId = msg.get<uint16_t>();
		uint16_t itemCount = msg.getByte();
		g_game().playerInspectItem(player, itemId, static_cast<int8_t>(itemCount), (inspectionType == INSPECT_CYCLOPEDIA));
	}
}

void ProtocolGame::sendSessionEndInformation(SessionEndInformations information)
{
	auto output = OutputMessagePool::getOutputMessage();
	output->addByte(__FUNCTION__, 0x18);
	output->addByte(__FUNCTION__, information);
	send(output);
	disconnect();
}

void ProtocolGame::sendItemInspection(uint16_t itemId, uint8_t itemCount, const Item *item, bool cyclopedia)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x76);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addByte(__FUNCTION__, cyclopedia ? 0x01 : 0x00);
	msg.addByte(__FUNCTION__, 0x01);

	const ItemType &it = Item::items[itemId];

	if (item)
	{
		msg.addString(__FUNCTION__, item->getName());
		AddItem(msg, item);
	}
	else
	{
		msg.addString(__FUNCTION__, it.name);
		AddItem(msg, it.id, itemCount, 0);
	}
	msg.addByte(__FUNCTION__, 0);

	auto descriptions = Item::getDescriptions(it, item);
	msg.addByte(__FUNCTION__, descriptions.size());
	for (const auto &description : descriptions)
	{
		msg.addString(__FUNCTION__, description.first);
		msg.addString(__FUNCTION__, description.second);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::parseCyclopediaCharacterInfo(NetworkMessage &msg)
{
	uint32_t characterID;
	CyclopediaCharacterInfoType_t characterInfoType;
	characterID = msg.get<uint32_t>();
	characterInfoType = static_cast<CyclopediaCharacterInfoType_t>(msg.getByte());
	uint16_t entriesPerPage = 0, page = 0;
	if (characterInfoType == CYCLOPEDIA_CHARACTERINFO_RECENTDEATHS || characterInfoType == CYCLOPEDIA_CHARACTERINFO_RECENTPVPKILLS)
	{
		entriesPerPage = std::min<uint16_t>(30, std::max<uint16_t>(5, msg.get<uint16_t>()));
		page = std::max<uint16_t>(1, msg.get<uint16_t>());
	}
	if (characterID == 0)
	{
		characterID = player->getGUID();
	}
	g_game().playerCyclopediaCharacterInfo(player, characterID, characterInfoType, entriesPerPage, page);
}

void ProtocolGame::parseHighscores(NetworkMessage &msg)
{
	HighscoreType_t type = static_cast<HighscoreType_t>(msg.getByte());
	uint8_t category = msg.getByte();
	uint32_t vocation = msg.get<uint32_t>();
	uint16_t page = 1;
	const std::string worldName = msg.getString();
	msg.getByte(); // Game World Category
	msg.getByte(); // BattlEye World Type
	if (type == HIGHSCORE_GETENTRIES)
	{
		page = std::max<uint16_t>(1, msg.get<uint16_t>());
	}
	uint8_t entriesPerPage = std::min<uint8_t>(30, std::max<uint8_t>(5, msg.getByte()));
	g_game().playerHighscores(player, type, category, vocation, worldName, page, entriesPerPage);
}

void ProtocolGame::parseTaskHuntingAction(NetworkMessage &msg)
{
	uint8_t slot = msg.getByte();
	uint8_t action = msg.getByte();
	bool upgrade = msg.getByte() != 0;
	uint16_t raceId = msg.get<uint16_t>();

	if (!g_configManager().getBoolean(TASK_HUNTING_ENABLED)) {
		return;
	}

	addGameTask(&Game::playerTaskHuntingAction, player->getID(), slot, action, upgrade, raceId);
}

void ProtocolGame::sendHighscoresNoData()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xB1);
	msg.addByte(__FUNCTION__, 0x01); // No data available
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendHighscores(const std::vector<HighscoreCharacter> &characters, uint8_t categoryId, uint32_t vocationId, uint16_t page, uint16_t pages)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xB1);
	msg.addByte(__FUNCTION__, 0x00); // No data available

	msg.addByte(__FUNCTION__, 1); // Worlds
	msg.addString(__FUNCTION__, g_configManager().getString(SERVER_NAME)); // First World
	msg.addString(__FUNCTION__, g_configManager().getString(SERVER_NAME)); // Selected World

	msg.addByte(__FUNCTION__, 0); // Game World Category: 0xFF(-1) - Selected World
	msg.addByte(__FUNCTION__, 0); // BattlEye World Type

	auto vocationPosition = msg.getBufferPosition();
	uint8_t vocations = 1;

	msg.skipBytes(1); // Vocation Count
	msg.addU32(__FUNCTION__, 0xFFFFFFFF); // All Vocations - hardcoded
	msg.addString(__FUNCTION__, "(all)");          // All Vocations - hardcoded

	uint32_t selectedVocation = 0xFFFFFFFF;
	const auto &vocationsMap = g_vocations().getVocations();
	for (const auto &it : vocationsMap)
	{
		const Vocation &vocation = it.second;
		if (vocation.getFromVocation() == static_cast<uint32_t>(vocation.getId()))
		{
			msg.addU32(__FUNCTION__, vocation.getFromVocation()); // Vocation Id
			msg.addString(__FUNCTION__, vocation.getVocName());          // Vocation Name
			++vocations;
			if (vocation.getFromVocation() == vocationId)
			{
				selectedVocation = vocationId;
			}
		}
	}
	msg.addU32(__FUNCTION__, selectedVocation); // Selected Vocation

	HighscoreCategory highscoreCategories[] =
		{
			{"Experience Points", HIGHSCORE_CATEGORY_EXPERIENCE},
			{"Fist Fighting", HIGHSCORE_CATEGORY_FIST_FIGHTING},
			{"Club Fighting", HIGHSCORE_CATEGORY_CLUB_FIGHTING},
			{"Sword Fighting", HIGHSCORE_CATEGORY_SWORD_FIGHTING},
			{"Axe Fighting", HIGHSCORE_CATEGORY_AXE_FIGHTING},
			{"Distance Fighting", HIGHSCORE_CATEGORY_DISTANCE_FIGHTING},
			{"Shielding", HIGHSCORE_CATEGORY_SHIELDING},
			{"Fishing", HIGHSCORE_CATEGORY_FISHING},
			{"Magic Level", HIGHSCORE_CATEGORY_MAGIC_LEVEL}};

	uint8_t selectedCategory = 0;
	msg.addByte(__FUNCTION__, sizeof(highscoreCategories) / sizeof(HighscoreCategory)); // Category Count
	for (HighscoreCategory &category : highscoreCategories)
	{
		msg.addByte(__FUNCTION__, category.id); // Category Id
		msg.addString(__FUNCTION__, category.name); // Category Name
		if (category.id == categoryId)
		{
			selectedCategory = categoryId;
		}
	}
	msg.addByte(__FUNCTION__, selectedCategory); // Selected Category

	msg.addU16(__FUNCTION__, page);  // Current page
	msg.addU16(__FUNCTION__, pages); // Pages

	msg.addByte(__FUNCTION__, characters.size()); // Character Count
	for (const HighscoreCharacter &character : characters)
	{
		msg.addU32(__FUNCTION__, character.rank); // Rank
		msg.addString(__FUNCTION__, character.name); // Character Name
		msg.addString(__FUNCTION__, ""); // Probably Character Title(not visible in window)
		msg.addByte(__FUNCTION__, character.vocation); // Vocation Id
		msg.addString(__FUNCTION__, g_configManager().getString(SERVER_NAME)); // World
		msg.addU16(__FUNCTION__, character.level); // Level
		msg.addByte(__FUNCTION__, (player->getGUID() == character.id)); // Player Indicator Boolean
		msg.addU64(__FUNCTION__, character.points); // Points
	}

	msg.addByte(__FUNCTION__, 0xFF); // ??
	msg.addByte(__FUNCTION__, 0); // ??
	msg.addByte(__FUNCTION__, 1); // ??
	msg.addU32(__FUNCTION__, static_cast<uint32_t>(getTimeNow())); // Last Update

	msg.setBufferPosition(vocationPosition);
	msg.addByte(__FUNCTION__, vocations);
	writeToOutputBuffer(msg);
}

void ProtocolGame::parseTournamentLeaderboard(NetworkMessage &msg)
{
	uint8_t ledaerboardType = msg.getByte();
	if (ledaerboardType == 0)
	{
		const std::string worldName = msg.getString();
		uint16_t currentPage = msg.get<uint16_t>();
		(void)worldName;
		(void)currentPage;
	}
	else if (ledaerboardType == 1)
	{
		const std::string worldName = msg.getString();
		const std::string characterName = msg.getString();
		(void)worldName;
		(void)characterName;
	}
	uint8_t elementsPerPage = msg.getByte();
	(void)elementsPerPage;

	addGameTask(&Game::playerTournamentLeaderboard, player->getID(), ledaerboardType);
}

void ProtocolGame::parseConfigureShowOffSocket(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	uint16_t itemId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	g_game().playerConfigureShowOffSocket(player->getID(), pos, stackpos, itemId);
}

void ProtocolGame::parseRuleViolationReport(NetworkMessage &msg)
{
	uint8_t reportType = msg.getByte();
	uint8_t reportReason = msg.getByte();
	const std::string &targetName = msg.getString();
	const std::string &comment = msg.getString();
	std::string translation;
	if (reportType == REPORT_TYPE_NAME)
	{
		translation = msg.getString();
	}
	else if (reportType == REPORT_TYPE_STATEMENT)
	{
		translation = msg.getString();
		msg.get<uint32_t>(); // statement id, used to get whatever player have said, we don't log that.
	}

	addGameTask(&Game::playerReportRuleViolationReport, player->getID(), targetName, reportType, reportReason, comment, translation);
}

void ProtocolGame::parseBestiarysendRaces()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xd5);
	msg.addU16(__FUNCTION__, BESTY_RACE_LAST);
	std::map<uint16_t, std::string> mtype_list = g_game().getBestiaryList();
	for (uint8_t i = BESTY_RACE_FIRST; i <= BESTY_RACE_LAST; i++)
	{
		std::string BestClass = "";
		uint16_t count = 0;
		for (auto rit : mtype_list)
		{
			const MonsterType *mtype = g_monsters().getMonsterType(rit.second);
			if (!mtype)
			{
				return;
			}
			if (mtype->info.bestiaryRace == static_cast<BestiaryType_t>(i))
			{
				count += 1;
				BestClass = mtype->info.bestiaryClass;
			}
		}
		msg.addString(__FUNCTION__, BestClass);
		msg.addU16(__FUNCTION__, count);
		uint16_t unlockedCount = g_iobestiary().getBestiaryRaceUnlocked(player, static_cast<BestiaryType_t>(i));
		msg.addU16(__FUNCTION__, unlockedCount);
	}
	writeToOutputBuffer(msg);

	player->BestiarysendCharms();
}

void ProtocolGame::sendBestiaryEntryChanged(uint16_t raceid)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xd9);
	msg.addU16(__FUNCTION__, raceid);
	writeToOutputBuffer(msg);
}

void ProtocolGame::parseBestiarysendMonsterData(NetworkMessage &msg)
{
	uint16_t raceId = msg.get<uint16_t>();
	std::string Class = "";
	MonsterType *mtype = nullptr;
	std::map<uint16_t, std::string> mtype_list = g_game().getBestiaryList();

	auto ait = mtype_list.find(raceId);
	if (ait != mtype_list.end())
	{
		MonsterType *mType = g_monsters().getMonsterType(ait->second);
		if (mType)
		{
			Class = mType->info.bestiaryClass;
			mtype = mType;
		}
	}

	if (!mtype)
	{
		SPDLOG_WARN("[ProtocolGame::parseBestiarysendMonsterData] - "
                    "MonsterType was not found");
		return;
	}

	uint32_t killCounter = player->getBestiaryKillCount(raceId);
	uint8_t currentLevel = g_iobestiary().getKillStatus(mtype, killCounter);

	NetworkMessage newmsg;
	newmsg.addByte(__FUNCTION__, 0xd7);
	newmsg.addU16(__FUNCTION__, raceId);
	newmsg.addString(__FUNCTION__, Class);

	newmsg.addByte(__FUNCTION__, currentLevel);
	newmsg.addU32(__FUNCTION__, killCounter);

	newmsg.addU16(__FUNCTION__, mtype->info.bestiaryFirstUnlock);
	newmsg.addU16(__FUNCTION__, mtype->info.bestiarySecondUnlock);
	newmsg.addU16(__FUNCTION__, mtype->info.bestiaryToUnlock);

	newmsg.addByte(__FUNCTION__, mtype->info.bestiaryStars);
	newmsg.addByte(__FUNCTION__, mtype->info.bestiaryOccurrence);

	std::vector<LootBlock> lootList = mtype->info.lootItems;
	newmsg.addByte(__FUNCTION__, lootList.size());
	for (LootBlock loot : lootList)
	{
		int8_t difficult = g_iobestiary().calculateDifficult(loot.chance);
		bool shouldAddItem = false;

		switch (currentLevel)
		{
		case 1:
			shouldAddItem = false;
			break;
		case 2:
			if (difficult < 2)
			{
				shouldAddItem = true;
			}
			break;
		case 3:
			if (difficult < 3)
			{
				shouldAddItem = true;
			}
			break;
		case 4:
			shouldAddItem = true;
			break;
		}

		newmsg.addU16(__FUNCTION__, shouldAddItem == true ? loot.id : 0);
		newmsg.addByte(__FUNCTION__, difficult);
		newmsg.addByte(__FUNCTION__, 0); // 1 if special event - 0 if regular loot (?)
		if (shouldAddItem == true)
		{
			newmsg.addString(__FUNCTION__, loot.name);
			newmsg.addByte(__FUNCTION__, loot.countmax > 0 ? 0x1 : 0x0);
		}
	}

	if (currentLevel > 1)
	{
		newmsg.addU16(__FUNCTION__, mtype->info.bestiaryCharmsPoints);
		int8_t attackmode = 0;
		if (!mtype->info.isHostile)
		{
			attackmode = 2;
		}
		else if (mtype->info.targetDistance)
		{
			attackmode = 1;
		}

		newmsg.addByte(__FUNCTION__, attackmode);
		newmsg.addByte(__FUNCTION__, 0x2);
		newmsg.addU32(__FUNCTION__, mtype->info.healthMax);
		newmsg.addU32(__FUNCTION__, static_cast<uint32_t>(mtype->info.experience));
		newmsg.addU16(__FUNCTION__, mtype->getBaseSpeed());
		newmsg.addU16(__FUNCTION__, static_cast<uint16_t>(mtype->info.armor));
	}

	if (currentLevel > 2)
	{
		std::map<uint8_t, int16_t> elements = g_iobestiary().getMonsterElements(mtype);

		newmsg.addByte(__FUNCTION__, elements.size());
		for (auto it = std::begin(elements), end = std::end(elements); it != end; it++)
		{
			newmsg.addByte(__FUNCTION__, it->first);
			newmsg.addU16(__FUNCTION__, it->second);
		}

		newmsg.addU16(__FUNCTION__, 1);
		newmsg.addString(__FUNCTION__, mtype->info.bestiaryLocations);
	}

	if (currentLevel > 3)
	{
		charmRune_t mType_c = g_iobestiary().getCharmFromTarget(player, mtype);
		if (mType_c != CHARM_NONE)
		{
			newmsg.addByte(__FUNCTION__, 1);
			newmsg.addByte(__FUNCTION__, mType_c);
			newmsg.addU32(__FUNCTION__, player->getLevel() * 100);
		}
		else
		{
			newmsg.addByte(__FUNCTION__, 0);
			newmsg.addByte(__FUNCTION__, 1);
		}
	}

	writeToOutputBuffer(newmsg);
}

void ProtocolGame::addBestiaryTrackerList(NetworkMessage &msg)
{
	uint16_t thisrace = msg.get<uint16_t>();
	std::map<uint16_t, std::string> mtype_list = g_game().getBestiaryList();
	auto it = mtype_list.find(thisrace);
	if (it != mtype_list.end())
	{
		MonsterType *mtype = g_monsters().getMonsterType(it->second);
		if (mtype)
		{
			player->addBestiaryTrackerList(mtype);
		}
	}
}

void ProtocolGame::sendTeamFinderList()
{
	if (!player)
		return;

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x2D);
	msg.addByte(__FUNCTION__, 0x00); // Bool value, with 'true' the player exceed packets for second.
	std::map<uint32_t, TeamFinder*> teamFinder = g_game().getTeamFinderList();
	auto teamFinderSize = InternalProtocol::getIterationIncreaseCount(teamFinder);
	msg.addU16(__FUNCTION__, teamFinderSize);
	for (auto it : teamFinder) {
		const Player* leader = g_game().getPlayerByGUID(it.first);
		if (!leader)
			return;

		TeamFinder* teamAssemble = it.second;
		if (!teamAssemble)
			return;

		uint8_t status = 0;
		uint16_t membersSize = 0;
		msg.addU32(__FUNCTION__, leader->getGUID());
		msg.addString(__FUNCTION__, leader->getName());
		msg.addU16(__FUNCTION__, teamAssemble->minLevel);
		msg.addU16(__FUNCTION__, teamAssemble->maxLevel);
		msg.addByte(__FUNCTION__, teamAssemble->vocationIDs);
		msg.addU16(__FUNCTION__, teamAssemble->teamSlots);
		for (auto itt : teamAssemble->membersMap) {
			const Player* member = g_game().getPlayerByGUID(it.first);
			if (member) {
				if (itt.first == player->getGUID())
					status = itt.second;

				if (itt.second == 3)
					membersSize += 1;
			}
		}
		msg.addU16(__FUNCTION__, std::max<uint16_t>((teamAssemble->teamSlots - teamAssemble->freeSlots), membersSize));
		// The leader does not count on this math, he is included inside the 'freeSlots'.
		msg.addU32(__FUNCTION__, teamAssemble->timestamp);
		msg.addByte(__FUNCTION__, teamAssemble->teamType);

		switch (teamAssemble->teamType) {
			case 1: {
				msg.addU16(__FUNCTION__, teamAssemble->bossID);
				break;
			}
			case 2: {
				msg.addU16(__FUNCTION__, teamAssemble->hunt_type);
				msg.addU16(__FUNCTION__, teamAssemble->hunt_area);
				break;
			}
			case 3: {
				msg.addU16(__FUNCTION__, teamAssemble->questID);
				break;
			}

			default:
				break;
		}

		msg.addByte(__FUNCTION__, status);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendLeaderTeamFinder(bool reset)
{
	if (!player)
		return;

	TeamFinder* teamAssemble = nullptr;
	std::map<uint32_t, TeamFinder*> teamFinder = g_game().getTeamFinderList();
	auto it = teamFinder.find(player->getGUID());
	if (it != teamFinder.end()) {
		teamAssemble = it->second;
	}

	if (!teamAssemble)
		return;

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x2C);
	msg.addByte(__FUNCTION__, reset ? 1 : 0);
	if (reset) {
		g_game().removeTeamFinderListed(player->getGUID());
		return;
	}
	msg.addU16(__FUNCTION__, teamAssemble->minLevel);
	msg.addU16(__FUNCTION__, teamAssemble->maxLevel);
	msg.addByte(__FUNCTION__, teamAssemble->vocationIDs);
	msg.addU16(__FUNCTION__, teamAssemble->teamSlots);
	msg.addU16(__FUNCTION__, teamAssemble->freeSlots);
	msg.addU32(__FUNCTION__, teamAssemble->timestamp);
	msg.addByte(__FUNCTION__, teamAssemble->teamType);

	switch (teamAssemble->teamType) {
		case 1: {
			msg.addU16(__FUNCTION__, teamAssemble->bossID);
			break;
		}
		case 2: {
			msg.addU16(__FUNCTION__, teamAssemble->hunt_type);
			msg.addU16(__FUNCTION__, teamAssemble->hunt_area);
			break;
		}
		case 3: {
			msg.addU16(__FUNCTION__, teamAssemble->questID);
			break;
		}

		default:
			break;
	}

	uint16_t membersSize = 1;
	for (auto memberPair : teamAssemble->membersMap) {
		const Player* member = g_game().getPlayerByGUID(memberPair.first);
		if (member) {
			membersSize += 1;
		}
	}

	msg.addU16(__FUNCTION__, membersSize);
	const Player* leader = g_game().getPlayerByGUID(teamAssemble->leaderGuid);
	if (!leader)
		return;

	msg.addU32(__FUNCTION__, leader->getGUID());
	msg.addString(__FUNCTION__, leader->getName());
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(leader->getLevel()));
	msg.addByte(__FUNCTION__, leader->getVocation()->getClientId());
	msg.addByte(__FUNCTION__, 3);

	for (auto memberPair : teamAssemble->membersMap) {
		const Player* member = g_game().getPlayerByGUID(memberPair.first);
		if (!member) {
			continue;
		}
		msg.addU32(__FUNCTION__, member->getGUID());
		msg.addString(__FUNCTION__, member->getName());
		msg.addU16(__FUNCTION__, static_cast<uint16_t>(member->getLevel()));
		msg.addByte(__FUNCTION__, member->getVocation()->getClientId());
		msg.addByte(__FUNCTION__, memberPair.second);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::createLeaderTeamFinder(NetworkMessage &msg)
{
	if (!player)
		return;

	std::map<uint32_t, uint8_t> members;
	std::map<uint32_t, TeamFinder*> teamFinder = g_game().getTeamFinderList();
	TeamFinder* teamAssemble = nullptr;
	auto it = teamFinder.find(player->getGUID());
	if (it != teamFinder.end()) {
		members = it->second->membersMap;
		teamAssemble = it->second;
	}

	if (!teamAssemble)
		teamAssemble = new TeamFinder();

	teamAssemble->minLevel = msg.get<uint16_t>();
	teamAssemble->maxLevel = msg.get<uint16_t>();
	teamAssemble->vocationIDs = msg.getByte();
	teamAssemble->teamSlots = msg.get<uint16_t>();
	teamAssemble->freeSlots = msg.get<uint16_t>();
	teamAssemble->partyBool = (msg.getByte() == 1);
	teamAssemble->timestamp = msg.get<uint32_t>();
	teamAssemble->teamType = msg.getByte();

	uint16_t bossID = 0;
	uint16_t huntType1 = 0;
	uint16_t huntType2 = 0;
	uint16_t questID = 0;

	switch (teamAssemble->teamType) {
		case 1: {
			bossID = msg.get<uint16_t>();
			break;
		}
		case 2: {
			huntType1 = msg.get<uint16_t>();
			huntType2 = msg.get<uint16_t>();
			break;
		}

		case 3: {
			questID = msg.get<uint16_t>();
			break;
		}

		default:
			break;
	}

	teamAssemble->bossID = bossID;
	teamAssemble->hunt_type = huntType1;
	teamAssemble->hunt_area = huntType2;
	teamAssemble->questID = questID;
	teamAssemble->leaderGuid = player->getGUID();

	if (teamAssemble->partyBool && player->getParty()) {
		for (Player* member : player->getParty()->getMembers()) {
			if (member && member->getGUID() != player->getGUID()) {
				members.insert({member->getGUID(), 3});
			}
		}
		if (player->getParty()->getLeader()->getGUID() != player->getGUID()) {
			members.insert({player->getParty()->getLeader()->getGUID(), 3});
		}
	}
	teamAssemble->membersMap = members;
	g_game().registerTeamFinderAssemble(player->getGUID(), teamAssemble);
}

void ProtocolGame::parsePartyAnalyzerAction(NetworkMessage &msg) const
{
	if (!player) {
		return;
	}

	Party* party = player->getParty();
	if (!party || !party->getLeader() || party->getLeader()->getID() != player->getID()) {
		return;
	}

	PartyAnalyzerAction_t action = static_cast<PartyAnalyzerAction_t>(msg.getByte());
	if (action == PARTYANALYZERACTION_RESET) {
		party->resetAnalyzer();
	} else if (action == PARTYANALYZERACTION_PRICETYPE) {
		party->switchAnalyzerPriceType();
	} else if (action == PARTYANALYZERACTION_PRICEVALUE) {
		uint16_t size = msg.get<uint16_t>();
		for (uint16_t i = 1; i <= size; i++) {
			uint16_t itemId = msg.get<uint16_t>();
			uint64_t price = msg.get<uint64_t>();
			player->setItemCustomPrice(itemId, price);
		}
		party->reloadPrices();
		party->updateTrackerAnalyzer();
	}
}

void ProtocolGame::parseLeaderFinderWindow(NetworkMessage &msg)
{
	if (!player)
		return;

	uint8_t action = msg.getByte();
	switch (action) {
		case 0: {
			player->sendLeaderTeamFinder(false);
			break;
		}
		case 1: {
			player->sendLeaderTeamFinder(true);
			break;
		}
		case 2: {
			uint32_t memberID = msg.get<uint32_t>();
			const Player* member = g_game().getPlayerByGUID(memberID);
			if (!member)
				return;

			std::map<uint32_t, TeamFinder*> teamFinder = g_game().getTeamFinderList();
			TeamFinder* teamAssemble = nullptr;
			auto it = teamFinder.find(player->getGUID());
			if (it != teamFinder.end()) {
				teamAssemble = it->second;
			}

			if (!teamAssemble)
				return;

			uint8_t memberStatus = msg.getByte();
			for (auto& memberPair : teamAssemble->membersMap) {
				if (memberPair.first == memberID) {
					memberPair.second = memberStatus;
				}
			}

			switch (memberStatus) {
				case 2: {
					member->sendTextMessage(MESSAGE_STATUS, "You are invited to a new team.");
					break;
				}
				case 3: {
					member->sendTextMessage(MESSAGE_STATUS, "Your team finder request was accepted.");
					break;
				}
				case 4: {
					member->sendTextMessage(MESSAGE_STATUS, "Your team finder request was denied.");
					break;
				}

				default:
					break;
			}
			player->sendLeaderTeamFinder(false);
			break;
		}
		case 3: {
			player->createLeaderTeamFinder(msg);
			player->sendLeaderTeamFinder(false);
			break;
		}

		default:
			break;
	}
}

void ProtocolGame::parseMemberFinderWindow(NetworkMessage &msg)
{
	if (!player)
		return;

	uint8_t action = msg.getByte();
	if (action == 0) {
			player->sendTeamFinderList();
	} else {
		uint32_t leaderID = msg.get<uint32_t>();
		const Player* leader = g_game().getPlayerByGUID(leaderID);
		if (!leader)
			return;

		std::map<uint32_t, TeamFinder*> teamFinder = g_game().getTeamFinderList();
		TeamFinder* teamAssemble = nullptr;
		auto it = teamFinder.find(leaderID);
		if (it != teamFinder.end()) {
			teamAssemble = it->second;
		}

		if (!teamAssemble)
			return;

		if (action == 1) {
			leader->sendTextMessage(MESSAGE_STATUS, "There is a new request to join your team.");
			teamAssemble->membersMap.insert({player->getGUID(), 1});
		} else {
			for (auto itt = teamAssemble->membersMap.begin(), end = teamAssemble->membersMap.end(); itt != end; ++itt) {
				if (itt->first == player->getGUID()) {
					teamAssemble->membersMap.erase(itt);
					break;
				}
			}
		}
		player->sendTeamFinderList();
	}
}

void ProtocolGame::parseSendBuyCharmRune(NetworkMessage &msg)
{
	charmRune_t runeID = static_cast<charmRune_t>(msg.getByte());
	uint8_t action = msg.getByte();
	uint16_t raceid = msg.get<uint16_t>();
	g_iobestiary().sendBuyCharmRune(player, runeID, action, raceid);
}

void ProtocolGame::refreshBestiaryTracker(std::list<MonsterType *> trackerList)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xB9);
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(trackerList.size()));
	for (MonsterType *mtype : trackerList)
	{
		uint32_t killAmount = player->getBestiaryKillCount(mtype->info.raceid);
		msg.addU16(__FUNCTION__, mtype->info.raceid);
		msg.addU32(__FUNCTION__, killAmount);
		msg.addU16(__FUNCTION__, mtype->info.bestiaryFirstUnlock);
		msg.addU16(__FUNCTION__, mtype->info.bestiarySecondUnlock);
		msg.addU16(__FUNCTION__, mtype->info.bestiaryToUnlock);

		if (g_iobestiary().getKillStatus(mtype, killAmount) == 4)
		{
			msg.addByte(__FUNCTION__, 4);
		}
		else
		{
			msg.addByte(__FUNCTION__, 0);
		}
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::BestiarysendCharms()
{
	int32_t removeRuneCost = player->getLevel() * 100;
	if (player->hasCharmExpansion())
	{
		removeRuneCost = (removeRuneCost * 75) / 100;
	}
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xd8);
	msg.addU32(__FUNCTION__, player->getCharmPoints());

	std::vector<Charm *> charmList = g_game().getCharmList();
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(charmList.size()));
	for (Charm *c_type : charmList)
	{
		msg.addByte(__FUNCTION__, c_type->id);
		msg.addString(__FUNCTION__, c_type->name);
		msg.addString(__FUNCTION__, c_type->description);
		msg.addByte(__FUNCTION__, 0); // Unknown
		msg.addU16(__FUNCTION__, c_type->points);
		if (g_iobestiary().hasCharmUnlockedRuneBit(c_type, player->getUnlockedRunesBit()))
		{
			msg.addByte(__FUNCTION__, 1);
			uint16_t raceid = player->parseRacebyCharm(c_type->id, false, 0);
			if (raceid > 0)
			{
				msg.addByte(__FUNCTION__, 1);
				msg.addU16(__FUNCTION__, raceid);
				msg.addU32(__FUNCTION__, removeRuneCost);
			}
			else
			{
				msg.addByte(__FUNCTION__, 0);
			}
		}
		else
		{
			msg.addByte(__FUNCTION__, 0);
			msg.addByte(__FUNCTION__, 0);
		}
	}
	msg.addByte(__FUNCTION__, 4); // Unknown

	std::list<uint16_t> finishedMonsters = g_iobestiary().getBestiaryFinished(player);
	std::list<charmRune_t> usedRunes = g_iobestiary().getCharmUsedRuneBitAll(player);

	for (charmRune_t charmRune : usedRunes)
	{
		Charm *tmpCharm = g_iobestiary().getBestiaryCharm(charmRune);
		uint16_t tmp_raceid = player->parseRacebyCharm(tmpCharm->id, false, 0);
		finishedMonsters.remove(tmp_raceid);
	}

	msg.addU16(__FUNCTION__, static_cast<uint16_t>(finishedMonsters.size()));
	for (uint16_t raceid_tmp : finishedMonsters)
	{
		msg.addU16(__FUNCTION__, raceid_tmp);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::parseBestiarysendCreatures(NetworkMessage &msg)
{
	std::ostringstream ss;
	std::map<uint16_t, std::string> race = {};
	std::string text = "";
	uint8_t search = msg.getByte();

	if (search == 1) {
		uint16_t monsterAmount = msg.get<uint16_t>();
		std::map<uint16_t, std::string> mtype_list = g_game().getBestiaryList();
		for (uint16_t monsterCount = 1; monsterCount <= monsterAmount; monsterCount++) {
			uint16_t raceid = msg.get<uint16_t>();
			if (player->getBestiaryKillCount(raceid) > 0) {
				auto it = mtype_list.find(raceid);
				if (it != mtype_list.end()) {
						race.insert({raceid, it->second});
				}
			}
		}
	} else {
		std::string raceName = msg.getString();
		race = g_iobestiary().findRaceByName(raceName);

		if (race.size() == 0)
		{
			SPDLOG_WARN("[ProtocolGame::parseBestiarysendCreature] - "
                        "Race was not found: {}, search: {}", raceName, search);
			return;
		}
		text = raceName;
	}
	NetworkMessage newmsg;
	newmsg.addByte(__FUNCTION__, 0xd6);
	newmsg.addString(__FUNCTION__, text);
	newmsg.addU16(__FUNCTION__, static_cast<uint16_t>(race.size()));
	std::map<uint16_t, uint32_t> creaturesKilled = g_iobestiary().getBestiaryKillCountByMonsterIDs(player, race);

	for (auto it_ : race)
	{
		uint16_t raceid_ = it_.first;
		newmsg.addU16(__FUNCTION__, raceid_);

		uint8_t progress = 0;
		for (const auto &_it : creaturesKilled)
		{
			if (_it.first == raceid_)
			{
				MonsterType *tmpType = g_monsters().getMonsterType(it_.second);
				if (!tmpType)
				{
					return;
				}
				progress = g_iobestiary().getKillStatus(tmpType, _it.second);
			}
		}

		if (progress > 0)
		{
			newmsg.addU16(__FUNCTION__, static_cast<uint16_t>(progress));
		}
		else
		{
			newmsg.addByte(__FUNCTION__, 0);
		}
	}
	writeToOutputBuffer(newmsg);
}

void ProtocolGame::parseBugReport(NetworkMessage &msg)
{
	uint8_t category = msg.getByte();
	std::string message = msg.getString();

	Position position;
	if (category == BUG_CATEGORY_MAP)
	{
		position = msg.getPosition();
	}

	addGameTask(&Game::playerReportBug, player->getID(), message, position, category);
}

void ProtocolGame::parseGreet(NetworkMessage &msg)
{
	uint32_t npcId = msg.get<uint32_t>();
	addGameTask(&Game::playerNpcGreet, player->getID(), npcId);
}

void ProtocolGame::parseDebugAssert(NetworkMessage &msg)
{
	if (debugAssertSent)
	{
		return;
	}

	debugAssertSent = true;

	std::string assertLine = msg.getString();
	std::string date = msg.getString();
	std::string description = msg.getString();
	std::string comment = msg.getString();
	addGameTask(&Game::playerDebugAssert, player->getID(), assertLine, date, description, comment);
}

void ProtocolGame::parsePreyAction(NetworkMessage &msg)
{
	int8_t index = -1;
	uint8_t slot = msg.getByte();
	uint8_t action = msg.getByte();
	uint8_t option = 0;
	uint16_t raceId = 0;
	if (action == static_cast<uint8_t>(PreyAction_MonsterSelection)) {
		index = msg.getByte();
	} else if (action == static_cast<uint8_t>(PreyAction_Option)) {
		option = msg.getByte();
	} else if (action == static_cast<uint8_t>(PreyAction_ListAll_Selection)) {
		raceId = msg.get<uint16_t>();
	}

	if (!g_configManager().getBoolean(PREY_ENABLED)) {
		return;
	}

	addGameTask(&Game::playerPreyAction, player->getID(), slot, action, option, index, raceId);
}

void ProtocolGame::parseSendResourceBalance()
{
	auto [sliverCount, coreCount] = player->getForgeSliversAndCores();

	sendResourcesBalance(
		player->getMoney(),
		player->getBankBalance(),
		player->getPreyCards(),
		player->getTaskHuntingPoints(),
		player->getForgeDusts(),
		sliverCount,
		coreCount
	);
}

void ProtocolGame::parseInviteToParty(NetworkMessage &msg)
{
	uint32_t targetId = msg.get<uint32_t>();
	addGameTask(&Game::playerInviteToParty, player->getID(), targetId);
}

void ProtocolGame::parseJoinParty(NetworkMessage &msg)
{
	uint32_t targetId = msg.get<uint32_t>();
	addGameTask(&Game::playerJoinParty, player->getID(), targetId);
}

void ProtocolGame::parseRevokePartyInvite(NetworkMessage &msg)
{
	uint32_t targetId = msg.get<uint32_t>();
	addGameTask(&Game::playerRevokePartyInvitation, player->getID(), targetId);
}

void ProtocolGame::parsePassPartyLeadership(NetworkMessage &msg)
{
	uint32_t targetId = msg.get<uint32_t>();
	addGameTask(&Game::playerPassPartyLeadership, player->getID(), targetId);
}

void ProtocolGame::parseEnableSharedPartyExperience(NetworkMessage &msg)
{
	bool sharedExpActive = msg.getByte() == 1;
	addGameTask(&Game::playerEnableSharedPartyExperience, player->getID(), sharedExpActive);
}

void ProtocolGame::parseQuestLine(NetworkMessage &msg)
{
	uint16_t questId = msg.get<uint16_t>();
	addGameTask(&Game::playerShowQuestLine, player->getID(), questId);
}

void ProtocolGame::parseMarketLeave()
{
	addGameTask(&Game::playerLeaveMarket, player->getID());
}

void ProtocolGame::parseMarketBrowse(NetworkMessage &msg)
{
	uint8_t browseId = msg.get<uint8_t>();

	if (browseId == MARKETREQUEST_OWN_OFFERS)
	{
		addGameTask(&Game::playerBrowseMarketOwnOffers, player->getID());
	}
	else if (browseId == MARKETREQUEST_OWN_HISTORY)
	{
		addGameTask(&Game::playerBrowseMarketOwnHistory, player->getID());
	}
	else
	{
		uint16_t itemId = msg.get<uint16_t>();
		uint8_t tier = msg.get<uint8_t>();
		player->sendMarketEnter(player->getLastDepotId());
		addGameTask(&Game::playerBrowseMarket, player->getID(), itemId, tier);
	}
}


void ProtocolGame::parseMarketCreateOffer(NetworkMessage &msg)
{
	uint8_t type = msg.getByte();
	uint16_t itemId = msg.get<uint16_t>();
	uint8_t itemTier = 0;
	if (Item::items[itemId].upgradeClassification > 0) {
		itemTier = msg.getByte();
	}
	uint16_t amount = msg.get<uint16_t>();
	uint64_t price = msg.get<uint64_t>();
	bool anonymous = (msg.getByte() != 0);
	if (amount > 0 && price > 0)
	{
		addGameTask(&Game::playerCreateMarketOffer, player->getID(), type, itemId, amount, price, itemTier, anonymous);
	}
}

void ProtocolGame::parseMarketCancelOffer(NetworkMessage &msg)
{
	uint32_t timestamp = msg.get<uint32_t>();
	uint16_t counter = msg.get<uint16_t>();
	if (counter > 0)
	{
		addGameTask(&Game::playerCancelMarketOffer, player->getID(), timestamp, counter);
	}

	updateCoinBalance();
}

void ProtocolGame::parseMarketAcceptOffer(NetworkMessage &msg)
{
	uint32_t timestamp = msg.get<uint32_t>();
	uint16_t counter = msg.get<uint16_t>();
	uint16_t amount = msg.get<uint16_t>();
	if (amount > 0 && counter > 0)
	{
		addGameTask(&Game::playerAcceptMarketOffer, player->getID(), timestamp, counter, amount);
	}

	updateCoinBalance();
}

void ProtocolGame::parseModalWindowAnswer(NetworkMessage &msg)
{
	uint32_t id = msg.get<uint32_t>();
	uint8_t button = msg.getByte();
	uint8_t choice = msg.getByte();
	addGameTask(&Game::playerAnswerModalWindow, player->getID(), id, button, choice);
}

void ProtocolGame::parseBrowseField(NetworkMessage &msg)
{
	const Position &pos = msg.getPosition();
	addGameTask(&Game::playerBrowseField, player->getID(), pos);
}

void ProtocolGame::parseSeekInContainer(NetworkMessage &msg)
{
	uint8_t containerId = msg.getByte();
	uint16_t index = msg.get<uint16_t>();
	addGameTask(&Game::playerSeekInContainer, player->getID(), containerId, index);
}

// Send methods
void ProtocolGame::sendOpenPrivateChannel(const std::string &receiver)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xAD);
	msg.addString(__FUNCTION__, receiver);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendExperienceTracker(int64_t rawExp, int64_t finalExp)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xAF);
	msg.add64(__FUNCTION__, rawExp);
	msg.add64(__FUNCTION__, finalExp);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannelEvent(uint16_t channelId, const std::string &playerName, ChannelEvent_t channelEvent)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xF3);
	msg.addU16(__FUNCTION__, channelId);
	msg.addString(__FUNCTION__, playerName);
	msg.addByte(__FUNCTION__, channelEvent);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureOutfit(const Creature *creature, const Outfit_t &outfit)
{
	if (!canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x8E);
	msg.addU32(__FUNCTION__, creature->getID());
	AddOutfit(msg, outfit);
	if (outfit.lookMount != 0)
	{
		msg.addByte(__FUNCTION__, outfit.lookMountHead);
		msg.addByte(__FUNCTION__, outfit.lookMountBody);
		msg.addByte(__FUNCTION__, outfit.lookMountLegs);
		msg.addByte(__FUNCTION__, outfit.lookMountFeet);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureLight(const Creature *creature)
{
	if (!canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	AddCreatureLight(msg, creature);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureIcon(const Creature* creature)
{
	if (!creature)
	{
		return;
	}

	CreatureIcon_t icon = creature->getIcon();
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x8B);
	msg.addU32(__FUNCTION__, creature->getID());
	// Type 14 for this
	msg.addByte(__FUNCTION__, 14);
	// 0 = no icon, 1 = we'll send an icon
	msg.addByte(__FUNCTION__, icon != CREATUREICON_NONE);
	if (icon != CREATUREICON_NONE) {
		msg.addByte(__FUNCTION__, icon);
		// Creature update
		msg.addByte(__FUNCTION__, 1);
		// Used for the life in the new quest
		msg.addU16(__FUNCTION__, 0);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendWorldLight(const LightInfo &lightInfo)
{
	NetworkMessage msg;
	AddWorldLight(msg, lightInfo);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTibiaTime(int32_t time)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xEF);
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(time / 60));
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(time % 60));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureWalkthrough(const Creature *creature, bool walkthrough)
{
	if (!canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x92);
	msg.addU32(__FUNCTION__, creature->getID());
	msg.addByte(__FUNCTION__, walkthrough ? 0x00 : 0x01);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureShield(const Creature *creature)
{
	if (!canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x91);
	msg.addU32(__FUNCTION__, creature->getID());
	msg.addByte(__FUNCTION__, player->getPartyShield(creature->getPlayer()));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureEmblem(const Creature *creature)
{
	if (!canSee(creature))
	{
		return;
	}

	// Remove creature from client and re-add to update
	Position pos = creature->getPosition();
	int32_t stackpos = creature->getTile()->getClientIndexOfCreature(player, creature);
	sendRemoveTileThing(pos, stackpos);
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x6A);
	msg.addPosition(__FUNCTION__, pos);
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(stackpos));
	AddCreature(msg, creature, false, creature->getID());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureSkull(const Creature *creature)
{
	if (g_game().getWorldType() != WORLD_TYPE_PVP)
	{
		return;
	}

	if (!canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x90);
	msg.addU32(__FUNCTION__, creature->getID());
	msg.addByte(__FUNCTION__, player->getSkullClient(creature));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureType(const Creature *creature, uint8_t creatureType)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x95);
	msg.addU32(__FUNCTION__, creature->getID());
	if (creatureType == CREATURETYPE_SUMMON_OTHERS) {
		creatureType = CREATURETYPE_SUMMON_PLAYER;
	}
	msg.addByte(__FUNCTION__, creatureType); // type or any byte idk
	if (creatureType == CREATURETYPE_SUMMON_PLAYER) {
		const Creature* master = creature->getMaster();
		if (master) {
			msg.addU32(__FUNCTION__, master->getID());
		} else {
			msg.addU32(__FUNCTION__, 0);
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureSquare(const Creature *creature, SquareColor_t color)
{
	if (!canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x93);
	msg.addU32(__FUNCTION__, creature->getID());
	msg.addByte(__FUNCTION__, 0x01);
	msg.addByte(__FUNCTION__, color);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTutorial(uint8_t tutorialId)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xDC);
	msg.addByte(__FUNCTION__, tutorialId);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddMarker(const Position &pos, uint8_t markType, const std::string &desc)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xDD);
	msg.addByte(__FUNCTION__, 0x00); // unknow

	msg.addPosition(__FUNCTION__, pos);
	msg.addByte(__FUNCTION__, markType);
	msg.addString(__FUNCTION__, desc);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterNoData(CyclopediaCharacterInfoType_t characterInfoType, uint8_t errorCode)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xDA);
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(characterInfoType));
	msg.addByte(__FUNCTION__, errorCode);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterBaseInformation()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xDA);
	msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_BASEINFORMATION);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addString(__FUNCTION__, player->getName());
	msg.addString(__FUNCTION__, player->getVocation()->getVocName());
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(player->getLevel()));
	AddOutfit(msg, player->getDefaultOutfit(), false);

	msg.addByte(__FUNCTION__, 0x00); // hide stamina
	msg.addByte(__FUNCTION__, 0x00); // enable store summary & character titles
	msg.addString(__FUNCTION__, ""); // character title
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterGeneralStats()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xDA);
	msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_GENERALSTATS);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addU64(__FUNCTION__, player->getExperience());
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(player->getLevel()));
	msg.addByte(__FUNCTION__, player->getLevelPercent());
	// BaseXPGainRate
	msg.addU16(__FUNCTION__, 100);
	// TournamentXPFactor
	msg.add32(__FUNCTION__,0);
	// LowLevelBonus
	msg.addU16(__FUNCTION__, 0);
	// XPBoost
	msg.addU16(__FUNCTION__, 0);
	// StaminaMultiplier(100=x1.0)
	msg.addU16(__FUNCTION__, 100);
	// xpBoostRemainingTime
	msg.addU16(__FUNCTION__, 0);
	// canBuyXpBoost
	msg.addByte(__FUNCTION__, 0x00);
	msg.addU16(__FUNCTION__, std::min<uint16_t>(static_cast<uint16_t>(player->getHealth()), std::numeric_limits<uint16_t>::max()));
	msg.addU16(__FUNCTION__, std::min<uint16_t>(static_cast<uint16_t>(player->getMaxHealth()), std::numeric_limits<uint16_t>::max()));
	msg.addU16(__FUNCTION__, std::min<uint16_t>(static_cast<uint16_t>(player->getMana()), std::numeric_limits<uint16_t>::max()));
	msg.addU16(__FUNCTION__, std::min<uint16_t>(static_cast<uint16_t>(player->getMaxMana()), std::numeric_limits<uint16_t>::max()));
	msg.addByte(__FUNCTION__, player->getSoul());
	msg.addU16(__FUNCTION__, player->getStaminaMinutes());

	Condition *condition = player->getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT);
	msg.addU16(__FUNCTION__, condition ? static_cast<uint16_t>(condition->getTicks() / 1000) : 0x00);
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(player->getOfflineTrainingTime() / 60 / 1000));
	msg.addU16(__FUNCTION__, player->getSpeed());
	msg.addU16(__FUNCTION__, player->getBaseSpeed());
	msg.addU32(__FUNCTION__, player->getCapacity());
	msg.addU32(__FUNCTION__, player->getCapacity());
	msg.addU32(__FUNCTION__, player->hasFlag(PlayerFlag_HasInfiniteCapacity) ? 1000000 : player->getFreeCapacity());
	msg.addByte(__FUNCTION__, 8);
	msg.addByte(__FUNCTION__, 1);
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(player->getMagicLevel()));
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(player->getBaseMagicLevel()));
	// loyalty bonus
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(player->getBaseMagicLevel()));
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(player->getMagicLevelPercent() * 100));

	for (uint8_t i = SKILL_FIRST; i < SKILL_CRITICAL_HIT_CHANCE; ++i)
	{
		static const uint8_t HardcodedSkillIds[] = {11, 9, 8, 10, 7, 6, 13};
		msg.addByte(__FUNCTION__, HardcodedSkillIds[i]);
		msg.addU16(__FUNCTION__, std::min<uint16_t>(player->getSkillLevel(i), std::numeric_limits<uint16_t>::max()));
		msg.addU16(__FUNCTION__, player->getBaseSkill(i));
		// loyalty bonus
		msg.addU16(__FUNCTION__, player->getBaseSkill(i));
		msg.addU16(__FUNCTION__, static_cast<uint16_t>(player->getSkillPercent(i) * 100));
	}

	// Version 12.70
	msg.addByte(__FUNCTION__, 0x00);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterCombatStats()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xDA);
	msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_COMBATSTATS);
	msg.addByte(__FUNCTION__, 0x00);
	for (uint8_t i = SKILL_CRITICAL_HIT_CHANCE; i <= SKILL_LAST; ++i)
	{
		msg.addU16(__FUNCTION__, std::min<uint16_t>(player->getSkillLevel(i), std::numeric_limits<uint16_t>::max()));
		msg.addU16(__FUNCTION__, 0);
	}

	// Version 12.81 new skill (Fatal, Dodge and Momentum)
	sendForgeSkillStats(msg);

	// Cleave (12.70)
	msg.addU16(__FUNCTION__, 0);
	// Magic shield capacity (12.70)
	msg.addU16(__FUNCTION__, 0); // Direct bonus
	msg.addU16(__FUNCTION__, 0); // Percentage bonus

	// Perfect shot range (12.70)
	for (uint16_t i = 1; i <= 5; i++)
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	// Damage reflection
	msg.addU16(__FUNCTION__, 0);

	uint8_t haveBlesses = 0;
	uint8_t blessings = 8;
	for (uint8_t i = 1; i < blessings; ++i)
	{
		if (player->hasBlessing(i))
		{
			++haveBlesses;
		}
	}

	msg.addByte(__FUNCTION__, haveBlesses);
	msg.addByte(__FUNCTION__, blessings);

	const Item *weapon = player->getWeapon();
	if (weapon)
	{
		const ItemType &it = Item::items[weapon->getID()];
		if (it.weaponType == WEAPON_WAND)
		{
			msg.addU16(__FUNCTION__, static_cast<uint16_t>(it.maxHitChance));
			msg.addByte(__FUNCTION__, getCipbiaElement(it.combatType));
			msg.addByte(__FUNCTION__, 0);
			msg.addByte(__FUNCTION__, CIPBIA_ELEMENTAL_UNDEFINED);
		}
		else if (it.weaponType == WEAPON_DISTANCE || it.weaponType == WEAPON_AMMO)
		{
			int32_t attackValue = weapon->getAttack();
			if (it.weaponType == WEAPON_AMMO)
			{
				const Item *weaponItem = player->getWeapon(true);
				if (weaponItem)
				{
					attackValue += weaponItem->getAttack();
				}
			}

			int32_t attackSkill = player->getSkillLevel(SKILL_DISTANCE);
			float attackFactor = player->getAttackFactor();
			int32_t maxDamage = static_cast<int32_t>(Weapons::getMaxWeaponDamage(player->getLevel(), attackSkill, attackValue, attackFactor, true) * player->getVocation()->distDamageMultiplier);
			if (it.abilities && it.abilities->elementType != COMBAT_NONE)
			{
				maxDamage += static_cast<int32_t>(Weapons::getMaxWeaponDamage(player->getLevel(), attackSkill, attackValue - weapon->getAttack() + it.abilities->elementDamage, attackFactor, true) * player->getVocation()->distDamageMultiplier);
			}
			msg.addU16(__FUNCTION__, static_cast<uint16_t>(maxDamage >> 1));
			msg.addByte(__FUNCTION__, CIPBIA_ELEMENTAL_PHYSICAL);
			if (it.abilities && it.abilities->elementType != COMBAT_NONE)
			{
				msg.addByte(__FUNCTION__, static_cast<uint8_t>(it.abilities->elementDamage) * 100 / attackValue);
				msg.addByte(__FUNCTION__, getCipbiaElement(it.abilities->elementType));
			}
			else
			{
				msg.addByte(__FUNCTION__, 0);
				msg.addByte(__FUNCTION__, CIPBIA_ELEMENTAL_UNDEFINED);
			}
		}
		else
		{
			int32_t attackValue = std::max<int32_t>(0, weapon->getAttack());
			int32_t attackSkill = player->getWeaponSkill(weapon);
			float attackFactor = player->getAttackFactor();
			int32_t maxDamage = static_cast<int32_t>(Weapons::getMaxWeaponDamage(player->getLevel(), attackSkill, attackValue, attackFactor, true) * player->getVocation()->meleeDamageMultiplier);
			if (it.abilities && it.abilities->elementType != COMBAT_NONE)
			{
				maxDamage += static_cast<int32_t>(Weapons::getMaxWeaponDamage(player->getLevel(), attackSkill, it.abilities->elementDamage, attackFactor, true) * player->getVocation()->meleeDamageMultiplier);
			}
			msg.addU16(__FUNCTION__, static_cast<uint16_t>(maxDamage >> 1));
			msg.addByte(__FUNCTION__, CIPBIA_ELEMENTAL_PHYSICAL);
			if (it.abilities && it.abilities->elementType != COMBAT_NONE)
			{
				msg.addByte(__FUNCTION__, static_cast<uint8_t>(it.abilities->elementDamage) * 100 / attackValue);
				msg.addByte(__FUNCTION__, getCipbiaElement(it.abilities->elementType));
			}
			else
			{
				msg.addByte(__FUNCTION__, 0);
				msg.addByte(__FUNCTION__, CIPBIA_ELEMENTAL_UNDEFINED);
			}
		}
	}
	else
	{
		float attackFactor = player->getAttackFactor();
		int32_t attackSkill = player->getSkillLevel(SKILL_FIST);
		int32_t attackValue = 7;

		int32_t maxDamage = Weapons::getMaxWeaponDamage(player->getLevel(), attackSkill, attackValue, attackFactor, true);
		msg.addU16(__FUNCTION__, static_cast<uint16_t>(maxDamage >> 1));
		msg.addByte(__FUNCTION__, CIPBIA_ELEMENTAL_PHYSICAL);
		msg.addByte(__FUNCTION__, 0);
		msg.addByte(__FUNCTION__, CIPBIA_ELEMENTAL_UNDEFINED);
	}

	msg.addU16(__FUNCTION__, static_cast<uint16_t>(player->getArmor()));
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(player->getDefense()));

	uint8_t combats = 0;
	auto startCombats = msg.getBufferPosition();
	msg.skipBytes(1);

	alignas(16) int16_t absorbs[COMBAT_COUNT] = {};
	for (int32_t slot = CONST_SLOT_FIRST; slot <= CONST_SLOT_LAST; ++slot)
	{
		if (!player->isItemAbilityEnabled(static_cast<Slots_t>(slot)))
		{
			continue;
		}

		Item *item = player->getInventoryItem(static_cast<Slots_t>(slot));
		if (!item)
		{
			continue;
		}

		const ItemType &it = Item::items[item->getID()];
		if (!it.abilities)
		{
			continue;
		}

		if (COMBAT_COUNT == 12)
		{
			absorbs[0] += it.abilities->absorbPercent[0];
			absorbs[1] += it.abilities->absorbPercent[1];
			absorbs[2] += it.abilities->absorbPercent[2];
			absorbs[3] += it.abilities->absorbPercent[3];
			absorbs[4] += it.abilities->absorbPercent[4];
			absorbs[5] += it.abilities->absorbPercent[5];
			absorbs[6] += it.abilities->absorbPercent[6];
			absorbs[7] += it.abilities->absorbPercent[7];
			absorbs[8] += it.abilities->absorbPercent[8];
			absorbs[9] += it.abilities->absorbPercent[9];
			absorbs[10] += it.abilities->absorbPercent[10];
			absorbs[11] += it.abilities->absorbPercent[11];
		}
		else
		{
			for (size_t i = 0; i < COMBAT_COUNT; ++i)
			{
				absorbs[i] += it.abilities->absorbPercent[i];
			}
		}
	}

	static const Cipbia_Elementals_t cipbiaCombats[] = {CIPBIA_ELEMENTAL_PHYSICAL, CIPBIA_ELEMENTAL_ENERGY, CIPBIA_ELEMENTAL_EARTH, CIPBIA_ELEMENTAL_FIRE, CIPBIA_ELEMENTAL_UNDEFINED,
														CIPBIA_ELEMENTAL_LIFEDRAIN, CIPBIA_ELEMENTAL_UNDEFINED, CIPBIA_ELEMENTAL_HEALING, CIPBIA_ELEMENTAL_DROWN, CIPBIA_ELEMENTAL_ICE, CIPBIA_ELEMENTAL_HOLY, CIPBIA_ELEMENTAL_DEATH};
	for (size_t i = 0; i < COMBAT_COUNT; ++i)
	{
		if (absorbs[i] != 0)
		{
			msg.addByte(__FUNCTION__, cipbiaCombats[i]);
			msg.addByte(__FUNCTION__, static_cast<uint8_t>(std::max<int16_t>(-100, std::min<int16_t>(100, absorbs[i]))));
			++combats;
		}
	}

	// Concoctions potions (12.70)
	msg.addByte(__FUNCTION__, 0x00);

	msg.setBufferPosition(startCombats);
	msg.addByte(__FUNCTION__, combats);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterRecentDeaths(uint16_t page, uint16_t pages, const std::vector<RecentDeathEntry> &entries)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xDA);
	msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_RECENTDEATHS);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addU16(__FUNCTION__, page);
	msg.addU16(__FUNCTION__, pages);
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(entries.size()));
	for (const RecentDeathEntry &entry : entries)
	{
		msg.addU32(__FUNCTION__, entry.timestamp);
		msg.addString(__FUNCTION__, entry.cause);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterRecentPvPKills(uint16_t page, uint16_t pages, const std::vector<RecentPvPKillEntry> &entries)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xDA);
	msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_RECENTPVPKILLS);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addU16(__FUNCTION__, page);
	msg.addU16(__FUNCTION__, pages);
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(entries.size()));
	for (const RecentPvPKillEntry &entry : entries)
	{
		msg.addU32(__FUNCTION__, entry.timestamp);
		msg.addString(__FUNCTION__, entry.description);
		msg.addByte(__FUNCTION__, entry.status);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterAchievements()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xDA);
	msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_ACHIEVEMENTS);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addU16(__FUNCTION__, 0);
	msg.addU16(__FUNCTION__, 0);
	msg.addU16(__FUNCTION__, 0);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterItemSummary()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xDA);
	msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_ITEMSUMMARY);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addU16(__FUNCTION__, 0);
	msg.addU16(__FUNCTION__, 0);
	msg.addU16(__FUNCTION__, 0);
	msg.addU16(__FUNCTION__, 0);
	msg.addU16(__FUNCTION__, 0);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterOutfitsMounts()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xDA);
	msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_OUTFITSMOUNTS);
	msg.addByte(__FUNCTION__, 0x00);
	Outfit_t currentOutfit = player->getDefaultOutfit();

	uint16_t outfitSize = 0;
	auto startOutfits = msg.getBufferPosition();
	msg.skipBytes(2);

	const auto &outfits = Outfits::getInstance().getOutfits(player->getSex());
	for (const Outfit &outfit : outfits)
	{
		uint8_t addons;
		if (!player->getOutfitAddons(outfit, addons))
		{
			continue;
		}
		const std::string from = outfit.from;
		++outfitSize;

		msg.addU16(__FUNCTION__, outfit.lookType);
		msg.addString(__FUNCTION__, outfit.name);
		msg.addByte(__FUNCTION__, addons);
		if (from == "store")
			msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_STORE);
		else if (from == "quest")
			msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_QUEST);
		else
			msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_NONE);
		if (outfit.lookType == currentOutfit.lookType)
		{
			msg.addU32(__FUNCTION__, 1000);
		}
		else
		{
			msg.addU32(__FUNCTION__, 0);
		}
	}
	if (outfitSize > 0)
	{
		msg.addByte(__FUNCTION__, currentOutfit.lookHead);
		msg.addByte(__FUNCTION__, currentOutfit.lookBody);
		msg.addByte(__FUNCTION__, currentOutfit.lookLegs);
		msg.addByte(__FUNCTION__, currentOutfit.lookFeet);
	}

	uint16_t mountSize = 0;
	auto startMounts = msg.getBufferPosition();
	msg.skipBytes(2);
	for (const Mount &mount : g_game().mounts.getMounts())
	{
		const std::string type = mount.type;
		if (player->hasMount(&mount))
		{
			++mountSize;

			msg.addU16(__FUNCTION__, mount.clientId);
			msg.addString(__FUNCTION__, mount.name);
			if (type == "store")
				msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_STORE);
			else if (type == "quest")
				msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_QUEST);
			else
				msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_NONE);
			msg.addU32(__FUNCTION__, 1000);
		}
	}
	if (mountSize > 0)
	{
		msg.addByte(__FUNCTION__, currentOutfit.lookMountHead);
		msg.addByte(__FUNCTION__, currentOutfit.lookMountBody);
		msg.addByte(__FUNCTION__, currentOutfit.lookMountLegs);
		msg.addByte(__FUNCTION__, currentOutfit.lookMountFeet);
	}

	uint16_t familiarsSize = 0;
	auto startFamiliars = msg.getBufferPosition();
	msg.skipBytes(2);
	const auto &familiars = Familiars::getInstance().getFamiliars(player->getVocationId());
	for (const Familiar &familiar : familiars)
	{
		const std::string type = familiar.type;
		if (!player->getFamiliar(familiar))
		{
			continue;
		}
		++familiarsSize;
		msg.addU16(__FUNCTION__, familiar.lookType);
		msg.addString(__FUNCTION__, familiar.name);
		if (type == "quest")
			msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_QUEST);
		else
			msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_NONE);
		msg.addU32(__FUNCTION__, 0);
	}

	msg.setBufferPosition(startOutfits);
	msg.addU16(__FUNCTION__, outfitSize);
	msg.setBufferPosition(startMounts);
	msg.addU16(__FUNCTION__, mountSize);
	msg.setBufferPosition(startFamiliars);
	msg.addU16(__FUNCTION__, familiarsSize);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterStoreSummary()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xDA);
	msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_STORESUMMARY);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addU32(__FUNCTION__, 0);
	msg.addU32(__FUNCTION__, 0);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addU16(__FUNCTION__, 0);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterInspection()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xDA);
	msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_INSPECTION);
	msg.addByte(__FUNCTION__, 0x00);
	uint8_t inventoryItems = 0;
	auto startInventory = msg.getBufferPosition();
	msg.skipBytes(1);
	for (std::underlying_type<Slots_t>::type slot = CONST_SLOT_FIRST; slot <= CONST_SLOT_LAST; slot++)
	{
		Item *inventoryItem = player->getInventoryItem(static_cast<Slots_t>(slot));
		if (inventoryItem)
		{
			++inventoryItems;

			msg.addByte(__FUNCTION__, slot);
			msg.addString(__FUNCTION__, inventoryItem->getName());
			AddItem(msg, inventoryItem);
			msg.addByte(__FUNCTION__, 0);

			auto descriptions = Item::getDescriptions(Item::items[inventoryItem->getID()], inventoryItem);
			msg.addByte(__FUNCTION__, static_cast<uint8_t>(descriptions.size()));
			for (const auto &description : descriptions)
			{
				msg.addString(__FUNCTION__, description.first);
				msg.addString(__FUNCTION__, description.second);
			}
		}
	}
	msg.addString(__FUNCTION__, player->getName());
	AddOutfit(msg, player->getDefaultOutfit(), false);

	msg.addByte(__FUNCTION__, 3);
	msg.addString(__FUNCTION__, "Level");
	msg.addString(__FUNCTION__, std::to_string(player->getLevel()));
	msg.addString(__FUNCTION__, "Vocation");
	msg.addString(__FUNCTION__, player->getVocation()->getVocName());
	msg.addString(__FUNCTION__, "Outfit");

	const Outfit *outfit = Outfits::getInstance().getOutfitByLookType(
                           player->getSex(),
                           player->getDefaultOutfit().lookType);
	if (outfit)
	{
		msg.addString(__FUNCTION__, outfit->name);
	}
	else
	{
		msg.addString(__FUNCTION__, "unknown");
	}
	msg.setBufferPosition(startInventory);
	msg.addByte(__FUNCTION__, inventoryItems);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterBadges()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xDA);
	msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_BADGES);
	msg.addByte(__FUNCTION__, 0x00);
	// enable badges
	msg.addByte(__FUNCTION__, 0x00);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterTitles()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xDA);
	msg.addByte(__FUNCTION__, CYCLOPEDIA_CHARACTERINFO_TITLES);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addByte(__FUNCTION__, 0x00);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTournamentLeaderboard()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xC5);
	msg.addByte(__FUNCTION__, 0);
	msg.addByte(__FUNCTION__, 0x01);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendReLoginWindow(uint8_t unfairFightReduction)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x28);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addByte(__FUNCTION__, unfairFightReduction);
	msg.addByte(__FUNCTION__, 0x00); // use death redemption (boolean)
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendStats()
{
	NetworkMessage msg;
	AddPlayerStats(msg);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendBasicData()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x9F);
	if (player->isPremium())
	{
		msg.addByte(__FUNCTION__, 1);
		msg.addU32(__FUNCTION__, static_cast<uint32_t>(getTimeNow() + (player->premiumDays * 86400)));
	}
	else
	{
		msg.addByte(__FUNCTION__, 0);
		msg.addU32(__FUNCTION__, 0);
	}
	msg.addByte(__FUNCTION__, player->getVocation()->getClientId());

	// Prey window
	if (player->getVocation()->getId() == 0)
	{
		msg.addByte(__FUNCTION__, 0);
	}
	else
	{
		msg.addByte(__FUNCTION__, 1); // has reached Main (allow player to open Prey window)
	}

	std::list<uint16_t> spellsList = g_spells().getSpellsByVocation(player->getVocationId());
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(spellsList.size()));
	for (uint16_t sid : spellsList)
	{
		msg.addByte(__FUNCTION__, static_cast<uint8_t>(sid));
	}
	msg.addByte(__FUNCTION__, player->getVocation()->getMagicShield()); // bool - determine whether magic shield is active or not
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendBlessStatus()
{
	if (!player)
		return;

	NetworkMessage msg;
	//uint8_t maxClientBlessings = (player->operatingSystem == CLIENTOS_NEW_WINDOWS) ? 8 : 6; (compartability for the client 10)
	//Ignore ToF (bless 1)
	uint8_t blessCount = 0;
	uint16_t flag = 0;
	uint16_t pow2 = 2;
	for (int i = 1; i <= 8; i++)
	{
		if (player->hasBlessing(i))
		{
			if (i > 1)
				blessCount++;
			flag |= pow2;
		}
		pow2 = pow2 * 2;
	}

	msg.addByte(__FUNCTION__, 0x9C);

	bool glow = g_configManager().getBoolean(INVENTORY_GLOW) || player->getLevel() < g_configManager().getNumber(ADVENTURERSBLESSING_LEVEL);
	msg.addU16(__FUNCTION__, glow ? 1 : 0); //Show up the glowing effect in items if have all blesses or adventurer's blessing
	auto blessSend = blessCount >= 5 ? 2 : 1;
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(blessCount >= 7 ? 3 : blessSend)); // 1 = Disabled | 2 = normal | 3 = green

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPremiumTrigger()
{
	if (!g_configManager().getBoolean(FREE_PREMIUM))
	{
		NetworkMessage msg;
		msg.addByte(__FUNCTION__, 0x9E);
		msg.addByte(__FUNCTION__, 16);
		for (uint16_t i = 0; i <= 15; i++)
		{
			//PREMIUM_TRIGGER_TRAIN_OFFLINE = false, PREMIUM_TRIGGER_XP_BOOST = false, PREMIUM_TRIGGER_MARKET = false, PREMIUM_TRIGGER_VIP_LIST = false, PREMIUM_TRIGGER_DEPOT_SPACE = false, PREMIUM_TRIGGER_INVITE_PRIVCHAT = false
			msg.addByte(__FUNCTION__, 0x01);
		}
		writeToOutputBuffer(msg);
	}
}

void ProtocolGame::sendTextMessage(const TextMessage &message)
{
	if (message.type == MESSAGE_NONE) {
		SPDLOG_ERROR("[ProtocolGame::sendTextMessage] - Message type is wrong, missing or invalid for player with name {}, on position {}", player->getName(), player->getPosition().toString());
		player->sendTextMessage(MESSAGE_ADMINISTRADOR, "There was a problem requesting your message, please contact the administrator");
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xB4);
	msg.addByte(__FUNCTION__, message.type);
	switch (message.type)
	{
	case MESSAGE_DAMAGE_DEALT:
	case MESSAGE_DAMAGE_RECEIVED:
	case MESSAGE_DAMAGE_OTHERS:
	{
		msg.addPosition(__FUNCTION__, message.position);
		msg.addU32(__FUNCTION__, message.primary.value);
		msg.addByte(__FUNCTION__, message.primary.color);
		msg.addU32(__FUNCTION__, message.secondary.value);
		msg.addByte(__FUNCTION__, message.secondary.color);
		break;
	}
	case MESSAGE_HEALED:
	case MESSAGE_HEALED_OTHERS:
	case MESSAGE_EXPERIENCE:
	case MESSAGE_EXPERIENCE_OTHERS:
	{
		msg.addPosition(__FUNCTION__, message.position);
		msg.addU32(__FUNCTION__, message.primary.value);
		msg.addByte(__FUNCTION__, message.primary.color);
		break;
	}
	case MESSAGE_GUILD:
	case MESSAGE_PARTY_MANAGEMENT:
	case MESSAGE_PARTY:
		msg.addU16(__FUNCTION__, message.channelId);
		break;
	default:
	{
		break;
	}
	}
	msg.addString(__FUNCTION__, message.text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendClosePrivate(uint16_t channelId)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xB3);
	msg.addU16(__FUNCTION__, channelId);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatePrivateChannel(uint16_t channelId, const std::string &channelName)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xB2);
	msg.addU16(__FUNCTION__, channelId);
	msg.addString(__FUNCTION__, channelName);
	msg.addU16(__FUNCTION__, 0x01);
	msg.addString(__FUNCTION__, player->getName());
	msg.addU16(__FUNCTION__, 0x00);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannelsDialog()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xAB);

	const ChannelList &list = g_chat().getChannelList(*player);
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(list.size()));
	for (ChatChannel *channel : list)
	{
		msg.addU16(__FUNCTION__, channel->getId());
		msg.addString(__FUNCTION__, channel->getName());
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannel(uint16_t channelId, const std::string &channelName, const UsersMap *channelUsers, const InvitedMap *invitedUsers)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xAC);

	msg.addU16(__FUNCTION__, channelId);
	msg.addString(__FUNCTION__, channelName);

	if (channelUsers)
	{
		msg.addU16(__FUNCTION__, static_cast<uint16_t>(channelUsers->size()));
		for (const auto &it : *channelUsers)
		{
			msg.addString(__FUNCTION__, it.second->getName());
		}
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	if (invitedUsers)
	{
		msg.addU16(__FUNCTION__, static_cast<uint16_t>(invitedUsers->size()));
		for (const auto &it : *invitedUsers)
		{
			msg.addString(__FUNCTION__, it.second->getName());
		}
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannelMessage(const std::string &author, const std::string &text, SpeakClasses type, uint16_t channel)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xAA);
	msg.addU32(__FUNCTION__, 0x00);
	msg.addString(__FUNCTION__, author);
	msg.addU16(__FUNCTION__, 0x00);
	msg.addByte(__FUNCTION__, type);
	msg.addU16(__FUNCTION__, channel);
	msg.addString(__FUNCTION__, text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendIcons(uint32_t icons)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xA2);
	msg.addU32(__FUNCTION__, icons);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUnjustifiedPoints(const uint8_t &dayProgress, const uint8_t &dayLeft, const uint8_t &weekProgress, const uint8_t &weekLeft, const uint8_t &monthProgress, const uint8_t &monthLeft, const uint8_t &skullDuration)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xB7);
	msg.addByte(__FUNCTION__, dayProgress);
	msg.addByte(__FUNCTION__, dayLeft);
	msg.addByte(__FUNCTION__, weekProgress);
	msg.addByte(__FUNCTION__, weekLeft);
	msg.addByte(__FUNCTION__, monthProgress);
	msg.addByte(__FUNCTION__, monthLeft);
	msg.addByte(__FUNCTION__, skullDuration);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendContainer(uint8_t cid, const Container *container, bool hasParent, uint16_t firstIndex)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x6E);

	msg.addByte(__FUNCTION__, cid);

	if (container->getID() == ITEM_BROWSEFIELD)
	{
		AddItem(msg, ITEM_BAG, 1, container->getTier());
		msg.addString(__FUNCTION__, "Browse Field");
	}
	else
	{
		AddItem(msg, container);
		msg.addString(__FUNCTION__, container->getName());
	}

	msg.addByte(__FUNCTION__, static_cast<uint8_t>(container->capacity()));

	msg.addByte(__FUNCTION__, hasParent ? 0x01 : 0x00);

	// Depot search
	msg.addByte(__FUNCTION__, (player->isDepotSearchAvailable() && container->isInsideDepot(true)) ? 0x01 : 0x00);

	msg.addByte(__FUNCTION__, container->isUnlocked() ? 0x01 : 0x00); // Drag and drop
	msg.addByte(__FUNCTION__, container->hasPagination() ? 0x01 : 0x00); // Pagination

	uint32_t containerSize = container->size();
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(containerSize));
	msg.addU16(__FUNCTION__, firstIndex);

	uint32_t maxItemsToSend;

	if (container->hasPagination() && firstIndex > 0)
	{
		maxItemsToSend = std::min<uint32_t>(container->capacity(), containerSize - firstIndex);
	}
	else
	{
		maxItemsToSend = container->capacity();
	}

	if (firstIndex >= containerSize)
	{
		msg.addByte(__FUNCTION__, 0x00);
	}
	else
	{
		msg.addByte(__FUNCTION__, static_cast<uint8_t>(std::min<uint32_t>(maxItemsToSend, containerSize)));

		uint32_t i = 0;
		const ItemDeque &itemList = container->getItemList();
		for (ItemDeque::const_iterator it = itemList.begin() + firstIndex, end = itemList.end(); i < maxItemsToSend && it != end; ++it, ++i)
		{
			AddItem(msg, *it);
		}
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendLootContainers()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xC0);
	msg.addByte(__FUNCTION__, player->quickLootFallbackToMainContainer ? 1 : 0);
	std::map<ObjectCategory_t, Container *> quickLoot;
	for (auto it : player->quickLootContainers)
	{
		if (it.second && !it.second->isRemoved())
		{
			quickLoot[it.first] = it.second;
		}
	}
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(quickLoot.size()));
	for (auto it : quickLoot)
	{
		msg.addByte(__FUNCTION__, it.first);
		msg.addU16(__FUNCTION__, it.second->getID());
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendLootStats(Item *item, uint8_t count)
{
	if (!item) {
		return;
	}

	Item* lootedItem = nullptr;
	lootedItem = item->clone();
	lootedItem->setItemCount(count);

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xCF);
	AddItem(msg, lootedItem);
	msg.addString(__FUNCTION__, lootedItem->getName());
	item->setIsLootTrackeable(false);
	writeToOutputBuffer(msg);

	lootedItem = nullptr;
}

void ProtocolGame::sendShop(Npc *npc)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x7A);
	msg.addString(__FUNCTION__, npc->getName());
	msg.addU16(__FUNCTION__, npc->getCurrency());

	msg.addString(__FUNCTION__, std::string()); // Currency name

	std::vector<ShopBlock> shoplist = npc->getShopItemVector();
	uint16_t itemsToSend = std::min<size_t>(shoplist.size(), std::numeric_limits<uint16_t>::max());
	msg.addU16(__FUNCTION__, itemsToSend);

	uint16_t i = 0;
	for (ShopBlock shopBlock : shoplist)
	{
		if (++i > itemsToSend) {
			break;
		}

		AddShopItem(msg, shopBlock);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCloseShop()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x7C);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendClientCheck()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x63);
	msg.addU32(__FUNCTION__, 1);
	msg.addByte(__FUNCTION__, 1);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendGameNews()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x98);
	msg.addU32(__FUNCTION__, 1); // unknown
	msg.addByte(__FUNCTION__, 1);         //(0 = open | 1 = highlight)
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendResourcesBalance(uint64_t money /*= 0*/, uint64_t bank /*= 0*/, uint64_t preyCards /*= 0*/, uint64_t taskHunting /*= 0*/,
										uint64_t forgeDust /*= 0*/, uint64_t forgeSliver /*= 0*/, uint64_t forgeCores /*= 0*/)
{
	sendResourceBalance(RESOURCE_BANK, bank);
	sendResourceBalance(RESOURCE_INVENTORY, money);
	sendResourceBalance(RESOURCE_PREY_CARDS, preyCards);
	sendResourceBalance(RESOURCE_TASK_HUNTING, taskHunting);
	sendResourceBalance(RESOURCE_FORGE_DUST, forgeDust);
	sendResourceBalance(RESOURCE_FORGE_SLIVER, forgeSliver);
	sendResourceBalance(RESOURCE_FORGE_CORES, forgeCores);
}

void ProtocolGame::sendResourceBalance(Resource_t resourceType, uint64_t value)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xEE);
	msg.addByte(__FUNCTION__, resourceType);
	msg.addU64(__FUNCTION__, value);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSaleItemList(const std::vector<ShopBlock> &shopVector, const std::map<uint16_t, uint16_t> &inventoryMap)
{
	//Since we already have full inventory map we shouldn't call getMoney here - it is simply wasting cpu power
	uint64_t playerMoney = 0;
	auto it = inventoryMap.find(ITEM_CRYSTAL_COIN);
	if (it != inventoryMap.end())
	{
		playerMoney += static_cast<uint64_t>(it->second) * 10000;
	}
	it = inventoryMap.find(ITEM_PLATINUM_COIN);
	if (it != inventoryMap.end())
	{
		playerMoney += static_cast<uint64_t>(it->second) * 100;
	}
	it = inventoryMap.find(ITEM_GOLD_COIN);
	if (it != inventoryMap.end())
	{
		playerMoney += static_cast<uint64_t>(it->second);
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xEE);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addU64(__FUNCTION__, player->getBankBalance());
	uint16_t currency = player->getShopOwner() ? player->getShopOwner()->getCurrency() : ITEM_GOLD_COIN;
	msg.addByte(__FUNCTION__, 0xEE);
	if (currency == ITEM_GOLD_COIN) {
		msg.addByte(__FUNCTION__, 0x01);
 		msg.addU64(__FUNCTION__, playerMoney);
	} else {
		msg.addByte(__FUNCTION__, 0x02);
		uint64_t newCurrency = 0;
		auto search = inventoryMap.find(currency);
		if (search != inventoryMap.end()) {
			newCurrency += static_cast<uint64_t>(search->second);
		}
		msg.addU64(__FUNCTION__, newCurrency);
	}

	msg.addByte(__FUNCTION__, 0x7B);

	uint8_t itemsToSend = 0;
	auto msgPosition = msg.getBufferPosition();
	msg.skipBytes(1);

	for (ShopBlock shopBlock : shopVector)
	{
		if (shopBlock.itemSellPrice == 0)
		{
			continue;
		}

		it = inventoryMap.find(shopBlock.itemId);
		if (it != inventoryMap.end())
		{
			itemsToSend++;
			msg.addU16(__FUNCTION__, shopBlock.itemId);
			msg.addU16(__FUNCTION__, it->second);
		}
	}

	msg.setBufferPosition(msgPosition);
	msg.addByte(__FUNCTION__, itemsToSend);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketEnter(uint32_t depotId)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xF6);
	msg.addByte(__FUNCTION__, std::min<uint8_t>(static_cast<uint8_t>(IOMarket::getPlayerOfferCount(player->getGUID())), std::numeric_limits<uint8_t>::max()));

	DepotLocker *depotLocker = player->getDepotLocker(depotId);
	if (!depotLocker)
	{
		msg.addU16(__FUNCTION__, 0x00);
		writeToOutputBuffer(msg);
		return;
	}

	player->setInMarket(true);

	// Only use here locker items, itemVector is for use of Game::createMarketOffer
	auto [itemVector, lockerItems] = player->requestLockerItems(depotLocker, true);
	auto totalItemsCountPosition = msg.getBufferPosition();
	msg.skipBytes(2); // Total items count

	uint16_t totalItemsCount = 0;
	for (const auto &[itemId, tierAndCountMap] : lockerItems)
	{
		for (const auto &[tier, count] : tierAndCountMap) {
			msg.addU16(__FUNCTION__, itemId);
			if (Item::items[itemId].upgradeClassification > 0) {
				msg.addByte(__FUNCTION__, tier);
			}
			msg.addU16(__FUNCTION__, static_cast<uint16_t>(count));
			totalItemsCount++;
		}
	}

	msg.setBufferPosition(totalItemsCountPosition);
	msg.addU16(__FUNCTION__, totalItemsCount);
	writeToOutputBuffer(msg);

	updateCoinBalance();
	sendResourcesBalance(player->getMoney(), player->getBankBalance(), player->getPreyCards(), player->getTaskHuntingPoints());
}

void ProtocolGame::sendCoinBalance()
{
	if (!player)
	{
		return;
	}

	// send is updating
	// TODO: export this to it own function
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xF2);
	msg.addByte(__FUNCTION__, 0x01);
	writeToOutputBuffer(msg);

	msg.reset();

	// send update
	msg.addByte(__FUNCTION__, 0xDF);
	msg.addByte(__FUNCTION__, 0x01);

	msg.addU32(__FUNCTION__, player->coinBalance); // Normal Coins
	msg.addU32(__FUNCTION__, player->coinBalance); // Transferable Coins
	msg.addU32(__FUNCTION__, player->coinBalance); // Reserved Auction Coins
	msg.addU32(__FUNCTION__, 0);					// Tournament Coins

	writeToOutputBuffer(msg);
}

void ProtocolGame::updateCoinBalance()
{
	if (!player) {
		return;
	}

	g_dispatcher().addTask(
		createTask(std::bind([](uint32_t playerId) {
			Player* threadPlayer = g_game().getPlayerByID(playerId);
			if (threadPlayer) {
				account::Account account;
				account.LoadAccountDB(threadPlayer->getAccount());
				uint32_t coins;
				account.GetCoins(&coins);
				threadPlayer->coinBalance = coins;
				threadPlayer->sendCoinBalance();
			}
		},
                              player->getID())));
}

void ProtocolGame::sendMarketLeave()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xF7);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketBrowseItem(uint16_t itemId, const MarketOfferList &buyOffers, const MarketOfferList &sellOffers, uint8_t tier)
{
	NetworkMessage msg;

	msg.addByte(__FUNCTION__, 0xF9);
	msg.addByte(__FUNCTION__, MARKETREQUEST_ITEM_BROWSE);
	msg.addU16(__FUNCTION__, itemId);
	if (Item::items[itemId].upgradeClassification > 0) {
		msg.addByte(__FUNCTION__, tier);
	}

	msg.addU32(__FUNCTION__, static_cast<uint32_t>(buyOffers.size()));
	for (const MarketOffer &offer : buyOffers)
	{
		msg.addU32(__FUNCTION__, offer.timestamp);
		msg.addU16(__FUNCTION__, offer.counter);
		msg.addU16(__FUNCTION__, offer.amount);
		msg.addU64(__FUNCTION__, offer.price);
		msg.addString(__FUNCTION__, offer.playerName);
	}

	msg.addU32(__FUNCTION__, static_cast<uint32_t>(sellOffers.size()));
	for (const MarketOffer &offer : sellOffers)
	{
		msg.addU32(__FUNCTION__, offer.timestamp);
		msg.addU16(__FUNCTION__, offer.counter);
		msg.addU16(__FUNCTION__, offer.amount);
		msg.addU64(__FUNCTION__, offer.price);
		msg.addString(__FUNCTION__, offer.playerName);
	}

	updateCoinBalance();
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketAcceptOffer(const MarketOfferEx &offer)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xF9);
	msg.addByte(__FUNCTION__, MARKETREQUEST_ITEM_BROWSE);
	msg.addU16(__FUNCTION__, offer.itemId);
	if (Item::items[offer.itemId].upgradeClassification > 0) {
		msg.addByte(__FUNCTION__, offer.tier);
	}

	if (offer.type == MARKETACTION_BUY)
	{
		msg.addU32(__FUNCTION__, 0x01);
		msg.addU32(__FUNCTION__, offer.timestamp);
		msg.addU16(__FUNCTION__, offer.counter);
		msg.addU16(__FUNCTION__, offer.amount);
		msg.addU64(__FUNCTION__, offer.price);
		msg.addString(__FUNCTION__, offer.playerName);
		msg.addU32(__FUNCTION__, 0x00);
	}
	else
	{
		msg.addU32(__FUNCTION__, 0x00);
		msg.addU32(__FUNCTION__, 0x01);
		msg.addU32(__FUNCTION__, offer.timestamp);
		msg.addU16(__FUNCTION__, offer.counter);
		msg.addU16(__FUNCTION__, offer.amount);
		msg.addU64(__FUNCTION__, offer.price);
		msg.addString(__FUNCTION__, offer.playerName);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketBrowseOwnOffers(const MarketOfferList &buyOffers, const MarketOfferList &sellOffers)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xF9);
	msg.addByte(__FUNCTION__, MARKETREQUEST_OWN_OFFERS);

	msg.addU32(__FUNCTION__, static_cast<uint32_t>(buyOffers.size()));
	for (const MarketOffer &offer : buyOffers)
	{
		msg.addU32(__FUNCTION__, offer.timestamp);
		msg.addU16(__FUNCTION__, offer.counter);
		msg.addU16(__FUNCTION__, offer.itemId);
		if (Item::items[offer.itemId].upgradeClassification > 0) {
			msg.addByte(__FUNCTION__, offer.tier);
		}
		msg.addU16(__FUNCTION__, offer.amount);
		msg.addU64(__FUNCTION__, offer.price);
	}

	msg.addU32(__FUNCTION__, static_cast<uint32_t>(sellOffers.size()));
	for (const MarketOffer &offer : sellOffers)
	{
		msg.addU32(__FUNCTION__, offer.timestamp);
		msg.addU16(__FUNCTION__, offer.counter);
		msg.addU16(__FUNCTION__, offer.itemId);
		if (Item::items[offer.itemId].upgradeClassification > 0) {
			msg.addByte(__FUNCTION__, offer.tier);
		}
		msg.addU16(__FUNCTION__, offer.amount);
		msg.addU64(__FUNCTION__, offer.price);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketCancelOffer(const MarketOfferEx &offer)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xF9);
	msg.addByte(__FUNCTION__, MARKETREQUEST_OWN_OFFERS);

	if (offer.type == MARKETACTION_BUY)
	{
		msg.addU32(__FUNCTION__, 0x01);
		msg.addU32(__FUNCTION__, offer.timestamp);
		msg.addU16(__FUNCTION__, offer.counter);
		msg.addU16(__FUNCTION__, offer.itemId);
		if (Item::items[offer.itemId].upgradeClassification > 0) {
			msg.addByte(__FUNCTION__, offer.tier);
		}
		msg.addU16(__FUNCTION__, offer.amount);
		msg.addU64(__FUNCTION__, offer.price);
		msg.addU32(__FUNCTION__, 0x00);
	}
	else
	{
		msg.addU32(__FUNCTION__, 0x00);
		msg.addU32(__FUNCTION__, 0x01);
		msg.addU32(__FUNCTION__, offer.timestamp);
		msg.addU16(__FUNCTION__, offer.counter);
		msg.addU16(__FUNCTION__, offer.itemId);
		if (Item::items[offer.itemId].upgradeClassification > 0) {
			msg.addByte(__FUNCTION__, offer.tier);
		}
		msg.addU16(__FUNCTION__, offer.amount);
		msg.addU64(__FUNCTION__, offer.price);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketBrowseOwnHistory(const HistoryMarketOfferList &buyOffers, const HistoryMarketOfferList &sellOffers)
{
	std::map<uint32_t, uint16_t> counterMap;
	uint32_t buyOffersToSend = std::min<uint32_t>(buyOffers.size(), 810 + std::max<int32_t>(0, 810 - sellOffers.size()));
	uint32_t sellOffersToSend = std::min<uint32_t>(sellOffers.size(), 810 + std::max<int32_t>(0, 810 - buyOffers.size()));

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xF9);
	msg.addByte(__FUNCTION__, MARKETREQUEST_OWN_HISTORY);
	// Send offers bytes
	InternalProtocol::sendMarketBrowseOffers(__FUNCTION__, msg, counterMap, buyOffers, buyOffersToSend);
	InternalProtocol::sendMarketBrowseOffers(__FUNCTION__, msg, counterMap, sellOffers, sellOffersToSend);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendForgingData()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x86);

	std::vector<ItemClassification*> classifications = g_game().getItemsClassifications();
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(classifications.size()));
	for (ItemClassification* classification : classifications)
	{
		msg.addByte(__FUNCTION__, classification->id);
		msg.addByte(__FUNCTION__, static_cast<uint8_t>(classification->tiers.size()));
		for (const auto &[tier, price] : classification->tiers)
		{
			msg.addByte(__FUNCTION__, tier);
			msg.addU64(__FUNCTION__, price);
		}
	}

	// Version 12.81
	// Forge Config Bytes

	// (conversion) (left column top) Cost to make 1 bottom item - 20
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(g_configManager().getNumber(FORGE_COST_ONE_SLIVER)));
	// (conversion) (left column bottom) How many items to make - 3
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(g_configManager().getNumber(FORGE_SLIVER_AMOUNT)));
	// (conversion) (middle column top) Cost to make 1 - 50
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(g_configManager().getNumber(FORGE_CORE_COST)));
	// (conversion) (right column top) Current stored dust limit minus this number = cost to increase stored dust limit - 75
	msg.addByte(__FUNCTION__, 75);
	// (conversion) (right column bottom) Starting stored dust limit
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(player->getForgeDustLevel()));
	// (conversion) (right column bottom) Max stored dust limit - 225
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(g_configManager().getNumber(FORGE_MAX_DUST)));
	// (fusion) Dust cost - 100
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(g_configManager().getNumber(FORGE_FUSION_DUST_COST)));
	// (transfer) Dust cost - 100
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(g_configManager().getNumber(FORGE_TRANSFER_DUST_COST)));
	// (fusion) Base success rate - 50
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(g_configManager().getNumber(FORGE_BASE_SUCCESS_RATE)));
	// (fusion) Bonus success rate - 15
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(g_configManager().getNumber(FORGE_BONUS_SUCCESS_RATE)));
	// (fusion) Tier loss chance after reduction - 50
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(g_configManager().getNumber(FORGE_TIER_LOSS_REDUCTION)));

	// Update player resources
	parseSendResourceBalance();

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendOpenForge() {
	// We will use it when sending the bytes to send the item information to the client
	std::map<uint16_t, std::map<uint8_t, uint16_t>> fusionItemsMap;
	std::map<uint16_t, std::map<uint8_t, uint16_t>> donorTierItemMap;
	std::map<uint16_t, std::map<uint8_t, uint16_t>> receiveTierItemMap;

	/*
	 *Start - Parsing items informations
	*/
	for (const auto &item : player->getAllInventoryItems(true)) {
		if (item->hasImbuements()) {
			continue;
		}

		auto itemClassification = item->getClassification();
		auto itemTier = item->getTier();
		auto maxConfigTier = g_configManager().getNumber(FORGE_MAX_ITEM_TIER);
		auto maxTier = (itemClassification == 4 ? maxConfigTier : itemClassification);
		// Save fusion items on map
		if (itemClassification != 0 && itemTier < maxTier) {
			getForgeInfoMap(item, fusionItemsMap);
		}

		if (itemClassification > 0) {
			if (itemClassification < 4 && itemTier > maxTier) {
				continue;
			}
			// Save transfer (donator of tier) items on map
			if (itemTier > 1) {
				getForgeInfoMap(item, donorTierItemMap);
			}
			// Save transfer (receiver of tier) items on map
			if (itemTier == 0) {
				getForgeInfoMap(item, receiveTierItemMap);
			}
		}
	}

	// Checking size of map to send in the addByte (total fusion items count)
	uint8_t fusionTotalItemsCount = 0;
	for (const auto &[itemId, tierAndCountMap] : fusionItemsMap) {
		for (const auto [itemTier, itemCount] : tierAndCountMap) {
			if (itemCount >= 2) {
				fusionTotalItemsCount++;
			}
		}
	}

	/*
	 * Start - Sending bytes
	*/
	NetworkMessage msg;
	// Header byte (135)
	msg.addByte(__FUNCTION__, 0x87);
	msg.addU16(__FUNCTION__, fusionTotalItemsCount);
	for (const auto &[itemId, tierAndCountMap] : fusionItemsMap) {
		for (const auto [itemTier, itemCount] : tierAndCountMap) {
			if (itemCount >= 2) {
				msg.addByte(__FUNCTION__, 0x01); // Number of friend items?
				msg.addU16(__FUNCTION__, itemId);
				msg.addByte(__FUNCTION__, itemTier);
				msg.addU16(__FUNCTION__, itemCount);
			}
		}
	}

	auto transferTotalCount = InternalProtocol::getIterationIncreaseCount(donorTierItemMap);
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(transferTotalCount));
	if (transferTotalCount > 0) {
		for (const auto &[itemId, tierAndCountMap] : donorTierItemMap) {
			// Let's access the itemType to check the item's (donator of tier) classification level
			// Must be the same as the item that will receive the tier
			const ItemType &donorType = Item::items[itemId];

			// Total count of item (donator of tier)
			auto donorTierTotalItemsCount = InternalProtocol::getIterationIncreaseCount(tierAndCountMap);
			msg.addU16(__FUNCTION__, donorTierTotalItemsCount);
			for (const auto [donorItemTier, donorItemCount] : tierAndCountMap) {
				msg.addU16(__FUNCTION__, itemId);
				msg.addByte(__FUNCTION__, donorItemTier);
				msg.addU16(__FUNCTION__, donorItemCount);
			}

			uint16_t receiveTierTotalItemCount = 0;
			for (const auto &[iteratorItemId, unusedTierAndCountMap] : receiveTierItemMap) {
				// Let's access the itemType to check the item's (receiver of tier) classification level
				const ItemType &receiveType = Item::items[iteratorItemId];
				if (donorType.upgradeClassification == receiveType.upgradeClassification) {
					receiveTierTotalItemCount++;
				}
			}

			// Total count of item (receiver of tier)
			msg.addU16(__FUNCTION__, receiveTierTotalItemCount);
			if (receiveTierTotalItemCount > 0) {
				for (const auto &[receiveItemId, receiveTierAndCountMap] : receiveTierItemMap) {
					// Let's access the itemType to check the item's (receiver of tier) classification level
					const ItemType &receiveType = Item::items[receiveItemId];
					if (donorType.upgradeClassification == receiveType.upgradeClassification) {
						for (const auto [receiveItemTier, receiveItemCount] : receiveTierAndCountMap) {
							msg.addU16(__FUNCTION__, receiveItemId);
							msg.addU16(__FUNCTION__, receiveItemCount);
						}
					}
				}
			}
		}
	}

	msg.addByte(__FUNCTION__, static_cast<uint8_t>(player->getForgeDustLevel())); // Player dust limit
	writeToOutputBuffer(msg);
	// Update forging informations
	sendForgingData();
}

void ProtocolGame::parseForgeEnter(NetworkMessage& msg) {
	// 0xBF -> 0 = fusion, 1 = transfer, 2 = dust to sliver, 3 = sliver to core, 4 = increase dust limit
	uint8_t action = msg.getByte();
	uint16_t firstItem = msg.get<uint16_t>();
	uint8_t tier = msg.getByte();
	uint16_t secondItem = msg.get<uint16_t>();
	bool usedCore = msg.getByte();
	bool reduceTierLoss = msg.getByte();
	if (action == 0) {
		addGameTask(&Game::playerForgeFuseItems, player->getID(), firstItem, tier, usedCore, reduceTierLoss);
	} else if (action == 1) {
		addGameTask(&Game::playerForgeTransferItemTier, player->getID(), firstItem, tier, secondItem);
	} else if (action <= 4) {
		addGameTask(&Game::playerForgeResourceConversion, player->getID(), action);
	}
}

void ProtocolGame::parseForgeBrowseHistory(NetworkMessage& msg)
{
	addGameTask(&Game::playerBrowseForgeHistory, player->getID(), msg.getByte());
}

void ProtocolGame::sendForgeFusionItem(uint16_t itemId, uint8_t tier, bool success, uint8_t bonus, uint8_t coreCount) {
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x8A);

	msg.addByte(__FUNCTION__, 0x00); // Fusion = 0
	// Was succeeded bool
	msg.addByte(__FUNCTION__, success);

	msg.addU16(__FUNCTION__, itemId); // Left item
	msg.addByte(__FUNCTION__, tier); // Left item tier
	msg.addU16(__FUNCTION__, itemId); // Right item
	msg.addByte(__FUNCTION__, tier + 1); // Right item tier

	msg.addByte(__FUNCTION__, bonus); // Roll fusion bonus
	// Core kept
	if (bonus == 2)
	{
		msg.addByte(__FUNCTION__, coreCount);
	}
	else if (bonus >= 4 && bonus <= 8)
	{
		msg.addU16(__FUNCTION__, itemId);
		msg.addByte(__FUNCTION__, tier);
	}

	writeToOutputBuffer(msg);
	sendOpenForge();
}

void ProtocolGame::sendTransferItemTier(uint16_t firstItem, uint8_t tier, uint16_t secondItem) {
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x8A);

	msg.addByte(__FUNCTION__, 0x01); // Transfer = 1
	msg.addByte(__FUNCTION__, 0x01); // Always success

	msg.addU16(__FUNCTION__, firstItem); // Left item
	msg.addByte(__FUNCTION__, tier); // Left item tier
	msg.addU16(__FUNCTION__, secondItem); // Right item
	msg.addByte(__FUNCTION__, tier - 1); // Right item tier

	msg.addByte(__FUNCTION__, 0x00); // Bonus type always none

	writeToOutputBuffer(msg);
	sendOpenForge();
}

void ProtocolGame::sendForgeHistory(uint8_t page)
{
	page = page + 1;
	auto historyVector = player->getForgeHistory();
	auto historyVectorLen = InternalProtocol::getVectorIterationIncreaseCount(historyVector);

	uint16_t lastPage = (1 < std::floor((historyVectorLen - 1) / 9) + 1) ? static_cast<uint16_t>(std::floor((historyVectorLen - 1) / 9) + 1) : 1;
	uint16_t currentPage = (lastPage < page) ? lastPage : page;

	std::vector<ForgeHistory> historyPerPage;
	uint16_t pageFirstEntry = (0 < historyVectorLen - (currentPage - 1) * 9) ? historyVectorLen - (currentPage - 1) * 9 : 0;
	uint16_t pageLastEntry = (0 < historyVectorLen - currentPage * 9) ? historyVectorLen - currentPage * 9: 0;
	for (uint16_t entry = pageFirstEntry; entry > pageLastEntry; --entry) {
		historyPerPage.push_back(historyVector[entry - 1]);
	}

	auto historyPageToSend = InternalProtocol::getVectorIterationIncreaseCount(historyPerPage);

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x88);
	msg.addU16(__FUNCTION__, currentPage - 1); // Current page
	msg.addU16(__FUNCTION__, lastPage); // Last page
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(historyPageToSend)); // History to send

	if (historyPageToSend > 0) {
		for (const auto &history : historyPerPage) {
			auto action = magic_enum::enum_integer(history.actionType);
			msg.addU32(__FUNCTION__, static_cast<uint32_t>(history.createdAt));
			msg.addByte(__FUNCTION__, action);
			msg.addString(__FUNCTION__, history.description);
			msg.addByte(__FUNCTION__, (history.bonus >= 1 && history.bonus < 8) ? 0x01 : 0x00);
		}
	}
	
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendForgeError(const ReturnValue returnValue)
{
	sendMessageDialog(getReturnMessage(returnValue));
	closeForgeWindow();
}

void ProtocolGame::closeForgeWindow()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x89);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketDetail(uint16_t itemId, uint8_t tier)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xF8);
	msg.addU16(__FUNCTION__, itemId);
	const ItemType &it = Item::items[itemId];

	if (it.upgradeClassification > 0) {
		msg.addByte(__FUNCTION__, tier);
	}

	if (it.armor != 0)
	{
		msg.addString(__FUNCTION__, std::to_string(it.armor));
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	if (it.attack != 0)
	{
		// TODO: chance to hit, range
		// example:
		// "attack +x, chance to hit +y%, z fields"
		if (it.abilities && it.abilities->elementType != COMBAT_NONE && it.abilities->elementDamage != 0)
		{
			std::ostringstream ss;
			ss << it.attack << " physical +" << it.abilities->elementDamage << ' ' << getCombatName(it.abilities->elementType);
			msg.addString(__FUNCTION__, ss.str());
		}
		else
		{
			msg.addString(__FUNCTION__, std::to_string(it.attack));
		}
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	if (it.isContainer())
	{
		msg.addString(__FUNCTION__, std::to_string(it.maxItems));
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	if (it.defense != 0)
	{
		if (it.extraDefense != 0)
		{
			std::ostringstream ss;
			ss << it.defense << ' ' << std::showpos << it.extraDefense << std::noshowpos;
			msg.addString(__FUNCTION__, ss.str());
		}
		else
		{
			msg.addString(__FUNCTION__, std::to_string(it.defense));
		}
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	if (!it.description.empty())
	{
		const std::string &descr = it.description;
		if (descr.back() == '.')
		{
			msg.addString(__FUNCTION__, std::string(descr, 0, descr.length() - 1));
		}
		else
		{
			msg.addString(__FUNCTION__, descr);
		}
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	if (it.decayTime != 0)
	{
		std::ostringstream ss;
		ss << it.decayTime << " seconds";
		msg.addString(__FUNCTION__, ss.str());
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	if (it.abilities)
	{
		std::ostringstream ss;
		bool separator = false;

		for (size_t i = 0; i < COMBAT_COUNT; ++i)
		{
			if (it.abilities->absorbPercent[i] == 0)
			{
				continue;
			}

			if (separator)
			{
				ss << ", ";
			}
			else
			{
				separator = true;
			}

			ss << getCombatName(indexToCombatType(i)) << ' ' << std::showpos << it.abilities->absorbPercent[i] << std::noshowpos << '%';
		}

		msg.addString(__FUNCTION__, ss.str());
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	if (it.minReqLevel != 0)
	{
		msg.addString(__FUNCTION__, std::to_string(it.minReqLevel));
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	if (it.minReqMagicLevel != 0)
	{
		msg.addString(__FUNCTION__, std::to_string(it.minReqMagicLevel));
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	msg.addString(__FUNCTION__, it.vocationString);

	msg.addString(__FUNCTION__, it.runeSpellName);

	if (it.abilities)
	{
		std::ostringstream ss;
		bool separator = false;

		for (uint8_t i = SKILL_FIRST; i <= SKILL_FISHING; i++)
		{
			if (!it.abilities->skills[i])
			{
				continue;
			}

			if (separator)
			{
				ss << ", ";
			}
			else
			{
				separator = true;
			}

			ss << getSkillName(i) << ' ' << std::showpos << it.abilities->skills[i] << std::noshowpos;
		}

		for (uint8_t i = SKILL_CRITICAL_HIT_CHANCE; i <= SKILL_LAST; i++)
		{
			if (!it.abilities->skills[i])
			{
				continue;
			}

			if (separator)
			{
				ss << ", ";
			}
			else
			{
				separator = true;
			}

			ss << getSkillName(i) << ' ';
			if (i != SKILL_CRITICAL_HIT_CHANCE) {
				ss << std::showpos;
			}
			ss << it.abilities->skills[i] << '%';

			if (i != SKILL_CRITICAL_HIT_CHANCE) {
				ss << std::noshowpos;
			}
		}

		if (it.abilities->stats[STAT_MAGICPOINTS] != 0)
		{
			if (separator)
			{
				ss << ", ";
			}
			else
			{
				separator = true;
			}

			ss << "magic level " << std::showpos << it.abilities->stats[STAT_MAGICPOINTS] << std::noshowpos;
		}

		if (it.abilities->speed != 0)
		{
			if (separator)
			{
				ss << ", ";
			}

			ss << "speed " << std::showpos << (it.abilities->speed >> 1) << std::noshowpos;
		}

		msg.addString(__FUNCTION__, ss.str());
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	if (it.charges != 0)
	{
		msg.addString(__FUNCTION__, std::to_string(it.charges));
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	std::string weaponName = getWeaponName(it.weaponType);

	if (it.slotPosition & SLOTP_TWO_HAND)
	{
		if (!weaponName.empty())
		{
			weaponName += ", two-handed";
		}
		else
		{
			weaponName = "two-handed";
		}
	}

	msg.addString(__FUNCTION__, weaponName);

	if (it.weight != 0)
	{
		std::ostringstream ss;
		if (it.weight < 10)
		{
			ss << "0.0" << it.weight;
		}
		else if (it.weight < 100)
		{
			ss << "0." << it.weight;
		}
		else
		{
			std::string weightString = std::to_string(it.weight);
			weightString.insert(weightString.end() - 2, '.');
			ss << weightString;
		}
		ss << " oz";
		msg.addString(__FUNCTION__, ss.str());
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	if (it.imbuementSlot > 0)
	{
		msg.addString(__FUNCTION__, std::to_string(it.imbuementSlot));
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	// Magic shield capacity modifier (12.70)
	msg.addU16(__FUNCTION__, 0x00);
	// Cleave modifier (12.70)
	msg.addU16(__FUNCTION__, 0x00);
	// Damage reflection modifier (12.70)
	msg.addU16(__FUNCTION__, 0x00);
	// Perfect shot modifier (12.70)
	msg.addU16(__FUNCTION__, 0x00);

	// Upgrade and tier detail modifier
	if (it.upgradeClassification > 0 && tier > 0)
	{
		msg.addString(__FUNCTION__, std::to_string(it.upgradeClassification));
		std::ostringstream ss;

		ss << static_cast<uint16_t>(tier) << " (";
		double chance;
		if (it.isWeapon()) {
			chance = 0.5 * tier + 0.05 * ((tier - 1) * (tier - 1));
			ss << std::setprecision(2) << std::fixed << chance << "% Onslaught)";
		}
		else if (it.isHelmet()) {
			chance = 2 * tier + 0.05 * ((tier - 1) * (tier - 1));
			ss << std::setprecision(2) << std::fixed << chance << "% Momentum)";
		}
		else if (it.isArmor()) {
			chance = (0.0307576 * tier * tier) + (0.440697 * tier) + 0.026;
			ss << std::setprecision(2) << std::fixed << chance << "% Ruse)";
		}
		msg.addString(__FUNCTION__, ss.str());
	}
	else if (it.upgradeClassification > 0 && tier == 0)
	{
		msg.addString(__FUNCTION__, std::to_string(it.upgradeClassification));
		msg.addString(__FUNCTION__, std::to_string(tier));
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
		msg.addU16(__FUNCTION__, 0x00);
	}

	auto purchase = IOMarket::getInstance().getPurchaseStatistics()[itemId][tier];
	if (const MarketStatistics* purchaseStatistics = &purchase; purchaseStatistics)
	{
		msg.addByte(__FUNCTION__, 0x01);
		msg.addU32(__FUNCTION__, purchaseStatistics->numTransactions);
		msg.addU64(__FUNCTION__, purchaseStatistics->totalPrice);
		msg.addU64(__FUNCTION__, purchaseStatistics->highestPrice);
		msg.addU64(__FUNCTION__, purchaseStatistics->lowestPrice);
	}
	else
	{
		msg.addByte(__FUNCTION__, 0x00);
	}

	auto sale = IOMarket::getInstance().getSaleStatistics()[itemId][tier];
	if (const MarketStatistics* saleStatistics = &sale; saleStatistics)
	{
		msg.addByte(__FUNCTION__, 0x01);
		msg.addU32(__FUNCTION__, saleStatistics->numTransactions);
		msg.addU64(__FUNCTION__, std::min<uint64_t>(std::numeric_limits<uint32_t>::max(), saleStatistics->totalPrice));
		msg.addU64(__FUNCTION__, saleStatistics->highestPrice);
		msg.addU64(__FUNCTION__, saleStatistics->lowestPrice);
	}
	else
	{
		msg.addByte(__FUNCTION__, 0x00);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTradeItemRequest(const std::string &traderName, const Item *item, bool ack)
{
	NetworkMessage msg;

	if (ack)
	{
		msg.addByte(__FUNCTION__, 0x7D);
	}
	else
	{
		msg.addByte(__FUNCTION__, 0x7E);
	}

	msg.addString(__FUNCTION__, traderName);

	if (const Container *tradeContainer = item->getContainer())
	{
		std::list<const Container *> listContainer{tradeContainer};
		std::list<const Item *> itemList{tradeContainer};
		while (!listContainer.empty())
		{
			const Container *container = listContainer.front();
			listContainer.pop_front();

			for (Item *containerItem : container->getItemList())
			{
				Container *tmpContainer = containerItem->getContainer();
				if (tmpContainer)
				{
					listContainer.push_back(tmpContainer);
				}
				itemList.push_back(containerItem);
			}
		}

		msg.addByte(__FUNCTION__, static_cast<uint8_t>(itemList.size()));
		for (const Item *listItem : itemList)
		{
			AddItem(msg, listItem);
		}
	}
	else
	{
		msg.addByte(__FUNCTION__, 0x01);
		AddItem(msg, item);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCloseTrade()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x7F);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCloseContainer(uint8_t cid)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x6F);
	msg.addByte(__FUNCTION__, cid);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureTurn(const Creature *creature, uint32_t stackPos)
{
	if (!canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x6B);
	msg.addPosition(__FUNCTION__, creature->getPosition());
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(stackPos));
	msg.addU16(__FUNCTION__, 0x63);
	msg.addU32(__FUNCTION__, creature->getID());
	msg.addByte(__FUNCTION__, creature->getDirection());
	msg.addByte(__FUNCTION__, player->canWalkthroughEx(creature) ? 0x00 : 0x01);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureSay(const Creature *creature, SpeakClasses type, const std::string &text, const Position *pos /* = nullptr*/)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xAA);

	static uint32_t statementId = 0;
	++statementId;
	msg.addU32(__FUNCTION__, statementId);

	msg.addString(__FUNCTION__, creature->getName());
	msg.addByte(__FUNCTION__, 0x00); // Show (Traded)

	//Add level only for players
	if (const Player *speaker = creature->getPlayer())
	{
		msg.addU16(__FUNCTION__, static_cast<uint16_t>(speaker->getLevel()));
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	msg.addByte(__FUNCTION__, type);
	if (pos)
	{
		msg.addPosition(__FUNCTION__, *pos);
	}
	else
	{
		msg.addPosition(__FUNCTION__, creature->getPosition());
	}

	msg.addString(__FUNCTION__, text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendToChannel(const Creature *creature, SpeakClasses type, const std::string &text, uint16_t channelId)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xAA);

	static uint32_t statementId = 0;
	++statementId;
	msg.addU32(__FUNCTION__, statementId);
	if (!creature)
	{
		msg.addU32(__FUNCTION__, 0x00);
		if (statementId != 0)
		{
			msg.addByte(__FUNCTION__, 0x00); // Show (Traded)
		}
	}
	else if (type == TALKTYPE_CHANNEL_R2)
	{
		msg.addU32(__FUNCTION__, 0x00);
		if (statementId != 0)
		{
			msg.addByte(__FUNCTION__, 0x00); // Show (Traded)
		}
		type = TALKTYPE_CHANNEL_R1;
	}
	else
	{
		msg.addString(__FUNCTION__, creature->getName());
		if (statementId != 0)
		{
			msg.addByte(__FUNCTION__, 0x00); // Show (Traded)
		}

		//Add level only for players
		if (const Player *speaker = creature->getPlayer())
		{
			msg.addU16(__FUNCTION__, static_cast<uint16_t>(speaker->getLevel()));
		}
		else
		{
			msg.addU16(__FUNCTION__, 0x00);
		}
	}

	msg.addByte(__FUNCTION__, type);
	msg.addU16(__FUNCTION__, channelId);
	msg.addString(__FUNCTION__, text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPrivateMessage(const Player *speaker, SpeakClasses type, const std::string &text)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xAA);
	static uint32_t statementId = 0;
	++statementId;
	msg.addU32(__FUNCTION__, statementId);
	if (speaker)
	{
		msg.addString(__FUNCTION__, speaker->getName());
		if (statementId != 0)
		{
			msg.addByte(__FUNCTION__, 0x00); // Show (Traded)
		}
		msg.addU16(__FUNCTION__, static_cast<uint16_t>(speaker->getLevel()));
	}
	else
	{
		msg.addU32(__FUNCTION__, 0x00);
		if (statementId != 0)
		{
			msg.addByte(__FUNCTION__, 0x00); // Show (Traded)
		}
	}
	msg.addByte(__FUNCTION__, type);
	msg.addString(__FUNCTION__, text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCancelTarget()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xA3);
	msg.addU32(__FUNCTION__, 0x00);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChangeSpeed(const Creature *creature, uint16_t speed)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x8F);
	msg.addU32(__FUNCTION__, creature->getID());
	msg.addU16(__FUNCTION__, creature->getBaseSpeed());
	msg.addU16(__FUNCTION__, speed);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCancelWalk()
{
	if (player)
	{
		NetworkMessage msg;
		msg.addByte(__FUNCTION__, 0xB5);
		msg.addByte(__FUNCTION__, player->getDirection());
		writeToOutputBuffer(msg);
	}
}

void ProtocolGame::sendSkills()
{
	NetworkMessage msg;
	AddPlayerSkills(msg);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPing()
{
	if (player)
	{
		NetworkMessage msg;
		msg.addByte(__FUNCTION__, 0x1D);
		writeToOutputBuffer(msg);
	}
}

void ProtocolGame::sendPingBack()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x1E);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendDistanceShoot(const Position &from, const Position &to, uint8_t type)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x83);
	msg.addPosition(__FUNCTION__, from);
	msg.addByte(__FUNCTION__, MAGIC_EFFECTS_CREATE_DISTANCEEFFECT);
	msg.addByte(__FUNCTION__, type);
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(static_cast<int8_t>(static_cast<int32_t>(to.x) - static_cast<int32_t>(from.x))));
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(static_cast<int8_t>(static_cast<int32_t>(to.y) - static_cast<int32_t>(from.y))));
	msg.addByte(__FUNCTION__, MAGIC_EFFECTS_END_LOOP);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendRestingStatus(uint8_t protection)
{
	if (!player)
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xA9);
	msg.addByte(__FUNCTION__, protection); // 1 / 0
	int32_t PlayerdailyStreak = 0;
	player->getStorageValue(STORAGEVALUE_DAILYREWARD, PlayerdailyStreak);
	msg.addByte(__FUNCTION__, PlayerdailyStreak < 2 ? 0 : 1);
	if (PlayerdailyStreak < 2)
	{
		msg.addString(__FUNCTION__, "Resting Area (no active bonus)");
	}
	else
	{
		std::ostringstream ss;
		ss << "Active Resting Area Bonuses: ";
		if (PlayerdailyStreak < DAILY_REWARD_DOUBLE_HP_REGENERATION)
		{
			ss << "\nHit Points Regeneration";
		}
		else
		{
			ss << "\nDouble Hit Points Regeneration";
		}
		if (PlayerdailyStreak >= DAILY_REWARD_MP_REGENERATION)
		{
			if (PlayerdailyStreak < DAILY_REWARD_DOUBLE_MP_REGENERATION)
			{
				ss << ",\nMana Points Regeneration";
			}
			else
			{
				ss << ",\nDouble Mana Points Regeneration";
			}
		}
		if (PlayerdailyStreak >= DAILY_REWARD_STAMINA_REGENERATION)
		{
			ss << ",\nStamina Points Regeneration";
		}
		if (PlayerdailyStreak >= DAILY_REWARD_SOUL_REGENERATION)
		{
			ss << ",\nSoul Points Regeneration";
		}
		ss << ".";
		msg.addString(__FUNCTION__, ss.str());
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMagicEffect(const Position &pos, uint8_t type)
{
	if (!canSee(pos))
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x83);
	msg.addPosition(__FUNCTION__, pos);
	msg.addByte(__FUNCTION__, MAGIC_EFFECTS_CREATE_EFFECT);
	msg.addByte(__FUNCTION__, type);
	msg.addByte(__FUNCTION__, MAGIC_EFFECTS_END_LOOP);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureHealth(const Creature *creature)
{
	if (creature->isHealthHidden())
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x8C);
	msg.addU32(__FUNCTION__, creature->getID());

	if (creature->isHealthHidden())
	{
		msg.addByte(__FUNCTION__, 0x00);
	}
	else
	{
		msg.addByte(__FUNCTION__, static_cast<uint8_t>(std::ceil((static_cast<double>(creature->getHealth()) / std::max<int32_t>(creature->getMaxHealth(), 1)) * 100)));
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPartyCreatureUpdate(const Creature* target)
{
	bool known;
	uint32_t removedKnown = 0;
	uint32_t cid = target->getID();
	checkCreatureAsKnown(cid, known, removedKnown);

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x8B);
	msg.addU32(__FUNCTION__, cid);
	msg.addByte(__FUNCTION__, 0);  // creature update
	AddCreature(msg, target, known, removedKnown);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPartyCreatureShield(const Creature* target)
{
	uint32_t cid = target->getID();
	if (knownCreatureSet.find(cid) == knownCreatureSet.end()) {
		sendPartyCreatureUpdate(target);
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x91);
	msg.addU32(__FUNCTION__, cid);
	msg.addByte(__FUNCTION__, player->getPartyShield(target->getPlayer()));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPartyCreatureSkull(const Creature* target)
{
	if (g_game().getWorldType() != WORLD_TYPE_PVP) {
		return;
	}

	uint32_t cid = target->getID();
	if (knownCreatureSet.find(cid) == knownCreatureSet.end()) {
		sendPartyCreatureUpdate(target);
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x90);
	msg.addU32(__FUNCTION__, cid);
	msg.addByte(__FUNCTION__, player->getSkullClient(target));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPartyCreatureHealth(const Creature* target, uint8_t healthPercent)
{
	uint32_t cid = target->getID();
	if (knownCreatureSet.find(cid) == knownCreatureSet.end()) {
		sendPartyCreatureUpdate(target);
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x8C);
	msg.addU32(__FUNCTION__, cid);
	msg.addByte(__FUNCTION__, healthPercent);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPartyPlayerMana(const Player* target, uint8_t manaPercent)
{
	uint32_t cid = target->getID();
	if (knownCreatureSet.find(cid) == knownCreatureSet.end()) {
		sendPartyCreatureUpdate(target);
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x8B);
	msg.addU32(__FUNCTION__, cid);
	msg.addByte(__FUNCTION__, 11);  // mana percent
	msg.addByte(__FUNCTION__, manaPercent);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPartyCreatureShowStatus(const Creature* target, bool showStatus)
{
	uint32_t cid = target->getID();
	if (knownCreatureSet.find(cid) == knownCreatureSet.end()) {
		sendPartyCreatureUpdate(target);
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x8B);
	msg.addU32(__FUNCTION__, cid);
	msg.addByte(__FUNCTION__, 12);  // show status
	msg.addByte(__FUNCTION__, (showStatus ? 0x01 : 0x00));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPartyPlayerVocation(const Player* target)
{
	uint32_t cid = target->getID();
	if (knownCreatureSet.find(cid) == knownCreatureSet.end()) {
		sendPartyCreatureUpdate(target);
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x8B);
	msg.addU32(__FUNCTION__, cid);
	msg.addByte(__FUNCTION__, 13);  // vocation
	msg.addByte(__FUNCTION__, target->getVocation()->getClientId());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPlayerVocation(const Player* target)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x8B);
	msg.addU32(__FUNCTION__, target->getID());
	msg.addByte(__FUNCTION__, 13);  // vocation
	msg.addByte(__FUNCTION__, target->getVocation()->getClientId());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendFYIBox(const std::string &message)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x15);
	msg.addString(__FUNCTION__, message);
	writeToOutputBuffer(msg);
}

//tile
void ProtocolGame::sendMapDescription(const Position& pos)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x64);
	msg.addPosition(__FUNCTION__, player->getPosition());
	GetMapDescription(pos.x - Map::maxClientViewportX, pos.y - Map::maxClientViewportY, pos.z, (Map::maxClientViewportX + 1) * 2, (Map::maxClientViewportY + 1) * 2, msg);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddTileItem(const Position &pos, uint32_t stackpos, const Item *item)
{
	if (!canSee(pos))
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x6A);
	msg.addPosition(__FUNCTION__, pos);
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(stackpos));
	AddItem(msg, item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateTileItem(const Position &pos, uint32_t stackpos, const Item *item)
{
	if (!canSee(pos))
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x6B);
	msg.addPosition(__FUNCTION__, pos);
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(stackpos));
	AddItem(msg, item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendRemoveTileThing(const Position &pos, uint32_t stackpos)
{
	if (!canSee(pos))
	{
		return;
	}

	NetworkMessage msg;
	RemoveTileThing(msg, pos, stackpos);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateTile(const Tile *tile, const Position &pos)
{
	if (!canSee(pos))
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x69);
	msg.addPosition(__FUNCTION__, pos);

	if (tile)
	{
		GetTileDescription(tile, msg);
		msg.addByte(__FUNCTION__, 0x00);
		msg.addByte(__FUNCTION__, 0xFF);
	}
	else
	{
		msg.addByte(__FUNCTION__, 0x01);
		msg.addByte(__FUNCTION__, 0xFF);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPendingStateEntered()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x0A);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendEnterWorld()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x0F);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendFightModes()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xA7);
	msg.addByte(__FUNCTION__, player->fightMode);
	msg.addByte(__FUNCTION__, player->chaseMode);
	msg.addByte(__FUNCTION__, player->secureMode);
	msg.addByte(__FUNCTION__, PVP_MODE_DOVE);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddCreature(const Creature *creature, const Position &pos, int32_t stackpos, bool isLogin)
{
	if (!canSee(pos))
	{
		return;
	}

	if (creature != player)
	{
		if (stackpos >= 10)
		{
			return;
		}

		NetworkMessage msg;
		msg.addByte(__FUNCTION__, 0x6A);
		msg.addPosition(__FUNCTION__, pos);
		msg.addByte(__FUNCTION__, static_cast<uint8_t>(stackpos));

		bool known;
		uint32_t removedKnown;
		checkCreatureAsKnown(creature->getID(), known, removedKnown);
		AddCreature(msg, creature, known, removedKnown);
		writeToOutputBuffer(msg);

		if (isLogin)
		{
			if (const Player *creaturePlayer = creature->getPlayer())
			{
				if (!creaturePlayer->isAccessPlayer() ||
					creaturePlayer->getAccountType() == account::ACCOUNT_TYPE_NORMAL)
					sendMagicEffect(pos, CONST_ME_TELEPORT);
			}
			else
			{
				sendMagicEffect(pos, CONST_ME_TELEPORT);
			}
		}

		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x17);

	msg.addU32(__FUNCTION__, player->getID());
	msg.addU16(__FUNCTION__, 0x32); // beat duration (50)

	msg.addDouble(__FUNCTION__, Creature::speedA, 3);
	msg.addDouble(__FUNCTION__, Creature::speedB, 3);
	msg.addDouble(__FUNCTION__, Creature::speedC, 3);

	// can report bugs?
	if (player->getAccountType() >= account::ACCOUNT_TYPE_NORMAL)
	{
		msg.addByte(__FUNCTION__, 0x01);
	}
	else
	{
		msg.addByte(__FUNCTION__, 0x00);
	}

	msg.addByte(__FUNCTION__, 0x00); // can change pvp framing option
	msg.addByte(__FUNCTION__, 0x00); // expert mode button enabled

	msg.addString(__FUNCTION__, g_configManager().getString(STORE_IMAGES_URL));
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(g_configManager().getNumber(STORE_COIN_PACKET)));

	msg.addByte(__FUNCTION__, shouldAddExivaRestrictions ? 0x01 : 0x00); // exiva button enabled
	msg.addByte(__FUNCTION__, 0x00); // Tournament button

	writeToOutputBuffer(msg);

	sendTibiaTime(g_game().getLightHour());
	sendPendingStateEntered();
	sendEnterWorld();
	sendMapDescription(pos);
	loggedIn = true;

	if (isLogin)
	{
		sendMagicEffect(pos, CONST_ME_TELEPORT);
	}

	for (int i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i)
	{
		sendInventoryItem(static_cast<Slots_t>(i), player->getInventoryItem(static_cast<Slots_t>(i)));
	}

	sendStats();
	sendSkills();
	sendBlessStatus();

	sendPremiumTrigger();

	sendItemsPrice();

	sendPreyPrices();
	player->sendPreyData();
	player->sendTaskHuntingData();
	sendForgingData();

	//gameworld light-settings
	sendWorldLight(g_game().getWorldLightInfo());

	//player light level
	sendCreatureLight(creature);

	const std::forward_list<VIPEntry> &vipEntries = IOLoginData::getVIPEntries(player->getAccount());

	if (player->isAccessPlayer())
	{
		for (const VIPEntry &entry : vipEntries)
		{
			VipStatus_t vipStatus;

			const Player *vipPlayer = g_game().getPlayerByGUID(entry.guid);
			if (!vipPlayer)
			{
				vipStatus = VIPSTATUS_OFFLINE;
			}
			else
			{
				vipStatus = vipPlayer->statusVipList;
			}

			sendVIP(entry.guid, entry.name, entry.description, entry.icon, entry.notify, vipStatus);
		}
	}
	else
	{
		for (const VIPEntry &entry : vipEntries)
		{
			VipStatus_t vipStatus;

			const Player *vipPlayer = g_game().getPlayerByGUID(entry.guid);
			if (!vipPlayer || vipPlayer->isInGhostMode())
			{
				vipStatus = VIPSTATUS_OFFLINE;
			}
			else
			{
				vipStatus = vipPlayer->statusVipList;
			}

			sendVIP(entry.guid, entry.name, entry.description, entry.icon, entry.notify, vipStatus);
		}
	}

	sendInventoryIds();
	Item *slotItem = player->getInventoryItem(CONST_SLOT_BACKPACK);
	if (slotItem)
	{
		Container *mainBackpack = slotItem->getContainer();
		Container *hasQuickLootContainer = player->getLootContainer(OBJECTCATEGORY_DEFAULT);
		if (mainBackpack && !hasQuickLootContainer)
		{
			player->setLootContainer(OBJECTCATEGORY_DEFAULT, mainBackpack);
			sendInventoryItem(CONST_SLOT_BACKPACK, player->getInventoryItem(CONST_SLOT_BACKPACK));
		}
	}

	sendLootContainers();
	sendBasicData();

	player->sendClientCheck();
	player->sendGameNews();
	player->sendIcons();
}

void ProtocolGame::sendMoveCreature(const Creature *creature, const Position &newPos, int32_t newStackPos, const Position &oldPos, int32_t oldStackPos, bool teleport)
{
	if (creature == player)
	{
		if (oldStackPos >= 10)
		{
			sendMapDescription(newPos);
		}
		else if (teleport)
		{
			NetworkMessage msg;
			RemoveTileThing(msg, oldPos, oldStackPos);
			writeToOutputBuffer(msg);
			sendMapDescription(newPos);
		}
		else
		{
			NetworkMessage msg;
			if (oldPos.z == MAP_INIT_SURFACE_LAYER && newPos.z >= MAP_INIT_SURFACE_LAYER + 1)
			{
				RemoveTileThing(msg, oldPos, oldStackPos);
			}
			else
			{
				msg.addByte(__FUNCTION__, 0x6D);
				msg.addPosition(__FUNCTION__, oldPos);
				msg.addByte(__FUNCTION__, static_cast<uint8_t>(oldStackPos));
				msg.addPosition(__FUNCTION__, newPos);
			}

			if (newPos.z > oldPos.z)
			{
				MoveDownCreature(msg, creature, newPos, oldPos);
			}
			else if (newPos.z < oldPos.z)
			{
				MoveUpCreature(msg, creature, newPos, oldPos);
			}

			if (oldPos.y > newPos.y)
			{ // north, for old x
				msg.addByte(__FUNCTION__, 0x65);
				GetMapDescription(oldPos.x - Map::maxClientViewportX, newPos.y - Map::maxClientViewportY, newPos.z, (Map::maxClientViewportX + 1) * 2, 1, msg);
			}
			else if (oldPos.y < newPos.y)
			{ // south, for old x
				msg.addByte(__FUNCTION__, 0x67);
				GetMapDescription(oldPos.x - Map::maxClientViewportX, newPos.y + (Map::maxClientViewportY + 1), newPos.z, (Map::maxClientViewportX + 1) * 2, 1, msg);
			}

			if (oldPos.x < newPos.x)
			{ // east, [with new y]
				msg.addByte(__FUNCTION__, 0x66);
				GetMapDescription(newPos.x + (Map::maxClientViewportX + 1), newPos.y - Map::maxClientViewportY, newPos.z, 1, (Map::maxClientViewportY + 1) * 2, msg);
			}
			else if (oldPos.x > newPos.x)
			{ // west, [with new y]
				msg.addByte(__FUNCTION__, 0x68);
				GetMapDescription(newPos.x - Map::maxClientViewportX, newPos.y - Map::maxClientViewportY, newPos.z, 1, (Map::maxClientViewportY + 1) * 2, msg);
			}
			writeToOutputBuffer(msg);
		}
	}
	else if (canSee(oldPos) && canSee(newPos))
	{
		if (teleport || (oldPos.z == MAP_INIT_SURFACE_LAYER && newPos.z >= MAP_INIT_SURFACE_LAYER + 1) || oldStackPos >= 10)
		{
			sendRemoveTileThing(oldPos, oldStackPos);
			sendAddCreature(creature, newPos, newStackPos, false);
		}
		else
		{
			NetworkMessage msg;
			msg.addByte(__FUNCTION__, 0x6D);
			msg.addPosition(__FUNCTION__, oldPos);
			msg.addByte(__FUNCTION__, static_cast<uint8_t>(oldStackPos));
			msg.addPosition(__FUNCTION__, newPos);
			writeToOutputBuffer(msg);
		}
	}
	else if (canSee(oldPos))
	{
		sendRemoveTileThing(oldPos, oldStackPos);
	}
	else if (canSee(newPos))
	{
		sendAddCreature(creature, newPos, newStackPos, false);
	}
}

void ProtocolGame::sendInventoryItem(Slots_t slot, const Item *item)
{
	NetworkMessage msg;
	if (item)
	{
		msg.addByte(__FUNCTION__, 0x78);
		msg.addByte(__FUNCTION__, slot);
		AddItem(msg, item);
	}
	else
	{
		msg.addByte(__FUNCTION__, 0x79);
		msg.addByte(__FUNCTION__, slot);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendInventoryIds()
{
	ItemsTierCountList items = player->getInventoryItemsId();

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xF5);
	auto countPosition = msg.getBufferPosition();
	msg.skipBytes(2); // Total items count

	for (uint16_t i = 1; i <= 11; i++)
	{
		msg.addU16(__FUNCTION__, i);
		msg.addByte(__FUNCTION__, 0x00);
		msg.addU16(__FUNCTION__, 0x01);
	}

	uint16_t totalItemsCount = 0;
	for (const auto &[itemId, item] : items) {
		for (const auto [tier, count] : item) {
			msg.addU16(__FUNCTION__, itemId);
			msg.addByte(__FUNCTION__, tier);
			msg.addU16(__FUNCTION__, static_cast<uint16_t>(count));
			totalItemsCount++;
		}
	}

	msg.setBufferPosition(countPosition);
	msg.addU16(__FUNCTION__, totalItemsCount + 11);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddContainerItem(uint8_t cid, uint16_t slot, const Item *item)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x70);
	msg.addByte(__FUNCTION__, cid);
	msg.addU16(__FUNCTION__, slot);
	AddItem(msg, item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateContainerItem(uint8_t cid, uint16_t slot, const Item *item)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x71);
	msg.addByte(__FUNCTION__, cid);
	msg.addU16(__FUNCTION__, slot);
	AddItem(msg, item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendRemoveContainerItem(uint8_t cid, uint16_t slot, const Item *lastItem)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x72);
	msg.addByte(__FUNCTION__, cid);
	msg.addU16(__FUNCTION__, slot);
	if (lastItem)
	{
		AddItem(msg, lastItem);
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTextWindow(uint32_t windowTextId, Item *item, uint16_t maxlen, bool canWrite)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x96);
	msg.addU32(__FUNCTION__, windowTextId);
	AddItem(msg, item);

	if (canWrite)
	{
		msg.addU16(__FUNCTION__, maxlen);
		msg.addString(__FUNCTION__, item->getText());
	}
	else
	{
		const std::string &text = item->getText();
		msg.addU16(__FUNCTION__, static_cast<uint16_t>(text.size()));
		msg.addString(__FUNCTION__, text);
	}

	const std::string &writer = item->getWriter();
	if (!writer.empty())
	{
		msg.addString(__FUNCTION__, writer);
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	msg.addByte(__FUNCTION__, 0x00); // Show (Traded)

	time_t writtenDate = item->getDate();
	if (writtenDate != 0)
	{
		msg.addString(__FUNCTION__, formatDateShort(writtenDate));
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x00);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendHouseWindow(uint32_t windowTextId, const std::string &text)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x97);
	msg.addByte(__FUNCTION__, 0x00);
	msg.addU32(__FUNCTION__, windowTextId);
	msg.addString(__FUNCTION__, text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendOutfitWindow()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xC8);

	bool mounted = false;
	Outfit_t currentOutfit = player->getDefaultOutfit();
	const Mount* currentMount = g_game().mounts.getMountByID(player->getCurrentMount());
	if (currentMount) {
		mounted = (currentOutfit.lookMount == currentMount->clientId);
		currentOutfit.lookMount = currentMount->clientId;
	}

	AddOutfit(msg, currentOutfit);

	msg.addByte(__FUNCTION__, currentOutfit.lookMountHead);
	msg.addByte(__FUNCTION__, currentOutfit.lookMountBody);
	msg.addByte(__FUNCTION__, currentOutfit.lookMountLegs);
	msg.addByte(__FUNCTION__, currentOutfit.lookMountFeet);
	msg.addU16(__FUNCTION__, currentOutfit.lookFamiliarsType);

	auto startOutfits = msg.getBufferPosition();
	uint16_t limitOutfits = std::numeric_limits<uint16_t>::max();
	uint16_t outfitSize = 0;
	msg.skipBytes(2);

	if (player->isAccessPlayer()) {
		msg.addU16(__FUNCTION__, 75);
		msg.addString(__FUNCTION__, "Gamemaster");
		msg.addByte(__FUNCTION__, 0);
		msg.addByte(__FUNCTION__, 0x00);
		++outfitSize;

		msg.addU16(__FUNCTION__, 266);
		msg.addString(__FUNCTION__, "Customer Support");
		msg.addByte(__FUNCTION__, 0);
		msg.addByte(__FUNCTION__, 0x00);
		++outfitSize;

		msg.addU16(__FUNCTION__, 302);
		msg.addString(__FUNCTION__, "Community Manager");
		msg.addByte(__FUNCTION__, 0);
		msg.addByte(__FUNCTION__, 0x00);
		++outfitSize;
	}

	const auto& outfits = Outfits::getInstance().getOutfits(player->getSex());

	for (const Outfit& outfit : outfits) {
		uint8_t addons;
		if (!player->getOutfitAddons(outfit, addons)) {
			continue;
		}

		msg.addU16(__FUNCTION__, outfit.lookType);
		msg.addString(__FUNCTION__, outfit.name);
		msg.addByte(__FUNCTION__, addons);
		msg.addByte(__FUNCTION__, 0x00);
		if (++outfitSize == limitOutfits) {
			break;
		}
	}

	auto endOutfits = msg.getBufferPosition();
	msg.setBufferPosition(startOutfits);
	msg.addU16(__FUNCTION__, outfitSize);
	msg.setBufferPosition(endOutfits);

	auto startMounts = msg.getBufferPosition();
	uint16_t limitMounts = std::numeric_limits<uint16_t>::max();
	uint16_t mountSize = 0;
	msg.skipBytes(2);

	const auto& mounts = g_game().mounts.getMounts();
	for (const Mount& mount : mounts) {
		if (player->hasMount(&mount)) {
			msg.addU16(__FUNCTION__, mount.clientId);
			msg.addString(__FUNCTION__, mount.name);
			msg.addByte(__FUNCTION__, 0x00);
			if (++mountSize == limitMounts) {
				break;
			}
		}
	}

	auto endMounts = msg.getBufferPosition();
	msg.setBufferPosition(startMounts);
	msg.addU16(__FUNCTION__, mountSize);
	msg.setBufferPosition(endMounts);

	auto startFamiliars = msg.getBufferPosition();
	uint16_t limitFamiliars = std::numeric_limits<uint16_t>::max();
	uint16_t familiarSize = 0;
	msg.skipBytes(2);

	const auto& familiars = Familiars::getInstance().getFamiliars(player->getVocationId());

	for (const Familiar& familiar : familiars) {
		if (!player->getFamiliar(familiar)) {
			continue;
		}

		msg.addU16(__FUNCTION__, familiar.lookType);
		msg.addString(__FUNCTION__, familiar.name);
		msg.addByte(__FUNCTION__, 0x00);
		if (++familiarSize == limitFamiliars) {
				break;
		}
	}

	auto endFamiliars = msg.getBufferPosition();
	msg.setBufferPosition(startFamiliars);
	msg.addU16(__FUNCTION__, familiarSize);
	msg.setBufferPosition(endFamiliars);

	msg.addByte(__FUNCTION__, 0x00); //Try outfit
	msg.addByte(__FUNCTION__, mounted ? 0x01 : 0x00);

	// Version 12.81 - Random outfit 'bool'
	msg.addByte(__FUNCTION__, 0);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPodiumWindow(const Item* podium, const Position& position, uint16_t itemId, uint8_t stackpos)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xC8);

	const ItemAttributes::CustomAttribute* podiumVisible = podium->getCustomAttribute("PodiumVisible");
	const ItemAttributes::CustomAttribute* lookType = podium->getCustomAttribute("LookType");
	const ItemAttributes::CustomAttribute* lookMount = podium->getCustomAttribute("LookMount");
	const ItemAttributes::CustomAttribute* lookDirection = podium->getCustomAttribute("LookDirection");

	bool outfited = false;
	bool mounted = false;

	if (lookType) {
		uint16_t look = static_cast<uint16_t>(boost::get<int64_t>(lookType->value));
		outfited = (look != 0);
		msg.addU16(__FUNCTION__, look);

		if (outfited) {
			const ItemAttributes::CustomAttribute* lookHead = podium->getCustomAttribute("LookHead");
			const ItemAttributes::CustomAttribute* lookBody = podium->getCustomAttribute("LookBody");
			const ItemAttributes::CustomAttribute* lookLegs = podium->getCustomAttribute("LookLegs");
			const ItemAttributes::CustomAttribute* lookFeet = podium->getCustomAttribute("LookFeet");

			msg.addByte(__FUNCTION__, lookHead ? static_cast<uint8_t>(boost::get<int64_t>(lookHead->value)) : 0);
			msg.addByte(__FUNCTION__, lookBody ? static_cast<uint8_t>(boost::get<int64_t>(lookBody->value)) : 0);
			msg.addByte(__FUNCTION__, lookLegs ? static_cast<uint8_t>(boost::get<int64_t>(lookLegs->value)) : 0);
			msg.addByte(__FUNCTION__, lookFeet ? static_cast<uint8_t>(boost::get<int64_t>(lookFeet->value)) : 0);

			const ItemAttributes::CustomAttribute* lookAddons = podium->getCustomAttribute("LookAddons");
			msg.addByte(__FUNCTION__, lookAddons ? static_cast<uint8_t>(boost::get<int64_t>(lookAddons->value)) : 0);
		}
	} else {
		msg.addU16(__FUNCTION__, 0);
	}

	if (lookMount) {
		uint16_t look = static_cast<uint16_t>(boost::get<int64_t>(lookMount->value));
		mounted = (look != 0);
		msg.addU16(__FUNCTION__, look);

		if (mounted) {
			const ItemAttributes::CustomAttribute* lookHead = podium->getCustomAttribute("LookMountHead");
			const ItemAttributes::CustomAttribute* lookBody = podium->getCustomAttribute("LookMountBody");
			const ItemAttributes::CustomAttribute* lookLegs = podium->getCustomAttribute("LookMountLegs");
			const ItemAttributes::CustomAttribute* lookFeet = podium->getCustomAttribute("LookMountFeet");

			msg.addByte(__FUNCTION__, lookHead ? static_cast<uint8_t>(boost::get<int64_t>(lookHead->value)) : 0);
			msg.addByte(__FUNCTION__, lookBody ? static_cast<uint8_t>(boost::get<int64_t>(lookBody->value)) : 0);
			msg.addByte(__FUNCTION__, lookLegs ? static_cast<uint8_t>(boost::get<int64_t>(lookLegs->value)) : 0);
			msg.addByte(__FUNCTION__, lookFeet ? static_cast<uint8_t>(boost::get<int64_t>(lookFeet->value)) : 0);
		}
	} else {
		msg.addU16(__FUNCTION__, 0);
		msg.addByte(__FUNCTION__, 0);
		msg.addByte(__FUNCTION__, 0);
		msg.addByte(__FUNCTION__, 0);
		msg.addByte(__FUNCTION__, 0);
	}
	msg.addU16(__FUNCTION__, 0);

	auto startOutfits = msg.getBufferPosition();
	uint16_t limitOutfits = std::numeric_limits<uint16_t>::max();
	uint16_t outfitSize = 0;
	msg.skipBytes(2);

	const auto& outfits = Outfits::getInstance().getOutfits(player->getSex());
	for (const Outfit& outfit : outfits) {
		uint8_t addons;
		if (!player->getOutfitAddons(outfit, addons)) {
			continue;
		}

		msg.addU16(__FUNCTION__, outfit.lookType);
		msg.addString(__FUNCTION__, outfit.name);
		msg.addByte(__FUNCTION__, addons);
		msg.addByte(__FUNCTION__, 0x00);
		if (++outfitSize == limitOutfits) {
			break;
		}
	}

	auto endOutfits = msg.getBufferPosition();
	msg.setBufferPosition(startOutfits);
	msg.addU16(__FUNCTION__, outfitSize);
	msg.setBufferPosition(endOutfits);

	auto startMounts = msg.getBufferPosition();
	uint16_t limitMounts = std::numeric_limits<uint16_t>::max();
	uint16_t mountSize = 0;
	msg.skipBytes(2);

	const auto& mounts = g_game().mounts.getMounts();
	for (const Mount& mount : mounts) {
		if (player->hasMount(&mount)) {
			msg.addU16(__FUNCTION__, mount.clientId);
			msg.addString(__FUNCTION__, mount.name);
			msg.addByte(__FUNCTION__, 0x00);
			if (++mountSize == limitMounts) {
				break;
			}
		}
	}

	auto endMounts = msg.getBufferPosition();
	msg.setBufferPosition(startMounts);
	msg.addU16(__FUNCTION__, mountSize);
	msg.setBufferPosition(endMounts);

	msg.addU16(__FUNCTION__, 0);

	msg.addByte(__FUNCTION__, 0x05);
	msg.addByte(__FUNCTION__, mounted ? 0x01 : 0x00);

	msg.addU16(__FUNCTION__, 0);

	msg.addPosition(__FUNCTION__, position);
	msg.addU16(__FUNCTION__, itemId);
	msg.addByte(__FUNCTION__, stackpos);

	msg.addByte(__FUNCTION__, podiumVisible ? static_cast<uint8_t>(boost::get<int64_t>(podiumVisible->value)) : 0x01);
	msg.addByte(__FUNCTION__, outfited ? 0x01 : 0x00);
	msg.addByte(__FUNCTION__, lookDirection ? static_cast<uint8_t>(boost::get<int64_t>(lookDirection->value)) : 2);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdatedVIPStatus(uint32_t guid, VipStatus_t newStatus)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xD3);
	msg.addU32(__FUNCTION__, guid);
	msg.addByte(__FUNCTION__, newStatus);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendVIP(uint32_t guid, const std::string &name, const std::string &description, uint32_t icon, bool notify, VipStatus_t status)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xD2);
	msg.addU32(__FUNCTION__, guid);
	msg.addString(__FUNCTION__, name);
	msg.addString(__FUNCTION__, description);
	msg.addU32(__FUNCTION__, std::min<uint32_t>(10, icon));
	msg.addByte(__FUNCTION__, notify ? 0x01 : 0x00);
	msg.addByte(__FUNCTION__, status);
	msg.addByte(__FUNCTION__, 0x00); // vipGroups
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSpellCooldown(uint8_t spellId, uint32_t time)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xA4);

	msg.addByte(__FUNCTION__, spellId);
	msg.addU32(__FUNCTION__, time);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSpellGroupCooldown(SpellGroup_t groupId, uint32_t time)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xA5);
	msg.addByte(__FUNCTION__, groupId);
	msg.addU32(__FUNCTION__, time);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUseItemCooldown(uint32_t time)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xA6);
	msg.addU32(__FUNCTION__, time);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPreyTimeLeft(const PreySlot* slot)
{
	if (!player || !slot) {
		return;
	}

	NetworkMessage msg;

	msg.addByte(__FUNCTION__, 0xE7);
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(slot->id));
	msg.addU16(__FUNCTION__, slot->bonusTimeLeft);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPreyData(const PreySlot* slot)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xE8);
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(slot->id));
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(slot->state));

	if (slot->state == PreyDataState_Locked) {
		msg.addByte(__FUNCTION__, player->isPremium() ? 0x01 : 0x00);
	} else if (slot->state == PreyDataState_Inactive) {
			// Empty
	} else if (slot->state == PreyDataState_Active) {	
		if (const MonsterType* mtype = g_monsters().getMonsterTypeByRaceId(slot->selectedRaceId)) {
			msg.addString(__FUNCTION__, mtype->name);
			const Outfit_t outfit = mtype->info.outfit;
			msg.addU16(__FUNCTION__, outfit.lookType);
			if (outfit.lookType == 0) {
				msg.addU16(__FUNCTION__, outfit.lookTypeEx);
			} else {
				msg.addByte(__FUNCTION__, outfit.lookHead);
				msg.addByte(__FUNCTION__, outfit.lookBody);
				msg.addByte(__FUNCTION__, outfit.lookLegs);
				msg.addByte(__FUNCTION__, outfit.lookFeet);
				msg.addByte(__FUNCTION__, outfit.lookAddons);
			}

			msg.addByte(__FUNCTION__, static_cast<uint8_t>(slot->bonus));
			msg.addU16(__FUNCTION__, slot->bonusPercentage);
			msg.addByte(__FUNCTION__, slot->bonusRarity);
			msg.addU16(__FUNCTION__, slot->bonusTimeLeft);
		}
	} else if (slot->state == PreyDataState_Selection) {
		msg.addByte(__FUNCTION__, static_cast<uint8_t>(slot->raceIdList.size()));
		std::for_each(slot->raceIdList.begin(), slot->raceIdList.end(), [&msg](uint16_t raceId)
		{
			if (const MonsterType* mtype = g_monsters().getMonsterTypeByRaceId(raceId)) {
				msg.addString(__FUNCTION__, mtype->name);
				const Outfit_t outfit = mtype->info.outfit;
				msg.addU16(__FUNCTION__, outfit.lookType);
				if (outfit.lookType == 0) {
					msg.addU16(__FUNCTION__, outfit.lookTypeEx);
				} else {
					msg.addByte(__FUNCTION__, outfit.lookHead);
					msg.addByte(__FUNCTION__, outfit.lookBody);
					msg.addByte(__FUNCTION__, outfit.lookLegs);
					msg.addByte(__FUNCTION__, outfit.lookFeet);
					msg.addByte(__FUNCTION__, outfit.lookAddons);
				}
			} else {
				SPDLOG_WARN("[ProtocolGame::sendPreyData] - Unknown monster type raceid: {}", raceId);
				return;
			}
		});
	} else if (slot->state == PreyDataState_SelectionChangeMonster) {
		msg.addByte(__FUNCTION__, static_cast<uint8_t>(slot->bonus));
		msg.addU16(__FUNCTION__, slot->bonusPercentage);
		msg.addByte(__FUNCTION__, slot->bonusRarity);
		msg.addByte(__FUNCTION__, static_cast<uint8_t>(slot->raceIdList.size()));
		std::for_each(slot->raceIdList.begin(), slot->raceIdList.end(), [&msg](uint16_t raceId)
		{
			if (const MonsterType* mtype = g_monsters().getMonsterTypeByRaceId(raceId)) {
				msg.addString(__FUNCTION__, mtype->name);
				const Outfit_t outfit = mtype->info.outfit;
				msg.addU16(__FUNCTION__, outfit.lookType);
				if (outfit.lookType == 0) {
					msg.addU16(__FUNCTION__, outfit.lookTypeEx);
				} else {
					msg.addByte(__FUNCTION__, outfit.lookHead);
					msg.addByte(__FUNCTION__, outfit.lookBody);
					msg.addByte(__FUNCTION__, outfit.lookLegs);
					msg.addByte(__FUNCTION__, outfit.lookFeet);
					msg.addByte(__FUNCTION__, outfit.lookAddons);
				}
			} else {
				SPDLOG_WARN("[ProtocolGame::sendPreyData] - Unknown monster type raceid: {}", raceId);
				return;
			}
		});
	} else if (slot->state == PreyDataState_ListSelection) {
		const std::map<uint16_t, std::string> bestiaryList = g_game().getBestiaryList();
		msg.addU16(__FUNCTION__, static_cast<uint16_t>(bestiaryList.size()));
		std::for_each(bestiaryList.begin(), bestiaryList.end(), [&msg](auto& mType)
		{
			msg.addU16(__FUNCTION__, mType.first);
		});
	} else {
		SPDLOG_WARN("[ProtocolGame::sendPreyData] - Unknown prey state: {}", slot->state);
		return;
	}

	msg.addU32(__FUNCTION__, std::max<uint32_t>(static_cast<uint32_t>(((slot->freeRerollTimeStamp - OTSYS_TIME()) / 1000)), 0));
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(slot->option));

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPreyPrices()
{
	if (!player) {
		return;
	}

	NetworkMessage msg;

	msg.addByte(__FUNCTION__, 0xE9);

	msg.addU32(__FUNCTION__, player->getPreyRerollPrice());
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(g_configManager().getNumber(PREY_BONUS_REROLL_PRICE)));
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(g_configManager().getNumber(PREY_SELECTION_LIST_PRICE)));
	msg.addU32(__FUNCTION__, player->getTaskHuntingRerollPrice());
	msg.addU32(__FUNCTION__, player->getTaskHuntingRerollPrice());
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(g_configManager().getNumber(TASK_HUNTING_SELECTION_LIST_PRICE)));
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(g_configManager().getNumber(TASK_HUNTING_BONUS_REROLL_PRICE)));

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendModalWindow(const ModalWindow &modalWindow)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xFA);

	msg.addU32(__FUNCTION__, modalWindow.id);
	msg.addString(__FUNCTION__, modalWindow.title);
	msg.addString(__FUNCTION__, modalWindow.message);

	msg.addByte(__FUNCTION__, static_cast<uint8_t>(modalWindow.buttons.size()));
	for (const auto &it : modalWindow.buttons)
	{
		msg.addString(__FUNCTION__, it.first);
		msg.addByte(__FUNCTION__, it.second);
	}

	msg.addByte(__FUNCTION__, static_cast<uint8_t>(modalWindow.choices.size()));
	for (const auto &it : modalWindow.choices)
	{
		msg.addString(__FUNCTION__, it.first);
		msg.addByte(__FUNCTION__, it.second);
	}

	msg.addByte(__FUNCTION__, modalWindow.defaultEscapeButton);
	msg.addByte(__FUNCTION__, modalWindow.defaultEnterButton);
	msg.addByte(__FUNCTION__, modalWindow.priority ? 0x01 : 0x00);

	writeToOutputBuffer(msg);
}

////////////// Add common messages
void ProtocolGame::AddCreature(NetworkMessage &msg, const Creature *creature, bool known, uint32_t remove)
{
	CreatureType_t creatureType = creature->getType();
	const Player *otherPlayer = creature->getPlayer();

	if (known)
	{
		msg.addU16(__FUNCTION__, 0x62);
		msg.addU32(__FUNCTION__, creature->getID());
	}
	else
	{
		msg.addU16(__FUNCTION__, 0x61);
		msg.addU32(__FUNCTION__, remove);
		msg.addU32(__FUNCTION__, creature->getID());
		if (creature->isHealthHidden())
		{
			msg.addByte(__FUNCTION__, CREATURETYPE_HIDDEN);
		}
		else
		{
			msg.addByte(__FUNCTION__, creatureType);
		}

		if (creatureType == CREATURETYPE_SUMMON_PLAYER)
		{
			const Creature *master = creature->getMaster();
			if (master)
			{
				msg.addU32(__FUNCTION__, master->getID());
			}
			else
			{
				msg.addU32(__FUNCTION__, 0x00);
			}
		}

		if (creature->isHealthHidden())
		{
			msg.addString(__FUNCTION__, "");
		}
		else
		{
			msg.addString(__FUNCTION__, creature->getName());
		}
	}

	if (creature->isHealthHidden())
	{
		msg.addByte(__FUNCTION__, 0x00);
	}
	else
	{
		msg.addByte(__FUNCTION__, static_cast<uint8_t>(std::ceil((static_cast<double>(creature->getHealth()) / std::max<int32_t>(creature->getMaxHealth(), 1)) * 100)));
	}

	msg.addByte(__FUNCTION__, creature->getDirection());

	if (!creature->isInGhostMode() && !creature->isInvisible())
	{
		const Outfit_t &outfit = creature->getCurrentOutfit();
		AddOutfit(msg, outfit);
		if (outfit.lookMount != 0)
		{
			msg.addByte(__FUNCTION__, outfit.lookMountHead);
			msg.addByte(__FUNCTION__, outfit.lookMountBody);
			msg.addByte(__FUNCTION__, outfit.lookMountLegs);
			msg.addByte(__FUNCTION__, outfit.lookMountFeet);
		}
	}
	else
	{
		static Outfit_t outfit;
		AddOutfit(msg, outfit);
	}

	LightInfo lightInfo = creature->getCreatureLight();
	msg.addByte(__FUNCTION__, player->isAccessPlayer() ? 0xFF : lightInfo.level);
	msg.addByte(__FUNCTION__, lightInfo.color);

	msg.addU16(__FUNCTION__, creature->getStepSpeed());

	CreatureIcon_t icon;
	auto sendIcon = false;
	if (otherPlayer) {
		icon = creature->getIcon();
		sendIcon = icon != CREATUREICON_NONE;
		msg.addByte(__FUNCTION__, sendIcon); // Icons
		if (sendIcon) {
			msg.addByte(__FUNCTION__, icon);
			msg.addByte(__FUNCTION__, 1);
			msg.addU16(__FUNCTION__, 0);
		}
	} else {
		if (auto monster = creature->getMonster();
			monster)
		{
			icon = monster->getIcon();
			sendIcon = icon != CREATUREICON_NONE;
			msg.addByte(__FUNCTION__, sendIcon); // Send Icons true/false
			if (sendIcon) {
				// Icones with stack (Fiendishs e Influenceds)
				if (monster->getForgeStack() > 0) {
					msg.addByte(__FUNCTION__, icon);
					msg.addByte(__FUNCTION__, 1);
					msg.addU16(__FUNCTION__, icon != 5 ? monster->getForgeStack() : 0); // Stack
				} else {
					// Icons without number on the side
					msg.addByte(__FUNCTION__, icon);
					msg.addByte(__FUNCTION__, 1);
					msg.addU16(__FUNCTION__, 0);
				}
			}
		} else {
			icon = creature->getIcon();
			sendIcon = icon != CREATUREICON_NONE;
			msg.addByte(__FUNCTION__, sendIcon); // Send Icons true/false
			if (sendIcon) {
				msg.addByte(__FUNCTION__, icon);
				msg.addByte(__FUNCTION__, 1);
				msg.addU16(__FUNCTION__, 0);
			}
		}
	}

	msg.addByte(__FUNCTION__, player->getSkullClient(creature));
	msg.addByte(__FUNCTION__, player->getPartyShield(otherPlayer));

	if (!known)
	{
		msg.addByte(__FUNCTION__, player->getGuildEmblem(otherPlayer));
	}

	if (creatureType == CREATURETYPE_MONSTER)
	{
		const Creature *master = creature->getMaster();
		if (master)
		{
			const Player *masterPlayer = master->getPlayer();
			if (masterPlayer)
			{
				creatureType = CREATURETYPE_SUMMON_PLAYER;
			}
		}
	}

	if (creature->isHealthHidden())
	{
		msg.addByte(__FUNCTION__, CREATURETYPE_HIDDEN);
	}
	else
	{
		msg.addByte(__FUNCTION__, creatureType); // Type (for summons)
	}

	if (creatureType == CREATURETYPE_SUMMON_PLAYER)
	{
		const Creature *master = creature->getMaster();
		if (master)
		{
			msg.addU32(__FUNCTION__, master->getID());
		}
		else
		{
			msg.addU32(__FUNCTION__, 0x00);
		}
	}

	if (creatureType == CREATURETYPE_PLAYER)
	{
		const Player *otherCreature = creature->getPlayer();
		if (otherCreature)
		{
			msg.addByte(__FUNCTION__, otherCreature->getVocation()->getClientId());
		}
		else
		{
			msg.addByte(__FUNCTION__, 0);
		}
	}

	msg.addByte(__FUNCTION__, creature->getSpeechBubble());
	msg.addByte(__FUNCTION__, 0xFF); // MARK_UNMARKED
	msg.addByte(__FUNCTION__, 0x00); // inspection type
	msg.addByte(__FUNCTION__, player->canWalkthroughEx(creature) ? 0x00 : 0x01);
}

void ProtocolGame::AddPlayerStats(NetworkMessage &msg)
{
	msg.addByte(__FUNCTION__, 0xA0);

	msg.addU16(__FUNCTION__, std::min<uint16_t>(static_cast<uint16_t>(player->getHealth()), std::numeric_limits<uint16_t>::max()));
	msg.addU16(__FUNCTION__, std::min<uint16_t>(static_cast<uint16_t>(player->getMaxHealth()), std::numeric_limits<uint16_t>::max()));

	msg.addU32(__FUNCTION__, player->hasFlag(PlayerFlag_HasInfiniteCapacity) ? 1000000 : player->getFreeCapacity());

	msg.addU64(__FUNCTION__, player->getExperience());

	msg.addU16(__FUNCTION__, static_cast<uint16_t>(player->getLevel()));
	msg.addByte(__FUNCTION__, player->getLevelPercent());

	msg.addU16(__FUNCTION__, player->getBaseXpGain()); // base xp gain rate
	msg.addU16(__FUNCTION__, player->getGrindingXpBoost()); // low level bonus
	msg.addU16(__FUNCTION__, player->getStoreXpBoost()); // xp boost
	msg.addU16(__FUNCTION__, player->getStaminaXpBoost()); // stamina multiplier (100 = 1.0x)

	msg.addU16(__FUNCTION__, std::min<uint16_t>(static_cast<uint16_t>(player->getMana()), std::numeric_limits<uint16_t>::max()));
	msg.addU16(__FUNCTION__, std::min<uint16_t>(static_cast<uint16_t>(player->getMaxMana()), std::numeric_limits<uint16_t>::max()));

	msg.addByte(__FUNCTION__, player->getSoul());

	msg.addU16(__FUNCTION__, player->getStaminaMinutes());

	msg.addU16(__FUNCTION__, player->getBaseSpeed());

	Condition *condition = player->getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT);
	msg.addU16(__FUNCTION__, condition ? static_cast<uint16_t>(condition->getTicks() / 1000) : 0x00);

	msg.addU16(__FUNCTION__, static_cast<uint16_t>(player->getOfflineTrainingTime() / 60 / 1000));

	msg.addU16(__FUNCTION__, player->getExpBoostStamina()); // xp boost time (seconds)
	msg.addByte(__FUNCTION__, 1); // enables exp boost in the store

	msg.addU16(__FUNCTION__, player->getManaShield());  // remaining mana shield
	msg.addU16(__FUNCTION__, player->getMaxManaShield());  // total mana shield
}

void ProtocolGame::AddPlayerSkills(NetworkMessage &msg)
{
	msg.addByte(__FUNCTION__, 0xA1);

	msg.addU16(__FUNCTION__, static_cast<uint16_t>(player->getMagicLevel()));
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(player->getBaseMagicLevel()));
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(player->getBaseMagicLevel()));
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(player->getMagicLevelPercent() * 100));

	for (uint8_t i = SKILL_FIRST; i <= SKILL_FISHING; ++i)
	{
		msg.addU16(__FUNCTION__, std::min<uint16_t>(player->getSkillLevel(i), std::numeric_limits<uint16_t>::max()));
		msg.addU16(__FUNCTION__, player->getBaseSkill(i));
		msg.addU16(__FUNCTION__, player->getBaseSkill(i));
		msg.addU16(__FUNCTION__, static_cast<uint16_t>(player->getSkillPercent(i) * 100));
	}

	for (uint8_t i = SKILL_CRITICAL_HIT_CHANCE; i <= SKILL_LAST; ++i)
	{
		msg.addU16(__FUNCTION__, std::min<uint16_t>(player->getSkillLevel(i), std::numeric_limits<uint16_t>::max()));
		msg.addU16(__FUNCTION__, player->getBaseSkill(i));
	}

	// Version 12.81 new skill (Fatal, Dodge and Momentum)
	sendForgeSkillStats(msg);

	// used for imbuement (Feather)
	msg.addU32(__FUNCTION__, player->getCapacity()); // total capacity
	msg.addU32(__FUNCTION__, player->getBaseCapacity()); // base total capacity

}

void ProtocolGame::AddOutfit(NetworkMessage &msg, const Outfit_t &outfit, bool addMount /* = true*/)
{
	msg.addU16(__FUNCTION__, outfit.lookType);
	if (outfit.lookType != 0)
	{
		msg.addByte(__FUNCTION__, outfit.lookHead);
		msg.addByte(__FUNCTION__, outfit.lookBody);
		msg.addByte(__FUNCTION__, outfit.lookLegs);
		msg.addByte(__FUNCTION__, outfit.lookFeet);
		msg.addByte(__FUNCTION__, outfit.lookAddons);
	}
	else
	{
		msg.addU16(__FUNCTION__, outfit.lookTypeEx);
	}

	if (addMount)
	{
		msg.addU16(__FUNCTION__, outfit.lookMount);
	}
}

void ProtocolGame::addImbuementInfo(NetworkMessage &msg, uint16_t imbuementId) const
{
	Imbuement *imbuement = g_imbuements().getImbuement(imbuementId);
	const BaseImbuement *baseImbuement = g_imbuements().getBaseByID(imbuement->getBaseID());
	const CategoryImbuement *categoryImbuement = g_imbuements().getCategoryByID(imbuement->getCategory());

	msg.addU32(__FUNCTION__, imbuementId);
	msg.addString(__FUNCTION__, baseImbuement->name + " " + imbuement->getName());
	msg.addString(__FUNCTION__, imbuement->getDescription());
	msg.addString(__FUNCTION__, categoryImbuement->name + imbuement->getSubGroup());

	msg.addU16(__FUNCTION__, imbuement->getIconID());
	msg.addU32(__FUNCTION__, baseImbuement->duration);

	msg.addByte(__FUNCTION__, imbuement->isPremium() ? 0x01 : 0x00);

	const auto &items = imbuement->getItems();
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(items.size()));

	for (const auto &itm : items)
	{
		const ItemType &it = Item::items[itm.first];
		msg.addU16(__FUNCTION__, itm.first);
		msg.addString(__FUNCTION__, it.name);
		msg.addU16(__FUNCTION__, itm.second);
	}

	msg.addU32(__FUNCTION__, baseImbuement->price);
	msg.addByte(__FUNCTION__, baseImbuement->percent);
	msg.addU32(__FUNCTION__, baseImbuement->protectionPrice);
}

void ProtocolGame::openImbuementWindow(Item *item)
{
	if (!item || item->isRemoved())
	{
		return;
	}

	player->setImbuingItem(item);

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xEB);
	msg.addU16(__FUNCTION__, item->getID());
	if (item->getClassification() > 0) {
		msg.addByte(__FUNCTION__, item->getTier());
	}
	msg.addByte(__FUNCTION__, item->getImbuementSlot());

	// Send imbuement time
	for (uint8_t slotid = 0; slotid < static_cast<uint8_t>(item->getImbuementSlot()); slotid++)
	{
		ImbuementInfo imbuementInfo;
		if (!item->getImbuementInfo(slotid, &imbuementInfo))
		{
			msg.addByte(__FUNCTION__, 0x00);
			continue;
		}

		msg.addByte(__FUNCTION__, 0x01);
		addImbuementInfo(msg, imbuementInfo.imbuement->getID());
		msg.addU32(__FUNCTION__, imbuementInfo.duration);
		msg.addU32(__FUNCTION__, g_imbuements().getBaseByID(imbuementInfo.imbuement->getBaseID())->removeCost);
	}

	std::vector<Imbuement *> imbuements = g_imbuements().getImbuements(player, item);
	phmap::flat_hash_map<uint16_t, uint16_t> needItems;

	msg.addU16(__FUNCTION__, static_cast<uint16_t>(imbuements.size()));
	for (const Imbuement *imbuement : imbuements)
	{
		addImbuementInfo(msg, imbuement->getID());

		const auto &items = imbuement->getItems();
		for (const auto &itm : items)
		{
			if (!needItems.count(itm.first))
			{
				needItems[itm.first] = player->getItemTypeCount(itm.first);
				uint32_t stashCount = player->getStashItemCount(Item::items[itm.first].id);
				if (stashCount > 0) {
					needItems[itm.first] += stashCount;
				}
			}
		}
	}

	msg.addU32(__FUNCTION__, static_cast<uint16_t>(needItems.size()));
	for (const auto &itm : needItems)
	{
		msg.addU16(__FUNCTION__, itm.first);
		msg.addU16(__FUNCTION__, itm.second);
	}

	sendResourcesBalance(player->getMoney(), player->getBankBalance(), player->getPreyCards(), player->getTaskHuntingPoints());

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMessageDialog(const std::string &message)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xED);
	msg.addByte(__FUNCTION__, 0x14); // Unknown type
	msg.addString(__FUNCTION__, message);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendImbuementResult(const std::string message)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xED);
	msg.addByte(__FUNCTION__, 0x01);
	msg.addString(__FUNCTION__, message);
	writeToOutputBuffer(msg);
}

void ProtocolGame::closeImbuementWindow()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xEC);
	writeToOutputBuffer(msg);
}

void ProtocolGame::AddWorldLight(NetworkMessage &msg, LightInfo lightInfo)
{
	msg.addByte(__FUNCTION__, 0x82);
	msg.addByte(__FUNCTION__, (player->isAccessPlayer() ? 0xFF : lightInfo.level));
	msg.addByte(__FUNCTION__, lightInfo.color);
}

void ProtocolGame::sendSpecialContainersAvailable()
{
	if (!player)
		return;

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x2A);
	msg.addByte(__FUNCTION__, player->isSupplyStashMenuAvailable() ? 0x01 : 0x00);
	msg.addByte(__FUNCTION__, player->isMarketMenuAvailable() ? 0x01 : 0x00);
	writeToOutputBuffer(msg);
}

void ProtocolGame::updatePartyTrackerAnalyzer(const Party* party)
{
	if (!player || !party || !party->getLeader())
		return;

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x2B);
	msg.addU32(__FUNCTION__, party->getAnalyzerTimeNow());
	msg.addU32(__FUNCTION__, party->getLeader()->getID());
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(party->priceType));

	msg.addByte(__FUNCTION__, static_cast<uint8_t>(party->membersData.size()));
	for (const PartyAnalyzer* analyzer : party->membersData) {
		msg.addU32(__FUNCTION__, analyzer->id);
		if (const Player* member = g_game().getPlayerByID(analyzer->id);
			!member || !member->getParty() || member->getParty() != party) {
			msg.addByte(__FUNCTION__, 0);
		} else {
			msg.addByte(__FUNCTION__, 1);
		}

		msg.addU64(__FUNCTION__, analyzer->lootPrice);
		msg.addU64(__FUNCTION__, analyzer->supplyPrice);
		msg.addU64(__FUNCTION__, analyzer->damage);
		msg.addU64(__FUNCTION__, analyzer->healing);
	}

	bool showNames = !party->membersData.empty();
	msg.addByte(__FUNCTION__, showNames ? 0x01 : 0x00);
	if (showNames) {
		msg.addByte(__FUNCTION__, static_cast<uint8_t>(party->membersData.size()));
		for (const PartyAnalyzer* analyzer : party->membersData) {
			msg.addU32(__FUNCTION__, analyzer->id);
			msg.addString(__FUNCTION__, analyzer->name);
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::AddCreatureLight(NetworkMessage &msg, const Creature *creature)
{
	LightInfo lightInfo = creature->getCreatureLight();

	msg.addByte(__FUNCTION__, 0x8D);
	msg.addU32(__FUNCTION__, creature->getID());
	msg.addByte(__FUNCTION__, (player->isAccessPlayer() ? 0xFF : lightInfo.level));
	msg.addByte(__FUNCTION__, lightInfo.color);
}

//tile
void ProtocolGame::RemoveTileThing(NetworkMessage &msg, const Position &pos, uint32_t stackpos)
{
	if (stackpos >= 10)
	{
		return;
	}

	msg.addByte(__FUNCTION__, 0x6C);
	msg.addPosition(__FUNCTION__, pos);
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(stackpos));
}

void ProtocolGame::sendKillTrackerUpdate(Container *corpse, const std::string &name, const Outfit_t creatureOutfit)
{
	bool isCorpseEmpty = corpse->empty();

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xD1);
	msg.addString(__FUNCTION__, name);
	msg.addU16(__FUNCTION__, creatureOutfit.lookType ? creatureOutfit.lookType : 21);
	msg.addByte(__FUNCTION__, creatureOutfit.lookType ? creatureOutfit.lookHead : 0x00);
	msg.addByte(__FUNCTION__, creatureOutfit.lookType ? creatureOutfit.lookBody : 0x00);
	msg.addByte(__FUNCTION__, creatureOutfit.lookType ? creatureOutfit.lookLegs : 0x00);
	msg.addByte(__FUNCTION__, creatureOutfit.lookType ? creatureOutfit.lookFeet : 0x00);
	msg.addByte(__FUNCTION__, creatureOutfit.lookType ? creatureOutfit.lookAddons : 0x00);
	msg.addByte(__FUNCTION__, isCorpseEmpty ? 0 : static_cast<uint8_t>(corpse->size()));

	if (!isCorpseEmpty)
	{
		for (const auto &it : corpse->getItemList())
		{
			AddItem(msg, it);
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateSupplyTracker(const Item *item)
{
	if (!player || !item)
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xCE);
	msg.addU16(__FUNCTION__, item->getID());

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateImpactTracker(CombatType_t type, int32_t amount)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xCC);
	if (type == COMBAT_HEALING)
	{
		msg.addByte(__FUNCTION__, ANALYZER_HEAL);
		msg.addU32(__FUNCTION__, amount);
	}
	else
	{
		msg.addByte(__FUNCTION__, ANALYZER_DAMAGE_DEALT);
		msg.addU32(__FUNCTION__, amount);
		msg.addByte(__FUNCTION__, getCipbiaElement(type));
	}
	writeToOutputBuffer(msg);
}
void ProtocolGame::sendUpdateInputAnalyzer(CombatType_t type, int32_t amount, std::string target)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xCC);
	msg.addByte(__FUNCTION__, ANALYZER_DAMAGE_RECEIVED);
	msg.addU32(__FUNCTION__, amount);
	msg.addByte(__FUNCTION__, getCipbiaElement(type));
	msg.addString(__FUNCTION__, target);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTaskHuntingData(const TaskHuntingSlot* slot)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xBB);
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(slot->id));
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(slot->state));
	if (slot->state == PreyTaskDataState_Locked) {
		msg.addByte(__FUNCTION__, player->isPremium() ? 0x01 : 0x00);
	} else if (slot->state == PreyTaskDataState_Inactive) {
		// Empty
	} else if (slot->state == PreyTaskDataState_Selection) {
		const Player* user = player;
		msg.addU16(__FUNCTION__, static_cast<uint16_t>(slot->raceIdList.size()));
		std::for_each(slot->raceIdList.begin(), slot->raceIdList.end(), [&msg, user](uint16_t raceid)
		{
			msg.addU16(__FUNCTION__, raceid);
			msg.addByte(__FUNCTION__, user->isCreatureUnlockedOnTaskHunting(g_monsters().getMonsterTypeByRaceId(raceid)) ? 0x01 : 0x00);
		});
	} else if (slot->state == PreyTaskDataState_ListSelection) {
		const Player* user = player;
		const std::map<uint16_t, std::string> bestiaryList = g_game().getBestiaryList();
		msg.addU16(__FUNCTION__, static_cast<uint16_t>(bestiaryList.size()));
		std::for_each(bestiaryList.begin(), bestiaryList.end(), [&msg, user](auto& mType)
		{
			msg.addU16(__FUNCTION__, mType.first);
			msg.addByte(__FUNCTION__, user->isCreatureUnlockedOnTaskHunting(g_monsters().getMonsterType(mType.second)) ? 0x01 : 0x00);
		});
	} else if (slot->state == PreyTaskDataState_Active) {
		if (const TaskHuntingOption* option = g_ioprey().GetTaskRewardOption(slot)) {
			msg.addU16(__FUNCTION__, slot->selectedRaceId);
			if (slot->upgrade) {
				msg.addByte(__FUNCTION__, 0x01);
				msg.addU16(__FUNCTION__, option->secondKills);
			} else {
				msg.addByte(__FUNCTION__, 0x00);
				msg.addU16(__FUNCTION__, option->firstKills);
			}
			msg.addU16(__FUNCTION__, slot->currentKills);
			msg.addByte(__FUNCTION__, slot->rarity);
		} else {
			SPDLOG_WARN("[ProtocolGame::sendTaskHuntingData] - Unknown slot option {} on player {}", slot->id, player->getName());
			return;
		}
	} else if (slot->state == PreyTaskDataState_Completed) {
		if (const TaskHuntingOption* option = g_ioprey().GetTaskRewardOption(slot)) {
			msg.addU16(__FUNCTION__, slot->selectedRaceId);
			if (slot->upgrade) {
				msg.addByte(__FUNCTION__, 0x01);
				msg.addU16(__FUNCTION__, option->secondKills);
				msg.addU16(__FUNCTION__, std::min<uint16_t>(slot->currentKills, option->secondKills));
			} else {
				msg.addByte(__FUNCTION__, 0x00);
				msg.addU16(__FUNCTION__, option->firstKills);
				msg.addU16(__FUNCTION__, std::min<uint16_t>(slot->currentKills, option->firstKills));
			}
			msg.addByte(__FUNCTION__, slot->rarity);
		} else {
			SPDLOG_WARN("[ProtocolGame::sendTaskHuntingData] - Unknown slot option {} on player {}", slot->id, player->getName());
			return;
		}
	} else {
		SPDLOG_WARN("[ProtocolGame::sendTaskHuntingData] - Unknown task hunting state: {}", slot->state);
		return;
	}

	msg.addU32(__FUNCTION__, std::max<uint32_t>(static_cast<uint32_t>(((slot->freeRerollTimeStamp - OTSYS_TIME()) / 1000)), 0));
	writeToOutputBuffer(msg);
}

void ProtocolGame::MoveUpCreature(NetworkMessage &msg, const Creature *creature, const Position &newPos, const Position &oldPos)
{
	if (creature != player)
	{
		return;
	}

	//floor change up
	msg.addByte(__FUNCTION__, 0xBE);

	//going to surface
	if (newPos.z == MAP_INIT_SURFACE_LAYER)
	{
		int32_t skip = -1;
		GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, 5, (Map::maxClientViewportX + 1) * 2, (Map::maxClientViewportY + 1) * 2, 3, skip); //(floor 7 and 6 already set)
		GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, 4, (Map::maxClientViewportX + 1) * 2, (Map::maxClientViewportY + 1) * 2, 4, skip);
		GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, 3, (Map::maxClientViewportX + 1) * 2, (Map::maxClientViewportY + 1) * 2, 5, skip);
		GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, 2, (Map::maxClientViewportX + 1) * 2, (Map::maxClientViewportY + 1) * 2, 6, skip);
		GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, 1, (Map::maxClientViewportX + 1) * 2, (Map::maxClientViewportY + 1) * 2, 7, skip);
		GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, 0, (Map::maxClientViewportX + 1) * 2, (Map::maxClientViewportY + 1) * 2, 8, skip);

		if (skip >= 0)
		{
			msg.addByte(__FUNCTION__, static_cast<uint8_t>(skip));
			msg.addByte(__FUNCTION__, 0xFF);
		}
	}
	//underground, going one floor up (still underground)
	else if (newPos.z > MAP_INIT_SURFACE_LAYER)
	{
		int32_t skip = -1;
		GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, oldPos.getZ() - 3, (Map::maxClientViewportX + 1) * 2, (Map::maxClientViewportY + 1) * 2, 3, skip);

		if (skip >= 0)
		{
			msg.addByte(__FUNCTION__, static_cast<uint8_t>(skip));
			msg.addByte(__FUNCTION__, 0xFF);
		}
	}

	//moving up a floor up makes us out of sync
	//west
	msg.addByte(__FUNCTION__, 0x68);
	GetMapDescription(oldPos.x - Map::maxClientViewportX, oldPos.y - (Map::maxClientViewportY - 1), newPos.z, 1, (Map::maxClientViewportY + 1) * 2, msg);

	//north
	msg.addByte(__FUNCTION__, 0x65);
	GetMapDescription(oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, newPos.z, (Map::maxClientViewportX + 1) * 2, 1, msg);
}

void ProtocolGame::MoveDownCreature(NetworkMessage &msg, const Creature *creature, const Position &newPos, const Position &oldPos)
{
	if (creature != player)
	{
		return;
	}

	//floor change down
	msg.addByte(__FUNCTION__, 0xBF);

	//going from surface to underground
	if (newPos.z == MAP_INIT_SURFACE_LAYER + 1)
	{
		int32_t skip = -1;

		GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, newPos.z, (Map::maxClientViewportX + 1) * 2, (Map::maxClientViewportY + 1) * 2, -1, skip);
		GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, newPos.z + 1, (Map::maxClientViewportX + 1) * 2, (Map::maxClientViewportY + 1) * 2, -2, skip);
		GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, newPos.z + 2, (Map::maxClientViewportX + 1) * 2, (Map::maxClientViewportY + 1) * 2, -3, skip);

		if (skip >= 0)
		{
			msg.addByte(__FUNCTION__, static_cast<uint8_t>(skip));
			msg.addByte(__FUNCTION__, 0xFF);
		}
	}
	//going further down
	else if (newPos.z > oldPos.z && newPos.z > MAP_INIT_SURFACE_LAYER + 1 && newPos.z < MAP_MAX_LAYERS - MAP_LAYER_VIEW_LIMIT)
	{
		int32_t skip = -1;
		GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, newPos.z + MAP_LAYER_VIEW_LIMIT, (Map::maxClientViewportX + 1) * 2, (Map::maxClientViewportY + 1) * 2, -3, skip);

		if (skip >= 0)
		{
			msg.addByte(__FUNCTION__, static_cast<uint8_t>(skip));
			msg.addByte(__FUNCTION__, 0xFF);
		}
	}

	//moving down a floor makes us out of sync
	//east
	msg.addByte(__FUNCTION__, 0x66);
	GetMapDescription(oldPos.x + Map::maxClientViewportX + 1, oldPos.y - (Map::maxClientViewportY + 1), newPos.z, 1, ((Map::maxClientViewportY + 1) * 2), msg);

	//south
	msg.addByte(__FUNCTION__, 0x67);
	GetMapDescription(oldPos.x - Map::maxClientViewportX, oldPos.y + (Map::maxClientViewportY + 1), newPos.z, ((Map::maxClientViewportX + 1) * 2), 1, msg);
}

void ProtocolGame::AddHiddenShopItem(NetworkMessage &msg)
{
	// Empty bytes from AddShopItem
	msg.addU16(__FUNCTION__, 0);
	msg.addByte(__FUNCTION__, 0);
	msg.addString(__FUNCTION__, std::string());
	msg.addU32(__FUNCTION__, 0);
	msg.addU32(__FUNCTION__, 0);
	msg.addU32(__FUNCTION__, 0);
}

void ProtocolGame::AddShopItem(NetworkMessage &msg, const ShopBlock &shopBlock)
{
	// Sends the item information empty if the player doesn't have the storage to buy/sell a certain item
	int32_t storageValue;
	player->getStorageValue(shopBlock.itemStorageKey, storageValue);
	if (shopBlock.itemStorageKey != 0 && storageValue < shopBlock.itemStorageValue)
	{
		AddHiddenShopItem(msg);
		return;
	}

	const ItemType &it = Item::items[shopBlock.itemId];
	msg.addU16(__FUNCTION__, shopBlock.itemId);
	if (it.isSplash() || it.isFluidContainer()) {
		msg.addByte(__FUNCTION__, static_cast<uint8_t>(shopBlock.itemSubType));
	} else {
		msg.addByte(__FUNCTION__, 0x00);
	}

	// If not send "itemName" variable from the npc shop, will registered the name that is in items.xml
	if (shopBlock.itemName.empty()) {
		msg.addString(__FUNCTION__, it.name);
	} else {
		msg.addString(__FUNCTION__, shopBlock.itemName);
	}
	msg.addU32(__FUNCTION__, it.weight);
	msg.addU32(__FUNCTION__, shopBlock.itemBuyPrice == 4294967295 ? 0 : shopBlock.itemBuyPrice);
	msg.addU32(__FUNCTION__, shopBlock.itemSellPrice == 4294967295 ? 0 : shopBlock.itemSellPrice);
}

void ProtocolGame::parseExtendedOpcode(NetworkMessage &msg)
{
	uint8_t opcode = msg.getByte();
	const std::string &buffer = msg.getString();

	// process additional opcodes via lua script event
	addGameTask(&Game::parsePlayerExtendedOpcode, player->getID(), opcode, buffer);
}

void ProtocolGame::sendItemsPrice()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0xCD);

	msg.addU16(__FUNCTION__, g_game().getItemsPriceCount());
	if (g_game().getItemsPriceCount() > 0)
	{
		for (const auto &[itemId, tierAndPriceMap] : g_game().getItemsPrice())
		{
			for (const auto &[tier, price] : tierAndPriceMap)
			{
				msg.addU16(__FUNCTION__, itemId);
				if (Item::items[itemId].upgradeClassification > 0)
				{
					msg.addByte(__FUNCTION__, tier);
				}
				msg.addU64(__FUNCTION__, price);
			}
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::reloadCreature(const Creature *creature)
{
	if (!canSee(creature))
		return;

	uint32_t stackpos = creature->getTile()->getClientIndexOfCreature(player, creature);

	if (stackpos >= 10)
		return;

	NetworkMessage msg;

	phmap::flat_hash_set<uint32_t>::iterator it = std::find(knownCreatureSet.begin(), knownCreatureSet.end(), creature->getID());
	if (it != knownCreatureSet.end())
	{
		msg.addByte(__FUNCTION__, 0x6B);
		msg.addPosition(__FUNCTION__, creature->getPosition());
		msg.addByte(__FUNCTION__, static_cast<uint8_t>(stackpos));
		AddCreature(msg, creature, false, 0);
	}
	else
	{
		sendAddCreature(creature, creature->getPosition(), stackpos, false);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendOpenStash()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x29);
	StashItemList list = player->getStashItems();
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(list.size()));
	for (auto item : list) {
		msg.addU16(__FUNCTION__, item.first);
		msg.addU32(__FUNCTION__, item.second);
	}
	msg.addU16(__FUNCTION__, static_cast<uint16_t>(g_configManager().getNumber(STASH_ITEMS) - getStashSize(list)));
	writeToOutputBuffer(msg);
}

void ProtocolGame::parseStashWithdraw(NetworkMessage &msg)
{
	if (!player->isSupplyStashMenuAvailable()) {
		player->sendCancelMessage("You can't use supply stash right now.");
		return;
	}

	if (player->isUIExhausted(500)) {
		player->sendCancelMessage("You need to wait to do this again.");
		return;
	}

	Supply_Stash_Actions_t action = static_cast<Supply_Stash_Actions_t>(msg.getByte());
	switch (action)	{
		case SUPPLY_STASH_ACTION_STOW_ITEM: {
			Position pos = msg.getPosition();
			uint16_t itemId = msg.get<uint16_t>();
			uint8_t stackpos = msg.getByte();
			uint32_t count = msg.getByte();
			addGameTask(&Game::playerStowItem, player->getID(), pos, itemId, stackpos, count, false);
			break;
		}
		case SUPPLY_STASH_ACTION_STOW_CONTAINER: {
			Position pos = msg.getPosition();
			uint16_t itemId = msg.get<uint16_t>();
			uint8_t stackpos = msg.getByte();
			addGameTask(&Game::playerStowItem, player->getID(), pos, itemId, stackpos, 0, false);
			break;
		}
		case SUPPLY_STASH_ACTION_STOW_STACK: {
			Position pos = msg.getPosition();
			uint16_t itemId = msg.get<uint16_t>();
			uint8_t stackpos = msg.getByte();
			addGameTask(&Game::playerStowItem, player->getID(), pos, itemId, stackpos, 0, true);
			break;
		}
		case SUPPLY_STASH_ACTION_WITHDRAW: {
			uint16_t itemId = msg.get<uint16_t>();
			uint32_t count = msg.get<uint32_t>();
			uint8_t stackpos = msg.getByte();
			addGameTask(&Game::playerStashWithdraw, player->getID(), itemId, count, stackpos);
			break;
		}
		default:
			SPDLOG_ERROR("Unknown 'supply stash' action switch: {}", action);
			break;
	}

	player->updateUIExhausted();
}

void ProtocolGame::sendDepotItems(const ItemsTierCountList &itemMap, uint16_t count)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x94);

	msg.addU16(__FUNCTION__, count);	// List size
	for (const auto &itemMap_it : itemMap) {
		for (const auto& [itemTier, itemCount] : itemMap_it.second) {
			msg.addU16(__FUNCTION__, itemMap_it.first);	// Item ID
			if (itemTier > 0) {
				msg.addByte(__FUNCTION__, itemTier - 1);
			}
			msg.addU16(__FUNCTION__, static_cast<uint16_t>(itemCount));
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCloseDepotSearch()
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x9A);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendDepotSearchResultDetail(uint16_t itemId,
                                               uint8_t tier,
                                               uint32_t depotCount,
                                               const ItemVector &depotItems,
                                               uint32_t inboxCount,
                                               const ItemVector &inboxItems,
                                               uint32_t stashCount)
{
	NetworkMessage msg;
	msg.addByte(__FUNCTION__, 0x99);
	msg.addU16(__FUNCTION__, itemId);
	if (Item::items[itemId].upgradeClassification > 0) {
		msg.addByte(__FUNCTION__, tier);
	}

	msg.addU32(__FUNCTION__, depotCount);
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(depotItems.size()));
	for (const auto& item : depotItems) {
		AddItem(msg, item);
	}

	msg.addU32(__FUNCTION__, inboxCount);
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(inboxItems.size()));
	for (const auto& item : inboxItems) {
		AddItem(msg, item);
	}

	msg.addByte(__FUNCTION__, stashCount > 0 ? 0x01 : 0x00);
	if (stashCount > 0) {
		msg.addU16(__FUNCTION__, itemId);
		msg.addU32(__FUNCTION__, stashCount);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::parseOpenDepotSearch()
{
	addGameTask(&Game::playerRequestDepotItems, player->getID());
}

void ProtocolGame::parseCloseDepotSearch()
{
	addGameTask(&Game::playerRequestCloseDepotSearch, player->getID());
}

void ProtocolGame::parseDepotSearchItemRequest(NetworkMessage &msg)
{
	uint16_t itemId = msg.get<uint16_t>();
	uint8_t itemTier = 0;
	if (Item::items[itemId].upgradeClassification > 0) {
		itemTier = msg.getByte();
	}
	
	addGameTask(&Game::playerRequestDepotSearchItem, player->getID(), itemId, itemTier);
}

void ProtocolGame::parseRetrieveDepotSearch(NetworkMessage &msg)
{
	uint16_t itemId = msg.get<uint16_t>();
	uint8_t itemTier = 0;
	if (Item::items[itemId].upgradeClassification > 0) {
		itemTier = msg.getByte();
	}
	uint8_t type = msg.getByte();
	
	addGameTask(&Game::playerRequestDepotSearchRetrieve, player->getID(), itemId, itemTier, type);
}

void ProtocolGame::parseOpenParentContainer(NetworkMessage &msg)
{
	Position pos = msg.getPosition();

	addGameTask(&Game::playerRequestOpenContainerFromDepotSearch, player->getID(), pos);
}

void ProtocolGame::sendUpdateCreature(const Creature* creature)
{
	if (!creature || !player) {
		return; 
	}

	if (!canSee(creature))
		return;

	int32_t stackPos = creature->getTile()->getClientIndexOfCreature(player, creature);
	if (stackPos == -1 || stackPos >= 10) {
		return;
	}

	NetworkMessage msg; 
	msg.addByte(__FUNCTION__, 0x6B);
	msg.addPosition(__FUNCTION__, creature->getPosition());
	msg.addByte(__FUNCTION__, static_cast<uint8_t>(stackPos));
	AddCreature(msg, creature, false, 0);
	writeToOutputBuffer(msg);
}

void ProtocolGame::getForgeInfoMap(const Item *item, std::map<uint16_t, std::map<uint8_t, uint16_t>>& itemsMap) const
{
	std::map<uint8_t, uint16_t> itemInfo;
	itemInfo.insert({ item->getTier(), item->getItemCount() });
	auto [first, inserted] = itemsMap.try_emplace(item->getID(), itemInfo);
	if (!inserted) {
		auto [otherFirst, otherInserted] = itemsMap[item->getID()].try_emplace(item->getTier(), item->getItemCount());
		if (!otherInserted) {
			(itemsMap[item->getID()])[item->getTier()] += item->getItemCount();
		}
	}
}

void ProtocolGame::sendForgeSkillStats(NetworkMessage &msg) const {
	std::array<Slots_t, 3> slots{ CONST_SLOT_LEFT, CONST_SLOT_ARMOR, CONST_SLOT_HEAD };
	for (const auto &slot : slots) {
		double_t skill = 0;
		if (const Item* item = player->getInventoryItem(slot); item) {
			const ItemType &it = Item::items[item->getID()];
			if (it.isWeapon()) {
				skill = item->getFatalChance() * 100;
			}
			if (it.isArmor()) {
				skill = item->getDodgeChance() * 100;
			}
			if (it.isHelmet()) {
				skill = item->getMomentumChance() * 100;
			}
		}

		auto skillCast = static_cast<uint16_t>(skill);
		msg.addU16(__FUNCTION__, skillCast);
		msg.addU16(__FUNCTION__, skillCast);
	}
}
