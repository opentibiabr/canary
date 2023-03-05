/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "declarations.hpp"
#include "creatures/combat/combat.h"
#include "lua/creature/events.h"
#include "game/game.h"
#include "io/iobestiary.h"
#include "creatures/monsters/monster.h"
#include "creatures/monsters/monsters.h"
#include "items/weapons/weapons.h"
#include "creatures/combat/spells.h"

CombatDamage Combat::getCombatDamage(Creature* creature, Creature* target) const {
	CombatDamage damage;
	damage.origin = params.origin;
	damage.primary.type = params.combatType;
	damage.instantSpellName = sourceInstantSpellName;
	damage.runeSpellName = sourceRuneSpellName;
	// Wheel of destiny
	Spell* spell = nullptr;
	Player* attackerPlayer = creature ? creature->getPlayer() : nullptr;
	if (attackerPlayer) {
		spell = attackerPlayer->getWheelOfDestinyCombatDataSpell(damage, target);
	}
	if (formulaType == COMBAT_FORMULA_DAMAGE) {
		damage.primary.value = normal_random(
			static_cast<int32_t>(mina),
			static_cast<int32_t>(maxa)
		);
	} else if (creature) {
		int32_t min, max;
		if (creature->getCombatValues(min, max)) {
			damage.primary.value = normal_random(min, max);
		} else if (Player* player = creature->getPlayer()) {
			if (params.valueCallback) {
				params.valueCallback->getMinMaxValues(player, damage, params.useCharges);
			} else if (formulaType == COMBAT_FORMULA_LEVELMAGIC) {
				uint32_t magicLevelSkill = player->getMagicLevel();
				// Wheel of destiny - Runic Mastery
				if (player->getWheelOfDestinyInstant("Runic Mastery") && spell && damage.instantSpellName.empty()) {
					if (normal_random(0, 100) <= 25) {
						// Yeah, im using rune name on instant. This happens because rune conjuring spell have the same name as the rune item spell.
						InstantSpell* conjuringSpell = g_spells().getInstantSpellByName(damage.runeSpellName);
						if (conjuringSpell && conjuringSpell != spell) {
							magicLevelSkill += std::ceil((static_cast<double>(magicLevelSkill) * (conjuringSpell->canCast(player) ? 20 : 10)) / 100.);
						}
					}
				}
				// int32_t levelFormula = player->getLevel() * 2 + magicLevelSkill * 3;
				int32_t levelFormula = player->getLevel() * 2 + (magicLevelSkill + player->getSpecializedMagicLevel(damage.primary.type)) * 3;
				damage.primary.value = normal_random(
					static_cast<int32_t>(levelFormula * mina + minb),
					static_cast<int32_t>(levelFormula * maxa + maxb)
				);
			} else if (formulaType == COMBAT_FORMULA_SKILL) {
				Item* tool = player->getWeapon();
				const Weapon* weapon = g_weapons().getWeapon(tool);
				if (weapon) {
					damage.primary.value = normal_random(
						static_cast<int32_t>(minb),
						static_cast<int32_t>(weapon->getWeaponDamage(player, target, tool, true) * maxa + maxb)
					);

					damage.secondary.type = weapon->getElementType();
					damage.secondary.value = weapon->getElementDamage(player, target, tool);
					if (params.useCharges) {
						auto charges = tool->getAttribute<uint16_t>(ItemAttribute_t::CHARGES);
						if (charges != 0) {
							g_game().transformItem(tool, tool->getID(), charges - 1);
						}
					}
				} else {
					damage.primary.value = normal_random(
						static_cast<int32_t>(minb),
						static_cast<int32_t>(maxb)
					);
				}
			}
		}
	}
	return damage;
}

void Combat::getCombatArea(const Position &centerPos, const Position &targetPos, const AreaCombat* area, std::forward_list<Tile*> &list) {
	if (targetPos.z >= MAP_MAX_LAYERS) {
		return;
	}

	if (area) {
		area->getList(centerPos, targetPos, list);
	} else {
		Tile* tile = g_game().map.getTile(targetPos);
		if (!tile) {
			tile = new StaticTile(targetPos.x, targetPos.y, targetPos.z);
			g_game().map.setTile(targetPos, tile);
		}
		list.push_front(tile);
	}
}

CombatType_t Combat::ConditionToDamageType(ConditionType_t type) {
	switch (type) {
		case CONDITION_FIRE:
			return COMBAT_FIREDAMAGE;

		case CONDITION_ENERGY:
			return COMBAT_ENERGYDAMAGE;

		case CONDITION_BLEEDING:
			return COMBAT_PHYSICALDAMAGE;

		case CONDITION_DROWN:
			return COMBAT_DROWNDAMAGE;

		case CONDITION_POISON:
			return COMBAT_EARTHDAMAGE;

		case CONDITION_FREEZING:
			return COMBAT_ICEDAMAGE;

		case CONDITION_DAZZLED:
			return COMBAT_HOLYDAMAGE;

		case CONDITION_CURSED:
			return COMBAT_DEATHDAMAGE;

		default:
			break;
	}

	return COMBAT_NONE;
}

ConditionType_t Combat::DamageToConditionType(CombatType_t type) {
	switch (type) {
		case COMBAT_FIREDAMAGE:
			return CONDITION_FIRE;

		case COMBAT_ENERGYDAMAGE:
			return CONDITION_ENERGY;

		case COMBAT_DROWNDAMAGE:
			return CONDITION_DROWN;

		case COMBAT_EARTHDAMAGE:
			return CONDITION_POISON;

		case COMBAT_ICEDAMAGE:
			return CONDITION_FREEZING;

		case COMBAT_HOLYDAMAGE:
			return CONDITION_DAZZLED;

		case COMBAT_DEATHDAMAGE:
			return CONDITION_CURSED;

		case COMBAT_PHYSICALDAMAGE:
			return CONDITION_BLEEDING;

		default:
			return CONDITION_NONE;
	}
}

bool Combat::isPlayerCombat(const Creature* target) {
	if (target->getPlayer()) {
		return true;
	}

	if (target->isSummon() && target->getMaster()->getPlayer()) {
		return true;
	}

	return false;
}

ReturnValue Combat::canTargetCreature(Player* player, Creature* target) {
	if (player == target) {
		return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
	}

	if (!player->hasFlag(PlayerFlags_t::IgnoreProtectionZone)) {
		// pz-zone
		if (player->getZone() == ZONE_PROTECTION) {
			return RETURNVALUE_ACTIONNOTPERMITTEDINPROTECTIONZONE;
		}

		if (target->getZone() == ZONE_PROTECTION) {
			return RETURNVALUE_ACTIONNOTPERMITTEDINPROTECTIONZONE;
		}

		// nopvp-zone
		if (isPlayerCombat(target)) {
			if (player->getZone() == ZONE_NOPVP) {
				return RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE;
			}

			if (target->getZone() == ZONE_NOPVP) {
				return RETURNVALUE_YOUMAYNOTATTACKAPERSONINPROTECTIONZONE;
			}
		}
	}

	if (player->hasFlag(PlayerFlags_t::CannotUseCombat) || !target->isAttackable()) {
		if (target->getPlayer()) {
			return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
		} else {
			return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE;
		}
	}

	if (target->getPlayer()) {
		if (isProtected(player, target->getPlayer())) {
			return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
		}

		if (player->hasSecureMode() && !Combat::isInPvpZone(player, target) && player->getSkullClient(target->getPlayer()) == SKULL_NONE) {
			return RETURNVALUE_TURNSECUREMODETOATTACKUNMARKEDPLAYERS;
		}
	}

	return Combat::canDoCombat(player, target);
}

