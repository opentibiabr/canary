/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

// Player.hpp already includes the cylopedia
#include "creatures/players/player.hpp"

#include "database/databasetasks.hpp"
#include "enums/player_blessings.hpp"
#include "enums/player_cyclopedia.hpp"
#include "game/game.hpp"
#include "kv/kv.hpp"
#include "database/database.hpp"
#include "items/tile.hpp"
#include "server/network/protocol/protocolgame.hpp"
#ifndef USE_PRECOMPILED_HEADERS
	#include <nlohmann/json.hpp>
	#include <algorithm>
	#include <chrono>
	#include <deque>
	#include <set>
	#include <fstream>
	#include <ranges>
	#include <unordered_set>
#endif

PlayerCyclopedia::PlayerCyclopedia(Player &player) :
	m_player(player) { }

namespace {
	struct DiscoveryRegion {
		uint16_t id;
		std::string name;
		std::vector<uint16_t> children;
		std::map<uint32_t, std::vector<std::pair<uint16_t, uint16_t>>> rows;
		bool contains(const Position &position) const {
			// Surface masks also describe buildings above ground; underground masks stay floor-specific.
			const auto floor = position.z < 7 ? 7 : position.z;
			const auto row = rows.find((static_cast<uint32_t>(floor) << 16) | position.y);
			return row != rows.end() && std::ranges::any_of(row->second, [&](const auto &run) { return position.x >= run.first && position.x <= run.second; });
		}
	};
	const std::map<uint16_t, DiscoveryRegion> &discoveryRegions() {
		// Immutable values only, no gameplay owners or lifetime-sensitive handles.
		static const auto regions = [] {
			std::map<uint16_t, DiscoveryRegion> result;
			try {
				std::ifstream input("data/XML/cyclopedia-discovery-areas.json");
				nlohmann::json document;
				input >> document;
				if (document.at("areas").size() > 512) {
					return result;
				}
				for (const auto &area : document.at("areas")) {
					const auto id = area.at("id").get<uint16_t>();
					DiscoveryRegion region { id, area.at("name").get<std::string>(), area.at("children").get<std::vector<uint16_t>>(), {} };
					for (const auto &run : area.at("runs")) {
						const auto z = run.at(0).get<uint32_t>();
						const auto y = run.at(1).get<uint32_t>();
						const auto x1 = run.at(2).get<uint32_t>();
						const auto x2 = run.at(3).get<uint32_t>();
						if (z > 15 || y > UINT16_MAX || x2 > UINT16_MAX || x1 > x2) {
							return std::map<uint16_t, DiscoveryRegion> {};
						}
						region.rows[(z << 16) | y].emplace_back(static_cast<uint16_t>(x1), static_cast<uint16_t>(x2));
					}
					result.emplace(id, std::move(region));
				}
			} catch (const std::exception &error) {
				g_logger().error("[CyclopediaDiscovery] Invalid catalog: {}", error.what());
				result.clear();
			}
			return result;
		}();
		return regions;
	}
	uint64_t discoveryNow() {
		return static_cast<uint64_t>(std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::steady_clock::now().time_since_epoch()).count());
	}
	uint32_t discoveryDistance(const Position &left, const Position &right) {
		if (left.z != right.z) {
			return UINT32_MAX;
		}
		return static_cast<uint32_t>(std::max(std::abs(static_cast<int>(left.x) - right.x), std::abs(static_cast<int>(left.y) - right.y)));
	}
}

