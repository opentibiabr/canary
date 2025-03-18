/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

// Player.hpp already includes the title
#include "creatures/players/player.hpp"

#include "creatures/appearance/mounts/mounts.hpp"
#include "creatures/monsters/monsters.hpp"
#include "enums/account_group_type.hpp"
#include "game/game.hpp"
#include "kv/kv.hpp"
#include "enums/account_group_type.hpp"

PlayerTitle::PlayerTitle(Player &player) :
	m_player(player) { }

bool PlayerTitle::isTitleUnlocked(uint8_t id) const {
	if (id == 0) {
		return false;
	}

	if (auto it = std::ranges::find_if(m_titlesUnlocked, [id](auto title_it) {
			return title_it.first.m_id == id;
		});
	    it != m_titlesUnlocked.end()) {
		return true;
	}

	return false;
}

bool PlayerTitle::manage(bool canAdd, uint8_t id, uint32_t timestamp /* = 0*/) {
	const Title &title = g_game().getTitleById(id);
	if (title.m_id == 0) {
		return false;
	}

	if (!canAdd) {
		if (!title.m_permanent) {
			remove(title);
		}
		return false;
	}

	if (isTitleUnlocked(id)) {
		return false;
	}

	int toSaveTimeStamp = timestamp != 0 ? timestamp : (OTSYS_TIME() / 1000);
	getUnlockedKV()->set(title.m_maleName, toSaveTimeStamp);
	m_titlesUnlocked.emplace_back(title, toSaveTimeStamp);
	m_titlesUnlocked.shrink_to_fit();
	g_logger().debug("[{}] - Added title: {}", __FUNCTION__, title.m_maleName);

	return true;
}

void PlayerTitle::remove(const Title &title) {
	auto id = title.m_id;
	if (!isTitleUnlocked(id)) {
		return;
	}

	auto it = std::ranges::find_if(m_titlesUnlocked, [id](auto title_it) {
		return title_it.first.m_id == id;
	});

	if (it == m_titlesUnlocked.end()) {
		return;
	}

	getUnlockedKV()->remove(title.m_maleName);
	m_titlesUnlocked.erase(it);
	m_titlesUnlocked.shrink_to_fit();
	g_logger().debug("[{}] - Removed title: {}", __FUNCTION__, title.m_maleName);
}

const std::vector<std::pair<Title, uint32_t>> &PlayerTitle::getUnlockedTitles() {
	return m_titlesUnlocked;
}

uint8_t PlayerTitle::getCurrentTitle() const {
	const auto title = m_player.kv()->scoped("titles")->get("current-title");
	return title ? static_cast<uint8_t>(title->getNumber()) : 0;
}

void PlayerTitle::setCurrentTitle(uint8_t id) const {
	m_player.kv()->scoped("titles")->set("current-title", id != 0 && isTitleUnlocked(id) ? id : 0);
}

std::string PlayerTitle::getCurrentTitleName() const {
	const auto currentTitle = getCurrentTitle();
	if (currentTitle == 0) {
		return "";
	}

	const auto &title = g_game().getTitleById(currentTitle);
	if (title.m_id == 0) {
		return "";
	}

	return getNameBySex(m_player.getSex(), title.m_maleName, title.m_femaleName);
}

const std::string &PlayerTitle::getNameBySex(PlayerSex_t sex, const std::string &male, const std::string &female) {
	return sex == PLAYERSEX_FEMALE && !female.empty() ? female : male;
}

