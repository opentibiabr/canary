/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class Player;
class KV;
class Account;

enum class CyclopediaBadge_t : uint8_t;

struct Badge {
	uint8_t m_id = 0;
	CyclopediaBadge_t m_type {};
	std::string m_name {};
	uint16_t m_amount = 0;

	Badge() = default;

	Badge(uint8_t id, CyclopediaBadge_t type, std::string name, uint16_t amount) :
		m_id(id), m_type(type), m_name(std::move(name)), m_amount(amount) { }

	bool operator==(const Badge &other) const {
		return m_id == other.m_id;
	}
};

template <>
struct std::hash<Badge> {
	std::size_t operator()(const Badge &b) const noexcept {
		return hash<uint8_t>()(b.m_id);
	}
};

class PlayerBadge {
public:
	explicit PlayerBadge(Player &player);

	[[nodiscard]] bool hasBadge(uint8_t id) const;
	bool add(uint8_t id, uint32_t timestamp = 0);
	void checkAndUpdateNewBadges();
	void loadUnlockedBadges();
	const std::shared_ptr<KV> &getUnlockedKV();

	// Badge Calculate Functions
	bool accountAge(uint8_t amount) const;
	bool loyalty(uint8_t amount) const;
	std::vector<std::shared_ptr<Player>> getPlayersInfoByAccount(const std::shared_ptr<Account> &acc) const;
	bool accountAllLevel(uint8_t amount) const;
	bool accountAllVocations(uint8_t amount) const;
	[[nodiscard]] bool tournamentParticipation(uint8_t skill) const;
	[[nodiscard]] bool tournamentPoints(uint8_t race) const;

private:
	// {badge ID, time when it was unlocked}
	std::shared_ptr<KV> m_badgeUnlockedKV;
	std::vector<std::pair<Badge, uint32_t>> m_badgesUnlocked;
	Player &m_player;
};
