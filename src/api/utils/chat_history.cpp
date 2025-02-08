
#include "pch.hpp"
#include "api/utils/chat_history.hpp"

ChatHistory::ChatHistory() = default;
ChatHistory::~ChatHistory() = default;

ChatHistory &ChatHistory::getInstance() {
	static ChatHistory instance;
	return instance;
}

void ChatHistory::addMessage(const std::string &channel, const nlohmann::json &message) {
	auto &history = channelHistory[channel];
	history.push_back(message);

	// Mantém apenas as últimas MAX_MESSAGES_PER_CHANNEL mensagens
	if (history.size() > MAX_MESSAGES_PER_CHANNEL) {
		history.pop_front();
	}
}

nlohmann::json ChatHistory::getChannelHistory(const std::string &channel) const {
	nlohmann::json history = nlohmann::json::array();
	if (channelHistory.count(channel) > 0) {
		for (const auto &msg : channelHistory.at(channel)) {
			history.push_back(msg);
		}
	}
	return history;
}

nlohmann::json ChatHistory::getAllHistory() const {
	nlohmann::json allHistory;
	for (const auto &[channel, messages] : channelHistory) {
		allHistory[channel] = messages;
	}
	return allHistory;
}
