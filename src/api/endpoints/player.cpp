

#include "pch.hpp"
#include "api/endpoints/player.hpp"
#include "config/configmanager.hpp"
#include "creatures/players/player.hpp"
#include "creatures/players/vocations/vocation.hpp"
#include "game/game.hpp"

PlayerEndpoints::PlayerEndpoints() = default;
 PlayerEndpoints::~PlayerEndpoints() = default;


crow::response PlayerEndpoints::getOnlinePlayers() {
	try {
		json data = {
			{ "total", g_game().getPlayersOnline() },
			{ "max", g_configManager().getNumber(MAX_PLAYERS) }
		};

		// Adiciona lista de jogadores online se houver algum
		if (g_game().getPlayersOnline() > 0) {
			json players = json::array();
			for (const auto &mapPlayer : g_game().getPlayers() | std::views::values) {
				if (mapPlayer) {
					players.push_back({ { "name", mapPlayer->getName() }, { "level", mapPlayer->getLevel() }, { "vocation", mapPlayer->getVocation()->getVocName() }, { "online_time", "verificar" } });
				}
			}
			data["players"] = players;
		}

		return APIResponse::ok(data);
	} catch (const std::exception &e) {
		return APIResponse::internalError("Erro ao buscar jogadores online: " + std::string(e.what()));
	}
}
crow::response PlayerEndpoints::getPlayerInfo(const std::string &name) {
	try {
		const auto &player = g_game().getPlayerByName(name);
		if (!player) {
			return APIResponse::notFound("Jogador não encontrado");
		}

		const json data = {
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

		return APIResponse::ok(data);
	} catch (const std::exception &e) {
		return APIResponse::internalError("Erro ao buscar informações do jogador: " + std::string(e.what()));
	}
}
