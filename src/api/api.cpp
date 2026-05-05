#include "pch.hpp"
#include "api/api.hpp"
#include "middleware/auth.hpp"
#include "endpoints/player.hpp"
#include "endpoints/server.hpp"
#include "endpoints/websocket.hpp"
#include "lib/thread/thread_pool.hpp"
#include "utils/validators.hpp"
#include "utils/broadcast_manager.hpp"

std::mutex APIServer::shutdownMutex;

APIServer::APIServer(ThreadPool &threadPool) :
	threadPool(threadPool) { }

APIServer &APIServer::getInstance() {
	return inject<APIServer>();
}

void APIServer::initialize(uint16_t port) {
	// Configuração do CORS
	auto &cors = app.get_middleware<crow::CORSHandler>();
	cors.global()
		.headers("Content-Type", "Authorization")
		.methods("POST"_method, "GET"_method)
		.origin("*");

	// Configuração do Rate Limit por rota
	auto &rateLimiter = app.get_middleware<RateLimitMiddleware>();
	// Rotas mais sensíveis com limite mais restrito
	rateLimiter.setRouteLimit("/api/v1/server/status", 100000000, 60); // 30 req/min
	rateLimiter.setRouteLimit("/api/v1/server/motd", 100000000, 60); // 20 req/min
	// Rotas de jogador com limite moderado
	rateLimiter.setRouteLimit("/api/v1/players/online", 100000000, 60); // 50 req/min
	rateLimiter.setRouteLimit("/api/v1/players/<string>", 100000000, 60); // 50 req/min
	// WebSocket com limite mais permissivo
	rateLimiter.setRouteLimit("/ws", 100000000, 60); // 200 req/min

	// Configuração dos validadores
	setupValidators();

	// Configuração básica do servidor
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
	// Rota de status do servidor
	CROW_ROUTE(app, "/api/v1/login")
		.methods("POST"_method)([](const crow::request &req) {
			// Extraia os dados do corpo da requisição
			const auto json = crow::json::load(req.body);
			if (!json) {
				return crow::response(400, "Invalid JSON");
			}

			const std::string username = json["username"].s();
			const std::string password = json["password"].s();

			if (username == "beats" && password == "1234") { // Exemplo de validação
				const std::string token = AuthMiddleware::generateToken(username); // Chama a função para gerar o token

				crow::json::wvalue response_json;
				response_json["token"] = token;

				return crow::response { response_json };
			} else {
				return crow::response(401, "Unauthorized");
			}
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

	// Rota de teste para players (apenas para desenvolvimento)
	CROW_ROUTE(app, "/api/v1/players")
		.methods("POST"_method)([](const crow::request &req) {
			try {
				const auto json = nlohmann::json::parse(req.body);
				if (!json.contains("name")) {
					return APIResponse::badRequest("Campo obrigatório ausente: name");
				}
				return crow::response(200, R"({"mensagem":"Endpoint de teste","sucesso":true})");
			} catch (const nlohmann::json::parse_error &e) {
				return APIResponse::badRequest("JSON inválido: " + std::string(e.what()));
			} catch (const std::exception &e) {
				return APIResponse::internalError("Erro interno: " + std::string(e.what()));
			}
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

	CROW_ROUTE(app, "/api/v1/check-update")
		.methods("POST"_method)([this](const crow::request &req) {
			const auto body = crow::json::load(req.body);
			if (!body) {
				return crow::response(400, "Invalid JSON body");
			}

			const std::string currentVersion = body["currentVersion"].s();
			const std::string platform = body["platform"].s();

			// Verifica se a plataforma é suportada
			if (!availableVersions.contains(platform)) {
				return crow::response(400, "Unsupported platform");
			}

			// Procura por uma atualização disponível
			const auto &versions = availableVersions[platform];
			for (const auto &[version, url, changelog, required] : versions) {
				if (isNewerVersion(currentVersion, version)) {
					const json response = {
						{ "hasUpdate", true },
						{ "updateInfo", { { "version", version }, { "url", url }, { "changelog", changelog }, { "required", required } } }
					};
					return crow::response(response.dump());
				}
			}

			// Nenhuma atualização encontrada
			const json response = {
				{ "hasUpdate", false }
			};
			return crow::response(response.dump());
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

	// Validação para endpoints de jogador
	validator.setValidator("/api/v1/players/<string>", [](const crow::request &req) -> std::optional<std::string> {
		const auto playerId = req.url_params.get("playerId");
		if (playerId) {
			return Validators::validatePlayerId(playerId);
		}
		return Validators::validatePlayerName(req.url_params.get("playerName"));
	});

	// Validação para listagem de jogadores online
	validator.setValidator("/api/v1/playersOnline", [](const crow::request &req) -> std::optional<std::string> {
		return Validators::validatePagination(req);
	});

	// Validação para criação/atualização de jogador
	validator.setValidator("/api/v1/players", [](const crow::request &req) -> std::optional<std::string> {
		if (req.method == "POST"_method || req.method == "PUT"_method) {
			auto jsonError = Validators::validateJson(req);
			if (jsonError) {
				return jsonError;
			}

			// Valida campos obrigatórios
			for (const auto &field : { "name", "vocation", "level" }) {
				auto fieldError = Validators::validateJsonField(req, field);
				if (fieldError) {
					return fieldError;
				}
			}

			// Valida o nome do jogador
			try {
				auto json = nlohmann::json::parse(req.body);
				return Validators::validatePlayerName(json["name"].get<std::string>());
			} catch (...) {
				return std::optional<std::string>("Erro ao processar dados do jogador");
			}
		}
		return std::nullopt;
	});
}

// Função para comparar versões
bool APIServer::isNewerVersion(const std::string &current, const std::string &new_version) {
	std::vector<int> curr_parts;
	std::vector<int> new_parts;

	// Split versions into parts
	std::stringstream ss_curr(current);
	std::stringstream ss_new(new_version);
	std::string part;

	while (getline(ss_curr, part, '.')) {
		curr_parts.push_back(std::stoi(part));
	}
	while (getline(ss_new, part, '.')) {
		new_parts.push_back(std::stoi(part));
	}

	// Compare each part
	for (size_t i = 0; i < 3; i++) {
		if (new_parts[i] > curr_parts[i]) {
			return true;
		}
		if (new_parts[i] < curr_parts[i]) {
			return false;
		}
	}

	return false;
}

// Mapa de versões disponíveis por plataforma
std::map<std::string, std::vector<VersionInfo>> APIServer::availableVersions = {
	{ "android", { { "1.1.0", "https://github.com/beats-dh/canary/releases/download/v1.4.2/app-release.apk", "- Melhorias na interface\n- Correção de bugs de conexão\n- Novo sistema de atualização\n- Fixs em varias extruturas", false } } }
};
