#pragma once

namespace WebSocketEvents {
	// Eventos do Sistema
	inline const std::string SYSTEM_RESOURCES = "system_resources";

	// Eventos de Jogador
	inline const std::string PLAYER_LOGIN = "player_login";
	inline const std::string PLAYER_LOGOUT = "player_logout";
	inline const std::string PLAYER_DEATH = "player_death";
	inline const std::string PLAYER_LEVEL_UP = "player_level_up";
	inline const std::string PLAYER_STATUS_UPDATE = "player_status_update";

	// Eventos de Chat
	inline const std::string CHAT_GLOBAL = "chat_global";
	inline const std::string CHAT_TRADE = "chat_trade";
	inline const std::string CHAT_HELP = "chat_help";
	inline const std::string CHAT_HISTORY = "chat_history";

	// Eventos do Servidor
	inline const std::string SERVER_STATUS = "server_status";
	inline const std::string SERVER_SAVE = "server_save";
	inline const std::string SERVER_SHUTDOWN = "server_shutdown";

	// Lista de eventos válidos
	inline const std::unordered_set<std::string> VALID_EVENTS = {
		SYSTEM_RESOURCES,
		PLAYER_LOGIN,
		PLAYER_LOGOUT,
		PLAYER_DEATH,
		PLAYER_LEVEL_UP,
		PLAYER_STATUS_UPDATE,
		CHAT_GLOBAL,
		CHAT_TRADE,
		CHAT_HELP,
		CHAT_HISTORY,
		SERVER_STATUS,
		SERVER_SAVE,
		SERVER_SHUTDOWN,

	};

	// Verifica se um evento é válido
	inline bool isValidEvent(const std::string &event) {
		return VALID_EVENTS.contains(event);
	}
}
