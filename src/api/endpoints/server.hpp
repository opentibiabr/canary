#pragma once

class ServerEndpoints {
public:
	ServerEndpoints();
	~ServerEndpoints();

	static crow::response getStatus();
	static crow::response getMotd();
	static crow::response getResources();
	static crow::response setGameState(const crow::request &req);
private:
	static const std::unordered_map<GameState_t, std::string> &getGameStatesMap();
	static std::string getGameStateString(GameState_t state);
	static GameState_t parseGameState(const std::string &stateStr);
};
