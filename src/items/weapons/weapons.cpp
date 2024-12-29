/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "items/weapons/weapons.hpp"

#include "config/configmanager.hpp"
#include "creatures/combat/combat.hpp"
#include "game/game.hpp"
#include "lua/creature/events.hpp"
#include "creatures/players/vocations/vocation.hpp"
#include "lib/di/container.hpp"
#include "lua/scripts/scripts.hpp"
#include "lua/global/lua_variant.hpp"
#include "creatures/players/player.hpp"

Weapons::Weapons() = default;
Weapons::~Weapons() = default;

Weapons &Weapons::getInstance() {
	return inject<Weapons>();
}

WeaponShared_ptr Weapons::getWeapon(const std::shared_ptr<Item> &item) const {
	if (!item) {
		return nullptr;
	}

	const auto it = weapons.find(item->getID());
	if (it == weapons.end()) {
		return nullptr;
	}
	return it->second;
}

void Weapons::clear(bool isFromXML /*= false*/) {
	if (isFromXML) {
		int numRemoved = 0;
		for (auto it = weapons.begin(); it != weapons.end();) {
			if (it->second && it->second->isFromXML()) {
				g_logger().debug("Weapon with id '{}' is from XML and will be removed.", it->first);
				it = weapons.erase(it);
				++numRemoved;
			} else {
				++it;
			}
		}

		if (numRemoved > 0) {
			g_logger().debug("Removed '{}' Weapon from XML.", numRemoved);
		}

		return;
	}

	weapons.clear();
}

bool Weapons::registerLuaEvent(const WeaponShared_ptr &event, bool fromXML /*= false*/) {
	weapons[event->getID()] = event;
	if (fromXML) {
		event->setFromXML(fromXML);
	}
	return true;
}

// Monsters
int32_t Weapons::getMaxMeleeDamage(int32_t attackSkill, int32_t attackValue) {
	// Returns maximum melee attack damage, rounding up
	return static_cast<int32_t>(std::ceil((attackSkill * (attackValue * 0.05)) + (attackValue * 0.5)));
}

// Players
int32_t Weapons::getMaxWeaponDamage(uint32_t level, int32_t attackSkill, int32_t attackValue, float attackFactor, bool isMelee) {
	if (isMelee) {
		return static_cast<int32_t>(std::round((0.085 * attackFactor * attackValue * attackSkill) + (level / 5)));
	} else {
		return static_cast<int32_t>(std::round((0.09 * attackFactor * attackValue * attackSkill) + (level / 5)));
	}
}

Weapon::Weapon() = default;

LuaScriptInterface* Weapon::getScriptInterface() const {
	return &g_scripts().getScriptInterface();
}

bool Weapon::loadScriptId() {
	LuaScriptInterface &luaInterface = g_scripts().getScriptInterface();
	m_scriptId = luaInterface.getEvent();
	if (m_scriptId == -1) {
		g_logger().error("[MoveEvent::loadScriptId] Failed to load event. Script name: '{}', Module: '{}'", luaInterface.getLoadingScriptName(), luaInterface.getInterfaceName());
		return false;
	}

	return true;
}

int32_t Weapon::getScriptId() const {
	return m_scriptId;
}

void Weapon::setScriptId(int32_t newScriptId) {
	m_scriptId = newScriptId;
}

bool Weapon::isLoadedScriptId() const {
	return m_scriptId != 0;
}

void Weapon::configureWeapon(const ItemType &it) {
	id = it.id;
}

