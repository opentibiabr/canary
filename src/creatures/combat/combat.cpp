/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 * Copyright (C) 2019-2021 Saiyans King
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "otpch.h"

#include "declarations.hpp"
#include "creatures/combat/combat.h"
#include "lua/creature/events.h"
#include "game/game.h"
#include "io/iobestiary.h"
#include "creatures/monsters/monster.h"
#include "creatures/monsters/monsters.h"
#include "items/weapons/weapons.h"

extern Game g_game;
extern Weapons* g_weapons;
extern Events* g_events;
extern Monsters g_monsters;

CombatDamage Combat::getCombatDamage(Creature* creature, Creature* target) const
{
	CombatDamage damage;
	damage.origin = params.origin;
	damage.primary.type = params.combatType;
	if (formulaType == COMBAT_FORMULA_DAMAGE) {
		damage.primary.value = normal_random(mina, maxa);
	} else if (creature) {
		int32_t min, max;
		if (creature->getCombatValues(min, max)) {
			damage.primary.value = normal_random(min, max);
		} else if (Player* player = creature->getPlayer()) {
			if (params.valueCallback) {
				params.valueCallback->getMinMaxValues(player, damage, params.useCharges);
			} else if (formulaType == COMBAT_FORMULA_LEVELMAGIC) {
				int32_t levelFormula = player->getLevel() * 2 + player->getMagicLevel() * 3;
				damage.primary.value = normal_random(std::fma(levelFormula, mina, minb), std::fma(levelFormula, maxa, maxb));
			} else if (formulaType == COMBAT_FORMULA_SKILL) {
				Item* tool = player->getWeapon();
				const Weapon* weapon = g_weapons->getWeapon(tool);
				if (weapon) {
					damage.primary.value = normal_random(minb, std::fma(weapon->getWeaponDamage(player, target, tool, true), maxa, maxb));
					damage.secondary.type = weapon->getElementType();
					damage.secondary.value = weapon->getElementDamage(player, target, tool);
					if (params.useCharges) {
						uint16_t charges = tool->getCharges();
						if (charges != 0) {
							g_game.transformItem(tool, tool->getID(), charges - 1);
						}
					}
				} else {
					damage.primary.value = normal_random(minb, maxb);
				}
			}
		}
	}
	return damage;
}

void Combat::getCombatArea(const Position& centerPos, const Position& targetPos, const AreaCombat* area, std::vector<Tile*>& list, bool directionalArea)
{
	if (targetPos.z >= MAP_MAX_LAYERS) {
		return;
	}

	if (area) {
		area->getList(centerPos, targetPos, directionalArea ? centerPos : targetPos, list);
	} else {
		Tile* tile = g_game.map.getTile(targetPos);
		if (!tile) {
			tile = new StaticTile(targetPos.x, targetPos.y, targetPos.z);
			g_game.map.setTile(targetPos, tile);
		}
		list.push_back(tile);
	}
}

