/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "server/network/protocol/protocolstatus.hpp"

#include "config/configmanager.hpp"
#include "core.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "server/network/message/outputmessage.hpp"
#include <nlohmann/json.hpp>

void ProtocolStatus::onRecvFirstMessage(NetworkMessage &msg) noexcept {
	const uint32_t ip = getIP();
	if (ip != 0x0100007F) {
		const auto ipStr = convertIPToString(ip);
		if (ipStr != g_configManager().getString(IP)) {
			const auto it = ipConnectMap.find(ip);
			if (it != ipConnectMap.end()) {
				const auto now = std::chrono::steady_clock::now();
				const auto timeout = std::chrono::milliseconds(g_configManager().getNumber(STATUSQUERY_TIMEOUT));
				if (now < (it->second + timeout)) {
					disconnect();
					return;
				}
			}
		}
	}

	ipConnectMap[ip] = std::chrono::steady_clock::now();

	switch (msg.getByte()) {
		// XML info protocol
		case 0xFF: {
			const auto command = msg.getString(4);
			if (command == "info") {
				g_dispatcher().addEvent(
					[self = std::static_pointer_cast<ProtocolStatus>(shared_from_this())] {
						self->sendStatusString();
					},
					__FUNCTION__
				);
				return;
			}

			if (command == "json") {
				g_dispatcher().addEvent(
					[self = std::static_pointer_cast<ProtocolStatus>(shared_from_this())] {
						self->sendStatusStringJson();
					},
					__FUNCTION__
				);
				return;
			}
			break;
		}

		// Another ServerInfo protocol
		case 0x01: {
			const auto requestedInfo = msg.get<uint16_t>();
			std::string characterName;
			if (requestedInfo & REQUEST_PLAYER_STATUS_INFO) {
				characterName = msg.getString();
			}

			g_dispatcher().addEvent(
				[self = std::static_pointer_cast<ProtocolStatus>(shared_from_this()),
			     requestedInfo,
			     characterName = std::move(characterName)] {
					self->sendInfo(requestedInfo, characterName);
				},
				__FUNCTION__
			);
			return;
		}

		default:
			break;
	}
	disconnect();
}

