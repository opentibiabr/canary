#include "pch.hpp"
#include "api/api.hpp"
#include "middleware/auth.hpp"
#include "endpoints/player.hpp"
#include "endpoints/server.hpp"
#include "endpoints/websocket.hpp"
#include "lib/thread/thread_pool.hpp"
#include "utils/validators.hpp"
#include "utils/broadcast_manager.hpp"
#include "account/account.hpp"
#include "enums/account_errors.hpp"
#include "enums/account_type.hpp"

std::mutex APIServer::shutdownMutex;

APIServer::APIServer(ThreadPool &threadPool) :
	threadPool(threadPool) { }

APIServer &APIServer::getInstance() {
	return inject<APIServer>();
}

void APIServer::initialize(uint16_t port) {
	auto &cors = app.get_middleware<crow::CORSHandler>();
	const std::string corsOrigin = g_configManager().getString(API_CORS_ORIGIN);
	auto &corsRule = cors.global()
		.headers("Content-Type", "Authorization")
		.methods("POST"_method, "GET"_method);
	if (!corsOrigin.empty()) {
		corsRule.origin(corsOrigin);
	}

	auto &rateLimiter = app.get_middleware<RateLimitMiddleware>();
	// Anti-bruteforce on auth
	rateLimiter.setRouteLimit("/api/v1/login", 5, 60);
	// Read-only public endpoints
	rateLimiter.setRouteLimit("/api/v1/server/status", 60, 60);
	rateLimiter.setRouteLimit("/api/v1/server/resources", 60, 60);
	rateLimiter.setRouteLimit("/api/v1/server/motd", 30, 60);
	rateLimiter.setRouteLimit("/api/v1/playersOnline", 60, 60);
	rateLimiter.setRouteLimit("/api/v1/players/<string>", 60, 60);
	rateLimiter.setRouteLimit("/api/v1/players/banned", 30, 60);
	rateLimiter.setRouteLimit("/api/v1/players/ban/history", 30, 60);
	// Destructive admin endpoints
	rateLimiter.setRouteLimit("/api/v1/players/kick", 10, 60);
	rateLimiter.setRouteLimit("/api/v1/players/ban", 10, 60);
	rateLimiter.setRouteLimit("/api/v1/server/state", 5, 60);
	rateLimiter.setRouteLimit("/api/v1/server/broadcast", 10, 60);
	// WebSocket connect attempts
	rateLimiter.setRouteLimit("/ws", 30, 60);

	setupValidators();

	app.loglevel(crow::LogLevel::Warning);
	app.port(port).use_compression(crow::compression::DEFLATE).multithreaded();

	setupRoutes();
	setupWebSocket();
}

void APIServer::start() {
	running = true;

	// Usa o thread pool para executar a API em background
	threadPool.detach_task([this]() {
		app.run();
	});

	// Inicia o broadcast manager
	BroadcastManager::getInstance().start();
}

void APIServer::stop() {
	try {
		std::lock_guard<std::mutex> lock(shutdownMutex);

		if (!running) {
			return;
		}

		running = false;

		try {
			BroadcastManager::getInstance().stop();
		} catch (const std::exception &e) {
			g_logger().error("[APIServer::stop] Erro ao parar BroadcastManager: {}", e.what());
		}

		try {
			app.stop();
		} catch (const std::exception &e) {
			g_logger().error("[APIServer::stop] Erro ao parar servidor Crow: {}", e.what());
		}
	} catch (const std::exception &e) {
		g_logger().error("[APIServer::stop] Erro crítico durante shutdown: {}", e.what());
	} catch (...) {
		g_logger().error("[APIServer::stop] Erro desconhecido durante shutdown");
	}
}

