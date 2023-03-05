/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/combat/combat.h"
#include "creatures/combat/spells.h"
#include "creatures/monsters/monster.h"
#include "game/game.h"
#include "lua/scripts/lua_environment.hpp"

Spells::Spells() = default;
Spells::~Spells() = default;

TalkActionResult_t Spells::playerSaySpell(Player* player, std::string &words) {
	std::string str_words = words;

	// strip trailing spaces
	trimString(str_words);

	InstantSpell* instantSpell = getInstantSpell(str_words);
	if (!instantSpell) {
		return TALKACTION_CONTINUE;
	}

	std::string param;

	if (instantSpell->getHasParam()) {
		size_t spellLen = instantSpell->getWords().length();
		size_t paramLen = str_words.length() - spellLen;
		std::string paramText = str_words.substr(spellLen, paramLen);
		if (!paramText.empty() && paramText.front() == ' ') {
			size_t loc1 = paramText.find('"', 1);
			if (loc1 != std::string::npos) {
				size_t loc2 = paramText.find('"', loc1 + 1);
				if (loc2 == std::string::npos) {
					loc2 = paramText.length();
				} else if (paramText.find_last_not_of(' ') != loc2) {
					return TALKACTION_CONTINUE;
				}

				param = paramText.substr(loc1 + 1, loc2 - loc1 - 1);
			} else {
				trimString(paramText);
				loc1 = paramText.find(' ', 0);
				if (loc1 == std::string::npos) {
					param = paramText;
				} else {
					return TALKACTION_CONTINUE;
				}
			}
		}
	}

	if (instantSpell->playerCastInstant(player, param)) {
		words = instantSpell->getWords();

		if (instantSpell->getHasParam() && !param.empty()) {
			words += " \"" + param + "\"";
		}

		return TALKACTION_BREAK;
	}

	return TALKACTION_FAILED;
}

void Spells::clear() {
	instants.clear();
	runes.clear();
}

bool Spells::hasInstantSpell(const std::string &word) const {
	if (auto iterate = instants.find(word);
		iterate != instants.end()) {
		return true;
	}
	return false;
}

bool Spells::registerInstantLuaEvent(InstantSpell* event) {
	InstantSpell_ptr instant { event };
	if (instant) {
		// If the spell not have the "spell:words()" return a error message
		const std::string &instantName = instant->getName();
		if (instant->getWordsMap().empty()) {
			SPDLOG_ERROR("[Spells::registerInstantLuaEvent] - Missing register words for spell with name {}", instantName);
			return false;
		}

		const std::string &words = instant->getWords();
		// Checks if there is any spell registered with the same name
		if (hasInstantSpell(words)) {
			SPDLOG_WARN("[Spells::registerInstantLuaEvent] - "
						"Duplicate registered instant spell with words: {}, on spell with name: {}",
						words, instantName);
			return false;
		}
		// Register spell word in the map
		setInstantSpell(words, *instant);
	}

	return false;
}

bool Spells::registerRuneLuaEvent(RuneSpell* event) {
	RuneSpell_ptr rune { event };
	if (rune) {
		uint16_t id = rune->getRuneItemId();
		auto result = runes.emplace(rune->getRuneItemId(), std::move(*rune));
		if (!result.second) {
			SPDLOG_WARN(
				"[{}] duplicate registered rune with id: {}, for script: {}",
				__FUNCTION__,
				id,
				event->getScriptInterface()->getLoadingScriptName()
			);
		}
		return result.second;
	}

	return false;
}

std::list<uint16_t> Spells::getSpellsByVocation(uint16_t vocationId) {
	std::list<uint16_t> spellsList;
	VocSpellMap vocSpells;
	std::map<uint16_t, bool>::const_iterator vocSpellsIt;

	for (const auto &it : instants) {
		vocSpells = it.second.getVocMap();
		vocSpellsIt = vocSpells.find(vocationId);

		if (vocSpellsIt != vocSpells.end()
			&& vocSpellsIt->second) {
			spellsList.push_back(it.second.getId());
		}
	}

	return spellsList;
}