void ProtocolStatus::sendStatusString() {
	const auto output = OutputMessagePool::getOutputMessage();

	setRawMessages(true);

	pugi::xml_document doc;

	pugi::xml_node decl = doc.prepend_child(pugi::node_declaration);
	decl.append_attribute("version") = "1.0";

	pugi::xml_node tsqp = doc.append_child("tsqp");
	tsqp.append_attribute("version") = "1.0";

	const auto now = std::chrono::steady_clock::now();
	const auto uptime = std::chrono::duration_cast<std::chrono::seconds>(now - start).count();
	const auto clientVersion = fmt::format("{}.{}", CLIENT_VERSION_UPPER, CLIENT_VERSION_LOWER);

	// Server Information
	auto &config = g_configManager();
	pugi::xml_node serverinfo = tsqp.append_child("serverinfo");
	serverinfo.append_attribute("uptime") = std::to_string(uptime).c_str();
	serverinfo.append_attribute("ip") = config.getString(IP).c_str();
	serverinfo.append_attribute("servername") = config.getString(ConfigKey_t::SERVER_NAME).c_str();
	serverinfo.append_attribute("port") = std::to_string(config.getNumber(LOGIN_PORT)).c_str();
	serverinfo.append_attribute("location") = config.getString(LOCATION).c_str();
	serverinfo.append_attribute("url") = config.getString(URL).c_str();
	serverinfo.append_attribute("server") = SERVER_NAME.c_str();
	serverinfo.append_attribute("version") = SERVER_VERSION.c_str();
	serverinfo.append_attribute("client") = clientVersion.c_str();

	// Owner Information
	pugi::xml_node owner = tsqp.append_child("owner");
	owner.append_attribute("name") = config.getString(OWNER_NAME).c_str();
	owner.append_attribute("email") = config.getString(OWNER_EMAIL).c_str();

	// Player Statistics
	const auto &[totalPlayers, totalUniqueIPs] = g_game().getPlayerStats();
	pugi::xml_node players = tsqp.append_child("players");
	players.append_attribute("online") = std::to_string(totalPlayers).c_str();
	players.append_attribute("unique") = std::to_string(totalUniqueIPs).c_str();
	players.append_attribute("max") = std::to_string(config.getNumber(MAX_PLAYERS)).c_str();
	players.append_attribute("peak") = std::to_string(g_game().getPlayersRecord()).c_str();

	// Monster and NPC Statistics
	pugi::xml_node monsters = tsqp.append_child("monsters");
	monsters.append_attribute("total") = std::to_string(g_game().getMonstersOnline()).c_str();

	pugi::xml_node npcs = tsqp.append_child("npcs");
	npcs.append_attribute("total") = std::to_string(g_game().getNpcsOnline()).c_str();

	// Rates Information
	pugi::xml_node rates = tsqp.append_child("rates");
	std::vector<std::pair<const char*, uint32_t>> rateAttributes = {
		{ "experience", config.getNumber(RATE_EXPERIENCE) },
		{ "skill", config.getNumber(RATE_SKILL) },
		{ "loot", config.getNumber(RATE_LOOT) },
		{ "magic", config.getNumber(RATE_MAGIC) },
		{ "spawn", config.getNumber(RATE_SPAWN) }
	};
	for (const auto &[name, value] : rateAttributes) {
		rates.append_attribute(name) = std::to_string(value).c_str();
	}

	// Map Information
	uint32_t mapWidth, mapHeight;
	g_game().getMapDimensions(mapWidth, mapHeight);
	pugi::xml_node map = tsqp.append_child("map");
	map.append_attribute("name") = config.getString(MAP_NAME).c_str();
	map.append_attribute("author") = config.getString(MAP_AUTHOR).c_str();
	map.append_attribute("width") = std::to_string(mapWidth).c_str();
	map.append_attribute("height") = std::to_string(mapHeight).c_str();

	// Message of the Day
	pugi::xml_node motd = tsqp.append_child("motd");
	motd.text() = config.getString(SERVER_MOTD).c_str();

	std::ostringstream ss;
	doc.save(ss, "", pugi::format_raw);

	const std::string data = ss.str();
	output->addBytes(data.c_str(), data.size());
	send(output);
	disconnect();
}

void ProtocolStatus::sendStatusStringJson() {
	const auto output = OutputMessagePool::getOutputMessage();

	setRawMessages(true);

	nlohmann::json statusJson;

	// Server Information
	const auto serverName = g_configManager().getString(ConfigKey_t::SERVER_NAME);
	const auto serverURL = g_configManager().getString(URL);
	statusJson["serverinfo"] = {
		{ "uptime", std::chrono::duration_cast<std::chrono::seconds>(std::chrono::steady_clock::now() - start).count() },
		{ "ip", g_configManager().getString(IP) },
		{ "servername", serverName },
		{ "port", g_configManager().getNumber(LOGIN_PORT) },
		{ "location", g_configManager().getString(LOCATION) },
		{ "url", serverURL },
		{ "server", SERVER_NAME },
		{ "version", SERVER_VERSION },
		{ "client", fmt::format("{}.{}", CLIENT_VERSION_UPPER, CLIENT_VERSION_LOWER) }
	};

	// Owner Information
	statusJson["owner"] = {
		{ "name", g_configManager().getString(OWNER_NAME) },
		{ "email", g_configManager().getString(OWNER_EMAIL) }
	};

	// Players Information
	const auto &[totalPlayers, totalUniqueIPs] = g_game().getPlayerStats();
	statusJson["players"] = {
		{ "online", totalPlayers },
		{ "player_unique", totalUniqueIPs },
		{ "max", g_configManager().getNumber(MAX_PLAYERS) },
		{ "peak", g_game().getPlayersRecord() }
	};

	// Monsters and NPCs
	statusJson["monsters"] = { { "total", g_game().getMonstersOnline() } };
	statusJson["npcs"] = { { "total", g_game().getNpcsOnline() } };

	// Rates Information
	statusJson["rates"] = {
		{ "experience", g_configManager().getNumber(RATE_EXPERIENCE) },
		{ "skill", g_configManager().getNumber(RATE_SKILL) },
		{ "loot", g_configManager().getNumber(RATE_LOOT) },
		{ "magic", g_configManager().getNumber(RATE_MAGIC) },
		{ "spawn", g_configManager().getNumber(RATE_SPAWN) }
	};

	// Map Information
	uint32_t mapWidth, mapHeight;
	g_game().getMapDimensions(mapWidth, mapHeight);
	statusJson["map"] = {
		{ "name", g_configManager().getString(MAP_NAME) },
		{ "author", g_configManager().getString(MAP_AUTHOR) },
		{ "width", mapWidth },
		{ "height", mapHeight }
	};

	// Message of the Day
	statusJson["motd"] = g_configManager().getString(SERVER_MOTD);

	// Serialize JSON to string
	const std::string data = statusJson.dump();

	// Send JSON data
	output->addBytes(data.data(), data.size());
	send(output);
	disconnect();
}

