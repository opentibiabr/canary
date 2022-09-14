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

#include <boost/range/adaptor/reversed.hpp>

#include "protocolgame.h"

#include "outputmessage.h"

#include "player.h"

#include "configmanager.h"
#include "actions.h"
#include "game.h"
#include "iologindata.h"
#include "iomarket.h"
#include "waitlist.h"
#include "ban.h"
#include "scheduler.h"
#include "modules.h"
#include "spells.h"
#include "weapons.h"
#include "imbuements.h"
#include "iobestiary.h"
#include "monsters.h"

extern Game g_game;
extern ConfigManager g_config;
extern Actions actions;
extern CreatureEvents *g_creatureEvents;
extern Vocations g_vocations;
extern Chat *g_chat;
extern Modules *g_modules;
extern Spells *g_spells;
extern Imbuements *g_imbuements;
extern Monsters g_monsters;

void ProtocolGame::AddItem(NetworkMessage &msg, uint16_t id, uint8_t count)
{
	const ItemType &it = Item::items[id];

	msg.add<uint16_t>(it.clientId);

	if (it.stackable)
	{
		msg.addByte(count);
	}
	else if (it.isSplash() || it.isFluidContainer())
	{
		msg.addByte(fluidMap[count & 7]);
	}
	else if (it.isContainer() && player->getOperatingSystem() <= CLIENTOS_NEW_MAC)
	{
		msg.addByte(0x00);
		msg.addByte(0x00);
	}
	if (it.isPodium) {
		msg.add<uint16_t>(0);
		msg.add<uint16_t>(0);

		msg.addByte(2);
		msg.addByte(0x01);
	}

	if (version >= 1280) {
        if (it.classification > 0) {
            msg.addByte(0); 
        }
    }
}

void ProtocolGame::AddItem(NetworkMessage &msg, const Item *item)
{
	if (!item)
	{
		return;
	}

	const ItemType &it = Item::items[item->getID()];

	msg.add<uint16_t>(it.clientId);

	if (it.stackable)
	{
		msg.addByte(std::min<uint16_t>(0xFF, item->getItemCount()));
	}
	else if (it.isSplash() || it.isFluidContainer())
	{
		msg.addByte(fluidMap[item->getFluidType() & 7]);
	}
	else if (it.isContainer() && player->getOperatingSystem() <= CLIENTOS_NEW_MAC)
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
				msg.addByte(0x01);
				msg.add<uint32_t>(lootFlags);
			}
			else
			{
				msg.addByte(0x00);
			}
		}
		else
		{
			msg.addByte(0x00);
		}

		// Quiver ammo count
    	if (container && item->getWeaponType() == WEAPON_QUIVER && player->getThing(CONST_SLOT_RIGHT) == item) {
      		uint16_t ammoTotal = 0;
      		for (Item* listItem : container->getItemList()) {
        		ammoTotal += listItem->getItemCount();
      		}
      		msg.addByte(0x01);
      		msg.add<uint32_t>(ammoTotal);
    	}
    	else
      		msg.addByte(0x00);
	}
	if (it.isPodium) {
		const ItemAttributes::CustomAttribute* podiumVisible = item->getCustomAttribute("PodiumVisible");
		const ItemAttributes::CustomAttribute* lookType = item->getCustomAttribute("LookType");
		const ItemAttributes::CustomAttribute* lookMount = item->getCustomAttribute("LookMount");
		const ItemAttributes::CustomAttribute* lookDirection = item->getCustomAttribute("LookDirection");

		if (lookType) {
			uint16_t look = static_cast<uint16_t>(boost::get<int64_t>(lookType->value));
			msg.add<uint16_t>(look);

			if(look != 0) {
				const ItemAttributes::CustomAttribute* lookHead = item->getCustomAttribute("LookHead");
				const ItemAttributes::CustomAttribute* lookBody = item->getCustomAttribute("LookBody");
				const ItemAttributes::CustomAttribute* lookLegs = item->getCustomAttribute("LookLegs");
				const ItemAttributes::CustomAttribute* lookFeet = item->getCustomAttribute("LookFeet");

				msg.addByte(lookHead ? static_cast<uint8_t>(boost::get<int64_t>(lookHead->value)) : 0);
				msg.addByte(lookBody ? static_cast<uint8_t>(boost::get<int64_t>(lookBody->value)) : 0);
				msg.addByte(lookLegs ? static_cast<uint8_t>(boost::get<int64_t>(lookLegs->value)) : 0);
				msg.addByte(lookFeet ? static_cast<uint8_t>(boost::get<int64_t>(lookFeet->value)) : 0);

				const ItemAttributes::CustomAttribute* lookAddons = item->getCustomAttribute("LookAddons");
				msg.addByte(lookAddons ? static_cast<uint8_t>(boost::get<int64_t>(lookAddons->value)) : 0);
			}
		} else {
			msg.add<uint16_t>(0);
		}

		if (lookMount) {
			uint16_t look = static_cast<uint16_t>(boost::get<int64_t>(lookMount->value));
			msg.add<uint16_t>(look);

			if (look != 0) {
				const ItemAttributes::CustomAttribute* lookHead = item->getCustomAttribute("LookMountHead");
				const ItemAttributes::CustomAttribute* lookBody = item->getCustomAttribute("LookMountBody");
				const ItemAttributes::CustomAttribute* lookLegs = item->getCustomAttribute("LookMountLegs");
				const ItemAttributes::CustomAttribute* lookFeet = item->getCustomAttribute("LookMountFeet");

				msg.addByte(lookHead ? static_cast<uint8_t>(boost::get<int64_t>(lookHead->value)) : 0);
				msg.addByte(lookBody ? static_cast<uint8_t>(boost::get<int64_t>(lookBody->value)) : 0);
				msg.addByte(lookLegs ? static_cast<uint8_t>(boost::get<int64_t>(lookLegs->value)) : 0);
				msg.addByte(lookFeet ? static_cast<uint8_t>(boost::get<int64_t>(lookFeet->value)) : 0);
			}
		} else {
			msg.add<uint16_t>(0);
		}

		msg.addByte(lookDirection ? static_cast<uint8_t>(boost::get<int64_t>(lookDirection->value)) : 2);
		msg.addByte(podiumVisible ? static_cast<uint8_t>(boost::get<int64_t>(podiumVisible->value)) : 0x01);
	}

	if (version >= 1280) {
        if (it.classification > 0) {
            uint8_t tier = item->getTier();
            msg.addByte(tier);
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
	Player *foundPlayer = g_game.getPlayerByName(name);
	if (!foundPlayer || g_config.getBoolean(ConfigManager::ALLOW_CLONES))
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

		if (g_game.getGameState() == GAME_STATE_CLOSING && !player->hasFlag(PlayerFlag_CanAlwaysLogin))
		{
			disconnectClient("The game is just going down.\nPlease try again later.");
			return;
		}

		if (g_game.getGameState() == GAME_STATE_CLOSED && !player->hasFlag(PlayerFlag_CanAlwaysLogin))
		{
			disconnectClient("Server is currently closed.\nPlease try again later.");
			return;
		}

		if (g_config.getBoolean(ConfigManager::ONLY_PREMIUM_ACCOUNT) && !player->isPremium() && (player->getGroup()->id < account::GROUP_TYPE_GAMEMASTER || player->getAccountType() < account::ACCOUNT_TYPE_GAMEMASTER))
		{
			disconnectClient("Your premium time for this account is out.\n\nTo play please buy additional premium time from our website");
			return;
		}

		if (g_config.getBoolean(ConfigManager::ONE_PLAYER_ON_ACCOUNT) && player->getAccountType() < account::ACCOUNT_TYPE_GAMEMASTER && g_game.getPlayerByAccount(player->getAccount()))
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
			output->addByte(0x16);
			output->addString(ss.str());
			output->addByte(retryTime);
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

		if (!g_game.placeCreature(player, player->getLoginPosition()))
		{
			if (!g_game.placeCreature(player, player->getTemplePosition(), false, true))
			{
				disconnectClient("Temple position is wrong. Please, contact the administrator.");
				SPDLOG_WARN("Player {} temple position is wrong", player->getName());
				return;
			}
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
		if (eventConnect != 0 || !g_config.getBoolean(ConfigManager::REPLACE_KICK_ON_LOGIN))
		{
			//Already trying to connect
			disconnectClient("You are already logged in.");
			return;
		}

		if (foundPlayer->client)
		{
			foundPlayer->disconnect();
			foundPlayer->isConnecting = true;

			eventConnect = g_scheduler.addEvent(createSchedulerTask(1000, std::bind(&ProtocolGame::connect, getThis(), foundPlayer->getID(), operatingSystem)));
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

	Player *foundPlayer = g_game.getPlayerByID(playerId);
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

	g_chat->removeUserFromAllChannels(*player);
	player->clearModalWindows();
	player->setOperatingSystem(operatingSystem);
	player->isConnecting = false;

	player->client = getThis();
	sendAddCreature(player, player->getPosition(), 0, true);
	player->lastIP = player->getIP();
	player->lastLoginSaved = std::max<time_t>(time(nullptr), player->lastLoginSaved + 1);
	acceptPackets = true;
	player->openPlayerContainers();
}

void ProtocolGame::logout(bool displayEffect, bool forced)
{
	//dispatcher thread
	if (!player)
	{
		return;
	}

	if (!player->isRemoved())
	{
		if (!forced)
		{
			if (!player->isAccessPlayer())
			{
				if (player->getTile()->hasFlag(TILESTATE_NOLOGOUT))
				{
					player->sendCancelMessage(RETURNVALUE_YOUCANNOTLOGOUTHERE);
					return;
				}

				if (!player->getTile()->hasFlag(TILESTATE_PROTECTIONZONE) && player->hasCondition(CONDITION_INFIGHT))
				{
					player->sendCancelMessage(RETURNVALUE_YOUMAYNOTLOGOUTDURINGAFIGHT);
					return;
				}
			}

			//scripting event - onLogout
			if (!g_creatureEvents->playerLogout(player))
			{
				//Let the script handle the error message
				return;
			}
		}

		if (displayEffect && player->getHealth() > 0 && !player->isInGhostMode())
		{
			g_game.addMagicEffect(player->getPosition(), CONST_ME_POFF);
		}
	}

	sendSessionEndInformation(SESSION_END_LOGOUT2);

	g_game.removeCreature(player, true);
}

void ProtocolGame::onRecvFirstMessage(NetworkMessage &msg)
{
	if (g_game.getGameState() == GAME_STATE_SHUTDOWN)
	{
		disconnect();
		return;
	}

	OperatingSystem_t operatingSystem = static_cast<OperatingSystem_t>(msg.get<uint16_t>());

	if (operatingSystem <= CLIENTOS_NEW_MAC) {
		enableCompact();
	}

	version = msg.get<uint16_t>();

	clientVersion = static_cast<int32_t>(msg.get<uint32_t>());

	msg.skipBytes(3); // U16 dat revision, game preview state

	// In version 12.40.10030 we have 13 extra bytes
	if (msg.getLength() - msg.getBufferPosition() == 141)
	{
		msg.skipBytes(13);
	}

	if (!Protocol::RSA_decrypt(msg))
	{
		SPDLOG_WARN("[ProtocolGame::onRecvFirstMessage] - RSA Decrypt Failed");
		disconnect();
		return;
	}

	xtea::key key;
	key[0] = msg.get<uint32_t>();
	key[1] = msg.get<uint32_t>();
	key[2] = msg.get<uint32_t>();
	key[3] = msg.get<uint32_t>();
	enableXTEAEncryption();
	setXTEAKey(std::move(key));

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

	if (clientVersion != g_config.getNumber(ConfigManager::CLIENT_VERSION))
	{
		std::ostringstream ss;
		ss << "Only clients with protocol " << g_config.getString(ConfigManager::CLIENT_VERSION_STR) << " allowed!";
		disconnectClient(ss.str());
		return;
	}

	if (g_game.getGameState() == GAME_STATE_STARTUP)
	{
		disconnectClient("Gameworld is starting up. Please wait.");
		return;
	}

	if (g_game.getGameState() == GAME_STATE_MAINTAIN)
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

	g_dispatcher.addTask(createTask(std::bind(&ProtocolGame::login, getThis(), characterName, accountId, operatingSystem)));
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
	output->add<uint16_t>(0x0006);
	output->addByte(0x1F);

	// Add timestamp & random number
	challengeTimestamp = static_cast<uint32_t>(time(nullptr));
	output->add<uint32_t>(challengeTimestamp);

	challengeRandom = randNumber(generator);
	output->addByte(challengeRandom);

	// Go back and write checksum
	output->skipBytes(-12);
	// To support 11.10-, not have problems with 11.11+
	output->add<uint32_t>(adlerChecksum(output->getOutputBuffer() + sizeof(uint32_t), 8));

	send(std::move(output));
}

void ProtocolGame::disconnectClient(const std::string &message) const
{
	auto output = OutputMessagePool::getOutputMessage();
	output->addByte(0x14);
	output->addString(message);
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
	if (!acceptPackets || g_game.getGameState() == GAME_STATE_SHUTDOWN || msg.getLength() <= 0) {
		return;
	}

	uint8_t recvbyte = msg.getByte();

	if (!player || player->isRemoved()) {
		if (recvbyte == 0x0F) {
			disconnect();
    }

		return;
	}

	//a dead player can not performs actions
	if (player->isDead() || player->getHealth() <= 0) {
		if (recvbyte == 0x14) {
			disconnect();
			return;
		}

		if (recvbyte == 0x0F) {
			if (!player) {
				return;
			}

			if (!player->spawn()) {
				disconnect();
				g_game.removeCreature(player);
				return;
			}

			sendAddCreature(player, player->getPosition(), 0, false);
			
			std::string bless = player->getBlessingsName();
			std::ostringstream lostBlesses;
			(bless.length() == 0) ? lostBlesses << "You lost all your blessings." : lostBlesses <<  "You are still blessed with " << bless;
			player->sendTextMessage(MESSAGE_EVENT_ADVANCE, lostBlesses.str());
			if (player->getLevel() < g_config.getNumber(ConfigManager::ADVENTURERSBLESSING_LEVEL)) {
				for (uint8_t i = 2; i <= 6; i++) {
					if (!player->hasBlessing(i)) {
						player->addBlessing(i, 1);
					}
				}
				sendBlessStatus();
			}
			return;
		}

		if (recvbyte != 0x1D && recvbyte != 0x1E) {
			// keep the connection alive
			g_scheduler.addEvent(createSchedulerTask(500, std::bind(&ProtocolGame::sendPing, getThis())));
			g_scheduler.addEvent(createSchedulerTask(1000, std::bind(&ProtocolGame::sendPingBack, getThis())));
			return;
		}
	}

	// Modules system
	if(recvbyte != 0xD3){
		g_dispatcher.addTask(createTask(std::bind(&Modules::executeOnRecvbyte, g_modules, player->getID(), msg, recvbyte)));
	}

	g_dispatcher.addTask(createTask(std::bind(&ProtocolGame::parsePacketFromDispatcher, getThis(), msg, recvbyte)));
}

void ProtocolGame::parsePacketFromDispatcher(NetworkMessage msg, uint8_t recvbyte)
{
	if (!acceptPackets || g_game.getGameState() == GAME_STATE_SHUTDOWN) {
		return;
	}

	if (!player || player->isRemoved() || player->getHealth() <= 0) {
		return;
	}

	switch (recvbyte) {
    case 0x00: SPDLOG_DEBUG("Player: {} sent an unknown packet header: x0{}", player->getName(), static_cast<uint16_t>(recvbyte));
		case 0x14: g_dispatcher.addTask(createTask(std::bind(&ProtocolGame::logout, getThis(), true, false))); break;
		case 0x1D: addGameTask(&Game::playerReceivePingBack, player->getID()); break;
		case 0x1E: addGameTask(&Game::playerReceivePing, player->getID()); break;
		case 0x2a: addBestiaryTrackerList(msg); break;
		case 0x2B: parsePartyAnalyzerAction(msg); break;
		case 0x2c: parseLeaderFinderWindow(msg); break;
		case 0x2d: parseMemberFinderWindow(msg); break;
		case 0x28: parseStashWithdraw(msg); break;
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
		case 0x7A: parsePlayerPurchase(msg); break;
		case 0x7B: parsePlayerSale(msg); break;
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
		case 0x92: parseRequestLockItems(); break;
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
		case 0xC7: parseTournamentLeaderboard(msg); break;
		case 0xC9: /* update tile */ break;
		case 0xCA: parseUpdateContainer(msg); break;
		case 0xCB: parseBrowseField(msg); break;
		case 0xCC: parseSeekInContainer(msg); break;
		case 0xCD: parseInspectionObject(msg); break;
		case 0xD2: addGameTask(&Game::playerRequestOutfit, player->getID()); break;
		//g_dispatcher.addTask(createTask(std::bind(&Modules::executeOnRecvbyte, g_modules, player, msg, recvbyte)));
		case 0xD3: g_dispatcher.addTask(createTask(std::bind(&ProtocolGame::parseSetOutfit, getThis(), msg))); break;
		case 0xD4: parseToggleMount(msg); break;
		case 0xD5: parseApplyImbuement(msg); break;
		case 0xD6: parseClearingImbuement(msg); break;
		case 0xD7: parseCloseImbuingWindow(msg); break;
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
		case 0xEE: parseGreet(msg); break;
		case 0xEF: if (!g_config.getBoolean(ConfigManager::STOREMODULES)) { parseCoinTransfer(msg); } break; /* premium coins transfer */
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
		case 0xFA: if (!g_config.getBoolean(ConfigManager::STOREMODULES)) { parseStoreOpen(msg); } break;
		case 0xFB: if (!g_config.getBoolean(ConfigManager::STOREMODULES)) { parseStoreRequestOffers(msg); } break;
		case 0xFC: if (!g_config.getBoolean(ConfigManager::STOREMODULES)) { parseStoreBuyOffer(msg); } break;
//		case 0xFD: parseStoreOpenTransactionHistory(msg); break;
//		case 0xFE: parseStoreRequestTransactionHistory(msg); break;

		//case 0xDF, 0xE0, 0xE1, 0xFB, 0xFC, 0xFD, 0xFE Premium Shop.

		default:
			SPDLOG_DEBUG("Player: {} sent an unknown packet header: x0{}", player->getName(), static_cast<uint16_t>(recvbyte));
			break;
	}

	// Send disconnect when opening the store
	// if (msg.isOverrun()) {
	// 	SPDLOG_WARN("[ProtocolGame::parsePacket] - Message is overrun");
	// 	disconnect();
	// }
}

void ProtocolGame::parseHotkeyEquip(NetworkMessage &msg)
{
	if (!player)
	{
		return;
	}
	uint16_t spriteid = msg.get<uint16_t>();
	addGameTask(&Game::onPressHotkeyEquip, player->getID(), spriteid);
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

			if (++count == 10) {
				break;
			}
		}
	}

	const CreatureVector *creatures = tile->getCreatures();
	if (creatures)
	{
		for (const Creature *creature : boost::adaptors::reverse(*creatures))
		{
			if (!player->canSeeCreature(creature))
			{
				continue;
			}

			bool known;
			uint32_t removedKnown;
			checkCreatureAsKnown(creature->getID(), known, removedKnown);
			AddCreature(msg, creature, known, removedKnown);

			++count;
		}
	}

	if (items && count < 10)
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

	if (z > 7)
	{
		startz = z - 2;
		endz = std::min<int32_t>(MAP_MAX_LAYERS - 1, z + 2);
		zstep = 1;
	}
	else
	{
		startz = 7;
		endz = 0;
		zstep = -1;
	}

	for (int32_t nz = startz; nz != endz + zstep; nz += zstep)
	{
		GetFloorDescription(msg, x, y, nz, width, height, z - nz, skip);
	}

	if (skip >= 0)
	{
		msg.addByte(skip);
		msg.addByte(0xFF);
	}
}

void ProtocolGame::GetFloorDescription(NetworkMessage &msg, int32_t x, int32_t y, int32_t z, int32_t width, int32_t height, int32_t offset, int32_t &skip)
{
	for (int32_t nx = 0; nx < width; nx++)
	{
		for (int32_t ny = 0; ny < height; ny++)
		{
			Tile *tile = g_game.map.getTile(x + nx + offset, y + ny + offset, z);
			if (tile)
			{
				if (skip >= 0)
				{
					msg.addByte(skip);
					msg.addByte(0xFF);
				}

				skip = 0;
				GetTileDescription(tile, msg);
			}
			else if (skip == 0xFE)
			{
				msg.addByte(0xFF);
				msg.addByte(0xFF);
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
			Creature* creature = g_game.getCreatureByID(*it);
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
	if (myPos.z <= 7)
	{
		//we are on ground level or above (7 -> 0)
		//view is from 7 -> 0
		if (z > 7)
		{
			return false;
		}
	}
	else if (myPos.z >= 8)
	{
		//we are underground (8 -> 15)
		//view is +/- 2 from the floor we stand on
		if (std::abs(myPos.getZ() - z) > 2)
		{
			return false;
		}
	}

	//negative offset means that the action taken place is on a lower floor than ourself
	int32_t offsetz = myPos.getZ() - z;
	if ((x >= myPos.getX() - 8 + offsetz) && (x <= myPos.getX() + 9 + offsetz) &&
		(y >= myPos.getY() - 6 + offsetz) && (y <= myPos.getY() + 7 + offsetz))
	{
		return true;
	}
	return false;
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
	Module *outfitModule = g_modules->getEventByRecvbyte(0xD3, false);
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
			g_game.playerChangeOutfit(player->getID(), newOutfit);
		}
		else if (outfitType == 1)
		{
			//This value probably has something to do with try outfit variable inside outfit window dialog
			//if try outfit is set to 2 it expects uint32_t value after mounted and disable mounts from outfit window dialog
			newOutfit.lookMount = 0;
			msg.get<uint32_t>();
		} else if (outfitType == 2) {
			Position pos = msg.getPosition();
			uint16_t spriteId = msg.get<uint16_t>();
			uint8_t stackpos = msg.getByte();
			newOutfit.lookMount = msg.get<uint16_t>();
			newOutfit.lookMountHead = std::min<uint8_t>(132, msg.getByte());
			newOutfit.lookMountBody = std::min<uint8_t>(132, msg.getByte());
			newOutfit.lookMountLegs = std::min<uint8_t>(132, msg.getByte());
			newOutfit.lookMountFeet = std::min<uint8_t>(132, msg.getByte());
			uint8_t direction = std::max<uint8_t>(DIRECTION_NORTH, std::min<uint8_t>(DIRECTION_WEST, msg.getByte()));
			uint8_t podiumVisible = msg.getByte();
			g_game.playerSetShowOffSocket(player->getID(), newOutfit, pos, stackpos, spriteId, podiumVisible, direction);
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

void ProtocolGame::parseClearingImbuement(NetworkMessage &msg)
{
	uint8_t slot = msg.getByte();
	addGameTask(&Game::playerClearingImbuement, player->getID(), slot);
}

void ProtocolGame::parseCloseImbuingWindow(NetworkMessage &)
{
	addGameTask(&Game::playerCloseImbuingWindow, player->getID());
}

void ProtocolGame::parseUseItem(NetworkMessage &msg)
{
	Position pos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	uint8_t index = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerUseItem, player->getID(), pos, stackpos, index, spriteId);
}

void ProtocolGame::parseUseItemEx(NetworkMessage &msg)
{
	Position fromPos = msg.getPosition();
	uint16_t fromSpriteId = msg.get<uint16_t>();
	uint8_t fromStackPos = msg.getByte();
	Position toPos = msg.getPosition();
	uint16_t toSpriteId = msg.get<uint16_t>();
	uint8_t toStackPos = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerUseItemEx, player->getID(), fromPos, fromStackPos, fromSpriteId, toPos, toStackPos, toSpriteId);
}

void ProtocolGame::parseUseWithCreature(NetworkMessage &msg)
{
	Position fromPos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	uint8_t fromStackPos = msg.getByte();
	uint32_t creatureId = msg.get<uint32_t>();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerUseWithCreature, player->getID(), fromPos, fromStackPos, creatureId, spriteId);
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
	uint16_t spriteId = msg.get<uint16_t>();
	uint8_t fromStackpos = msg.getByte();
	Position toPos = msg.getPosition();
	uint8_t count = msg.getByte();

	if (toPos != fromPos)
	{
		addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerMoveThing, player->getID(), fromPos, spriteId, fromStackpos, toPos, count);
	}
}

void ProtocolGame::parseLookAt(NetworkMessage &msg)
{
	Position pos = msg.getPosition();
	msg.skipBytes(2); // spriteId
	uint8_t stackpos = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerLookAt, player->getID(), pos, stackpos);
}

