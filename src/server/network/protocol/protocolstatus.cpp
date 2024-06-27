/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "core.hpp"

#include "server/network/protocol/protocolstatus.hpp"

#include "config/configmanager.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "server/network/message/outputmessage.hpp"

std::string ProtocolStatus::SERVER_NAME = "Canary";
std::string ProtocolStatus::SERVER_VERSION = "3.0";
std::string ProtocolStatus::SERVER_DEVELOPERS = "OpenTibiaBR Organization";

std::map<uint32_t, int64_t> ProtocolStatus::ipConnectMap;
const uint64_t ProtocolStatus::start = OTSYS_TIME(true);

void ProtocolStatus::onRecvFirstMessage(NetworkMessage &msg) {
	uint32_t ip = getIP();
	if (ip != 0x0100007F) {
		std::string ipStr = convertIPToString(ip);
		if (ipStr != g_configManager().getString(IP, __FUNCTION__)) {
			std::map<uint32_t, int64_t>::const_iterator it = ipConnectMap.find(ip);
			if (it != ipConnectMap.end() && (OTSYS_TIME() < (it->second + g_configManager().getNumber(STATUSQUERY_TIMEOUT, __FUNCTION__)))) {
				disconnect();
				return;
			}
		}
	}

	ipConnectMap[ip] = OTSYS_TIME();

	switch (msg.getByte()) {
		// XML info protocol
		case 0xFF: {
			if (msg.getString(4) == "info") {
				g_dispatcher().addEvent([self = std::static_pointer_cast<ProtocolStatus>(shared_from_this())] {
					self->sendStatusString();
				},
				                        "ProtocolStatus::sendStatusString");
				return;
			}
			break;
		}

		// Another ServerInfo protocol
		case 0x01: {
			uint16_t requestedInfo = msg.get<uint16_t>(); // only a Byte is necessary, though we could add new info here
			std::string characterName;
			if (requestedInfo & REQUEST_PLAYER_STATUS_INFO) {
				characterName = msg.getString();
			}
			g_dispatcher().addEvent([self = std::static_pointer_cast<ProtocolStatus>(shared_from_this()), requestedInfo, characterName] {
				self->sendInfo(requestedInfo, characterName);
			},
			                        "ProtocolStatus::sendInfo");

			return;
		}

		default:
			break;
	}
	disconnect();
}