void ProtocolStatus::sendInfo(uint16_t requestedInfo, const std::string &characterName) const {
	const auto output = OutputMessagePool::getOutputMessage();

	if (requestedInfo & REQUEST_BASIC_SERVER_INFO) {
		output->addByte(0x10);
		output->addString(g_configManager().getString(ConfigKey_t::SERVER_NAME));
		output->addString(g_configManager().getString(IP));
		output->addString(std::to_string(g_configManager().getNumber(LOGIN_PORT)));
	}

	if (requestedInfo & REQUEST_OWNER_SERVER_INFO) {
		output->addByte(0x11);
		output->addString(g_configManager().getString(OWNER_NAME));
		output->addString(g_configManager().getString(OWNER_EMAIL));
	}

	if (requestedInfo & REQUEST_MISC_SERVER_INFO) {
		output->addByte(0x12);
		output->addString(g_configManager().getString(SERVER_MOTD));
		output->addString(g_configManager().getString(LOCATION));
		output->addString(g_configManager().getString(URL));
		output->add<uint64_t>(std::chrono::duration_cast<std::chrono::seconds>(std::chrono::steady_clock::now() - start).count());
	}

	if (requestedInfo & REQUEST_PLAYERS_INFO) {
		output->addByte(0x20);
		output->add<uint32_t>(static_cast<uint32_t>(g_game().getPlayersOnline()));
		output->add<uint32_t>(g_configManager().getNumber(MAX_PLAYERS));
		output->add<uint32_t>(g_game().getPlayersRecord());
	}

	if (requestedInfo & REQUEST_MAP_INFO) {
		output->addByte(0x30);
		output->addString(g_configManager().getString(MAP_NAME));
		output->addString(g_configManager().getString(MAP_AUTHOR));
		uint32_t mapWidth, mapHeight;
		g_game().getMapDimensions(mapWidth, mapHeight);
		output->add<uint16_t>(mapWidth);
		output->add<uint16_t>(mapHeight);
	}

	if (requestedInfo & REQUEST_EXT_PLAYERS_INFO) {
		output->addByte(0x21); // players info - online players list

		const auto players = g_game().getPlayers();
		output->add<uint32_t>(players.size());
		for (const auto &player : players | std::views::values) {
			output->addString(player->getName());
			output->add<uint32_t>(player->getLevel());
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
		output->addString(SERVER_NAME);
		output->addString(SERVER_VERSION);
		output->addString(fmt::format("{}.{}", CLIENT_VERSION_UPPER, CLIENT_VERSION_LOWER));
	}
	send(output);
	disconnect();
}
