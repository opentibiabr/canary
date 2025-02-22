#include "pch.hpp"
#include "api/utils/broadcast_manager.hpp"
#include "api/utils/chat_history.hpp"
#include "api/utils/system_info.hpp"

std::mutex BroadcastManager::shutdownMutex;
std::atomic<bool> BroadcastManager::running { false };

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
	try {
		std::lock_guard<std::mutex> lock(shutdownMutex);

		if (!running) {
			return;
		}

		running = false;

		if (broadcastThread.joinable()) {
			try {
				broadcastThread.join();
			} catch (const std::exception &e) {
				g_logger().error("[BroadcastManager::stop] Erro ao aguardar thread de broadcast: {}", e.what());
			}
		}
	} catch (const std::exception &e) {
		g_logger().error("[BroadcastManager::stop] Erro crítico durante parada: {}", e.what());
	} catch (...) {
		g_logger().error("[BroadcastManager::stop] Erro desconhecido durante parada");
	}
}

void BroadcastManager::broadcastChatMessage(const std::string &playerName, uint32_t level, const std::string &message, const std::string &channel) {
	try {
		if (!running) {
			return;
		}

		// Função para converter Latin1 para UTF-8
		auto toUtf8 = [](const std::string &input) -> std::string {
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

		if (running) {
			// Salva a mensagem no histórico
			ChatHistory::getInstance().addMessage(channel, data);
			WebSocketHandler::getInstance().broadcast(eventType, data);
		}
	} catch (const std::exception &e) {
		g_logger().error("Erro ao transmitir mensagem de chat: {}", e.what());
	}
}

// Na classe que gerencia as conexões WebSocket
void BroadcastManager::broadcastChatMessageHistory() {
	try {
		if (!running) {
			return;
		}

		// Envia o histórico completo para o cliente
		const nlohmann::json historyData = ChatHistory::getInstance().getAllHistory();
		if (running) {
			WebSocketHandler::getInstance().broadcast(WebSocketEvents::CHAT_HISTORY, historyData);
		}
	} catch (const std::exception &e) {
		g_logger().error("Erro ao enviar histórico do chat: {}", e.what());
	}
}

void BroadcastManager::broadcastSystemResources() {
	try {
		// Verifica se ainda estamos em execução
		if (!running) {
			return;
		}

		// Captura os recursos do sistema de forma segura
		const auto resources = SystemInfo::getSystemResources();

		// Verifica novamente se ainda estamos em execução antes de fazer o broadcast
		if (running) {
			WebSocketHandler::getInstance().broadcast(WebSocketEvents::SYSTEM_RESOURCES, resources);
		}
	} catch (const std::exception &e) {
		g_logger().error("[BroadcastManager::broadcastSystemResources] Erro durante broadcast: {}", e.what());
	} catch (...) {
		g_logger().error("[BroadcastManager::broadcastSystemResources] Erro desconhecido durante shutdown");
	}
}

void BroadcastManager::broadcastServerStatus() {
	try {
		// Verifica se ainda estamos em execução
		if (!running) {
			return;
		}

		// Captura o estado do jogo de forma segura
		auto gameState = g_game().getGameState();
		// Não faz broadcast se o jogo não estiver em estado normal
		// if (gameState != GAME_STATE_NORMAL) {
		// 	return;
		// }

		// Captura os dados do servidor de forma segura
		auto playersOnline = g_game().getPlayersOnline();
		auto maxPlayers = g_configManager().getNumber(MAX_PLAYERS);
		auto uptime = (OTSYS_TIME(true) - ProtocolStatus::start) / 1000;

		const nlohmann::json status = {
			{ "status", gameState },
			{ "uptime", uptime },
			{ "players_online", playersOnline },
			{ "max_players", maxPlayers }
		};

		// Verifica novamente se ainda estamos em execução antes de fazer o broadcast
		if (running) {
			WebSocketHandler::getInstance().broadcast(WebSocketEvents::SERVER_STATUS, status);
		}
	} catch (const std::exception &e) {
		g_logger().error("[BroadcastManager::broadcastServerStatus] Erro durante broadcast: {}", e.what());
	} catch (...) {
		g_logger().error("[BroadcastManager::broadcastServerStatus] Erro desconhecido durante shutdown");
	}
}