Spell* Spells::getSpellByName(const std::string &name) {
	Spell* spell = getRuneSpellByName(name);
	if (!spell) {
		spell = getInstantSpellByName(name);
	}
	return spell;
}

RuneSpell* Spells::getRuneSpell(uint32_t id) {
	auto it = runes.find(id);
	if (it == runes.end()) {
		for (auto &rune : runes) {
			if (rune.second.getId() == id) {
				return &rune.second;
			}
		}
		return nullptr;
	}
	return &it->second;
}

RuneSpell* Spells::getRuneSpellByName(const std::string &name) {
	for (auto &it : runes) {
		if (strcasecmp(it.second.getName().c_str(), name.c_str()) == 0) {
			return &it.second;
		}
	}
	return nullptr;
}

InstantSpell* Spells::getInstantSpell(const std::string &words) {
	InstantSpell* result = nullptr;

	for (auto &it : instants) {
		const std::string &instantSpellWords = it.second.getWords();
		size_t spellLen = instantSpellWords.length();
		if (strncasecmp(instantSpellWords.c_str(), words.c_str(), spellLen) == 0) {
			if (!result || spellLen > result->getWords().length()) {
				result = &it.second;
				if (words.length() == spellLen) {
					break;
				}
			}
		}
	}

	if (result) {
		const std::string &resultWords = result->getWords();
		if (words.length() > resultWords.length()) {
			if (!result->getHasParam()) {
				return nullptr;
			}

			size_t spellLen = resultWords.length();
			size_t paramLen = words.length() - spellLen;
			if (paramLen < 2 || words[spellLen] != ' ') {
				return nullptr;
			}
		}
		return result;
	}
	return nullptr;
}

InstantSpell* Spells::getInstantSpellById(uint32_t spellId) {
	for (auto &it : instants) {
		if (it.second.getId() == spellId) {
			return &it.second;
		}
	}
	return nullptr;
}

InstantSpell* Spells::getInstantSpellByName(const std::string &name) {
	for (auto &it : instants) {
		if (strcasecmp(it.second.getName().c_str(), name.c_str()) == 0) {
			return &it.second;
		}
	}
	return nullptr;
}

Position Spells::getCasterPosition(Creature* creature, Direction dir) {
	return getNextPosition(dir, creature->getPosition());
}

CombatSpell::CombatSpell(Combat* newCombat, bool newNeedTarget, bool newNeedDirection) :
	Script(&g_spells().getScriptInterface()),
	combat(newCombat),
	needDirection(newNeedDirection),
	needTarget(newNeedTarget) {
	// Empty
}

bool CombatSpell::loadScriptCombat() {
	combat = g_luaEnvironment.getCombatObject(g_luaEnvironment.lastCombatId).get();
	return combat != nullptr;
}

bool CombatSpell::castSpell(Creature* creature) {
	if (isLoadedCallback()) {
		LuaVariant var;
		var.type = VARIANT_POSITION;

		if (needDirection) {
			var.pos = Spells::getCasterPosition(creature, creature->getDirection());
		} else {
			var.pos = creature->getPosition();
		}

		return executeCastSpell(creature, var);
	}

	Position pos;
	if (needDirection) {
		pos = Spells::getCasterPosition(creature, creature->getDirection());
	} else {
		pos = creature->getPosition();
	}

	combat->doCombat(creature, pos);
	return true;
}

bool CombatSpell::castSpell(Creature* creature, Creature* target) {
	if (isLoadedCallback()) {
		LuaVariant var;

		if (combat->hasArea()) {
			var.type = VARIANT_POSITION;

			if (needTarget) {
				var.pos = target->getPosition();
			} else if (needDirection) {
				var.pos = Spells::getCasterPosition(creature, creature->getDirection());
			} else {
				var.pos = creature->getPosition();
			}
		} else {
			var.type = VARIANT_NUMBER;
			var.number = target->getID();
		}

		return executeCastSpell(creature, var);
	}

	if (combat->hasArea()) {
		if (needTarget) {
			combat->doCombat(creature, target->getPosition());
		} else {
			return castSpell(creature);
		}
	} else {
		combat->doCombat(creature, target);
	}
	return true;
}