int32_t Weapon::playerWeaponCheck(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, uint8_t shootRange) const {
	const Position &playerPos = player->getPosition();
	const Position &targetPos = target->getPosition();
	if (playerPos.z != targetPos.z) {
		return 0;
	}

	if (std::max<uint32_t>(Position::getDistanceX(playerPos, targetPos), Position::getDistanceY(playerPos, targetPos)) > shootRange) {
		return 0;
	}

	if (!player->hasFlag(PlayerFlags_t::IgnoreWeaponCheck)) {
		if (!enabled) {
			return 0;
		}

		if (player->getMana() < getManaCost(player)) {
			return 0;
		}

		if (player->getHealth() < getHealthCost(player)) {
			return 0;
		}

		if (player->getSoul() < soul) {
			return 0;
		}

		if (isPremium() && !player->isPremium()) {
			return 0;
		}

		if (!vocWeaponMap.empty() && !vocWeaponMap.contains(player->getVocationId())) {
			return 0;
		}

		int32_t damageModifier = 100;
		if (player->getLevel() < getReqLevel()) {
			damageModifier = (isWieldedUnproperly() ? damageModifier / 2 : 0);
		}

		if (player->getMagicLevel() < getReqMagLv()) {
			damageModifier = (isWieldedUnproperly() ? damageModifier / 2 : 0);
		}
		return damageModifier;
	}

	return 100;
}

bool Weapon::useWeapon(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, const std::shared_ptr<Creature> &target) const {
	const int32_t damageModifier = playerWeaponCheck(player, target, item->getShootRange());
	if (damageModifier == 0) {
		return false;
	}

	internalUseWeapon(player, item, target, damageModifier);
	return true;
}

CombatDamage Weapon::getCombatDamage(CombatDamage combat, const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, int32_t damageModifier) const {
	// Local variables
	const uint32_t level = player->getLevel();
	const int16_t elementalAttack = getElementDamageValue();
	const int32_t weaponAttack = std::max<int32_t>(0, item->getAttack());
	const int32_t playerSkill = player->getWeaponSkill(item);
	const float attackFactor = player->getAttackFactor(); // full atk, balanced or full defense

	// Getting values factores
	const int32_t totalAttack = elementalAttack + weaponAttack;
	const double weaponAttackProportion = static_cast<double>(weaponAttack) / static_cast<double>(totalAttack);

	// Calculating damage
	const int32_t maxDamage = static_cast<int32_t>(Weapons::getMaxWeaponDamage(level, playerSkill, totalAttack, attackFactor, true) * player->getVocation()->meleeDamageMultiplier * damageModifier / 100);
	const int32_t minDamage = level / 5;
	const int32_t realDamage = normal_random(minDamage, maxDamage);

	// Setting damage to combat
	combat.primary.value = realDamage * weaponAttackProportion;
	combat.secondary.value = realDamage * (1 - weaponAttackProportion);
	return combat;
}

bool Weapon::useFist(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target) {
	if (!Position::areInRange<1, 1>(player->getPosition(), target->getPosition())) {
		return false;
	}

	const float attackFactor = player->getAttackFactor();
	const int32_t attackSkill = player->getSkillLevel(SKILL_FIST);
	constexpr int32_t attackValue = 7;

	const int32_t maxDamage = Weapons::getMaxWeaponDamage(player->getLevel(), attackSkill, attackValue, attackFactor, true);

	CombatParams params;
	params.combatType = COMBAT_PHYSICALDAMAGE;
	params.blockedByArmor = true;
	params.blockedByShield = true;
	params.soundImpactEffect = SoundEffect_t::HUMAN_CLOSE_ATK_FIST;

	CombatDamage damage;
	damage.origin = ORIGIN_MELEE;
	damage.primary.type = params.combatType;
	damage.primary.value = -normal_random(0, maxDamage);

	Combat::doCombatHealth(player, target, damage, params);
	if (!player->hasFlag(PlayerFlags_t::NotGainSkill) && player->getAddAttackSkill()) {
		player->addSkillAdvance(SKILL_FIST, 1);
	}

	return true;
}