void PlayerTitle::checkAndUpdateNewTitles() {
	Benchmark bm_checkTitles;
	for (const auto &title : g_game().getTitles()) {
		switch (title.m_type) {
			case CyclopediaTitle_t::NOTHING:
				break;
			case CyclopediaTitle_t::GOLD:
				manage(checkGold(title.m_amount), title.m_id);
				break;
			case CyclopediaTitle_t::MOUNTS:
				manage(checkMount(title.m_amount), title.m_id);
				break;
			case CyclopediaTitle_t::OUTFITS:
				manage(checkOutfit(title.m_amount), title.m_id);
				break;
			case CyclopediaTitle_t::LEVEL:
				manage(checkLevel(title.m_amount), title.m_id);
				break;
			case CyclopediaTitle_t::HIGHSCORES:
				manage(checkHighscore(title.m_skill), title.m_id);
				break;
			case CyclopediaTitle_t::BESTIARY:
			case CyclopediaTitle_t::BOSSTIARY:
				manage(checkBestiary(title.m_maleName, title.m_race, title.m_type == CyclopediaTitle_t::BOSSTIARY, title.m_amount), title.m_id);
				break;
			case CyclopediaTitle_t::DAILY_REWARD:
				manage(checkLoginStreak(title.m_amount), title.m_id);
				break;
			case CyclopediaTitle_t::TASK:
				manage(checkTask(title.m_amount), title.m_id);
				break;
			case CyclopediaTitle_t::MAP:
				// manage(checkMap(title.m_amount), title.m_id);
				break;
			case CyclopediaTitle_t::OTHERS:
				manage(checkOther(title.m_maleName), title.m_id);
				break;
		}
	}

	g_logger().debug("Checking and updating titles of player {} took {} milliseconds.", m_player.getName(), bm_checkTitles.duration());

	loadUnlockedTitles();
}

void PlayerTitle::loadUnlockedTitles() {
	const auto &unlockedTitles = getUnlockedKV()->keys();
	g_logger().debug("[{}] - Loading unlocked titles: {}", __FUNCTION__, unlockedTitles.size());
	for (const auto &titleName : unlockedTitles) {
		const Title &title = g_game().getTitleByName(titleName);
		if (title.m_id == 0) {
			g_logger().error("[{}] - Title {} not found.", __FUNCTION__, titleName);
			continue;
		}

		m_titlesUnlocked.emplace_back(title, getUnlockedKV()->get(titleName)->getNumber());
	}
}

const std::shared_ptr<KV> &PlayerTitle::getUnlockedKV() {
	if (m_titleUnlockedKV == nullptr) {
		m_titleUnlockedKV = m_player.kv()->scoped("titles")->scoped("unlocked");
	}

	return m_titleUnlockedKV;
}

// Title Calculate Functions
bool PlayerTitle::checkGold(uint32_t amount) const {
	return m_player.getBankBalance() >= amount;
}

bool PlayerTitle::checkMount(uint32_t amount) const {
	uint8_t total = 0;
	for (const auto &mount : g_game().mounts->getMounts()) {
		if (m_player.hasMount(mount)) {
			total++;
		}
	}
	return total >= amount;
}

bool PlayerTitle::checkOutfit(uint32_t amount) const {
	return m_player.outfits.size() >= amount;
}

bool PlayerTitle::checkLevel(uint32_t amount) const {
	return m_player.getLevel() >= amount;
}

bool PlayerTitle::checkHighscore(uint8_t skill) const {
	Database &db = Database::getInstance();
	std::string query;
	std::string fieldCheck = "id";

	switch (static_cast<HighscoreCategories_t>(skill)) {
		case HighscoreCategories_t::CHARMS:
			query = fmt::format(
				"SELECT `pc`.`player_guid`, `pc`.`charm_points`, `p`.`group_id` FROM `player_charms` pc JOIN `players` p ON `pc`.`player_guid` = `p`.`id` WHERE `p`.`group_id` < {} ORDER BY `pc`.`charm_points` DESC LIMIT 1",
				static_cast<int>(GROUP_TYPE_GAMEMASTER)
			);
			fieldCheck = "player_guid";
			break;
		case HighscoreCategories_t::DROME:
			// todo check if player is in the top 5 for the previous rota of the Tibiadrome.
			return false;
		case HighscoreCategories_t::GOSHNAR:
			// todo check if player is the most killer of Goshnar and his aspects.
			return false;
		default:
			std::string skillName = g_game().getSkillNameById(skill);
			query = fmt::format(
				"SELECT `id` FROM `players` "
				"WHERE `group_id` < {} AND `{}` > 10 "
				"ORDER BY `{}` DESC LIMIT 1",
				static_cast<int>(GROUP_TYPE_GAMEMASTER), skillName, skillName
			);
			break;
	}

	const DBResult_ptr result = db.storeQuery(query);
	if (!result) {
		return false;
	}

	auto resultValue = result->getNumber<uint32_t>(fieldCheck);
	g_logger().debug("top id: {}, player id: {}", resultValue, m_player.getGUID());

	return resultValue == m_player.getGUID();
}

