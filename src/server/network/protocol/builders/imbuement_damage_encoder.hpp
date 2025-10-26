#pragma once

class NetworkMessage;
class Player;

class ImbuementDamageEncoder {
public:
	static void writeDamage(NetworkMessage &msg, const std::shared_ptr<Player> &player);
	static void writeAbsorbValues(const std::shared_ptr<Player> &player, NetworkMessage &msg, uint8_t &combats, bool fromPlayerSkills = false);
};