ReturnValue Combat::canDoCombat(Creature* caster, Tile* tile, bool aggressive) {
	if (tile->hasProperty(CONST_PROP_BLOCKPROJECTILE)) {
		return RETURNVALUE_NOTENOUGHROOM;
	}

	if (tile->hasFlag(TILESTATE_FLOORCHANGE)) {
		return RETURNVALUE_NOTENOUGHROOM;
	}

	if (tile->getTeleportItem()) {
		return RETURNVALUE_NOTENOUGHROOM;
	}

	if (caster) {
		const Position &casterPosition = caster->getPosition();
		const Position &tilePosition = tile->getPosition();
		if (casterPosition.z < tilePosition.z) {
			return RETURNVALUE_FIRSTGODOWNSTAIRS;
		} else if (casterPosition.z > tilePosition.z) {
			return RETURNVALUE_FIRSTGOUPSTAIRS;
		}

		if (const Player* player = caster->getPlayer()) {
			if (player->hasFlag(PlayerFlags_t::IgnoreProtectionZone)) {
				return RETURNVALUE_NOERROR;
			}
		}
	}

	// pz-zone
	if (aggressive && tile->hasFlag(TILESTATE_PROTECTIONZONE)) {
		return RETURNVALUE_ACTIONNOTPERMITTEDINPROTECTIONZONE;
	}

	return g_events().eventCreatureOnAreaCombat(caster, tile, aggressive);
}

bool Combat::isInPvpZone(const Creature* attacker, const Creature* target) {
	return attacker->getZone() == ZONE_PVP && target->getZone() == ZONE_PVP;
}

bool Combat::isProtected(const Player* attacker, const Player* target) {
	uint32_t protectionLevel = g_configManager().getNumber(PROTECTION_LEVEL);
	if (target->getLevel() < protectionLevel || attacker->getLevel() < protectionLevel) {
		return true;
	}

	if (!attacker->getVocation()->canCombat() || !target->getVocation()->canCombat() && (attacker->getVocationId() == VOCATION_NONE || target->getVocationId() == VOCATION_NONE)) {
		return true;
	}

	if (attacker->getSkull() == SKULL_BLACK && attacker->getSkullClient(target) == SKULL_NONE) {
		return true;
	}

	return false;
}

ReturnValue Combat::canDoCombat(Creature* attacker, Creature* target) {
	if (attacker) {
		const Creature* attackerMaster = attacker->getMaster();
		if (const Player* targetPlayer = target->getPlayer()) {
			if (targetPlayer->hasFlag(PlayerFlags_t::CannotBeAttacked)) {
				return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
			}

			if (const Player* attackerPlayer = attacker->getPlayer()) {
				if (attackerPlayer->hasFlag(PlayerFlags_t::CannotAttackPlayer)) {
					return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
				}

				if (isProtected(attackerPlayer, targetPlayer)) {
					return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
				}

				// nopvp-zone
				if (const Tile* targetPlayerTile = targetPlayer->getTile();
					targetPlayerTile->hasFlag(TILESTATE_NOPVPZONE)) {
					return RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE;
				} else if (attackerPlayer->getTile()->hasFlag(TILESTATE_NOPVPZONE) && !targetPlayerTile->hasFlag(TILESTATE_NOPVPZONE | TILESTATE_PROTECTIONZONE)) {
					return RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE;
				}

				if (attackerPlayer->getFaction() != FACTION_DEFAULT && attackerPlayer->getFaction() != FACTION_PLAYER && attackerPlayer->getFaction() == targetPlayer->getFaction()) {
					return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
				}
			}

			if (attackerMaster) {
				if (const Player* masterAttackerPlayer = attackerMaster->getPlayer()) {
					if (masterAttackerPlayer->hasFlag(PlayerFlags_t::CannotAttackPlayer)) {
						return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
					}

					if (targetPlayer->getTile()->hasFlag(TILESTATE_NOPVPZONE)) {
						return RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE;
					}

					if (isProtected(masterAttackerPlayer, targetPlayer)) {
						return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
					}
				}
			}

			if (attacker->getMonster() && (!attackerMaster || attackerMaster->getMonster())) {
				if (attacker->getFaction() != FACTION_DEFAULT && !attacker->getMonster()->isEnemyFaction(targetPlayer->getFaction())) {
					return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
				}
			}
		} else if (target && target->getMonster()) {

			if (attacker->getFaction() != FACTION_DEFAULT && attacker->getFaction() != FACTION_PLAYER && attacker->getMonster() && !attacker->getMonster()->isEnemyFaction(target->getFaction())) {
				return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE;
			}

			if (const Player* attackerPlayer = attacker->getPlayer()) {
				if (attackerPlayer->hasFlag(PlayerFlags_t::CannotAttackMonster)) {
					return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE;
				}

				if (target->isSummon() && target->getMaster()->getPlayer() && target->getZone() == ZONE_NOPVP) {
					return RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE;
				}
			} else if (attacker->getMonster()) {
				const Creature* targetMaster = target->getMaster();

				if ((!targetMaster || !targetMaster->getPlayer()) && attacker->getFaction() == FACTION_DEFAULT) {

					if (!attackerMaster || !attackerMaster->getPlayer()) {
						return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE;
					}
				}
			}
		} else if (target && target->getNpc()) {
			return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE;
		}

		if (g_game().getWorldType() == WORLD_TYPE_NO_PVP) {
			if (attacker->getPlayer() || (attackerMaster && attackerMaster->getPlayer())) {
				if (target->getPlayer()) {
					if (!isInPvpZone(attacker, target)) {
						return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
					}
				}

				if (target->isSummon() && target->getMaster()->getPlayer()) {
					if (!isInPvpZone(attacker, target)) {
						return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE;
					}
				}
			}
		}
	}
	return g_events().eventCreatureOnTargetCombat(attacker, target);
}

void Combat::setPlayerCombatValues(formulaType_t newFormulaType, double newMina, double newMinb, double newMaxa, double newMaxb) {
	this->formulaType = newFormulaType;
	this->mina = newMina;
	this->minb = newMinb;
	this->maxa = newMaxa;
	this->maxb = newMaxb;
}

bool Combat::setParam(CombatParam_t param, uint32_t value) {
	switch (param) {
		case COMBAT_PARAM_TYPE: {
			params.combatType = static_cast<CombatType_t>(value);
			return true;
		}

		case COMBAT_PARAM_EFFECT: {
			params.impactEffect = static_cast<uint8_t>(value);
			return true;
		}

		case COMBAT_PARAM_DISTANCEEFFECT: {
			params.distanceEffect = static_cast<uint8_t>(value);
			return true;
		}

		case COMBAT_PARAM_BLOCKARMOR: {
			params.blockedByArmor = (value != 0);
			return true;
		}

		case COMBAT_PARAM_BLOCKSHIELD: {
			params.blockedByShield = (value != 0);
			return true;
		}

		case COMBAT_PARAM_TARGETCASTERORTOPMOST: {
			params.targetCasterOrTopMost = (value != 0);
			return true;
		}

		case COMBAT_PARAM_CREATEITEM: {
			params.itemId = value;
			return true;
		}

		case COMBAT_PARAM_AGGRESSIVE: {
			params.aggressive = (value != 0);
			return true;
		}

		case COMBAT_PARAM_DISPEL: {
			params.dispelType = static_cast<ConditionType_t>(value);
			return true;
		}

		case COMBAT_PARAM_USECHARGES: {
			params.useCharges = (value != 0);
			return true;
		}
	}
	return false;
}