bool PlayerTitle::checkBestiary(const std::string &name, uint16_t race, bool isBoss /* = false*/, uint32_t amount) const {
	if (race == 0) {
		if (name == "Executioner") {
			// todo check if player has unlocked all bestiary
		} else if (name == "Boss Executioner") {
			// todo check if player has unlocked all bosses
		}
		return false;
	}
	if (isBoss && amount > 0) {
		// todo check if this way, is calculating by boss race
		return m_player.getBestiaryKillCount(race) >= amount;
	}
	return m_player.isCreatureUnlockedOnTaskHunting(g_monsters().getMonsterTypeByRaceId(race, isBoss));
}

bool PlayerTitle::checkLoginStreak(uint32_t amount) const {
	const auto streakKV = m_player.kv()->scoped("daily-reward")->get("streak");
	return streakKV && streakKV.has_value() && static_cast<uint8_t>(streakKV->getNumber()) >= amount;
}

bool PlayerTitle::checkTask(uint32_t amount) const {
	return m_player.getTaskHuntingPoints() >= amount;
}

bool PlayerTitle::checkMap(uint32_t) const {
	// todo cyclopledia
	return false;
}

bool PlayerTitle::checkOther(const std::string &name) const {
	if (name == "Guild Leader") {
		const auto &rank = m_player.getGuildRank();
		return rank && rank->level == 3;
	} else if (name == "Proconsul of Iksupan") {
		// Win Ancient Aucar Outfits complete so fight with Atab and be teleported to the arena.
	} else if (name == "Admirer of the Crown") {
		// Complete the Royal Costume Outfits.
		return m_player.canWear(1457, 3) && m_player.canWear(1456, 3);
	} else if (name == "Big Spender") {
		// Unlocked the full Golden Outfit.
		return m_player.canWear(1211, 3) && m_player.canWear(1210, 3);
	} else if (name == "Challenger of the Iks") {
		// Defeat Ahau while equipping a Broken Iks Headpiece, a Broken Iks Cuirass, some Broken Iks Faulds and Broken Iks Sandals
		return m_player.getBestiaryKillCount(2346) >= 1;
	} else if (name == "Royal Bounacean Advisor") {
		// Complete the Galthen and the Lost Queen quest line
		// Win Royal Bounacean Outfit
		return m_player.canWear(1437, 3) && m_player.canWear(1436, 3);
	} else if (name == "Aeternal") {
		// Unlocked by 10-year-old characters.
	} else if (name == "Robinson Crusoe") {
		// Visit Schrödinger's Island.
	} else if (name == "Chompmeister") {
		// Complete all Jean Pierre's dishes in Hot Cuisine Quest.
	} else if (name == "Bringer of Rain") {
		// Clear wave 100 in the Tibiadrome.
	} else if (name == "Beastly") {
		// Reached 2000 charm points
		return m_player.getCharmPoints() >= 2000;
	} else if (name == "Midnight Hunter") {
		// Kill a certain amount of Midnight Panthers.
		// (The exact number is yet to be confirmed but is at least 21 and at most 28 panthers.)
		return m_player.getBestiaryKillCount(698) >= 25;
	} else if (name == "Ratinator") {
		// Kill 10,000 Cave Rats.
		return m_player.getBestiaryKillCount(56) >= 10000;
	} else if (name == "Doomsday Nemesis") {
		// Kill Gaz'haragoth one time.
		return m_player.getBestiaryKillCount(1003) >= 1;
	} else if (name == "Hero of Bounac") {
		// Complete The Order of the Lion Quest.
	} else if (name == "King of Demon") {
		// Defeat Morshabaal 5 times.
		return m_player.getBestiaryKillCount(2118) >= 5;
	} else if (name == "Planegazer") {
		// Kill Planestrider in Opticording Sphere Quest.
	} else if (name == "Time Traveller") {
		// Complete 25 Years of Tibia Quest.
	} else if (name == "Truly Boss") {
		return m_player.getBossPoints() >= 15000;
	}
	return false;
}
