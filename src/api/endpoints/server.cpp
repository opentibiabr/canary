//
// Created by danie on 25/01/2025.
//

#include "pch.hpp"
#include "api/endpoints/server.hpp"
#include "server/network/protocol/protocolstatus.hpp"
#include "api/utils/system_info.hpp"

ServerEndpoints::ServerEndpoints() = default;
ServerEndpoints::~ServerEndpoints() = default;

crow::response ServerEndpoints::getStatus() {
	try {
		const json data = {
			{ "status", getGameStateString(g_game().getGameState()) },
			{ "uptime", (OTSYS_TIME(true) - ProtocolStatus::start) / 1000 },
			{ "players_online", g_game().getPlayersOnline() },
			{ "max_players", g_configManager().getNumber(MAX_PLAYERS) },
			{ "server_version", std::string(ProtocolStatus::SERVER_VERSION) },
			{ "server_name", g_configManager().getString(SERVER_NAME) },
			{ "server_location", std::string(g_configManager().getString(LOCATION)) },
			{ "server_ip", g_configManager().getString(IP) }
		};

		return APIResponse::ok(data);
	} catch (const std::exception &e) {
		return APIResponse::erro(500, "Erro ao buscar status do servidor: " + std::string(e.what()));
	}
}
crow::response ServerEndpoints::getMotd() {
	try {
		const json data = {
			{ "motd", g_configManager().getString(SERVER_MOTD) }
		};

		return APIResponse::ok(data);
	} catch (const std::exception &e) {
		return APIResponse::erro(500, "Erro ao buscar SERVER_MOTD: " + std::string(e.what()));
	}
}
crow::response ServerEndpoints::getResources() {
	try {
		const auto resources = SystemInfo::getSystemResources();
		return APIResponse::ok(resources);
	} catch (const std::exception &e) {
		return APIResponse::erro(500, "Erro ao buscar recursos do sistema: " + std::string(e.what()));
	}
}
crow::response ServerEndpoints::setGameState(const crow::request &req) {
	try {
		const auto bodyData = crow::json::load(req.body);

		if (!bodyData.has("state")) {
			return APIResponse::erro(400, "Campo 'state' é obrigatório");
		}

		const std::string newStateStr = bodyData["state"].s();
		GameState_t newState;

		try {
			newState = parseGameState(newStateStr);
		} catch (const std::runtime_error &e) {
			return APIResponse::erro(400, e.what());
		}

		// Verifica se o estado atual é SHUTDOWN
		if (g_game().getGameState() == GAME_STATE_SHUTDOWN) {
			return APIResponse::erro(400, "Não é possível alterar o estado quando o servidor está desligando");
		}

		g_game().setGameState(newState);

		const json data = {
			{ "status", "success" },
			{ "new_state", getGameStateString(newState) }
		};

		return APIResponse::ok(data);
	} catch (const nlohmann::json::parse_error &e) {
		return APIResponse::erro(400, "JSON inválido: " + std::string(e.what()));
	} catch (const std::exception &e) {
		return APIResponse::erro(500, "Erro ao alterar estado do servidor: " + std::string(e.what()));
	}
}
const std::unordered_map<GameState_t, std::string> &ServerEndpoints::getGameStatesMap() {
	static const std::unordered_map<GameState_t, std::string> states = {
		{ GAME_STATE_NORMAL, "online" },
		{ GAME_STATE_CLOSED, "fechado" },
		{ GAME_STATE_SHUTDOWN, "desligando" },
		{ GAME_STATE_MAINTAIN, "manutenção" }
	};
	return states;
}

std::string ServerEndpoints::getGameStateString(const GameState_t state) {
	const auto &states = getGameStatesMap();
	const auto it = states.find(state);
	return it != states.end() ? it->second : "desconhecido";
}
GameState_t ServerEndpoints::parseGameState(const std::string &stateStr) {
	const auto &states = getGameStatesMap();
	for (const auto &[state, str] : states) {
		if (str == stateStr) {
			return state;
		}
	}
	throw std::runtime_error("Estado do jogo inválido");
}
