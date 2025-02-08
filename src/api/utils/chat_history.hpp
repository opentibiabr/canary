#pragma once

class ChatHistory {
public:
	ChatHistory();
	~ChatHistory();
	static ChatHistory &getInstance();

	void addMessage(const std::string &channel, const nlohmann::json &message);

	nlohmann::json getChannelHistory(const std::string &channel) const;

	nlohmann::json getAllHistory() const;

private:
	static constexpr size_t MAX_MESSAGES_PER_CHANNEL = 1000; // Limite de mensagens por canal
	std::unordered_map<std::string, std::deque<nlohmann::json>> channelHistory;
};