bool CombatSpell::executeCastSpell(Creature* creature, const LuaVariant &var) const {
	// onCastSpell(creature, var)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[CombatSpell::executeCastSpell - Creature {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 creature->getName());
		return false;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushVariant(L, var);

	return getScriptInterface()->callFunction(2);
}

bool Spell::playerSpellCheck(Player* player) const {
	if (player->hasFlag(PlayerFlags_t::CannotUseSpells)) {
		return false;
	}

	if (player->hasFlag(PlayerFlags_t::IgnoreSpellCheck)) {
		return true;
	}

	if (!enabled) {
		return false;
	}

	if (aggressive && (range < 1 || (range > 0 && !player->getAttackedCreature())) && player->getSkull() == SKULL_BLACK) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return false;
	}

	if (aggressive && player->hasCondition(CONDITION_PACIFIED)) {
		player->sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	if (aggressive && !player->hasFlag(PlayerFlags_t::IgnoreProtectionZone) && player->getZone() == ZONE_PROTECTION) {
		player->sendCancelMessage(RETURNVALUE_ACTIONNOTPERMITTEDINPROTECTIONZONE);
		return false;
	}

	if (player->hasCondition(CONDITION_SPELLGROUPCOOLDOWN, group) || player->hasCondition(CONDITION_SPELLCOOLDOWN, spellId) || (secondaryGroup != SPELLGROUP_NONE && player->hasCondition(CONDITION_SPELLGROUPCOOLDOWN, secondaryGroup))) {
		player->sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);

		if (isInstant()) {
			g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		}

		return false;
	}

	if (player->getLevel() < level) {
		player->sendCancelMessage(RETURNVALUE_NOTENOUGHLEVEL);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	if (player->getMagicLevel() < magLevel) {
		player->sendCancelMessage(RETURNVALUE_NOTENOUGHMAGICLEVEL);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	if (player->getMana() < getManaCost(player) && !player->hasFlag(PlayerFlags_t::HasInfiniteMana)) {
		player->sendCancelMessage(RETURNVALUE_NOTENOUGHMANA);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	if (player->getSoul() < soul && !player->hasFlag(PlayerFlags_t::HasInfiniteSoul)) {
		player->sendCancelMessage(RETURNVALUE_NOTENOUGHSOUL);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	if (isInstant() && getNeedLearn()) {
		if (!player->hasLearnedInstantSpell(getName())) {
			player->sendCancelMessage(RETURNVALUE_YOUNEEDTOLEARNTHISSPELL);
			g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
			return false;
		}
	} else if (!vocSpellMap.empty() && !vocSpellMap.contains(player->getVocationId())) {
		player->sendCancelMessage(RETURNVALUE_YOURVOCATIONCANNOTUSETHISSPELL);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	if (needWeapon) {
		switch (player->getWeaponType()) {
			case WEAPON_SWORD:
			case WEAPON_CLUB:
			case WEAPON_AXE:
				break;

			default: {
				player->sendCancelMessage(RETURNVALUE_YOUNEEDAWEAPONTOUSETHISSPELL);
				g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
				return false;
			}
		}
	}

	if (isPremium() && !player->isPremium()) {
		player->sendCancelMessage(RETURNVALUE_YOUNEEDPREMIUMACCOUNT);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	return true;
}

bool Spell::playerInstantSpellCheck(Player* player, const Position &toPos) {
	if (toPos.x == 0xFFFF) {
		return true;
	}

	const Position &playerPos = player->getPosition();
	if (playerPos.z > toPos.z) {
		player->sendCancelMessage(RETURNVALUE_FIRSTGOUPSTAIRS);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	} else if (playerPos.z < toPos.z) {
		player->sendCancelMessage(RETURNVALUE_FIRSTGODOWNSTAIRS);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	Tile* tile = g_game().map.getTile(toPos);
	if (!tile) {
		tile = new StaticTile(toPos.x, toPos.y, toPos.z);
		g_game().map.setTile(toPos, tile);
	}

	ReturnValue ret = Combat::canDoCombat(player, tile, aggressive);
	if (ret != RETURNVALUE_NOERROR) {
		player->sendCancelMessage(ret);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	if (blockingCreature && tile->getBottomVisibleCreature(player) != nullptr) {
		player->sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	if (blockingSolid && tile->hasFlag(TILESTATE_BLOCKSOLID)) {
		player->sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	return true;
}

bool Spell::playerRuneSpellCheck(Player* player, const Position &toPos) {
	if (!playerSpellCheck(player)) {
		return false;
	}

	if (toPos.x == 0xFFFF) {
		return true;
	}

	const Position &playerPos = player->getPosition();
	if (playerPos.z > toPos.z) {
		player->sendCancelMessage(RETURNVALUE_FIRSTGOUPSTAIRS);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	} else if (playerPos.z < toPos.z) {
		player->sendCancelMessage(RETURNVALUE_FIRSTGODOWNSTAIRS);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	Tile* tile = g_game().map.getTile(toPos);
	if (!tile) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	if (range != -1 && !g_game().canThrowObjectTo(playerPos, toPos, true, range, range)) {
		player->sendCancelMessage(RETURNVALUE_DESTINATIONOUTOFREACH);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	ReturnValue ret = Combat::canDoCombat(player, tile, aggressive);
	if (ret != RETURNVALUE_NOERROR) {
		player->sendCancelMessage(ret);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	const Creature* topVisibleCreature = tile->getBottomVisibleCreature(player);
	if (blockingCreature && topVisibleCreature) {
		player->sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	} else if (blockingSolid && tile->hasFlag(TILESTATE_BLOCKSOLID)) {
		player->sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	if (needTarget && !topVisibleCreature) {
		player->sendCancelMessage(RETURNVALUE_CANONLYUSETHISRUNEONCREATURES);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	if (aggressive && needTarget && topVisibleCreature && player->hasSecureMode()) {
		const Player* targetPlayer = topVisibleCreature->getPlayer();
		if (targetPlayer && targetPlayer != player && player->getSkullClient(targetPlayer) == SKULL_NONE && !Combat::isInPvpZone(player, targetPlayer)) {
			player->sendCancelMessage(RETURNVALUE_TURNSECUREMODETOATTACKUNMARKEDPLAYERS);
			g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
			return false;
		}
	}
	return true;
}

void Spell::applyCooldownConditions(Player* player) const {
	WheelOfDestinySpellGrade_t spellGrade = player->getWheelOfDestinySpellUpgrade(getName());
	bool isUpgraded = getWheelOfDestinyUpgraded() && spellGrade > 0;
	if (cooldown > 0) {
		int32_t spellCooldown = cooldown;
		if (isUpgraded) {
			spellCooldown -= getWheelOfDestinyBoost(WHEEL_OF_DESTINY_SPELL_BOOST_COOLDOWN, spellGrade);
		}
		if (spellCooldown > 0) {
			Condition* condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_SPELLCOOLDOWN, spellCooldown / g_configManager().getFloat(RATE_SPELL_COOLDOWN), 0, false, spellId);
			player->addCondition(condition);
		}
	}

	if (groupCooldown > 0) {
		int32_t spellGroupCooldown = groupCooldown;
		if (isUpgraded) {
			spellGroupCooldown -= getWheelOfDestinyBoost(WHEEL_OF_DESTINY_SPELL_BOOST_GROUP_COOLDOWN, spellGrade);
		}
		if (spellGroupCooldown > 0) {
			Condition* condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_SPELLGROUPCOOLDOWN, spellGroupCooldown / g_configManager().getFloat(RATE_SPELL_COOLDOWN), 0, false, group);
			player->addCondition(condition);
		}
	}

	if (secondaryGroupCooldown > 0) {
		int32_t spellSecondaryGroupCooldown = secondaryGroupCooldown;
		if (isUpgraded) {
			spellSecondaryGroupCooldown -= getWheelOfDestinyBoost(WHEEL_OF_DESTINY_SPELL_BOOST_SECONDARY_GROUP_COOLDOWN, spellGrade);
		}
		if (spellSecondaryGroupCooldown > 0) {
			Condition* condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_SPELLGROUPCOOLDOWN, spellSecondaryGroupCooldown / g_configManager().getFloat(RATE_SPELL_COOLDOWN), 0, false, secondaryGroup);
			player->addCondition(condition);
		}
	}
}

void Spell::postCastSpell(Player* player, bool finishedCast /*= true*/, bool payCost /*= true*/) const {
	if (finishedCast) {
		if (!player->hasFlag(PlayerFlags_t::HasNoExhaustion)) {
			applyCooldownConditions(player);
		}

		if (aggressive) {
			player->addInFightTicks();
		}
	}

	if (payCost) {
		Spell::postCastSpell(player, getManaCost(player), getSoulCost());
	}
}

void Spell::postCastSpell(Player* player, uint32_t manaCost, uint32_t soulCost) {
	if (manaCost > 0) {
		player->addManaSpent(manaCost);
		player->changeMana(-static_cast<int32_t>(manaCost));
	}

	if (!player->hasFlag(PlayerFlags_t::HasInfiniteSoul)) {
		if (soulCost > 0) {
			player->changeSoul(-static_cast<int32_t>(soulCost));
		}
	}
}

uint32_t Spell::getManaCost(const Player* player) const {
	if (mana != 0) {
		WheelOfDestinySpellGrade_t spellGrade = player->getWheelOfDestinySpellUpgrade(getName());
		if (getWheelOfDestinyUpgraded() && spellGrade > 0) {
			if (getWheelOfDestinyBoost(WHEEL_OF_DESTINY_SPELL_BOOST_MANA, spellGrade) >= mana) {
				return 0;
			} else {
				return (mana - getWheelOfDestinyBoost(WHEEL_OF_DESTINY_SPELL_BOOST_MANA, spellGrade));
			}
		}
		return mana;
	}

	if (manaPercent != 0) {
		uint32_t maxMana = player->getMaxMana();
		uint32_t manaCost = (maxMana * manaPercent) / 100;
		WheelOfDestinySpellGrade_t spellGrade = player->getWheelOfDestinySpellUpgrade(getName());
		if (getWheelOfDestinyUpgraded() && spellGrade > 0) {
			if (getWheelOfDestinyBoost(WHEEL_OF_DESTINY_SPELL_BOOST_MANA, spellGrade) >= manaCost) {
				return 0;
			} else {
				return (manaCost - getWheelOfDestinyBoost(WHEEL_OF_DESTINY_SPELL_BOOST_MANA, spellGrade));
			}
		}
		return manaCost;
	}

	return 0;
}

bool InstantSpell::playerCastInstant(Player* player, std::string &param) {
	if (!playerSpellCheck(player)) {
		return false;
	}

	LuaVariant var;
	var.instantName = getName();
	Player* playerTarget = nullptr;

	if (selfTarget) {
		var.type = VARIANT_NUMBER;
		var.number = player->getID();
	} else if (needTarget || casterTargetOrDirection) {
		Creature* target = nullptr;
		bool useDirection = false;

		if (hasParam) {
			ReturnValue ret = g_game().getPlayerByNameWildcard(param, playerTarget);

			if (playerTarget && playerTarget->isAccessPlayer() && !player->isAccessPlayer()) {
				playerTarget = nullptr;
			}

			target = playerTarget;
			if (!target || target->isRemoved() || target->getHealth() <= 0) {
				if (!casterTargetOrDirection) {
					applyCooldownConditions(player);

					player->sendCancelMessage(ret);
					g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
					return false;
				}

				useDirection = true;
			}

			if (playerTarget) {
				param = playerTarget->getName();
			}
		} else {
			target = player->getAttackedCreature();
			if (!target || target->isRemoved() || target->getHealth() <= 0) {
				if (!casterTargetOrDirection) {
					player->sendCancelMessage(RETURNVALUE_YOUCANONLYUSEITONCREATURES);
					g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
					return false;
				}

				useDirection = true;
			}
		}

		if (!useDirection) {
			if (!canThrowSpell(player, target)) {
				player->sendCancelMessage(RETURNVALUE_CREATUREISNOTREACHABLE);
				g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
				return false;
			}

			var.type = VARIANT_NUMBER;
			var.number = target->getID();
		} else {
			var.type = VARIANT_POSITION;
			var.pos = Spells::getCasterPosition(player, player->getDirection());

			if (!playerInstantSpellCheck(player, var.pos)) {
				return false;
			}
		}
	} else if (hasParam) {
		var.type = VARIANT_STRING;

		if (getHasPlayerNameParam()) {
			ReturnValue ret = g_game().getPlayerByNameWildcard(param, playerTarget);

			if (ret != RETURNVALUE_NOERROR) {
				applyCooldownConditions(player);

				player->sendCancelMessage(ret);
				g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
				return false;
			}

			if (playerTarget && (!playerTarget->isAccessPlayer() || player->isAccessPlayer())) {
				param = playerTarget->getName();
			}
		}

		var.text = param;
	} else {
		var.type = VARIANT_POSITION;

		if (needDirection) {
			var.pos = Spells::getCasterPosition(player, player->getDirection());
		} else {
			var.pos = player->getPosition();
		}

		if (!playerInstantSpellCheck(player, var.pos)) {
			return false;
		}
	}

	if (!allowOnSelf && playerTarget && playerTarget->getName() == player->getName()) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return false;
	}

	auto worldType = g_game().getWorldType();
	if (pzLocked && (worldType == WORLD_TYPE_PVP || worldType == WORLD_TYPE_PVP_ENFORCED)) {
		player->addInFightTicks(true);
	}

	bool result = executeCastSpell(player, var);
	if (result) {
		postCastSpell(player);
	}

	return result;
}

bool InstantSpell::canThrowSpell(const Creature* creature, const Creature* target) const {
	const Position &fromPos = creature->getPosition();
	const Position &toPos = target->getPosition();
	if (fromPos.z != toPos.z || (range == -1 && !g_game().canThrowObjectTo(fromPos, toPos, checkLineOfSight)) || (range != -1 && !g_game().canThrowObjectTo(fromPos, toPos, checkLineOfSight, range, range))) {
		return false;
	}
	return true;
}

bool InstantSpell::castSpell(Creature* creature) {
	LuaVariant var;
	var.instantName = getName();

	if (casterTargetOrDirection) {
		Creature* target = creature->getAttackedCreature();
		if (target && target->getHealth() > 0) {
			if (!canThrowSpell(creature, target)) {
				return false;
			}

			var.type = VARIANT_NUMBER;
			var.number = target->getID();
			var.instantName = getName();
			return executeCastSpell(creature, var);
		}

		return false;
	} else if (needDirection) {
		var.type = VARIANT_POSITION;
		var.pos = Spells::getCasterPosition(creature, creature->getDirection());
	} else {
		var.type = VARIANT_POSITION;
		var.pos = creature->getPosition();
	}

	return executeCastSpell(creature, var);
}

bool InstantSpell::castSpell(Creature* creature, Creature* target) {
	if (needTarget) {
		LuaVariant var;
		var.type = VARIANT_NUMBER;
		var.number = target->getID();
		return executeCastSpell(creature, var);
	} else {
		return castSpell(creature);
	}
}

bool InstantSpell::executeCastSpell(Creature* creature, const LuaVariant &var) const {
	// onCastSpell(creature, var)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[InstantSpell::executeCastSpell - Creature {} words {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 creature->getName(), getWords());
		return false;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushVariant(L, var);

	return getScriptInterface()->callFunction(2);
}

bool InstantSpell::canCast(const Player* player) const {
	if (player->hasFlag(PlayerFlags_t::CannotUseSpells)) {
		return false;
	}

	if (player->hasFlag(PlayerFlags_t::IgnoreSpellCheck)) {
		return true;
	}

	if (getNeedLearn()) {
		if (player->hasLearnedInstantSpell(getName())) {
			return true;
		}
	} else {
		if (vocSpellMap.empty() || vocSpellMap.contains(player->getVocationId())) {
			return true;
		}
	}

	return false;
}

ReturnValue RuneSpell::canExecuteAction(const Player* player, const Position &toPos) {
	if (player->hasFlag(PlayerFlags_t::CannotUseSpells)) {
		return RETURNVALUE_CANNOTUSETHISOBJECT;
	}

	ReturnValue ret = Action::canExecuteAction(player, toPos);
	if (ret != RETURNVALUE_NOERROR) {
		return ret;
	}

	if (toPos.x == 0xFFFF) {
		if (needTarget) {
			return RETURNVALUE_CANONLYUSETHISRUNEONCREATURES;
		} else if (!selfTarget) {
			return RETURNVALUE_NOTENOUGHROOM;
		}
	}

	return RETURNVALUE_NOERROR;
}

bool RuneSpell::executeUse(Player* player, Item* item, const Position &, Thing* target, const Position &toPosition, bool isHotkey) {
	if (!playerRuneSpellCheck(player, toPosition)) {
		return false;
	}

	// If script not loaded correctly, return
	if (!isLoadedCallback()) {
		return false;
	}

	LuaVariant var;
	var.runeName = getName();

	if (needTarget) {
		var.type = VARIANT_NUMBER;

		if (target == nullptr) {
			const Tile* toTile = g_game().map.getTile(toPosition);
			if (toTile) {
				const Creature* visibleCreature = toTile->getBottomVisibleCreature(player);
				if (visibleCreature) {
					var.number = visibleCreature->getID();
				}
			}
		} else {
			var.number = target->getCreature()->getID();
		}
	} else {
		var.type = VARIANT_POSITION;
		var.pos = toPosition;
	}

	if (!internalCastSpell(player, var, isHotkey)) {
		return false;
	}

	postCastSpell(player);
	if (hasCharges && item && g_configManager().getBoolean(REMOVE_RUNE_CHARGES)) {
		int32_t newCount = std::max<int32_t>(0, item->getItemCount() - 1);
		g_game().transformItem(item, item->getID(), newCount);
		player->updateSupplyTracker(item);
	}

	auto worldType = g_game().getWorldType();
	if (pzLocked && (worldType == WORLD_TYPE_PVP || worldType == WORLD_TYPE_PVP_ENFORCED)) {
		player->addInFightTicks(true);
	}

	return true;
}

bool RuneSpell::castSpell(Creature* creature) {
	LuaVariant var;
	var.type = VARIANT_NUMBER;
	var.number = creature->getID();
	var.runeName = getName();
	return internalCastSpell(creature, var, false);
}

bool RuneSpell::castSpell(Creature* creature, Creature* target) {
	LuaVariant var;
	var.type = VARIANT_NUMBER;
	var.number = target->getID();
	var.runeName = getName();
	return internalCastSpell(creature, var, false);
}

bool RuneSpell::internalCastSpell(Creature* creature, const LuaVariant &var, bool isHotkey) {
	bool result;
	if (isLoadedCallback()) {
		result = executeCastSpell(creature, var, isHotkey);
	} else {
		result = false;
	}
	return result;
}

bool RuneSpell::executeCastSpell(Creature* creature, const LuaVariant &var, bool isHotkey) const {
	// onCastSpell(creature, var, isHotkey)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[RuneSpell::executeCastSpell - Creature {} runeId {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 creature->getName(), getRuneItemId());
		return false;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushVariant(L, var);

	LuaScriptInterface::pushBoolean(L, isHotkey);

	return getScriptInterface()->callFunction(3);
}
