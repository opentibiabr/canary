#pragma once

class PlayerEndpoints {
public:
	PlayerEndpoints();
	~PlayerEndpoints();

	static crow::response getOnlinePlayers();
	static crow::response getPlayerInfo(const std::string &name);
};