bool Combat::setCallback(CallBackParam_t key) {
	switch (key) {
		case CALLBACK_PARAM_LEVELMAGICVALUE: {
			params.valueCallback.reset(new ValueCallback(COMBAT_FORMULA_LEVELMAGIC));
			return true;
		}

		case CALLBACK_PARAM_SKILLVALUE: {
			params.valueCallback.reset(new ValueCallback(COMBAT_FORMULA_SKILL));
			return true;
		}

		case CALLBACK_PARAM_TARGETTILE: {
			params.tileCallback.reset(new TileCallback());
			return true;
		}

		case CALLBACK_PARAM_TARGETCREATURE: {
			params.targetCallback.reset(new TargetCallback());
			return true;
		}
	}
	return false;
}

CallBack* Combat::getCallback(CallBackParam_t key) {
	switch (key) {
		case CALLBACK_PARAM_LEVELMAGICVALUE:
		case CALLBACK_PARAM_SKILLVALUE: {
			return params.valueCallback.get();
		}

		case CALLBACK_PARAM_TARGETTILE: {
			return params.tileCallback.get();
		}

		case CALLBACK_PARAM_TARGETCREATURE: {
			return params.targetCallback.get();
		}
	}
	return nullptr;
}

void Combat::CombatHealthFunc(Creature* caster, Creature* target, const CombatParams &params, CombatDamage* data) {
	assert(data);
	CombatDamage damage = *data;

	Player* attackerPlayer = nullptr;
	if (caster) {
		attackerPlayer = caster->getPlayer();
	}

	Monster* targetMonster = nullptr;
	if (target) {
		targetMonster = target->getMonster();
	}

	Monster* attackerMonster = nullptr;
	if (caster) {
		attackerMonster = caster->getMonster();
	}

	Player* targetPlayer = nullptr;
	if (target) {
		targetPlayer = target->getPlayer();
	}

	if (caster && attackerPlayer) {
		Item* item = attackerPlayer->getWeapon();
		damage = applyImbuementElementalDamage(item, damage);
		g_events().eventPlayerOnCombat(attackerPlayer, target, item, damage);

		if (targetPlayer && targetPlayer->getSkull() != SKULL_BLACK) {
			if (damage.primary.type != COMBAT_HEALING) {
				damage.primary.value /= 2;
			}
			if (damage.secondary.type != COMBAT_HEALING) {
				damage.secondary.value /= 2;
			}
		}
	}

	if (g_game().combatBlockHit(damage, caster, target, params.blockedByShield, params.blockedByArmor, params.itemId != 0)) {
		return;
	}

	// Player attacking monster
	if (attackerPlayer && targetMonster) {
		const PreySlot* slot = attackerPlayer->getPreyWithMonster(targetMonster->getRaceId());
		if (slot && slot->isOccupied() && slot->bonus == PreyBonus_Damage && slot->bonusTimeLeft > 0) {
			damage.primary.value += static_cast<int32_t>(std::ceil((damage.primary.value * slot->bonusPercentage) / 100));
			damage.secondary.value += static_cast<int32_t>(std::ceil((damage.secondary.value * slot->bonusPercentage) / 100));
		}
	}

	// Monster attacking player
	if (attackerMonster && targetPlayer) {
		const PreySlot* slot = targetPlayer->getPreyWithMonster(attackerMonster->getRaceId());
		if (slot && slot->isOccupied() && slot->bonus == PreyBonus_Defense && slot->bonusTimeLeft > 0) {
			damage.primary.value -= static_cast<int32_t>(std::ceil((damage.primary.value * slot->bonusPercentage) / 100));
			damage.secondary.value -= static_cast<int32_t>(std::ceil((damage.secondary.value * slot->bonusPercentage) / 100));
		}
	}

	if (g_game().combatChangeHealth(caster, target, damage)) {
		CombatConditionFunc(caster, target, params, &damage);
		CombatDispelFunc(caster, target, params, nullptr);
	}
}

CombatDamage Combat::applyImbuementElementalDamage(Item* item, CombatDamage damage) {
	if (!item) {
		return damage;
	}

	for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); slotid++) {
		ImbuementInfo imbuementInfo;
		if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
			continue;
		}

		if (imbuementInfo.imbuement->combatType == COMBAT_NONE
			|| damage.primary.type == COMBAT_HEALING
			|| damage.secondary.type == COMBAT_HEALING) {
			continue;
		}

		float damagePercent = imbuementInfo.imbuement->elementDamage / 100.0;

		damage.secondary.type = imbuementInfo.imbuement->combatType;
		damage.primary.value = damage.primary.value * (1 - damagePercent);
		damage.secondary.value = damage.primary.value * (damagePercent);

		/* If damage imbuement is set, we can return without checking other slots */
		break;
	}

	return damage;
}

void Combat::CombatManaFunc(Creature* caster, Creature* target, const CombatParams &params, CombatDamage* data) {
	assert(data);
	CombatDamage damage = *data;
	if (damage.primary.value < 0) {
		if (caster && target && caster->getPlayer() && target->getSkull() != SKULL_BLACK && target->getPlayer()) {
			damage.primary.value /= 2;
		}
	}
	if (g_game().combatChangeMana(caster, target, damage)) {
		CombatConditionFunc(caster, target, params, nullptr);
		CombatDispelFunc(caster, target, params, nullptr);
	}
}

void Combat::CombatConditionFunc(Creature* caster, Creature* target, const CombatParams &params, CombatDamage* data) {
	if (params.origin == ORIGIN_MELEE && data && data->primary.value == 0 && data->secondary.value == 0) {
		return;
	}

	for (const auto &condition : params.conditionList) {
		Player* player = nullptr;
		if (target) {
			player = target->getPlayer();
		}
		// Cleanse charm rune (target as player)
		if (player) {
			if (player->isImmuneCleanse(condition->getType())) {
				player->sendCancelMessage("You are still immune against this spell.");
				return;
			} else if (caster && caster->getMonster()) {
				uint16_t playerCharmRaceid = player->parseRacebyCharm(CHARM_CLEANSE, false, 0);
				if (playerCharmRaceid != 0) {
					const MonsterType* mType = g_monsters().getMonsterType(caster->getName());
					if (mType && playerCharmRaceid == mType->info.raceid) {
						Charm* charm = g_iobestiary().getBestiaryCharm(CHARM_CLEANSE);
						if (charm && (charm->chance > normal_random(0, 100))) {
							if (player->hasCondition(condition->getType())) {
								player->removeCondition(condition->getType());
							}
							player->setImmuneCleanse(condition->getType());
							player->sendCancelMessage(charm->cancelMsg);
							return;
						}
					}
				}
			}
		}

		if (caster == target || target && !target->isImmune(condition->getType())) {
			Condition* conditionCopy = condition->clone();
			if (caster) {
				conditionCopy->setParam(CONDITION_PARAM_OWNER, caster->getID());
			}

			// TODO: infight condition until all aggressive conditions has ended
			if (target) {
				target->addCombatCondition(conditionCopy);
			}
		}
	}
}

void Combat::CombatDispelFunc(Creature*, Creature* target, const CombatParams &params, CombatDamage*) {
	if (target) {
		target->removeCombatCondition(params.dispelType);
	}
}

void Combat::CombatNullFunc(Creature* caster, Creature* target, const CombatParams &params, CombatDamage*) {
	CombatConditionFunc(caster, target, params, nullptr);
	CombatDispelFunc(caster, target, params, nullptr);
}