bool PlayerCyclopedia::loadDiscovery() {
	if (discoveryLoaded) {
		return true;
	}
	const auto now = discoveryNow();
	if (now < discoveryRetryAfter || discoveryRegions().empty()) {
		return false;
	}
	discoveryRetryAfter = now + 30000;
	auto &db = g_database();
	if (!db.executeQuery("CREATE TABLE IF NOT EXISTS `cyclopedia_discovery` (`world_id` INT UNSIGNED NOT NULL,`player_id` INT UNSIGNED NOT NULL,`area_id` SMALLINT UNSIGNED NOT NULL,`active` TINYINT UNSIGNED NOT NULL DEFAULT 0,`points` TEXT NOT NULL,PRIMARY KEY (`world_id`,`player_id`,`area_id`)) ENGINE=InnoDB")) {
		return false;
	}
	const auto count = db.storeQuery(fmt::format("SELECT COUNT(*) AS `count` FROM `cyclopedia_discovery` AS `d` JOIN `players` AS `p` ON `p`.`id`=`d`.`player_id` WHERE `d`.`world_id`={} AND `d`.`player_id`={} AND `p`.`account_id`={}", 0, m_player.getGUID(), m_player.getAccountId()));
	if (!count || count->getNumber<uint32_t>("count") > 512) {
		return false;
	}
	std::map<uint16_t, std::vector<DiscoveryPoint>> restored;
	uint16_t active = 0;
	if (count->getNumber<uint32_t>("count") != 0) {
		const auto rows = db.storeQuery(fmt::format("SELECT `d`.`area_id`,`d`.`active`,`d`.`points` FROM `cyclopedia_discovery` AS `d` JOIN `players` AS `p` ON `p`.`id`=`d`.`player_id` WHERE `d`.`world_id`={} AND `d`.`player_id`={} AND `p`.`account_id`={}", 0, m_player.getGUID(), m_player.getAccountId()));
		if (!rows) {
			return false;
		}
		do {
			const auto id = rows->getNumber<uint16_t>("area_id");
			const auto area = discoveryRegions().find(id);
			const auto points = nlohmann::json::parse(rows->getString("points"), nullptr, false);
			if (area == discoveryRegions().end() || !points.is_array() || points.size() != 5) {
				return false;
			}
			std::set<Position> positions;
			for (const auto &value : points) {
				if (!value.is_array() || value.size() != 4 || !std::ranges::all_of(value, [](const auto &field) { return field.is_number_unsigned(); })) {
					return false;
				}
				const auto x = value[0].get<uint64_t>(), y = value[1].get<uint64_t>(), z = value[2].get<uint64_t>(), state = value[3].get<uint64_t>();
				if (x > UINT16_MAX || y > UINT16_MAX || z > 15 || state > 2) {
					return false;
				}
				const Position pos(static_cast<uint16_t>(x), static_cast<uint16_t>(y), static_cast<uint8_t>(z));
				if (!area->second.contains(pos) || !positions.insert(pos).second) {
					return false;
				}
				restored[id].push_back({ pos, static_cast<uint8_t>(state) });
			}
			if (rows->getNumber<uint8_t>("active")) {
				if (active != 0) {
					return false;
				}
				active = id;
			}
		} while (rows->next());
	}
	discoveryState = std::move(restored);
	discoveryActive = active;
	discoveryLoaded = true;
	return true;
}

bool PlayerCyclopedia::saveDiscovery(uint16_t area, const std::vector<DiscoveryPoint> &points) {
	nlohmann::json serialized = nlohmann::json::array();
	for (const auto &point : points) {
		serialized.push_back({ point.position.x, point.position.y, point.position.z, point.state });
	}
	auto &db = g_database();
	return DBTransaction::executeWithinTransactionRollbackOnFailure([&] {
		const auto owner = db.storeQuery(fmt::format("SELECT `id` FROM `players` WHERE `id`={} AND {}=0 AND `account_id`={} FOR UPDATE", m_player.getGUID(), 0, m_player.getAccountId()));
		return owner
			&& db.executeQuery(fmt::format("UPDATE `cyclopedia_discovery` SET `active`=0 WHERE `world_id`={} AND `player_id`={}", 0, m_player.getGUID()))
			&& db.executeQuery(fmt::format("INSERT INTO `cyclopedia_discovery` (`world_id`,`player_id`,`area_id`,`active`,`points`) VALUES ({},{},{},1,{}) ON DUPLICATE KEY UPDATE `active`=1,`points`=VALUES(`points`)", 0, m_player.getGUID(), area, db.escapeString(serialized.dump())));
	});
}