CombatType_t Combat::ConditionToDamageType(ConditionType_t type)
{
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

ConditionType_t Combat::DamageToConditionType(CombatType_t type)
{
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

bool Combat::isPlayerCombat(const Creature* target)
{
	if (target->getPlayer()) {
		return true;
	}

	if (target->isSummon() && target->getMaster()->getPlayer()) {
		return true;
	}

	return false;
}

ReturnValue Combat::canTargetCreature(Player* attackerPlayer, Creature* targetCreature)
{
	if (attackerPlayer == targetCreature) {
		return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
	}

	if (!attackerPlayer->hasFlag(PlayerFlag_IgnoreProtectionZone)) {
		//pz-zone
		if (attackerPlayer->getZone() == ZONE_PROTECTION) {
			return RETURNVALUE_YOUMAYNOTATTACKAPERSONWHILEINPROTECTIONZONE;
		}

		if (targetCreature->getZone() == ZONE_PROTECTION) {
			return RETURNVALUE_YOUMAYNOTATTACKAPERSONINPROTECTIONZONE;
		}

		//nopvp-zone
		if (isPlayerCombat(targetCreature)) {
			if (attackerPlayer->getZone() == ZONE_NOPVP) {
				return RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE;
			}

			if (targetCreature->getZone() == ZONE_NOPVP) {
				return RETURNVALUE_YOUMAYNOTATTACKAPERSONINPROTECTIONZONE;
			}
		}
	}

	if (attackerPlayer->hasFlag(PlayerFlag_CannotUseCombat) || !targetCreature->isAttackable()) {
		if (targetCreature->getPlayer()) {
			return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
		} else {
			return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE;
		}
	}

	if (targetCreature->getPlayer()) {
		if (isProtected(attackerPlayer, targetCreature->getPlayer())) {
			return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
		}

		if (attackerPlayer->hasSecureMode() && !Combat::isInPvpZone(attackerPlayer, targetCreature) && attackerPlayer->getSkullClient(targetCreature->getPlayer()) == SKULL_NONE) {
			return RETURNVALUE_TURNSECUREMODETOATTACKUNMARKEDPLAYERS;
		}
	}

	return Combat::canDoCombat(attackerPlayer, targetCreature);
}

ReturnValue Combat::canDoCombat(Creature* caster, Tile* tile, bool aggressive)
{
	if (tile->hasFlag(TILESTATE_BLOCKPROJECTILE | TILESTATE_FLOORCHANGE | TILESTATE_TELEPORT)) {
		return RETURNVALUE_NOTENOUGHROOM;
	}

	if (caster) {
		const Position& casterPosition = caster->getPosition();
		const Position& tilePosition = tile->getPosition();
		if (casterPosition.z < tilePosition.z) {
			return RETURNVALUE_FIRSTGODOWNSTAIRS;
		} else if (casterPosition.z > tilePosition.z) {
			return RETURNVALUE_FIRSTGOUPSTAIRS;
		}

		if (const Player* player = caster->getPlayer()) {
			if (player->hasFlag(PlayerFlag_IgnoreProtectionZone)) {
				return RETURNVALUE_NOERROR;
			}
		}
	}

	//pz-zone
	if (aggressive && tile->hasFlag(TILESTATE_PROTECTIONZONE)) {
		return RETURNVALUE_ACTIONNOTPERMITTEDINPROTECTIONZONE;
	}

	return g_events->eventCreatureOnAreaCombat(caster, tile, aggressive);
}

bool Combat::isInPvpZone(const Creature* attacker, const Creature* target)
{
	return attacker->getZone() == ZONE_PVP && target->getZone() == ZONE_PVP;
}

bool Combat::isProtected(const Player* attackerPlayer, const Player* target)
{
	uint32_t protectionLevel = g_configManager().getNumber(PROTECTION_LEVEL);
	if (target->getLevel() < protectionLevel || attackerPlayer->getLevel() < protectionLevel) {
		return true;
	}

	if (attackerPlayer->getVocationId() == VOCATION_NONE || target->getVocationId() == VOCATION_NONE) {
		return true;
	}

	if (attackerPlayer->getSkull() == SKULL_BLACK && attackerPlayer->getSkullClient(target) == SKULL_NONE) {
		return true;
	}

	return false;
}

ReturnValue Combat::canDoCombat(Creature* attacker, Creature* target)
{
	if (!attacker) {
		return g_events->eventCreatureOnTargetCombat(attacker, target);
	}

	if (const Player* targetPlayer = target->getPlayer()) {
		if (targetPlayer->hasFlag(PlayerFlag_CannotBeAttacked)) {
			return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
		}

		if (const Player* attackerPlayer = attacker->getPlayer()) {
			if (attackerPlayer->hasFlag(PlayerFlag_CannotAttackPlayer)) {
				return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
			}

			if (isProtected(attackerPlayer, targetPlayer)) {
				return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER;
			}

			//nopvp-zone
			const Tile* targetPlayerTile = targetPlayer->getTile();
			if (targetPlayerTile->hasFlag(TILESTATE_NOPVPZONE)) {
				return RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE;
			} else if (attackerPlayer->getTile()->hasFlag(TILESTATE_NOPVPZONE) && !targetPlayerTile->hasFlag(TILESTATE_NOPVPZONE | TILESTATE_PROTECTIONZONE)) {
				return RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE;
			}
		}

		if (attacker->isSummon()) {
			if (const Player* masterAttackerPlayer = attacker->getMaster()->getPlayer()) {
				if (masterAttackerPlayer->hasFlag(PlayerFlag_CannotAttackPlayer)) {
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
	} else if (target->getMonster()) {
		if (const Player* attackerPlayer = attacker->getPlayer()) {
			if (attackerPlayer->hasFlag(PlayerFlag_CannotAttackMonster)) {
				return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE;
			}

			if (target->isSummon() && target->getMaster()->getPlayer() && target->getZone() == ZONE_NOPVP) {
				return RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE;
			}
		} else if (attacker->getMonster()) {
			const Creature* targetMaster = target->getMaster();

			if (!targetMaster || !targetMaster->getPlayer()) {
				const Creature* attackerMaster = attacker->getMaster();

				if (!attackerMaster || !attackerMaster->getPlayer()) {
					return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE;
				}
			}
		}
	}

	if (g_game.getWorldType() == WORLD_TYPE_NO_PVP) {
		if (attacker->getPlayer() || (attacker->isSummon() && attacker->getMaster()->getPlayer())) {
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
	return g_events->eventCreatureOnTargetCombat(attacker, target);
}

void Combat::setPlayerCombatValues(formulaType_t newFormulaType, double newMina, double newMinb, double newMaxa, double newMaxb)
{
	this->formulaType = newFormulaType;
	this->mina = newMina;
	this->minb = newMinb;
	this->maxa = newMaxa;
	this->maxb = newMaxb;
}

bool Combat::setParam(CombatParam_t param, uint32_t value)
{
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

bool Combat::setCallback(CallBackParam_t key)
{
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

CallBack* Combat::getCallback(CallBackParam_t key)
{
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

#if CLIENT_VERSION >= 1203
void Combat::combatTileEffects(const SpectatorVector& spectators, NetworkMessage& effectMsg, EffectParams& effectParams, Creature* caster, Tile* tile, const CombatParams& params)
{
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
				if (g_game.getWorldType() == WORLD_TYPE_NO_PVP || tile->hasFlag(TILESTATE_NOPVPZONE)) {
					if (itemId == ITEM_FIREFIELD_PVP_FULL) {
						itemId = ITEM_FIREFIELD_NOPVP;
					} else if (itemId == ITEM_POISONFIELD_PVP) {
						itemId = ITEM_POISONFIELD_NOPVP;
					} else if (itemId == ITEM_ENERGYFIELD_PVP) {
						itemId = ITEM_ENERGYFIELD_NOPVP;
					}
				} else if (itemId == ITEM_FIREFIELD_PVP_FULL || itemId == ITEM_POISONFIELD_PVP || itemId == ITEM_ENERGYFIELD_PVP) {
					casterPlayer->addInFightTicks();
				}
			}
		}

		Item* item = Item::CreateItem(itemId);
		if (caster) {
			item->setOwner(caster->getID());
		}

		ReturnValue ret = g_game.internalAddItem(tile, item);
		if (ret == RETURNVALUE_NOERROR) {
			item->startDecaying();
		} else {
			delete item;
		}
	}

	if (params.tileCallback) {
		params.tileCallback->onTileCombat(caster, tile);
	}

	//Pack our effects
	if (params.impactEffect != CONST_ME_NONE) {
		const Position& position = tile->getPosition();
		if (position.x >= effectParams.startPosX + CLIENT_MAP_WIDTH) {
			//We can't pack this effect :(
			Game::addMagicEffect(spectators, tile->getPosition(), params.impactEffect);
			return;
		}

		//Adjust Positions
		uint32_t deltaDiff = 0;

		//Adjust Y-Position
		if (position.y > effectParams.currentPosY) {
			//First check delta whether we don't need to add full width
			deltaDiff += CLIENT_MAP_WIDTH - (effectParams.deltaPos % CLIENT_MAP_WIDTH);
			++effectParams.currentPosY;
			if (position.y > effectParams.currentPosY) {
				//Add rest of Y-Axis adjustment as full width's
				deltaDiff += static_cast<uint32_t>(position.y - effectParams.currentPosY) * CLIENT_MAP_WIDTH;
				effectParams.currentPosY = position.y;
			}
			effectParams.currentPosX = effectParams.startPosX;
		}

		//Adjust X-Position
		if (position.x > effectParams.currentPosX) {
			deltaDiff += (position.x - effectParams.currentPosX);
			effectParams.currentPosX = position.x;
		}

		//Adjust Positions
		effectParams.deltaPos += deltaDiff;
		if (deltaDiff > 0) {
			//Just in-case check if we have overflowed uint8_t - shouldn't be possible on standard client viewport unless someone use some bullshit large area for spell
			constexpr uint32_t maxU8 = std::numeric_limits<uint8_t>::max();
			Delta_Check:
			if (deltaDiff > maxU8) {
				effectMsg.addByte(MAGIC_EFFECTS_DELTA);
				effectMsg.addByte(maxU8);
				deltaDiff -= maxU8;
				goto Delta_Check;
			} else {
				effectMsg.addByte(MAGIC_EFFECTS_DELTA);
				effectMsg.addByte(deltaDiff);
			}
		}

		//Pack Effect
		effectMsg.addByte(MAGIC_EFFECTS_CREATE_EFFECT);
		effectMsg.addByte(params.impactEffect);
	}
}
#endif // CLIENT_VERSION >= 1203

void Combat::combatTileEffects(const SpectatorVector& spectators, Creature* caster, Tile* tile, const CombatParams& params)
{
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
				if (g_game.getWorldType() == WORLD_TYPE_NO_PVP || tile->hasFlag(TILESTATE_NOPVPZONE)) {
					if (itemId == ITEM_FIREFIELD_PVP_FULL) {
						itemId = ITEM_FIREFIELD_NOPVP;
					} else if (itemId == ITEM_POISONFIELD_PVP) {
						itemId = ITEM_POISONFIELD_NOPVP;
					} else if (itemId == ITEM_ENERGYFIELD_PVP) {
						itemId = ITEM_ENERGYFIELD_NOPVP;
					}
				} else if (itemId == ITEM_FIREFIELD_PVP_FULL || itemId == ITEM_POISONFIELD_PVP || itemId == ITEM_ENERGYFIELD_PVP) {
					casterPlayer->addInFightTicks();
				}
			}
		}

		Item* item = Item::CreateItem(itemId);
		if (caster) {
			item->setOwner(caster->getID());
		}

		ReturnValue ret = g_game.internalAddItem(tile, item);
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

void Combat::postCombatEffects(Creature* caster, const Position& pos, const CombatParams& params)
{
	if (caster && params.distanceEffect != CONST_ANI_NONE) {
		addDistanceEffect(caster, caster->getPosition(), pos, params.distanceEffect);
	}
}

void Combat::addDistanceEffect(Creature* caster, const Position& fromPos, const Position& toPos, uint8_t effect)
{
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
		g_game.addDistanceEffect(fromPos, toPos, effect);
	}
}

void Combat::doCombat(Creature* caster, Creature* target) const
{
	//target combat callback function
	if (params.combatType != COMBAT_NONE) {
		CombatDamage damage = getCombatDamage(caster, target);

		bool canCombat = !params.aggressive || (caster != target && Combat::canDoCombat(caster, target) == RETURNVALUE_NOERROR);
		if ((caster == target || canCombat) && params.impactEffect != CONST_ME_NONE) {
			g_game.addMagicEffect(target->getPosition(), params.impactEffect);
		}

		if (canCombat) {
			doTargetCombat(caster, target, damage, params);
		}
	}
	else {
		if (!params.aggressive || (caster != target && Combat::canDoCombat(caster, target) == RETURNVALUE_NOERROR)) {
			SpectatorVector spectators;
			g_game.map.getSpectators(spectators, target->getPosition(), true, true);

			if (params.origin != ORIGIN_MELEE) {
				for (const auto& condition : params.conditionList) {
					//Cleanse charm rune (target as player)
					Player* player = target->getPlayer();
					if (player) {
						if (player->isImmuneCleanse(condition->getType())) {
							player->sendCancelMessage("You are still immune against this spell.");
							return;
						} else if (caster && caster->getMonster()) {
							uint16_t playerCharmRaceid = player->parseRacebyCharm(CHARM_CLEANSE, false, 0);
							if (playerCharmRaceid != 0) {
								MonsterType* mType = g_monsters.getMonsterType(caster->getName());
								if (mType && playerCharmRaceid == mType->info.raceid) {
									IOBestiary g_bestiary;
									Charm* charm = g_bestiary.getBestiaryCharm(CHARM_CLEANSE);
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

					if (caster == target || !target->isImmune(condition->getType())) {
						Condition* conditionCopy = condition->clone();
						if (caster) {
							conditionCopy->setParam(CONDITION_PARAM_OWNER, caster->getID());
						}
						target->addCombatCondition(conditionCopy);
					}
				}
			}

			if (params.dispelType == CONDITION_PARALYZE) {
				target->removeCondition(CONDITION_PARALYZE);
			} else if (params.dispelType != CONDITION_NONE) {
				target->removeCombatCondition(params.dispelType);
			}

			combatTileEffects(spectators, caster, target->getTile(), params);

			if (params.targetCallback) {
				params.targetCallback->onTargetCombat(caster, target);
			}

			if (caster && params.distanceEffect != CONST_ANI_NONE) {
				addDistanceEffect(caster, caster->getPosition(), target->getPosition(), params.distanceEffect);
			}
		}
	}
}

void Combat::doCombat(Creature* caster, const Position& position) const
{
	//area combat callback function
	if (params.combatType != COMBAT_NONE) {
		CombatDamage damage = getCombatDamage(caster, nullptr);
		doAreaCombat(caster, position, area.get(), damage, params);
	} else {
		std::vector<Tile*> tileList;

		if (caster) {
			getCombatArea(caster->getPosition(), position, area.get(), tileList, params.directionalArea);
		} else {
			getCombatArea(position, position, area.get(), tileList, params.directionalArea);
		}

		uint32_t maxX = 0;
		uint32_t maxY = 0;

		//calculate the max viewable range
		for (Tile* tile : tileList) {
			const Position& tilePos = tile->getPosition();

			uint32_t diff = Position::getDistanceX(tilePos, position);
			maxX = std::max(maxX, diff);
			diff = Position::getDistanceY(tilePos, position);
			maxY = std::max(maxY, diff);
		}

		const int32_t rangeX = maxX + Map::maxViewportX;
		const int32_t rangeY = maxY + Map::maxViewportY;

		SpectatorVector spectators;
		g_game.map.getSpectators(spectators, position, true, true, rangeX, rangeX, rangeY, rangeY);

		postCombatEffects(caster, position, params);
		#if CLIENT_VERSION >= 1203
		NetworkMessage effectMsg;
		effectMsg.addByte(0x83);

		EffectParams effectParams(position.x - maxX, position.y - maxY);
		effectMsg.add<uint16_t>(effectParams.startPosX);
		effectMsg.add<uint16_t>(effectParams.startPosY);
		effectMsg.addByte(position.z);
		#endif // CLIENT_VERSION >= 1203

		for (Tile* tile : tileList) {
			if (canDoCombat(caster, tile, params.aggressive) != RETURNVALUE_NOERROR) {
				continue;
			}
			
			#if CLIENT_VERSION >= 1203
			combatTileEffects(spectators, effectMsg, effectParams, caster, tile, params);
			#else
			combatTileEffects(spectators, caster, tile, params);
			#endif // CLIENT_VERSION >= 1203
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
						for (const auto& condition : params.conditionList) {
							if (caster == creature || !creature->isImmune(condition->getType())) {
								Condition* conditionCopy = condition->clone();
								if (caster) {
									conditionCopy->setParam(CONDITION_PARAM_OWNER, caster->getID());
								}

								//TODO: infight condition until all aggressive conditions has ended
								creature->addCombatCondition(conditionCopy);
							}
						}
					}

					if (params.dispelType == CONDITION_PARALYZE) {
						creature->removeCondition(CONDITION_PARALYZE);
					} else if (params.dispelType != CONDITION_NONE) {
						creature->removeCombatCondition(params.dispelType);
					}

					if (params.targetCallback) {
						params.targetCallback->onTargetCombat(caster, creature);
					}

					if (params.targetCasterOrTopMost) {
						break;
					}
				}
			}
		}

		#if CLIENT_VERSION >= 1203
		effectMsg.addByte(MAGIC_EFFECTS_END_LOOP);
		for (Creature* spectator : spectators) {
			if (Player* tmpPlayer = spectator->getPlayer()) {
				tmpPlayer->sendNetworkMessage(effectMsg);
			}
		}
		#endif // CLIENT_VERSION >= 1203
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

		if (imbuementInfo.imbuement->combatType == COMBAT_NONE) {
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

void Combat::doTargetCombat(Creature* caster, Creature* target, CombatDamage& damage, const CombatParams& params)
{
	if (caster && params.distanceEffect != CONST_ANI_NONE) {
		addDistanceEffect(caster, caster->getPosition(), target->getPosition(), params.distanceEffect);
	}

	Player* casterPlayer = caster ? caster->getPlayer() : nullptr;
	if (casterPlayer) {
		if (damage.origin != ORIGIN_CONDITION && (damage.primary.value < 0 || damage.secondary.value < 0)) {
			uint16_t chance = casterPlayer->getSpecialSkill(SPECIALSKILL_CRITICALHITCHANCE);
			uint16_t skill = casterPlayer->getSpecialSkill(SPECIALSKILL_CRITICALHITAMOUNT);
			if (chance > 0 && skill > 0 && normal_random(1, 100) <= chance) {
				damage.primary.value += std::round(damage.primary.value * (skill * 0.01));
				damage.secondary.value += std::round(damage.secondary.value * (skill * 0.01));
				#if CLIENT_VERSION >= 1094
				g_game.addMagicEffect(target->getPosition(), CONST_ME_CRITICAL_DAMAGE);
				#endif // CLIENT_VERSION >= 1094
			}
		}

		Item *item = casterPlayer->getWeapon();
		damage = applyImbuementElementalDamage(item, damage);

		Player* targetPlayer = target->getPlayer();
		if (targetPlayer && targetPlayer->getSkull() != SKULL_BLACK) {
			damage.primary.value /= 2;
			damage.secondary.value /= 2;
		}
	}

	bool success = false;
	if (damage.primary.type != COMBAT_MANADRAIN) {
		if (g_game.combatBlockHit(damage, caster, target, params.blockedByShield, params.blockedByArmor, params.itemId != 0)) {
			return;
		}
		success = g_game.combatChangeHealth(caster, target, damage);
	} else {
		success = g_game.combatChangeMana(caster, target, damage);
	}

	if (success) {
		if (damage.blockType == BLOCK_NONE || damage.blockType == BLOCK_ARMOR) {
			for (const auto& condition : params.conditionList) {
				if (caster == target || !target->isImmune(condition->getType())) {
					Condition* conditionCopy = condition->clone();
					if (caster) {
						conditionCopy->setParam(CONDITION_PARAM_OWNER, caster->getID());
					}

					//TODO: infight condition until all aggressive conditions has ended
					target->addCombatCondition(conditionCopy);
				}
			}
		}

		if (casterPlayer && damage.origin != ORIGIN_CONDITION) {
			CombatDamage leechCombat;
			int32_t totalDamage = std::abs(damage.primary.value + damage.secondary.value);

			if (casterPlayer->getHealth() < casterPlayer->getMaxHealth()) {
				uint16_t chance = casterPlayer->getSpecialSkill(SPECIALSKILL_LIFELEECHCHANCE);
				uint16_t skill = casterPlayer->getSpecialSkill(SPECIALSKILL_LIFELEECHAMOUNT);
				if (chance > 0 && skill > 0 && normal_random(1, 100) <= chance) {
					leechCombat.primary.value = std::round(totalDamage * (skill * 0.01));
					g_game.combatChangeHealth(nullptr, casterPlayer, leechCombat);
					g_game.addMagicEffect(casterPlayer->getPosition(), CONST_ME_MAGIC_RED);
				}
			}

			if (casterPlayer->getMana() < casterPlayer->getMaxMana()) {
				uint16_t chance = casterPlayer->getSpecialSkill(SPECIALSKILL_MANALEECHCHANCE);
				uint16_t skill = casterPlayer->getSpecialSkill(SPECIALSKILL_MANALEECHAMOUNT);
				if (chance > 0 && skill > 0 && normal_random(1, 100) <= chance) {
					leechCombat.primary.value = std::round(totalDamage * (skill * 0.01));
					g_game.combatChangeMana(nullptr, casterPlayer, leechCombat);
					g_game.addMagicEffect(casterPlayer->getPosition(), CONST_ME_MAGIC_BLUE);
				}
			}
		}

		if (params.dispelType == CONDITION_PARALYZE) {
			target->removeCondition(CONDITION_PARALYZE);
		} else if (params.dispelType != CONDITION_NONE) {
			target->removeCombatCondition(params.dispelType);
		}
	}

	if (params.targetCallback) {
		params.targetCallback->onTargetCombat(caster, target);
	}
}

void Combat::doAreaCombat(Creature* caster, const Position& position, const AreaCombat* area, CombatDamage& damage, const CombatParams& params)
{
	std::vector<Tile*> tileList;

	if (caster) {
		getCombatArea(caster->getPosition(), position, area, tileList, params.directionalArea);
	} else {
		getCombatArea(position, position, area, tileList, params.directionalArea);
	}

	uint16_t effectStatus = 0, lifeLeechChance = 0, manaLeechChance = 0;
	Player* casterPlayer = caster ? caster->getPlayer() : nullptr;
	if (casterPlayer && damage.origin != ORIGIN_CONDITION && (damage.primary.value < 0 || damage.secondary.value < 0)) {
		uint16_t chance = casterPlayer->getSpecialSkill(SPECIALSKILL_CRITICALHITCHANCE);
		uint16_t skill = casterPlayer->getSpecialSkill(SPECIALSKILL_CRITICALHITAMOUNT);
		if (chance > 0 && skill > 0 && uniform_random(1, 100) <= chance) {
			damage.primary.value += std::round(damage.primary.value * (skill * 0.01));
			damage.secondary.value += std::round(damage.secondary.value * (skill * 0.01));
			effectStatus |= EFFECT_STATUS_CRITICAL;
		}
	}

	uint32_t maxX = 0;
	uint32_t maxY = 0;

	//calculate the max viewable range
	for (Tile* tile : tileList) {
		const Position& tilePos = tile->getPosition();

		uint32_t diff = Position::getDistanceX(tilePos, position);
		maxX = std::max(maxX, diff);
		diff = Position::getDistanceY(tilePos, position);
		maxY = std::max(maxY, diff);
	}

	const int32_t rangeX = maxX + Map::maxClientViewportX;
	const int32_t rangeY = maxY + Map::maxClientViewportY;

	SpectatorVector spectators;
	g_game.map.getSpectators(spectators, position, true, true, rangeX, rangeX, rangeY, rangeY);

	postCombatEffects(caster, position, params);
	#if CLIENT_VERSION >= 1203
	NetworkMessage effectMsg;
	effectMsg.addByte(0x83);

	EffectParams effectParams(position.x - maxX, position.y - maxY);
	effectMsg.add<uint16_t>(effectParams.startPosX);
	effectMsg.add<uint16_t>(effectParams.startPosY);
	effectMsg.addByte(position.z);
	#endif // CLIENT_VERSION >= 1203

	std::vector<Creature*> toDamageCreatures;
	toDamageCreatures.reserve(100);

	for (Tile* tile : tileList) {
		if (canDoCombat(caster, tile, params.aggressive) != RETURNVALUE_NOERROR) {
			continue;
		}

		#if CLIENT_VERSION >= 1203
		combatTileEffects(spectators, effectMsg, effectParams, caster, tile, params);
		#else
		combatTileEffects(spectators, caster, tile, params);
		#endif // CLIENT_VERSION >= 1203
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
					toDamageCreatures.push_back(creature);

					#if CLIENT_VERSION >= 1094
					if (effectStatus & EFFECT_STATUS_CRITICAL) {
						#if CLIENT_VERSION >= 1203
						if (params.impactEffect != CONST_ME_NONE) {
							//Pack Effect
							effectMsg.addByte(MAGIC_EFFECTS_CREATE_EFFECT);
							effectMsg.addByte(CONST_ME_CRITICAL_DAMAGE);
						} else {
							g_game.addMagicEffect(creature->getPosition(), CONST_ME_CRITICAL_DAMAGE);
						}
						#else
						g_game.addMagicEffect(creature->getPosition(), CONST_ME_CRITICAL_DAMAGE);
						#endif // CLIENT_VERSION >= 1203
					}
					#endif // CLIENT_VERSION >= 1094

					if (params.targetCasterOrTopMost) {
						break;
					}
				}
			}
		}
	}

	#if CLIENT_VERSION >= 1203
	effectMsg.addByte(MAGIC_EFFECTS_END_LOOP);
	for (Creature* spectator : spectators) {
		if (Player* tmpPlayer = spectator->getPlayer()) {
			tmpPlayer->sendNetworkMessage(effectMsg);
		}
	}
	#endif // CLIENT_VERSION >= 1203

	CombatDamage leechCombat;
	for (Creature* creature : toDamageCreatures) {
		CombatDamage damageCopy = damage;
		if (casterPlayer && (damageCopy.primary.value < 0 || damageCopy.secondary.value < 0)) {
			Player* targetPlayer = creature->getPlayer();
			if (targetPlayer && targetPlayer->getSkull() != SKULL_BLACK) {
				damageCopy.primary.value /= 2;
				damageCopy.secondary.value /= 2;
			}
		}

		bool success = false;
		if (damageCopy.primary.type != COMBAT_MANADRAIN) {
			if (g_game.combatBlockHit(damageCopy, caster, creature, params.blockedByShield, params.blockedByArmor, params.itemId != 0)) {
				continue;
			}
			success = g_game.combatChangeHealth(caster, creature, damageCopy);
		} else {
			success = g_game.combatChangeMana(caster, creature, damageCopy);
		}

		if (success) {
			if (damage.blockType == BLOCK_NONE || damage.blockType == BLOCK_ARMOR) {
				for (const auto& condition : params.conditionList) {
					if (caster == creature || !creature->isImmune(condition->getType())) {
						Condition* conditionCopy = condition->clone();
						if (caster) {
							conditionCopy->setParam(CONDITION_PARAM_OWNER, caster->getID());
						}

						//TODO: infight condition until all aggressive conditions has ended
						creature->addCombatCondition(conditionCopy);
					}
				}
			}

			if (casterPlayer && damage.origin != ORIGIN_CONDITION) {
				int32_t totalDamage = std::abs(damageCopy.primary.value + damageCopy.secondary.value);
				double targetsCount = static_cast<double>(toDamageCreatures.size());

				if (casterPlayer->getHealth() < casterPlayer->getMaxHealth()) {
					uint16_t chance = casterPlayer->getSpecialSkill(SPECIALSKILL_LIFELEECHCHANCE);
					uint16_t skill = casterPlayer->getSpecialSkill(SPECIALSKILL_LIFELEECHAMOUNT);
					if (chance > 0 && skill > 0) {
						if (lifeLeechChance == 0) {
							lifeLeechChance = normal_random(1, 100);
						}

						if (lifeLeechChance <= chance) {
							leechCombat.primary.value = std::ceil(totalDamage * (skill * 0.01) * std::fma(0.1, targetsCount, 0.9) / targetsCount);
							g_game.combatChangeHealth(nullptr, casterPlayer, leechCombat);
							effectStatus |= EFFECT_STATUS_LIFELEECH;
						}
					}
				}

				if (casterPlayer->getMana() < casterPlayer->getMaxMana()) {
					uint16_t chance = casterPlayer->getSpecialSkill(SPECIALSKILL_MANALEECHCHANCE);
					uint16_t skill = casterPlayer->getSpecialSkill(SPECIALSKILL_MANALEECHAMOUNT);
					if (chance > 0 && skill > 0) {
						if (manaLeechChance == 0) {
							manaLeechChance = normal_random(1, 100);
						}

						if (manaLeechChance <= chance) {
							leechCombat.primary.value = std::ceil(totalDamage * (skill * 0.01) * std::fma(0.1, targetsCount, 0.9) / targetsCount);
							g_game.combatChangeMana(nullptr, casterPlayer, leechCombat);
							effectStatus |= EFFECT_STATUS_MANALEECH;
						}
					}
				}
			}

			if (params.dispelType == CONDITION_PARALYZE) {
				creature->removeCondition(CONDITION_PARALYZE);
			} else if (params.dispelType != CONDITION_NONE) {
				creature->removeCombatCondition(params.dispelType);
			}
		}

		if (params.targetCallback) {
			params.targetCallback->onTargetCombat(caster, creature);
		}
	}

	if (casterPlayer && effectStatus != 0) {
		if (effectStatus & EFFECT_STATUS_LIFELEECH) {
			g_game.addMagicEffect(casterPlayer->getPosition(), CONST_ME_MAGIC_RED);
		}
		if (effectStatus & EFFECT_STATUS_MANALEECH) {
			g_game.addMagicEffect(casterPlayer->getPosition(), CONST_ME_MAGIC_BLUE);
		}
	}
}

//**********************************************************//

void ValueCallback::getMinMaxValues(Player* player, CombatDamage& damage, bool useCharges) const
{
	//onGetPlayerMinMaxValues(...)
	if (!scriptInterface->reserveScriptEnv()) {
		std::cout << "[Error - ValueCallback::getMinMaxValues] Call stack overflow" << std::endl;
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

	int parameters = 1;
	switch (type) {
		case COMBAT_FORMULA_LEVELMAGIC: {
			//onGetPlayerMinMaxValues(player, level, maglevel)
			lua_pushnumber(L, player->getLevel());
			lua_pushnumber(L, player->getMagicLevel());
			parameters += 2;
			break;
		}

		case COMBAT_FORMULA_SKILL: {
			//onGetPlayerMinMaxValues(player, attackSkill, attackValue, attackFactor)
			Item* tool = player->getWeapon();
			const Weapon* weapon = g_weapons->getWeapon(tool);

			int32_t attackValue = 7;
			if (weapon) {
				attackValue = tool->getAttack();
				if (tool->getWeaponType() == WEAPON_AMMO) {
					Item* item = player->getWeapon(true);
					if (item) {
						attackValue += item->getAttack();
					}
				}

				damage.secondary.type = weapon->getElementType();
				damage.secondary.value = weapon->getElementDamage(player, nullptr, tool);
				if (useCharges) {
					uint16_t charges = tool->getCharges();
					if (charges != 0) {
						g_game.transformItem(tool, tool->getID(), charges - 1);
					}
				}
			}

			lua_pushnumber(L, player->getWeaponSkill(tool));
			lua_pushnumber(L, attackValue);
			lua_pushnumber(L, player->getAttackFactor());
			parameters += 3;
			break;
		}

		default: {
			std::cout << "ValueCallback::getMinMaxValues - unknown callback type" << std::endl;
			scriptInterface->resetScriptEnv();
			return;
		}
	}

	int size0 = lua_gettop(L);
	if (lua_pcall(L, parameters, 2, 0) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		damage.primary.value = normal_random(
			LuaScriptInterface::getNumber<int32_t>(L, -2),
			LuaScriptInterface::getNumber<int32_t>(L, -1)
		);
		lua_pop(L, 2);
	}

	if ((lua_gettop(L) + parameters + 1) != size0) {
		LuaScriptInterface::reportError(nullptr, "Stack size changed!");
	}

	scriptInterface->resetScriptEnv();
}

//**********************************************************//

void TileCallback::onTileCombat(Creature* creature, Tile* tile) const
{
	//onTileCombat(creature, pos)
	if (!scriptInterface->reserveScriptEnv()) {
		std::cout << "[Error - TileCallback::onTileCombat] Call stack overflow" << std::endl;
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

void TargetCallback::onTargetCombat(Creature* creature, Creature* target) const
{
	//onTargetCombat(creature, target)
	if (!scriptInterface->reserveScriptEnv()) {
		std::cout << "[Error - TargetCallback::onTargetCombat] Call stack overflow" << std::endl;
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

AreaCombat::AreaCombat(const AreaCombat& rhs)
{
	hasExtArea = rhs.hasExtArea;
	for (int32_t i = DIRECTION_NORTH; i <= DIRECTION_LAST; ++i) {
		if (rhs.areas[i].isInitialized()) {
			areas[i].setupArea(rhs.areas[i].getRows(), rhs.areas[i].getCols());
			copyArea(&rhs.areas[i], &areas[i], MATRIXOPERATION_COPY);
		} else {
			areas[i].clear();
		}
	}
}

void AreaCombat::getList(const Position& centerPos, const Position& targetPos, const Position& sightLinePos, std::vector<Tile*>& list) const
{
	const MatrixArea* area = getArea(centerPos, targetPos);
	if (!area) {
		return;
	}
	
	uint32_t centerY, centerX;
	area->getCenter(centerY, centerX);

	uint32_t rows = area->getRows();
	uint32_t cols = area->getCols();
	list.reserve(static_cast<size_t>(rows * cols));

	Position tmpPos(targetPos.x - centerX, targetPos.y - centerY, targetPos.z);
	for (uint32_t y = 0; y < rows; ++y, ++tmpPos.y, tmpPos.x -= cols) {
		for (uint32_t x = 0; x < cols; ++x, ++tmpPos.x) {
			if (area->getValue(y, x) != 0) {
				if (g_game.isSightClear(sightLinePos, tmpPos, true)) {
					Tile* tile = g_game.map.getTile(tmpPos);
					if (!tile) {
						tile = new StaticTile(tmpPos.x, tmpPos.y, tmpPos.z);
						g_game.map.setTile(tmpPos, tile);
					}
					list.push_back(tile);
				}
			}
		}
	}
}

void AreaCombat::copyArea(const MatrixArea* input, MatrixArea* output, MatrixOperation_t op)
{
	uint32_t centerY, centerX;
	input->getCenter(centerY, centerX);

	switch (op) {
		case MATRIXOPERATION_MIRROR:
		{
			for (uint32_t y = 0; y < input->getRows(); ++y) {
				uint32_t rx = 0;
				for (int32_t x = input->getCols(); --x >= 0;) {
					if (((y ^ centerY) | (static_cast<uint32_t>(x) ^ centerX)) == 0) {
						output->setCenter(y, rx);
					}
					output->setValue(y, rx++, input->getValue(y, x));
				}
			}
			break;
		}
		case MATRIXOPERATION_FLIP:
		{
			for (uint32_t x = 0; x < input->getCols(); ++x) {
				uint32_t ry = 0;
				for (int32_t y = input->getRows(); --y >= 0;) {
					if (((static_cast<uint32_t>(y) ^ centerY) | (x ^ centerX)) == 0) {
						output->setCenter(ry, x);
					}
					output->setValue(ry++, x, input->getValue(y, x));
				}
			}
			break;
		}
		case MATRIXOPERATION_ROTATE90:
		{
			uint32_t ry = 0;
			for (uint32_t x = 0; x < input->getCols(); ++x) {
				uint32_t rx = 0;
				for (int32_t y = input->getRows(); --y >= 0;) {
					if (((static_cast<uint32_t>(y) ^ centerY) | (x ^ centerX)) == 0) {
						output->setCenter(ry, rx);
					}
					output->setValue(ry, rx++, input->getValue(y, x));
				}

				++ry;
			}
			break;
		}
		case MATRIXOPERATION_ROTATE180:
		{
			uint32_t rx = input->getCols();
			for (uint32_t x = 0; x < input->getCols(); ++x) {
				--rx;

				uint32_t ry = 0;
				for (int32_t y = input->getRows(); --y >= 0;) {
					if (((static_cast<uint32_t>(y) ^ centerY) | (x ^ centerX)) == 0) {
						output->setCenter(ry, rx);
					}
					output->setValue(ry++, rx, input->getValue(y, x));
				}
			}
			break;
		}
		case MATRIXOPERATION_ROTATE270:
		{
			uint32_t ry = input->getCols();
			for (uint32_t x = 0; x < input->getCols(); ++x) {
				--ry;

				uint32_t rx = input->getRows();
				for (int32_t y = input->getRows(); --y >= 0;) {
					--rx;
					if (((static_cast<uint32_t>(y) ^ centerY) | (x ^ centerX)) == 0) {
						output->setCenter(ry, rx);
					}
					output->setValue(ry, rx, input->getValue(y, x));
				}
			}
			break;
		}
		default:
		{
			for (uint32_t y = 0; y < input->getRows(); ++y) {
				for (uint32_t x = 0; x < input->getCols(); ++x) {
					output->setValue(y, x, input->getValue(y, x));
				}
			}

			output->setCenter(centerY, centerX);
			break;
		}
	}
}

MatrixArea* AreaCombat::createArea(Direction dir, const std::list<uint32_t>& list, uint32_t rows)
{
	uint32_t cols;
	if (rows == 0) {
		cols = 0;
	} else {
		cols = list.size() / rows;
	}

	MatrixArea* area = &areas[dir];
	area->setupArea(rows, cols);

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

void AreaCombat::setupArea(const std::list<uint32_t>& list, uint32_t rows)
{
	//NORTH
	MatrixArea* area = createArea(DIRECTION_NORTH, list, rows);

	//SOUTH
	MatrixArea* southArea = &areas[DIRECTION_SOUTH];
	southArea->setupArea(area->getRows(), area->getCols());
	AreaCombat::copyArea(area, southArea, MATRIXOPERATION_ROTATE180);

	//EAST
	MatrixArea* eastArea = &areas[DIRECTION_EAST];
	eastArea->setupArea(area->getCols(), area->getRows());
	AreaCombat::copyArea(area, eastArea, MATRIXOPERATION_ROTATE90);

	//WEST
	MatrixArea* westArea = &areas[DIRECTION_WEST];
	westArea->setupArea(area->getCols(), area->getRows());
	AreaCombat::copyArea(area, westArea, MATRIXOPERATION_ROTATE270);
}

void AreaCombat::setupArea(int32_t length, int32_t spread)
{
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

void AreaCombat::setupArea(int32_t radius)
{
	int32_t area[13][13] = {
		{0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 8, 8, 7, 8, 8, 0, 0, 0, 0},
		{0, 0, 0, 8, 7, 6, 6, 6, 7, 8, 0, 0, 0},
		{0, 0, 8, 7, 6, 5, 5, 5, 6, 7, 8, 0, 0},
		{0, 8, 7, 6, 5, 4, 4, 4, 5, 6, 7, 8, 0},
		{0, 8, 6, 5, 4, 3, 2, 3, 4, 5, 6, 8, 0},
		{8, 7, 6, 5, 4, 2, 1, 2, 4, 5, 6, 7, 8},
		{0, 8, 6, 5, 4, 3, 2, 3, 4, 5, 6, 8, 0},
		{0, 8, 7, 6, 5, 4, 4, 4, 5, 6, 7, 8, 0},
		{0, 0, 8, 7, 6, 5, 5, 5, 6, 7, 8, 0, 0},
		{0, 0, 0, 8, 7, 6, 6, 6, 7, 8, 0, 0, 0},
		{0, 0, 0, 0, 8, 8, 7, 8, 8, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0}
	};

	std::list<uint32_t> list;

	for (auto& row : area) {
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

void AreaCombat::setupExtArea(const std::list<uint32_t>& list, uint32_t rows)
{
	if (list.empty()) {
		return;
	}

	hasExtArea = true;

	//NORTH-WEST
	MatrixArea* area = createArea(DIRECTION_NORTHWEST, list, rows);

	//NORTH-EAST
	MatrixArea* neArea = &areas[DIRECTION_NORTHEAST];
	neArea->setupArea(area->getRows(), area->getCols());
	AreaCombat::copyArea(area, neArea, MATRIXOPERATION_MIRROR);

	//SOUTH-WEST
	MatrixArea* swArea = &areas[DIRECTION_SOUTHWEST];
	swArea->setupArea(area->getRows(), area->getCols());
	AreaCombat::copyArea(area, swArea, MATRIXOPERATION_FLIP);

	//SOUTH-EAST
	MatrixArea* seArea = &areas[DIRECTION_SOUTHEAST];
	seArea->setupArea(area->getRows(), area->getCols());
	AreaCombat::copyArea(swArea, seArea, MATRIXOPERATION_MIRROR);
}

//**********************************************************//

void MagicField::onStepInField(Creature* creature)
{
	//remove magic walls/wild growth
	uint16_t id = getID();
	if (id == ITEM_MAGICWALL || id == ITEM_WILDGROWTH || id == ITEM_MAGICWALL_SAFE || id == ITEM_WILDGROWTH_SAFE || isBlocking()) {
		if (!creature->isInGhostMode()) {
			g_game.internalRemoveItem(this, 1);
		}

		return;
	}

	const ItemType& it = items[getID()];
	if (it.conditionDamage) {
		Condition* conditionCopy = it.conditionDamage->clone();
		uint32_t ownerId = getOwner();
		if (ownerId) {
			bool harmfulField = true;

			if (g_game.getWorldType() == WORLD_TYPE_NO_PVP || getTile()->hasFlag(TILESTATE_NOPVPZONE)) {
				Creature* owner = g_game.getCreatureByID(ownerId);
				if (owner) {
					if (owner->getPlayer() || (owner->isSummon() && owner->getMaster()->getPlayer())) {
						harmfulField = false;
					}
				}
			}

			Player* targetPlayer = creature->getPlayer();
			if (targetPlayer) {
				Player* attackerPlayer = g_game.getPlayerByID(ownerId);
				if (attackerPlayer) {
					if (Combat::isProtected(attackerPlayer, targetPlayer)) {
						harmfulField = false;
					}
				}
			}

			if (!harmfulField || (OTSYS_TIME() - createTime <= 5000) || creature->hasBeenAttacked(ownerId)) {
				conditionCopy->setParam(CONDITION_PARAM_OWNER, ownerId);
			}
		}

		creature->addCondition(conditionCopy);
	}
}