void Combat::combatTileEffects(const SpectatorHashSet &spectators, Creature* caster, Tile* tile, const CombatParams &params) {
	if (params.itemId != 0) {
		uint16_t itemId = params.itemId;
		switch (itemId) {
			case ITEM_FIREFIELD_PERSISTENT_FULL:
				itemId = ITEM_FIREFIELD_PVP_FULL;
				break;

			case ITEM_FIREFIELD_PERSISTENT_MEDIUM:
				itemId = ITEM_FIREFIELD_PVP_MEDIUM;
				break;

			case ITEM_FIREFIELD_PERSISTENT_SMALL:
				itemId = ITEM_FIREFIELD_PVP_SMALL;
				break;

			case ITEM_ENERGYFIELD_PERSISTENT:
				itemId = ITEM_ENERGYFIELD_PVP;
				break;

			case ITEM_POISONFIELD_PERSISTENT:
				itemId = ITEM_POISONFIELD_PVP;
				break;

			case ITEM_MAGICWALL_PERSISTENT:
				itemId = ITEM_MAGICWALL;
				break;

			case ITEM_WILDGROWTH_PERSISTENT:
				itemId = ITEM_WILDGROWTH;
				break;

			default:
				break;
		}

		if (caster) {
			Player* casterPlayer;
			if (caster->isSummon()) {
				casterPlayer = caster->getMaster()->getPlayer();
			} else {
				casterPlayer = caster->getPlayer();
			}

			if (casterPlayer) {
				if (g_game().getWorldType() == WORLD_TYPE_NO_PVP || tile->hasFlag(TILESTATE_NOPVPZONE)) {
					if (itemId == ITEM_FIREFIELD_PVP_FULL) {
						itemId = ITEM_FIREFIELD_NOPVP;
					} else if (itemId == ITEM_POISONFIELD_PVP) {
						itemId = ITEM_POISONFIELD_NOPVP;
					} else if (itemId == ITEM_ENERGYFIELD_PVP) {
						itemId = ITEM_ENERGYFIELD_NOPVP;
					} else if (itemId == ITEM_MAGICWALL) {
						itemId = ITEM_MAGICWALL_SAFE;
					} else if (itemId == ITEM_WILDGROWTH) {
						itemId = ITEM_WILDGROWTH_SAFE;
					}
				} else if (itemId == ITEM_FIREFIELD_PVP_FULL || itemId == ITEM_POISONFIELD_PVP || itemId == ITEM_ENERGYFIELD_PVP || itemId == ITEM_MAGICWALL || itemId == ITEM_WILDGROWTH) {
					casterPlayer->addInFightTicks();
				}
			}
		}

		Item* item = Item::CreateItem(itemId);
		if (caster) {
			item->setAttribute(ItemAttribute_t::OWNER, caster->getID());
		}

		ReturnValue ret = g_game().internalAddItem(tile, item);
		if (ret == RETURNVALUE_NOERROR) {
			item->startDecaying();
		} else {
			delete item;
		}
	}

	if (params.tileCallback) {
		params.tileCallback->onTileCombat(caster, tile);
	}

	if (params.impactEffect != CONST_ME_NONE) {
		Game::addMagicEffect(spectators, tile->getPosition(), params.impactEffect);
	}
}

void Combat::postCombatEffects(Creature* caster, const Position &pos, const CombatParams &params) {
	if (caster && params.distanceEffect != CONST_ANI_NONE) {
		addDistanceEffect(caster, caster->getPosition(), pos, params.distanceEffect);
	}
}

void Combat::addDistanceEffect(Creature* caster, const Position &fromPos, const Position &toPos, uint8_t effect) {
	if (effect == CONST_ANI_WEAPONTYPE) {
		if (!caster) {
			return;
		}

		Player* player = caster->getPlayer();
		if (!player) {
			return;
		}

		switch (player->getWeaponType()) {
			case WEAPON_AXE:
				effect = CONST_ANI_WHIRLWINDAXE;
				break;
			case WEAPON_SWORD:
				effect = CONST_ANI_WHIRLWINDSWORD;
				break;
			case WEAPON_CLUB:
				effect = CONST_ANI_WHIRLWINDCLUB;
				break;
			default:
				effect = CONST_ANI_NONE;
				break;
		}
	}

	if (effect != CONST_ANI_NONE) {
		g_game().addDistanceEffect(fromPos, toPos, effect);
	}
}

void Combat::doCombat(Creature* caster, Creature* target) const {
	// target combat callback function
	if (params.combatType != COMBAT_NONE) {
		CombatDamage damage = getCombatDamage(caster, target);
		if (damage.primary.type != COMBAT_MANADRAIN) {
			doCombatHealth(caster, target, damage, params);
		} else {
			doCombatMana(caster, target, damage, params);
		}
	} else {
		doCombatDefault(caster, target, params);
	}
}

void Combat::doCombat(Creature* caster, const Position &position) const {
	// area combat callback function
	if (params.combatType != COMBAT_NONE) {
		CombatDamage damage = getCombatDamage(caster, nullptr);
		if (damage.primary.type != COMBAT_MANADRAIN) {
			doCombatHealth(caster, position, area.get(), damage, params);
		} else {
			doCombatMana(caster, position, area.get(), damage, params);
		}
	} else {
		CombatFunc(caster, position, area.get(), params, CombatNullFunc, nullptr);
	}
}