std::string PlayerCyclopedia::startDiscovery(uint16_t subarea) {
	if (!loadDiscovery() || m_player.isRemoved()) {
		return "Discovery is temporarily unavailable.";
	}
	const auto now = discoveryNow();
	if (now < discoveryNextReset) {
		return "Please wait before starting discovery again.";
	}
	discoveryNextReset = now + 2000;
	const auto area = discoveryRegions().find(subarea);
	if (area == discoveryRegions().end() || area->second.rows.empty()) {
		return "This subarea is not available for discovery.";
	}
	if (const auto previous = discoveryState.find(subarea); previous != discoveryState.end()
	    && std::ranges::all_of(previous->second, [](const auto &point) { return point.state == 2; })) {
		return "You have already completed this subarea.";
	}
	const auto origin = m_player.getPosition();
	if (!area->second.contains(origin)) {
		return "Stand inside the selected subarea before starting discovery.";
	}
	auto &game = g_game();
	size_t remainingVisits = 32768;
	const auto generate = [&](Position floorOrigin) {
		const auto isWalkable = [&](const Position &position) {
			const auto tile = game.map.getTile(position);
			return area->second.contains(position) && tile && tile->getGround() && !tile->getHouse() && !tile->isMovableBlocking() && !tile->hasFlag(TILESTATE_FLOORCHANGE | TILESTATE_TELEPORT);
		};
		bool found = isWalkable(floorOrigin);
		for (int radius = 1; !found && radius <= 7; ++radius) {
			for (int dx = -radius; !found && dx <= radius; ++dx) {
				for (int dy = -radius; !found && dy <= radius; ++dy) {
					if (std::max(std::abs(dx), std::abs(dy)) != radius) {
						continue;
					}
					const int x = origin.x + dx, y = origin.y + dy;
					if (x < 0 || y < 0 || x > UINT16_MAX || y > UINT16_MAX) {
						continue;
					}
					const Position candidate(static_cast<uint16_t>(x), static_cast<uint16_t>(y), floorOrigin.z);
					if (isWalkable(candidate)) {
						floorOrigin = candidate;
						found = true;
					}
				}
			}
		}
		if (!found) {
			return std::vector<DiscoveryPoint> {};
		}
		std::deque<Position> queue { floorOrigin };
		std::unordered_set<uint32_t> visited { (static_cast<uint32_t>(floorOrigin.x) << 16) | floorOrigin.y };
		std::vector<Position> candidates;
		while (!queue.empty() && remainingVisits != 0) {
			const auto position = queue.front();
			queue.pop_front();
			if (discoveryDistance(position, floorOrigin) > 7) {
				candidates.push_back(position);
			}
			for (const auto &[dx, dy] : { std::pair { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } }) {
				if (remainingVisits == 0) {
					break;
				}
				const int x = position.x + dx, y = position.y + dy;
				if (x < 0 || y < 0 || x > UINT16_MAX || y > UINT16_MAX) {
					continue;
				}
				const auto key = (static_cast<uint32_t>(x) << 16) | y;
				if (visited.contains(key)) {
					continue;
				}
				visited.insert(key);
				--remainingVisits;
				const Position next(static_cast<uint16_t>(x), static_cast<uint16_t>(y), floorOrigin.z);
				if (!area->second.contains(next)) {
					continue;
				}
				if (isWalkable(next)) {
					queue.push_back(next);
				}
			}
		}
		std::vector<DiscoveryPoint> points;
		for (size_t attempts = 0; !candidates.empty() && points.size() < 5 && attempts < 2048; ++attempts) {
			const auto index = static_cast<size_t>(uniform_random(0, static_cast<int32_t>(candidates.size() - 1)));
			const auto position = candidates[index];
			candidates[index] = candidates.back();
			candidates.pop_back();
			if (std::ranges::all_of(points, [&](const auto &point) { return discoveryDistance(point.position, position) >= 8; })) {
				points.push_back({ position, 0 });
			}
		}
		return points;
	};
	std::vector<DiscoveryPoint> points;
	const auto lastFloor = origin.z < 7 ? 7 : origin.z;
	for (uint8_t floor = origin.z; floor <= lastFloor && remainingVisits != 0; ++floor) {
		points = generate(Position(origin.x, origin.y, floor));
		if (points.size() == 5) {
			break;
		}
	}
	if (points.size() != 5) {
		return "Not enough reachable points in this subarea on its available floors. No exploration was reset.";
	}
	if (!saveDiscovery(subarea, points)) {
		return "Could not save discovery. Your previous exploration was preserved.";
	}
	for (const auto &point : discoveryPoints()) {
		if (point.state != 2 && discoveryDistance(point.position, origin) <= 7) {
			m_player.removeMagicEffect(point.position, CONST_ME_PINK_VORTEX);
		}
	}
	discoveryState[subarea] = std::move(points);
	discoveryActive = subarea;
	discoveryNextEffects = 0;
	sendDiscoveryEffects();
	g_logger().info(fmt::format("[CyclopediaDiscovery] player={} subarea={} points=5", m_player.getGUID(), subarea));
	return "";
}

