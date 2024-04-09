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

struct Badge {
	uint8_t m_id = 0;
	CyclopediaBadgeType_t m_type;
	std::string m_name;
	uint16_t m_amount = 0;

	Badge() = default;

	Badge(uint8_t id, CyclopediaBadgeType_t type, const std::string &name, uint16_t amount) :
		m_id(id), m_type(type), m_name(name), m_amount(amount) { }

	bool operator==(const Badge &other) const {
		return m_id == other.m_id;
	}
};

namespace std {
	template <>
	struct hash<Badge> {
		std::size_t operator()(const Badge &b) const {
			return hash<uint8_t>()(b.m_id); // Use o ID como base para o hash
		}
	};
}

class PlayerBadge {
public:
	explicit PlayerBadge(Player &player);

	[[nodiscard]] bool hasBadge(uint8_t id) const;
	bool add(uint8_t id, uint32_t timestamp = 0);
	[[nodiscard]] std::vector<std::pair<Badge, uint32_t>> getUnlockedBadges() const;
	void loadUnlockedBadges();
	const std::shared_ptr<KV> &getUnlockedKV();

private:
	// {badge ID, time when it was unlocked}
	std::shared_ptr<KV> m_badgeUnlockedKV;
	std::vector<std::pair<Badge, uint32_t>> m_badgesUnlocked;
	Player &m_player;
};