void Combat::CombatFunc(Creature* caster, const Position &pos, const AreaCombat* area, const CombatParams &params, CombatFunction func, CombatDamage* data) {
	std::forward_list<Tile*> tileList;

	if (caster) {
		getCombatArea(caster->getPosition(), pos, area, tileList);
	} else {
		getCombatArea(pos, pos, area, tileList);
	}

	SpectatorHashSet spectators;
	uint32_t maxX = 0;
	uint32_t maxY = 0;

	// calculate the max viewable range
	for (Tile* tile : tileList) {
		const Position &tilePos = tile->getPosition();

		uint32_t diff = Position::getDistanceX(tilePos, pos);
		if (diff > maxX) {
			maxX = diff;
		}

		diff = Position::getDistanceY(tilePos, pos);
		if (diff > maxY) {
			maxY = diff;
		}
	}

	const int32_t rangeX = maxX + Map::maxViewportX;
	const int32_t rangeY = maxY + Map::maxViewportY;
	g_game().map.getSpectators(spectators, pos, true, true, rangeX, rangeX, rangeY, rangeY);

	int affected = 0;
	for (Tile* tile : tileList) {
		if (canDoCombat(caster, tile, params.aggressive) != RETURNVALUE_NOERROR) {
			continue;
		}

		if (CreatureVector* creatures = tile->getCreatures()) {
			const Creature* topCreature = tile->getTopCreature();
			for (Creature* creature : *creatures) {
				if (params.targetCasterOrTopMost) {
					if (caster && caster->getTile() == tile) {
						if (creature != caster) {
							continue;
						}
					} else if (creature != topCreature) {
						continue;
					}
				}

				if (!params.aggressive || (caster != creature && Combat::canDoCombat(caster, creature) == RETURNVALUE_NOERROR)) {
					affected++;
				}
			}
		}
	}
	//
	CombatDamage tmpDamage;
	if (data) {
		tmpDamage.origin = data->origin;
		tmpDamage.primary.type = data->primary.type;
		tmpDamage.primary.value = data->primary.value;
		tmpDamage.secondary.type = data->secondary.type;
		tmpDamage.secondary.value = data->secondary.value;
		tmpDamage.critical = data->critical;
		tmpDamage.fatal = data->fatal;
		tmpDamage.criticalDamage = data->criticalDamage;
		tmpDamage.criticalChance = data->criticalChance;
		tmpDamage.damageMultiplier = data->damageMultiplier;
		tmpDamage.damageReductionMultiplier = data->damageReductionMultiplier;
		tmpDamage.healingMultiplier = data->healingMultiplier;
		tmpDamage.manaLeech = data->manaLeech;
		tmpDamage.lifeLeech = data->lifeLeech;
		tmpDamage.healingLink = data->healingLink;
		tmpDamage.instantSpellName = data->instantSpellName;
		tmpDamage.runeSpellName = data->runeSpellName;
		tmpDamage.lifeLeechChance = data->lifeLeechChance;
		tmpDamage.manaLeechChance = data->manaLeechChance;
	}

	// Wheel of destiny
	uint8_t beamAffectedTotal = 0;
	uint8_t beamAffectedCurrent = 0;
	Player* casterPlayer = caster ? caster->getPlayer() : nullptr;
	if (casterPlayer && tmpDamage.runeSpellName == "Beam Mastery" && casterPlayer->getWheelOfDestinyInstant("Beam Mastery")) {
		beamAffectedTotal = 3;
	}

	tmpDamage.affected = affected;
	for (Tile* tile : tileList) {
		if (canDoCombat(caster, tile, params.aggressive) != RETURNVALUE_NOERROR) {
			continue;
		}

		if (CreatureVector* creatures = tile->getCreatures()) {
			const Creature* topCreature = tile->getTopCreature();
			for (Creature* creature : *creatures) {
				if (params.targetCasterOrTopMost) {
					if (caster && caster->getTile() == tile) {
						if (creature != caster) {
							continue;
						}
					} else if (creature != topCreature) {
						continue;
					}
				}

				if (!params.aggressive || (caster != creature && Combat::canDoCombat(caster, creature) == RETURNVALUE_NOERROR)) {
					if (casterPlayer && beamAffectedTotal > 0) {
						tmpDamage.damageMultiplier += casterPlayer->checkWheelOfDestinyBeamMasteryDamage();
						--beamAffectedTotal;
						beamAffectedCurrent++;
					}
					func(caster, creature, params, &tmpDamage);
					if (params.targetCallback) {
						params.targetCallback->onTargetCombat(caster, creature);
					}

					if (params.targetCasterOrTopMost) {
						break;
					}
				}
			}
		}
		combatTileEffects(spectators, caster, tile, params);
	}

	if (casterPlayer && !casterPlayer->isRemoved() && beamAffectedCurrent > 0) {
		casterPlayer->reduceAllSpellsCooldownTimer(beamAffectedCurrent * 1000);
	}

	postCombatEffects(caster, pos, params);
}

void Combat::doCombatHealth(Creature* caster, Creature* target, CombatDamage &damage, const CombatParams &params) {
	bool canCombat = !params.aggressive || (caster != target && Combat::canDoCombat(caster, target) == RETURNVALUE_NOERROR);
	if ((caster && target)
		&& (caster == target || canCombat)
		&& (params.impactEffect != CONST_ME_NONE)) {
		g_game().addMagicEffect(target->getPosition(), params.impactEffect);
	}

	if (target && params.combatType == COMBAT_HEALING && target->getMonster()) {
		if (target != caster) {
			return;
		}
	}

	if (caster && caster->getPlayer()) {
		// Critical damage
		uint16_t chance = caster->getPlayer()->getSkillLevel(SKILL_CRITICAL_HIT_CHANCE) + damage.criticalChance;
		// Charm low blow rune)
		if (!damage.cleave && target && target->getMonster() && damage.primary.type != COMBAT_HEALING) {
			uint16_t playerCharmRaceid = caster->getPlayer()->parseRacebyCharm(CHARM_LOW, false, 0);
			if (playerCharmRaceid != 0) {
				const MonsterType* mType = g_monsters().getMonsterType(target->getName());
				if (mType && playerCharmRaceid == mType->info.raceid) {
					Charm* charm = g_iobestiary().getBestiaryCharm(CHARM_LOW);
					if (charm) {
						chance += charm->percent;
					}
				}
			}
		}
		if (chance != 0 && uniform_random(1, 100) <= chance) {
			damage.critical = true;
			damage.primary.value += (damage.primary.value * (caster->getPlayer()->getSkillLevel(SKILL_CRITICAL_HIT_DAMAGE) + damage.criticalDamage)) / 100;
			damage.secondary.value += (damage.secondary.value * (caster->getPlayer()->getSkillLevel(SKILL_CRITICAL_HIT_DAMAGE) + damage.criticalDamage)) / 100;
		}

		// Fatal hit (onslaught)
		if (auto playerWeapon = caster->getPlayer()->getInventoryItem(CONST_SLOT_LEFT);
			playerWeapon != nullptr && playerWeapon->getTier()) {
			double_t fatalChance = playerWeapon->getFatalChance();
			double_t randomChance = uniform_random(0, 10000) / 100;
			if (damage.primary.type != COMBAT_HEALING && fatalChance > 0 && randomChance < fatalChance) {
				damage.fatal = true;
				damage.primary.value += static_cast<int32_t>(std::round(damage.primary.value * 0.6));
				damage.secondary.value += static_cast<int32_t>(std::round(damage.secondary.value * 0.6));
			}
		}
	}
	if (canCombat) {
		if (target && caster && params.distanceEffect != CONST_ANI_NONE) {
			addDistanceEffect(caster, caster->getPosition(), target->getPosition(), params.distanceEffect);
		}

		CombatHealthFunc(caster, target, params, &damage);
		if (params.targetCallback) {
			params.targetCallback->onTargetCombat(caster, target);
		}
	}
}

void Combat::doCombatHealth(Creature* caster, const Position &position, const AreaCombat* area, CombatDamage &damage, const CombatParams &params) {
	if (caster && caster->getPlayer()) {
		// Critical damage
		uint16_t chance = caster->getPlayer()->getSkillLevel(SKILL_CRITICAL_HIT_CHANCE) + damage.criticalChance;
		if (damage.primary.type != COMBAT_HEALING && chance != 0 && uniform_random(1, 100) <= chance) {
			damage.critical = true;
			damage.primary.value += (damage.primary.value * (caster->getPlayer()->getSkillLevel(SKILL_CRITICAL_HIT_DAMAGE) + damage.criticalDamage)) / 100;
			damage.secondary.value += (damage.secondary.value * (caster->getPlayer()->getSkillLevel(SKILL_CRITICAL_HIT_DAMAGE) + damage.criticalDamage)) / 100;
		}

		// Fatal hit (onslaught)
		if (auto playerWeapon = caster->getPlayer()->getInventoryItem(CONST_SLOT_LEFT);
			playerWeapon != nullptr && playerWeapon->getTier() > 0) {
			double_t fatalChance = playerWeapon->getFatalChance();
			double_t randomChance = uniform_random(0, 10000) / 100;
			if (damage.primary.type != COMBAT_HEALING && fatalChance > 0 && randomChance < fatalChance) {
				damage.fatal = true;
				damage.primary.value += static_cast<int32_t>(std::round(damage.primary.value * 0.6));
				damage.secondary.value += static_cast<int32_t>(std::round(damage.secondary.value * 0.6));
			}
		}
	}
	CombatFunc(caster, position, area, params, CombatHealthFunc, &damage);
}