void PlayerCyclopedia::onDiscoveryMove(bool teleport) {
	const auto client = m_player.getClient();
	if (!client || client->getClientVersionString() != "15.25.0a00a0d67311e057aa8e659a84cdf51db9c08c03" || !loadDiscovery() || m_player.isRemoved()) {
		return;
	}
	bool changed = false;
	if (!teleport && discoveryActive != 0 && discoveryNow() >= discoveryNextWrite) {
		auto points = discoveryState.at(discoveryActive);
		const auto previousReached = std::ranges::count_if(points, [](const auto &point) { return point.state == 2; });
		for (auto &point : points) {
			const auto distance = discoveryDistance(point.position, m_player.getPosition());
			const uint8_t state = distance <= 1 ? 2 : distance <= 7 ? 1
																	: 0;
			if (state > point.state) {
				point.state = state;
				changed = true;
			}
		}
		if (changed) {
			if (saveDiscovery(discoveryActive, points)) {
				const auto &previous = discoveryState.at(discoveryActive);
				for (size_t i = 0; i < points.size(); ++i) {
					if (points[i].state == 2 && previous[i].state != 2) {
						m_player.removeMagicEffect(points[i].position, CONST_ME_PINK_VORTEX);
						m_player.sendMagicEffect(points[i].position, CONST_ME_PINK_BEAM);
					}
				}
				const auto reached = std::ranges::count_if(points, [](const auto &point) { return point.state == 2; });
				if (reached > previousReached) {
					m_player.sendTextMessage(MESSAGE_EVENT_ADVANCE, "Well done! You discovered a point of interest!");
					if (static_cast<size_t>(reached) == points.size()) {
						m_player.sendTextMessage(MESSAGE_EVENT_ADVANCE, fmt::format("Congratulations! You discovered subarea {} completely!", discoveryRegions().at(discoveryActive).name));
					}
				}
				discoveryState[discoveryActive] = std::move(points);
			} else {
				discoveryNextWrite = discoveryNow() + 3000;
				changed = false;
			}
		}
	}
	const auto area = currentDiscoveryArea();
	if (area != discoveryLastArea) {
		const auto previous = discoveryRegions().find(discoveryLastArea);
		if (previous != discoveryRegions().end()) {
			const auto points = discoveryState.find(discoveryLastArea);
			if (points == discoveryState.end() || std::ranges::any_of(points->second, [](const auto &point) { return point.state != 2; })) {
				m_player.sendTextMessage(MESSAGE_FAILURE, fmt::format("You have left the subarea {}. Return to discover its remaining secrets!", previous->second.name));
			}
		}
		const auto entered = discoveryRegions().find(area);
		if (entered != discoveryRegions().end()) {
			const auto points = discoveryState.find(area);
			if (points == discoveryState.end() || std::ranges::any_of(points->second, [](const auto &point) { return point.state != 2; })) {
				m_player.sendTextMessage(MESSAGE_FAILURE, fmt::format("You have entered the subarea {}. Find {} points of interest to fully discover it.", entered->second.name, points == discoveryState.end() ? 5 : points->second.size()));
			}
		}
	}
	if (changed || area != discoveryLastArea) {
		discoveryLastArea = area;
		m_player.sendCyclopediaDiscovery();
	}
	sendDiscoveryEffects();
}