void APIServer::setupRoutes() {
	// Login: validates against the accounts table (argon2 / SHA1 fallback) and returns a JWT.
	CROW_ROUTE(app, "/api/v1/login")
		.methods("POST"_method)([](const crow::request &req) {
			const auto json = crow::json::load(req.body);
			if (!json || !json.has("username") || !json.has("password")) {
				return APIResponse::badRequest("Campos 'username' e 'password' são obrigatórios");
			}

			const std::string username = json["username"].s();
			const std::string password = json["password"].s();
			if (username.empty() || password.empty()) {
				return APIResponse::badRequest("Credenciais não podem ser vazias");
			}

			Account account(username);
			if (account.load() != AccountErrors_t::Ok) {
				return APIResponse::unauthorized("Credenciais inválidas");
			}
			if (!account.authenticate(password)) {
				return APIResponse::unauthorized("Credenciais inválidas");
			}

			const uint32_t accountId = account.getID();
			if (accountId == 0) {
				return APIResponse::internalError("Falha ao carregar conta");
			}
			const uint8_t accountType = static_cast<uint8_t>(account.getAccountType());

			const std::string token = AuthMiddleware::generateToken(accountId, accountType);
			crow::json::wvalue body;
			body["token"] = token;
			body["account_type"] = accountType;
			return crow::response { body };
		});

	// Rota de status do servidor
	CROW_ROUTE(app, "/api/v1/server/status")
		.methods("GET"_method)([](const crow::request &) {
			return ServerEndpoints::getStatus();
		});

	// Rota para alterar estado do servidor
	CROW_ROUTE(app, "/api/v1/server/state")
		.methods("POST"_method)([](const crow::request &req) {
			return ServerEndpoints::setGameState(req);
		});

	// Rota de recursos do sistema
	CROW_ROUTE(app, "/api/v1/server/resources")
		.methods("GET"_method)([](const crow::request &) {
			return ServerEndpoints::getResources();
		});

	// Rota de MOTD
	CROW_ROUTE(app, "/api/v1/server/motd")
		.methods("GET"_method)([](const crow::request &) {
			return ServerEndpoints::getMotd();
		});

	// Rota para listar todos os jogadores banidos
	CROW_ROUTE(app, "/api/v1/players/banned")
		.methods("GET"_method)([](const crow::request &req) {
			return PlayerEndpoints::getBannedPlayers(req);
		});

	// Rota para buscar jogador por nome
	CROW_ROUTE(app, "/api/v1/players/<string>")
		.methods("GET"_method)([](const crow::request &req, const std::string &playerName) {
			try {
				// Validação do nome do jogador antes de processar
				const auto nameError = Validators::validatePlayerName(playerName);
				if (nameError) {
					return APIResponse::badRequest(*nameError);
				}

				// Decodifica o nome ANTES de buscar
				const std::string decodedName = Validators::urlDecode(playerName);

				// Busca o jogador
				auto response = PlayerEndpoints::getPlayerInfo(decodedName);
				if (response.code == 404) {
					// Converte 404 para uma resposta mais amigável
					return APIResponse::notFound("Jogador não encontrado: " + decodedName);
				}
				return response;
			} catch (const std::exception &e) {
				return APIResponse::internalError("Erro ao buscar jogador: " + std::string(e.what()));
			}
		});

	// Rota de jogadores online
	CROW_ROUTE(app, "/api/v1/playersOnline")
		.methods("GET"_method)([](const crow::request &req) {
			try {
				return PlayerEndpoints::getOnlinePlayers();
			} catch (const std::exception &e) {
				return APIResponse::internalError("Erro ao listar jogadores: " + std::string(e.what()));
			}
		});

	// Rota de broadcast para GMs
	CROW_ROUTE(app, "/api/v1/server/broadcast")
		.methods("POST"_method)([](const crow::request &req) {
			return ServerEndpoints::broadcastMessage(req);
		});

	// Rota para kickar jogador
	CROW_ROUTE(app, "/api/v1/players/kick")
		.methods("POST"_method)([](const crow::request &req) {
			return PlayerEndpoints::kickPlayer(req);
		});

	// Rota para banir ou desbanir jogador
	CROW_ROUTE(app, "/api/v1/players/ban")
		.methods("POST"_method)([](const crow::request &req) {
			return PlayerEndpoints::banOrUnbanPlayer(req);
		});

	// Rota para histórico de banimentos
	CROW_ROUTE(app, "/api/v1/players/ban/history")
		.methods("GET"_method)([](const crow::request &req) {
			return PlayerEndpoints::getBanHistory(req);
		});
}

void APIServer::setupWebSocket() {
	CROW_WEBSOCKET_ROUTE(app, "/ws")
		.onopen([](crow::websocket::connection &conn) {
			WebSocketHandler::getInstance().handleOpen(conn);
		})
		.onclose([](crow::websocket::connection &conn, const std::string &reason) {
			WebSocketHandler::getInstance().handleClose(conn);
		})
		.onmessage([](crow::websocket::connection &conn, const std::string &data, const bool is_binary) {
			try {
				WebSocketHandler::getInstance().handleMessage(conn, data, is_binary);
			} catch (const std::exception &e) {
				g_logger().error("Erro ao processar mensagem WebSocket: {}", e.what());
				const nlohmann::json error = {
					{ "type", "error" },
					{ "message", std::string("Erro ao processar mensagem: ") + e.what() }
				};
				conn.send_text(error.dump());
			}
		});
}

void APIServer::setupValidators() {
	auto &validator = app.get_middleware<ValidationMiddleware>();

	// Validação central para endpoints de jogador (player path param vem do URL).
	// O handler ainda re-decodifica o nome e revalida — defesa em profundidade.
	validator.setValidator("/api/v1/players/<string>", [](const crow::request &req) -> std::optional<std::string> {
		// Path params do Crow não são acessíveis aqui; a validação real ocorre no handler.
		return std::nullopt;
	});

	validator.setValidator("/api/v1/playersOnline", [](const crow::request &req) -> std::optional<std::string> {
		return Validators::validatePagination(req);
	});
}
