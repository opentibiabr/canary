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

	const Badge &badge = g_game().getBadgeByIdOrName(id);
	if (badge.m_id == 0) {
		return false;
	}

	int toSaveTimeStamp = timestamp != 0 ? timestamp : (OTSYS_TIME() / 1000);
	getUnlockedKV()->set(badge.m_name, toSaveTimeStamp);
	m_badgesUnlocked.push_back({ badge, toSaveTimeStamp });
	m_badgesUnlocked.shrink_to_fit();
	return true;
}

std::vector<std::pair<Badge, uint32_t>> PlayerBadge::getUnlockedBadges() const {
	return m_badgesUnlocked;
}

void PlayerBadge::loadUnlockedBadges() {
	const auto &unlockedBadges = getUnlockedKV()->keys();
	g_logger().debug("[{}] - Loading unlocked badges: {}", __FUNCTION__, unlockedBadges.size());
	for (const auto &badgeName : unlockedBadges) {
		const Badge &badge = g_game().getBadgeByIdOrName(0, badgeName);
		if (badge.m_id == 0) {
			g_logger().error("[{}] - Badge {} not found.", __FUNCTION__, badgeName);
			continue;
		}

		g_logger().debug("[{}] - Badge {} found for player {}.", __FUNCTION__, badge.m_name, m_player.getName());

		m_badgesUnlocked.push_back({ badge, getUnlockedKV()->get(badgeName)->getNumber() });
	}
}

const std::shared_ptr<KV> &PlayerBadge::getUnlockedKV() {
	if (m_badgeUnlockedKV == nullptr) {
		m_badgeUnlockedKV = m_player.kv()->scoped("badges")->scoped("unlocked");
	}

	return m_badgeUnlockedKV;
}