void PlayerCyclopedia::sendDiscoveryEffects() {
	const auto client = m_player.getClient();
	if (!client || client->getClientVersionString() != "15.25.0a00a0d67311e057aa8e659a84cdf51db9c08c03"
	    || m_player.isRemoved() || !discoveryLoaded || discoveryActive == 0) {
		return;
	}
	const auto now = discoveryNow();
	if (now < discoveryNextEffects) {
		return;
	}
	discoveryNextEffects = now + 1000;
	for (const auto &point : discoveryPoints()) {
		if (point.state != 2 && discoveryDistance(point.position, m_player.getPosition()) <= 7) {
			m_player.sendMagicEffect(point.position, CONST_ME_PINK_VORTEX);
		}
	}
}

std::vector<PlayerCyclopedia::DiscoveryProgress> PlayerCyclopedia::discoveryProgress() {
	std::vector<DiscoveryProgress> progress;
	for (const auto &[id, region] : discoveryRegions()) {
		uint32_t reached = 0, total = 0;
		const auto add = [&](uint16_t area) {
			if (!discoveryRegions().contains(area) || discoveryRegions().at(area).rows.empty()) {
				return;
			}
			total += 5;
			if (const auto points = discoveryState.find(area); points != discoveryState.end()) {
				reached += static_cast<uint32_t>(std::ranges::count_if(points->second, [](const auto &point) { return point.state == 2; }));
			}
		};
		if (region.children.empty()) {
			add(id);
		} else {
			for (const auto child : region.children) {
				add(child);
			}
		}
		const auto percent = static_cast<uint8_t>(total ? reached * 100 / total : 0);
		progress.push_back({ id, static_cast<uint8_t>(percent == 100 ? 3 : percent >= 66 ? 2
		                                                  : percent >= 33                ? 1
		                                                                                 : 0),
		                     percent });
	}
	return progress;
}

std::vector<uint16_t> PlayerCyclopedia::discoverableAreas() const {
	std::vector<uint16_t> ids;
	for (const auto &[id, region] : discoveryRegions()) {
		const auto points = discoveryState.find(id);
		if (!region.rows.empty() && (points == discoveryState.end() || std::ranges::any_of(points->second, [](const auto &point) { return point.state != 2; }))) {
			ids.push_back(id);
		}
	}
	return ids;
}

std::vector<uint16_t> PlayerCyclopedia::completedDiscoveryAreas() const {
	std::vector<uint16_t> ids;
	for (const auto &[id, points] : discoveryState) {
		if (!points.empty() && std::ranges::all_of(points, [](const auto &point) { return point.state == 2; })) {
			ids.push_back(id);
		}
	}
	return ids;
}

uint16_t PlayerCyclopedia::currentDiscoveryArea() const {
	const auto position = m_player.getPosition();
	if (discoveryActive != 0 && discoveryRegions().at(discoveryActive).contains(position)) {
		return discoveryActive;
	}
	for (const auto &[id, region] : discoveryRegions()) {
		if (region.contains(position)) {
			return id;
		}
	}
	return 0;
}

