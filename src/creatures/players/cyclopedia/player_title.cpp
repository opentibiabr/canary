/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "player_title.hpp"

#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "kv/kv.hpp"

PlayerTitle::PlayerTitle(Player &player) :
	m_player(player) { }

bool PlayerTitle::isTitleUnlocked(uint8_t id) const {
	if (id == 0) {
		return false;
	}

	if (auto it = std::find_if(m_titlesUnlocked.begin(), m_titlesUnlocked.end(), [id](auto title_it) {
			return title_it.first.m_id == id;
		});
		it != m_titlesUnlocked.end()) {
		return true;
	}

	return false;
}

bool PlayerTitle::add(uint8_t id, uint32_t timestamp /* = 0*/) {
	if (isTitleUnlocked(id)) {
		return false;
	}

	const Title &title = g_game().getTitleById(id);
	if (title.m_id == 0) {
		return false;
	}

	int toSaveTimeStamp = timestamp != 0 ? timestamp : (OTSYS_TIME() / 1000);
	getUnlockedKV()->set(title.m_maleName, toSaveTimeStamp);
	m_titlesUnlocked.emplace_back(title, toSaveTimeStamp);
	m_titlesUnlocked.shrink_to_fit();
	g_logger().debug("[{}] - Added title: {}", __FUNCTION__, title.m_maleName);
	return true;
}

std::vector<std::pair<Title, uint32_t>> PlayerTitle::getUnlockedTitles() const {
	return m_titlesUnlocked;
}

uint8_t PlayerTitle::getCurrentTitle() const {
	return static_cast<uint8_t>(m_player.kv()->scoped("titles")->get("current-title")->getNumber());
}

void PlayerTitle::setCurrentTitle(uint8_t id) {
	m_player.kv()->scoped("titles")->set("current-title", id != 0 && isTitleUnlocked(id) ? id : 0);
}

std::string PlayerTitle::getCurrentTitleName() const {
	auto currentTitle = getCurrentTitle();
	if (currentTitle == 0) {
		return "";
	}

	auto title = g_game().getTitleById(currentTitle);
	if (title.m_id == 0) {
		return "";
	}
	return (m_player.getSex() == PLAYERSEX_FEMALE && !title.m_femaleName.empty()) ? title.m_femaleName : title.m_maleName;
}