void Combat::doCombatMana(Creature* caster, Creature* target, CombatDamage &damage, const CombatParams &params) {
	bool canCombat = !params.aggressive || (caster != target && Combat::canDoCombat(caster, target) == RETURNVALUE_NOERROR);
	if ((caster && target)
		&& (caster == target || canCombat)
		&& (params.impactEffect != CONST_ME_NONE)) {
		g_game().addMagicEffect(target->getPosition(), params.impactEffect);
	}

	if (caster && caster->getPlayer()) {
		// Critical damage
		uint16_t chance = caster->getPlayer()->getSkillLevel(SKILL_CRITICAL_HIT_CHANCE) + damage.criticalChance;
		if (chance != 0 && uniform_random(1, 100) <= chance) {
			damage.critical = true;
			damage.primary.value += (damage.primary.value * (caster->getPlayer()->getSkillLevel(SKILL_CRITICAL_HIT_DAMAGE) + damage.criticalDamage)) / 100;
			damage.secondary.value += (damage.secondary.value * (caster->getPlayer()->getSkillLevel(SKILL_CRITICAL_HIT_DAMAGE) + damage.criticalDamage)) / 100;
		}
	}

	if (canCombat) {
		if (caster && target && params.distanceEffect != CONST_ANI_NONE) {
			addDistanceEffect(caster, caster->getPosition(), target->getPosition(), params.distanceEffect);
		}

		CombatManaFunc(caster, target, params, &damage);
		if (params.targetCallback) {
			params.targetCallback->onTargetCombat(caster, target);
		}
	}
}

void Combat::doCombatMana(Creature* caster, const Position &position, const AreaCombat* area, CombatDamage &damage, const CombatParams &params) {
	if (caster && caster->getPlayer()) {
		// Critical damage
		uint16_t chance = caster->getPlayer()->getSkillLevel(SKILL_CRITICAL_HIT_CHANCE) + damage.criticalChance;
		if (chance != 0 && uniform_random(1, 100) <= chance) {
			damage.critical = true;
			damage.primary.value += (damage.primary.value * (caster->getPlayer()->getSkillLevel(SKILL_CRITICAL_HIT_DAMAGE) + damage.criticalDamage)) / 100;
			damage.secondary.value += (damage.secondary.value * (caster->getPlayer()->getSkillLevel(SKILL_CRITICAL_HIT_DAMAGE) + damage.criticalDamage)) / 100;
		}
	}
	CombatFunc(caster, position, area, params, CombatManaFunc, &damage);
}

void Combat::doCombatCondition(Creature* caster, const Position &position, const AreaCombat* area, const CombatParams &params) {
	CombatFunc(caster, position, area, params, CombatConditionFunc, nullptr);
}

void Combat::doCombatCondition(Creature* caster, Creature* target, const CombatParams &params) {
	bool canCombat = !params.aggressive || (caster != target && Combat::canDoCombat(caster, target) == RETURNVALUE_NOERROR);
	if ((caster == target || canCombat) && params.impactEffect != CONST_ME_NONE) {
		g_game().addMagicEffect(target->getPosition(), params.impactEffect);
	}

	if (canCombat) {
		if (caster && target && params.distanceEffect != CONST_ANI_NONE) {
			addDistanceEffect(caster, caster->getPosition(), target->getPosition(), params.distanceEffect);
		}

		CombatConditionFunc(caster, target, params, nullptr);
		if (params.targetCallback) {
			params.targetCallback->onTargetCombat(caster, target);
		}
	}
}

void Combat::doCombatDispel(Creature* caster, const Position &position, const AreaCombat* area, const CombatParams &params) {
	CombatFunc(caster, position, area, params, CombatDispelFunc, nullptr);
}

void Combat::doCombatDispel(Creature* caster, Creature* target, const CombatParams &params) {
	bool canCombat = !params.aggressive || (caster != target && Combat::canDoCombat(caster, target) == RETURNVALUE_NOERROR);
	if ((caster && target)
		&& (caster == target || canCombat)
		&& (params.impactEffect != CONST_ME_NONE)) {
		g_game().addMagicEffect(target->getPosition(), params.impactEffect);
	}

	if (canCombat) {
		CombatDispelFunc(caster, target, params, nullptr);
		if (params.targetCallback) {
			params.targetCallback->onTargetCombat(caster, target);
		}

		if (target && caster && params.distanceEffect != CONST_ANI_NONE) {
			addDistanceEffect(caster, caster->getPosition(), target->getPosition(), params.distanceEffect);
		}
	}
}

void Combat::doCombatDefault(Creature* caster, Creature* target, const CombatParams &params) {
	if (!params.aggressive || (caster != target && Combat::canDoCombat(caster, target) == RETURNVALUE_NOERROR)) {
		SpectatorHashSet spectators;
		g_game().map.getSpectators(spectators, target->getPosition(), true, true);

		CombatNullFunc(caster, target, params, nullptr);
		combatTileEffects(spectators, caster, target->getTile(), params);

		if (params.targetCallback) {
			params.targetCallback->onTargetCombat(caster, target);
		}

		/*
		if (params.impactEffect != CONST_ME_NONE) {
			g_game().addMagicEffect(target->getPosition(), params.impactEffect);
		}
		*/

		if (caster && params.distanceEffect != CONST_ANI_NONE) {
			addDistanceEffect(caster, caster->getPosition(), target->getPosition(), params.distanceEffect);
		}
	}
}

//**********************************************************//

