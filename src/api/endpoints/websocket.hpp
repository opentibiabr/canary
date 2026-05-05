#pragma once

#include "crow.h"
#include "api/utils/websocket_events.hpp"

#include <memory>
#include <api/utils/broadcast_manager.hpp>
#include <creatures/players/player.hpp>
#include <game/game.hpp>

class WebSocketHandler {
public:
	WebSocketHandler() = default;
	~WebSocketHandler() = default;
	WebSocketHandler(const WebSocketHandler &) = delete;
	WebSocketHandler &operator=(const WebSocketHandler &) = delete;

	static WebSocketHandler &getInstance() {
		static WebSocketHandler instance;
		return instance;
	}

	void handleOpen(crow::websocket::connection &conn) {
		std::lock_guard lock(mtx);
		connections.insert(&conn);
		g_logger().info("Nova conexão WebSocket estabelecida");
	}

	void handleClose(crow::websocket::connection &conn) {
		std::lock_guard lock(mtx);
		connections.erase(&conn);
		// Remove todas as inscrições desta conexão
		for (auto &subscribers : subscriptions | std::views::values) {
			subscribers.erase(&conn);
		}
		g_logger().info("Conexão WebSocket fechada");
	}

	void handleMessage(crow::websocket::connection &conn, const std::string &data, const bool is_binary) {
		if (is_binary) {
			g_logger().warn("Mensagem binária recebida e ignorada");
			return;
		}

		try {
			auto json = nlohmann::json::parse(data);

			if (!json.contains("type")) {
				sendError(conn, "Campo 'type' é obrigatório");
				return;
			}

			const std::string type = json["type"];

			if (type == "subscribe") {
				handleSubscribe(conn, json);
			} else if (type == "unsubscribe") {
				handleUnsubscribe(conn, json);
			} else if (type == "ping") {
				handlePing(conn);
			} else if (type == "broadcast") {
				handleBroadcast(conn, json);
			} else if (type == "kick") {
				handleKick(conn, json);
			} else if (type == "chat_history") {
				BroadcastManager::broadcastChatMessageHistory();
			} else if (type == "chat_message") {
				handleChatMessage(conn, json);
			} else {
				sendError(conn, "Tipo de mensagem desconhecido");
			}
		} catch (const nlohmann::json::parse_error &e) {
			sendError(conn, "JSON inválido: " + std::string(e.what()));
		} catch (const std::exception &e) {
			sendError(conn, "Erro ao processar mensagem: " + std::string(e.what()));
		}
	}

	void broadcast(const std::string &event, const nlohmann::json &data) {
		if (!WebSocketEvents::isValidEvent(event)) {
			g_logger().warn("Tentativa de broadcast de evento inválido: {}", event);
			return;
		}

		std::lock_guard lock(mtx);
		const auto &it = subscriptions.find(event);
		if (it != subscriptions.end()) {
			const nlohmann::json message = {
				{ "type", "event" },
				{ "event", event },
				{ "data", data },
				{ "timestamp", std::time(nullptr) }
			};

			const std::string messageStr = message.dump();
			for (auto conn_it = it->second.begin(); conn_it != it->second.end();) {
				const auto conn = *conn_it;
				try {
					conn->send_text(messageStr);
					++conn_it;
				} catch (const std::exception &e) {
					g_logger().error("Erro ao enviar mensagem para conexão: {}", e.what());
					conn_it = it->second.erase(conn_it);
				}
			}
		}
	}

private:
	std::mutex mtx;
	std::unordered_set<crow::websocket::connection*> connections;
	std::unordered_map<std::string, std::unordered_set<crow::websocket::connection*>> subscriptions;

	void handleSubscribe(crow::websocket::connection &conn, const nlohmann::json &json) {
		if (!json.contains("events") || !json["events"].is_array()) {
			sendError(conn, "Campo 'events' deve ser um array");
			return;
		}

		std::vector<std::string> validEvents;
		std::vector<std::string> invalidEvents;

		for (const auto &event : json["events"]) {
			if (!event.is_string()) {
				continue;
			}
			std::string eventName = event;
			if (WebSocketEvents::isValidEvent(eventName)) {
				validEvents.emplace_back(eventName);
			} else {
				invalidEvents.emplace_back(eventName);
			}
		}

		std::lock_guard lock(mtx);
		for (const auto &event : validEvents) {
			subscriptions[event].insert(&conn);
		}

		nlohmann::json response = {
			{ "type", "subscribed" },
			{ "events", validEvents }
		};

		if (!invalidEvents.empty()) {
			response["invalid_events"] = invalidEvents;
			response["message"] = "Alguns eventos são inválidos e foram ignorados";
		}

		conn.send_text(response.dump());
	}

