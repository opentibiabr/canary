#pragma once

class PlayerEndpoints {
public:
	PlayerEndpoints();
	~PlayerEndpoints();

	static crow::response getOnlinePlayers();
	static crow::response getPlayerInfo(const std::string &name);
	static crow::response kickPlayer(const crow::request &req);
	static crow::response banOrUnbanPlayer(const crow::request &req);
	static crow::response getBanHistory(const crow::request &req);
	static crow::response getBannedPlayers(const crow::request &req);
};