const std::vector<PlayerCyclopedia::DiscoveryPoint> &PlayerCyclopedia::discoveryPoints() const {
	static const std::vector<DiscoveryPoint> empty;
	const auto points = discoveryState.find(discoveryActive);
	return points == discoveryState.end() ? empty : points->second;
}

Summary PlayerCyclopedia::getSummary() const {
	return { getAmount(Summary_t::PREY_CARDS),
		     getAmount(Summary_t::INSTANT_REWARDS),
		     getAmount(Summary_t::HIRELINGS) };
}

void PlayerCyclopedia::loadSummaryData() const {
	const DBResult_ptr result = g_database().storeQuery(fmt::format("SELECT COUNT(*) as `count` FROM `player_hirelings` WHERE `player_id` = {}", m_player.getGUID()));
	const auto kvScoped = m_player.kv()->scoped("summary")->scoped(g_game().getSummaryKeyByType(static_cast<uint8_t>(Summary_t::HIRELINGS)));
	if (result && !kvScoped->get("amount").has_value()) {
		kvScoped->set("amount", result->getNumber<int16_t>("count"));
	}
}

void PlayerCyclopedia::loadDeathHistory(uint16_t page, uint16_t entriesPerPage) const {
	Benchmark bm_check;
	uint32_t offset = static_cast<uint32_t>(page - 1) * entriesPerPage;
	const auto query = fmt::format("SELECT `time`, `level`, `killed_by`, `mostdamage_by`, `participants`, (select count(*) FROM `player_deaths` WHERE `player_id` = {} AND `time` >= UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 30 DAY))) as `entries` FROM `player_deaths` WHERE `player_id` = {} AND `time` >= UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 30 DAY)) ORDER BY `time` DESC LIMIT {}, {}", m_player.getGUID(), m_player.getGUID(), offset, entriesPerPage);

	uint32_t playerID = m_player.getID();
	const std::function<void(DBResult_ptr, bool)> callback = [playerID, page, entriesPerPage](const DBResult_ptr &result, bool) {
		const auto &player = g_game().getPlayerByID(playerID);
		if (!player) {
			return;
		}

		player->resetAsyncOngoingTask(PlayerAsyncTask_RecentDeaths);
		if (!result) {
			player->sendCyclopediaCharacterRecentDeaths(0, 0, {});
			return;
		}

		auto pages = result->getNumber<uint32_t>("entries");
		pages += entriesPerPage - 1;
		pages /= entriesPerPage;

		std::vector<RecentDeathEntry> entries;
		entries.reserve(result->countResults());
		do {
			std::string killed_by = result->getString("killed_by");
			std::string mostdamage_by = result->getString("mostdamage_by");
			std::string participants = result->getString("participants");
			// Debug: Log the raw participants string
			g_logger().debug("Participants string: {}", participants);

			std::string cause = fmt::format("Died at level {}", result->getNumber<uint32_t>("level"));
			if (!killed_by.empty()) {
				cause.append(fmt::format(" by {}", killed_by));
			}
			if (!mostdamage_by.empty()) {
				if (killed_by.empty()) {
					cause.append(fmt::format(" by {}", mostdamage_by));
				} else if (mostdamage_by != killed_by) {
					cause.append(fmt::format(" and by {}", mostdamage_by));
				} else {
					cause.append(" <b>(soloed)</b>");
				}
			}

			if (!participants.empty()) {
				std::map<std::string, std::pair<int, std::string>> participantCount;
				std::set<std::string> skipped; // Track skipped names like PHP
				std::istringstream iss(participants);
				std::string line;
				while (std::getline(iss, line)) {
					if (line.find("Name: ") == 0) {
						auto trim_cr = [](std::string &s) {
							if (!s.empty() && s.back() == '\r') {
								s.pop_back();
							}
						};
						std::string name = line.substr(6);
						trim_cr(name);
						const auto pos = iss.tellg();
						std::string typeLine;
						if (std::getline(iss, typeLine) && typeLine.find("Type: ") == 0) {
							std::string type = typeLine.substr(6);
							trim_cr(type);
							// Skip only if not already skipped (mimic PHP logic)
							if ((name == killed_by || name == mostdamage_by) && !skipped.contains(name)) {
								skipped.insert(name);
								continue;
							}
							participantCount[name].first++; // Increment count
							participantCount[name].second = type; // Store type
						} else {
							g_logger().warn("Malformed participant entry for name '{}': expected 'Type: ' line", name);
							if (pos != std::istringstream::pos_type(-1)) {
								iss.seekg(pos);
							}
						}
					}
				}

				std::vector<std::string> players;
				std::vector<std::string> monsters;
				for (const auto &[name, data] : participantCount) {
					int count = data.first;
					std::string type = data.second;
					std::string entry = count > 1 ? fmt::format("{}x {}", count, name) : name;
					if (type == "player") {
						players.push_back(entry);
					} else if (type == "monster") {
						monsters.push_back(entry);
					} else {
						g_logger().warn("Unrecognized participant type '{}' for name '{}'", type, name);
					}
				}

				if (!players.empty() || !monsters.empty()) {
					cause.append(", ");
					std::vector<std::string> allParticipants;
					allParticipants.insert(allParticipants.end(), players.begin(), players.end());
					allParticipants.insert(allParticipants.end(), monsters.begin(), monsters.end());
					cause.append(fmt::format("{}", fmt::join(allParticipants, ", ")));
				}
				// Debug: Log the final cause string
				g_logger().debug("Cause string: {}", cause);
			}

			entries.emplace_back(cause, result->getNumber<uint32_t>("time"));
		} while (result->next());
		player->sendCyclopediaCharacterRecentDeaths(page, static_cast<uint16_t>(pages), entries);
	};
	g_databaseTasks().store(query, callback);
	m_player.addAsyncOngoingTask(PlayerAsyncTask_RecentDeaths);

	g_logger().debug("Loading death history from the player {} took {} milliseconds.", m_player.getName(), bm_check.duration());
}