void Weapon::internalUseWeapon(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, const std::shared_ptr<Creature> &target, int32_t damageModifier, int32_t cleavePercent) const {
	if (player) {
		if (params.soundCastEffect == SoundEffect_t::SILENCE) {
			g_game().sendDoubleSoundEffect(player->getPosition(), player->getHitSoundEffect(), player->getAttackSoundEffect(), player);
		} else {
			g_game().sendDoubleSoundEffect(player->getPosition(), params.soundCastEffect, params.soundImpactEffect, player);
		}
	}

	if (isLoadedScriptId()) {
		if (cleavePercent != 0) {
			return;
		}

		LuaVariant var;
		var.type = VARIANT_NUMBER;
		var.number = target->getID();
		executeUseWeapon(player, var);
		g_logger().debug("Weapon::internalUseWeapon - Lua callback executed.");
	} else {
		CombatDamage damage;
		const WeaponType_t weaponType = item->getWeaponType();
		if (weaponType == WEAPON_AMMO || weaponType == WEAPON_DISTANCE || weaponType == WEAPON_MISSILE) {
			damage.origin = ORIGIN_RANGED;
		} else {
			damage.origin = ORIGIN_MELEE;
		}

		damage.primary.type = params.combatType;
		damage.primary.value = (getWeaponDamage(player, target, item) * damageModifier) / 100;
		damage.secondary.type = getElementType();

		// Cleave damage
		uint16_t damagePercent = 100;
		if (cleavePercent != 0) {
			damage.extension = true;
			damagePercent = cleavePercent;
			if (!damage.exString.empty()) {
				damage.exString += ", ";
			}
			damage.exString += "cleave damage";
		}

		if (damage.secondary.type == COMBAT_NONE) {
			damage.primary.value = (getWeaponDamage(player, target, item) * damageModifier / 100) * damagePercent / 100;
			damage.secondary.value = 0;
		} else {
			damage.primary.value = (getWeaponDamage(player, target, item) * damageModifier / 100) * damagePercent / 100;
			damage.secondary.value = (getElementDamage(player, target, item) * damageModifier / 100) * damagePercent / 100;
		}

		if (g_configManager().getBoolean(TOGGLE_CHAIN_SYSTEM) && params.chainCallback) {
			m_combat->doCombatChain(player, target, params.aggressive);
			g_logger().debug("Weapon::internalUseWeapon - Chain callback executed.");
		} else {
			Combat::doCombatHealth(player, target, damage, params);
		}

		g_logger().debug("Weapon::internalUseWeapon - cpp callback executed.");
	}

	onUsedWeapon(player, item, target->getTile());
}

void Weapon::internalUseWeapon(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, const std::shared_ptr<Tile> &tile) const {
	if (isLoadedScriptId()) {
		LuaVariant var;
		var.type = VARIANT_TARGETPOSITION;
		var.pos = tile->getPosition();
		executeUseWeapon(player, var);
	} else {
		Combat::postCombatEffects(player, player->getPosition(), tile->getPosition(), params);
		g_game().addMagicEffect(tile->getPosition(), CONST_ME_POFF);
		g_game().sendSingleSoundEffect(tile->getPosition(), SoundEffect_t::PHYSICAL_RANGE_MISS, player);
	}
	onUsedWeapon(player, item, tile);
}

void Weapon::onUsedWeapon(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, const std::shared_ptr<Tile> &destTile) const {
	if (!player->hasFlag(PlayerFlags_t::NotGainSkill)) {
		skills_t skillType;
		uint32_t skillPoint;
		if (getSkillType(player, item, skillType, skillPoint)) {
			player->addSkillAdvance(skillType, skillPoint);
		}
	}

	const uint32_t manaCost = getManaCost(player);
	if (manaCost != 0) {
		player->addManaSpent(manaCost);
		player->changeMana(-static_cast<int32_t>(manaCost));

		if (g_configManager().getBoolean(REFUND_BEGINNING_WEAPON_MANA) && (item->getName() == "wand of vortex" || item->getName() == "snakebite rod")) {
			player->changeMana(static_cast<int32_t>(manaCost));
		}
	}

	const uint32_t healthCost = getHealthCost(player);
	if (healthCost != 0) {
		player->changeHealth(-static_cast<int32_t>(healthCost));
	}

	if (!player->hasFlag(PlayerFlags_t::HasInfiniteSoul) && soul > 0) {
		player->changeSoul(-static_cast<int32_t>(soul));
	}

	bool skipRemoveBeginningWeaponAmmo = !g_configManager().getBoolean(REMOVE_BEGINNING_WEAPON_AMMO) && (item->getName() == "arrow" || item->getName() == "bolt" || item->getName() == "spear");
	if (!skipRemoveBeginningWeaponAmmo && breakChance != 0 && uniform_random(1, 100) <= breakChance) {
		Weapon::decrementItemCount(item);
		player->updateSupplyTracker(item);
		return;
	}

	switch (action) {
		case WEAPONACTION_REMOVECOUNT:
			if (!skipRemoveBeginningWeaponAmmo && g_configManager().getBoolean(REMOVE_WEAPON_AMMO)) {
				Weapon::decrementItemCount(item);
				player->updateSupplyTracker(item);
			}
			break;

		case WEAPONACTION_REMOVECHARGE: {
			if (uint16_t charges = item->getCharges() != 0 && g_configManager().getBoolean(REMOVE_WEAPON_CHARGES)) {
				g_game().transformItem(item, item->getID(), charges - 1);
			}
			break;
		}

		case WEAPONACTION_MOVE:
			g_game().internalMoveItem(item->getParent(), destTile, INDEX_WHEREEVER, item, 1, nullptr, FLAG_NOLIMIT);
			break;

		default:
			break;
	}
}

