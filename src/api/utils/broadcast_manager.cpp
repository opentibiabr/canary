

#include "pch.hpp"
#include "api/utils/broadcast_manager.hpp"
#include "api/utils/chat_history.hpp"
#include "api/utils/system_info.hpp"

BroadcastManager::BroadcastManager() = default;
BroadcastManager::~BroadcastManager() {
	stop();
}

BroadcastManager &BroadcastManager::getInstance() {
	static BroadcastManager instance;
	return instance;
}
void BroadcastManager::start() {
	if (!running) {
		running = true;
		broadcastThread = std::jthread([this]() {
			while (running) {
				try {
					broadcastSystemResources();
					broadcastServerStatus();
					std::this_thread::sleep_for(std::chrono::seconds(1));
				} catch (const std::exception &e) {
					g_logger().error("Erro no broadcast: {}", e.what());
				}
			}
		});
	}
}
void BroadcastManager::stop() {
	running = false;
	if (broadcastThread.joinable()) {
		broadcastThread.join();
	}
}

void BroadcastManager::broadcastChatMessage(const std::string &playerName, uint32_t level, const std::string &message, const std::string &channel) {
	try {
		// Função para converter Latin1 para UTF-8
		auto toUtf8 = [](const std::string& input) -> std::string {
			std::string output;
			output.reserve(input.length() * 2); // UTF-8 pode usar até 2 bytes por caractere

			for (unsigned char c : input) {
				if (c < 0x80) {
					// ASCII normal
					output += c;
				} else {
					// Caracteres Latin1 (ISO-8859-1) para UTF-8
					output += (0xC0 | (c >> 6));
					output += (0x80 | (c & 0x3F));
				}
			}
			return output;
		};

		const nlohmann::json data = {
			{ "player", toUtf8(playerName) },
			{ "level", level },
			{ "message", toUtf8(message) },
			{ "channel", channel },
			{ "timestamp", std::time(nullptr) }
		};

		std::string eventType;
		if (channel == "global") {
			eventType = WebSocketEvents::CHAT_GLOBAL;
		} else if (channel == "trade") {
			eventType = WebSocketEvents::CHAT_TRADE;
		} else if (channel == "help") {
			eventType = WebSocketEvents::CHAT_HELP;
		} else {
			return; // Canal desconhecido
		}

		// Salva a mensagem no histórico
		ChatHistory::getInstance().addMessage(channel, data);

		WebSocketHandler::getInstance().broadcast(eventType, data);
	} catch (const std::exception &e) {
		g_logger().error("Erro ao transmitir mensagem de chat: {}", e.what());
	}
}

// Na classe que gerencia as conexões WebSocket
void BroadcastManager::broadcastChatMessageHistory() {
	try {
		// Envia o histórico completo para o cliente
		const nlohmann::json historyData = ChatHistory::getInstance().getAllHistory();
		WebSocketHandler::getInstance().broadcast(WebSocketEvents::CHAT_HISTORY, historyData);
	} catch (const std::exception &e) {
		g_logger().error("Erro ao enviar histórico do chat: {}", e.what());
	}
}

void BroadcastManager::broadcastSystemResources() {
	try {
		const auto resources = SystemInfo::getSystemResources();
		WebSocketHandler::getInstance().broadcast(WebSocketEvents::SYSTEM_RESOURCES, resources);
	} catch (const std::exception &e) {
		g_logger().error("Erro ao transmitir recursos do sistema: {}", e.what());
	}
}

void BroadcastManager::broadcastServerStatus() {
	try {
		const nlohmann::json status = {
			{ "status", g_game().getGameState() },
			{ "uptime", (OTSYS_TIME(true) - ProtocolStatus::start) / 1000 },
			{ "players_online", g_game().getPlayersOnline() },
			{ "max_players", g_configManager().getNumber(MAX_PLAYERS) }
		};
		WebSocketHandler::getInstance().broadcast(WebSocketEvents::SERVER_STATUS, status);
	} catch (const std::exception &e) {
		g_logger().error("Erro ao transmitir status do servidor: {}", e.what());
	}
}