void ProtocolStatus::sendStatusString() {
	auto output = OutputMessagePool::getOutputMessage();

	setRawMessages(true);

	pugi::xml_document doc;

	pugi::xml_node decl = doc.prepend_child(pugi::node_declaration);
	decl.append_attribute("version") = "1.0";

	pugi::xml_node tsqp = doc.append_child("tsqp");
	tsqp.append_attribute("version") = "1.0";

	pugi::xml_node serverinfo = tsqp.append_child("serverinfo");
	uint64_t uptime = (OTSYS_TIME() - ProtocolStatus::start) / 1000;
	serverinfo.append_attribute("uptime") = std::to_string(uptime).c_str();
	serverinfo.append_attribute("ip") = g_configManager().getString(IP, __FUNCTION__).c_str();
	serverinfo.append_attribute("servername") = g_configManager().getString(ConfigKey_t::SERVER_NAME, __FUNCTION__).c_str();
	serverinfo.append_attribute("port") = std::to_string(g_configManager().getNumber(LOGIN_PORT, __FUNCTION__)).c_str();
	serverinfo.append_attribute("location") = g_configManager().getString(LOCATION, __FUNCTION__).c_str();
	serverinfo.append_attribute("url") = g_configManager().getString(URL, __FUNCTION__).c_str();
	serverinfo.append_attribute("server") = ProtocolStatus::SERVER_NAME.c_str();
	serverinfo.append_attribute("version") = ProtocolStatus::SERVER_VERSION.c_str();
	serverinfo.append_attribute("client") = fmt::format("{}.{}", CLIENT_VERSION_UPPER, CLIENT_VERSION_LOWER).c_str();

	pugi::xml_node owner = tsqp.append_child("owner");
	owner.append_attribute("name") = g_configManager().getString(OWNER_NAME, __FUNCTION__).c_str();
	owner.append_attribute("email") = g_configManager().getString(OWNER_EMAIL, __FUNCTION__).c_str();

	pugi::xml_node players = tsqp.append_child("players");
	uint32_t real = 0;
	std::map<uint32_t, uint32_t> listIP;
	for (const auto &[key, player] : g_game().getPlayers()) {
		if (player->getIP() != 0) {
			auto ip = listIP.find(player->getIP());
			if (ip != listIP.end()) {
				listIP[player->getIP()]++;
				if (listIP[player->getIP()] < 5) {
					real++;
				}
			} else {
				listIP[player->getIP()] = 1;
				real++;
			}
		}
	}
	players.append_attribute("online") = std::to_string(real).c_str();
	players.append_attribute("max") = std::to_string(g_configManager().getNumber(MAX_PLAYERS, __FUNCTION__)).c_str();
	players.append_attribute("peak") = std::to_string(g_game().getPlayersRecord()).c_str();

	pugi::xml_node monsters = tsqp.append_child("monsters");
	monsters.append_attribute("total") = std::to_string(g_game().getMonstersOnline()).c_str();

	pugi::xml_node npcs = tsqp.append_child("npcs");
	npcs.append_attribute("total") = std::to_string(g_game().getNpcsOnline()).c_str();

	pugi::xml_node rates = tsqp.append_child("rates");
	rates.append_attribute("experience") = std::to_string(g_configManager().getNumber(RATE_EXPERIENCE, __FUNCTION__)).c_str();
	rates.append_attribute("skill") = std::to_string(g_configManager().getNumber(RATE_SKILL, __FUNCTION__)).c_str();
	rates.append_attribute("loot") = std::to_string(g_configManager().getNumber(RATE_LOOT, __FUNCTION__)).c_str();
	rates.append_attribute("magic") = std::to_string(g_configManager().getNumber(RATE_MAGIC, __FUNCTION__)).c_str();
	rates.append_attribute("spawn") = std::to_string(g_configManager().getNumber(RATE_SPAWN, __FUNCTION__)).c_str();

	pugi::xml_node map = tsqp.append_child("map");
	map.append_attribute("name") = g_configManager().getString(MAP_NAME, __FUNCTION__).c_str();
	map.append_attribute("author") = g_configManager().getString(MAP_AUTHOR, __FUNCTION__).c_str();

	uint32_t mapWidth, mapHeight;
	g_game().getMapDimensions(mapWidth, mapHeight);
	map.append_attribute("width") = std::to_string(mapWidth).c_str();
	map.append_attribute("height") = std::to_string(mapHeight).c_str();

	pugi::xml_node motd = tsqp.append_child("motd");
	motd.text() = g_configManager().getString(SERVER_MOTD, __FUNCTION__).c_str();

	std::ostringstream ss;
	doc.save(ss, "", pugi::format_raw);

	std::string data = ss.str();
	output->addBytes(data.c_str(), data.size());
	send(output);
	disconnect();
}

