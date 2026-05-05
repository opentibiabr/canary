#include "pch.hpp"
#include "api/endpoints/player.hpp"
#include "api/utils/dispatcher_sync.hpp"
#include "config/configmanager.hpp"
#include "creatures/players/player.hpp"
#include "creatures/players/vocations/vocation.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"

PlayerEndpoints::PlayerEndpoints() = default;
PlayerEndpoints::~PlayerEndpoints() = default;

crow::response PlayerEndpoints::getOnlinePlayers() {
	try {
		auto data = runOnDispatcher(
			[]() {
				json result = {
					{ "total", g_game().getPlayersOnline() },
					{ "max", g_configManager().getNumber(MAX_PLAYERS) }
				};
				if (g_game().getPlayersOnline() > 0) {
					json players = json::array();
					for (const auto &mapPlayer : g_game().getPlayers() | std::views::values) {
						if (!mapPlayer) {
							continue;
						}
						const auto now = std::chrono::system_clock::now();
						const auto lastLoginSaved = std::chrono::system_clock::from_time_t(mapPlayer->lastLoginSaved);
						players.push_back({ { "name", mapPlayer->getName() }, { "level", mapPlayer->getLevel() }, { "vocation", mapPlayer->getVocation()->getVocName() }, { "online_time", std::chrono::duration_cast<std::chrono::seconds>(now - lastLoginSaved).count() } });
					}
					result["players"] = players;
				}
				return result;
			},
			__FUNCTION__
		);
		return APIResponse::ok(data);
	} catch (const std::exception &e) {
		return APIResponse::internalError("Erro ao buscar jogadores online: " + std::string(e.what()));
	}
}

crow::response PlayerEndpoints::getPlayerInfo(const std::string &name) {
	try {
		auto result = runOnDispatcher(
			[&name]() -> std::optional<json> {
				const auto &player = g_game().getPlayerByName(name);
				if (!player) {
					return std::nullopt;
				}
				return json {
					{ "name", player->getName() },
					{ "level", player->getLevel() },
					{ "vocation", player->getVocation()->getVocName() },
					{ "health", player->getHealth() },
					{ "max_health", player->getMaxHealth() },
					{ "mana", player->getMana() },
					{ "max_mana", player->getMaxMana() },
					{ "skills", { { "magic", player->getMagicLevel() }, { "fist", player->getSkillLevel(SKILL_FIST) }, { "club", player->getSkillLevel(SKILL_CLUB) }, { "sword", player->getSkillLevel(SKILL_SWORD) }, { "axe", player->getSkillLevel(SKILL_AXE) }, { "distance", player->getSkillLevel(SKILL_DISTANCE) }, { "shielding", player->getSkillLevel(SKILL_SHIELD) }, { "fishing", player->getSkillLevel(SKILL_FISHING) } } },
					{ "online", player->isOnline() },
					{ "premium", player->isPremium() }
				};
			},
			__FUNCTION__
		);
		if (!result) {
			return APIResponse::notFound("Jogador não encontrado");
		}
		return APIResponse::ok(*result);
	} catch (const std::exception &e) {
		return APIResponse::internalError("Erro ao buscar informações do jogador: " + std::string(e.what()));
	}
}

crow::response PlayerEndpoints::kickPlayer(const crow::request &req) {
	try {
		const auto bodyData = crow::json::load(req.body);
		if (!bodyData.has("name")) {
			return APIResponse::badRequest("Campo 'name' é obrigatório");
		}

		const std::string playerName = bodyData["name"].s();
		if (playerName.empty()) {
			return APIResponse::badRequest("Nome do jogador não pode ser vazio");
		}

		auto result = runOnDispatcher(
			[&playerName]() -> std::variant<std::string, int> {
				const auto &player = g_game().getPlayerByName(playerName);
				if (!player || !player->isOnline()) {
					return 404;
				}
				if (player->getGroup() && player->getGroup()->access) {
					return 403;
				}
				const std::string actualName = player->getName();
				player->removePlayer(true);
				return actualName;
			},
			__FUNCTION__
		);

		if (std::holds_alternative<int>(result)) {
			const int code = std::get<int>(result);
			if (code == 404) {
				return APIResponse::notFound("Jogador não encontrado ou offline");
			}
			return APIResponse::badRequest("Você não pode kickar este jogador");
		}

		return APIResponse::ok(json {
			{ "status", "success" },
			{ "kicked", std::get<std::string>(result) }
		});
	} catch (const nlohmann::json::parse_error &e) {
		return APIResponse::badRequest("JSON inválido: " + std::string(e.what()));
	} catch (const std::exception &e) {
		return APIResponse::internalError("Erro ao kickar jogador: " + std::string(e.what()));
	}
}

