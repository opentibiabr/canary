/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

// Player.hpp already includes the badge
#include "creatures/players/player.hpp"

#include "account/account.hpp"
#include "enums/account_errors.hpp"
#include "enums/player_cyclopedia.hpp"
#include "game/game.hpp"
#include "kv/kv.hpp"

PlayerBadge::PlayerBadge(Player &player) :
	m_player(player) { }

bool PlayerBadge::hasBadge(uint8_t id) const {
	if (id == 0) {
		return false;
	}

	if (auto it = std::ranges::find_if(m_badgesUnlocked, [id](auto badge_it) {
			return badge_it.first.m_id == id;
		});
	    it != m_badgesUnlocked.end()) {
		return true;
	}

	return false;
}

bool PlayerBadge::add(uint8_t id, uint32_t timestamp /* = 0*/) {
	if (hasBadge(id)) {
		return false;
	}

	const Badge &badge = g_game().getBadgeById(id);
	if (badge.m_id == 0) {
		return false;
	}

	int toSaveTimeStamp = timestamp != 0 ? timestamp : (OTSYS_TIME() / 1000);
	getUnlockedKV()->set(badge.m_name, toSaveTimeStamp);
	m_badgesUnlocked.emplace_back(badge, toSaveTimeStamp);
	m_badgesUnlocked.shrink_to_fit();
	return true;
}

void PlayerBadge::checkAndUpdateNewBadges() {
	for (const auto &badge : g_game().getBadges()) {
		switch (badge.m_type) {
			case CyclopediaBadge_t::ACCOUNT_AGE:
				if (accountAge(badge.m_amount)) {
					add(badge.m_id);
				}
				break;
			case CyclopediaBadge_t::LOYALTY:
				if (loyalty(badge.m_amount)) {
					add(badge.m_id);
				}
				break;
			case CyclopediaBadge_t::ACCOUNT_ALL_LEVEL:
				if (accountAllLevel(badge.m_amount)) {
					add(badge.m_id);
				}
				break;
			case CyclopediaBadge_t::ACCOUNT_ALL_VOCATIONS:
				if (accountAllVocations(badge.m_amount)) {
					add(badge.m_id);
				}
				break;
			case CyclopediaBadge_t::TOURNAMENT_PARTICIPATION:
			case CyclopediaBadge_t::TOURNAMENT_POINTS:
				break;
		}
	}

	loadUnlockedBadges();
}

void PlayerBadge::loadUnlockedBadges() {
	const auto &unlockedBadges = getUnlockedKV()->keys();
	g_logger().debug("[{}] - Loading unlocked badges: {}", __FUNCTION__, unlockedBadges.size());
	for (const auto &badgeName : unlockedBadges) {
		const Badge &badge = g_game().getBadgeByName(badgeName);
		if (badge.m_id == 0) {
			g_logger().error("[{}] - Badge {} not found.", __FUNCTION__, badgeName);
			continue;
		}

		g_logger().debug("[{}] - Badge {} found for player {}.", __FUNCTION__, badge.m_name, m_player.getName());

		m_badgesUnlocked.emplace_back(badge, getUnlockedKV()->get(badgeName)->getNumber());
	}
}

const std::shared_ptr<KV> &PlayerBadge::getUnlockedKV() {
	if (m_badgeUnlockedKV == nullptr) {
		m_badgeUnlockedKV = m_player.kv()->scoped("badges")->scoped("unlocked");
	}

	return m_badgeUnlockedKV;
}

// Badge Calculate Functions
bool PlayerBadge::accountAge(uint8_t amount) const {
	return std::floor(m_player.getLoyaltyPoints() / 365) >= amount;
}

bool PlayerBadge::loyalty(uint8_t amount) const {
	return m_player.getLoyaltyPoints() >= amount;
}

std::vector<std::shared_ptr<Player>> PlayerBadge::getPlayersInfoByAccount(const std::shared_ptr<Account> &acc) const {
	const auto [accountPlayers, error] = acc->getAccountPlayers();
	if (error != AccountErrors_t::Ok || accountPlayers.empty()) {
		return {};
	}

	std::string namesList;
	for (const auto &[name, _] : accountPlayers) {
		if (!namesList.empty()) {
			namesList += ", ";
		}
		std::string escapedName = g_database().escapeString(name);
		namesList += fmt::format("{}", escapedName);
	}

	auto query = fmt::format("SELECT name, level, vocation FROM players WHERE name IN ({})", namesList);
	std::vector<std::shared_ptr<Player>> players;
	DBResult_ptr result = g_database().storeQuery(query);
	if (result) {
		do {
			auto player = std::make_shared<Player>(nullptr);
			player->setName(result->getString("name"));
			player->setLevel(result->getNumber<uint32_t>("level"));
			player->setVocation(result->getNumber<uint16_t>("vocation"));
			players.push_back(player);
		} while (result->next());
	}

	return players;
}

bool PlayerBadge::accountAllLevel(uint8_t amount) const {
	auto players = getPlayersInfoByAccount(m_player.getAccount());
	uint16_t total = std::accumulate(players.begin(), players.end(), 0, [](uint16_t sum, const std::shared_ptr<Player> &player) {
		return sum + player->getLevel();
	});
	return total >= amount;
}

bool PlayerBadge::accountAllVocations(uint8_t amount) const {
	auto knight = false;
	auto paladin = false;
	auto druid = false;
	auto sorcerer = false;
	for (const auto &player : getPlayersInfoByAccount(m_player.getAccount())) {
		if (player->getLevel() >= amount) {
			const auto &vocationEnum = player->getPlayerVocationEnum();
			if (vocationEnum == Vocation_t::VOCATION_KNIGHT_CIP) {
				knight = true;
			} else if (vocationEnum == Vocation_t::VOCATION_SORCERER_CIP) {
				sorcerer = true;
			} else if (vocationEnum == Vocation_t::VOCATION_PALADIN_CIP) {
				paladin = true;
			} else if (vocationEnum == Vocation_t::VOCATION_DRUID_CIP) {
				druid = true;
			}
		}
	}
	return knight && paladin && druid && sorcerer;
}

bool PlayerBadge::tournamentParticipation(uint8_t skill) const {
	// todo check if is used
	return false;
}

bool PlayerBadge::tournamentPoints(uint8_t race) const {
	// todo check if is used
	return false;
}