uint32_t Weapon::getManaCost(const std::shared_ptr<Player> &player) const {
	if (mana != 0) {
		return mana;
	}

	if (manaPercent == 0) {
		return 0;
	}

	return (player->getMaxMana() * manaPercent) / 100;
}

int32_t Weapon::getHealthCost(const std::shared_ptr<Player> &player) const {
	if (health != 0) {
		return health;
	}

	if (healthPercent == 0) {
		return 0;
	}

	return (player->getMaxHealth() * healthPercent) / 100;
}

bool Weapon::executeUseWeapon(const std::shared_ptr<Player> &player, const LuaVariant &var) const {
	// onUseWeapon(player, var)
	if (!LuaScriptInterface::reserveScriptEnv()) {
		std::string playerName = player ? player->getName() : "Player nullptr";
		g_logger().error("[Weapon::executeUseWeapon - Player {} weaponId {}]"
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 playerName, getID());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");
	LuaScriptInterface::pushVariant(L, var);

	return getScriptInterface()->callFunction(2);
}

void Weapon::decrementItemCount(const std::shared_ptr<Item> &item) {
	const uint16_t count = item->getItemCount();
	if (count > 1) {
		g_game().transformItem(item, item->getID(), count - 1);
	} else {
		g_game().internalRemoveItem(item);
	}
}

bool Weapon::calculateSkillFormula(const std::shared_ptr<Player> &player, int32_t &attackSkill, int32_t &attackValue, float &attackFactor, int16_t &elementAttack, CombatDamage &damage, bool useCharges /* = false*/) const {
	const auto &tool = player->getWeapon();
	if (!tool) {
		return false;
	}

	std::shared_ptr<Item> item = nullptr;
	attackValue = tool->getAttack();
	if (tool->getWeaponType() == WEAPON_AMMO) {
		item = player->getWeapon(true);
		if (item) {
			attackValue += item->getAttack();
		}
	}

	const CombatType_t elementType = getElementType();
	damage.secondary.type = elementType;

	bool shouldCalculateSecondaryDamage = false;
	if (elementType != COMBAT_NONE) {
		elementAttack = getElementDamageValue();
		shouldCalculateSecondaryDamage = true;
		attackValue += elementAttack;
	}

	if (useCharges) {
		const auto charges = tool->getAttribute<uint16_t>(ItemAttribute_t::CHARGES);
		if (charges != 0) {
			g_game().transformItem(tool, tool->getID(), charges - 1);
		}
	}

	attackSkill = player->getWeaponSkill(item ? item : tool);
	attackFactor = player->getAttackFactor();
	return shouldCalculateSecondaryDamage;
}

void Weapon::addVocWeaponMap(const std::string &vocName) {
	const int32_t vocationId = g_vocations().getVocationId(vocName);
	if (vocationId != -1) {
		vocWeaponMap[vocationId] = true;
	}
}

std::shared_ptr<Combat> Weapon::getCombat() const {
	if (!m_combat) {
		g_logger().error("Weapon::getCombat() - m_combat is nullptr");
		return nullptr;
	}

	return m_combat;
}

std::shared_ptr<Combat> Weapon::getCombat() {
	if (!m_combat) {
		m_combat = std::make_shared<Combat>();
	}

	return m_combat;
}

WeaponMelee::WeaponMelee() {
	// Add combat type and blocked attributes to the weapon
	params.blockedByArmor = true;
	params.blockedByShield = true;
	params.combatType = COMBAT_PHYSICALDAMAGE;
}

void WeaponMelee::configureWeapon(const ItemType &it) {
	if (it.abilities) {
		elementType = it.abilities->elementType;
		elementDamage = it.abilities->elementDamage;
		params.aggressive = true;
		params.useCharges = true;
	} else {
		elementType = COMBAT_NONE;
		elementDamage = 0;
	}
	Weapon::configureWeapon(it);
}

bool WeaponMelee::useWeapon(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, const std::shared_ptr<Creature> &target) const {
	const int32_t damageModifier = playerWeaponCheck(player, target, item->getShootRange());
	if (damageModifier == 0) {
		return false;
	}

	const int32_t cleavePercent = player->getCleavePercent(true);
	if (cleavePercent > 0) {
		const Position &targetPos = target->getPosition();
		const Position &playerPos = player->getPosition();
		if (playerPos != targetPos) {
			Position firstCleaveTargetPos = targetPos;
			Position secondCleaveTargetPos = targetPos;
			if (targetPos.x == playerPos.x) {
				firstCleaveTargetPos.x++;
				secondCleaveTargetPos.x--;
			} else if (targetPos.y == playerPos.y) {
				firstCleaveTargetPos.y++;
				secondCleaveTargetPos.y--;
			} else {
				if (targetPos.x > playerPos.x) {
					firstCleaveTargetPos.x--;
				} else {
					firstCleaveTargetPos.x++;
				}

				if (targetPos.y > playerPos.y) {
					secondCleaveTargetPos.y--;
				} else {
					secondCleaveTargetPos.y++;
				}
			}
			const auto &firstTile = g_game().map.getTile(firstCleaveTargetPos.x, firstCleaveTargetPos.y, firstCleaveTargetPos.z);
			const auto &secondTile = g_game().map.getTile(secondCleaveTargetPos.x, secondCleaveTargetPos.y, secondCleaveTargetPos.z);

			if (firstTile) {
				if (const CreatureVector* tileCreatures = firstTile->getCreatures()) {
					for (const auto &tileCreature : *tileCreatures) {
						if (tileCreature->getMonster() || (tileCreature->getPlayer() && !player->hasSecureMode())) {
							internalUseWeapon(player, item, tileCreature, damageModifier, cleavePercent);
						}
					}
				}
			}
			if (secondTile) {
				if (const CreatureVector* tileCreatures = secondTile->getCreatures()) {
					for (const auto &tileCreature : *tileCreatures) {
						if (tileCreature->getMonster() || (tileCreature->getPlayer() && !player->hasSecureMode())) {
							internalUseWeapon(player, item, tileCreature, damageModifier, cleavePercent);
						}
					}
				}
			}
		}
	}

	internalUseWeapon(player, item, target, damageModifier);
	return true;
}

bool WeaponMelee::getSkillType(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, skills_t &skill, uint32_t &skillpoint) const {
	if (player->getAddAttackSkill() && player->getLastAttackBlockType() != BLOCK_IMMUNITY) {
		skillpoint = 1;
	} else {
		skillpoint = 0;
	}

	const WeaponType_t weaponType = item->getWeaponType();
	switch (weaponType) {
		case WEAPON_SWORD: {
			skill = SKILL_SWORD;
			return true;
		}

		case WEAPON_CLUB: {
			skill = SKILL_CLUB;
			return true;
		}

		case WEAPON_AXE: {
			skill = SKILL_AXE;
			return true;
		}

		default:
			break;
	}
	return false;
}

int32_t WeaponMelee::getElementDamage(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &, const std::shared_ptr<Item> &item) const {
	if (elementType == COMBAT_NONE) {
		return 0;
	}

	const int32_t attackSkill = player->getWeaponSkill(item);
	const int32_t attackValue = elementDamage;
	const float attackFactor = player->getAttackFactor();
	const uint32_t level = player->getLevel();

	const int32_t maxValue = Weapons::getMaxWeaponDamage(level, attackSkill, attackValue, attackFactor, true);
	const int32_t minValue = level / 5;

	return -normal_random(minValue, static_cast<int32_t>(maxValue * player->getVocation()->meleeDamageMultiplier));
}

int16_t WeaponMelee::getElementDamageValue() const {
	return elementDamage;
}

int32_t WeaponMelee::getWeaponDamage(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &, const std::shared_ptr<Item> &item, bool maxDamage /*= false*/) const {
	using namespace std;
	const int32_t attackSkill = player->getWeaponSkill(item);
	const int32_t attackValue = std::max<int32_t>(0, item->getAttack());
	const float attackFactor = player->getAttackFactor();
	const uint32_t level = player->getLevel();

	const int32_t maxValue = static_cast<int32_t>(Weapons::getMaxWeaponDamage(level, attackSkill, attackValue, attackFactor, true) * player->getVocation()->meleeDamageMultiplier);

	const int32_t minValue = level / 5;

	if (maxDamage) {
		return -maxValue;
	}

	return -normal_random(minValue, (maxValue * static_cast<int32_t>(player->getVocation()->meleeDamageMultiplier)));
}

WeaponDistance::WeaponDistance() {
	// Add combat type and distance effect to the weapon
	params.blockedByArmor = true;
	params.combatType = COMBAT_PHYSICALDAMAGE;
}

void WeaponDistance::configureWeapon(const ItemType &it) {
	params.distanceEffect = it.shootType;
	if (it.abilities) {
		elementType = it.abilities->elementType;
		elementDamage = it.abilities->elementDamage;
		params.aggressive = true;
		params.useCharges = true;
	} else {
		elementType = COMBAT_NONE;
		elementDamage = 0;
	}

	Weapon::configureWeapon(it);
}

bool WeaponDistance::useWeapon(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, const std::shared_ptr<Creature> &target) const {
	int32_t damageModifier;
	const ItemType &it = Item::items[id];
	if (it.weaponType == WEAPON_AMMO) {
		const auto &mainWeaponItem = player->getWeapon(true);
		const WeaponShared_ptr &mainWeapon = g_weapons().getWeapon(mainWeaponItem);
		if (mainWeapon) {
			damageModifier = mainWeapon->playerWeaponCheck(player, target, mainWeaponItem->getShootRange());
		} else {
			damageModifier = playerWeaponCheck(player, target, mainWeaponItem->getShootRange());
		}
	} else {
		damageModifier = playerWeaponCheck(player, target, item->getShootRange());
	}

	if (damageModifier == 0) {
		return false;
	}

	bool perfectShot = false;
	const Position &playerPos = player->getPosition();
	const Position &targetPos = target->getPosition();
	const int32_t distanceX = Position::getDistanceX(targetPos, playerPos);
	const int32_t distanceY = Position::getDistanceY(targetPos, playerPos);
	int32_t damageX = player->getPerfectShotDamage(distanceX);
	int32_t damageY = player->getPerfectShotDamage(distanceY);

	if (it.weaponType == WEAPON_DISTANCE) {
		const auto &quiver = player->getInventoryItem(CONST_SLOT_RIGHT);
		if (quiver && quiver->getWeaponType()) {
			if (quiver->getPerfectShotRange() == distanceX) {
				damageX -= quiver->getPerfectShotDamage();
			} else if (quiver->getPerfectShotRange() == distanceY) {
				damageY -= quiver->getPerfectShotDamage();
			}
		}
	}

	int32_t chance;
	if (damageX != 0 || damageY != 0) {
		chance = 100;
		perfectShot = true;
	} else if (it.hitChance == 0) {
		// hit chance is based on distance to target and distance skill
		const uint32_t skill = player->getSkillLevel(SKILL_DISTANCE);
		const uint32_t distance = std::max<uint32_t>(distanceX, distanceY);

		uint32_t maxHitChance;
		if (it.maxHitChance != -1) {
			maxHitChance = it.maxHitChance;
		} else if (it.ammoType != AMMO_NONE) {
			// hit chance on two-handed weapons is limited to 90%
			maxHitChance = 90;
		} else {
			// one-handed is set to 75%
			maxHitChance = 75;
		}

		if (maxHitChance == 75) {
			// chance for one-handed weapons
			switch (distance) {
				case 1:
				case 5:
					chance = std::min<uint32_t>(skill, 74) + 1;
					break;
				case 2:
					chance = static_cast<uint32_t>(std::min<uint32_t>(skill, 28) * 2.40f) + 8;
					break;
				case 3:
					chance = static_cast<uint32_t>(std::min<uint32_t>(skill, 45) * 1.55f) + 6;
					break;
				case 4:
					chance = static_cast<uint32_t>(std::min<uint32_t>(skill, 58) * 1.25f) + 3;
					break;
				case 6:
					chance = static_cast<uint32_t>(std::min<uint32_t>(skill, 90) * 0.80f) + 3;
					break;
				case 7:
					chance = static_cast<uint32_t>(std::min<uint32_t>(skill, 104) * 0.70f) + 2;
					break;
				default:
					chance = it.hitChance;
					break;
			}
		} else if (maxHitChance == 90) {
			// formula for two-handed weapons
			switch (distance) {
				case 1:
				case 5:
					chance = static_cast<uint32_t>(std::min<uint32_t>(skill, 74) * 1.20f) + 1;
					break;
				case 2:
					chance = static_cast<uint32_t>(std::min<uint32_t>(skill, 28) * 3.20f);
					break;
				case 3:
					chance = std::min<uint32_t>(skill, 45) * 2;
					break;
				case 4:
					chance = static_cast<uint32_t>(std::min<uint32_t>(skill, 58) * 1.55f);
					break;
				case 6:
				case 7:
					chance = std::min<uint32_t>(skill, 90);
					break;
				default:
					chance = it.hitChance;
					break;
			}
		} else if (maxHitChance == 100) {
			switch (distance) {
				case 1:
				case 5:
					chance = static_cast<uint32_t>(std::min<uint32_t>(skill, 73) * 1.35f) + 1;
					break;
				case 2:
					chance = static_cast<uint32_t>(std::min<uint32_t>(skill, 30) * 3.20f) + 4;
					break;
				case 3:
					chance = static_cast<uint32_t>(std::min<uint32_t>(skill, 48) * 2.05f) + 2;
					break;
				case 4:
					chance = static_cast<uint32_t>(std::min<uint32_t>(skill, 65) * 1.50f) + 2;
					break;
				case 6:
					chance = static_cast<uint32_t>(std::min<uint32_t>(skill, 87) * 1.20f) - 4;
					break;
				case 7:
					chance = static_cast<uint32_t>(std::min<uint32_t>(skill, 90) * 1.10f) + 1;
					break;
				default:
					chance = it.hitChance;
					break;
			}
		} else {
			chance = maxHitChance;
		}
	} else {
		chance = it.hitChance;
	}

	if (!perfectShot && item->getWeaponType() == WEAPON_AMMO) {
		const auto &bow = player->getWeapon(true);
		if (bow && bow->getHitChance() != 0) {
			chance += bow->getHitChance();
		}
	}

	if (chance >= uniform_random(1, 100)) {
		Weapon::internalUseWeapon(player, item, target, damageModifier);
	} else {
		// miss target
		auto destTile = target->getTile();

		if (!Position::areInRange<1, 1, 0>(player->getPosition(), target->getPosition())) {
			static std::vector<std::pair<int32_t, int32_t>> destList {
				{ -1, -1 }, { 0, -1 }, { 1, -1 }, { -1, 0 }, { 0, 0 }, { 1, 0 }, { -1, 1 }, { 0, 1 }, { 1, 1 }
			};
			std::ranges::shuffle(destList.begin(), destList.end(), getRandomGenerator());

			const Position destPos = target->getPosition();

			for (const auto &dir : destList) {
				// Blocking tiles or tiles without ground ain't valid targets for spears
				const auto &tmpTile = g_game().map.getTile(static_cast<uint16_t>(destPos.x + dir.first), static_cast<uint16_t>(destPos.y + dir.second), destPos.z);
				if (tmpTile && !tmpTile->hasFlag(TILESTATE_IMMOVABLEBLOCKSOLID) && tmpTile->getGround() != nullptr) {
					destTile = tmpTile;
					break;
				}
			}
		}

		Weapon::internalUseWeapon(player, item, destTile);
	}
	return true;
}

int32_t WeaponDistance::getElementDamage(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, const std::shared_ptr<Item> &item) const {
	if (elementType == COMBAT_NONE) {
		return 0;
	}

	int32_t attackValue = elementDamage;
	if (item && player && item->getWeaponType() == WEAPON_AMMO) {
		const auto &weapon = player->getWeapon(true);
		if (weapon) {
			attackValue += item->getAttack();
			attackValue += weapon->getAttack();
		}
	}

	const int32_t attackSkill = player->getSkillLevel(SKILL_DISTANCE);
	const float attackFactor = player->getAttackFactor();

	int32_t minValue = std::round(player->getLevel() / 5);
	const int32_t maxValue = std::round((0.09f * attackFactor) * attackSkill * attackValue + minValue) / 2;

	if (target) {
		if (target->getPlayer()) {
			minValue /= 4;
		} else {
			minValue /= 2;
		}
	}

	return -normal_random(minValue, static_cast<int32_t>(maxValue * player->getVocation()->distDamageMultiplier));
}

int16_t WeaponDistance::getElementDamageValue() const {
	return elementDamage;
}

int32_t WeaponDistance::getWeaponDamage(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, const std::shared_ptr<Item> &item, bool maxDamage /*= false*/) const {
	int32_t attackValue = item->getAttack();
	bool hasElement = false;

	if (player && item && item->getWeaponType() == WEAPON_AMMO) {
		const auto &weapon = player->getWeapon(true);
		if (weapon) {
			const ItemType &it = Item::items[item->getID()];
			if (it.abilities && it.abilities->elementDamage != 0) {
				attackValue += it.abilities->elementDamage;
				hasElement = true;
			}

			attackValue += weapon->getAttack();
		}
	}

	const int32_t attackSkill = player->getSkillLevel(SKILL_DISTANCE);
	const float attackFactor = player->getAttackFactor();

	int32_t minValue = player->getLevel() / 5;
	int32_t maxValue = std::round((0.09f * attackFactor) * attackSkill * attackValue + minValue);
	if (maxDamage) {
		return -maxValue;
	}

	if (target && target->getPlayer()) {
		if (hasElement) {
			minValue /= 4;
		} else {
			minValue /= 2;
		}
	} else {
		if (hasElement) {
			maxValue /= 2;
			minValue /= 2;
		}
	}

	return -normal_random(minValue, (maxValue * static_cast<int32_t>(player->getVocation()->distDamageMultiplier)));
}

bool WeaponDistance::getSkillType(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &, skills_t &skill, uint32_t &skillpoint) const {
	skill = SKILL_DISTANCE;

	if (player && player->getAddAttackSkill()) {
		switch (player->getLastAttackBlockType()) {
			case BLOCK_NONE: {
				skillpoint = 2;
				break;
			}

			case BLOCK_DEFENSE:
			case BLOCK_ARMOR: {
				skillpoint = 1;
				break;
			}

			default:
				skillpoint = 0;
				break;
		}
	} else {
		skillpoint = 0;
	}
	return true;
}

WeaponWand::WeaponWand() = default;

void WeaponWand::configureWeapon(const ItemType &it) {
	params.distanceEffect = it.shootType;
	const_cast<ItemType &>(it).combatType = params.combatType;
	const_cast<ItemType &>(it).maxHitChance = (minChange + maxChange) / 2;
	Weapon::configureWeapon(it);
}

int32_t WeaponWand::getWeaponDamage(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &, const std::shared_ptr<Item> &, bool maxDamage /* = false*/) const {
	return maxDamage ? -maxChange : -normal_random(minChange, maxChange);
}

int16_t WeaponWand::getElementDamageValue() const {
	return 0;
}
