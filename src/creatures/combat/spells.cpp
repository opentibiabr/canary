/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/combat/spells.hpp"

#include "config/configmanager.hpp"
#include "creatures/combat/combat.hpp"
#include "creatures/combat/condition.hpp"
#include "creatures/players/player.hpp"
#include "creatures/players/wheel/player_wheel.hpp"
#include "creatures/players/wheel/wheel_definitions.hpp"
#include "enums/account_group_type.hpp"
#include "enums/account_type.hpp"
#include "game/game.hpp"
#include "lua/global/lua_variant.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "lua/scripts/scripts.hpp"
#include "lib/di/container.hpp"

Spells::Spells() = default;
Spells::~Spells() = default;

TalkActionResult_t Spells::playerSaySpell(const std::shared_ptr<Player> &player, std::string &words) {
	auto maxOnline = g_configManager().getNumber(MAX_PLAYERS_PER_ACCOUNT);
	const auto &tile = player->getTile();
	if (maxOnline > 1 && player->getAccountType() < ACCOUNT_TYPE_GAMEMASTER && tile && !tile->hasFlag(TILESTATE_PROTECTIONZONE)) {
		auto maxOutsizePZ = g_configManager().getNumber(MAX_PLAYERS_OUTSIDE_PZ_PER_ACCOUNT);
		auto accountPlayers = g_game().getPlayersByAccount(player->getAccount());
		int countOutsizePZ = 0;
		for (const auto &accountPlayer : accountPlayers) {
			if (accountPlayer == player || accountPlayer->isOffline()) {
				continue;
			}
			if (accountPlayer->getTile() && !accountPlayer->getTile()->hasFlag(TILESTATE_PROTECTIONZONE)) {
				++countOutsizePZ;
			}
		}
		if (countOutsizePZ >= maxOutsizePZ) {
			player->sendTextMessage(MESSAGE_FAILURE, fmt::format("You cannot cast spells while you have {} character(s) outside of a protection zone.", maxOutsizePZ));
			return TALKACTION_FAILED;
		}
	}
	std::string str_words = words;

	if (player->hasCondition(CONDITION_FEARED)) {
		player->sendTextMessage(MESSAGE_FAILURE, "You are feared.");
		return TALKACTION_FAILED;
	}

	// strip trailing spaces
	trimString(str_words);

	const auto &instantSpell = getInstantSpell(str_words);
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

void Spells::setInstantSpell(const std::string &word, const std::shared_ptr<InstantSpell> &instant) {
	instants.try_emplace(word, instant);
}

bool Spells::registerInstantLuaEvent(const std::shared_ptr<InstantSpell> &instant) {
	if (instant) {
		// If the spell not have the "spell:words()" return a error message
		const std::string &instantName = instant->getName();
		if (instant->getWords().empty()) {
			g_logger().error("[Spells::registerInstantLuaEvent] - Missing register word for spell with name {}", instantName);
			return false;
		}

		const std::string &words = instant->getWords();
		// Checks if there is any spell registered with the same name
		if (hasInstantSpell(words)) {
			g_logger().warn("[Spells::registerInstantLuaEvent] - "
			                "Duplicate registered instant spell with words: {}, on spell with name: {}",
			                words, instantName);
			return false;
		}
		// Register spell word in the map
		setInstantSpell(words, instant);
		return true;
	}

	return false;
}

bool Spells::registerRuneLuaEvent(const std::shared_ptr<RuneSpell> &rune) {
	if (rune) {
		uint16_t id = rune->getRuneItemId();
		const auto &[iter, inserted] = runes.try_emplace(rune->getRuneItemId(), rune);
		if (!inserted) {
			g_logger().warn(
				"[{}] duplicate registered rune with id: {}, for script: {}",
				__FUNCTION__,
				id,
				rune->getRuneSpellScriptInterface()->getLoadingScriptName()
			);
		}
		return inserted;
	}

	return false;
}

std::list<uint16_t> Spells::getSpellsByVocation(uint16_t vocationId) {
	std::list<uint16_t> spellsList;
	VocSpellMap vocSpells;
	std::map<uint16_t, bool>::const_iterator vocSpellsIt;

	for (const auto &it : instants) {
		vocSpells = it.second->getVocMap();
		vocSpellsIt = vocSpells.find(vocationId);

		if (vocSpellsIt != vocSpells.end()
		    && vocSpellsIt->second) {
			spellsList.push_back(it.second->getSpellId());
		}
	}

	return spellsList;
}

const std::map<std::string, std::shared_ptr<InstantSpell>> &Spells::getInstantSpells() const {
	return instants;
}

Spells &Spells::getInstance() {
	return inject<Spells>();
}

std::shared_ptr<Spell> Spells::getSpellByName(const std::string &name) {
	std::shared_ptr<Spell> spell = getRuneSpellByName(name);
	if (!spell) {
		spell = getInstantSpellByName(name);
	}
	return spell;
}

std::shared_ptr<RuneSpell> Spells::getRuneSpell(uint16_t id) {
	auto it = runes.find(id);
	if (it == runes.end()) {
		for (auto &rune : runes) {
			if (rune.second->getRuneItemId() == id) {
				return rune.second;
			}
		}
		return nullptr;
	}
	return it->second;
}

std::shared_ptr<RuneSpell> Spells::getRuneSpellByName(const std::string &name) {
	for (auto &it : runes) {
		if (strcasecmp(it.second->getName().c_str(), name.c_str()) == 0) {
			return it.second;
		}
	}
	return nullptr;
}

std::shared_ptr<InstantSpell> Spells::getInstantSpell(const std::string &words) {
	std::shared_ptr<InstantSpell> result = nullptr;

	for (auto &it : instants) {
		const std::string &instantSpellWords = it.second->getWords();
		size_t spellLen = instantSpellWords.length();
		if (strncasecmp(instantSpellWords.c_str(), words.c_str(), spellLen) == 0) {
			if (!result || spellLen > result->getWords().length()) {
				result = it.second;
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

std::shared_ptr<InstantSpell> Spells::getInstantSpellById(uint16_t spellId) {
	for (auto &it : instants) {
		if (it.second->getSpellId() == spellId) {
			return it.second;
		}
	}
	return nullptr;
}

std::shared_ptr<InstantSpell> Spells::getInstantSpellByName(const std::string &name) {
	for (auto &it : instants) {
		if (strcasecmp(it.second->getName().c_str(), name.c_str()) == 0) {
			return it.second;
		}
	}
	return nullptr;
}

Position Spells::getCasterPosition(const std::shared_ptr<Creature> &creature, Direction dir) {
	return getNextPosition(dir, creature->getPosition());
}

LuaScriptInterface* BaseSpell::getScriptInterface() const {
	return &g_scripts().getScriptInterface();
}

bool BaseSpell::loadScriptId() {
	LuaScriptInterface &luaInterface = g_scripts().getScriptInterface();
	m_spellScriptId = luaInterface.getEvent();
	if (m_spellScriptId == -1) {
		g_logger().error("[MoveEvent::loadScriptId] Failed to load event. Script name: '{}', Module: '{}'", luaInterface.getLoadingScriptName(), luaInterface.getInterfaceName());
		return false;
	}

	return true;
}

int32_t BaseSpell::getScriptId() const {
	return m_spellScriptId;
}

void BaseSpell::setScriptId(int32_t newScriptId) {
	m_spellScriptId = newScriptId;
}

bool BaseSpell::isLoadedScriptId() const {
	return m_spellScriptId != 0;
}

CombatSpell::CombatSpell(const std::shared_ptr<Combat> &newCombat, bool newNeedTarget, bool newNeedDirection) :
	m_combat(newCombat),
	needDirection(newNeedDirection),
	needTarget(newNeedTarget) {
}

std::shared_ptr<Combat> CombatSpell::getCombat() const {
	return m_combat;
}

bool CombatSpell::castSpell(const std::shared_ptr<Creature> &creature) {
	if (isLoadedScriptId()) {
		LuaVariant var;
		var.type = VARIANT_POSITION;

		if (creature) {
			if (needDirection) {
				var.pos = Spells::getCasterPosition(creature, creature->getDirection());
			} else {
				var.pos = creature->getPosition();
			}
		}

		return executeCastSpell(creature, var);
	}

	Position pos;
	if (creature) {
		if (needDirection) {
			pos = Spells::getCasterPosition(creature, creature->getDirection());
		} else {
			pos = creature->getPosition();
		}
	}

	const auto &combat = getCombat();
	if (!combat) {
		return false;
	}

	if (soundCastEffect != SoundEffect_t::SILENCE) {
		combat->setParam(COMBAT_PARAM_CASTSOUND, static_cast<uint32_t>(soundCastEffect));
	}

	if (soundImpactEffect != SoundEffect_t::SILENCE) {
		combat->setParam(COMBAT_PARAM_IMPACTSOUND, static_cast<uint32_t>(soundImpactEffect));
	}

	combat->doCombat(creature, pos);
	return true;
}

bool CombatSpell::castSpell(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &target) {
	const auto &combat = getCombat();
	if (!combat) {
		return false;
	}

	if (isLoadedScriptId()) {
		LuaVariant var;
		if (combat->hasArea()) {
			var.type = VARIANT_POSITION;

			if (needTarget && target) {
				var.pos = target->getPosition();
			} else if (needDirection && creature) {
				var.pos = Spells::getCasterPosition(creature, creature->getDirection());
			} else {
				if (creature) {
					var.pos = creature->getPosition();
				}
			}
		} else {
			var.type = VARIANT_NUMBER;
			var.number = target->getID();
		}

		return executeCastSpell(creature, var);
	}

	if (soundCastEffect != SoundEffect_t::SILENCE) {
		combat->setParam(COMBAT_PARAM_CASTSOUND, static_cast<uint32_t>(soundCastEffect));
	}

	if (soundImpactEffect != SoundEffect_t::SILENCE) {
		combat->setParam(COMBAT_PARAM_IMPACTSOUND, static_cast<uint32_t>(soundImpactEffect));
	}

	if (combat->hasArea()) {
		if (needTarget && target) {
			combat->doCombat(creature, target->getPosition());
		} else {
			return castSpell(creature);
		}
	} else {
		combat->doCombat(creature, target);
	}
	return true;
}

bool CombatSpell::executeCastSpell(const std::shared_ptr<Creature> &creature, const LuaVariant &var) const {
	// onCastSpell(creature, var)
	if (!LuaEnvironment::reserveScriptEnv()) {
		g_logger().error("[CombatSpell::executeCastSpell - Creature {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 creature->getName());
		return false;
	}

	ScriptEnvironment* env = LuaEnvironment::getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushVariant(L, var);

	return getScriptInterface()->callFunction(2);
}

Spell::Spell() = default;

bool Spell::playerSpellCheck(const std::shared_ptr<Player> &player) const {
	if (player->hasFlag(PlayerFlags_t::CannotUseSpells)) {
		return false;
	}

	if (player->hasFlag(PlayerFlags_t::IgnoreSpellCheck)) {
		return true;
	}

	if (player->hasCondition(CONDITION_FEARED)) {
		player->sendTextMessage(MESSAGE_FAILURE, "You are feared.");
		return false;
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

	if (aggressive && !player->hasFlag(PlayerFlags_t::IgnoreProtectionZone) && player->getZoneType() == ZONE_PROTECTION) {
		player->sendCancelMessage(RETURNVALUE_ACTIONNOTPERMITTEDINPROTECTIONZONE);
		return false;
	}

	if (player->hasCondition(CONDITION_SPELLGROUPCOOLDOWN, group) || player->hasCondition(CONDITION_SPELLCOOLDOWN, m_spellId) || (secondaryGroup != SPELLGROUP_NONE && player->hasCondition(CONDITION_SPELLGROUPCOOLDOWN, secondaryGroup))) {
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
	} else if (!vocSpellMap.empty() && !vocSpellMap.contains(player->getVocationId()) && player->getGroup()->id < GROUP_TYPE_GAMEMASTER) {
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

bool Spell::playerInstantSpellCheck(const std::shared_ptr<Player> &player, const Position &toPos) const {
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

	const auto &tile = g_game().map.getOrCreateTile(toPos);

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

bool Spell::playerRuneSpellCheck(const std::shared_ptr<Player> &player, const Position &toPos) const {
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

	const auto &tile = g_game().map.getTile(toPos);
	if (!tile) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return false;
	}

	if (range != -1 && !g_game().canThrowObjectTo(playerPos, toPos, SightLine_CheckSightLineAndFloor, range, range)) {
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

	const auto &topVisibleCreature = tile->getBottomVisibleCreature(player);
	if ((blockingCreature && topVisibleCreature) || (blockingSolid && tile->hasFlag(TILESTATE_BLOCKSOLID) && !topVisibleCreature)) {
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
		const auto &targetPlayer = topVisibleCreature->getPlayer();
		if (targetPlayer && targetPlayer != player && player->getSkullClient(targetPlayer) == SKULL_NONE && !Combat::isInPvpZone(player, targetPlayer)) {
			player->sendCancelMessage(RETURNVALUE_TURNSECUREMODETOATTACKUNMARKEDPLAYERS);
			g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
			return false;
		}
	}
	return true;
}

// Wheel of destiny - Get:
bool Spell::getWheelOfDestinyUpgraded() const {
	return whellOfDestinyUpgraded;
}

int32_t Spell::getWheelOfDestinyBoost(WheelSpellBoost_t boost, WheelSpellGrade_t grade) const {
	int32_t value = 0;
	try {
		if (grade >= WheelSpellGrade_t::REGULAR) {
			value += wheelOfDestinyRegularBoost.at(static_cast<uint8_t>(boost));
		}
		if (grade >= WheelSpellGrade_t::UPGRADED) {
			value += wheelOfDestinyUpgradedBoost.at(static_cast<uint8_t>(boost));
		}
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}] invalid grade value, error code: {}", __FUNCTION__, e.what());
	}
	return value;
}

// Wheel of destiny - Set:
void Spell::setWheelOfDestinyUpgraded(bool value) {
	whellOfDestinyUpgraded = value;
}

void Spell::setWheelOfDestinyBoost(WheelSpellBoost_t boost, WheelSpellGrade_t grade, int32_t value) {
	try {
		if (grade == WheelSpellGrade_t::REGULAR) {
			wheelOfDestinyRegularBoost.at(static_cast<uint8_t>(boost)) = value;
		} else if (grade == WheelSpellGrade_t::UPGRADED) {
			wheelOfDestinyUpgradedBoost.at(static_cast<uint8_t>(boost)) = value;
		}
	} catch (const std::out_of_range &e) {
		g_logger().error("[{}] invalid grade value, error code: {}", __FUNCTION__, e.what());
	}
}

const std::string &Spell::getWords() const {
	return m_words;
}

void Spell::setWords(std::string_view newWord) {
	m_words = newWord.data();
}

const std::string &Spell::getSeparator() const {
	return m_separator;
}

void Spell::setSeparator(std::string_view newSeparator) {
	m_separator = newSeparator.data();
}

void Spell::getCombatDataAugment(const std::shared_ptr<Player> &player, CombatDamage &damage) const {
	if (!(damage.instantSpellName).empty()) {
		const auto equippedAugmentItems = player->getEquippedAugmentItems();
		for (const auto &item : equippedAugmentItems) {
			const auto &augments = item->getAugmentsBySpellName(damage.instantSpellName);
			for (auto &augment : augments) {
				if (augment->value == 0) {
					continue;
				}
				if (
					augment->type == Augment_t::IncreasedDamage || augment->type == Augment_t::PowerfulImpact || augment->type == Augment_t::StrongImpact || augment->type == Augment_t::Base
				) {
					const float augmentPercent = augment->value / 100.0;
					damage.primary.value += static_cast<int32_t>(damage.primary.value * augmentPercent);
					damage.secondary.value += static_cast<int32_t>(damage.secondary.value * augmentPercent);
				} else if (augment->type != Augment_t::Cooldown) {
					const int32_t augmentValue = augment->value * 100;
					damage.lifeLeech += augment->type == Augment_t::LifeLeech ? augmentValue : 0;
					damage.manaLeech += augment->type == Augment_t::ManaLeech ? augmentValue : 0;
					damage.criticalDamage += augment->type == Augment_t::CriticalExtraDamage ? augmentValue : 0;
				}
			}
		}
	}
};

int32_t Spell::calculateAugmentSpellCooldownReduction(const std::shared_ptr<Player> &player) const {
	int32_t spellCooldown = 0;
	const auto &equippedAugmentItems = player->getEquippedAugmentItemsByType(Augment_t::Cooldown);
	for (const auto &item : equippedAugmentItems) {
		const auto augments = item->getAugmentsBySpellNameAndType(getName(), Augment_t::Cooldown);
		for (const auto &augment : augments) {
			spellCooldown += augment->value;
		}
	}

	return spellCooldown;
}

void Spell::applyCooldownConditions(const std::shared_ptr<Player> &player) const {
	WheelSpellGrade_t spellGrade = player->wheel()->getSpellUpgrade(getName());
	bool isUpgraded = getWheelOfDestinyUpgraded() && static_cast<uint8_t>(spellGrade) > 0;
	// Safety check to prevent division by zero
	auto rateCooldown = g_configManager().getFloat(RATE_SPELL_COOLDOWN);
	if (std::abs(rateCooldown) < std::numeric_limits<float>::epsilon()) {
		rateCooldown = 0.1; // Safe minimum value
	}

	if (cooldown > 0) {
		int32_t spellCooldown = cooldown;
		if (isUpgraded) {
			spellCooldown -= getWheelOfDestinyBoost(WheelSpellBoost_t::COOLDOWN, spellGrade);
		}
		int32_t augmentCooldownReduction = calculateAugmentSpellCooldownReduction(player);
		g_logger().debug("[{}] spell name: {}, spellCooldown: {}, bonus: {}, augment {}", __FUNCTION__, name, spellCooldown, player->wheel()->getSpellBonus(name, WheelSpellBoost_t::COOLDOWN), augmentCooldownReduction);
		spellCooldown -= player->wheel()->getSpellBonus(name, WheelSpellBoost_t::COOLDOWN);
		spellCooldown -= augmentCooldownReduction;
		const int32_t halfBaseCooldown = cooldown / 2;
		spellCooldown = halfBaseCooldown > spellCooldown ? halfBaseCooldown : spellCooldown; // The cooldown should never be reduced less than half (50%) of its base cooldown
		if (spellCooldown > 0) {
			player->wheel()->handleTwinBurstsCooldown(player, name, spellCooldown, rateCooldown);
			const auto &condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_SPELLCOOLDOWN, spellCooldown / rateCooldown, 0, false, m_spellId);
			player->addCondition(condition);
		}
	}

	if (groupCooldown > 0) {
		int32_t spellGroupCooldown = groupCooldown;
		if (isUpgraded) {
			spellGroupCooldown -= getWheelOfDestinyBoost(WheelSpellBoost_t::GROUP_COOLDOWN, spellGrade);
		}
		if (spellGroupCooldown > 0) {
			const auto &condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_SPELLGROUPCOOLDOWN, spellGroupCooldown / rateCooldown, 0, false, group);
			player->addCondition(condition);
		}
	}

	if (secondaryGroupCooldown > 0) {
		int32_t spellSecondaryGroupCooldown = secondaryGroupCooldown;
		if (isUpgraded) {
			spellSecondaryGroupCooldown -= getWheelOfDestinyBoost(WheelSpellBoost_t::SECONDARY_GROUP_COOLDOWN, spellGrade);
		}
		spellSecondaryGroupCooldown -= player->wheel()->getSpellBonus(name, WheelSpellBoost_t::SECONDARY_GROUP_COOLDOWN);
		if (spellSecondaryGroupCooldown > 0) {
			player->wheel()->handleBeamMasteryCooldown(player, name, spellSecondaryGroupCooldown, rateCooldown);
			const auto &condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_SPELLGROUPCOOLDOWN, spellSecondaryGroupCooldown / rateCooldown, 0, false, secondaryGroup);
			player->addCondition(condition);
		}
	}
}

const std::string &Spell::getName() const {
	return name;
}

void Spell::setName(std::string n) {
	name = std::move(n);
}

uint16_t Spell::getSpellId() const {
	return m_spellId;
}

void Spell::setSpellId(uint16_t id) {
	m_spellId = id;
}

void Spell::postCastSpell(const std::shared_ptr<Player> &player, bool finishedCast /*= true*/, bool payCost /*= true*/) const {
	if (finishedCast) {
		if (!player->hasFlag(PlayerFlags_t::HasNoExhaustion)) {
			applyCooldownConditions(player);
		}

		if (aggressive) {
			player->addInFightTicks();
			player->updateLastAggressiveAction();
		}

		if (player && soundCastEffect != SoundEffect_t::SILENCE) {
			g_game().sendDoubleSoundEffect(player->getPosition(), soundCastEffect, soundImpactEffect, player);
		}
	}

	if (payCost) {
		postCastSpell(player, getManaCost(player), getSoulCost());
	}
}

void Spell::postCastSpell(const std::shared_ptr<Player> &player, uint32_t manaCost, uint32_t soulCost) {
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

bool Spell::isLearnable() const {
	return learnable;
}

uint32_t Spell::getManaCost(const std::shared_ptr<Player> &player) const {
	WheelSpellGrade_t spellGrade = player->wheel()->getSpellUpgrade(getName());
	uint32_t manaRedution = 0;
	if (getWheelOfDestinyUpgraded() && static_cast<uint8_t>(spellGrade) > 0) {
		manaRedution += getWheelOfDestinyBoost(WheelSpellBoost_t::MANA, spellGrade);
	}
	manaRedution += player->wheel()->getSpellBonus(name, WheelSpellBoost_t::MANA);

	if (mana != 0) {
		if (manaRedution > mana) {
			return 0;
		}
		return mana - manaRedution;
	}

	if (manaPercent != 0) {
		uint32_t maxMana = player->getMaxMana();
		uint32_t manaCost = (maxMana * manaPercent) / 100;
		if (manaRedution > manaCost) {
			return 0;
		}
		return manaCost;
	}

	return 0;
}

uint32_t Spell::getSoulCost() const {
	return soul;
}

void Spell::setSoulCost(uint32_t s) {
	soul = s;
}

uint32_t Spell::getLevel() const {
	return level;
}

void Spell::setLevel(uint32_t lvl) {
	level = lvl;
}

uint32_t Spell::getMagicLevel() const {
	return magLevel;
}

void Spell::setMagicLevel(uint32_t lvl) {
	magLevel = lvl;
}

uint32_t Spell::getMana() const {
	return mana;
}

void Spell::setMana(uint32_t m) {
	mana = m;
}

uint32_t Spell::getManaPercent() const {
	return manaPercent;
}

void Spell::setManaPercent(uint32_t m) {
	manaPercent = m;
}

bool Spell::isPremium() const {
	return premium;
}

void Spell::setPremium(bool p) {
	premium = p;
}

bool Spell::isEnabled() const {
	return enabled;
}

void Spell::setEnabled(bool e) {
	enabled = e;
}

const VocSpellMap &Spell::getVocMap() const {
	return vocSpellMap;
}

void Spell::addVocMap(uint16_t vocationId, bool b) {
	if (vocationId == 0XFFFF) {
		g_logger().error("Vocation overflow for spell: {}", getName());
		return;
	}

	g_logger().trace("Adding spell: {} to voc id: {}", getName(), vocationId);
	vocSpellMap[vocationId] = b;
}

SpellGroup_t Spell::getGroup() {
	return group;
}

void Spell::setGroup(SpellGroup_t g) {
	group = g;
}

SpellGroup_t Spell::getSecondaryGroup() {
	return secondaryGroup;
}

void Spell::setSecondaryGroup(SpellGroup_t g) {
	secondaryGroup = g;
}

uint32_t Spell::getCooldown() const {
	return cooldown;
}

void Spell::setCooldown(uint32_t cd) {
	cooldown = cd;
}

uint32_t Spell::getSecondaryCooldown() const {
	return secondaryGroupCooldown;
}

void Spell::setSecondaryCooldown(uint32_t cd) {
	secondaryGroupCooldown = cd;
}

uint32_t Spell::getGroupCooldown() const {
	return groupCooldown;
}

void Spell::setGroupCooldown(uint32_t cd) {
	groupCooldown = cd;
}

int32_t Spell::getRange() const {
	return range;
}

void Spell::setRange(int32_t r) {
	range = r;
}

bool Spell::getNeedTarget() const {
	return needTarget;
}

void Spell::setNeedTarget(bool n) {
	needTarget = n;
}

bool Spell::getNeedWeapon() const {
	return needWeapon;
}

void Spell::setNeedWeapon(bool n) {
	needWeapon = n;
}

bool Spell::getNeedLearn() const {
	return learnable;
}

void Spell::setNeedLearn(bool n) {
	learnable = n;
}

bool Spell::getSelfTarget() const {
	return selfTarget;
}

void Spell::setSelfTarget(bool s) {
	selfTarget = s;
}

bool Spell::getBlockingSolid() const {
	return blockingSolid;
}

void Spell::setBlockingSolid(bool b) {
	blockingSolid = b;
}

bool Spell::getBlockingCreature() const {
	return blockingCreature;
}

void Spell::setBlockingCreature(bool b) {
	blockingCreature = b;
}

bool Spell::getAggressive() const {
	return aggressive;
}

void Spell::setAggressive(bool a) {
	aggressive = a;
}

bool Spell::getAllowOnSelf() const {
	return allowOnSelf;
}

void Spell::setAllowOnSelf(bool s) {
	allowOnSelf = s;
}

bool Spell::getLockedPZ() const {
	return pzLocked;
}

void Spell::setLockedPZ(bool b) {
	pzLocked = b;
}

InstantSpell::InstantSpell() = default;

bool InstantSpell::playerCastInstant(const std::shared_ptr<Player> &player, std::string &param) const {
	if (!playerSpellCheck(player)) {
		return false;
	}

	LuaVariant var;
	var.instantName = getName();
	std::shared_ptr<Player> playerTarget = nullptr;

	if (selfTarget) {
		var.type = VARIANT_NUMBER;
		var.number = player->getID();
	} else if (needTarget || casterTargetOrDirection) {
		std::shared_ptr<Creature> target;
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
		player->updateLastAggressiveAction();
	}

	bool result = executeCastSpell(player, var);
	if (result) {
		postCastSpell(player);
	}

	return result;
}

bool InstantSpell::canThrowSpell(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &target) const {
	const Position &fromPos = creature->getPosition();
	const Position &toPos = target->getPosition();
	if (fromPos.z != toPos.z || (range == -1 && !g_game().canThrowObjectTo(fromPos, toPos, checkLineOfSight ? SightLine_CheckSightLineAndFloor : SightLine_NoCheck)) || (range != -1 && !g_game().canThrowObjectTo(fromPos, toPos, checkLineOfSight ? SightLine_CheckSightLineAndFloor : SightLine_NoCheck, range, range))) {
		return false;
	}
	return true;
}

bool InstantSpell::castSpell(const std::shared_ptr<Creature> &creature) {
	LuaVariant var;
	var.instantName = getName();

	if (casterTargetOrDirection) {
		const auto &target = creature->getAttackedCreature();
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

bool InstantSpell::castSpell(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &target) {
	if (needTarget) {
		LuaVariant var;
		var.type = VARIANT_NUMBER;
		var.number = target->getID();
		return executeCastSpell(creature, var);
	}
	return castSpell(creature);
}

bool InstantSpell::executeCastSpell(const std::shared_ptr<Creature> &creature, const LuaVariant &var) const {
	// onCastSpell(creature, var)
	if (!LuaEnvironment::reserveScriptEnv()) {
		g_logger().error("[InstantSpell::executeCastSpell - Creature {} words {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 creature->getName(), getWords());
		return false;
	}

	ScriptEnvironment* env = LuaEnvironment::getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushVariant(L, var);

	return getScriptInterface()->callFunction(2);
}

bool InstantSpell::isInstant() const {
	return true;
}

bool InstantSpell::getHasParam() const {
	return hasParam;
}

void InstantSpell::setHasParam(bool p) {
	hasParam = p;
}

bool InstantSpell::getHasPlayerNameParam() const {
	return hasPlayerNameParam;
}

void InstantSpell::setHasPlayerNameParam(bool p) {
	hasPlayerNameParam = p;
}

bool InstantSpell::getNeedDirection() const {
	return needDirection;
}

void InstantSpell::setNeedDirection(bool n) {
	needDirection = n;
}

bool InstantSpell::getNeedCasterTargetOrDirection() const {
	return casterTargetOrDirection;
}

void InstantSpell::setNeedCasterTargetOrDirection(bool d) {
	casterTargetOrDirection = d;
}

bool InstantSpell::getBlockWalls() const {
	return checkLineOfSight;
}

void InstantSpell::setBlockWalls(bool w) {
	checkLineOfSight = w;
}

bool InstantSpell::canCast(const std::shared_ptr<Player> &player) const {
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

LuaScriptInterface* RuneSpell::getRuneSpellScriptInterface() const {
	return &g_scripts().getScriptInterface();
}

bool RuneSpell::loadRuneSpellScriptId() {
	LuaScriptInterface &luaInterface = g_scripts().getScriptInterface();
	m_runeSpellScriptId = luaInterface.getEvent();
	if (m_runeSpellScriptId == -1) {
		g_logger().error("[MoveEvent::loadScriptId] Failed to load event. Script name: '{}', Module: '{}'", luaInterface.getLoadingScriptName(), luaInterface.getInterfaceName());
		return false;
	}

	return true;
}

int32_t RuneSpell::getRuneSpellScriptId() const {
	return m_runeSpellScriptId;
}

void RuneSpell::setRuneSpellScriptId(int32_t newScriptId) {
	m_runeSpellScriptId = newScriptId;
}

bool RuneSpell::isRuneSpellLoadedScriptId() const {
	return m_runeSpellScriptId != 0;
}

ReturnValue RuneSpell::canExecuteAction(const std::shared_ptr<Player> &player, const Position &toPos) {
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

bool RuneSpell::hasOwnErrorHandler() {
	return true;
}

std::shared_ptr<Thing> RuneSpell::getTarget(const std::shared_ptr<Player> &, const std::shared_ptr<Creature> &targetCreature, const Position &, uint8_t) const {
	return targetCreature;
}

bool RuneSpell::executeUse(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, const Position &, const std::shared_ptr<Thing> &target, const Position &toPosition, bool isHotkey) {
	if (!playerRuneSpellCheck(player, toPosition)) {
		return false;
	}

	// If script not loaded correctly, return
	if (!isRuneSpellLoadedScriptId()) {
		return false;
	}

	LuaVariant var;
	var.runeName = getName();

	if (needTarget) {
		var.type = VARIANT_NUMBER;

		if (target == nullptr) {
			const auto &toTile = g_game().map.getTile(toPosition);
			if (toTile) {
				const auto &visibleCreature = toTile->getBottomVisibleCreature(player);
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
		player->updateLastAggressiveAction();
	}

	return true;
}

bool RuneSpell::castSpell(const std::shared_ptr<Creature> &creature) {
	LuaVariant var;
	var.type = VARIANT_NUMBER;
	var.number = creature->getID();
	var.runeName = getName();
	return internalCastSpell(creature, var, false);
}

bool RuneSpell::castSpell(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &target) {
	LuaVariant var;
	var.type = VARIANT_NUMBER;
	var.number = target->getID();
	var.runeName = getName();
	return internalCastSpell(creature, var, false);
}

bool RuneSpell::internalCastSpell(const std::shared_ptr<Creature> &creature, const LuaVariant &var, bool isHotkey) const {
	bool result;
	if (isRuneSpellLoadedScriptId()) {
		result = executeCastSpell(creature, var, isHotkey);
	} else {
		result = false;
	}
	return result;
}

bool RuneSpell::executeCastSpell(const std::shared_ptr<Creature> &creature, const LuaVariant &var, bool isHotkey) const {
	// onCastSpell(creature, var, isHotkey)
	if (!LuaEnvironment::reserveScriptEnv()) {
		g_logger().error("[RuneSpell::executeCastSpell - Creature {} runeId {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 creature->getName(), getRuneItemId());
		return false;
	}

	ScriptEnvironment* env = LuaEnvironment::getScriptEnv();
	env->setScriptId(getRuneSpellScriptId(), getRuneSpellScriptInterface());

	lua_State* L = getRuneSpellScriptInterface()->getLuaState();

	getRuneSpellScriptInterface()->pushFunction(getRuneSpellScriptId());

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushVariant(L, var);

	LuaScriptInterface::pushBoolean(L, isHotkey);

	return getRuneSpellScriptInterface()->callFunction(3);
}

bool RuneSpell::isInstant() const {
	return false;
}

uint16_t RuneSpell::getRuneItemId() const {
	return runeId;
}

void RuneSpell::setRuneItemId(uint16_t i) {
	runeId = i;
}

uint32_t RuneSpell::getCharges() const {
	return charges;
}

void RuneSpell::setCharges(uint32_t c) {
	if (c > 0) {
		hasCharges = true;
	}
	charges = c;
}