void ProtocolGame::parseLookInBattleList(NetworkMessage &msg)
{
	uint32_t creatureId = msg.get<uint32_t>();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerLookInBattleList, player->getID(), creatureId);
}

void ProtocolGame::parseQuickLoot(NetworkMessage &msg)
{
	Position pos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	bool lootAllCorpses = msg.getByte();
	addGameTask(&Game::playerQuickLoot, player->getID(), pos, spriteId, stackpos, nullptr, lootAllCorpses);
}

void ProtocolGame::parseLootContainer(NetworkMessage &msg)
{
	uint8_t action = msg.getByte();
	if (action == 0)
	{
		ObjectCategory_t category = (ObjectCategory_t)msg.getByte();
		Position pos = msg.getPosition();
		uint16_t spriteId = msg.get<uint16_t>();
		uint8_t stackpos = msg.getByte();
		addGameTask(&Game::playerSetLootContainer, player->getID(), category, pos, spriteId, stackpos);
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

void ProtocolGame::parseRequestLockItems()
{
	addGameTask(&Game::playerRequestLockFind, player->getID());
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

	fightMode_t fightMode;
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

void ProtocolGame::parsePlayerPurchase(NetworkMessage &msg)
{
	uint16_t id = msg.get<uint16_t>();
	uint8_t count = msg.getByte();
	uint8_t amount = msg.getByte();
	bool ignoreCap = msg.getByte() != 0;
	bool inBackpacks = msg.getByte() != 0;
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerBuyItem, player->getID(), id, count, amount, ignoreCap, inBackpacks);
}

void ProtocolGame::parsePlayerSale(NetworkMessage &msg)
{
	uint16_t id = msg.get<uint16_t>();
	uint8_t count = std::max(msg.getByte(), (uint8_t) 1);
	uint8_t amount = msg.getByte();
	bool ignoreEquipped = msg.getByte() != 0;

	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerSellItem, player->getID(), id, count, amount, ignoreEquipped);
}

void ProtocolGame::parseRequestTrade(NetworkMessage &msg)
{
	Position pos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	uint32_t playerId = msg.get<uint32_t>();
	addGameTask(&Game::playerRequestTrade, player->getID(), pos, stackpos, playerId, spriteId);
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
	uint16_t spriteId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerRotateItem, player->getID(), pos, stackpos, spriteId);
}

void ProtocolGame::parseWrapableItem(NetworkMessage &msg)
{
	Position pos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerWrapableItem, player->getID(), pos, stackpos, spriteId);
}

void ProtocolGame::parseInspectionObject(NetworkMessage &msg)
{
	uint8_t inspectionType = msg.getByte();
	if (inspectionType == INSPECT_NORMALOBJECT)
	{
		Position pos = msg.getPosition();
		g_game.playerInspectItem(player, pos);
	}
	else if (inspectionType == INSPECT_NPCTRADE || inspectionType == INSPECT_CYCLOPEDIA)
	{
		uint16_t itemId = msg.get<uint16_t>();
		uint16_t itemCount = msg.getByte();
		g_game.playerInspectItem(player, itemId, itemCount, (inspectionType == INSPECT_CYCLOPEDIA));
	}
}

void ProtocolGame::sendSessionEndInformation(SessionEndInformations information)
{
	auto output = OutputMessagePool::getOutputMessage();
	output->addByte(0x18);
	output->addByte(information);
	send(output);
	disconnect();
}