void PlayerCyclopedia::loadRecentKills(uint16_t page, uint16_t entriesPerPage) const {
	Benchmark bm_check;

	const std::string &escapedName = g_database().escapeString(m_player.getName());
	uint32_t offset = static_cast<uint32_t>(page - 1) * entriesPerPage;
	const auto query = fmt::format("SELECT `d`.`time`, `d`.`killed_by`, `d`.`mostdamage_by`, `d`.`unjustified`, `d`.`mostdamage_unjustified`, `p`.`name`, (select count(*) FROM `player_deaths` WHERE ((`killed_by` = {} AND `is_player` = 1) OR (`mostdamage_by` = {} AND `mostdamage_is_player` = 1))) as `entries` FROM `player_deaths` AS `d` INNER JOIN `players` AS `p` ON `d`.`player_id` = `p`.`id` WHERE ((`d`.`killed_by` = {} AND `d`.`is_player` = 1) OR (`d`.`mostdamage_by` = {} AND `d`.`mostdamage_is_player` = 1)) AND `time` >= UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 70 DAY)) ORDER BY `time` DESC LIMIT {}, {}", escapedName, escapedName, escapedName, escapedName, offset, entriesPerPage);

	uint32_t playerID = m_player.getID();
	const std::function<void(DBResult_ptr, bool)> callback = [playerID, page, entriesPerPage](const DBResult_ptr &result, bool) {
		const auto &player = g_game().getPlayerByID(playerID);
		if (!player) {
			return;
		}

		player->resetAsyncOngoingTask(PlayerAsyncTask_RecentPvPKills);
		if (!result) {
			player->sendCyclopediaCharacterRecentPvPKills(0, 0, {});
			return;
		}

		auto pages = result->getNumber<uint32_t>("entries");
		pages += entriesPerPage - 1;
		pages /= entriesPerPage;

		std::vector<RecentPvPKillEntry> entries;
		entries.reserve(result->countResults());
		do {
			std::string cause1 = result->getString("killed_by");
			std::string cause2 = result->getString("mostdamage_by");
			std::string name = result->getString("name");

			uint8_t status = CYCLOPEDIA_CHARACTERINFO_RECENTKILLSTATUS_JUSTIFIED;
			if (player->getName() == cause1) {
				if (result->getNumber<uint32_t>("unjustified") == 1) {
					status = CYCLOPEDIA_CHARACTERINFO_RECENTKILLSTATUS_UNJUSTIFIED;
				}
			} else if (player->getName() == cause2) {
				if (result->getNumber<uint32_t>("mostdamage_unjustified") == 1) {
					status = CYCLOPEDIA_CHARACTERINFO_RECENTKILLSTATUS_UNJUSTIFIED;
				}
			}

			entries.emplace_back(fmt::format("Killed {}.", name), result->getNumber<uint32_t>("time"), status);
		} while (result->next());
		player->sendCyclopediaCharacterRecentPvPKills(page, static_cast<uint16_t>(pages), entries);
	};
	g_databaseTasks().store(query, callback);
	m_player.addAsyncOngoingTask(PlayerAsyncTask_RecentPvPKills);

	g_logger().debug("Loading recent kills from the player {} took {} milliseconds.", m_player.getName(), bm_check.duration());
}