void ProtocolStatus::sendInfo(uint16_t requestedInfo, const std::string &characterName) {
	auto output = OutputMessagePool::getOutputMessage();

	if (requestedInfo & REQUEST_BASIC_SERVER_INFO) {
		output->addByte(0x10);
		output->addString(g_configManager().getString(ConfigKey_t::SERVER_NAME, __FUNCTION__), "ProtocolStatus::sendInfo - g_configManager().getString(stringConfig_t::SERVER_NAME)");
		output->addString(g_configManager().getString(IP, __FUNCTION__), "ProtocolStatus::sendInfo - g_configManager().getString(IP)");
		output->addString(std::to_string(g_configManager().getNumber(LOGIN_PORT, __FUNCTION__)), "ProtocolStatus::sendInfo - std::to_string(g_configManager().getNumber(LOGIN_PORT))");
	}

	if (requestedInfo & REQUEST_OWNER_SERVER_INFO) {
		output->addByte(0x11);
		output->addString(g_configManager().getString(OWNER_NAME, __FUNCTION__), "ProtocolStatus::sendInfo - g_configManager().getString(OWNER_NAME)");
		output->addString(g_configManager().getString(OWNER_EMAIL, __FUNCTION__), "ProtocolStatus::sendInfo - g_configManager().getString(OWNER_EMAIL)");
	}

	if (requestedInfo & REQUEST_MISC_SERVER_INFO) {
		output->addByte(0x12);
		output->addString(g_configManager().getString(SERVER_MOTD, __FUNCTION__), "ProtocolStatus::sendInfo - g_configManager().getString(SERVER_MOTD)");
		output->addString(g_configManager().getString(LOCATION, __FUNCTION__), "ProtocolStatus::sendInfo - g_configManager().getString(LOCATION)");
		output->addString(g_configManager().getString(URL, __FUNCTION__), "ProtocolStatus::sendInfo - g_configManager().getString(URL)");
		output->add<uint64_t>((OTSYS_TIME() - ProtocolStatus::start) / 1000);
	}

	if (requestedInfo & REQUEST_PLAYERS_INFO) {
		output->addByte(0x20);
		output->add<uint32_t>(static_cast<uint32_t>(g_game().getPlayersOnline()));
		output->add<uint32_t>(g_configManager().getNumber(MAX_PLAYERS, __FUNCTION__));
		output->add<uint32_t>(g_game().getPlayersRecord());
	}

	if (requestedInfo & REQUEST_MAP_INFO) {
		output->addByte(0x30);
		output->addString(g_configManager().getString(MAP_NAME, __FUNCTION__), "ProtocolStatus::sendInfo - g_configManager().getString(MAP_NAME)");
		output->addString(g_configManager().getString(MAP_AUTHOR, __FUNCTION__), "ProtocolStatus::sendInfo - g_configManager().getString(MAP_AUTHOR)");
		uint32_t mapWidth, mapHeight;
		g_game().getMapDimensions(mapWidth, mapHeight);
		output->add<uint16_t>(mapWidth);
		output->add<uint16_t>(mapHeight);
	}

	if (requestedInfo & REQUEST_EXT_PLAYERS_INFO) {
		output->addByte(0x21); // players info - online players list

		const auto players = g_game().getPlayers();
		output->add<uint32_t>(players.size());
		for (const auto &it : players) {
			output->addString(it.second->getName(), "ProtocolStatus::sendInfo - it.second->getName()");
			output->add<uint32_t>(it.second->getLevel());
		}
	}

	if (requestedInfo & REQUEST_PLAYER_STATUS_INFO) {
		output->addByte(0x22); // players info - online status info of a player
		if (g_game().getPlayerByName(characterName) != nullptr) {
			output->addByte(0x01);
		} else {
			output->addByte(0x00);
		}
	}

	if (requestedInfo & REQUEST_SERVER_SOFTWARE_INFO) {
		output->addByte(0x23); // server software info
		output->addString(ProtocolStatus::SERVER_NAME, "ProtocolStatus::sendInfo - ProtocolStatus::SERVER_NAME");
		output->addString(ProtocolStatus::SERVER_VERSION, "ProtocolStatus::sendInfo - ProtocolStatus::SERVER_VERSION)");
		output->addString(fmt::format("{}.{}", CLIENT_VERSION_UPPER, CLIENT_VERSION_LOWER), "ProtocolStatus::sendInfo - fmt::format(CLIENT_VERSION_UPPER, CLIENT_VERSION_LOWER)");
	}
	send(output);
	disconnect();
}