void ValueCallback::getMinMaxValues(Player* player, CombatDamage &damage, bool useCharges) const {
	// onGetPlayerMinMaxValues(...)
	if (!scriptInterface->reserveScriptEnv()) {
		SPDLOG_ERROR("[ValueCallback::getMinMaxValues - Player {} formula {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 player->getName(), type);
		return;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	if (!env->setCallbackId(scriptId, scriptInterface)) {
		scriptInterface->resetScriptEnv();
		return;
	}

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(scriptId);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	int16_t elementAttack = 0; // To calculate elemental damage after executing spell script and get real damage.
	int32_t attackValue = 7; // default start attack value
	int parameters = 1;
	bool shouldCalculateSecondaryDamage = false;

	switch (type) {
		case COMBAT_FORMULA_LEVELMAGIC: {
			// onGetPlayerMinMaxValues(player, level, maglevel)
			uint32_t magicLevelSkill = (player->getMagicLevel() + player->getSpecializedMagicLevel(damage.primary.type));
			// Wheel of destiny
			if (player && player->getWheelOfDestinyInstant("Runic Mastery") && damage.instantSpellName.empty()) {
				if (normal_random(0, 100) <= 25) {
					Spell* spell = g_spells().getRuneSpellByName(damage.runeSpellName);
					if (spell) {
						// Yeah, im using rune name on instant. This happens because rune conjuring spell have the same name as the rune item spell.
						InstantSpell* conjuringSpell = g_spells().getInstantSpellByName(damage.runeSpellName);
						if (conjuringSpell && conjuringSpell != spell) {
							magicLevelSkill += std::ceil((static_cast<double>(magicLevelSkill) * (conjuringSpell->canCast(player) ? 20 : 10)) / 100.);
						}
					}
				}
			}
			lua_pushnumber(L, player->getLevel());
			lua_pushnumber(L, magicLevelSkill);
			parameters += 2;
			break;
		}

		case COMBAT_FORMULA_SKILL: {
			// onGetPlayerMinMaxValues(player, attackSkill, attackValue, attackFactor)
			Item* tool = player->getWeapon();
			const Weapon* weapon = g_weapons().getWeapon(tool);
			Item* item = nullptr;

			if (weapon) {
				attackValue = tool->getAttack();
				if (tool->getWeaponType() == WEAPON_AMMO) {
					item = player->getWeapon(true);
					if (item) {
						attackValue += item->getAttack();
					}
				}

				CombatType_t elementType = weapon->getElementType();
				damage.secondary.type = elementType;

				if (elementType != COMBAT_NONE) {
					if (weapon) {
						elementAttack = weapon->getElementDamageValue();
						shouldCalculateSecondaryDamage = true;
						attackValue += elementAttack;
					}
				} else {
					shouldCalculateSecondaryDamage = false;
				}

				if (useCharges) {
					auto charges = tool->getAttribute<uint16_t>(ItemAttribute_t::CHARGES);
					if (charges != 0) {
						g_game().transformItem(tool, tool->getID(), charges - 1);
					}
				}
			}

			lua_pushnumber(L, player->getWeaponSkill(item ? item : tool));
			lua_pushnumber(L, attackValue);
			lua_pushnumber(L, player->getAttackFactor());
			parameters += 3;
			break;
		}

		default: {
			SPDLOG_WARN("[ValueCallback::getMinMaxValues] - Unknown callback type");
			scriptInterface->resetScriptEnv();
			return;
		}
	}

	int size0 = lua_gettop(L);
	if (lua_pcall(L, parameters, 2, 0) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {

		int32_t defaultDmg = normal_random(
			LuaScriptInterface::getNumber<int32_t>(L, -2),
			LuaScriptInterface::getNumber<int32_t>(L, -1)
		);

		if (shouldCalculateSecondaryDamage) {
			double factor = (double)elementAttack / (double)attackValue; // attack value here is phys dmg + element dmg
			int32_t elementDamage = std::round(defaultDmg * factor);
			int32_t physDmg = std::round(defaultDmg * (1.0 - factor));
			damage.primary.value = physDmg;
			damage.secondary.value = elementDamage;

		} else {
			damage.primary.value = defaultDmg;
			damage.secondary.type = COMBAT_NONE;
			damage.secondary.value = 0;
		}

		lua_pop(L, 2);
	}

	if ((lua_gettop(L) + parameters + 1) != size0) {
		LuaScriptInterface::reportError(nullptr, "Stack size changed!");
	}

	scriptInterface->resetScriptEnv();
}

//**********************************************************//

void TileCallback::onTileCombat(Creature* creature, Tile* tile) const {
	// onTileCombat(creature, pos)
	if (!scriptInterface->reserveScriptEnv()) {
		SPDLOG_ERROR("[TileCallback::onTileCombat - Creature {} type {} on tile x: {} y: {} z: {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 creature->getName(), type, (tile->getPosition()).getX(), (tile->getPosition()).getY(), (tile->getPosition()).getZ());
		return;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	if (!env->setCallbackId(scriptId, scriptInterface)) {
		scriptInterface->resetScriptEnv();
		return;
	}

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(scriptId);
	if (creature) {
		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}
	LuaScriptInterface::pushPosition(L, tile->getPosition());

	scriptInterface->callFunction(2);
}

//**********************************************************//

void TargetCallback::onTargetCombat(Creature* creature, Creature* target) const {
	// onTargetCombat(creature, target)
	if (!scriptInterface->reserveScriptEnv()) {
		SPDLOG_ERROR("[TargetCallback::onTargetCombat - Creature {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 creature->getName());
		return;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	if (!env->setCallbackId(scriptId, scriptInterface)) {
		scriptInterface->resetScriptEnv();
		return;
	}

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(scriptId);

	if (creature) {
		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}

	if (target) {
		LuaScriptInterface::pushUserdata<Creature>(L, target);
		LuaScriptInterface::setCreatureMetatable(L, -1, target);
	} else {
		lua_pushnil(L);
	}

	int size0 = lua_gettop(L);

	if (lua_pcall(L, 2, 0 /*nReturnValues*/, 0) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	}

	if ((lua_gettop(L) + 2 /*nParams*/ + 1) != size0) {
		LuaScriptInterface::reportError(nullptr, "Stack size changed!");
	}

	scriptInterface->resetScriptEnv();
}

//**********************************************************//

void AreaCombat::clear() {
	for (const auto &it : areas) {
		delete it.second;
	}
	areas.clear();
}

AreaCombat::AreaCombat(const AreaCombat &rhs) {
	hasExtArea = rhs.hasExtArea;
	for (const auto &it : rhs.areas) {
		areas[it.first] = new MatrixArea(*it.second);
	}
}

void AreaCombat::getList(const Position &centerPos, const Position &targetPos, std::forward_list<Tile*> &list) const {
	const MatrixArea* area = getArea(centerPos, targetPos);
	if (!area) {
		return;
	}

	uint32_t centerY, centerX;
	area->getCenter(centerY, centerX);

	Position tmpPos(targetPos.x - centerX, targetPos.y - centerY, targetPos.z);
	uint32_t cols = area->getCols();
	for (uint32_t y = 0, rows = area->getRows(); y < rows; ++y) {
		for (uint32_t x = 0; x < cols; ++x) {
			if (area->getValue(y, x) != 0 && g_game().isSightClear(targetPos, tmpPos, true)) {
				Tile* tile = g_game().map.getTile(tmpPos);
				if (!tile) {
					tile = new StaticTile(tmpPos.x, tmpPos.y, tmpPos.z);
					g_game().map.setTile(tmpPos, tile);
				}
				list.push_front(tile);
			}
			tmpPos.x++;
		}
		tmpPos.x -= cols;
		tmpPos.y++;
	}
}

void AreaCombat::copyArea(const MatrixArea* input, MatrixArea* output, MatrixOperation_t op) const {
	uint32_t centerY, centerX;
	input->getCenter(centerY, centerX);

	if (op == MATRIXOPERATION_COPY) {
		for (uint32_t y = 0; y < input->getRows(); ++y) {
			for (uint32_t x = 0; x < input->getCols(); ++x) {
				(*output)[y][x] = (*input)[y][x];
			}
		}

		output->setCenter(centerY, centerX);
	} else if (op == MATRIXOPERATION_MIRROR) {
		for (uint32_t y = 0; y < input->getRows(); ++y) {
			uint32_t rx = 0;
			for (int32_t x = input->getCols(); --x >= 0;) {
				(*output)[y][rx++] = (*input)[y][x];
			}
		}

		output->setCenter(centerY, (input->getRows() - 1) - centerX);
	} else if (op == MATRIXOPERATION_FLIP) {
		for (uint32_t x = 0; x < input->getCols(); ++x) {
			uint32_t ry = 0;
			for (int32_t y = input->getRows(); --y >= 0;) {
				(*output)[ry++][x] = (*input)[y][x];
			}
		}

		output->setCenter((input->getCols() - 1) - centerY, centerX);
	} else {
		// rotation
		int32_t rotateCenterX = (output->getCols() / 2) - 1;
		int32_t rotateCenterY = (output->getRows() / 2) - 1;
		int32_t angle;

		switch (op) {
			case MATRIXOPERATION_ROTATE90:
				angle = 90;
				break;

			case MATRIXOPERATION_ROTATE180:
				angle = 180;
				break;

			case MATRIXOPERATION_ROTATE270:
				angle = 270;
				break;

			default:
				angle = 0;
				break;
		}

		double angleRad = M_PI * angle / 180.0;

		double a = std::cos(angleRad);
		double b = -std::sin(angleRad);
		double c = std::sin(angleRad);
		double d = std::cos(angleRad);

		const uint32_t rows = input->getRows();
		for (uint32_t x = 0, cols = input->getCols(); x < cols; ++x) {
			for (uint32_t y = 0; y < rows; ++y) {
				// calculate new coordinates using rotation center
				int32_t newX = x - centerX;
				int32_t newY = y - centerY;

				// perform rotation
				int32_t rotatedX = static_cast<int32_t>(round(newX * a + newY * b));
				int32_t rotatedY = static_cast<int32_t>(round(newX * c + newY * d));

				// write in the output matrix using rotated coordinates
				(*output)[rotatedY + rotateCenterY][rotatedX + rotateCenterX] = (*input)[y][x];
			}
		}

		output->setCenter(rotateCenterY, rotateCenterX);
	}
}

MatrixArea* AreaCombat::createArea(const std::list<uint32_t> &list, uint32_t rows) {
	uint32_t cols;
	if (rows == 0) {
		cols = 0;
	} else {
		cols = list.size() / rows;
	}

	MatrixArea* area = new MatrixArea(rows, cols);

	uint32_t x = 0;
	uint32_t y = 0;

	for (uint32_t value : list) {
		if (value == 1 || value == 3) {
			area->setValue(y, x, true);
		}

		if (value == 2 || value == 3) {
			area->setCenter(y, x);
		}

		++x;

		if (cols == x) {
			x = 0;
			++y;
		}
	}
	return area;
}

void AreaCombat::setupArea(const std::list<uint32_t> &list, uint32_t rows) {
	MatrixArea* area = createArea(list, rows);

	// NORTH
	areas[DIRECTION_NORTH] = area;

	uint32_t maxOutput = std::max<uint32_t>(area->getCols(), area->getRows()) * 2;

	// SOUTH
	MatrixArea* southArea = new MatrixArea(maxOutput, maxOutput);
	copyArea(area, southArea, MATRIXOPERATION_ROTATE180);
	areas[DIRECTION_SOUTH] = southArea;

	// EAST
	MatrixArea* eastArea = new MatrixArea(maxOutput, maxOutput);
	copyArea(area, eastArea, MATRIXOPERATION_ROTATE90);
	areas[DIRECTION_EAST] = eastArea;

	// WEST
	MatrixArea* westArea = new MatrixArea(maxOutput, maxOutput);
	copyArea(area, westArea, MATRIXOPERATION_ROTATE270);
	areas[DIRECTION_WEST] = westArea;
}

void AreaCombat::setupArea(int32_t length, int32_t spread) {
	std::list<uint32_t> list;

	uint32_t rows = length;
	int32_t cols = 1;

	if (spread != 0) {
		cols = ((length - (length % spread)) / spread) * 2 + 1;
	}

	int32_t colSpread = cols;

	for (uint32_t y = 1; y <= rows; ++y) {
		int32_t mincol = cols - colSpread + 1;
		int32_t maxcol = cols - (cols - colSpread);

		for (int32_t x = 1; x <= cols; ++x) {
			if (y == rows && x == ((cols - (cols % 2)) / 2) + 1) {
				list.push_back(3);
			} else if (x >= mincol && x <= maxcol) {
				list.push_back(1);
			} else {
				list.push_back(0);
			}
		}

		if (spread > 0 && y % spread == 0) {
			--colSpread;
		}
	}

	setupArea(list, rows);
}

void AreaCombat::setupArea(int32_t radius) {
	int32_t area[13][13] = {
		{ 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 8, 8, 7, 8, 8, 0, 0, 0, 0 },
		{ 0, 0, 0, 8, 7, 6, 6, 6, 7, 8, 0, 0, 0 },
		{ 0, 0, 8, 7, 6, 5, 5, 5, 6, 7, 8, 0, 0 },
		{ 0, 8, 7, 6, 5, 4, 4, 4, 5, 6, 7, 8, 0 },
		{ 0, 8, 6, 5, 4, 3, 2, 3, 4, 5, 6, 8, 0 },
		{ 8, 7, 6, 5, 4, 2, 1, 2, 4, 5, 6, 7, 8 },
		{ 0, 8, 6, 5, 4, 3, 2, 3, 4, 5, 6, 8, 0 },
		{ 0, 8, 7, 6, 5, 4, 4, 4, 5, 6, 7, 8, 0 },
		{ 0, 0, 8, 7, 6, 5, 5, 5, 6, 7, 8, 0, 0 },
		{ 0, 0, 0, 8, 7, 6, 6, 6, 7, 8, 0, 0, 0 },
		{ 0, 0, 0, 0, 8, 8, 7, 8, 8, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0 }
	};

	std::list<uint32_t> list;

	for (auto &row : area) {
		for (int cell : row) {
			if (cell == 1) {
				list.push_back(3);
			} else if (cell > 0 && cell <= radius) {
				list.push_back(1);
			} else {
				list.push_back(0);
			}
		}
	}

	setupArea(list, 13);
}

void AreaCombat::setupExtArea(const std::list<uint32_t> &list, uint32_t rows) {
	if (list.empty()) {
		return;
	}

	hasExtArea = true;
	MatrixArea* area = createArea(list, rows);

	// NORTH-WEST
	areas[DIRECTION_NORTHWEST] = area;

	uint32_t maxOutput = std::max<uint32_t>(area->getCols(), area->getRows()) * 2;

	// NORTH-EAST
	MatrixArea* neArea = new MatrixArea(maxOutput, maxOutput);
	copyArea(area, neArea, MATRIXOPERATION_MIRROR);
	areas[DIRECTION_NORTHEAST] = neArea;

	// SOUTH-WEST
	MatrixArea* swArea = new MatrixArea(maxOutput, maxOutput);
	copyArea(area, swArea, MATRIXOPERATION_FLIP);
	areas[DIRECTION_SOUTHWEST] = swArea;

	// SOUTH-EAST
	MatrixArea* seArea = new MatrixArea(maxOutput, maxOutput);
	copyArea(swArea, seArea, MATRIXOPERATION_MIRROR);
	areas[DIRECTION_SOUTHEAST] = seArea;
}

//**********************************************************//

void MagicField::onStepInField(Creature &creature) {
	// remove magic walls/wild growth
	if (!isBlocking() && g_game().getWorldType() == WORLD_TYPE_NO_PVP && id == ITEM_MAGICWALL_SAFE || id == ITEM_WILDGROWTH_SAFE) {
		if (!creature.isInGhostMode()) {
			g_game().internalRemoveItem(this, 1);
		}

		return;
	}

	const ItemType &it = items[getID()];
	if (it.conditionDamage) {
		Condition* conditionCopy = it.conditionDamage->clone();
		auto ownerId = getAttribute<uint32_t>(ItemAttribute_t::OWNER);
		if (ownerId) {
			bool harmfulField = true;

			if (g_game().getWorldType() == WORLD_TYPE_NO_PVP || getTile()->hasFlag(TILESTATE_NOPVPZONE)) {
				Creature* owner = g_game().getCreatureByID(ownerId);
				if (owner) {
					if (owner->getPlayer() || (owner->isSummon() && owner->getMaster()->getPlayer())) {
						harmfulField = false;
					}
				}
			}

			Player* targetPlayer = creature.getPlayer();
			if (targetPlayer) {
				const Player* attackerPlayer = g_game().getPlayerByID(ownerId);
				if (attackerPlayer) {
					if (Combat::isProtected(attackerPlayer, targetPlayer)) {
						harmfulField = false;
					}
				}
			}

			if (!harmfulField || (OTSYS_TIME() - createTime <= 5000) || creature.hasBeenAttacked(ownerId)) {
				conditionCopy->setParam(CONDITION_PARAM_OWNER, ownerId);
			}
		}

		creature.addCondition(conditionCopy);
	}
}