void PlayerCyclopedia::updateStoreSummary(uint8_t type, uint16_t amount, const std::string &id) const {
	switch (type) {
		case Summary_t::HOUSE_ITEMS:
		case Summary_t::BLESSINGS:
			insertValue(type, amount, id);
			break;
		case Summary_t::ALL_BLESSINGS:
			for (auto blessIt : magic_enum::enum_values<Blessings>()) {
				insertValue(static_cast<uint8_t>(Summary_t::BLESSINGS), amount, fmt::format("{}", blessIt));
			}
			break;
		default:
			updateAmount(type, amount);
			break;
	}
}

uint16_t PlayerCyclopedia::getAmount(uint8_t type) const {
	const auto kvScope = m_player.kv()->scoped("summary")->scoped(g_game().getSummaryKeyByType(type))->get("amount");
	return static_cast<uint16_t>(kvScope ? kvScope->getNumber() : 0);
}

void PlayerCyclopedia::updateAmount(uint8_t type, uint16_t amount) const {
	const auto oldAmount = getAmount(type);
	m_player.kv()->scoped("summary")->scoped(g_game().getSummaryKeyByType(type))->set("amount", oldAmount + amount);
}

std::map<uint16_t, uint16_t> PlayerCyclopedia::getResult(uint8_t type) const {
	const auto kvScope = m_player.kv()->scoped("summary")->scoped(g_game().getSummaryKeyByType(type));
	std::map<uint16_t, uint16_t> result; // ID, amount
	for (const auto &scope : kvScope->keys()) {
		const size_t &pos = scope.find('.');
		if (pos == std::string::npos) {
			g_logger().error("[{}] Invalid key format: {}", __FUNCTION__, scope);
			continue;
		}
		std::string id = scope.substr(0, pos);
		const auto amount = kvScope->scoped(id)->get("amount");
		result.emplace(std::stoll(id), static_cast<uint16_t>(amount ? amount->getNumber() : 0));
	}
	return result;
}

void PlayerCyclopedia::insertValue(uint8_t type, uint16_t amount, const std::string &id) const {
	auto result = getResult(type);
	const auto it = result.find(std::stoll(id));
	auto oldAmount = (it != result.end() ? it->second : 0);
	auto newAmount = oldAmount + amount;
	m_player.kv()->scoped("summary")->scoped(g_game().getSummaryKeyByType(type))->scoped(id)->set("amount", newAmount);
	g_logger().debug("[{}] type: {}, id: {}, old amount: {}, added amount: {}, new amount: {}", __FUNCTION__, type, id, oldAmount, amount, newAmount);
}
