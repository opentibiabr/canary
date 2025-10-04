#pragma once

class NetworkMessage;
class Player;
class PreySlot;
class TaskHuntingSlot;

enum PreyDataState_t : uint8_t;
enum PreyOption_t : uint8_t;
enum PreyTaskDataState_t : uint8_t;

class PreyMessageBuilder {
public:
	static void writeTimeLeft(NetworkMessage &msg, const PreySlot &slot);
	static bool writePreySlot(NetworkMessage &msg, const std::shared_ptr<Player> &player, const std::unique_ptr<PreySlot> &slot, bool oldProtocol);
	static void writePreyPrices(NetworkMessage &msg, const std::shared_ptr<Player> &player, bool oldProtocol);
	static bool writeTaskSlot(NetworkMessage &msg, const std::shared_ptr<Player> &player, const std::unique_ptr<TaskHuntingSlot> &slot);
};