	void handleUnsubscribe(crow::websocket::connection &conn, const nlohmann::json &json) {
		if (!json.contains("events") || !json["events"].is_array()) {
			sendError(conn, "Campo 'events' deve ser um array");
			return;
		}

		std::lock_guard lock(mtx);
		std::vector<std::string> unsubscribed;

		for (const auto &event : json["events"]) {
			if (!event.is_string()) {
				continue;
			}
			std::string eventName = event;
			const auto it = subscriptions.find(eventName);
			if (it != subscriptions.end()) {
				it->second.erase(&conn);
				unsubscribed.push_back(eventName);
			}
		}

		const nlohmann::json response = {
			{ "type", "unsubscribed" },
			{ "events", unsubscribed }
		};

		conn.send_text(response.dump());
	}

	void handlePing(crow::websocket::connection &conn) const {
		const nlohmann::json response = {
			{ "type", "pong" },
			{ "timestamp", std::time(nullptr) }
		};
		conn.send_text(response.dump());
	}

	void handleBroadcast(crow::websocket::connection &conn, const nlohmann::json &json) {
		// Verificar permissões do usuário aqui
		if (!json.contains("message")) {
			sendError(conn, "Campo 'message' é obrigatório");
			return;
		}

		const nlohmann::json broadcastMessage = {
			{ "type", "broadcast" },
			{ "message", json["message"] },
			{ "level", json.value("level", "info") },
			{ "timestamp", std::time(nullptr) }
		};

		std::lock_guard lock(mtx);
		for (auto &connection : connections) {
			try {
				connection->send_text(broadcastMessage.dump());
			} catch (const std::exception &e) {
				g_logger().error("Erro ao enviar broadcast: {}", e.what());
			}
		}
	}

	void handleKick(crow::websocket::connection &conn, const nlohmann::json &json) const {
		// Verificar permissões do usuário aqui
		if (!json.contains("player")) {
			sendError(conn, "Campo 'player' é obrigatório");
			return;
		}

		// Implementar lógica de kick aqui
		// Por enquanto apenas loga a ação
		g_logger().info("Solicitação de kick para jogador: {}", json["player"].get<std::string>());
	}

	void sendError(crow::websocket::connection &conn, const std::string &message) const {
		const nlohmann::json error = {
			{ "type", "error" },
			{ "message", message },
			{ "timestamp", std::time(nullptr) }
		};
		conn.send_text(error.dump());
	}

	void handleChatMessage(crow::websocket::connection &conn, const nlohmann::json &json) const {
		try {
			if (!json.contains("data") || !json["data"].is_object()) {
				sendError(conn, "Campo 'data' inválido para chat_message");
				return;
			}

			const auto &data = json["data"];
			if (!data.contains("message") || !data.contains("channel")) {
				sendError(conn, "Campos 'message' e 'channel' são obrigatórios");
				return;
			}

			const std::string message = data["message"];
			std::string channel = data["channel"];

			// Remove o prefixo "chat_" do canal
			if (channel.substr(0, 5) == "chat_") {
				channel = channel.substr(5);
			}

			// Valida o canal
			if (channel != "global" && channel != "trade" && channel != "help") {
				sendError(conn, "Canal inválido: " + channel);
				return;
			}

			int channelId = 0;
			if (channel == "global") {
				channelId = 3;
			} else if (channel == "trade") {
				channelId = 5;
			} else if (channel == "help") {
				channelId = 7;
			}

			const auto &teste = std::make_shared<Player>(nullptr);
			teste->setName("Beats Monitor");
			teste->setLevel(100);

			if (g_game().getPlayersOnline() > 0) {
				for (const auto &mapPlayer : g_game().getPlayers() | std::views::values) {
					if (mapPlayer && teste) {
						mapPlayer->sendToChannel(teste, TALKTYPE_CHANNEL_O, message, channelId);
					}
				}
			}
		} catch (const std::exception &e) {
			sendError(conn, "Erro ao processar mensagem de chat: " + std::string(e.what()));
		}
	}
};