void ProtocolGame::sendItemInspection(uint16_t itemId, uint8_t itemCount, const Item *item, bool cyclopedia)
{
	NetworkMessage msg;
	msg.addByte(0x76);
	msg.addByte(0x00);
	msg.addByte(cyclopedia ? 0x01 : 0x00);
	msg.addByte(0x01);

	const ItemType &it = Item::items.getItemIdByClientId(itemId);

	if (item)
	{
		msg.addString(item->getName());
		AddItem(msg, item);
	}
	else
	{
		msg.addString(it.name);
		AddItem(msg, it.id, itemCount);
	}
	msg.addByte(0);

	auto descriptions = Item::getDescriptions(it, item);
	msg.addByte(descriptions.size());
	for (const auto &description : descriptions)
	{
		msg.addString(description.first);
		msg.addString(description.second);
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
	g_game.playerCyclopediaCharacterInfo(player, characterID, characterInfoType, entriesPerPage, page);
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
	g_game.playerHighscores(player, type, category, vocation, worldName, page, entriesPerPage);
}

void ProtocolGame::parseTaskHuntingAction(NetworkMessage &msg)
{
	uint8_t slot = msg.getByte();
	uint8_t action = msg.getByte();
	bool upgrade = msg.getByte() != 0;
	uint16_t raceId = msg.get<uint16_t>();

	if (!g_config.getBoolean(ConfigManager::TASK_HUNTING_ENABLED)) {
		return;
	}

	addGameTask(&Game::playerTaskHuntingAction, player->getID(), slot, action, upgrade, raceId);
}

void ProtocolGame::sendHighscoresNoData()
{
	NetworkMessage msg;
	msg.addByte(0xB1);
	msg.addByte(0x01); // No data available
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendHighscores(const std::vector<HighscoreCharacter> &characters, uint8_t categoryId, uint32_t vocationId, uint16_t page, uint16_t pages)
{
	NetworkMessage msg;
	msg.addByte(0xB1);
	msg.addByte(0x00); // No data available

	msg.addByte(1);												   // Worlds
	msg.addString(g_config.getString(ConfigManager::SERVER_NAME)); // First World
	msg.addString(g_config.getString(ConfigManager::SERVER_NAME)); // Selected World

	msg.addByte(0); // Game World Category: 0xFF(-1) - Selected World
	msg.addByte(0); // BattlEye World Type

	auto vocationPosition = msg.getBufferPosition();
	uint8_t vocations = 1;

	msg.skipBytes(1);			   // Vocation Count
	msg.add<uint32_t>(0xFFFFFFFF); // All Vocations - hardcoded
	msg.addString("(all)");		   // All Vocations - hardcoded

	uint32_t selectedVocation = 0xFFFFFFFF;
	const auto &vocationsMap = g_vocations.getVocations();
	for (const auto &it : vocationsMap)
	{
		const Vocation &vocation = it.second;
		if (vocation.getFromVocation() == static_cast<uint32_t>(vocation.getId()))
		{
			msg.add<uint32_t>(vocation.getFromVocation()); // Vocation Id
			msg.addString(vocation.getVocName());		   // Vocation Name
			++vocations;
			if (vocation.getFromVocation() == vocationId)
			{
				selectedVocation = vocationId;
			}
		}
	}
	msg.add<uint32_t>(selectedVocation); // Selected Vocation

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
	msg.addByte(sizeof(highscoreCategories) / sizeof(HighscoreCategory)); // Category Count
	for (HighscoreCategory &category : highscoreCategories)
	{
		msg.addByte(category.id);	  // Category Id
		msg.addString(category.name); // Category Name
		if (category.id == categoryId)
		{
			selectedCategory = categoryId;
		}
	}
	msg.addByte(selectedCategory); // Selected Category

	msg.add<uint16_t>(page);  // Current page
	msg.add<uint16_t>(pages); // Pages

	msg.addByte(characters.size()); // Character Count
	for (const HighscoreCharacter &character : characters)
	{
		msg.add<uint32_t>(character.rank);							   // Rank
		msg.addString(character.name);								   // Character Name
		msg.addString("");											   // Probably Character Title(not visible in window)
		msg.addByte(character.vocation);							   // Vocation Id
		msg.addString(g_config.getString(ConfigManager::SERVER_NAME)); // World
		msg.add<uint16_t>(character.level);							   // Level
		msg.addByte((player->getGUID() == character.id));			   // Player Indicator Boolean
		msg.add<uint64_t>(character.points);						   // Points
	}

	msg.addByte(0xFF);				  // ??
	msg.addByte(0);					  // ??
	msg.addByte(1);					  // ??
	msg.add<uint32_t>(time(nullptr)); // Last Update

	msg.setBufferPosition(vocationPosition);
	msg.addByte(vocations);
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
	uint16_t spriteId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	g_game.playerConfigureShowOffSocket(player->getID(), pos, stackpos, spriteId);
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
	msg.addByte(0xd5);
	msg.add<uint16_t>(BESTY_RACE_LAST);
	std::map<uint16_t, std::string> mtype_list = g_game.getBestiaryList();
	for (uint8_t i = BESTY_RACE_FIRST; i <= BESTY_RACE_LAST; i++)
	{
		std::string BestClass = "";
		uint16_t count = 0;
		for (auto rit : mtype_list)
		{
			MonsterType *mtype = g_monsters.getMonsterType(rit.second);
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
		msg.addString(BestClass);
		msg.add<uint16_t>(count);
		uint16_t unlockedCount = g_iobestiary().getBestiaryRaceUnlocked(player, static_cast<BestiaryType_t>(i));
		msg.add<uint16_t>(unlockedCount);
	}
	writeToOutputBuffer(msg);

	player->BestiarysendCharms();
}

void ProtocolGame::sendBestiaryEntryChanged(uint16_t raceid)
{
	NetworkMessage msg;
	msg.addByte(0xd9);
	msg.add<uint16_t>(raceid);
	writeToOutputBuffer(msg);
}

void ProtocolGame::parseBestiarysendMonsterData(NetworkMessage &msg)
{
	uint16_t raceId = msg.get<uint16_t>();
	std::string Class = "";
	MonsterType *mtype = nullptr;
	std::map<uint16_t, std::string> mtype_list = g_game.getBestiaryList();

	auto ait = mtype_list.find(raceId);
	if (ait != mtype_list.end())
	{
		MonsterType *mType = g_monsters.getMonsterType(ait->second);
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
	newmsg.addByte(0xd7);
	newmsg.add<uint16_t>(raceId);
	newmsg.addString(Class);

	newmsg.addByte(currentLevel);
	newmsg.add<uint32_t>(killCounter);

	newmsg.add<uint16_t>(mtype->info.bestiaryFirstUnlock);
	newmsg.add<uint16_t>(mtype->info.bestiarySecondUnlock);
	newmsg.add<uint16_t>(mtype->info.bestiaryToUnlock);

	newmsg.addByte(mtype->info.bestiaryStars);
	newmsg.addByte(mtype->info.bestiaryOccurrence);
	
	std::vector<LootBlock> lootList = mtype->info.lootItems;
	newmsg.addByte(lootList.size());
	for (LootBlock loot : lootList)
	{
		int8_t difficult = g_iobestiary().calculateDifficult(loot.chance);
		newmsg.addItemId(currentLevel > 1 ? loot.id : 0);
		newmsg.addByte(difficult);
		newmsg.addByte(0); // 1 if special event - 0 if regular loot (?)
		if (currentLevel > 1)
		{
			newmsg.addString(loot.name);
			newmsg.addByte(loot.countmax > 0 ? 0x1 : 0x0);
		}
	}

	if (currentLevel > 1)
	{
		newmsg.add<uint16_t>(mtype->info.bestiaryCharmsPoints);
		int8_t attackmode = 0;
		if (!mtype->info.isHostile)
		{
			attackmode = 2;
		}
		else if (mtype->info.targetDistance)
		{
			attackmode = 1;
		}

		newmsg.addByte(attackmode);
		newmsg.addByte(0x2);
		newmsg.add<uint32_t>(mtype->info.healthMax);
		newmsg.add<uint32_t>(mtype->info.experience);
		newmsg.add<uint16_t>(mtype->info.baseSpeed);
		newmsg.add<uint16_t>(mtype->info.armor);
	}

	if (currentLevel > 2)
	{
		std::map<uint8_t, int16_t> elements = g_iobestiary().getMonsterElements(mtype);

		newmsg.addByte(elements.size());
		for (auto it = std::begin(elements), end = std::end(elements); it != end; it++)
		{
			newmsg.addByte(it->first);
			newmsg.add<uint16_t>(it->second);
		}

		newmsg.add<uint16_t>(1);
		newmsg.addString(mtype->info.bestiaryLocations);
	}

	if (currentLevel > 3)
	{
		charmRune_t mType_c = g_iobestiary().getCharmFromTarget(player, mtype);
		if (mType_c != CHARM_NONE)
		{
			newmsg.addByte(1);
			newmsg.addByte(mType_c);
			newmsg.add<uint32_t>(player->getLevel() * 100);
		}
		else
		{
			newmsg.addByte(0);
			newmsg.addByte(1);
		}
	}

	writeToOutputBuffer(newmsg);
}

void ProtocolGame::addBestiaryTrackerList(NetworkMessage &msg)
{
	uint16_t thisrace = msg.get<uint16_t>();
	std::map<uint16_t, std::string> mtype_list = g_game.getBestiaryList();
	auto it = mtype_list.find(thisrace);
	if (it != mtype_list.end())
	{
		MonsterType *mtype = g_monsters.getMonsterType(it->second);
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
	msg.addByte(0x2D);
	msg.addByte(0x00); // Bool value, with 'true' the player exceed packets for second.
	std::map<uint32_t, TeamFinder*> teamFinder = g_game.getTeamFinderList();
	msg.add<uint16_t>(teamFinder.size());
	for (auto it : teamFinder) {
		Player* leader = g_game.getPlayerByGUID(it.first);
		if (!leader)
			return;

		TeamFinder* teamAssemble = it.second;
		if (!teamAssemble)
			return;

		uint8_t status = 0;
		uint16_t membersSize = 0;
		msg.add<uint32_t>(leader->getGUID());
		msg.addString(leader->getName());
		msg.add<uint16_t>(teamAssemble->minLevel);
		msg.add<uint16_t>(teamAssemble->maxLevel);
		msg.addByte(teamAssemble->vocationIDs);
		msg.add<uint16_t>(teamAssemble->teamSlots);
		for (auto itt : teamAssemble->membersMap) {
			Player* member = g_game.getPlayerByGUID(it.first);
			if (member) {
				if (itt.first == player->getGUID())
					status = itt.second;

				if (itt.second == 3)
					membersSize += 1;
			}
		}
		msg.add<uint16_t>(std::max<uint16_t>((teamAssemble->teamSlots - teamAssemble->freeSlots), membersSize));
		// The leader does not count on this math, he is included inside the 'freeSlots'.
		msg.add<uint32_t>(teamAssemble->timestamp);
		msg.addByte(teamAssemble->teamType);

		switch (teamAssemble->teamType) {
			case 1: {
				msg.add<uint16_t>(teamAssemble->bossID);
				break;
			}
			case 2: {
				msg.add<uint16_t>(teamAssemble->hunt_type);
				msg.add<uint16_t>(teamAssemble->hunt_area);
				break;
			}
			case 3: {
				msg.add<uint16_t>(teamAssemble->questID);
				break;
			}

			default:
				break;
		}

		msg.addByte(status);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendLeaderTeamFinder(bool reset)
{
	if (!player)
		return;

	TeamFinder* teamAssemble = nullptr;
	std::map<uint32_t, TeamFinder*> teamFinder = g_game.getTeamFinderList();
	auto it = teamFinder.find(player->getGUID());
	if (it != teamFinder.end()) {
		teamAssemble = it->second;
	}

	if (!teamAssemble)
		return;

	NetworkMessage msg;
	msg.addByte(0x2C);
	msg.addByte(reset ? 1 : 0);
	if (reset) {
		g_game.removeTeamFinderListed(player->getGUID());
		return;
	}
	msg.add<uint16_t>(teamAssemble->minLevel);
	msg.add<uint16_t>(teamAssemble->maxLevel);
	msg.addByte(teamAssemble->vocationIDs);
	msg.add<uint16_t>(teamAssemble->teamSlots);
	msg.add<uint16_t>(teamAssemble->freeSlots);
	msg.add<uint32_t>(teamAssemble->timestamp);
	msg.addByte(teamAssemble->teamType);

	switch (teamAssemble->teamType) {
		case 1: {
			msg.add<uint16_t>(teamAssemble->bossID);
			break;
		}
		case 2: {
			msg.add<uint16_t>(teamAssemble->hunt_type);
			msg.add<uint16_t>(teamAssemble->hunt_area);
			break;
		}
		case 3: {
			msg.add<uint16_t>(teamAssemble->questID);
			break;
		}

		default:
			break;
	}

	uint16_t membersSize = 1;
	for (auto memberPair : teamAssemble->membersMap) {
		Player* member = g_game.getPlayerByGUID(memberPair.first);
		if (member) {
			membersSize += 1;
		}
	}

	msg.add<uint16_t>(membersSize);
	Player* leader = g_game.getPlayerByGUID(teamAssemble->leaderGuid);
	if (!leader)
		return;

	msg.add<uint32_t>(leader->getGUID());
	msg.addString(leader->getName());
	msg.add<uint16_t>(leader->getLevel());
	msg.addByte(leader->getVocation()->getClientId());
	msg.addByte(3);

	for (auto memberPair : teamAssemble->membersMap) {
		Player* member = g_game.getPlayerByGUID(memberPair.first);
		if (!member) {
			continue;
		}
		msg.add<uint32_t>(member->getGUID());
		msg.addString(member->getName());
		msg.add<uint16_t>(member->getLevel());
		msg.addByte(member->getVocation()->getClientId());
		msg.addByte(memberPair.second);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::createLeaderTeamFinder(NetworkMessage &msg)
{
	if (!player)
		return;

	std::map<uint32_t, uint8_t> members;
	std::map<uint32_t, TeamFinder*> teamFinder = g_game.getTeamFinderList();
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
	g_game.registerTeamFinderAssemble(player->getGUID(), teamAssemble);
}

void ProtocolGame::parsePartyAnalyzerAction(NetworkMessage &msg)
{
	if (!player) {
		return;
	}

	Party* party = player->getParty();
	if (!party || !party->getLeader() || party->getLeader()->getID() != player->getID()) {
		return;
	}
	
	uint8_t action = msg.getByte();
	switch (action) {
		case 0: { // reset analyzer
			party->resetAnalyzer();
			break;
		}
		case 1: { // Quando Usar quando ta leader
			uint8_t type = 0;
			party->changeAnalyzerPriceType(static_cast<PartyAnalyzer_t>(type));
			break;
		}
		case 2: { // Quando Usar quando ta market
			uint8_t type = 1;
			party->changeAnalyzerPriceType(static_cast<PartyAnalyzer_t>(type));
			break;
		}
		
		default:
			break;
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
			Player* member = g_game.getPlayerByGUID(memberID);
			if (!member)
				return;

			std::map<uint32_t, TeamFinder*> teamFinder = g_game.getTeamFinderList();
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
		Player* leader = g_game.getPlayerByGUID(leaderID);
		if (!leader)
			return;

		std::map<uint32_t, TeamFinder*> teamFinder = g_game.getTeamFinderList();
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
	msg.addByte(0xB9);
	msg.addByte(trackerList.size());
	for (MonsterType *mtype : trackerList)
	{
		uint32_t killAmount = player->getBestiaryKillCount(mtype->info.raceid);
		msg.add<uint16_t>(mtype->info.raceid);
		msg.add<uint32_t>(killAmount);
		msg.add<uint16_t>(mtype->info.bestiaryFirstUnlock);
		msg.add<uint16_t>(mtype->info.bestiarySecondUnlock);
		msg.add<uint16_t>(mtype->info.bestiaryToUnlock);

		if (g_iobestiary().getKillStatus(mtype, killAmount) == 4)
		{
			msg.addByte(4);
		}
		else
		{
			msg.addByte(0);
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
	msg.addByte(0xd8);
	msg.add<uint32_t>(player->getCharmPoints());

	std::vector<Charm *> charmList = g_game.getCharmList();
	msg.addByte(charmList.size());
	for (Charm *c_type : charmList)
	{
		msg.addByte(c_type->id);
		msg.addString(c_type->name);
		msg.addString(c_type->description);
		msg.addByte(0); // Unknown
		msg.add<uint16_t>(c_type->points);
		if (g_iobestiary().hasCharmUnlockedRuneBit(c_type, player->getUnlockedRunesBit()))
		{
			msg.addByte(1);
			uint16_t raceid = player->parseRacebyCharm(c_type->id, false, 0);
			if (raceid > 0)
			{
				msg.addByte(1);
				msg.add<uint16_t>(raceid);
				msg.add<uint32_t>(removeRuneCost);
			}
			else
			{
				msg.addByte(0);
			}
		}
		else
		{
			msg.addByte(0);
			msg.addByte(0);
		}
	}
	msg.addByte(4); // Unknown

	std::list<uint16_t> finishedMonsters = g_iobestiary().getBestiaryFinished(player);
	std::list<charmRune_t> usedRunes = g_iobestiary().getCharmUsedRuneBitAll(player);

	for (charmRune_t charmRune : usedRunes)
	{
		Charm *tmpCharm = g_iobestiary().getBestiaryCharm(charmRune);
		uint16_t tmp_raceid = player->parseRacebyCharm(tmpCharm->id, false, 0);
		finishedMonsters.remove(tmp_raceid);
	}

	msg.add<uint16_t>(finishedMonsters.size());
	for (uint16_t raceid_tmp : finishedMonsters)
	{
		msg.add<uint16_t>(raceid_tmp);
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
		std::map<uint16_t, std::string> mtype_list = g_game.getBestiaryList();
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
	newmsg.addByte(0xd6);
	newmsg.addString(text);
	newmsg.add<uint16_t>(race.size());
	std::map<uint16_t, uint32_t> creaturesKilled = g_iobestiary().getBestiaryKillCountByMonsterIDs(player, race);

	for (auto it_ : race)
	{
		uint16_t raceid_ = it_.first;
		newmsg.add<uint16_t>(raceid_);

		uint8_t progress = 0;
		for (const auto &_it : creaturesKilled)
		{
			if (_it.first == raceid_)
			{
				MonsterType *tmpType = g_monsters.getMonsterType(it_.second);
				if (!tmpType)
				{
					return;
				}
				progress = g_iobestiary().getKillStatus(tmpType, _it.second);
			}
		}

		if (progress > 0)
		{
			newmsg.add<uint16_t>(static_cast<uint16_t>(progress));
		}
		else
		{
			newmsg.addByte(0);
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

	if (!g_config.getBoolean(ConfigManager::PREY_ENABLED)) {
		return;
	}

	addGameTask(&Game::playerPreyAction, player->getID(), slot, action, option, index, raceId);
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
	bool version1280 = false;	
	if (version >= 1280) {
		version1280 = true;
  }
  uint16_t browseId = 0;
	if (version1280) {
		browseId = static_cast<uint16_t>(msg.get<uint8_t>());
	} else {
		browseId = msg.get<uint16_t>();
  }
  if ((version1280 && browseId == MARKETREQUEST_OWN_OFFERS) || (!version1280 && browseId == MARKETREQUEST_OWN_OFFERS_OLD)) {		
		addGameTask(&Game::playerBrowseMarketOwnOffers, player->getID());
	} else if (browseId == MARKETREQUEST_OWN_HISTORY) {		
		addGameTask(&Game::playerBrowseMarketOwnHistory, player->getID());
	} else {
		if (version1280) {
			browseId = msg.get<uint16_t>();
		}

		uint8_t tier = 0;
		const ItemType& it = Item::items.getItemIdByClientId(browseId);
		if (it.id == 0 || it.wareId == 0) {
			return;
		} else if (it.classification > 0 && version1280) {
			tier = msg.getByte(); // item tier
		}
		addGameTask(&Game::playerBrowseMarket, player->getID(), browseId, version1280, tier);
	}
}

void ProtocolGame::parseStoreOpen(NetworkMessage &msg)
{
	uint8_t serviceType = msg.getByte();
	addGameTaskTimed(600, &Game::playerStoreOpen, player->getID(), serviceType);
}

void ProtocolGame::parseStoreRequestOffers(NetworkMessage &message)
{
	//StoreService_t serviceType = SERVICE_STANDARD;
	message.getByte(); // discard service type byte // version >= 1092

	std::string categoryName = message.getString();
	const int16_t index = g_game.gameStore.getCategoryIndexByName(categoryName);

	if (index >= 0)
	{
		addGameTaskTimed(350, &Game::playerShowStoreCategoryOffers, player->getID(),
						 g_game.gameStore.getCategoryOffers().at(index));
	}
	else
	{
		SPDLOG_WARN("[ProtocolGame::parseStoreRequestOffers] - "
                    "Requested category: {} doesn't exists", categoryName);
	}
}

void ProtocolGame::parseStoreBuyOffer(NetworkMessage &message)
{
	uint32_t offerId = message.get<uint32_t>();
	uint8_t productType = message.getByte(); //used only in return of a namechange offer request
	std::string additionalInfo;
	if (productType == ADDITIONALINFO)
	{
		additionalInfo = message.getString();
	}
	addGameTaskTimed(350, &Game::playerBuyStoreOffer, player->getID(), offerId, productType, additionalInfo);
}

void ProtocolGame::parseStoreOpenTransactionHistory(NetworkMessage &msg)
{
	uint8_t entriesPerPage = msg.getByte();
	if (entriesPerPage > 0 && entriesPerPage != GameStore::HISTORY_ENTRIES_PER_PAGE)
	{
		GameStore::HISTORY_ENTRIES_PER_PAGE = entriesPerPage;
	}

	addGameTaskTimed(2000, &Game::playerStoreTransactionHistory, player->getID(), 1);
}

void ProtocolGame::parseStoreRequestTransactionHistory(NetworkMessage &msg)
{
	uint32_t pageNumber = msg.get<uint32_t>();
	addGameTaskTimed(2000, &Game::playerStoreTransactionHistory, player->getID(), pageNumber);
}

void ProtocolGame::parseCoinTransfer(NetworkMessage &msg)
{
	std::string receiverName = msg.getString();
	uint32_t amount = msg.get<uint32_t>();

	if (amount > 0)
	{
		addGameTaskTimed(350, &Game::playerCoinTransfer, player->getID(), receiverName, amount);
	}

	updateCoinBalance();
}

void ProtocolGame::parseMarketCreateOffer(NetworkMessage &msg)
{
	uint8_t type = msg.getByte();
	uint16_t spriteId = msg.get<uint16_t>();
	uint16_t tier = 0;

	const ItemType& it = Item::items.getItemIdByClientId(spriteId);
	if (it.id == 0 || it.wareId == 0) {
		return;
	} else if (it.classification > 0 && version >= 1280) {
		tier = msg.getByte(); // item tier
	}

	uint64_t price = 0;

	uint16_t amount = msg.get<uint16_t>();
	if (version >= 1280) {
		price = msg.get<uint64_t>();
	} else {
		price = static_cast<uint64_t>(msg.get<uint32_t>());
	}
	bool anonymous = (msg.getByte() != 0);
	if (amount > 0 && price > 0) {
		addGameTask(&Game::playerCreateMarketOffer, player->getID(), type, spriteId, amount, tier, price, anonymous);
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
	msg.addByte(0xAD);
	msg.addString(receiver);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendExperienceTracker(int64_t rawExp, int64_t finalExp)
{
	NetworkMessage msg;
	msg.addByte(0xAF);
	msg.add<int64_t>(rawExp);
	msg.add<int64_t>(finalExp);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannelEvent(uint16_t channelId, const std::string &playerName, ChannelEvent_t channelEvent)
{
	NetworkMessage msg;
	msg.addByte(0xF3);
	msg.add<uint16_t>(channelId);
	msg.addString(playerName);
	msg.addByte(channelEvent);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureOutfit(const Creature *creature, const Outfit_t &outfit)
{
	if (!canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x8E);
	msg.add<uint32_t>(creature->getID());
	AddOutfit(msg, outfit);
	if (outfit.lookMount != 0)
	{
		msg.addByte(outfit.lookMountHead);
		msg.addByte(outfit.lookMountBody);
		msg.addByte(outfit.lookMountLegs);
		msg.addByte(outfit.lookMountFeet);
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
	msg.addByte(0x8B);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(14); // type 14 for this
	msg.addByte(icon != CREATUREICON_NONE); // 0 = no icon, 1 = we'll send an icon
	if (icon != CREATUREICON_NONE) {
		msg.addByte(icon);
		msg.addByte(1); // Creature update
		msg.add<uint16_t>(0); // Used for the life in the new quest
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
	msg.addByte(0xEF);
	msg.addByte(time / 60);
	msg.addByte(time % 60);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureWalkthrough(const Creature *creature, bool walkthrough)
{
	if (!canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x92);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(walkthrough ? 0x00 : 0x01);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureShield(const Creature *creature)
{
	if (!canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x91);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(player->getPartyShield(creature->getPlayer()));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureEmblem(const Creature* creature)
{
	if (!canSee(creature)) {
		return;
	}
	// Remove creature from client and re-add to update
	Position pos = creature->getPosition();
	int32_t stackpos = creature->getTile()->getClientIndexOfCreature(player, creature);
	sendRemoveTileThing(pos, stackpos);
	NetworkMessage msg;
	msg.addByte(0x6A);
	msg.addPosition(pos);
	msg.addByte(stackpos);
	AddCreature(msg, creature, false, creature->getID());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureSkull(const Creature *creature)
{
	if (g_game.getWorldType() != WORLD_TYPE_PVP)
	{
		return;
	}

	if (!canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x90);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(player->getSkullClient(creature));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureType(const Creature *creature, uint8_t creatureType)
{
	NetworkMessage msg;
	msg.addByte(0x95);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(creatureType);

	if (player->getOperatingSystem() == CLIENTOS_WINDOWS)
	{
		msg.addByte(creatureType); // type or any byte idk
	}

	if (creatureType == CREATURETYPE_SUMMONPLAYER)
	{
		const Creature *master = creature->getMaster();
		if (master)
		{
			msg.add<uint32_t>(master->getID());
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
	msg.addByte(0x93);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(0x01);
	msg.addByte(color);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTutorial(uint8_t tutorialId)
{
	NetworkMessage msg;
	msg.addByte(0xDC);
	msg.addByte(tutorialId);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddMarker(const Position &pos, uint8_t markType, const std::string &desc)
{
	NetworkMessage msg;
	msg.addByte(0xDD);
	msg.addByte(0x00); // unknow

	msg.addPosition(pos);
	msg.addByte(markType);
	msg.addString(desc);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterNoData(CyclopediaCharacterInfoType_t characterInfoType, uint8_t errorCode)
{
	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(static_cast<uint8_t>(characterInfoType));
	msg.addByte(errorCode);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterBaseInformation()
{
	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_BASEINFORMATION);
	msg.addByte(0x00);
	msg.addString(player->getName());
	msg.addString(player->getVocation()->getVocName());
	msg.add<uint16_t>(player->getLevel());
	AddOutfit(msg, player->getDefaultOutfit(), false);

	msg.addByte(0x00); // hide stamina
	msg.addByte(0x00); // enable store summary & character titles
	msg.addString(""); // character title
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterGeneralStats()
{
	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_GENERALSTATS);
	msg.addByte(0x00);
	msg.add<uint64_t>(player->getExperience());
	msg.add<uint16_t>(player->getLevel());
	msg.addByte(player->getLevelPercent());
	// BaseXPGainRate
	msg.add<uint16_t>(100);
	// TournamentXPFactor
	msg.add<int32_t>(0);
	// LowLevelBonus
	msg.add<uint16_t>(0);
	// XPBoost
	msg.add<uint16_t>(0);
	// StaminaMultiplier(100=x1.0)
	msg.add<uint16_t>(100);
	// xpBoostRemainingTime
	msg.add<uint16_t>(0);
	// canBuyXpBoost
	msg.addByte(0x00);
	msg.add<uint16_t>(std::min<int32_t>(player->getHealth(), std::numeric_limits<uint16_t>::max()));
	msg.add<uint16_t>(std::min<int32_t>(player->getMaxHealth(), std::numeric_limits<uint16_t>::max()));
	msg.add<uint16_t>(std::min<int32_t>(player->getMana(), std::numeric_limits<uint16_t>::max()));
	msg.add<uint16_t>(std::min<int32_t>(player->getMaxMana(), std::numeric_limits<uint16_t>::max()));
	msg.addByte(player->getSoul());
	msg.add<uint16_t>(player->getStaminaMinutes());

	Condition* condition = player->getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT);
	msg.add<uint16_t>(condition ? condition->getTicks() / 1000 : 0x00);
	msg.add<uint16_t>(player->getOfflineTrainingTime() / 60 / 1000);
	msg.add<uint16_t>(player->getSpeed() / 2);
	msg.add<uint16_t>(player->getBaseSpeed() / 2);
	msg.add<uint32_t>(player->getCapacity());
	msg.add<uint32_t>(player->getCapacity());
	msg.add<uint32_t>(player->getFreeCapacity());
	msg.addByte(8);
	msg.addByte(1);
	msg.add<uint16_t>(player->getMagicLevel());
	msg.add<uint16_t>(player->getBaseMagicLevel());
	// loyalty bonus
	msg.add<uint16_t>(player->getBaseMagicLevel());
	msg.add<uint16_t>(player->getMagicLevelPercent() * 100);
	static const uint8_t HardcodedSkillIds[] = { 11, 9, 8, 10, 7, 6, 13 };
	for (uint8_t i = SKILL_FIRST; i < SKILL_CRITICAL_HIT_CHANCE; ++i)
	{
		msg.addByte(HardcodedSkillIds[i]);
		msg.add<uint16_t>(std::min<int32_t>(player->getSkillLevel(i), std::numeric_limits<uint16_t>::max()));
		msg.add<uint16_t>(player->getBaseSkill(i));
		// loyalty bonus
		msg.add<uint16_t>(player->getBaseSkill(i));
		msg.add<uint16_t>(player->getSkillPercent(i) * 100);
	}

	if (version >= 1270) {
		// Version 12.70 start (new items magic level modifiers)
		const Item *weapon = player->getWeapon();
		if (weapon)
		{
			const ItemType &it = Item::items[weapon->getID()];
			if (it.abilities)
			{
				bool found = false;
				for (uint8_t i = 1; i <= 11; i++) {
					if (it.abilities->specializedMagicLevel[i] > 0) {
						found = true;
						msg.addByte(0x01);
						msg.addByte(getCipbiaElement(indexToCombatType(i)));
						msg.add<uint16_t>(static_cast<uint16_t>(it.abilities->specializedMagicLevel[i]));
						break;
					}
				}
				if (!found)
					msg.addByte(0x00);
			}
			else
			{
				msg.addByte(0x00);
			}
		}
		else
		{
			msg.addByte(0x00);
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterCombatStats()
{
	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_COMBATSTATS);
	msg.addByte(0x00);
	for (uint8_t i = SKILL_CRITICAL_HIT_CHANCE; i <= SKILL_LAST; ++i)
	{
		msg.add<uint16_t>(std::min<int32_t>(player->getSkillLevel(i), std::numeric_limits<uint16_t>::max()));
		msg.add<uint16_t>(0);
	}

	if (version >= 1270) {
		msg.add<uint16_t>(static_cast<uint16_t>(player->getCleavePercent())); //cleave %
		msg.add<uint16_t>(static_cast<uint16_t>(player->getMagicShieldCapacityFlat())); //direct bonus
		msg.add<uint16_t>(static_cast<uint16_t>(player->getMagicShieldCapacityPercent())); //percent bonus

		//at range
		for (uint8_t range = 1; range <= 5; range++) {
			msg.add<uint16_t>(static_cast<uint16_t>(player->getPerfectShotDamage(range)));
		}

		msg.add<uint16_t>(static_cast<uint16_t>(player->getReflectFlat(COMBAT_PHYSICALDAMAGE))); //damage deflection
	}

	uint8_t haveBlesses = 0;
	uint8_t blessings = 8;
	for (uint8_t i = 1; i < blessings; ++i)
	{
		if (player->hasBlessing(i))
		{
			++haveBlesses;
		}
	}
	msg.addByte(haveBlesses);
	msg.addByte(blessings);
	const Item *weapon = player->getWeapon();
	if (weapon)
	{
		const ItemType &it = Item::items[weapon->getID()];
		if (it.weaponType == WEAPON_WAND)
		{
			msg.add<uint16_t>(it.maxHitChance);
			msg.addByte(getCipbiaElement(it.combatType));
			msg.addByte(0);
			msg.addByte(0);
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
			msg.add<uint16_t>(maxDamage >> 1);
			msg.addByte(CIPBIA_ELEMENTAL_PHYSICAL);
			if (it.abilities && it.abilities->elementType != COMBAT_NONE)
			{
				msg.addByte(static_cast<uint32_t>(it.abilities->elementDamage) * 100 / attackValue);
				msg.addByte(getCipbiaElement(it.abilities->elementType));
			}
			else
			{
				bool imbueDmg = false;
				Item* weaponNC = player->getWeapon(true);
				if (weaponNC) {
					uint8_t slots = Item::items[weaponNC->getID()].imbuingSlots;
					if (slots > 0) {
						for (uint8_t i = 0; i < slots; i++) {
							uint32_t info = weaponNC->getImbuement(i);
							if (info >> 8) {
								Imbuement* ib = g_imbuements->getImbuement(info & 0xFF);
								if (ib->combatType != COMBAT_NONE) {
									msg.addByte(static_cast<uint32_t>(ib->elementDamage));
									msg.addByte(getCipbiaElement(ib->combatType));
									imbueDmg = true;
									break;
								}
							}
						}
					}
				}
				if (!imbueDmg) {
					msg.addByte(0);
					msg.addByte(0);
				}
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
			msg.add<uint16_t>(maxDamage >> 1);
			msg.addByte(CIPBIA_ELEMENTAL_PHYSICAL);
			if (it.abilities && it.abilities->elementType != COMBAT_NONE)
			{
				msg.addByte(static_cast<uint32_t>(it.abilities->elementDamage) * 100 / attackValue);
				msg.addByte(getCipbiaElement(it.abilities->elementType));
			}
			else
			{
				bool imbueDmg = false;
				Item* weaponNC = player->getWeapon();
				if (weaponNC) {
					uint8_t slots = Item::items[weaponNC->getID()].imbuingSlots;
					if (slots > 0) {
						for (uint8_t i = 0; i < slots; i++) {
							uint32_t info = weaponNC->getImbuement(i);
							if (info >> 8) {
								Imbuement* ib = g_imbuements->getImbuement(info & 0xFF);
								if (ib->combatType != COMBAT_NONE) {
									msg.addByte(static_cast<uint32_t>(ib->elementDamage));
									msg.addByte(getCipbiaElement(ib->combatType));
									imbueDmg = true;
									break;
								}
							}
						}
					}
				}
				if (!imbueDmg) {
					msg.addByte(0);
					msg.addByte(0);
				}
			}
		}
	}
	else
	{
		float attackFactor = player->getAttackFactor();
		int32_t attackSkill = player->getSkillLevel(SKILL_FIST);
		int32_t attackValue = 7;

		int32_t maxDamage = Weapons::getMaxWeaponDamage(player->getLevel(), attackSkill, attackValue, attackFactor, true);
		msg.add<uint16_t>(maxDamage >> 1);
		msg.addByte(CIPBIA_ELEMENTAL_PHYSICAL);
		msg.addByte(0);
		msg.addByte(0);
	}
	msg.add<uint16_t>(player->getArmor());
	msg.add<uint16_t>(player->getDefense());

	uint8_t combats = 0;
	auto startCombats = msg.getBufferPosition();
	msg.skipBytes(1);

	alignas(16) int16_t absorbs[COMBAT_COUNT] = { 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 };
	for (int32_t slot = CONST_SLOT_FIRST; slot <= CONST_SLOT_LAST; ++slot)
	{
		if (!player->isItemAbilityEnabled(static_cast<slots_t>(slot)))
		{
			continue;
		}

		Item *item = player->getInventoryItem(static_cast<slots_t>(slot));
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
			for (uint16_t i = 0; i < COMBAT_COUNT; i++) {
				absorbs[i] *= (std::floor(100 - it.abilities->absorbPercent[i]) / 100.);
			}
		}
		else
		{
			for (uint16_t i = 0; i < COMBAT_COUNT; ++i)
			{
				absorbs[i] += it.abilities->absorbPercent[i];
			}
		}
		uint8_t slots = Item::items[item->getID()].imbuingSlots;
		if (slots > 0) {
			for (uint8_t i = 0; i < slots; i++) {
				uint32_t info = item->getImbuement(i);
				if (info >> 8) {
					Imbuement* ib = g_imbuements->getImbuement(info & 0xFF);
					for (uint16_t i = 0; i < COMBAT_COUNT; i++) {
						const int16_t& absorbPercent2 = ib->absorbPercent[i];

						if (absorbPercent2 != 0) {
							absorbs[i] *= (std::floor(100 - absorbPercent2) / 100.);
						}
					}
				}
			}
		}
	}

	static const Cipbia_Elementals_t cipbiaCombats[] = {
		CIPBIA_ELEMENTAL_PHYSICAL,
		CIPBIA_ELEMENTAL_ENERGY,
		CIPBIA_ELEMENTAL_EARTH,
		CIPBIA_ELEMENTAL_FIRE,
		CIPBIA_ELEMENTAL_UNDEFINED,
		CIPBIA_ELEMENTAL_LIFEDRAIN,
		CIPBIA_ELEMENTAL_UNDEFINED,
		CIPBIA_ELEMENTAL_HEALING,
		CIPBIA_ELEMENTAL_DROWN,
		CIPBIA_ELEMENTAL_ICE,
		CIPBIA_ELEMENTAL_HOLY,
		CIPBIA_ELEMENTAL_DEATH
	};

	for (size_t i = 0; i < COMBAT_COUNT; ++i)
	{
		if (absorbs[i] != 100)
		{
			msg.addByte(cipbiaCombats[i]);
			msg.addByte(std::max<int16_t>(-100, std::min<int16_t>(100, (100 - absorbs[i]) ) ) );
			++combats;
		}
	}

	auto actual = msg.getBufferPosition();

	msg.setBufferPosition(startCombats);
	msg.addByte(combats);

	msg.setBufferPosition(actual);

	if (version >= 1270) {
		msg.addByte(0x00); //1270 loop (concotions ativas)
		//msg.addItemId(42861); //itemid
		//msg.add<uint16_t>(1800); //time
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterRecentDeaths(uint16_t page, uint16_t pages, const std::vector<RecentDeathEntry> &entries)
{
	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_RECENTDEATHS);
	msg.addByte(0x00);
	msg.add<uint16_t>(page);
	msg.add<uint16_t>(pages);
	msg.add<uint16_t>(entries.size());
	for (const RecentDeathEntry &entry : entries)
	{
		msg.add<uint32_t>(entry.timestamp);
		msg.addString(entry.cause);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterRecentPvPKills(uint16_t page, uint16_t pages, const std::vector<RecentPvPKillEntry> &entries)
{
	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_RECENTPVPKILLS);
	msg.addByte(0x00);
	msg.add<uint16_t>(page);
	msg.add<uint16_t>(pages);
	msg.add<uint16_t>(entries.size());
	for (const RecentPvPKillEntry &entry : entries)
	{
		msg.add<uint32_t>(entry.timestamp);
		msg.addString(entry.description);
		msg.addByte(entry.status);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterAchievements()
{
	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_ACHIEVEMENTS);
	msg.addByte(0x00);
	msg.add<uint16_t>(0);
	msg.add<uint16_t>(0);
	msg.add<uint16_t>(0);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterItemSummary()
{
	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_ITEMSUMMARY);
	msg.addByte(0x00);
	msg.add<uint16_t>(0);
	msg.add<uint16_t>(0);
	msg.add<uint16_t>(0);
	msg.add<uint16_t>(0);
	msg.add<uint16_t>(0);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterOutfitsMounts()
{
	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITSMOUNTS);
	msg.addByte(0x00);
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

		msg.add<uint16_t>(outfit.lookType);
		msg.addString(outfit.name);
		msg.addByte(addons);
		if (from == "store")
			msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_STORE);
		else if (from == "quest")
			msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_QUEST);
		else
			msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_NONE);
		if (outfit.lookType == currentOutfit.lookType)
		{
			msg.add<uint32_t>(1000);
		}
		else
		{
			msg.add<uint32_t>(0);
		}
	}
	if (outfitSize > 0)
	{
		msg.addByte(currentOutfit.lookHead);
		msg.addByte(currentOutfit.lookBody);
		msg.addByte(currentOutfit.lookLegs);
		msg.addByte(currentOutfit.lookFeet);
	}

	uint16_t mountSize = 0;
	auto startMounts = msg.getBufferPosition();
	msg.skipBytes(2);
	for (const Mount &mount : g_game.mounts.getMounts())
	{
		const std::string type = mount.type;
		if (player->hasMount(&mount))
		{
			++mountSize;

			msg.add<uint16_t>(mount.clientId);
			msg.addString(mount.name);
			if (type == "store")
				msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_STORE);
			else if (type == "quest")
				msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_QUEST);
			else
				msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_NONE);
			msg.add<uint32_t>(1000);
		}
	}
	if (mountSize > 0)
	{
		msg.addByte(currentOutfit.lookMountHead);
		msg.addByte(currentOutfit.lookMountBody);
		msg.addByte(currentOutfit.lookMountLegs);
		msg.addByte(currentOutfit.lookMountFeet);
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
		msg.add<uint16_t>(familiar.lookType);
		msg.addString(familiar.name);
		if (type == "quest")
			msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_QUEST);
		else
			msg.addByte(CYCLOPEDIA_CHARACTERINFO_OUTFITTYPE_NONE);
		msg.add<uint32_t>(0);
	}

	msg.setBufferPosition(startOutfits);
	msg.add<uint16_t>(outfitSize);
	msg.setBufferPosition(startMounts);
	msg.add<uint16_t>(mountSize);
	msg.setBufferPosition(startFamiliars);
	msg.add<uint16_t>(familiarsSize);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterStoreSummary()
{
	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_STORESUMMARY);
	msg.addByte(0x00);
	// Remaining Store Xp Boost Time
	msg.add<uint32_t>(player->getExpBoostStamina());
	// RemainingDailyRewardXpBoostTime
	msg.add<uint32_t>(0);
	msg.addByte(0x00);
	msg.addByte(0x00);
	msg.addByte(0x00);
	msg.addByte(0x00);
	msg.addByte(0x00);
	msg.addByte(0x00);
	msg.addByte(0x00);
	msg.addByte(0x00);
	msg.add<uint16_t>(0);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterInspection()
{
	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_INSPECTION);
	msg.addByte(0x00);
	uint8_t inventoryItems = 0;
	auto startInventory = msg.getBufferPosition();
	msg.skipBytes(1);
	for (std::underlying_type<slots_t>::type slot = CONST_SLOT_FIRST; slot <= CONST_SLOT_LAST; slot++)
	{
		Item *inventoryItem = player->getInventoryItem(static_cast<slots_t>(slot));
		if (inventoryItem)
		{
			++inventoryItems;

			msg.addByte(slot);
			msg.addString(inventoryItem->getName());
			AddItem(msg, inventoryItem);
			msg.addByte(0);

			auto descriptions = Item::getDescriptions(Item::items[inventoryItem->getID()], inventoryItem);
			msg.addByte(descriptions.size());
			for (const auto &description : descriptions)
			{
				msg.addString(description.first);
				msg.addString(description.second);
			}
		}
	}
	msg.addString(player->getName());
	AddOutfit(msg, player->getDefaultOutfit(), false);

	msg.addByte(3);
	msg.addString("Level");
	msg.addString(std::to_string(player->getLevel()));
	msg.addString("Vocation");
	msg.addString(player->getVocation()->getVocName());
	msg.addString("Outfit");

	const Outfit *outfit = Outfits::getInstance().getOutfitByLookType(player->getSex(),
																	  player->getDefaultOutfit().lookType);
	if (outfit)
	{
		msg.addString(outfit->name);
	}
	else
	{
		msg.addString("unknown");
	}
	msg.setBufferPosition(startInventory);
	msg.addByte(inventoryItems);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterBadges()
{
	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_BADGES);
	msg.addByte(0x00);
	// ShowAccountInformation
	msg.addByte(0x01);
	// if ShowAccountInformation show IsOnline, IsPremium, character title, badges
	// IsOnline
	msg.addByte(0x01);
	// IsPremium (GOD has always 'Premium')
	msg.addByte(player->isPremium() ? 0x01 : 0x00);
	// character title
	msg.addString("");
	// badges
	msg.addByte(0x00);
	// Todo badges loop
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterTitles()
{
	NetworkMessage msg;
	msg.addByte(0xDA);
	msg.addByte(CYCLOPEDIA_CHARACTERINFO_TITLES);
	msg.addByte(0x00);
	msg.addByte(0x00);
	msg.addByte(0x00);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTournamentLeaderboard()
{
	NetworkMessage msg;
	msg.addByte(0xC5);
	msg.addByte(0);
	msg.addByte(0x01);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendReLoginWindow(uint8_t unfairFightReduction)
{
	NetworkMessage msg;
	msg.addByte(0x28);
	msg.addByte(0x00);
	msg.addByte(unfairFightReduction);
	msg.addByte(0x00); // use death redemption (boolean)
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
	msg.addByte(0x9F);
	if (player->isPremium())
	{
		msg.addByte(1);
		msg.add<uint32_t>(time(nullptr) + (player->premiumDays * 86400));
	}
	else
	{
		msg.addByte(0);
		msg.add<uint32_t>(0);
	}
	msg.addByte(player->getVocation()->getClientId());

	// Prey window
	if (player->getVocation()->getId() == 0)
	{
		msg.addByte(0);
	}
	else
	{
		msg.addByte(1); // has reached Main (allow player to open Prey window)
	}

	std::list<uint16_t> spellsList = g_spells->getSpellsByVocation(player->getVocationId());
	msg.add<uint16_t>(spellsList.size());
	for (uint16_t sid : spellsList)
	{
		msg.addByte(sid);
	}
	msg.addByte(player->getVocation()->getMagicShield()); // bool - determine whether magic shield is active or not
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

	msg.addByte(0x9C);

	msg.add<uint16_t>((blessCount >= 5) ? (flag | 1) : flag);		  //Show up the glowing effect in items if have all blesses
	msg.addByte((blessCount >= 7) ? 3 : ((blessCount >= 5) ? 2 : 1)); // 1 = Disabled | 2 = normal | 3 = green
	// msg.add<uint16_t>(0);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendStoreHighlight()
{
	NetworkMessage msg;
	bool haveSale = g_game.gameStore.haveCategoryByState(StoreState_t::SALE);
	bool haveNewItem = g_game.gameStore.haveCategoryByState(StoreState_t::NEW);
	msg.addByte(0x19);
	msg.addByte((haveSale) ? 1 : 0);
	msg.addByte((haveNewItem) ? 1 : 0);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPremiumTrigger()
{
	if (!g_config.getBoolean(ConfigManager::FREE_PREMIUM))
	{
		NetworkMessage msg;
		msg.addByte(0x9E);
		msg.addByte(16);
		for (uint16_t i = 0; i <= 15; i++)
		{
			//PREMIUM_TRIGGER_TRAIN_OFFLINE = false, PREMIUM_TRIGGER_XP_BOOST = false, PREMIUM_TRIGGER_MARKET = false, PREMIUM_TRIGGER_VIP_LIST = false, PREMIUM_TRIGGER_DEPOT_SPACE = false, PREMIUM_TRIGGER_INVITE_PRIVCHAT = false
			msg.addByte(0x01);
		}
		writeToOutputBuffer(msg);
	}
}

// Send preyInfo
void ProtocolGame::closeImbuingWindow()
{
	NetworkMessage msg;
	msg.addByte(0xEC);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTextMessage(const TextMessage &message)
{
	NetworkMessage msg;
	msg.addByte(0xB4);
	msg.addByte(message.type);
	switch (message.type)
	{
	case MESSAGE_DAMAGE_DEALT:
	case MESSAGE_DAMAGE_RECEIVED:
	case MESSAGE_DAMAGE_OTHERS:
	{
		msg.addPosition(message.position);
		msg.add<uint32_t>(message.primary.value);
		msg.addByte(message.primary.color);
		msg.add<uint32_t>(message.secondary.value);
		msg.addByte(message.secondary.color);
		break;
	}
	case MESSAGE_HEALED:
	case MESSAGE_HEALED_OTHERS:
	case MESSAGE_EXPERIENCE:
	case MESSAGE_EXPERIENCE_OTHERS:
	{
		msg.addPosition(message.position);
		msg.add<uint32_t>(message.primary.value);
		msg.addByte(message.primary.color);
		break;
	}
	case MESSAGE_GUILD:
	case MESSAGE_PARTY_MANAGEMENT:
	case MESSAGE_PARTY:
		msg.add<uint16_t>(message.channelId);
		break;
	default:
	{
		break;
	}
	}
	msg.addString(message.text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendClosePrivate(uint16_t channelId)
{
	NetworkMessage msg;
	msg.addByte(0xB3);
	msg.add<uint16_t>(channelId);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatePrivateChannel(uint16_t channelId, const std::string &channelName)
{
	NetworkMessage msg;
	msg.addByte(0xB2);
	msg.add<uint16_t>(channelId);
	msg.addString(channelName);
	msg.add<uint16_t>(0x01);
	msg.addString(player->getName());
	msg.add<uint16_t>(0x00);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannelsDialog()
{
	NetworkMessage msg;
	msg.addByte(0xAB);

	const ChannelList &list = g_chat->getChannelList(*player);
	msg.addByte(list.size());
	for (ChatChannel *channel : list)
	{
		msg.add<uint16_t>(channel->getId());
		msg.addString(channel->getName());
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannel(uint16_t channelId, const std::string &channelName, const UsersMap *channelUsers, const InvitedMap *invitedUsers)
{
	NetworkMessage msg;
	msg.addByte(0xAC);

	msg.add<uint16_t>(channelId);
	msg.addString(channelName);

	if (channelUsers)
	{
		msg.add<uint16_t>(channelUsers->size());
		for (const auto &it : *channelUsers)
		{
			msg.addString(it.second->getName());
		}
	}
	else
	{
		msg.add<uint16_t>(0x00);
	}

	if (invitedUsers)
	{
		msg.add<uint16_t>(invitedUsers->size());
		for (const auto &it : *invitedUsers)
		{
			msg.addString(it.second->getName());
		}
	}
	else
	{
		msg.add<uint16_t>(0x00);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannelMessage(const std::string &author, const std::string &text, SpeakClasses type, uint16_t channel)
{
	NetworkMessage msg;
	msg.addByte(0xAA);
	msg.add<uint32_t>(0x00);
	msg.addString(author);
	msg.add<uint16_t>(0x00);
	msg.addByte(type);
	msg.add<uint16_t>(channel);
	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendIcons(uint32_t icons)
{
	NetworkMessage msg;
	msg.addByte(0xA2);
	msg.add<uint32_t>(icons);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUnjustifiedPoints(const uint8_t &dayProgress, const uint8_t &dayLeft, const uint8_t &weekProgress, const uint8_t &weekLeft, const uint8_t &monthProgress, const uint8_t &monthLeft, const uint8_t &skullDuration)
{
	NetworkMessage msg;
	msg.addByte(0xB7);
	msg.addByte(dayProgress);
	msg.addByte(dayLeft);
	msg.addByte(weekProgress);
	msg.addByte(weekLeft);
	msg.addByte(monthProgress);
	msg.addByte(monthLeft);
	msg.addByte(skullDuration);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendContainer(uint8_t cid, const Container *container, bool hasParent, uint16_t firstIndex)
{
	NetworkMessage msg;
	msg.addByte(0x6E);

	msg.addByte(cid);

	if (container->getID() == ITEM_BROWSEFIELD)
	{
		AddItem(msg, ITEM_BAG, 1);
		msg.addString("Browse Field");
	}
	else
	{
		AddItem(msg, container);
		msg.addString(container->getName());
	}

	msg.addByte(container->capacity());

	msg.addByte(hasParent ? 0x01 : 0x00);

	msg.addByte(0x00); // To-do: Depot Find (boolean)

	msg.addByte(container->isUnlocked() ? 0x01 : 0x00);	   // Drag and drop
	msg.addByte(container->hasPagination() ? 0x01 : 0x00); // Pagination

	uint32_t containerSize = container->size();
	msg.add<uint16_t>(containerSize);
	msg.add<uint16_t>(firstIndex);

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
		msg.addByte(0x00);
	}
	else
	{
		msg.addByte(std::min<uint32_t>(maxItemsToSend, containerSize));

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
	msg.addByte(0xC0);
	msg.addByte(player->quickLootFallbackToMainContainer ? 1 : 0);
	std::map<ObjectCategory_t, Container *> quickLoot;
	for (auto it : player->quickLootContainers)
	{
		if (it.second && !it.second->isRemoved())
		{
			quickLoot[it.first] = it.second;
		}
	}
	msg.addByte(quickLoot.size());
	for (auto it : quickLoot)
	{
		msg.addByte(it.first);
		msg.add<uint16_t>(it.second->getClientID());
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendLootStats(Item *item, uint8_t count)
{
	if (!item)
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xCF);
	AddItem(msg, item);
	msg.addString(item->getName());
	item->setIsLootTrackeable(false);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendShop(Npc *npc, const ShopInfoList &itemList)
{
	NetworkMessage msg;
	msg.addByte(0x7A);
	msg.addString(npc->getName());
	msg.add<uint16_t>(npc->getCurrencyTrading());

	msg.addString(std::string()); // ??

	uint16_t itemsToSend = std::min<size_t>(itemList.size(), std::numeric_limits<uint16_t>::max());
	msg.add<uint16_t>(itemsToSend);

	uint16_t i = 0;
	for (auto it = itemList.begin(); i < itemsToSend; ++it, ++i) {
		AddShopItem(msg, *it);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCloseShop()
{
	NetworkMessage msg;
	msg.addByte(0x7C);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendClientCheck()
{
	NetworkMessage msg;
	msg.addByte(0x63);
	msg.add<uint32_t>(1);
	msg.addByte(1);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendGameNews()
{
	NetworkMessage msg;
	msg.addByte(0x98);
	msg.add<uint32_t>(1); // unknown
	msg.addByte(1);		  //(0 = open | 1 = highlight)
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendResourcesBalance(uint64_t money /*= 0*/, uint64_t bank /*= 0*/, uint64_t preyCards /*= 0*/, uint64_t taskHunting /*= 0*/)
{
  sendResourceBalance(RESOURCETYPE_BANK_GOLD, bank);
	sendResourceBalance(RESOURCETYPE_INVENTORY_GOLD, money);
	sendResourceBalance(RESOURCETYPE_PREY_BONUS_REROLLS, preyCards);
	sendResourceBalance(RESOURCE_TASK_HUNTING, taskHunting);
}

void ProtocolGame::sendResourceBalance(ResourceTypes_t type, uint64_t amount)
{
	 NetworkMessage msg;
    msg.reset();
    msg.addByte(0xEE);
    msg.addByte(type);

    // fix overflow in forge UI
    switch(type) {
        case RESOURCE_FORGE_DUST:
            amount = std::min<uint64_t>(std::numeric_limits<uint8_t>::max(), amount);
            break;
        case RESOURCE_FORGE_SLIVERS:
        case RESOURCE_FORGE_CORES:
            amount = std::min<uint64_t>(std::numeric_limits<uint16_t>::max(), amount);
            break;
        default:
            break;
    }

    //std::cout << "testando " << amount << std::endl;
    msg.add<uint64_t>(amount);
    writeToOutputBuffer(msg);
}

void ProtocolGame::sendSaleItemList(const std::vector<ShopInfo>& shop, const TieredItemsCountMap& inventoryMap)
{
	if (!player) {
		return;
	}
	//Since we already have full inventory map we shouldn't call getMoney here - it is simply wasting cpu power
	uint64_t playerMoney = 0;
	TieredItemsCountMap::const_iterator it = inventoryMap.find({ITEM_CRYSTAL_COIN, 0});
	if (it != inventoryMap.end()) {
		playerMoney += static_cast<uint64_t>(it->second) * 10000;
	}
	it = inventoryMap.find({ITEM_PLATINUM_COIN, 0});
	if (it != inventoryMap.end()) {
		playerMoney += static_cast<uint64_t>(it->second) * 100;
	}
	it = inventoryMap.find({ITEM_GOLD_COIN, 0});
	if (it != inventoryMap.end()) {
		playerMoney += static_cast<uint64_t>(it->second);
	}
	
	NetworkMessage msg;
	msg.reset();

	if (version >= 1100) {
		sendResourceBalance(RESOURCETYPE_BANK_GOLD, player->bankBalance);
		sendResourceBalance(RESOURCETYPE_INVENTORY_GOLD, playerMoney);
	}

	msg.addByte(0x7B);
	msg.add<uint64_t>(player->bankBalance + playerMoney); // deprecated and ignored by QT client. OTClient still uses it.

	uint8_t itemsToSend = 0;
	auto msgPosition = msg.getBufferPosition();
	msg.skipBytes(1);

	for (const ShopInfo& shopInfo : shop) {
		if (shopInfo.sellPrice == 0) {
			continue;
		}

		uint32_t index = static_cast<uint32_t>(shopInfo.itemId);
		if (Item::items[shopInfo.itemId].isFluidContainer()) {
			index |= (static_cast<uint32_t>(shopInfo.subType) << 16);
		}

		it = inventoryMap.find({index, 0});
		if (it != inventoryMap.end() && it->second > 0) {
			msg.addItemId(shopInfo.itemId);
			msg.addByte(std::min<uint32_t>(it->second, std::numeric_limits<uint8_t>::max()));
			if (++itemsToSend >= 0xFF) {
				break;
			}
		}
	}

	msg.setBufferPosition(msgPosition);
	msg.addByte(itemsToSend);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketEnter(uint32_t depotId)
{
	NetworkMessage msg;
	msg.addByte(0xF6);
	msg.addByte(std::min<uint32_t>(IOMarket::getPlayerOfferCount(player->getGUID()), std::numeric_limits<uint8_t>::max()));

	Container* depotChest = player->lastDepotChest;
    if (!depotChest) {
        msg.add<uint16_t>(0x00);
        writeToOutputBuffer(msg);
        return;
    }

	player->setInMarket(true);

	TieredItemsCountMap depotItems;
	std::forward_list<Container*> containerList { depotChest, player->getInbox() };

	do {
        Container* container = containerList.front();
        containerList.pop_front();

        for (Item* item : container->getItemList()) {
            Container* c = item->getContainer();
            if (c && !c->empty()) {
                containerList.push_front(c);
                continue;
            }

            const ItemType& itemType = Item::items[item->getID()];
            if (itemType.wareId == 0) {
                continue;
            }
						
						if(itemType.id == 8293) {
							continue;
						}

            if (c && (!itemType.isContainer() || c->capacity() != itemType.maxItems)) {
                continue;
            }

            if (!item->hasMarketAttributes()) {
                continue;
            } 

            depotItems[{itemType.id, item->getTier()}] += Item::countByType(item, -1);
        }
    } while (!containerList.empty());

	StashItemList stashToSend = player->getStashItems();
	uint16_t size = 0;
	for (auto item : stashToSend)
	{
		size += ceil(item.second);
	}

	do
	{
		for (auto item : stashToSend)
		{
			const ItemType &itemType = Item::items[Item::items.getItemIdByClientId(item.first).id];
			if (itemType.wareId == 0) {
				continue;
			}

			size = size - item.second;
			depotItems[{itemType.wareId, 0/*stash sempre 0*/}] += item.second; 
		}
	} while (size > 0);
	uint16_t itemsToSend = std::min<size_t>(depotItems.size(), std::numeric_limits<uint16_t>::max());
	msg.add<uint16_t>(itemsToSend);
	/*
	uint16_t i = 0;
	for (std::map<uint16_t, uint32_t>::const_iterator it = depotItems.begin(); i < itemsToSend; ++it, ++i)
	{
		msg.add<uint16_t>(it->first);
		msg.add<uint16_t>(std::min<uint32_t>(0xFFFF, it->second));
	}
	*/
	bool version1280 = false;
    if (version >= 1280) {
    	version1280 = true;
    }

    uint16_t i = 0;  	
    for (auto it = depotItems.begin(); i < itemsToSend; ++it, ++i) {
	    const ItemType& itemType = Item::items[it->first.first];
		msg.add<uint16_t>(itemType.wareId);
        if (version1280) {
			if (itemType.classification > 0) {
				msg.addByte(it->first.second);
			}
        }
        msg.add<uint16_t>(std::min<uint32_t>(0xFFFF, it->second));
    }

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
	msg.addByte(0xF2);
	msg.addByte(0x01);
	writeToOutputBuffer(msg);

	msg.reset();

	// send update
	msg.addByte(0xDF);
	msg.addByte(0x01);

	msg.add<uint32_t>(player->coinBalance); // Normal Coins
	msg.add<uint32_t>(player->coinBalance); // Transferable Coins
	msg.add<uint32_t>(player->coinBalance); // Reserved Auction Coins
	msg.add<uint32_t>(player->tournamentCoinBalance);					// Tournament Coins

	writeToOutputBuffer(msg);
}

void ProtocolGame::updateCoinBalance()
{
	if (!player) {
		return;
	}
	g_dispatcher.addTask(
		createTask(std::bind([](uint32_t playerId) {
			Player* threadPlayer = g_game.getPlayerByID(playerId);
			if (threadPlayer) {
				account::Account account;
				account.LoadAccountDB(threadPlayer->getAccount());
				uint32_t coins;
				account.GetCoins(&coins);
				threadPlayer->coinBalance = coins;
				uint32_t tournamentCoins;
				account.GetTournamentCoins(&tournamentCoins);
				threadPlayer->tournamentCoinBalance = tournamentCoins;
				threadPlayer->sendCoinBalance();
			}
		},
		player->getID())));
}

void ProtocolGame::sendMarketLeave()
{
	NetworkMessage msg;
	msg.addByte(0xF7);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketBrowseItem(uint16_t itemId, const MarketOfferList& buyOffers, const MarketOfferList& sellOffers, uint8_t tier)
{
	// updateCoinBalance();
  
  bool version1280 = false;
  if (version >= 1280) {
    version1280 = true;
  }
  
  NetworkMessage msg;
  msg.addByte(0xF9);
  if (version1280) {
    msg.addByte(MARKETREQUEST_ITEM);
  }
  msg.addItemId(itemId);
  
  if (version1280) {
		if (Item::items[itemId].classification > 0) {
			msg.addByte(tier); // item tier
		}
  }
  
  msg.add<uint32_t>(buyOffers.size());
  
  for (const MarketOffer& offer : buyOffers) {    	
        msg.add<uint32_t>(offer.timestamp);
        msg.add<uint16_t>(offer.counter);
        msg.add<uint16_t>(offer.amount);
        if (version1280) {
	        msg.add<uint64_t>(offer.price);
	    } else {    	
	        msg.add<uint32_t>(offer.price);
	    }
        msg.addString(offer.playerName);
    }

    msg.add<uint32_t>(sellOffers.size());
    for (const MarketOffer& offer : sellOffers) {
        msg.add<uint32_t>(offer.timestamp);
        msg.add<uint16_t>(offer.counter);
        msg.add<uint16_t>(offer.amount);
        if (version1280) {
	        msg.add<uint64_t>(offer.price);
	    } else {    	
	        msg.add<uint32_t>(offer.price);
	    }
        msg.addString(offer.playerName);
    }    

    writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketAcceptOffer(const MarketOfferEx &offer)
{
	NetworkMessage msg;
  
  bool version1280 = false;
  if (version >= 1280) {
    version1280 = true;
  }
  msg.addByte(0xF9);
  if (version1280) {
    msg.addByte(MARKETREQUEST_ITEM);
  }
  
  msg.addItemId(offer.itemId);
  
  if (version1280) {    	
		if (Item::items[offer.itemId].classification > 0) {
			msg.addByte(offer.tier);
		}
    }

	if (offer.type == MARKETACTION_BUY) {
      msg.add<uint32_t>(0x01);
      msg.add<uint32_t>(offer.timestamp);
      msg.add<uint16_t>(offer.counter);
      msg.add<uint16_t>(offer.amount);
      if (version1280) {
        msg.add<uint64_t>(offer.price);
    } else {
      msg.add<uint32_t>(offer.price);
    }
      msg.addString(offer.playerName);
      msg.add<uint32_t>(0x00);
  } else {
      msg.add<uint32_t>(0x00);
      msg.add<uint32_t>(0x01);
      msg.add<uint32_t>(offer.timestamp);
      msg.add<uint16_t>(offer.counter);
      msg.add<uint16_t>(offer.amount);
      if (version1280) {
        msg.add<uint64_t>(offer.price);
    } else {
      msg.add<uint32_t>(offer.price);
    }
      msg.addString(offer.playerName);
  }
  
  writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketBrowseOwnOffers(const MarketOfferList &buyOffers, const MarketOfferList &sellOffers)
{
	NetworkMessage msg;
	bool version1280 = false;
  if (version >= 1280) {
    version1280 = true;
  }
  msg.addByte(0xF9);
  if (version1280) {
    msg.addByte(MARKETREQUEST_OWN_OFFERS);
  } else {
    msg.add<uint16_t>(MARKETREQUEST_OWN_OFFERS_OLD);
  }
  msg.add<uint32_t>(buyOffers.size());
  
  for (const MarketOffer& offer : buyOffers) {
      msg.add<uint32_t>(offer.timestamp);
      msg.add<uint16_t>(offer.counter);
      msg.addItemId(offer.itemId);
      if (version1280) {
    if (Item::items[offer.itemId].classification > 0) {
      msg.addByte(offer.tier);
    }
      }
      msg.add<uint16_t>(offer.amount);
      if (version1280) { 
        msg.add<uint64_t>(offer.price);
      } else {
        msg.add<uint32_t>(offer.price);
      }
  }

  msg.add<uint32_t>(sellOffers.size());
  for (const MarketOffer& offer : sellOffers) {
      msg.add<uint32_t>(offer.timestamp);
      msg.add<uint16_t>(offer.counter);
      msg.addItemId(offer.itemId);
      if (version1280) {
    if (Item::items[offer.itemId].classification > 0) {
      msg.addByte(offer.tier);
    }
      }
      msg.add<uint16_t>(offer.amount);
      if (version1280) { 
        msg.add<uint64_t>(offer.price);
      } else {
        msg.add<uint32_t>(offer.price);
      }
  }

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketCancelOffer(const MarketOfferEx &offer)
{
	NetworkMessage msg;
	bool version1280 = false;
  if (version >= 1280) {
    version1280 = true;
  }
  msg.addByte(0xF9);
  if (version1280) {
    msg.addByte(MARKETREQUEST_OWN_OFFERS);
  } else {
    msg.add<uint16_t>(MARKETREQUEST_OWN_OFFERS);
  }

  if (offer.type == MARKETACTION_BUY) {
      msg.add<uint32_t>(0x01);
      msg.add<uint32_t>(offer.timestamp);
      msg.add<uint16_t>(offer.counter);
      msg.addItemId(offer.itemId);
      if (version1280) {
    if (Item::items[offer.itemId].classification > 0) {
      msg.addByte(offer.tier);
    }
  }
      msg.add<uint16_t>(offer.amount);
      if (version1280) {
        msg.add<uint64_t>(offer.price);
      } else {
        msg.add<uint32_t>(offer.price);
      }
      msg.add<uint32_t>(0x00);
  } else {
      msg.add<uint32_t>(0x00);
      msg.add<uint32_t>(0x01);
      msg.add<uint32_t>(offer.timestamp);
      msg.add<uint16_t>(offer.counter);
      msg.addItemId(offer.itemId);
      if (version1280) {
    if (Item::items[offer.itemId].classification > 0) {
      msg.addByte(offer.tier);
    }
  }
      msg.add<uint16_t>(offer.amount);
      if (version1280) {
        msg.add<uint64_t>(offer.price);
      } else {
        msg.add<uint32_t>(offer.price);
      }
  }

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketBrowseOwnHistory(const HistoryMarketOfferList &buyOffers, const HistoryMarketOfferList &sellOffers)
{
	bool version1280 = false;
    if (version >= 1280) {
    	version1280 = true;
    }
    uint32_t i = 0;
    std::map<uint32_t, uint16_t> counterMap;
    uint32_t buyOffersToSend = std::min<uint32_t>(buyOffers.size(), 810 + std::max<int32_t>(0, 810 - sellOffers.size()));
    uint32_t sellOffersToSend = std::min<uint32_t>(sellOffers.size(), 810 + std::max<int32_t>(0, 810 - buyOffers.size()));

    NetworkMessage msg;

    msg.addByte(0xF9);
    if (version1280) {
    	msg.addByte(MARKETREQUEST_OWN_HISTORY);
    } else {
    	msg.add<uint16_t>(MARKETREQUEST_OWN_HISTORY_OLD);
    }

    msg.add<uint32_t>(buyOffersToSend);
    for (HistoryMarketOfferList::const_iterator it = buyOffers.begin(); i < buyOffersToSend; ++it, ++i) {
      msg.add<uint32_t>(it->timestamp);
      msg.add<uint16_t>(counterMap[it->timestamp]++);
      msg.addItemId(it->itemId);
      if (version1280) {
    if (Item::items[it->itemId].classification > 0) {
      msg.addByte(it->tier);
    }
      }
      msg.add<uint16_t>(it->amount);
      if (version1280) {
        msg.add<uint64_t>(it->price);
      } else {
        msg.add<uint32_t>(it->price);
      }
      msg.addByte(it->state);
  }

  counterMap.clear();
  i = 0;

  msg.add<uint32_t>(sellOffersToSend);
  for (HistoryMarketOfferList::const_iterator it = sellOffers.begin(); i < sellOffersToSend; ++it, ++i) {
      msg.add<uint32_t>(it->timestamp);
      msg.add<uint16_t>(counterMap[it->timestamp]++);
      msg.addItemId(it->itemId);
      if (version1280) {
    if (Item::items[it->itemId].classification > 0) {
      msg.addByte(it->tier);
    }
      }
      msg.add<uint16_t>(it->amount);
      if (version1280) {
        msg.add<uint64_t>(it->price);
      } else {
        msg.add<uint32_t>(it->price);
      }
      msg.addByte(it->state);
  }

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketDetail(uint16_t itemId, uint8_t tier)
{
	NetworkMessage msg;
  bool version1280 = false;
  if (version >= 1280) {
    version1280 = true;
  }
	msg.addByte(0xF8);
	msg.addItemId(itemId);

	const ItemType &it = Item::items[itemId];
  
  if (version1280) {    	
    if (it.classification > 0) { 
			msg.addByte(tier); // item tier
		}
  }
  
	if (it.armor != 0)
	{
		msg.addString(std::to_string(it.armor));
	}
	else
	{
		msg.add<uint16_t>(0x00);
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
			msg.addString(ss.str());
		}
		else
		{
			msg.addString(std::to_string(it.attack));
		}
	}
	else
	{
		msg.add<uint16_t>(0x00);
	}

	if (it.isContainer())
	{
		msg.addString(std::to_string(it.maxItems));
	}
	else
	{
		msg.add<uint16_t>(0x00);
	}

	if (it.defense != 0)
	{
		if (it.extraDefense != 0)
		{
			std::ostringstream ss;
			ss << it.defense << ' ' << std::showpos << it.extraDefense << std::noshowpos;
			msg.addString(ss.str());
		}
		else
		{
			msg.addString(std::to_string(it.defense));
		}
	}
	else
	{
		msg.add<uint16_t>(0x00);
	}

	if (!it.description.empty())
	{
		const std::string &descr = it.description;
		if (descr.back() == '.')
		{
			msg.addString(std::string(descr, 0, descr.length() - 1));
		}
		else
		{
			msg.addString(descr);
		}
	}
	else
	{
		msg.add<uint16_t>(0x00);
	}

	if (it.decayTime != 0)
	{
		std::ostringstream ss;
		ss << it.decayTime << " seconds";
		msg.addString(ss.str());
	}
	else
	{
		msg.add<uint16_t>(0x00);
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

		msg.addString(ss.str());
	}
	else
	{
		msg.add<uint16_t>(0x00);
	}

	if (it.minReqLevel != 0)
	{
		msg.addString(std::to_string(it.minReqLevel));
	}
	else
	{
		msg.add<uint16_t>(0x00);
	}

	if (it.minReqMagicLevel != 0)
	{
		msg.addString(std::to_string(it.minReqMagicLevel));
	}
	else
	{
		msg.add<uint16_t>(0x00);
	}

	msg.addString(it.vocationString);

	msg.addString(it.runeSpellName);

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

			ss << getSkillName(i) << ' ' << std::showpos << it.abilities->skills[i] << std::noshowpos << '%';
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

		for (uint8_t i = 1; i <= 11; i++) {
			if (it.abilities->specializedMagicLevel[i]) {
				if (separator)
				{
					ss << ", ";
				}
				else
				{
					separator = true;
				}

				ss << getCombatName(indexToCombatType(i)) << " magic level " << std::showpos << it.abilities->specializedMagicLevel[i] << std::noshowpos;
			}
		}

		if (it.abilities->speed != 0)
		{
			if (separator)
			{
				ss << ", ";
			}

			ss << "speed " << std::showpos << (it.abilities->speed >> 1) << std::noshowpos;
		}

		msg.addString(ss.str());
	}
	else
	{
		msg.add<uint16_t>(0x00);
	}

	if (it.charges != 0)
	{
		msg.addString(std::to_string(it.charges));
	}
	else
	{
		msg.add<uint16_t>(0x00);
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

	msg.addString(weaponName);

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
		msg.addString(ss.str());
	}
	else
	{
		msg.add<uint16_t>(0x00);
	}

	uint8_t slot = Item::items[itemId].imbuingSlots;
	if (slot > 0)
	{
		msg.addString(std::to_string(slot));
	}
	else
	{
		msg.add<uint16_t>(0x00);
	}
	
	if (version >= 1270) {
		//cleave
		if (it.abilities) {

			std::ostringstream string;

			if (it.abilities->magicShieldCapacityFlat > 0)
			{
				string.clear();
				string << std::showpos << it.abilities->magicShieldCapacityFlat << std::noshowpos << " and " << it.abilities->magicShieldCapacityPercent << "%";
				msg.addString(string.str());
			}
			else {
				msg.add<uint16_t>(0x00);
			}

			if (it.abilities->cleavePercent > 0) {
				string.clear();
				string << it.abilities->cleavePercent << "%";
				msg.addString(string.str());
			} else {
				msg.add<uint16_t>(0x00);
			}

			if (it.abilities->reflectFlat[COMBAT_PHYSICALDAMAGE] > 0) {
				string.clear();
				string << it.abilities->reflectFlat[COMBAT_PHYSICALDAMAGE];
				msg.addString(string.str());
			} else {
				msg.add<uint16_t>(0x00);
			}
			

			if (it.abilities->perfectShotDamage > 0) {
				string.clear();
				string << std::showpos << it.abilities->perfectShotDamage << std::noshowpos << " at " << it.abilities->perfectShotRange << "%";
				msg.addString(string.str());
			} else {
				msg.add<uint16_t>(0x00);
			}



		} else {
			//cleave
			msg.add<uint16_t>(0x00);

			//magic shield capacity
			msg.add<uint16_t>(0x00);

			//perfect shot
			msg.add<uint16_t>(0x00);

			//damage deflect
			msg.add<uint16_t>(0x00);
		}
	}
  
  if (version1280) {
    if (it.classification > 0) {
      uint8_t classifications = it.classification;
      msg.addString(std::to_string(classifications));
    } else {
      msg.add<uint16_t>(0); // Classification
    }
    if (tier > 0) {	    	
    skills_t skillExaltationForge = SKILL_FIRST;
    float bonusValueExaltationForge = 0;
    it.getTierBonus(tier, skillExaltationForge, bonusValueExaltationForge);

    std::ostringstream ss;
    ss << static_cast<uint16_t>(tier) << " (" << std::setprecision(2) << std::fixed << (bonusValueExaltationForge) << "% " << getSkillName(skillExaltationForge) << ")";
        msg.addString(ss.str()); 	// tier
    } else {
      msg.add<uint16_t>(0); 		// tier
    }
	}

	MarketStatistics* statistics = IOMarket::getInstance()->getPurchaseStatistics(itemId, tier);
    if (statistics) {
        msg.addByte(0x01);
		msg.add<uint32_t>(statistics->numTransactions);
		if (version1280) {
	        msg.add<uint64_t>(std::min<uint64_t>(std::numeric_limits<uint32_t>::max(), statistics->totalPrice));
			msg.add<uint64_t>(statistics->highestPrice);
			msg.add<uint64_t>(statistics->lowestPrice);
		} else {
			if (version >= 1266) {
	            msg.add<uint64_t>(statistics->totalPrice);
	        } else {
	            msg.add<uint32_t>(std::min<uint64_t>(std::numeric_limits<uint32_t>::max(), statistics->totalPrice));
	        }
			msg.add<uint32_t>(statistics->highestPrice);
        	msg.add<uint32_t>(statistics->lowestPrice);
		}
    } else {
        msg.addByte(0x00);
    }

    statistics = IOMarket::getInstance()->getSaleStatistics(itemId, tier);
    if (statistics) {        
    msg.addByte(0x01);
		msg.add<uint32_t>(statistics->numTransactions);
		if (version1280) {
      msg.add<uint64_t>(std::min<uint64_t>(std::numeric_limits<uint32_t>::max(), statistics->totalPrice));
			msg.add<uint64_t>(statistics->highestPrice);
			msg.add<uint64_t>(statistics->lowestPrice);
		} else {
			if (version >= 1266) {
        msg.add<uint64_t>(statistics->totalPrice);
    } else {
        msg.add<uint32_t>(std::min<uint64_t>(std::numeric_limits<uint32_t>::max(), statistics->totalPrice));
    }
    msg.add<uint32_t>(statistics->highestPrice);
    msg.add<uint32_t>(statistics->lowestPrice); 
		}
		} else {
        msg.addByte(0x00);
    }

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTradeItemRequest(const std::string &traderName, const Item *item, bool ack)
{
	NetworkMessage msg;

	if (ack)
	{
		msg.addByte(0x7D);
	}
	else
	{
		msg.addByte(0x7E);
	}

	msg.addString(traderName);

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

		msg.addByte(itemList.size());
		for (const Item *listItem : itemList)
		{
			AddItem(msg, listItem);
		}
	}
	else
	{
		msg.addByte(0x01);
		AddItem(msg, item);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCloseTrade()
{
	NetworkMessage msg;
	msg.addByte(0x7F);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCloseContainer(uint8_t cid)
{
	NetworkMessage msg;
	msg.addByte(0x6F);
	msg.addByte(cid);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureTurn(const Creature *creature, uint32_t stackPos)
{
	if (!canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x6B);
	if (stackPos >= 10) {
		msg.add<uint16_t>(0xFFFF);
		msg.add<uint32_t>(creature->getID());
	} else {
		msg.addPosition(creature->getPosition());
		msg.addByte(stackPos);
	}
	msg.add<uint16_t>(0x63);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(creature->getDirection());
	msg.addByte(player->canWalkthroughEx(creature) ? 0x00 : 0x01);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureSay(const Creature *creature, SpeakClasses type, const std::string &text, const Position *pos /* = nullptr*/)
{
	NetworkMessage msg;
	msg.addByte(0xAA);

	static uint32_t statementId = 0;
	msg.add<uint32_t>(++statementId);

	msg.addString(creature->getName());
	msg.addByte(0x00); // Show (Traded)

	//Add level only for players
	if (const Player *speaker = creature->getPlayer())
	{
		msg.add<uint16_t>(speaker->getLevel());
	}
	else
	{
		msg.add<uint16_t>(0x00);
	}

	msg.addByte(type);
	if (pos)
	{
		msg.addPosition(*pos);
	}
	else
	{
		msg.addPosition(creature->getPosition());
	}

	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendToChannel(const Creature *creature, SpeakClasses type, const std::string &text, uint16_t channelId)
{
	NetworkMessage msg;
	msg.addByte(0xAA);

	static uint32_t statementId = 0;
	msg.add<uint32_t>(++statementId);
	if (!creature)
	{
		msg.add<uint32_t>(0x00);
		if (statementId != 0)
		{
			msg.addByte(0x00); // Show (Traded)
		}
	}
	else if (type == TALKTYPE_CHANNEL_R2)
	{
		msg.add<uint32_t>(0x00);
		if (statementId != 0)
		{
			msg.addByte(0x00); // Show (Traded)
		}
		type = TALKTYPE_CHANNEL_R1;
	}
	else
	{
		msg.addString(creature->getName());
		if (statementId != 0)
		{
			msg.addByte(0x00); // Show (Traded)
		}

		//Add level only for players
		if (const Player *speaker = creature->getPlayer())
		{
			msg.add<uint16_t>(speaker->getLevel());
		}
		else
		{
			msg.add<uint16_t>(0x00);
		}
	}

	msg.addByte(type);
	msg.add<uint16_t>(channelId);
	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPrivateMessage(const Player *speaker, SpeakClasses type, const std::string &text)
{
	NetworkMessage msg;
	msg.addByte(0xAA);
	static uint32_t statementId = 0;
	msg.add<uint32_t>(++statementId);
	if (speaker)
	{
		msg.addString(speaker->getName());
		if (statementId != 0)
		{
			msg.addByte(0x00); // Show (Traded)
		}
		msg.add<uint16_t>(speaker->getLevel());
	}
	else
	{
		msg.add<uint32_t>(0x00);
		if (statementId != 0)
		{
			msg.addByte(0x00); // Show (Traded)
		}
	}
	msg.addByte(type);
	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCancelTarget()
{
	NetworkMessage msg;
	msg.addByte(0xA3);
	msg.add<uint32_t>(0x00);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChangeSpeed(const Creature *creature, uint32_t speed)
{
	NetworkMessage msg;
	msg.addByte(0x8F);
	msg.add<uint32_t>(creature->getID());
	msg.add<uint16_t>(creature->getBaseSpeed() / 2);
	msg.add<uint16_t>(speed / 2);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCancelWalk()
{
	if (player)
	{
		NetworkMessage msg;
		msg.addByte(0xB5);
		msg.addByte(player->getDirection());
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
		msg.addByte(0x1D);
		writeToOutputBuffer(msg);
	}
}

void ProtocolGame::sendPingBack()
{
	NetworkMessage msg;
	msg.addByte(0x1E);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendDistanceShoot(const Position &from, const Position &to, uint8_t type)
{
	NetworkMessage msg;
	msg.addByte(0x83);
	msg.addPosition(from);
	msg.addByte(MAGIC_EFFECTS_CREATE_DISTANCEEFFECT);
	msg.addByte(type);
	msg.addByte(static_cast<uint8_t>(static_cast<int8_t>(static_cast<int32_t>(to.x) - static_cast<int32_t>(from.x))));
	msg.addByte(static_cast<uint8_t>(static_cast<int8_t>(static_cast<int32_t>(to.y) - static_cast<int32_t>(from.y))));
	msg.addByte(MAGIC_EFFECTS_END_LOOP);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendRestingStatus(uint8_t protection)
{
	if (!player)
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(0xA9);
	msg.addByte(protection); // 1 / 0
	int32_t PlayerdailyStreak = 0;
	player->getStorageValue(STORAGEVALUE_DAILYREWARD, PlayerdailyStreak);
	msg.addByte(PlayerdailyStreak < 2 ? 0 : 1);
	if (PlayerdailyStreak < 2)
	{
		msg.addString("Resting Area (no active bonus)");
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
		msg.addString(ss.str());
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
	msg.addByte(0x83);
	msg.addPosition(pos);
	msg.addByte(MAGIC_EFFECTS_CREATE_EFFECT);
	msg.addByte(type);
	msg.addByte(MAGIC_EFFECTS_END_LOOP);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureHealth(const Creature *creature)
{
	if (creature->isHealthHidden())
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x8C);
	msg.add<uint32_t>(creature->getID());

	if (creature->isHealthHidden())
	{
		msg.addByte(0x00);
	}
	else
	{
		msg.addByte(std::ceil((static_cast<double>(creature->getHealth()) / std::max<int32_t>(creature->getMaxHealth(), 1)) * 100));
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
	msg.addByte(0x8B);
	msg.add<uint32_t>(cid);
	msg.addByte(0);  // creature update
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
	msg.addByte(0x91);
	msg.add<uint32_t>(cid);
	msg.addByte(player->getPartyShield(target->getPlayer()));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPartyCreatureSkull(const Creature* target)
{
	if (g_game.getWorldType() != WORLD_TYPE_PVP) {
		return;
	}

	uint32_t cid = target->getID();
	if (knownCreatureSet.find(cid) == knownCreatureSet.end()) {
		sendPartyCreatureUpdate(target);
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x90);
	msg.add<uint32_t>(cid);
	msg.addByte(player->getSkullClient(target));
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
	msg.addByte(0x8C);
	msg.add<uint32_t>(cid);
	msg.addByte(healthPercent);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPartyPlayerMana(const Player* target, uint8_t manaPercent)
{
	uint32_t cid = target->getID();
	if (knownCreatureSet.find(cid) == knownCreatureSet.end()) {
		sendPartyCreatureUpdate(target);
	}

	NetworkMessage msg;
	msg.addByte(0x8B);
	msg.add<uint32_t>(cid);
	msg.addByte(11);  // mana percent
	msg.addByte(manaPercent);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPartyCreatureShowStatus(const Creature* target, bool showStatus)
{
	uint32_t cid = target->getID();
	if (knownCreatureSet.find(cid) == knownCreatureSet.end()) {
		sendPartyCreatureUpdate(target);
	}

	NetworkMessage msg;
	msg.addByte(0x8B);
	msg.add<uint32_t>(cid);
	msg.addByte(12);  // show status
	msg.addByte((showStatus ? 0x01 : 0x00));
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
	msg.addByte(0x8B);
	msg.add<uint32_t>(cid);
	msg.addByte(13);  // vocation
	msg.addByte(target->getVocation()->getClientId());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPlayerVocation(const Player* target)
{
	NetworkMessage msg;
	msg.addByte(0x8B);
	msg.add<uint32_t>(target->getID());
	msg.addByte(13);  // vocation
	msg.addByte(target->getVocation()->getClientId());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendFYIBox(const std::string &message)
{
	NetworkMessage msg;
	msg.addByte(0x15);
	msg.addString(message);
	writeToOutputBuffer(msg);
}

//tile
void ProtocolGame::sendMapDescription(const Position &pos)
{
	NetworkMessage msg;
	msg.addByte(0x64);
	msg.addPosition(player->getPosition());
	GetMapDescription(pos.x - 8, pos.y - 6, pos.z, 18, 14, msg);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddTileItem(const Position &pos, uint32_t stackpos, const Item *item)
{
	if (!canSee(pos))
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x6A);
	msg.addPosition(pos);
	msg.addByte(stackpos);
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
	msg.addByte(0x6B);
	msg.addPosition(pos);
	msg.addByte(stackpos);
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

void ProtocolGame::sendUpdateTileCreature(const Position& pos, uint32_t stackpos, const Creature* creature)
{
	if (!canSee(pos)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x6B);
	msg.addPosition(pos);
	msg.addByte(stackpos);

	bool known;
	uint32_t removedKnown;
	checkCreatureAsKnown(creature->getID(), known, removedKnown);
	AddCreature(msg, creature, false, removedKnown);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendRemoveTileCreature(const Creature* creature, const Position& pos, uint32_t stackpos)
{
  if (stackpos < 10) {
		if (!canSee(pos)) {
			return;
		}

		NetworkMessage msg;
		RemoveTileThing(msg, pos, stackpos);
		writeToOutputBuffer(msg);
		return;
	}
	NetworkMessage msg;
	msg.addByte(0x6C);
	msg.add<uint16_t>(0xFFFF);
	msg.add<uint32_t>(creature->getID());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateTile(const Tile *tile, const Position &pos)
{
	if (!canSee(pos))
	{
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x69);
	msg.addPosition(pos);

	if (tile)
	{
		GetTileDescription(tile, msg);
		msg.addByte(0x00);
		msg.addByte(0xFF);
	}
	else
	{
		msg.addByte(0x01);
		msg.addByte(0xFF);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPendingStateEntered()
{
	NetworkMessage msg;
	msg.addByte(0x0A);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendEnterWorld()
{
	NetworkMessage msg;
	msg.addByte(0x0F);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendFightModes()
{
	NetworkMessage msg;
	msg.addByte(0xA7);
	msg.addByte(player->fightMode);
	msg.addByte(player->chaseMode);
	msg.addByte(player->secureMode);
	msg.addByte(PVP_MODE_DOVE);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddCreature(const Creature *creature, const Position &pos, int32_t stackpos, bool isLogin)
{
	if (!canSee(pos))
	{
		return;
	}

	if (creature != player){
		if (stackpos >= 10){
			if (const Tile* tile = creature->getTile()) {
				sendUpdateTile(tile, pos);
			}
		} else {
			NetworkMessage msg;
			msg.addByte(0x6A);
			msg.addPosition(pos);
			msg.addByte(stackpos);

			bool known;
			uint32_t removedKnown;
			checkCreatureAsKnown(creature->getID(), known, removedKnown);
			AddCreature(msg, creature, known, removedKnown);
			writeToOutputBuffer(msg);
		}

		
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x17);

	msg.add<uint32_t>(player->getID());
	msg.add<uint16_t>(0x32); // beat duration (50)

	msg.addDouble(Creature::speedA, 3);
	msg.addDouble(Creature::speedB, 3);
	msg.addDouble(Creature::speedC, 3);

	// can report bugs?
	if (player->getAccountType() >= account::ACCOUNT_TYPE_NORMAL)
	{
		msg.addByte(0x01);
	}
	else
	{
		msg.addByte(0x00);
	}

	msg.addByte(0x00); // can change pvp framing option
	msg.addByte(0x00); // expert mode button enabled

	msg.addString(g_config.getString(ConfigManager::STORE_IMAGES_URL));
	msg.add<uint16_t>(static_cast<uint16_t>(g_config.getNumber(ConfigManager::STORE_COIN_PACKET)));

	msg.addByte(shouldAddExivaRestrictions ? 0x01 : 0x00); // exiva button enabled
	msg.addByte(0x00);									   // tournament button

	writeToOutputBuffer(msg);

	sendTibiaTime(g_game.getLightHour());
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
		sendInventoryItem(static_cast<slots_t>(i), player->getInventoryItem(static_cast<slots_t>(i)));
	}

	sendStats();
	sendSkills();
	sendBlessStatus();

	sendPremiumTrigger();
	sendStoreHighlight();

	sendItemsPrice();
	
	sendPreyPrices();
	player->sendPreyData();
	player->sendTaskHuntingData();

	//gameworld light-settings
	sendWorldLight(g_game.getWorldLightInfo());

	//player light level
	sendCreatureLight(creature);

	const std::forward_list<VIPEntry> &vipEntries = IOLoginData::getVIPEntries(player->getAccount());

	if (player->isAccessPlayer())
	{
		for (const VIPEntry &entry : vipEntries)
		{
			VipStatus_t vipStatus;

			Player *vipPlayer = g_game.getPlayerByGUID(entry.guid);
			if (!vipPlayer)
			{
				vipStatus = VIPSTATUS_OFFLINE;
			}
			else
			{
				vipStatus = VIPSTATUS_ONLINE;
			}

			sendVIP(entry.guid, entry.name, entry.description, entry.icon, entry.notify, vipStatus);
		}
	}
	else
	{
		for (const VIPEntry &entry : vipEntries)
		{
			VipStatus_t vipStatus;

			Player *vipPlayer = g_game.getPlayerByGUID(entry.guid);
			if (!vipPlayer || !player->canSeeCreature(vipPlayer))
			{
				vipStatus = VIPSTATUS_OFFLINE;
			}
			else
			{
				vipStatus = VIPSTATUS_ONLINE;
			}

			sendVIP(entry.guid, entry.name, entry.description, entry.icon, entry.notify, vipStatus);
		}
	}
	
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

	TieredItemsCountMap tempInventoryMap;
	player->getAllItemTypeCountAndSubtype(tempInventoryMap);
    sendItems(tempInventoryMap); 

	player->sendClientCheck();
	player->sendGameNews();
	player->sendIcons();
}

void ProtocolGame::sendMoveCreature(const Creature *creature, const Position &newPos, int32_t newStackPos, const Position &oldPos, int32_t oldStackPos, bool teleport)
{
	if (creature == player)
	{
		if (teleport) {
			sendRemoveTileCreature(creature, oldPos, oldStackPos);
			sendMapDescription(newPos);
		} else {
			NetworkMessage msg;
			if (oldPos.z == 7 && newPos.z >= 8){
				RemoveTileCreature(msg, creature, oldPos, oldStackPos);
			} else {
				msg.addByte(0x6D);
				if (oldStackPos < 10) {
					msg.addPosition(oldPos);
					msg.addByte(oldStackPos);
				} else {
					msg.add<uint16_t>(0xFFFF);
					msg.add<uint32_t>(creature->getID());
				}
				msg.addPosition(newPos);
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
				msg.addByte(0x65);
				GetMapDescription(oldPos.x - 8, newPos.y - 6, newPos.z, 18, 1, msg);
			}
			else if (oldPos.y < newPos.y)
			{ // south, for old x
				msg.addByte(0x67);
				GetMapDescription(oldPos.x - 8, newPos.y + 7, newPos.z, 18, 1, msg);
			}

			if (oldPos.x < newPos.x)
			{ // east, [with new y]
				msg.addByte(0x66);
				GetMapDescription(newPos.x + 9, newPos.y - 6, newPos.z, 1, 14, msg);
			}
			else if (oldPos.x > newPos.x)
			{ // west, [with new y]
				msg.addByte(0x68);
				GetMapDescription(newPos.x - 8, newPos.y - 6, newPos.z, 1, 14, msg);
			}
			writeToOutputBuffer(msg);
		}
	}
	else if (canSee(oldPos) && canSee(newPos))
	{
		if (teleport || (oldPos.z == 7 && newPos.z >= 8))
		{
			sendRemoveTileCreature(creature, oldPos, oldStackPos);
			sendAddCreature(creature, newPos, newStackPos, false);
		}
		else
		{
			NetworkMessage msg;
			msg.addByte(0x6D);
			if (oldStackPos < 10) {
				msg.addPosition(oldPos);
				msg.addByte(oldStackPos);
			} else {
				msg.add<uint16_t>(0xFFFF);
				msg.add<uint32_t>(creature->getID());
			}
			msg.addPosition(newPos);
			writeToOutputBuffer(msg);
		}
	}
	else if (canSee(oldPos))
	{
		sendRemoveTileCreature(creature, oldPos, oldStackPos);
	}
	else if (canSee(newPos))
	{
		sendAddCreature(creature, newPos, newStackPos, false);
	}
}

void ProtocolGame::sendInventoryItem(slots_t slot, const Item *item)
{
	NetworkMessage msg;
	if (item)
	{
		msg.addByte(0x78);
		msg.addByte(slot);
		AddItem(msg, item);
	}
	else
	{
		msg.addByte(0x79);
		msg.addByte(slot);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendItems(const TieredItemsCountMap& inventoryMap)
{
	if (!player) {
    	return;
	}

	bool version1280 = false; 
	if (version >= 1280) {
		version1280 = true; 
	}

	NetworkMessage msg;
	msg.addByte(0xF5);
	msg.add<uint16_t>(inventoryMap.size() + 11);

	for (uint16_t i = 1; i <= 11; i++)
	{
		msg.add<uint16_t>(i);		// slotId
		msg.addByte(0); 			// always 0
		msg.add<uint16_t>(0x01); 	// always 1
	}

	for (const auto &it : inventoryMap)
	{
		msg.add<uint16_t>(Item::items[it.first.first].clientId);	// item clientId
		msg.addByte((version1280 ? it.first.second : 0x00)); 		// tier
		//msg.add<uint16_t>(it.second);								// count
		msg.add<uint16_t>(std::min<int32_t>(it.second, std::numeric_limits<uint16_t>::max())); // count
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddContainerItem(uint8_t cid, uint16_t slot, const Item *item)
{
	NetworkMessage msg;
	msg.addByte(0x70);
	msg.addByte(cid);
	msg.add<uint16_t>(slot);
	AddItem(msg, item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateContainerItem(uint8_t cid, uint16_t slot, const Item *item)
{
	NetworkMessage msg;
	msg.addByte(0x71);
	msg.addByte(cid);
	msg.add<uint16_t>(slot);
	AddItem(msg, item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendRemoveContainerItem(uint8_t cid, uint16_t slot, const Item *lastItem)
{
	NetworkMessage msg;
	msg.addByte(0x72);
	msg.addByte(cid);
	msg.add<uint16_t>(slot);
	if (lastItem)
	{
		AddItem(msg, lastItem);
	}
	else
	{
		msg.add<uint16_t>(0x00);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTextWindow(uint32_t windowTextId, Item *item, uint16_t maxlen, bool canWrite)
{
	NetworkMessage msg;
	msg.addByte(0x96);
	msg.add<uint32_t>(windowTextId);
	AddItem(msg, item);

	if (canWrite)
	{
		msg.add<uint16_t>(maxlen);
		msg.addString(item->getText());
	}
	else
	{
		const std::string &text = item->getText();
		msg.add<uint16_t>(text.size());
		msg.addString(text);
	}

	const std::string &writer = item->getWriter();
	if (!writer.empty())
	{
		msg.addString(writer);
	}
	else
	{
		msg.add<uint16_t>(0x00);
	}

	msg.addByte(0x00); // Show (Traded)

	time_t writtenDate = item->getDate();
	if (writtenDate != 0)
	{
		msg.addString(formatDateShort(writtenDate));
	}
	else
	{
		msg.add<uint16_t>(0x00);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTextWindow(uint32_t windowTextId, uint32_t itemId, const std::string &text)
{
	NetworkMessage msg;
	msg.addByte(0x96);
	msg.add<uint32_t>(windowTextId);
	AddItem(msg, itemId, 1);
	msg.add<uint16_t>(text.size());
	msg.addString(text);
	msg.add<uint16_t>(0x00);
	msg.addByte(0x00); // Show (Traded)
	msg.add<uint16_t>(0x00);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendHouseWindow(uint32_t windowTextId, const std::string &text)
{
	NetworkMessage msg;
	msg.addByte(0x97);
	msg.addByte(0x00);
	msg.add<uint32_t>(windowTextId);
	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendOutfitWindow()
{
	NetworkMessage msg;
	msg.addByte(0xC8);

	bool mounted = false;
	Outfit_t currentOutfit = player->getDefaultOutfit();
	Mount* currentMount = g_game.mounts.getMountByID(player->getCurrentMount());
	if (currentMount) {
		mounted = (currentOutfit.lookMount == currentMount->clientId);
		currentOutfit.lookMount = currentMount->clientId;
	}

	AddOutfit(msg, currentOutfit);

	msg.addByte(currentOutfit.lookMountHead);
	msg.addByte(currentOutfit.lookMountBody);
	msg.addByte(currentOutfit.lookMountLegs);
	msg.addByte(currentOutfit.lookMountFeet);
	msg.add<uint16_t>(currentOutfit.lookFamiliarsType);

	auto startOutfits = msg.getBufferPosition();
	uint16_t limitOutfits = std::numeric_limits<uint16_t>::max();
	uint16_t outfitSize = 0;
	msg.skipBytes(2);

	if (player->isAccessPlayer()) {
		msg.add<uint16_t>(75);
		msg.addString("Gamemaster");
		msg.addByte(0);
		msg.addByte(0x00);
		++outfitSize;

		msg.add<uint16_t>(266);
		msg.addString("Customer Support");
		msg.addByte(0);
		msg.addByte(0x00);
		++outfitSize;

		msg.add<uint16_t>(302);
		msg.addString("Community Manager");
		msg.addByte(0);
		msg.addByte(0x00);
		++outfitSize;
	}

	const auto& outfits = Outfits::getInstance().getOutfits(player->getSex());

	for (const Outfit& outfit : outfits) {
		uint8_t addons;
		if (!player->getOutfitAddons(outfit, addons)) {
			continue;
		}

		msg.add<uint16_t>(outfit.lookType);
		msg.addString(outfit.name);
		msg.addByte(addons);
		msg.addByte(0x00);
		if (++outfitSize == limitOutfits) {
			break;
		}
	}

	auto endOutfits = msg.getBufferPosition();
	msg.setBufferPosition(startOutfits);
	msg.add<uint16_t>(outfitSize);
	msg.setBufferPosition(endOutfits);

	auto startMounts = msg.getBufferPosition();
	uint16_t limitMounts = std::numeric_limits<uint16_t>::max();
	uint16_t mountSize = 0;
	msg.skipBytes(2);

	const auto& mounts = g_game.mounts.getMounts();
	for (const Mount& mount : mounts) {
		if (player->hasMount(&mount)) {
			msg.add<uint16_t>(mount.clientId);
			msg.addString(mount.name);
			msg.addByte(0x00);
			if (++mountSize == limitMounts) {
				break;
			}
		}
	}

	auto endMounts = msg.getBufferPosition();
	msg.setBufferPosition(startMounts);
	msg.add<uint16_t>(mountSize);
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

		msg.add<uint16_t>(familiar.lookType);
		msg.addString(familiar.name);
		msg.addByte(0x00);
		if (++familiarSize == limitFamiliars) {
				break;
		}
	}

	auto endFamiliars = msg.getBufferPosition();
	msg.setBufferPosition(startFamiliars);
	msg.add<uint16_t>(familiarSize);
	msg.setBufferPosition(endFamiliars);

	msg.addByte(0x00); //Try outfit
	msg.addByte(mounted ? 0x01 : 0x00);
	
	// random outfit
	msg.addByte(0);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendItemClasses()
{
	NetworkMessage msg;
	msg.addByte(0x86);

	uint8_t classSize = 4;
	uint8_t tiersSize = 10;

	// item classes
	msg.addByte(classSize);
	for (uint8_t i = 0; i < classSize; i++) {
		msg.addByte(i + 1); // class id

		// item tiers
		msg.addByte(tiersSize); // tiers size
		for (uint8_t j = 0; j < tiersSize; j++) {
			msg.addByte(j); // tier id
			msg.add<uint64_t>(10000); // upgrade cost
		}
	}

	// unknown
	for (uint8_t i = 0; i < tiersSize + 1; i++) {
		msg.addByte(0);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPodiumWindow(const Item* podium, const Position& position, uint16_t spriteId, uint8_t stackpos)
{
	NetworkMessage msg;
	msg.addByte(0xC8);

	const ItemAttributes::CustomAttribute* podiumVisible = podium->getCustomAttribute("PodiumVisible");
	const ItemAttributes::CustomAttribute* lookType = podium->getCustomAttribute("LookType");
	const ItemAttributes::CustomAttribute* lookMount = podium->getCustomAttribute("LookMount");
	const ItemAttributes::CustomAttribute* lookDirection = podium->getCustomAttribute("LookDirection");

	bool outfited = false;
	bool mounted = false;

	if (lookType) {
		uint16_t look = static_cast<uint16_t>(boost::get<int64_t>(lookType->value));
		outfited = (look != 0);
		msg.add<uint16_t>(look);

		if (outfited) {
			const ItemAttributes::CustomAttribute* lookHead = podium->getCustomAttribute("LookHead");
			const ItemAttributes::CustomAttribute* lookBody = podium->getCustomAttribute("LookBody");
			const ItemAttributes::CustomAttribute* lookLegs = podium->getCustomAttribute("LookLegs");
			const ItemAttributes::CustomAttribute* lookFeet = podium->getCustomAttribute("LookFeet");

			msg.addByte(lookHead ? static_cast<uint8_t>(boost::get<int64_t>(lookHead->value)) : 0);
			msg.addByte(lookBody ? static_cast<uint8_t>(boost::get<int64_t>(lookBody->value)) : 0);
			msg.addByte(lookLegs ? static_cast<uint8_t>(boost::get<int64_t>(lookLegs->value)) : 0);
			msg.addByte(lookFeet ? static_cast<uint8_t>(boost::get<int64_t>(lookFeet->value)) : 0);

			const ItemAttributes::CustomAttribute* lookAddons = podium->getCustomAttribute("LookAddons");
			msg.addByte(lookAddons ? static_cast<uint8_t>(boost::get<int64_t>(lookAddons->value)) : 0);
		}
	} else {
		msg.add<uint16_t>(0);
	}

	if (lookMount) {
		uint16_t look = static_cast<uint16_t>(boost::get<int64_t>(lookMount->value));
		mounted = (look != 0);
		msg.add<uint16_t>(look);

		if (mounted) {
			const ItemAttributes::CustomAttribute* lookHead = podium->getCustomAttribute("LookMountHead");
			const ItemAttributes::CustomAttribute* lookBody = podium->getCustomAttribute("LookMountBody");
			const ItemAttributes::CustomAttribute* lookLegs = podium->getCustomAttribute("LookMountLegs");
			const ItemAttributes::CustomAttribute* lookFeet = podium->getCustomAttribute("LookMountFeet");

			msg.addByte(lookHead ? static_cast<uint8_t>(boost::get<int64_t>(lookHead->value)) : 0);
			msg.addByte(lookBody ? static_cast<uint8_t>(boost::get<int64_t>(lookBody->value)) : 0);
			msg.addByte(lookLegs ? static_cast<uint8_t>(boost::get<int64_t>(lookLegs->value)) : 0);
			msg.addByte(lookFeet ? static_cast<uint8_t>(boost::get<int64_t>(lookFeet->value)) : 0);
		}
	} else {
		msg.add<uint16_t>(0);
		msg.addByte(0);
		msg.addByte(0);
		msg.addByte(0);
		msg.addByte(0);
	}
	msg.add<uint16_t>(0);

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

		msg.add<uint16_t>(outfit.lookType);
		msg.addString(outfit.name);
		msg.addByte(addons);
		msg.addByte(0x00);
		if (++outfitSize == limitOutfits) {
			break;
		}
	}

	auto endOutfits = msg.getBufferPosition();
	msg.setBufferPosition(startOutfits);
	msg.add<uint16_t>(outfitSize);
	msg.setBufferPosition(endOutfits);

	auto startMounts = msg.getBufferPosition();
	uint16_t limitMounts = std::numeric_limits<uint16_t>::max();
	uint16_t mountSize = 0;
	msg.skipBytes(2);

	const auto& mounts = g_game.mounts.getMounts();
	for (const Mount& mount : mounts) {
		if (player->hasMount(&mount)) {
			msg.add<uint16_t>(mount.clientId);
			msg.addString(mount.name);
			msg.addByte(0x00);
			if (++mountSize == limitMounts) {
				break;
			}
		}
	}

	auto endMounts = msg.getBufferPosition();
	msg.setBufferPosition(startMounts);
	msg.add<uint16_t>(mountSize);
	msg.setBufferPosition(endMounts);

	msg.add<uint16_t>(0);

	msg.addByte(0x05);
	msg.addByte(mounted ? 0x01 : 0x00);

	msg.add<uint16_t>(0);

	msg.addPosition(position);
	msg.add<uint16_t>(spriteId);
	msg.addByte(stackpos);

	msg.addByte(podiumVisible ? static_cast<uint8_t>(boost::get<int64_t>(podiumVisible->value)) : 0x01);
	msg.addByte(outfited ? 0x01 : 0x00);
	msg.addByte(lookDirection ? static_cast<uint8_t>(boost::get<int64_t>(lookDirection->value)) : 2);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdatedVIPStatus(uint32_t guid, VipStatus_t newStatus)
{
	NetworkMessage msg;
	msg.addByte(0xD3);
	msg.add<uint32_t>(guid);
	msg.addByte(newStatus);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendVIP(uint32_t guid, const std::string &name, const std::string &description, uint32_t icon, bool notify, VipStatus_t status)
{
	NetworkMessage msg;
	msg.addByte(0xD2);
	msg.add<uint32_t>(guid);
	msg.addString(name);
	msg.addString(description);
	msg.add<uint32_t>(std::min<uint32_t>(10, icon));
	msg.addByte(notify ? 0x01 : 0x00);
	msg.addByte(status);
	msg.addByte(0x00); // vipGroups
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSpellCooldown(uint8_t spellId, uint32_t time)
{
	NetworkMessage msg;
	msg.addByte(0xA4);

	msg.addByte(spellId);
	msg.add<uint32_t>(time);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSpellGroupCooldown(SpellGroup_t groupId, uint32_t time)
{
	NetworkMessage msg;
	msg.addByte(0xA5);
	msg.addByte(groupId);
	msg.add<uint32_t>(time);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendOpenStore(uint8_t)
{
	NetworkMessage msg;

	msg.addByte(0xFB); //open store
	msg.addByte(0x00);

	//add categories
	uint16_t categoriesCount = g_game.gameStore.getCategoryOffers().size();

	msg.add<uint16_t>(categoriesCount);

	for (StoreCategory *category : g_game.gameStore.getCategoryOffers())
	{
		msg.addString(category->name);
		msg.addString(category->description);

		uint8_t stateByte;
		switch (category->state)
		{
		case NORMAL:
			stateByte = 0;
			break;
		case NEW:
			stateByte = 1;
			break;
		case SALE:
			stateByte = 2;
			break;
		case LIMITED_TIME:
			stateByte = 3;
			break;
		default:
			stateByte = 0;
			break;
		}
		msg.addByte(stateByte);

		msg.addByte((uint8_t)category->icons.size());
		for (std::string iconStr : category->icons)
		{
			msg.addString(iconStr);
		}
		msg.addString(""); //TODO: parentCategory
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendStoreCategoryOffers(StoreCategory *category)
{
	NetworkMessage msg;
	msg.addByte(0xFC); //StoreOffers
	msg.addString(category->name);
	msg.add<uint16_t>(category->offers.size());

	for (BaseOffer *offer : category->offers)
	{
		msg.add<uint32_t>(offer->id);
		std::stringstream offername;
		if (offer->type == Offer_t::ITEM || offer->type == Offer_t::STACKABLE_ITEM)
		{
			if (((ItemOffer *)offer)->count > 1)
			{
				offername << ((ItemOffer *)offer)->count << "x ";
			}
		}
		offername << offer->name;

		msg.addString(offername.str());
		msg.addString(offer->description);

		msg.add<uint32_t>(offer->price);
		msg.addByte((uint8_t)offer->state);

		//outfits
		uint8_t disabled = 0;
		std::stringstream disabledReason;

		disabledReason << "";

		if (offer->type == OUTFIT || offer->type == OUTFIT_ADDON)
		{
			OutfitOffer *outfitOffer = (OutfitOffer *)offer;

			uint16_t looktype = (player->getSex() == PLAYERSEX_MALE) ? outfitOffer->maleLookType : outfitOffer->femaleLookType;
			uint8_t addons = outfitOffer->addonNumber;

			if (player->canWear(looktype, addons))
			{ //player can wear the offer already
				disabled = 1;
				if (addons == 0)
				{ //addons == 0 //oufit-only offer and player already has it
					disabledReason << "You already have this outfit.";
				}
				else
				{
					disabledReason << "You already have this outfit/addon.";
				}
			}
			else
			{
				if (outfitOffer->type == OUTFIT_ADDON && !player->canWear(looktype, 0))
				{ //addon offer and player doesnt have the base outfit
					disabled = 1;
					disabledReason << "You don't have the outfit, you can't buy the addon.";
				}
			}
		}
		else if (offer->type == MOUNT)
		{
			MountOffer *mountOffer = (MountOffer *)offer;
			Mount *m = g_game.mounts.getMountByID(mountOffer->mountId);
			if (player->hasMount(m))
			{
				disabled = 1;
				disabledReason << "You already have this mount.";
			}
		}
		else if (offer->type == PROMOTION)
		{
			if (player->isPromoted() || !player->isPremium())
			{ //TODO: add support to multiple promotion levels
				disabled = 1;
				disabledReason << "You can't get this promotion";
			}
		}

		msg.addByte(disabled);

		if (disabled)
		{
			msg.addString(disabledReason.str());
		}

		//add icons
		msg.addByte((uint8_t)offer->icons.size());

		for (std::string iconName : offer->icons)
		{
			msg.addString(iconName);
		}

		msg.add<uint16_t>(0);
		//TODO: add support to suboffers
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendStoreError(GameStoreError_t error, const std::string &message)
{
	NetworkMessage msg;

	msg.addByte(0xE0); //storeError
	msg.addByte(error);
	msg.addString(message);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendStorePurchaseSuccessful(const std::string &message, const uint32_t coinBalance)
{
	NetworkMessage msg;

	msg.addByte(0xFE); //CompletePurchase
	msg.addByte(0x00);

	msg.addString(message);
	msg.add<uint32_t>(coinBalance); //dont know why the client needs it duplicated. But ok...
	msg.add<uint32_t>(coinBalance);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendStoreRequestAdditionalInfo(uint32_t offerId, ClientOffer_t clientOfferType)
{
	NetworkMessage msg;

	msg.addByte(0xE1); //RequestPurchaseData
	msg.add<uint32_t>(offerId);
	msg.addByte(clientOfferType);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPreyTimeLeft(const PreySlot* slot)
{
	if (!player || !slot) {
		return;
	}

	NetworkMessage msg;

	msg.addByte(0xE7);
	msg.addByte(static_cast<uint8_t>(slot->id));
	msg.add<uint16_t>(slot->bonusTimeLeft);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPreyData(const PreySlot* slot)
{
	NetworkMessage msg;
	msg.addByte(0xE8);
	msg.addByte(static_cast<uint8_t>(slot->id));
	msg.addByte(static_cast<uint8_t>(slot->state));

	if (slot->state == PreyDataState_Locked) {
		msg.addByte(player->isPremium() ? 0x01 : 0x00);
	} else if (slot->state == PreyDataState_Inactive) {
			// Empty
	} else if (slot->state == PreyDataState_Active) {	
		if (const MonsterType* mtype = g_monsters.getMonsterTypeByRaceId(slot->selectedRaceId)) {
			msg.addString(mtype->name);
			const Outfit_t outfit = mtype->info.outfit;
			msg.add<uint16_t>(outfit.lookType);
			if (outfit.lookType == 0) {
				msg.add<uint16_t>(outfit.lookTypeEx);
			} else {
				msg.addByte(outfit.lookHead);
				msg.addByte(outfit.lookBody);
				msg.addByte(outfit.lookLegs);
				msg.addByte(outfit.lookFeet);
				msg.addByte(outfit.lookAddons);
			}

			msg.addByte(static_cast<uint8_t>(slot->bonus));
			msg.add<uint16_t>(slot->bonusPercentage);
			msg.addByte(slot->bonusRarity);
			msg.add<uint16_t>(slot->bonusTimeLeft);
		}
	} else if (slot->state == PreyDataState_Selection) {
		msg.addByte(static_cast<uint8_t>(slot->raceIdList.size()));
		std::for_each(slot->raceIdList.begin(), slot->raceIdList.end(), [&msg](uint16_t raceId)
		{
			if (const MonsterType* mtype = g_monsters.getMonsterTypeByRaceId(raceId)) {
				msg.addString(mtype->name);
				const Outfit_t outfit = mtype->info.outfit;
				msg.add<uint16_t>(outfit.lookType);
				if (outfit.lookType == 0) {
					msg.add<uint16_t>(outfit.lookTypeEx);
				} else {
					msg.addByte(outfit.lookHead);
					msg.addByte(outfit.lookBody);
					msg.addByte(outfit.lookLegs);
					msg.addByte(outfit.lookFeet);
					msg.addByte(outfit.lookAddons);
				}
			} else {
				SPDLOG_WARN("[ProtocolGame::sendPreyData] - Unknown monster type raceid: {}", raceId);
				return;
			}
		});
	} else if (slot->state == PreyDataState_SelectionChangeMonster) {
		msg.addByte(static_cast<uint8_t>(slot->bonus));
		msg.add<uint16_t>(slot->bonusPercentage);
		msg.addByte(slot->bonusRarity);
		msg.addByte(static_cast<uint8_t>(slot->raceIdList.size()));
		std::for_each(slot->raceIdList.begin(), slot->raceIdList.end(), [&msg](uint16_t raceId)
		{
			if (const MonsterType* mtype = g_monsters.getMonsterTypeByRaceId(raceId)) {
				msg.addString(mtype->name);
				const Outfit_t outfit = mtype->info.outfit;
				msg.add<uint16_t>(outfit.lookType);
				if (outfit.lookType == 0) {
					msg.add<uint16_t>(outfit.lookTypeEx);
				} else {
					msg.addByte(outfit.lookHead);
					msg.addByte(outfit.lookBody);
					msg.addByte(outfit.lookLegs);
					msg.addByte(outfit.lookFeet);
					msg.addByte(outfit.lookAddons);
				}
			} else {
				SPDLOG_WARN("[ProtocolGame::sendPreyData] - Unknown monster type raceid: {}", raceId);
				return;
			}
		});
	} else if (slot->state == PreyDataState_ListSelection) {
		const std::map<uint16_t, std::string> bestiaryList = g_game.getBestiaryList();
		msg.add<uint16_t>(static_cast<uint16_t>(bestiaryList.size()));
		std::for_each(bestiaryList.begin(), bestiaryList.end(), [&msg](auto& mType)
		{
			msg.add<uint16_t>(mType.first);
		});
	} else {
		SPDLOG_WARN("[ProtocolGame::sendPreyData] - Unknown prey state: {}", slot->state);
		return;
	}

	msg.add<uint32_t>(std::max<uint32_t>(static_cast<uint32_t>(((slot->freeRerollTimeStamp - OTSYS_TIME()) / 1000)), 0));
	msg.addByte(static_cast<uint8_t>(slot->option));

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPreyPrices()
{
	if (!player) {
		return;
	}

	NetworkMessage msg;

	msg.addByte(0xE9);

	msg.add<uint32_t>(player->getPreyRerollPrice());
	msg.addByte(static_cast<uint8_t>(g_config.getNumber(ConfigManager::PREY_BONUS_REROLL_PRICE)));
	msg.addByte(static_cast<uint8_t>(g_config.getNumber(ConfigManager::PREY_SELECTION_LIST_PRICE)));
	msg.add<uint32_t>(player->getTaskHuntingRerollPrice());
	msg.add<uint32_t>(player->getTaskHuntingRerollPrice());
	msg.addByte(static_cast<uint8_t>(g_config.getNumber(ConfigManager::TASK_HUNTING_SELECTION_LIST_PRICE)));
	msg.addByte(static_cast<uint8_t>(g_config.getNumber(ConfigManager::TASK_HUNTING_BONUS_REROLL_PRICE)));

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendStoreTrasactionHistory(HistoryStoreOfferList &list, uint32_t page, uint8_t entriesPerPage)
{
	NetworkMessage msg;
	uint32_t isLastPage = (list.size() <= entriesPerPage) ? 0x01 : 0x00;

	//TODO: Support multiple pages
	isLastPage = 0x01; //FIXME
	page = 0x00;
	////////////////////////

	msg.addByte(0xFD);				   //BrowseTransactionHistory
	msg.add<uint32_t>(page);		   //which page
	msg.add<uint32_t>(isLastPage);	   //is the last page? /
	msg.addByte((uint8_t)list.size()); //how many elements follows

	for (HistoryStoreOffer offer : list)
	{
		msg.add<uint32_t>(offer.time);
		msg.addByte(offer.mode);
		msg.add<uint32_t>(offer.amount); //FIXME: investigate why it doesn't send the price properly
		msg.addByte(0x00);				 // 0 = transferable tibia coin, 1 = normal tibia coin
		msg.addString(offer.description);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendModalWindow(const ModalWindow &modalWindow)
{
	NetworkMessage msg;
	msg.addByte(0xFA);

	msg.add<uint32_t>(modalWindow.id);
	msg.addString(modalWindow.title);
	msg.addString(modalWindow.message);

	msg.addByte(modalWindow.buttons.size());
	for (const auto &it : modalWindow.buttons)
	{
		msg.addString(it.first);
		msg.addByte(it.second);
	}

	msg.addByte(modalWindow.choices.size());
	for (const auto &it : modalWindow.choices)
	{
		msg.addString(it.first);
		msg.addByte(it.second);
	}

	msg.addByte(modalWindow.defaultEscapeButton);
	msg.addByte(modalWindow.defaultEnterButton);
	msg.addByte(modalWindow.priority ? 0x01 : 0x00);

	writeToOutputBuffer(msg);
}

////////////// Add common messages
void ProtocolGame::AddCreature(NetworkMessage &msg, const Creature *creature, bool known, uint32_t remove)
{
	CreatureType_t creatureType = creature->getType();
	const Player *otherPlayer = creature->getPlayer();

	if (known)
	{
		msg.add<uint16_t>(0x62);
		msg.add<uint32_t>(creature->getID());
	}
	else
	{
		msg.add<uint16_t>(0x61);
		msg.add<uint32_t>(remove);
		msg.add<uint32_t>(creature->getID());
		if (creature->isHealthHidden())
		{
			msg.addByte(CREATURETYPE_HIDDEN);
		}
		else
		{
			msg.addByte(creatureType);
		}

		if (creatureType == CREATURETYPE_SUMMONPLAYER)
		{
			const Creature *master = creature->getMaster();
			if (master)
			{
				msg.add<uint32_t>(master->getID());
			}
			else
			{
				msg.add<uint32_t>(0x00);
			}
		}

		if (creature->isHealthHidden())
		{
			msg.addString("");
		}
		else
		{
			msg.addString(creature->getName());
		}
	}

	if (creature->isHealthHidden())
	{
		msg.addByte(0x00);
	}
	else
	{
		msg.addByte(std::ceil((static_cast<double>(creature->getHealth()) / std::max<int32_t>(creature->getMaxHealth(), 1)) * 100));
	}

	msg.addByte(creature->getDirection());

	if (!creature->isInGhostMode() && !creature->isInvisible())
	{
		const Outfit_t &outfit = creature->getCurrentOutfit();
		AddOutfit(msg, outfit);
		if (outfit.lookMount != 0)
		{
			msg.addByte(outfit.lookMountHead);
			msg.addByte(outfit.lookMountBody);
			msg.addByte(outfit.lookMountLegs);
			msg.addByte(outfit.lookMountFeet);
		}
	}
	else
	{
		static Outfit_t outfit;
		AddOutfit(msg, outfit);
	}

	LightInfo lightInfo = creature->getCreatureLight();
	msg.addByte(player->isAccessPlayer() ? 0xFF : lightInfo.level);
	msg.addByte(lightInfo.color);

	msg.add<uint16_t>(creature->getStepSpeed() / 2);

	if (version >= 1240) {
        if (otherPlayer) {            
            CreatureIcon_t icon = creature->getIcon();
			msg.addByte(icon != CREATUREICON_NONE); // Icons
			if (icon != CREATUREICON_NONE) {
				msg.addByte(icon);
				msg.addByte(1);
				msg.add<uint16_t>(0);
			}
        } else {
            if (creature->getMonster()) {
                const Monster* monster = creature->getMonster(); // convertendo pra monster
                if (monster) {
                    CreatureIcon_t icon = monster->getIcon();
                    msg.addByte(icon != CREATUREICON_NONE); // sent Icons true/false
                    if (icon != CREATUREICON_NONE) {

                        // icones com stack (Fiendishs e Influenceds)
                        if (monster->getForgeStack() > 0) {

                            msg.addByte(icon);
                            msg.addByte(1);
                            msg.add<uint16_t>(icon != MONSTERICON_5 ? monster->getForgeStack() : 0); //stack   

                        } else {
                            // icones sem numero do lado
                            msg.addByte(icon);
                            msg.addByte(1);
                            msg.add<uint16_t>(0);                            
                        }
                    }                    
                }
            } else {
                CreatureIcon_t icon = creature->getIcon();
                msg.addByte(icon != CREATUREICON_NONE); // sent Icons true/false
                if (icon != CREATUREICON_NONE) {
                   	msg.addByte(icon);
					msg.addByte(1);
					msg.add<uint16_t>(0);              
                }
            }            
        }        
    }

	msg.addByte(player->getSkullClient(creature));
	msg.addByte(player->getPartyShield(otherPlayer));

	if (!known)
	{
		msg.addByte(player->getGuildEmblem(otherPlayer));
	}

	if (creatureType == CREATURETYPE_MONSTER)
	{
		const Creature *master = creature->getMaster();
		if (master)
		{
			const Player *masterPlayer = master->getPlayer();
			if (masterPlayer)
			{
				creatureType = CREATURETYPE_SUMMONPLAYER;
			}
		}
	}

	if (creature->isHealthHidden())
	{
		msg.addByte(CREATURETYPE_HIDDEN);
	}
	else
	{
		msg.addByte(creatureType); // Type (for summons)
	}

	if (creatureType == CREATURETYPE_SUMMONPLAYER)
	{
		const Creature *master = creature->getMaster();
		if (master)
		{
			msg.add<uint32_t>(master->getID());
		}
		else
		{
			msg.add<uint32_t>(0x00);
		}
	}

	if (creatureType == CREATURETYPE_PLAYER)
	{
		const Player *otherCreature = creature->getPlayer();
		if (otherCreature)
		{
			msg.addByte(otherCreature->getVocation()->getClientId());
		}
		else
		{
			msg.addByte(0);
		}
	}

	msg.addByte(creature->getSpeechBubble());
	msg.addByte(0xFF); // MARK_UNMARKED
	msg.addByte(0x00); // inspection type
	msg.addByte(player->canWalkthroughEx(creature) ? 0x00 : 0x01);
}

void ProtocolGame::AddPlayerStats(NetworkMessage &msg)
{
	msg.addByte(0xA0);

	msg.add<uint16_t>(std::min<int32_t>(player->getHealth(), std::numeric_limits<uint16_t>::max()));
	msg.add<uint16_t>(std::min<int32_t>(player->getMaxHealth(), std::numeric_limits<uint16_t>::max()));

	msg.add<uint32_t>(player->getFreeCapacity());

	msg.add<uint64_t>(player->getExperience());

	msg.add<uint16_t>(player->getLevel());
	msg.addByte(player->getLevelPercent());

	msg.add<uint16_t>(player->getBaseXpGain());		 // base xp gain rate
	msg.add<uint16_t>(player->getGrindingXpBoost()); // low level bonus
	msg.add<uint16_t>(player->getStoreXpBoost());	 // xp boost
	msg.add<uint16_t>(player->getStaminaXpBoost());	 // stamina multiplier (100 = 1.0x)

	msg.add<uint16_t>(std::min<int32_t>(player->getMana(), std::numeric_limits<uint16_t>::max()));
	msg.add<uint16_t>(std::min<int32_t>(player->getMaxMana(), std::numeric_limits<uint16_t>::max()));

	msg.addByte(player->getSoul());

	msg.add<uint16_t>(player->getStaminaMinutes());

	msg.add<uint16_t>(player->getBaseSpeed() / 2);

	Condition *condition = player->getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT);
	msg.add<uint16_t>(condition ? condition->getTicks() / 1000 : 0x00);

	msg.add<uint16_t>(player->getOfflineTrainingTime() / 60 / 1000);

	msg.add<uint16_t>(player->getExpBoostStamina()); // xp boost time (seconds)
	msg.addByte(1);									 // enables exp boost in the store

	msg.add<uint16_t>(player->getManaShield());  // remaining mana shield
	msg.add<uint16_t>(player->getMaxManaShield());  // total mana shield
}

void ProtocolGame::AddPlayerSkills(NetworkMessage &msg)
{
	msg.addByte(0xA1);

	msg.add<uint16_t>(player->getMagicLevel());

	if (player->getOperatingSystem() <= CLIENTOS_NEW_MAC)
	{
		msg.add<uint16_t>(player->getBaseMagicLevel());
	}

	msg.add<uint16_t>(player->getBaseMagicLevel());
	msg.add<uint16_t>(player->getMagicLevelPercent() * 100);

	for (uint8_t i = SKILL_FIRST; i <= SKILL_FISHING; ++i)
	{
		msg.add<uint16_t>(std::min<int32_t>(player->getSkillLevel(i), std::numeric_limits<uint16_t>::max()));
		msg.add<uint16_t>(player->getBaseSkill(i));

		if (player->getOperatingSystem() <= CLIENTOS_NEW_MAC)
		{
			msg.add<uint16_t>(player->getBaseSkill(i));
		}

		msg.add<uint16_t>(player->getSkillPercent(i) * 100);
	}

	for (uint8_t i = SKILL_CRITICAL_HIT_CHANCE; i <= SKILL_LAST; ++i)
	{
		msg.add<uint16_t>(std::min<int32_t>(player->getSkillLevel(i), std::numeric_limits<uint16_t>::max()));
		msg.add<uint16_t>(player->getBaseSkill(i));
	}

	// used for imbuement (Feather)
	msg.add<uint32_t>(player->getCapacity());	  // total capacity
	msg.add<uint32_t>(player->getBaseCapacity()); // base total capacity
}

void ProtocolGame::AddOutfit(NetworkMessage &msg, const Outfit_t &outfit, bool addMount /* = true*/)
{
	msg.add<uint16_t>(outfit.lookType);
	if (outfit.lookType != 0)
	{
		msg.addByte(outfit.lookHead);
		msg.addByte(outfit.lookBody);
		msg.addByte(outfit.lookLegs);
		msg.addByte(outfit.lookFeet);
		msg.addByte(outfit.lookAddons);
	}
	else
	{
		msg.addItemId(outfit.lookTypeEx);
	}

	if (addMount)
	{
		msg.add<uint16_t>(outfit.lookMount);
	}
}

void ProtocolGame::addImbuementInfo(NetworkMessage &msg, uint32_t imbuid)
{
	Imbuement *imbuement = g_imbuements->getImbuement(imbuid);
	BaseImbue *base = g_imbuements->getBaseByID(imbuement->getBaseID());
	Category *category = g_imbuements->getCategoryByID(imbuement->getCategory());

	msg.add<uint32_t>(imbuid);
	msg.addString(base->name + " " + imbuement->getName());
	msg.addString(imbuement->getDescription());
	msg.addString(category->name + imbuement->getSubGroup());

	msg.add<uint16_t>(imbuement->getIconID());
	msg.add<uint32_t>(base->duration);

	msg.addByte(imbuement->isPremium() ? 0x01 : 0x00);

	const auto &items = imbuement->getItems();
	msg.addByte(items.size());

	for (const auto &itm : items)
	{
		const ItemType &it = Item::items[itm.first];
		msg.addItemId(itm.first);
		msg.addString(it.name);
		msg.add<uint16_t>(itm.second);
	}

	msg.add<uint32_t>(base->price);
	msg.addByte(base->percent);
	msg.add<uint32_t>(base->protection);
}

void ProtocolGame::sendImbuementWindow(Item *item)
{
	if (!item || item->isRemoved())
	{
		return;
	}

	const ItemType &it = Item::items[item->getID()];
	uint8_t slot = it.imbuingSlots;
	
	/*bool itemHasImbue = false;
	for (uint8_t i = 0; i < slot; i++)
	{
		uint32_t info = item->getImbuement(i);
		if (info >> 8)
		{
			itemHasImbue = true;
			break;
		}
	}*/

	// Seting imbuing item
	player->inImbuing(item);

	NetworkMessage msg;
	msg.addByte(0xEB);
	msg.addItemId(item->getID());
  // n tenho certeza
	if (version >= 1280) {    	
    const ItemType &it = Item::items[item->getID()];
    if (it.classification > 0) {
			msg.addByte(0);
		}
  }
	msg.addByte(slot);

	for (uint8_t i = 0; i < slot; i++)
	{
		uint32_t info = item->getImbuement(i);
		if (info >> 8)
		{
			msg.addByte(0x01);

			addImbuementInfo(msg, (info & 0xFF));
			msg.add<uint32_t>(info >> 8);
			msg.add<uint32_t>(g_imbuements->getBaseByID(g_imbuements->getImbuement((info & 0xFF))->getBaseID())->removecust);
		}
		else
		{
			msg.addByte(0x00);
		}
	}

	std::vector<Imbuement *> imbuements = g_imbuements->getImbuements(player, item);
	std::unordered_map<uint16_t, uint16_t> needItems;
	msg.add<uint16_t>(imbuements.size());
	for (Imbuement *ib : imbuements)
	{
		addImbuementInfo(msg, ib->getId());

		const auto &items = ib->getItems();
		for (const auto &itm : items)
		{
			if (!needItems.count(itm.first))
			{
				needItems[itm.first] = player->getItemTypeCount(itm.first);
				uint32_t stashCount = player->getStashItemCount(Item::items[itm.first].clientId);
				if (stashCount > 0) {
					needItems[itm.first] += stashCount;
				}
			}
		}
	}

	msg.add<uint32_t>(needItems.size());
	for (const auto &itm : needItems)
	{
		msg.addItemId(itm.first);
		msg.add<uint16_t>(itm.second);
	}

	sendResourcesBalance(player->getMoney(), player->getBankBalance(), player->getPreyCards(), player->getTaskHuntingPoints());

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMessageDialog(const std::string &message)
{
	NetworkMessage msg;
	msg.addByte(0xED);
	msg.addByte(0x14); // Unknown type
	msg.addString(message);
	writeToOutputBuffer(msg);
}

void ProtocolGame::AddWorldLight(NetworkMessage &msg, LightInfo lightInfo)
{
	msg.addByte(0x82);
	msg.addByte((player->isAccessPlayer() ? 0xFF : lightInfo.level));
	msg.addByte(lightInfo.color);
}

void ProtocolGame::sendSpecialContainersAvailable()
{
	if (!player)
		return;

	NetworkMessage msg;
	msg.addByte(0x2A);
	msg.addByte(player->isSupplyStashMenuAvailable() ? 0x01 : 0x00);
	msg.addByte(player->isMarketMenuAvailable() ? 0x01 : 0x00);
	writeToOutputBuffer(msg);
}

void ProtocolGame::updatePartyTrackerAnalyzer(const Party* party)
{
	if (!player || !party || !party->getLeader())
		return;

	NetworkMessage msg;
	msg.addByte(0x2B);
	msg.add<uint32_t>(party->getAnalyzerTimeNow());
	msg.add<uint32_t>(party->getLeader()->getID());
	msg.addByte(static_cast<uint8_t>(party->priceType));

	msg.addByte(static_cast<uint8_t>(party->membersData.size()));
	for (const PartyAnalyzer* analyzer : party->membersData) {
		msg.add<uint32_t>(analyzer->id);
		const Player* member = g_game.getPlayerByID(analyzer->id);
		if (!member || !member->getParty() || member->getParty() != party || !party->isSharedExperienceEnabled()) {
			msg.addByte(0);
		} else {
			msg.addByte(1);
		}

		msg.add<uint64_t>(analyzer->lootPrice);
		msg.add<uint64_t>(analyzer->supplyPrice);
		msg.add<uint64_t>(analyzer->damage);
		msg.add<uint64_t>(analyzer->healing);
	}

	bool showNames = true; // This bool is to hide the name on the list. (Why this should be optional? To-Do)
	msg.addByte(showNames ? 0x01 : 0x00);

	if (showNames) {
		msg.addByte(static_cast<uint8_t>(party->membersData.size()));
		for (const PartyAnalyzer* analyzer : party->membersData) {
			msg.add<uint32_t>(analyzer->id);
			msg.addString(analyzer->name);
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::AddCreatureLight(NetworkMessage &msg, const Creature *creature)
{
	LightInfo lightInfo = creature->getCreatureLight();

	msg.addByte(0x8D);
	msg.add<uint32_t>(creature->getID());
	msg.addByte((player->isAccessPlayer() ? 0xFF : lightInfo.level));
	msg.addByte(lightInfo.color);
}

//tile
void ProtocolGame::RemoveTileThing(NetworkMessage &msg, const Position &pos, uint32_t stackpos)
{
	if (stackpos >= 10)
	{
		return;
	}

	msg.addByte(0x6C);
	msg.addPosition(pos);
	msg.addByte(stackpos);
}

void ProtocolGame::RemoveTileCreature(NetworkMessage& msg, const Creature* creature, const Position& pos, uint32_t stackpos)
{
	if (stackpos < 10) {
		RemoveTileThing(msg, pos, stackpos);
		return;
	}

	msg.addByte(0x6C);
	msg.add<uint16_t>(0xFFFF);
	msg.add<uint32_t>(creature->getID());
}


void ProtocolGame::sendKillTrackerUpdate(Container *corpse, const std::string &name, const Outfit_t creatureOutfit)
{
	bool isCorpseEmpty = corpse->empty();

	NetworkMessage msg;
	msg.addByte(0xD1);
	msg.addString(name);
	msg.add<uint16_t>(creatureOutfit.lookType ? creatureOutfit.lookType : 21);
	msg.addByte(creatureOutfit.lookType ? creatureOutfit.lookHead : 0x00);
	msg.addByte(creatureOutfit.lookType ? creatureOutfit.lookBody : 0x00);
	msg.addByte(creatureOutfit.lookType ? creatureOutfit.lookLegs : 0x00);
	msg.addByte(creatureOutfit.lookType ? creatureOutfit.lookFeet : 0x00);
	msg.addByte(creatureOutfit.lookType ? creatureOutfit.lookAddons : 0x00);
	msg.addByte(isCorpseEmpty ? 0 : corpse->size());

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
	msg.addByte(0xCE);
	msg.add<uint16_t>(item->getClientID());

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateImpactTracker(CombatType_t type, int32_t amount)
{
	NetworkMessage msg;
	msg.addByte(0xCC);
	if (type == COMBAT_HEALING)
	{
		msg.addByte(ANALYZER_HEAL);
		msg.add<uint32_t>(amount);
	}
	else
	{
		msg.addByte(ANALYZER_DAMAGE_DEALT);
		msg.add<uint32_t>(amount);
		msg.addByte(getCipbiaElement(type));
	}
	writeToOutputBuffer(msg);
}
void ProtocolGame::sendUpdateInputAnalyzer(CombatType_t type, int32_t amount, std::string target)
{
	NetworkMessage msg;
	msg.addByte(0xCC);
	msg.addByte(ANALYZER_DAMAGE_RECEIVED);
	msg.add<uint32_t>(amount);
	msg.addByte(getCipbiaElement(type));
	msg.addString(target);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTaskHuntingData(const TaskHuntingSlot* slot)
{
	NetworkMessage msg;
	msg.addByte(0xBB);
	msg.addByte(static_cast<uint8_t>(slot->id));
	msg.addByte(static_cast<uint8_t>(slot->state));
	if (slot->state == PreyTaskDataState_Locked) {
		msg.addByte(player->isPremium() ? 0x01 : 0x00);
	} else if (slot->state == PreyTaskDataState_Inactive) {
		// Empty
	} else if (slot->state == PreyTaskDataState_Selection) {
		const Player* user = player;
		msg.add<uint16_t>(static_cast<uint16_t>(slot->raceIdList.size()));
		std::for_each(slot->raceIdList.begin(), slot->raceIdList.end(), [&msg, user](uint16_t raceid)
		{
			msg.add<uint16_t>(raceid);
			msg.addByte(user->isCreatureUnlockedOnTaskHunting(g_monsters.getMonsterTypeByRaceId(raceid)) ? 0x01 : 0x00);
		});
	} else if (slot->state == PreyTaskDataState_ListSelection) {
		const Player* user = player;
		const std::map<uint16_t, std::string> bestiaryList = g_game.getBestiaryList();
		msg.add<uint16_t>(static_cast<uint16_t>(bestiaryList.size()));
		std::for_each(bestiaryList.begin(), bestiaryList.end(), [&msg, user](auto& mType)
		{
			msg.add<uint16_t>(mType.first);
			msg.addByte(user->isCreatureUnlockedOnTaskHunting(g_monsters.getMonsterType(mType.second)) ? 0x01 : 0x00);
		});
	} else if (slot->state == PreyTaskDataState_Active) {
		if (const TaskHuntingOption* option = g_ioprey().GetTaskRewardOption(slot)) {
			msg.add<uint16_t>(slot->selectedRaceId);
			if (slot->upgrade) {
				msg.addByte(0x01);
				msg.add<uint16_t>(option->secondKills);
			} else {
				msg.addByte(0x00);
				msg.add<uint16_t>(option->firstKills);
			}
			msg.add<uint16_t>(slot->currentKills);
			msg.addByte(slot->rarity);
		} else {
			SPDLOG_WARN("[ProtocolGame::sendTaskHuntingData] - Unknown slot option {} on player {}", slot->id, player->getName());
			return;
		}
	} else if (slot->state == PreyTaskDataState_Completed) {
		if (const TaskHuntingOption* option = g_ioprey().GetTaskRewardOption(slot)) {
			msg.add<uint16_t>(slot->selectedRaceId);
			if (slot->upgrade) {
				msg.addByte(0x01);
				msg.add<uint16_t>(option->secondKills);
				msg.add<uint16_t>(std::min<uint16_t>(slot->currentKills, option->secondKills));
			} else {
				msg.addByte(0x00);
				msg.add<uint16_t>(option->firstKills);
				msg.add<uint16_t>(std::min<uint16_t>(slot->currentKills, option->firstKills));
			}
			msg.addByte(slot->rarity);
		} else {
			SPDLOG_WARN("[ProtocolGame::sendTaskHuntingData] - Unknown slot option {} on player {}", slot->id, player->getName());
			return;
		}
	} else {
		SPDLOG_WARN("[ProtocolGame::sendTaskHuntingData] - Unknown task hunting state: {}", slot->state);
		return;
	}

	msg.add<uint32_t>(std::max<uint32_t>(static_cast<uint32_t>(((slot->freeRerollTimeStamp - OTSYS_TIME()) / 1000)), 0));
	writeToOutputBuffer(msg);
}

void ProtocolGame::MoveUpCreature(NetworkMessage &msg, const Creature *creature, const Position &newPos, const Position &oldPos)
{
	if (creature != player)
	{
		return;
	}

	//floor change up
	msg.addByte(0xBE);

	//going to surface
	if (newPos.z == 7)
	{
		int32_t skip = -1;
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, 5, 18, 14, 3, skip); //(floor 7 and 6 already set)
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, 4, 18, 14, 4, skip);
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, 3, 18, 14, 5, skip);
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, 2, 18, 14, 6, skip);
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, 1, 18, 14, 7, skip);
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, 0, 18, 14, 8, skip);

		if (skip >= 0)
		{
			msg.addByte(skip);
			msg.addByte(0xFF);
		}
	}
	//underground, going one floor up (still underground)
	else if (newPos.z > 7)
	{
		int32_t skip = -1;
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, oldPos.getZ() - 3, 18, 14, 3, skip);

		if (skip >= 0)
		{
			msg.addByte(skip);
			msg.addByte(0xFF);
		}
	}

	//moving up a floor up makes us out of sync
	//west
	msg.addByte(0x68);
	GetMapDescription(oldPos.x - 8, oldPos.y - 5, newPos.z, 1, 14, msg);

	//north
	msg.addByte(0x65);
	GetMapDescription(oldPos.x - 8, oldPos.y - 6, newPos.z, 18, 1, msg);
}

void ProtocolGame::MoveDownCreature(NetworkMessage &msg, const Creature *creature, const Position &newPos, const Position &oldPos)
{
	if (creature != player)
	{
		return;
	}

	//floor change down
	msg.addByte(0xBF);

	//going from surface to underground
	if (newPos.z == 8)
	{
		int32_t skip = -1;

		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, newPos.z, 18, 14, -1, skip);
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, newPos.z + 1, 18, 14, -2, skip);
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, newPos.z + 2, 18, 14, -3, skip);

		if (skip >= 0)
		{
			msg.addByte(skip);
			msg.addByte(0xFF);
		}
	}
	//going further down
	else if (newPos.z > oldPos.z && newPos.z > 8 && newPos.z < 14)
	{
		int32_t skip = -1;
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, newPos.z + 2, 18, 14, -3, skip);

		if (skip >= 0)
		{
			msg.addByte(skip);
			msg.addByte(0xFF);
		}
	}

	//moving down a floor makes us out of sync
	//east
	msg.addByte(0x66);
	GetMapDescription(oldPos.x + 9, oldPos.y - 7, newPos.z, 1, 14, msg);

	//south
	msg.addByte(0x67);
	GetMapDescription(oldPos.x - 8, oldPos.y + 7, newPos.z, 18, 1, msg);
}

void ProtocolGame::AddShopItem(NetworkMessage &msg, const ShopInfo &item)
{
	const ItemType &it = Item::items[item.itemId];
	msg.add<uint16_t>(it.clientId);

	if (it.isSplash() || it.isFluidContainer())
	{
		msg.addByte(serverFluidToClient(item.subType));
	}
	else
	{
		msg.addByte(0x00);
	}

	msg.addString(item.realName);
	msg.add<uint32_t>(it.weight);
	msg.add<uint32_t>(item.buyPrice == 4294967295 ? 0 : item.buyPrice);
	msg.add<uint32_t>(item.sellPrice == 4294967295 ? 0 : item.sellPrice);
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
    if (version <= 1200) {
        return;
    } 

    NetworkMessage msg;
    
    msg.addByte(0xCD);

    bool version1280 = false;
    if (version >= 1280) { 
        version1280 = true; 
    }      
  
    msg.add<uint16_t>(g_game.getItemsPriceCount());
    if (g_game.getItemsPriceCount() > 0) {
        std::map<uint16_t, uint32_t> items = g_game.getItemsPrice();
        for (const auto& it : items) {
            msg.addItemId(it.first);
            if (version1280) {
                if (Item::items[it.first].classification > 0) {
                    msg.addByte(0);
                }
            }
            msg.add<uint32_t>(it.second);

            if (version1280) {
                msg.add<uint32_t>(0);
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

	std::unordered_set<uint32_t>::iterator it = std::find(knownCreatureSet.begin(), knownCreatureSet.end(), creature->getID());
	if (it != knownCreatureSet.end())
	{
		msg.addByte(0x6B);
		msg.addPosition(creature->getPosition());
		msg.addByte(stackpos);
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
	msg.addByte(0x29);
	StashItemList list = player->getStashItems();
	msg.add<uint16_t>(list.size());
	for (auto item : list) {
		msg.add<uint16_t>(item.first);
		msg.add<uint32_t>(item.second);
	}
	msg.add<uint16_t>(g_config.getNumber(ConfigManager::STASH_ITEMS) - getStashSize(list));
	writeToOutputBuffer(msg);
}

void ProtocolGame::parseStashWithdraw(NetworkMessage &msg)
{
	// if (!player->isSupplyStashMenuAvailable()) {
		// player->sendCancelMessage("You can't use supply stash right now.");
		// return;
	// }
	if (player->isStashExhausted()) {
		player->sendCancelMessage("You need to wait to do this again.");
		return;
	}

	Supply_Stash_Actions_t action = static_cast<Supply_Stash_Actions_t>(msg.getByte());
	switch (action)	{
		case SUPPLY_STASH_ACTION_STOW_ITEM: {
			Position pos = msg.getPosition();
			uint16_t spriteId = msg.get<uint16_t>();
			uint8_t stackpos = msg.getByte();
			uint32_t count = msg.getByte();
			addGameTask(&Game::playerStowItem, player->getID(), pos, spriteId, stackpos, count, false);
			break;
		}
		case SUPPLY_STASH_ACTION_STOW_CONTAINER: {
			Position pos = msg.getPosition();
			uint16_t spriteId = msg.get<uint16_t>();
			uint8_t stackpos = msg.getByte();
			addGameTask(&Game::playerStowItem, player->getID(), pos, spriteId, stackpos, 0, false);
			break;
		}
		case SUPPLY_STASH_ACTION_STOW_STACK: {
			Position pos = msg.getPosition();
			uint16_t spriteId = msg.get<uint16_t>();
			uint8_t stackpos = msg.getByte();
			addGameTask(&Game::playerStowItem, player->getID(), pos, spriteId, stackpos, 0, true);
			break;
		}
		case SUPPLY_STASH_ACTION_WITHDRAW: {
			uint16_t spriteId = msg.get<uint16_t>();
			uint32_t count = msg.get<uint32_t>();
			uint8_t stackpos = msg.getByte();
			addGameTask(&Game::playerStashWithdraw, player->getID(), spriteId, count, stackpos);
			break;
		}
		default:
			SPDLOG_ERROR("Unknown 'supply stash' action switch: {}", action);
			break;
	}

	player->updateStashExhausted();
}

void ProtocolGame::sendLockerItems(std::map<uint16_t, uint16_t> itemMap, uint16_t count)
{
	NetworkMessage msg;
	msg.addByte(0x94);

	msg.add<uint16_t>(count);
	for (const auto &it : itemMap)
	{
		msg.addItemId(it.first);
		msg.add<uint16_t>(it.second);
	}

	writeToOutputBuffer(msg);
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
    msg.addByte(0x6B);
    msg.addPosition(creature->getPosition());
    msg.addByte(stackPos);
    AddCreature(msg, creature, false, 0);
    writeToOutputBuffer(msg);
}