crow::response PlayerEndpoints::banOrUnbanPlayer(const crow::request &req) {
	try {
		const auto bodyData = crow::json::load(req.body);
		if (!bodyData.has("action") || !bodyData.has("name")) {
			return APIResponse::badRequest("Campos 'action' e 'name' são obrigatórios");
		}

		const std::string action = bodyData["action"].s();
		const std::string name = bodyData["name"].s();
		const uint32_t admin = bodyData.has("admin") ? bodyData["admin"].i() : 0;

		if (action == "ban") {
			if (!bodyData.has("duration") || !bodyData.has("reason")) {
				return APIResponse::badRequest("Campos 'duration' e 'reason' são obrigatórios para ban");
			}
			const int duration = bodyData["duration"].i();
			const std::string reason = bodyData["reason"].s();

			const bool ok = runOnDispatcher(
				[&]() { return g_game().banPlayer(name, duration, reason, admin); },
				__FUNCTION__
			);
			if (ok) {
				return APIResponse::ok("Jogador banido com sucesso");
			}
			return APIResponse::badRequest("Não foi possível banir o jogador. Verifique se já está banido ou se o nome está correto.");
		}
		if (action == "unban") {
			const bool ok = runOnDispatcher(
				[&]() { return g_game().unbanPlayer(name, admin); },
				__FUNCTION__
			);
			if (ok) {
				return APIResponse::ok("Jogador desbanido com sucesso");
			}
			return APIResponse::badRequest("Não foi possível desbanir o jogador. Verifique se está banido ou se o nome está correto.");
		}
		return APIResponse::badRequest("Ação inválida. Use 'ban' ou 'unban'.");
	} catch (const std::exception &e) {
		return APIResponse::erro(500, e.what());
	}
}

crow::response PlayerEndpoints::getBanHistory(const crow::request &req) {
	const auto &urlParams = crow::query_string(req.url_params);
	const std::string name = urlParams.get("name") ? urlParams.get("name") : "";
	if (name.empty()) {
		return APIResponse::badRequest("Parâmetro 'name' é obrigatório");
	}

	try {
		auto entries = runOnDispatcher(
			[&name]() -> std::optional<std::vector<json>> {
				Database &db = Database::getInstance();
				const auto result = db.storeQuery(fmt::format("SELECT `account_id` FROM `players` WHERE `name` = {}", db.escapeString(name)));
				if (!result) {
					return std::nullopt;
				}
				const uint32_t accountId = result->getNumber<uint32_t>("account_id");
				const auto &history = db.storeQuery(fmt::format("SELECT `reason`, `banned_at`, `expired_at`, `banned_by` FROM `account_ban_history` WHERE `account_id` = {} ORDER BY `banned_at` DESC", accountId));
				std::vector<json> rows;
				if (history) {
					do {
						rows.push_back({ { "reason", history->getString("reason") }, { "banned_at", history->getNumber<time_t>("banned_at") }, { "expired_at", history->getNumber<time_t>("expired_at") }, { "banned_by", history->getNumber<uint32_t>("banned_by") } });
					} while (history->next());
				}
				return rows;
			},
			__FUNCTION__,
			5000
		);

		if (!entries) {
			return APIResponse::notFound("Jogador não encontrado");
		}
		return APIResponse::ok(json(*entries));
	} catch (const std::exception &e) {
		return APIResponse::internalError("Erro ao consultar histórico: " + std::string(e.what()));
	}
}

crow::response PlayerEndpoints::getBannedPlayers(const crow::request &req) {
	try {
		auto rows = runOnDispatcher(
			[]() -> std::vector<json> {
				Database &db = Database::getInstance();
				const auto &bans = db.storeQuery(
					"SELECT ab.account_id, ab.reason, ab.banned_at, ab.expires_at, ab.banned_by, p.name "
					"FROM account_bans ab "
					"JOIN players p ON ab.account_id = p.account_id "
					"JOIN accounts a ON ab.account_id = a.id "
					"WHERE a.type < 5"
				);
				std::vector<json> result;
				if (bans) {
					do {
						result.push_back({ { "name", bans->getString("name") }, { "reason", bans->getString("reason") }, { "banned_at", bans->getNumber<time_t>("banned_at") }, { "expires_at", bans->getNumber<time_t>("expires_at") }, { "banned_by", bans->getNumber<uint32_t>("banned_by") } });
					} while (bans->next());
				}
				return result;
			},
			__FUNCTION__,
			5000
		);
		return APIResponse::ok(json(rows));
	} catch (const std::exception &e) {
		return APIResponse::internalError("Erro ao listar banidos: " + std::string(e.what()));
	}
}
