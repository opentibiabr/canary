/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/game.hpp"
#include "creatures/creature.hpp"
#include "lua/functions/creatures/creature_functions.hpp"
#include "map/spectators.hpp"

int CreatureFunctions::luaCreatureCreate(lua_State* L) {
	// Creature(id or name or userdata)
	std::shared_ptr<Creature> creature;
	if (isNumber(L, 2)) {
		creature = g_game().getCreatureByID(getNumber<uint32_t>(L, 2));
	} else if (isString(L, 2)) {
		creature = g_game().getCreatureByName(getString(L, 2));
	} else if (isUserdata(L, 2)) {
		LuaData_t type = getUserdataType(L, 2);
		if (type != LuaData_t::Player && type != LuaData_t::Monster && type != LuaData_t::Npc) {
			lua_pushnil(L);
			return 1;
		}
		creature = getUserdataShared<Creature>(L, 2);
	} else {
		creature = nullptr;
	}

	if (creature) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetEvents(lua_State* L) {
	// creature:getEvents(type)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	CreatureEventType_t eventType = getNumber<CreatureEventType_t>(L, 2);
	const auto eventList = creature->getCreatureEvents(eventType);
	lua_createtable(L, static_cast<int>(eventList.size()), 0);

	int index = 0;
	for (const auto &eventPtr : eventList) {
		pushString(L, eventPtr->getName());
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int CreatureFunctions::luaCreatureRegisterEvent(lua_State* L) {
	// creature:registerEvent(name)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		const std::string &name = getString(L, 2);
		pushBoolean(L, creature->registerCreatureEvent(name));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureUnregisterEvent(lua_State* L) {
	// creature:unregisterEvent(name)
	const std::string &name = getString(L, 2);
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		pushBoolean(L, creature->unregisterCreatureEvent(name));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureIsRemoved(lua_State* L) {
	// creature:isRemoved()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		pushBoolean(L, creature->isRemoved());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureIsCreature(lua_State* L) {
	// creature:isCreature()
	pushBoolean(L, getUserdataShared<Creature>(L, 1) != nullptr);
	return 1;
}

int CreatureFunctions::luaCreatureIsInGhostMode(lua_State* L) {
	// creature:isInGhostMode()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		pushBoolean(L, creature->isInGhostMode());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureIsHealthHidden(lua_State* L) {
	// creature:isHealthHidden()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		pushBoolean(L, creature->isHealthHidden());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureCanSee(lua_State* L) {
	// creature:canSee(position)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		const Position &position = getPosition(L, 2);
		pushBoolean(L, creature->canSee(position));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureCanSeeCreature(lua_State* L) {
	// creature:canSeeCreature(creature)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		std::shared_ptr<Creature> otherCreature = getCreature(L, 2);
		pushBoolean(L, creature->canSeeCreature(otherCreature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetParent(lua_State* L) {
	// creature:getParent()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Cylinder> parent = creature->getParent();
	if (!parent) {
		lua_pushnil(L);
		return 1;
	}

	pushCylinder(L, parent);
	return 1;
}

int CreatureFunctions::luaCreatureGetId(lua_State* L) {
	// creature:getId()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getID());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetName(lua_State* L) {
	// creature:getName()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		pushString(L, creature->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetTypeName(lua_State* L) {
	// creature:getTypeName()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		pushString(L, creature->getTypeName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetTarget(lua_State* L) {
	// creature:getTarget()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Creature> target = creature->getAttackedCreature();
	if (target) {
		pushUserdata<Creature>(L, target);
		setCreatureMetatable(L, -1, target);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetTarget(lua_State* L) {
	// creature:setTarget(target)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		std::shared_ptr<Creature> target = getCreature(L, 2);
		pushBoolean(L, creature->setAttackedCreature(target));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetFollowCreature(lua_State* L) {
	// creature:getFollowCreature()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Creature> followCreature = creature->getFollowCreature();
	if (followCreature) {
		pushUserdata<Creature>(L, followCreature);
		setCreatureMetatable(L, -1, followCreature);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetFollowCreature(lua_State* L) {
	// creature:setFollowCreature(followedCreature)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		std::shared_ptr<Creature> followCreature = getCreature(L, 2);
		pushBoolean(L, creature->setFollowCreature(followCreature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetMaster(lua_State* L) {
	// creature:getMaster()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Creature> master = creature->getMaster();
	if (!master) {
		lua_pushnil(L);
		return 1;
	}

	pushUserdata<Creature>(L, master);
	setCreatureMetatable(L, -1, master);
	return 1;
}

int CreatureFunctions::luaCreatureReload(lua_State* L) {
	// creature:reload()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	g_game().reloadCreature(creature);
	pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureSetMaster(lua_State* L) {
	// creature:setMaster(master)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, creature->setMaster(getCreature(L, 2), true));
	// Reloading creature icon/knownCreature
	CreatureFunctions::luaCreatureReload(L);
	return 1;
}

int CreatureFunctions::luaCreatureGetLight(lua_State* L) {
	// creature:getLight()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	LightInfo lightInfo = creature->getCreatureLight();
	lua_pushnumber(L, lightInfo.level);
	lua_pushnumber(L, lightInfo.color);
	return 2;
}

int CreatureFunctions::luaCreatureSetLight(lua_State* L) {
	// creature:setLight(color, level)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	LightInfo light;
	light.color = getNumber<uint8_t>(L, 2);
	light.level = getNumber<uint8_t>(L, 3);
	creature->setCreatureLight(light);
	g_game().changeLight(creature);
	pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureGetSpeed(lua_State* L) {
	// creature:getSpeed()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getSpeed());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetSpeed(lua_State* L) {
	// creature:setSpeed(speed)
	std::shared_ptr<Creature> creature = getCreature(L, 1);
	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	int32_t speed = getNumber<int32_t>(L, 2);
	g_game().setCreatureSpeed(creature, speed);
	pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureGetBaseSpeed(lua_State* L) {
	// creature:getBaseSpeed()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getBaseSpeed());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureChangeSpeed(lua_State* L) {
	// creature:changeSpeed(delta)
	std::shared_ptr<Creature> creature = getCreature(L, 1);
	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	int32_t delta = getNumber<int32_t>(L, 2);
	g_game().changeSpeed(creature, delta);
	pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureSetDropLoot(lua_State* L) {
	// creature:setDropLoot(doDrop)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		creature->setDropLoot(getBoolean(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetSkillLoss(lua_State* L) {
	// creature:setSkillLoss(skillLoss)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		creature->setSkillLoss(getBoolean(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetPosition(lua_State* L) {
	// creature:getPosition()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		pushPosition(L, creature->getPosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetTile(lua_State* L) {
	// creature:getTile()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Tile> tile = creature->getTile();
	if (tile) {
		pushUserdata<Tile>(L, tile);
		setMetatable(L, -1, "Tile");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetDirection(lua_State* L) {
	// creature:getDirection()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getDirection());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetDirection(lua_State* L) {
	// creature:setDirection(direction)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		pushBoolean(L, g_game().internalCreatureTurn(creature, getNumber<Direction>(L, 2)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetHealth(lua_State* L) {
	// creature:getHealth()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getHealth());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetHealth(lua_State* L) {
	// creature:setHealth(health)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	creature->health = std::min<int32_t>(getNumber<uint32_t>(L, 2), creature->healthMax);
	g_game().addCreatureHealth(creature);

	std::shared_ptr<Player> player = creature->getPlayer();
	if (player) {
		player->sendStats();
	}
	pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureAddHealth(lua_State* L) {
	// creature:addHealth(healthChange, combatType)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	CombatDamage damage;
	damage.primary.value = getNumber<int32_t>(L, 2);
	if (damage.primary.value >= 0) {
		damage.primary.type = COMBAT_HEALING;
	} else if (damage.primary.value < 0) {
		damage.primary.type = getNumber<CombatType_t>(L, 3);
	} else {
		damage.primary.type = COMBAT_UNDEFINEDDAMAGE;
	}
	pushBoolean(L, g_game().combatChangeHealth(nullptr, creature, damage));
	return 1;
}

int CreatureFunctions::luaCreatureGetMaxHealth(lua_State* L) {
	// creature:getMaxHealth()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getMaxHealth());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetMaxHealth(lua_State* L) {
	// creature:setMaxHealth(maxHealth)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	creature->healthMax = getNumber<uint32_t>(L, 2);
	creature->health = std::min<int32_t>(creature->health, creature->healthMax);
	g_game().addCreatureHealth(creature);

	std::shared_ptr<Player> player = creature->getPlayer();
	if (player) {
		player->sendStats();
	}
	pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureSetHiddenHealth(lua_State* L) {
	// creature:setHiddenHealth(hide)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		creature->setHiddenHealth(getBoolean(L, 2));
		g_game().addCreatureHealth(creature);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureIsMoveLocked(lua_State* L) {
	// creature:isMoveLocked()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		pushBoolean(L, creature->isMoveLocked());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetMoveLocked(lua_State* L) {
	// creature:setMoveLocked(moveLocked)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		creature->setMoveLocked(getBoolean(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureIsDirectionLocked(lua_State* L) {
	// creature:isDirectionLocked()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		pushBoolean(L, creature->isDirectionLocked());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetDirectionLocked(lua_State* L) {
	// creature:setDirectionLocked(directionLocked)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		creature->setDirectionLocked(getBoolean(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetSkull(lua_State* L) {
	// creature:getSkull()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getSkull());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetSkull(lua_State* L) {
	// creature:setSkull(skull)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		creature->setSkull(getNumber<Skulls_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetOutfit(lua_State* L) {
	// creature:getOutfit()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		pushOutfit(L, creature->getCurrentOutfit());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetOutfit(lua_State* L) {
	// creature:setOutfit(outfit)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		Outfit_t outfit = getOutfit(L, 2);
		if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && outfit.lookType != 0 && !g_game().isLookTypeRegistered(outfit.lookType)) {
			g_logger().warn("[CreatureFunctions::luaCreatureSetOutfit] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", outfit.lookType);
			return 1;
		}

		creature->defaultOutfit = outfit;
		g_game().internalCreatureChangeOutfit(creature, creature->defaultOutfit);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetCondition(lua_State* L) {
	// creature:getCondition(conditionType[, conditionId = CONDITIONID_COMBAT[, subId = 0]])
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	ConditionType_t conditionType = getNumber<ConditionType_t>(L, 2);
	ConditionId_t conditionId = getNumber<ConditionId_t>(L, 3, CONDITIONID_COMBAT);
	uint32_t subId = getNumber<uint32_t>(L, 4, 0);

	const std::shared_ptr<Condition> condition = creature->getCondition(conditionType, conditionId, subId);
	if (condition) {
		pushUserdata<const Condition>(L, condition);
		setWeakMetatable(L, -1, "Condition");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureAddCondition(lua_State* L) {
	// creature:addCondition(condition)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	std::shared_ptr<Condition> condition = getUserdataShared<Condition>(L, 2);
	if (creature && condition) {
		pushBoolean(L, creature->addCondition(condition->clone()));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureRemoveCondition(lua_State* L) {
	// creature:removeCondition(conditionType[, conditionId = CONDITIONID_COMBAT[, subId = 0[, force = false]]])
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	ConditionType_t conditionType = getNumber<ConditionType_t>(L, 2);
	ConditionId_t conditionId = getNumber<ConditionId_t>(L, 3, CONDITIONID_COMBAT);
	uint32_t subId = getNumber<uint32_t>(L, 4, 0);
	const std::shared_ptr<Condition> condition = creature->getCondition(conditionType, conditionId, subId);
	if (condition) {
		bool force = getBoolean(L, 5, false);
		if (subId == 0) {
			creature->removeCondition(conditionType, conditionId, force);
		} else {
			creature->removeCondition(condition);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureHasCondition(lua_State* L) {
	// creature:hasCondition(conditionType[, subId = 0])
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	ConditionType_t conditionType = getNumber<ConditionType_t>(L, 2);
	uint32_t subId = getNumber<uint32_t>(L, 3, 0);
	pushBoolean(L, creature->hasCondition(conditionType, subId));
	return 1;
}

int CreatureFunctions::luaCreatureIsImmune(lua_State* L) {
	// creature:isImmune(condition or conditionType)
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	if (isNumber(L, 2)) {
		pushBoolean(L, creature->isImmune(getNumber<ConditionType_t>(L, 2)));
	} else if (auto condition = getUserdataShared<Condition>(L, 2)) {
		pushBoolean(L, creature->isImmune(condition->getType()));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureRemove(lua_State* L) {
	// creature:remove([forced = true])
	std::shared_ptr<Creature>* creaturePtr = getRawUserDataShared<Creature>(L, 1);
	if (!creaturePtr) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Creature> creature = *creaturePtr;
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	bool forced = getBoolean(L, 2, true);
	if (std::shared_ptr<Player> player = creature->getPlayer()) {
		if (forced) {
			player->removePlayer(true);
		} else {
			player->removePlayer(true, false);
		}
	} else {
		g_game().removeCreature(creature);
	}

	*creaturePtr = nullptr;
	pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureTeleportTo(lua_State* L) {
	// creature:teleportTo(position[, pushMovement = false])
	bool pushMovement = getBoolean(L, 3, false);

	const Position &position = getPosition(L, 2);
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature == nullptr) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	const Position oldPosition = creature->getPosition();
	if (auto ret = g_game().internalTeleport(creature, position, pushMovement);
	    ret != RETURNVALUE_NOERROR) {
		g_logger().debug("[{}] Failed to teleport creature {}, on position {}, error code: {}", __FUNCTION__, creature->getName(), oldPosition.toString(), getReturnMessage(ret));
		pushBoolean(L, false);
		return 1;
	}

	if (!pushMovement) {
		if (oldPosition.x == position.x) {
			if (oldPosition.y < position.y) {
				g_game().internalCreatureTurn(creature, DIRECTION_SOUTH);
			} else {
				g_game().internalCreatureTurn(creature, DIRECTION_NORTH);
			}
		} else if (oldPosition.x > position.x) {
			g_game().internalCreatureTurn(creature, DIRECTION_WEST);
		} else if (oldPosition.x < position.x) {
			g_game().internalCreatureTurn(creature, DIRECTION_EAST);
		}
	}
	pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureSay(lua_State* L) {
	// creature:say(text[, type = TALKTYPE_MONSTER_SAY[, ghost = false[, target = nullptr[, position]]]])
	int parameters = lua_gettop(L);

	Position position;
	if (parameters >= 6) {
		position = getPosition(L, 6);
		if (!position.x || !position.y) {
			reportErrorFunc("Invalid position specified.");
			pushBoolean(L, false);
			return 1;
		}
	}

	std::shared_ptr<Creature> target = nullptr;
	if (parameters >= 5) {
		target = getCreature(L, 5);
	}

	bool ghost = getBoolean(L, 4, false);

	SpeakClasses type = getNumber<SpeakClasses>(L, 3, TALKTYPE_MONSTER_SAY);
	const std::string &text = getString(L, 2);
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	Spectators spectators;
	if (target) {
		spectators.insert(target);
	}

	if (position.x != 0) {
		pushBoolean(L, g_game().internalCreatureSay(creature, type, text, ghost, &spectators, &position));
	} else {
		pushBoolean(L, g_game().internalCreatureSay(creature, type, text, ghost, &spectators));
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetDamageMap(lua_State* L) {
	// creature:getDamageMap()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, creature->damageMap.size(), 0);
	for (auto damageEntry : creature->damageMap) {
		lua_createtable(L, 0, 2);
		setField(L, "total", damageEntry.second.total);
		setField(L, "ticks", damageEntry.second.ticks);
		lua_rawseti(L, -2, damageEntry.first);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetSummons(lua_State* L) {
	// creature:getSummons()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, creature->getSummonCount(), 0);

	int index = 0;
	for (const auto &summon : creature->getSummons()) {
		if (summon) {
			pushUserdata<Creature>(L, summon);
			setCreatureMetatable(L, -1, summon);
			lua_rawseti(L, -2, ++index);
		}
	}
	return 1;
}

int CreatureFunctions::luaCreatureHasBeenSummoned(lua_State* L) {
	// creature:hasBeenSummoned()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		pushBoolean(L, creature->hasBeenSummoned());
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int CreatureFunctions::luaCreatureGetDescription(lua_State* L) {
	// creature:getDescription(distance)
	int32_t distance = getNumber<int32_t>(L, 2);
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		pushString(L, creature->getDescription(distance));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetPathTo(lua_State* L) {
	// creature:getPathTo(pos[, minTargetDist = 0[, maxTargetDist = 1[, fullPathSearch = true[, clearSight = true[, maxSearchDist = 0]]]]])
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const Position &position = getPosition(L, 2);

	FindPathParams fpp;
	fpp.minTargetDist = getNumber<int32_t>(L, 3, 0);
	fpp.maxTargetDist = getNumber<int32_t>(L, 4, 1);
	fpp.fullPathSearch = getBoolean(L, 5, fpp.fullPathSearch);
	fpp.clearSight = getBoolean(L, 6, fpp.clearSight);
	fpp.maxSearchDist = getNumber<int32_t>(L, 7, fpp.maxSearchDist);

	std::vector<Direction> dirList;
	if (creature->getPathTo(position, dirList, fpp)) {
		lua_newtable(L);

		int index = 0;
		for (Direction dir : dirList) {
			lua_pushnumber(L, dir);
			lua_rawseti(L, -2, ++index);
		}
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int CreatureFunctions::luaCreatureMove(lua_State* L) {
	// creature:move(direction)
	// creature:move(tile[, flags = 0])
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	if (isNumber(L, 2)) {
		Direction direction = getNumber<Direction>(L, 2);
		if (direction > DIRECTION_LAST) {
			lua_pushnil(L);
			return 1;
		}
		lua_pushnumber(L, g_game().internalMoveCreature(creature, direction, FLAG_NOLIMIT));
	} else {
		std::shared_ptr<Tile> tile = getUserdataShared<Tile>(L, 2);
		if (!tile) {
			lua_pushnil(L);
			return 1;
		}
		lua_pushnumber(L, g_game().internalMoveCreature(creature, tile, getNumber<uint32_t>(L, 3)));
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetZoneType(lua_State* L) {
	// creature:getZoneType()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getZoneType());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetZones(lua_State* L) {
	// creature:getZones()
	std::shared_ptr<Creature> creature = getUserdataShared<Creature>(L, 1);
	if (creature == nullptr) {
		lua_pushnil(L);
		return 1;
	}

	const auto zones = creature->getZones();
	lua_createtable(L, static_cast<int>(zones.size()), 0);
	int index = 0;
	for (auto zone : zones) {
		index++;
		pushUserdata<Zone>(L, zone);
		setMetatable(L, -1, "Zone");
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetIcon(lua_State* L) {
	// creature:setIcon(key, category, icon[, number])
	auto creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	const auto key = getString(L, 2);
	const auto category = getNumber<CreatureIconCategory_t>(L, 3);
	const auto count = getNumber<uint16_t>(L, 5, 0);
	CreatureIcon creatureIcon;
	if (category == CreatureIconCategory_t::Modifications) {
		auto icon = getNumber<CreatureIconModifications_t>(L, 4);
		creatureIcon = CreatureIcon(icon, count);
	} else {
		auto icon = getNumber<CreatureIconQuests_t>(L, 4);
		creatureIcon = CreatureIcon(icon, count);
	}

	creature->setIcon(key, creatureIcon);
	pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureGetIcons(lua_State* L) {
	// creature:getIcons()
	const auto creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	auto icons = creature->getIcons();
	lua_createtable(L, static_cast<int>(icons.size()), 0);
	for (auto &icon : icons) {
		lua_createtable(L, 0, 3);
		setField(L, "category", static_cast<uint8_t>(icon.category));
		setField(L, "icon", icon.serialize());
		setField(L, "count", icon.count);
		lua_rawseti(L, -2, static_cast<int>(icon.category));
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetIcon(lua_State* L) {
	// creature:getIcon(key)
	const auto creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	const auto key = getString(L, 2);
	auto icon = creature->getIcon(key);
	if (icon.isSet()) {
		lua_createtable(L, 0, 3);
		setField(L, "category", static_cast<uint8_t>(icon.category));
		setField(L, "icon", icon.serialize());
		setField(L, "count", icon.count);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureRemoveIcon(lua_State* L) {
	// creature:removeIcon(key)
	auto creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	const auto key = getString(L, 2);
	creature->removeIcon(key);
	pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureClearIcons(lua_State* L) {
	// creature:clearIcons()
	auto creature = getUserdataShared<Creature>(L, 1);
	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	creature->clearIcons();
	pushBoolean(L, true);
	return 1;
}
