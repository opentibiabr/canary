/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "player_badge.hpp"

#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "kv/kv.hpp"

PlayerBadge::PlayerBadge(Player &player) :
	m_player(player) { }

bool PlayerBadge::hasBadge(uint8_t id) const {
	if (id == 0) {
		return false;
	}

	if (auto it = std::find_if(m_badgesUnlocked.begin(), m_badgesUnlocked.end(), [id](auto badge_it) {
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
bool PlayerBadge::accountAge(uint8_t amount) {
	return std::floor(m_player.getLoyaltyPoints() / 365) >= amount;
}

bool PlayerBadge::loyalty(uint8_t amount) {
	return m_player.getLoyaltyPoints() >= amount;
}

bool PlayerBadge::accountAllLevel(uint8_t amount) {
	const auto &players = g_game().getPlayersByAccount(m_player.getAccount(), true);
	uint16_t total = std::accumulate(players.begin(), players.end(), 0, [](uint16_t sum, const std::shared_ptr<Player> &player) {
		return sum + player->getLevel();
	});
	return total >= amount;
}

bool PlayerBadge::accountAllVocations(uint8_t amount) {
	auto knight = false;
	auto paladin = false;
	auto druid = false;
	auto sorcerer = false;
	for (const auto &player : g_game().getPlayersByAccount(m_player.getAccount(), true)) {
		if (player->getLevel() >= amount) {
			auto vocationEnum = player->getPlayerVocationEnum();
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

bool PlayerBadge::tournamentParticipation(uint8_t skill) {
	// todo check if is used
	return false;
}

bool PlayerBadge::tournamentPoints(uint8_t race) {
	// todo check if is used
	return false;
}
