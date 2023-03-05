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
#include "game/game.h"
#include "lua/creature/events.h"
#include "items/weapons/weapons.h"

Weapons::Weapons() = default;
Weapons::~Weapons() = default;

const Weapon* Weapons::getWeapon(const Item* item) const {
	if (!item) {
		return nullptr;
	}

	auto it = weapons.find(item->getID());
	if (it == weapons.end()) {
		return nullptr;
	}
	return it->second;
}

void Weapons::clear() {
	weapons.clear();
}

bool Weapons::registerLuaEvent(Weapon* event) {
	weapons[event->getID()] = event;
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

void Weapon::configureWeapon(const ItemType &it) {
	id = it.id;
}

// std::string Weapon::getScriptEventName() const
// {
// return "onUseWeapon";
// }

int32_t Weapon::playerWeaponCheck(Player* player, Creature* target, uint8_t shootRange) const {
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

bool Weapon::useWeapon(Player* player, Item* item, Creature* target) const {
	int32_t damageModifier = playerWeaponCheck(player, target, item->getShootRange());
	if (damageModifier == 0) {
		return false;
	}

	internalUseWeapon(player, item, target, damageModifier);
	return true;
}

CombatDamage Weapon::getCombatDamage(CombatDamage combat, Player* player, Item* item, int32_t damageModifier) const {
	// Local variables
	uint32_t level = player->getLevel();
	int16_t elementalAttack = getElementDamageValue();
	int32_t weaponAttack = std::max<int32_t>(0, item->getAttack());
	int32_t playerSkill = player->getWeaponSkill(item);
	float attackFactor = player->getAttackFactor(); // full atk, balanced or full defense

	// Getting values factores
	int32_t totalAttack = elementalAttack + weaponAttack;
	double weaponAttackProportion = (double)weaponAttack / (double)totalAttack;

	// Calculating damage
	int32_t maxDamage = static_cast<int32_t>(Weapons::getMaxWeaponDamage(level, playerSkill, totalAttack, attackFactor, true) * player->getVocation()->meleeDamageMultiplier * damageModifier / 100);
	int32_t minDamage = level / 5;
	int32_t realDamage = normal_random(minDamage, maxDamage);

	// Setting damage to combat
	combat.primary.value = realDamage * weaponAttackProportion;
	combat.secondary.value = realDamage * (1 - weaponAttackProportion);
	return combat;
}

bool Weapon::useFist(Player* player, Creature* target) {
	if (!Position::areInRange<1, 1>(player->getPosition(), target->getPosition())) {
		return false;
	}

	float attackFactor = player->getAttackFactor();
	int32_t attackSkill = player->getSkillLevel(SKILL_FIST);
	int32_t attackValue = 7;

	int32_t maxDamage = Weapons::getMaxWeaponDamage(player->getLevel(), attackSkill, attackValue, attackFactor, true);

	CombatParams params;
	params.combatType = COMBAT_PHYSICALDAMAGE;
	params.blockedByArmor = true;
	params.blockedByShield = true;

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

void Weapon::internalUseWeapon(Player* player, Item* item, Creature* target, int32_t damageModifier, bool cleave) const {
	if (isLoadedCallback()) {
		if (cleave)
			return;
		LuaVariant var;
		var.type = VARIANT_NUMBER;
		var.number = target->getID();
		executeUseWeapon(player, var);
	} else {
		CombatDamage damage;
		WeaponType_t weaponType = item->getWeaponType();
		if (weaponType == WEAPON_AMMO || weaponType == WEAPON_DISTANCE || weaponType == WEAPON_WAND) {
			damage.origin = ORIGIN_RANGED;
		} else {
			damage.origin = ORIGIN_MELEE;
		}

		damage.primary.type = params.combatType;
		damage.secondary.type = getElementType();

		// cleave
		damage.cleave = cleave;
		uint16_t cleavePercent = 0;
		if (cleave) {
			damage.extension = true;
			cleavePercent = player->getCleavePercent();
			damage.exString = " (cleave damage)";
		}

		if (damage.secondary.type == COMBAT_NONE) {
			damage.primary.value = (getWeaponDamage(player, target, item, false, cleavePercent) * damageModifier) / 100;
			damage.secondary.value = 0;
		} else {
			damage.primary.value = (getWeaponDamage(player, target, item, false, cleavePercent) * damageModifier) / 100;
			damage.secondary.value = (getElementDamage(player, target, item, cleavePercent) * damageModifier) / 100;
		}

		Combat::doCombatHealth(player, target, damage, params);
	}

	onUsedWeapon(player, item, target->getTile());
}

void Weapon::internalUseWeapon(Player* player, Item* item, Tile* tile) const {
	if (isLoadedCallback()) {
		LuaVariant var;
		var.type = VARIANT_TARGETPOSITION;
		var.pos = tile->getPosition();
		executeUseWeapon(player, var);
	} else {
		Combat::postCombatEffects(player, tile->getPosition(), params);
		g_game().addMagicEffect(tile->getPosition(), CONST_ME_POFF);
	}
	onUsedWeapon(player, item, tile);
}

void Weapon::onUsedWeapon(Player* player, Item* item, Tile* destTile) const {
	if (!player->hasFlag(PlayerFlags_t::NotGainSkill)) {
		skills_t skillType;
		uint32_t skillPoint;
		if (getSkillType(player, item, skillType, skillPoint)) {
			player->addSkillAdvance(skillType, skillPoint);
		}
	}

	uint32_t manaCost = getManaCost(player);
	if (manaCost != 0) {
		player->addManaSpent(manaCost);
		player->changeMana(-static_cast<int32_t>(manaCost));
	}

	uint32_t healthCost = getHealthCost(player);
	if (healthCost != 0) {
		player->changeHealth(-static_cast<int32_t>(healthCost));
	}

	if (!player->hasFlag(PlayerFlags_t::HasInfiniteSoul) && soul > 0) {
		player->changeSoul(-static_cast<int32_t>(soul));
	}

	if (breakChance != 0 && uniform_random(1, 100) <= breakChance) {
		Weapon::decrementItemCount(item);
		player->updateSupplyTracker(item);
		return;
	}

	switch (action) {
		case WEAPONACTION_REMOVECOUNT:
			if (g_configManager().getBoolean(REMOVE_WEAPON_AMMO)) {
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

uint32_t Weapon::getManaCost(const Player* player) const {
	if (mana != 0) {
		return mana;
	}

	if (manaPercent == 0) {
		return 0;
	}

	return (player->getMaxMana() * manaPercent) / 100;
}

int32_t Weapon::getHealthCost(const Player* player) const {
	if (health != 0) {
		return health;
	}

	if (healthPercent == 0) {
		return 0;
	}

	return (player->getMaxHealth() * healthPercent) / 100;
}

bool Weapon::executeUseWeapon(Player* player, const LuaVariant &var) const {
	// onUseWeapon(player, var)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[Weapon::executeUseWeapon - Player {} weaponId {}]"
					 "Call stack overflow. Too many lua script calls being nested.",
					 player->getName(), getID());
		return false;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");
	getScriptInterface()->pushVariant(L, var);

	return getScriptInterface()->callFunction(2);
}

void Weapon::decrementItemCount(Item* item) {
	uint16_t count = item->getItemCount();
	if (count > 1) {
		g_game().transformItem(item, item->getID(), count - 1);
	} else {
		g_game().internalRemoveItem(item);
	}
}

WeaponMelee::WeaponMelee(LuaScriptInterface* interface) :
	Weapon(interface) {
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

bool WeaponMelee::useWeapon(Player* player, Item* item, Creature* target) const {
	int32_t damageModifier = playerWeaponCheck(player, target, item->getShootRange());
	if (damageModifier == 0) {
		return false;
	}

	if (player->getCleavePercent() > 0) {
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
				if (targetPos.x > playerPos.x)
					firstCleaveTargetPos.x--;
				else
					firstCleaveTargetPos.x++;

				if (targetPos.y > playerPos.y)
					secondCleaveTargetPos.y--;
				else
					secondCleaveTargetPos.y++;
			}
			Position pos(firstCleaveTargetPos.x, firstCleaveTargetPos.y, firstCleaveTargetPos.z);
			Position pos2(secondCleaveTargetPos.x, secondCleaveTargetPos.y, secondCleaveTargetPos.z);
			Tile* firstTile = g_game().map.getTile(pos);
			Tile* secondTile = g_game().map.getTile(pos2);

			if (firstTile && !firstTile->isMoveableBlocking()) {

				for (Creature* creature : *firstTile->getCreatures()) {
					if (creature->getMonster() || (creature->getPlayer() && !player->hasSecureMode()))
						internalUseWeapon(player, item, creature, damageModifier, true);
				}
			}
			if (secondTile && !secondTile->isMoveableBlocking()) {
				for (Creature* creature : *secondTile->getCreatures()) {
					if (creature->getMonster() || (creature->getPlayer() && !player->hasSecureMode()))
						internalUseWeapon(player, item, creature, damageModifier, true);
				}
			}
		}
	}

	internalUseWeapon(player, item, target, damageModifier);
	return true;
}

bool WeaponMelee::getSkillType(const Player* player, const Item* item, skills_t &skill, uint32_t &skillpoint) const {
	if (player->getAddAttackSkill() && player->getLastAttackBlockType() != BLOCK_IMMUNITY) {
		skillpoint = 1;
	} else {
		skillpoint = 0;
	}

	WeaponType_t weaponType = item->getWeaponType();
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

int32_t WeaponMelee::getElementDamage(const Player* player, const Creature*, const Item* item, uint16_t cleavePercent) const {
	if (elementType == COMBAT_NONE) {
		return 0;
	}

	int32_t attackSkill = player->getWeaponSkill(item);
	int32_t attackValue = elementDamage;
	if (cleavePercent != 0)
		attackValue = std::round(attackValue * cleavePercent / 100.);
	float attackFactor = player->getAttackFactor();
	uint32_t level = player->getLevel();
	int32_t minValue = level / 5;

	int32_t maxValue = Weapons::getMaxWeaponDamage(level, attackSkill, attackValue, attackFactor, true);
	return -normal_random(minValue, static_cast<int32_t>(maxValue * player->getVocation()->meleeDamageMultiplier));
}

int16_t WeaponMelee::getElementDamageValue() const {
	return elementDamage;
}

int32_t WeaponMelee::getWeaponDamage(const Player* player, const Creature*, const Item* item, bool maxDamage /*= false*/, uint16_t cleavePercent /*= 0*/) const {
	using namespace std;
	int32_t attackSkill = player->getWeaponSkill(item);
	int32_t attackValue = std::max<int32_t>(0, item->getAttack());
	float attackFactor = player->getAttackFactor();
	if (cleavePercent != 0)
		attackValue = std::round(attackValue * cleavePercent / 100.);
	uint32_t level = player->getLevel();

	int32_t maxValue = static_cast<int32_t>(Weapons::getMaxWeaponDamage(level, attackSkill, attackValue, attackFactor, true) * player->getVocation()->meleeDamageMultiplier);

	int32_t minValue = level / 5;

	if (maxDamage) {
		return -maxValue;
	}

	return -normal_random(minValue, (maxValue * static_cast<int32_t>(player->getVocation()->meleeDamageMultiplier)));
}

WeaponDistance::WeaponDistance(LuaScriptInterface* interface) :
	Weapon(interface) {
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

bool WeaponDistance::useWeapon(Player* player, Item* item, Creature* target) const {
	int32_t damageModifier;
	const ItemType &it = Item::items[id];
	if (it.weaponType == WEAPON_AMMO) {
		Item* mainWeaponItem = player->getWeapon(true);
		const Weapon* mainWeapon = g_weapons().getWeapon(mainWeaponItem);
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

	int32_t chance;
	if (it.hitChance == 0) {
		// hit chance is based on distance to target and distance skill
		uint32_t skill = player->getSkillLevel(SKILL_DISTANCE);
		const Position &playerPos = player->getPosition();
		const Position &targetPos = target->getPosition();
		uint32_t distance = std::max<uint32_t>(Position::getDistanceX(playerPos, targetPos), Position::getDistanceY(playerPos, targetPos));

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

	if (item->getWeaponType() == WEAPON_AMMO) {
		Item* bow = player->getWeapon(true);
		if (bow && bow->getHitChance() != 0) {
			chance += bow->getHitChance();
		}
	}

	if (chance >= uniform_random(1, 100)) {
		Weapon::internalUseWeapon(player, item, target, damageModifier);
	} else {
		// miss target
		Tile* destTile = target->getTile();

		if (!Position::areInRange<1, 1, 0>(player->getPosition(), target->getPosition())) {
			static std::vector<std::pair<int32_t, int32_t>> destList {
				{ -1, -1 }, { 0, -1 }, { 1, -1 }, { -1, 0 }, { 0, 0 }, { 1, 0 }, { -1, 1 }, { 0, 1 }, { 1, 1 }
			};
			std::ranges::shuffle(destList.begin(), destList.end(), getRandomGenerator());

			Position destPos = target->getPosition();

			for (const auto &dir : destList) {
				// Blocking tiles or tiles without ground ain't valid targets for spears
				Tile* tmpTile = g_game().map.getTile(static_cast<uint16_t>(destPos.x + dir.first), static_cast<uint16_t>(destPos.y + dir.second), destPos.z);
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

int32_t WeaponDistance::getElementDamage(const Player* player, const Creature* target, const Item* item, uint16_t cleavePercent) const {
	if (elementType == COMBAT_NONE) {
		return 0;
	}

	int32_t attackValue = elementDamage;
	if (item->getWeaponType() == WEAPON_AMMO) {
		Item* weapon = player->getWeapon(true);
		if (weapon) {
			attackValue += item->getAttack();
			attackValue += weapon->getAttack();
		}
	}

	int32_t attackSkill = player->getSkillLevel(SKILL_DISTANCE);
	float attackFactor = player->getAttackFactor();

	int32_t minValue = std::round(player->getLevel() / 5);
	int32_t maxValue = std::round((0.09f * attackFactor) * attackSkill * attackValue + minValue) / 2;

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

int32_t WeaponDistance::getWeaponDamage(const Player* player, const Creature* target, const Item* item, bool maxDamage /*= false*/, uint16_t cleavePercent) const {
	int32_t attackValue = item->getAttack();
	bool hasElement = false;

	if (item->getWeaponType() == WEAPON_AMMO) {
		Item* weapon = player->getWeapon(true);
		if (weapon) {
			const ItemType &it = Item::items[item->getID()];
			if (it.abilities && it.abilities->elementDamage != 0) {
				attackValue += it.abilities->elementDamage;
				hasElement = true;
			}

			attackValue += weapon->getAttack();
		}
	}

	int32_t attackSkill = player->getSkillLevel(SKILL_DISTANCE);
	float attackFactor = player->getAttackFactor();

	int32_t minValue = player->getLevel() / 5;
	int32_t maxValue = std::round((0.09f * attackFactor) * attackSkill * attackValue + minValue);
	if (maxDamage) {
		return -maxValue;
	}

	if (target->getPlayer()) {
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

bool WeaponDistance::getSkillType(const Player* player, const Item*, skills_t &skill, uint32_t &skillpoint) const {
	skill = SKILL_DISTANCE;

	if (player->getAddAttackSkill()) {
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

void WeaponWand::configureWeapon(const ItemType &it) {
	params.distanceEffect = it.shootType;
	const_cast<ItemType &>(it).combatType = params.combatType;
	const_cast<ItemType &>(it).maxHitChance = (minChange + maxChange) / 2;
	Weapon::configureWeapon(it);
}

int32_t WeaponWand::getWeaponDamage(const Player*, const Creature*, const Item*, bool maxDamage /*= false*/, uint16_t cleavePercent) const {
	if (maxDamage) {
		return -maxChange;
	}
	return -normal_random(minChange, maxChange);
}

int16_t WeaponWand::getElementDamageValue() const {
	return 0;
}
