/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "player_achievement.hpp"

#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "kv/kv.hpp"

PlayerAchievement::PlayerAchievement(Player &player) :
	m_player(player) { }

bool PlayerAchievement::add(uint16_t id, bool message /* = true*/, uint32_t timestamp /* = 0*/) {
	if (isUnlocked(id)) {
		return false;
	}

	const Achievement &achievement = g_game().getAchievementById(id);
	if (achievement.id == 0) {
		return false;
	}

	if (message) {
		m_player.sendTextMessage(MESSAGE_EVENT_ADVANCE, fmt::format("Congratulations! You earned the achievement {}.", achievement.name));
	}

	addPoints(achievement.points);
	int toSaveTimeStamp = timestamp != 0 ? timestamp : (OTSYS_TIME() / 1000);
	getUnlockedKV()->set(achievement.name, toSaveTimeStamp);
	m_achievementsUnlocked.push_back({ achievement.id, toSaveTimeStamp });
	m_achievementsUnlocked.shrink_to_fit();
	return true;
}

bool PlayerAchievement::remove(uint16_t id) {
	if (!isUnlocked(id)) {
		return false;
	}

	Achievement achievement = g_game().getAchievementById(id);
	if (achievement.id == 0) {
		return false;
	}

	if (auto it = std::find_if(m_achievementsUnlocked.begin(), m_achievementsUnlocked.end(), [id](auto achievement_it) {
			return achievement_it.first == id;
		});
	    it != m_achievementsUnlocked.end()) {
		getUnlockedKV()->remove(achievement.name);
		m_achievementsUnlocked.erase(it);
		removePoints(achievement.points);
		m_achievementsUnlocked.shrink_to_fit();
		return true;
	}

	return false;
}

bool PlayerAchievement::isUnlocked(uint16_t id) const {
	if (id == 0) {
		return false;
	}

	if (auto it = std::find_if(m_achievementsUnlocked.begin(), m_achievementsUnlocked.end(), [id](auto achievement_it) {
			return achievement_it.first == id;
		});
	    it != m_achievementsUnlocked.end()) {
		return true;
	}

	return false;
}

uint16_t PlayerAchievement::getPoints() const {
	return m_player.kv()->scoped("achievements")->get("points")->getNumber();
}

void PlayerAchievement::addPoints(uint16_t toAddPoints) {
	auto oldPoints = getPoints();
	m_player.kv()->scoped("achievements")->set("points", oldPoints + toAddPoints);
}

void PlayerAchievement::removePoints(uint16_t points) {
	auto oldPoints = getPoints();
	m_player.kv()->scoped("achievements")->set("points", oldPoints - std::min<uint16_t>(oldPoints, points));
}

std::vector<std::pair<uint16_t, uint32_t>> PlayerAchievement::getUnlockedAchievements() const {
	return m_achievementsUnlocked;
}

void PlayerAchievement::loadUnlockedAchievements() {
	const auto &unlockedAchievements = getUnlockedKV()->keys();
	g_logger().debug("[{}] - Loading unlocked achievements: {}", __FUNCTION__, unlockedAchievements.size());
	for (const auto &achievementName : unlockedAchievements) {
		const Achievement &achievement = g_game().getAchievementByName(achievementName);
		if (achievement.id == 0) {
			g_logger().error("[{}] - Achievement {} not found.", __FUNCTION__, achievementName);
			continue;
		}

		g_logger().debug("[{}] - Achievement {} found for player {}.", __FUNCTION__, achievementName, m_player.getName());

		m_achievementsUnlocked.push_back({ achievement.id, getUnlockedKV()->get(achievementName)->getNumber() });
	}
}

void PlayerAchievement::sendUnlockedSecretAchievements() {
	std::vector<std::pair<Achievement, uint32_t>> m_achievementsUnlocked;
	uint16_t unlockedSecret = 0;
	for (const auto &[achievId, achievCreatedTime] : getUnlockedAchievements()) {
		Achievement achievement = g_game().getAchievementById(achievId);
		if (achievement.id == 0) {
			continue;
		}

		if (achievement.secret) {
			unlockedSecret++;
		}

		m_achievementsUnlocked.push_back({ achievement, achievCreatedTime });
	}

	m_player.sendCyclopediaCharacterAchievements(unlockedSecret, m_achievementsUnlocked);
}

const std::shared_ptr<KV> &PlayerAchievement::getUnlockedKV() {
	if (m_unlockedKV == nullptr) {
		m_unlockedKV = m_player.kv()->scoped("achievements")->scoped("unlocked");
	}

	return m_unlockedKV;
}