void PlayerTitle::checkAndUpdateNewTitles() {
	Benchmark bm_checkTitles;
	for (const auto &title : g_game().getTitles()) {
		switch (title.m_type) {
			case CyclopediaTitle_t::NOTHING:
				break;
			case CyclopediaTitle_t::GOLD:
				if (checkGold(title.m_amount)) {
					add(title.m_id);
				}
				break;
			case CyclopediaTitle_t::MOUNTS:
				if (checkMount(title.m_amount)) {
					add(title.m_id);
				}
				break;
			case CyclopediaTitle_t::OUTFITS:
				if (checkOutfit(title.m_amount)) {
					add(title.m_id);
				}
				break;
			case CyclopediaTitle_t::LEVEL:
				if (checkLevel(title.m_amount)) {
					add(title.m_id);
				}
				break;
			case CyclopediaTitle_t::HIGHSCORES:
				// if (checkHighscore(title.m_skill)) {
				// 	add(title.m_id);
				// }
				break;
			case CyclopediaTitle_t::BESTIARY:
				if (checkBestiary(title.m_race)) {
					add(title.m_id);
				}
				break;
			case CyclopediaTitle_t::LOGIN:
				if (checkLoginStreak(title.m_amount)) {
					add(title.m_id);
				}
				break;
			case CyclopediaTitle_t::TASK:
				if (checkTask(title.m_amount)) {
					add(title.m_id);
				}
				break;
			case CyclopediaTitle_t::MAP:
				// if (checkMap(title.m_amount)) {
				// 	add(title.m_id);
				// }
				break;
			case CyclopediaTitle_t::QUEST:
				if (checkQuest(title.m_storage)) {
					add(title.m_id);
				}
				break;
			case CyclopediaTitle_t::OTHERS:
				if (checkOther(title.m_maleName)) {
					add(title.m_id);
				}
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

		auto femaleLog = !title.m_femaleName.empty() ? ("/" + title.m_femaleName) : "";
		// g_logger().debug("[{}] - Title {}{} found for player {}.", __FUNCTION__, title.m_maleName, femaleLog, m_player.getName());

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
bool PlayerTitle::checkGold(uint32_t amount) {
	return m_player.getBankBalance() >= amount;
}

bool PlayerTitle::checkMount(uint32_t amount) {
	uint8_t total = 0;
	for (const auto &mount : g_game().mounts.getMounts()) {
		if (m_player.hasMount(mount)) {
			total = total++;
		}
	}
	return total >= amount;
}

bool PlayerTitle::checkOutfit(uint32_t amount) {
	return m_player.outfits.size() >= amount;
}

bool PlayerTitle::checkLevel(uint32_t amount) {
	return m_player.getLevel() >= amount;
}

bool PlayerTitle::checkHighscore(uint8_t skill) {
	// todo cyclopledia
	return false;
	//	return g_game().getH() m_player.getLevel() >= amount;
}

bool PlayerTitle::checkBestiary(uint16_t race) {
	return m_player.isCreatureUnlockedOnTaskHunting(g_monsters().getMonsterTypeByRaceId(race));
}

bool PlayerTitle::checkLoginStreak(uint32_t amount) {
	auto streakKV = m_player.kv()->scoped("daily-reward")->get("streak");
	return streakKV && streakKV.has_value() && static_cast<uint8_t>(streakKV->getNumber()) >= amount;
}

bool PlayerTitle::checkTask(uint32_t amount) {
	return m_player.getTaskHuntingPoints() >= amount;
}

bool PlayerTitle::checkMap(uint32_t amount) {
	// todo cyclopledia
	return false;
}

bool PlayerTitle::checkQuest(TitleStorage storage) {
	return !storage.kvKey.empty()
		? m_player.kv()->get(storage.kvKey)->getNumber() == storage.value
		: m_player.getStorageValue(storage.key) == storage.value;
}

bool PlayerTitle::checkOther(std::string name) {
	if (name == "Admirer of the Crown") {
		// todo
		return false;
	} else if (name == "Big Spender" && m_player.canWear(1211, 3) && m_player.canWear(1210, 3)) {
		return true;
	} else if (name == "Guild Leader") {
		auto rank = m_player.getGuildRank();
		return rank && rank->level == 3;
	} else if (name == "Jack of all Taints") {
		// todo
		return false;
	} else if (name == "Reigning Drome Champion") {
		// todo
		return false;
	}
	return false;
}

/*int GameFunctions::luaGameGetHighscoresLeaderId(lua_State* L) {
// Game.getHighscoresLeaderId(skill)
const auto highscoreVector = g_game().getHighscoreByCategory(static_cast<HighscoreCategories_t>(getNumber<uint16_t>(L, 1, 0)));
if (highscoreVector.size() != 0) {
	lua_pushnumber(L, highscoreVector.front().id);
} else {
	lua_pushnumber(L, 0);
}

return 1;
}

int GameFunctions::luaGameGetBestiaryRaceAmount(lua_State* L) {
// Game.getBestiaryRaceAmount(race)
uint16_t entries = 0;
BestiaryType_t race = static_cast<BestiaryType_t>(getNumber<uint16_t>(L, 1, 0));
for (const auto mType_it : g_game().getBestiaryList()) {
	if (const MonsterType *mType = g_monsters().getMonsterType(mType_it.second);
		mType && mType->info.bestiaryRace == race) {
		entries++;
	}
}

lua_pushnumber(L, entries);
return 1;
}*/
