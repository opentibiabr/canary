#pragma once

class BroadcastManager {
public:
    static BroadcastManager &getInstance();

	void start();
	void stop();

    static void broadcastChatMessage(const std::string &playerName, uint32_t level, const std::string &message, const std::string &channel);
	static void broadcastChatMessageHistory() ;

private:
    BroadcastManager();
    ~BroadcastManager();

	static void broadcastSystemResources();
	static void broadcastServerStatus();

	std::atomic<bool> running{false};
    std::jthread broadcastThread;
};
