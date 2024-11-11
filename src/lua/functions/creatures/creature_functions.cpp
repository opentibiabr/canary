/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/creature_functions.hpp"

#include "config/configmanager.hpp"
#include "creatures/combat/condition.hpp"
#include "creatures/creature.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "lua/creature/creatureevent.hpp"
#include "map/spectators.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void CreatureFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Creature", "", CreatureFunctions::luaCreatureCreate);
	Lua::registerMetaMethod(L, "Creature", "__eq", Lua::luaUserdataCompare);
	Lua::registerMethod(L, "Creature", "getEvents", CreatureFunctions::luaCreatureGetEvents);
	Lua::registerMethod(L, "Creature", "registerEvent", CreatureFunctions::luaCreatureRegisterEvent);
	Lua::registerMethod(L, "Creature", "unregisterEvent", CreatureFunctions::luaCreatureUnregisterEvent);
	Lua::registerMethod(L, "Creature", "isRemoved", CreatureFunctions::luaCreatureIsRemoved);
	Lua::registerMethod(L, "Creature", "isCreature", CreatureFunctions::luaCreatureIsCreature);
	Lua::registerMethod(L, "Creature", "isInGhostMode", CreatureFunctions::luaCreatureIsInGhostMode);
	Lua::registerMethod(L, "Creature", "isHealthHidden", CreatureFunctions::luaCreatureIsHealthHidden);
	Lua::registerMethod(L, "Creature", "isImmune", CreatureFunctions::luaCreatureIsImmune);
	Lua::registerMethod(L, "Creature", "canSee", CreatureFunctions::luaCreatureCanSee);
	Lua::registerMethod(L, "Creature", "canSeeCreature", CreatureFunctions::luaCreatureCanSeeCreature);
	Lua::registerMethod(L, "Creature", "getParent", CreatureFunctions::luaCreatureGetParent);
	Lua::registerMethod(L, "Creature", "getId", CreatureFunctions::luaCreatureGetId);
	Lua::registerMethod(L, "Creature", "getName", CreatureFunctions::luaCreatureGetName);
	Lua::registerMethod(L, "Creature", "getTypeName", CreatureFunctions::luaCreatureGetTypeName);
	Lua::registerMethod(L, "Creature", "getTarget", CreatureFunctions::luaCreatureGetTarget);
	Lua::registerMethod(L, "Creature", "setTarget", CreatureFunctions::luaCreatureSetTarget);
	Lua::registerMethod(L, "Creature", "getFollowCreature", CreatureFunctions::luaCreatureGetFollowCreature);
	Lua::registerMethod(L, "Creature", "setFollowCreature", CreatureFunctions::luaCreatureSetFollowCreature);
	Lua::registerMethod(L, "Creature", "reload", CreatureFunctions::luaCreatureReload);
	Lua::registerMethod(L, "Creature", "getMaster", CreatureFunctions::luaCreatureGetMaster);
	Lua::registerMethod(L, "Creature", "setMaster", CreatureFunctions::luaCreatureSetMaster);
	Lua::registerMethod(L, "Creature", "getLight", CreatureFunctions::luaCreatureGetLight);
	Lua::registerMethod(L, "Creature", "setLight", CreatureFunctions::luaCreatureSetLight);
	Lua::registerMethod(L, "Creature", "getSpeed", CreatureFunctions::luaCreatureGetSpeed);
	Lua::registerMethod(L, "Creature", "setSpeed", CreatureFunctions::luaCreatureSetSpeed);
	Lua::registerMethod(L, "Creature", "getBaseSpeed", CreatureFunctions::luaCreatureGetBaseSpeed);
	Lua::registerMethod(L, "Creature", "changeSpeed", CreatureFunctions::luaCreatureChangeSpeed);
	Lua::registerMethod(L, "Creature", "setDropLoot", CreatureFunctions::luaCreatureSetDropLoot);
	Lua::registerMethod(L, "Creature", "setSkillLoss", CreatureFunctions::luaCreatureSetSkillLoss);
	Lua::registerMethod(L, "Creature", "getPosition", CreatureFunctions::luaCreatureGetPosition);
	Lua::registerMethod(L, "Creature", "getTile", CreatureFunctions::luaCreatureGetTile);
	Lua::registerMethod(L, "Creature", "getDirection", CreatureFunctions::luaCreatureGetDirection);
	Lua::registerMethod(L, "Creature", "setDirection", CreatureFunctions::luaCreatureSetDirection);
	Lua::registerMethod(L, "Creature", "getHealth", CreatureFunctions::luaCreatureGetHealth);
	Lua::registerMethod(L, "Creature", "setHealth", CreatureFunctions::luaCreatureSetHealth);
	Lua::registerMethod(L, "Creature", "addHealth", CreatureFunctions::luaCreatureAddHealth);
	Lua::registerMethod(L, "Creature", "getMaxHealth", CreatureFunctions::luaCreatureGetMaxHealth);
	Lua::registerMethod(L, "Creature", "setMaxHealth", CreatureFunctions::luaCreatureSetMaxHealth);
	Lua::registerMethod(L, "Creature", "setHiddenHealth", CreatureFunctions::luaCreatureSetHiddenHealth);
	Lua::registerMethod(L, "Creature", "isMoveLocked", CreatureFunctions::luaCreatureIsMoveLocked);
	Lua::registerMethod(L, "Creature", "isDirectionLocked", CreatureFunctions::luaCreatureIsDirectionLocked);
	Lua::registerMethod(L, "Creature", "setMoveLocked", CreatureFunctions::luaCreatureSetMoveLocked);
	Lua::registerMethod(L, "Creature", "setDirectionLocked", CreatureFunctions::luaCreatureSetDirectionLocked);
	Lua::registerMethod(L, "Creature", "getSkull", CreatureFunctions::luaCreatureGetSkull);
	Lua::registerMethod(L, "Creature", "setSkull", CreatureFunctions::luaCreatureSetSkull);
	Lua::registerMethod(L, "Creature", "getOutfit", CreatureFunctions::luaCreatureGetOutfit);
	Lua::registerMethod(L, "Creature", "setOutfit", CreatureFunctions::luaCreatureSetOutfit);
	Lua::registerMethod(L, "Creature", "getCondition", CreatureFunctions::luaCreatureGetCondition);
	Lua::registerMethod(L, "Creature", "addCondition", CreatureFunctions::luaCreatureAddCondition);
	Lua::registerMethod(L, "Creature", "removeCondition", CreatureFunctions::luaCreatureRemoveCondition);
	Lua::registerMethod(L, "Creature", "hasCondition", CreatureFunctions::luaCreatureHasCondition);
	Lua::registerMethod(L, "Creature", "remove", CreatureFunctions::luaCreatureRemove);
	Lua::registerMethod(L, "Creature", "teleportTo", CreatureFunctions::luaCreatureTeleportTo);
	Lua::registerMethod(L, "Creature", "say", CreatureFunctions::luaCreatureSay);
	Lua::registerMethod(L, "Creature", "getDamageMap", CreatureFunctions::luaCreatureGetDamageMap);
	Lua::registerMethod(L, "Creature", "getSummons", CreatureFunctions::luaCreatureGetSummons);
	Lua::registerMethod(L, "Creature", "hasBeenSummoned", CreatureFunctions::luaCreatureHasBeenSummoned);
	Lua::registerMethod(L, "Creature", "getDescription", CreatureFunctions::luaCreatureGetDescription);
	Lua::registerMethod(L, "Creature", "getPathTo", CreatureFunctions::luaCreatureGetPathTo);
	Lua::registerMethod(L, "Creature", "move", CreatureFunctions::luaCreatureMove);
	Lua::registerMethod(L, "Creature", "getZoneType", CreatureFunctions::luaCreatureGetZoneType);
	Lua::registerMethod(L, "Creature", "getZones", CreatureFunctions::luaCreatureGetZones);
	Lua::registerMethod(L, "Creature", "setIcon", CreatureFunctions::luaCreatureSetIcon);
	Lua::registerMethod(L, "Creature", "getIcon", CreatureFunctions::luaCreatureGetIcon);
	Lua::registerMethod(L, "Creature", "getIcons", CreatureFunctions::luaCreatureGetIcons);
	Lua::registerMethod(L, "Creature", "removeIcon", CreatureFunctions::luaCreatureRemoveIcon);
	Lua::registerMethod(L, "Creature", "clearIcons", CreatureFunctions::luaCreatureClearIcons);

	CombatFunctions::init(L);
	MonsterFunctions::init(L);
	NpcFunctions::init(L);
	PlayerFunctions::init(L);
}

int CreatureFunctions::luaCreatureCreate(lua_State* L) {
	// Creature(id or name or userdata)
	std::shared_ptr<Creature> creature;
	if (Lua::isNumber(L, 2)) {
		creature = g_game().getCreatureByID(Lua::getNumber<uint32_t>(L, 2));
	} else if (Lua::isString(L, 2)) {
		creature = g_game().getCreatureByName(Lua::getString(L, 2));
	} else if (Lua::isUserdata(L, 2)) {
		using enum LuaData_t;
		const LuaData_t type = Lua::getUserdataType(L, 2);
		if (type != Player && type != Monster && type != Npc) {
			lua_pushnil(L);
			return 1;
		}
		creature = Lua::getUserdataShared<Creature>(L, 2);
	} else {
		creature = nullptr;
	}

	if (creature) {
		Lua::pushUserdata<Creature>(L, creature);
		Lua::setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetEvents(lua_State* L) {
	// creature:getEvents(type)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const CreatureEventType_t eventType = Lua::getNumber<CreatureEventType_t>(L, 2);
	const auto eventList = creature->getCreatureEvents(eventType);
	lua_createtable(L, static_cast<int>(eventList.size()), 0);

	int index = 0;
	for (const auto &eventPtr : eventList) {
		Lua::pushString(L, eventPtr->getName());
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int CreatureFunctions::luaCreatureRegisterEvent(lua_State* L) {
	// creature:registerEvent(name)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		const std::string &name = Lua::getString(L, 2);
		Lua::pushBoolean(L, creature->registerCreatureEvent(name));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureUnregisterEvent(lua_State* L) {
	// creature:unregisterEvent(name)
	const std::string &name = Lua::getString(L, 2);
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		Lua::pushBoolean(L, creature->unregisterCreatureEvent(name));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureIsRemoved(lua_State* L) {
	// creature:isRemoved()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		Lua::pushBoolean(L, creature->isRemoved());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureIsCreature(lua_State* L) {
	// creature:isCreature()
	Lua::pushBoolean(L, Lua::getUserdataShared<Creature>(L, 1) != nullptr);
	return 1;
}

int CreatureFunctions::luaCreatureIsInGhostMode(lua_State* L) {
	// creature:isInGhostMode()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		Lua::pushBoolean(L, creature->isInGhostMode());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureIsHealthHidden(lua_State* L) {
	// creature:isHealthHidden()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		Lua::pushBoolean(L, creature->isHealthHidden());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureCanSee(lua_State* L) {
	// creature:canSee(position)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		const Position &position = Lua::getPosition(L, 2);
		Lua::pushBoolean(L, creature->canSee(position));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureCanSeeCreature(lua_State* L) {
	// creature:canSeeCreature(creature)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		const auto &otherCreature = Lua::getCreature(L, 2);
		Lua::pushBoolean(L, creature->canSeeCreature(otherCreature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetParent(lua_State* L) {
	// creature:getParent()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const auto &parent = creature->getParent();
	if (!parent) {
		lua_pushnil(L);
		return 1;
	}

	Lua::pushCylinder(L, parent);
	return 1;
}

int CreatureFunctions::luaCreatureGetId(lua_State* L) {
	// creature:getId()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getID());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetName(lua_State* L) {
	// creature:getName()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		Lua::pushString(L, creature->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetTypeName(lua_State* L) {
	// creature:getTypeName()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		Lua::pushString(L, creature->getTypeName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetTarget(lua_State* L) {
	// creature:getTarget()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const auto &target = creature->getAttackedCreature();
	if (target) {
		Lua::pushUserdata<Creature>(L, target);
		Lua::setCreatureMetatable(L, -1, target);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetTarget(lua_State* L) {
	// creature:setTarget(target)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		const auto &target = Lua::getCreature(L, 2);
		Lua::pushBoolean(L, creature->setAttackedCreature(target));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetFollowCreature(lua_State* L) {
	// creature:getFollowCreature()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const auto &followCreature = creature->getFollowCreature();
	if (followCreature) {
		Lua::pushUserdata<Creature>(L, followCreature);
		Lua::setCreatureMetatable(L, -1, followCreature);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetFollowCreature(lua_State* L) {
	// creature:setFollowCreature(followedCreature)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		const auto &followCreature = Lua::getCreature(L, 2);
		Lua::pushBoolean(L, creature->setFollowCreature(followCreature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetMaster(lua_State* L) {
	// creature:getMaster()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const auto &master = creature->getMaster();
	if (!master) {
		lua_pushnil(L);
		return 1;
	}

	Lua::pushUserdata<Creature>(L, master);
	Lua::setCreatureMetatable(L, -1, master);
	return 1;
}

int CreatureFunctions::luaCreatureReload(lua_State* L) {
	// creature:reload()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	g_game().reloadCreature(creature);
	Lua::pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureSetMaster(lua_State* L) {
	// creature:setMaster(master)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	Lua::pushBoolean(L, creature->setMaster(Lua::getCreature(L, 2), true));
	// Reloading creature icon/knownCreature
	CreatureFunctions::luaCreatureReload(L);
	return 1;
}

int CreatureFunctions::luaCreatureGetLight(lua_State* L) {
	// creature:getLight()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const LightInfo lightInfo = creature->getCreatureLight();
	lua_pushnumber(L, lightInfo.level);
	lua_pushnumber(L, lightInfo.color);
	return 2;
}

int CreatureFunctions::luaCreatureSetLight(lua_State* L) {
	// creature:setLight(color, level)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	LightInfo light;
	light.color = Lua::getNumber<uint8_t>(L, 2);
	light.level = Lua::getNumber<uint8_t>(L, 3);
	creature->setCreatureLight(light);
	g_game().changeLight(creature);
	Lua::pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureGetSpeed(lua_State* L) {
	// creature:getSpeed()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getSpeed());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetSpeed(lua_State* L) {
	// creature:setSpeed(speed)
	const auto &creature = Lua::getCreature(L, 1);
	if (!creature) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const int32_t speed = Lua::getNumber<int32_t>(L, 2);
	g_game().setCreatureSpeed(creature, speed);
	Lua::pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureGetBaseSpeed(lua_State* L) {
	// creature:getBaseSpeed()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getBaseSpeed());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureChangeSpeed(lua_State* L) {
	// creature:changeSpeed(delta)
	const auto &creature = Lua::getCreature(L, 1);
	if (!creature) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const int32_t delta = Lua::getNumber<int32_t>(L, 2);
	g_game().changeSpeed(creature, delta);
	Lua::pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureSetDropLoot(lua_State* L) {
	// creature:setDropLoot(doDrop)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		creature->setDropLoot(Lua::getBoolean(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetSkillLoss(lua_State* L) {
	// creature:setSkillLoss(skillLoss)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		creature->setSkillLoss(Lua::getBoolean(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetPosition(lua_State* L) {
	// creature:Lua::getPosition()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		Lua::pushPosition(L, creature->getPosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetTile(lua_State* L) {
	// creature:getTile()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const auto &tile = creature->getTile();
	if (tile) {
		Lua::pushUserdata<Tile>(L, tile);
		Lua::setMetatable(L, -1, "Tile");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetDirection(lua_State* L) {
	// creature:getDirection()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getDirection());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetDirection(lua_State* L) {
	// creature:setDirection(direction)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		Lua::pushBoolean(L, g_game().internalCreatureTurn(creature, Lua::getNumber<Direction>(L, 2)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetHealth(lua_State* L) {
	// creature:getHealth()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getHealth());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetHealth(lua_State* L) {
	// creature:setHealth(health)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	creature->health = std::min<int32_t>(Lua::getNumber<uint32_t>(L, 2), creature->healthMax);
	g_game().addCreatureHealth(creature);

	const auto &player = creature->getPlayer();
	if (player) {
		player->sendStats();
	}
	Lua::pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureAddHealth(lua_State* L) {
	// creature:addHealth(healthChange, combatType)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	CombatDamage damage;
	damage.primary.value = Lua::getNumber<int32_t>(L, 2);
	if (damage.primary.value >= 0) {
		damage.primary.type = COMBAT_HEALING;
	} else if (damage.primary.value < 0) {
		damage.primary.type = Lua::getNumber<CombatType_t>(L, 3);
	} else {
		damage.primary.type = COMBAT_UNDEFINEDDAMAGE;
	}
	Lua::pushBoolean(L, g_game().combatChangeHealth(nullptr, creature, damage));
	return 1;
}

int CreatureFunctions::luaCreatureGetMaxHealth(lua_State* L) {
	// creature:getMaxHealth()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getMaxHealth());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetMaxHealth(lua_State* L) {
	// creature:setMaxHealth(maxHealth)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	creature->healthMax = Lua::getNumber<uint32_t>(L, 2);
	creature->health = std::min<int32_t>(creature->health, creature->healthMax);
	g_game().addCreatureHealth(creature);

	const auto &player = creature->getPlayer();
	if (player) {
		player->sendStats();
	}
	Lua::pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureSetHiddenHealth(lua_State* L) {
	// creature:setHiddenHealth(hide)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		creature->setHiddenHealth(Lua::getBoolean(L, 2));
		g_game().addCreatureHealth(creature);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureIsMoveLocked(lua_State* L) {
	// creature:isMoveLocked()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		Lua::pushBoolean(L, creature->isMoveLocked());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetMoveLocked(lua_State* L) {
	// creature:setMoveLocked(moveLocked)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		creature->setMoveLocked(Lua::getBoolean(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureIsDirectionLocked(lua_State* L) {
	// creature:isDirectionLocked()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		Lua::pushBoolean(L, creature->isDirectionLocked());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetDirectionLocked(lua_State* L) {
	// creature:setDirectionLocked(directionLocked)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		creature->setDirectionLocked(Lua::getBoolean(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetSkull(lua_State* L) {
	// creature:getSkull()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getSkull());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetSkull(lua_State* L) {
	// creature:setSkull(skull)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		creature->setSkull(Lua::getNumber<Skulls_t>(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetOutfit(lua_State* L) {
	// creature:Lua::getOutfit()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		Lua::pushOutfit(L, creature->getCurrentOutfit());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetOutfit(lua_State* L) {
	// creature:setOutfit(outfit)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		Outfit_t outfit = Lua::getOutfit(L, 2);
		if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && outfit.lookType != 0 && !g_game().isLookTypeRegistered(outfit.lookType)) {
			g_logger().warn("[CreatureFunctions::luaCreatureSetOutfit] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", outfit.lookType);
			return 1;
		}

		creature->defaultOutfit = outfit;
		g_game().internalCreatureChangeOutfit(creature, creature->defaultOutfit);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetCondition(lua_State* L) {
	// creature:getCondition(conditionType[, conditionId = CONDITIONID_COMBAT[, subId = 0]])
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const ConditionType_t conditionType = Lua::getNumber<ConditionType_t>(L, 2);
	const auto conditionId = Lua::getNumber<ConditionId_t>(L, 3, CONDITIONID_COMBAT);
	const auto subId = Lua::getNumber<uint32_t>(L, 4, 0);

	const auto &condition = creature->getCondition(conditionType, conditionId, subId);
	if (condition) {
		Lua::pushUserdata<const Condition>(L, condition);
		Lua::setWeakMetatable(L, -1, "Condition");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureAddCondition(lua_State* L) {
	// creature:addCondition(condition)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	const auto &condition = Lua::getUserdataShared<Condition>(L, 2);
	if (creature && condition) {
		Lua::pushBoolean(L, creature->addCondition(condition->clone()));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureRemoveCondition(lua_State* L) {
	// creature:removeCondition(conditionType[, conditionId = CONDITIONID_COMBAT[, subId = 0[, force = false]]])
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const ConditionType_t conditionType = Lua::getNumber<ConditionType_t>(L, 2);
	const auto conditionId = Lua::getNumber<ConditionId_t>(L, 3, CONDITIONID_COMBAT);
	const auto subId = Lua::getNumber<uint32_t>(L, 4, 0);
	const auto &condition = creature->getCondition(conditionType, conditionId, subId);
	if (condition) {
		const bool force = Lua::getBoolean(L, 5, false);
		if (subId == 0) {
			creature->removeCondition(conditionType, conditionId, force);
		} else {
			creature->removeCondition(condition);
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureHasCondition(lua_State* L) {
	// creature:hasCondition(conditionType[, subId = 0])
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const ConditionType_t conditionType = Lua::getNumber<ConditionType_t>(L, 2);
	const auto subId = Lua::getNumber<uint32_t>(L, 3, 0);
	Lua::pushBoolean(L, creature->hasCondition(conditionType, subId));
	return 1;
}

int CreatureFunctions::luaCreatureIsImmune(lua_State* L) {
	// creature:isImmune(condition or conditionType)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	if (Lua::isNumber(L, 2)) {
		Lua::pushBoolean(L, creature->isImmune(Lua::getNumber<ConditionType_t>(L, 2)));
	} else if (const auto condition = Lua::getUserdataShared<Condition>(L, 2)) {
		Lua::pushBoolean(L, creature->isImmune(condition->getType()));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureRemove(lua_State* L) {
	// creature:remove([forced = true])
	auto* creaturePtr = Lua::getRawUserDataShared<Creature>(L, 1);
	if (!creaturePtr) {
		lua_pushnil(L);
		return 1;
	}

	const auto &creature = *creaturePtr;
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const bool forced = Lua::getBoolean(L, 2, true);
	if (const auto &player = creature->getPlayer()) {
		if (forced) {
			player->removePlayer(true);
		} else {
			player->removePlayer(true, false);
		}
	} else {
		g_game().removeCreature(creature);
	}

	*creaturePtr = nullptr;
	Lua::pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureTeleportTo(lua_State* L) {
	// creature:teleportTo(position[, pushMovement = false])
	const bool pushMovement = Lua::getBoolean(L, 3, false);

	const Position &position = Lua::getPosition(L, 2);
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature == nullptr) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const Position oldPosition = creature->getPosition();
	if (const auto ret = g_game().internalTeleport(creature, position, pushMovement);
	    ret != RETURNVALUE_NOERROR) {
		g_logger().debug("[{}] Failed to teleport creature {}, on position {}, error code: {}", __FUNCTION__, creature->getName(), oldPosition.toString(), getReturnMessage(ret));
		Lua::pushBoolean(L, false);
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
	Lua::pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureSay(lua_State* L) {
	// creature:say(text[, type = TALKTYPE_MONSTER_SAY[, ghost = false[, target = nullptr[, position]]]])
	const int parameters = lua_gettop(L);

	Position position;
	if (parameters >= 6) {
		position = Lua::getPosition(L, 6);
		if (!position.x || !position.y) {
			Lua::reportErrorFunc("Invalid position specified.");
			Lua::pushBoolean(L, false);
			return 1;
		}
	}

	std::shared_ptr<Creature> target = nullptr;
	if (parameters >= 5) {
		target = Lua::getCreature(L, 5);
	}

	const bool ghost = Lua::getBoolean(L, 4, false);

	const auto type = Lua::getNumber<SpeakClasses>(L, 3, TALKTYPE_MONSTER_SAY);
	const std::string &text = Lua::getString(L, 2);
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	Spectators spectators;
	if (target) {
		spectators.insert(target);
	}

	if (position.x != 0) {
		Lua::pushBoolean(L, g_game().internalCreatureSay(creature, type, text, ghost, &spectators, &position));
	} else {
		Lua::pushBoolean(L, g_game().internalCreatureSay(creature, type, text, ghost, &spectators));
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetDamageMap(lua_State* L) {
	// creature:getDamageMap()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, creature->damageMap.size(), 0);
	for (const auto damageEntry : creature->damageMap) {
		lua_createtable(L, 0, 2);
		Lua::setField(L, "total", damageEntry.second.total);
		Lua::setField(L, "ticks", damageEntry.second.ticks);
		lua_rawseti(L, -2, damageEntry.first);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetSummons(lua_State* L) {
	// creature:getSummons()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, creature->getSummonCount(), 0);

	int index = 0;
	for (const auto &summon : creature->getSummons()) {
		if (summon) {
			Lua::pushUserdata<Creature>(L, summon);
			Lua::setCreatureMetatable(L, -1, summon);
			lua_rawseti(L, -2, ++index);
		}
	}
	return 1;
}

int CreatureFunctions::luaCreatureHasBeenSummoned(lua_State* L) {
	// creature:hasBeenSummoned()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		Lua::pushBoolean(L, creature->hasBeenSummoned());
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int CreatureFunctions::luaCreatureGetDescription(lua_State* L) {
	// creature:getDescription(distance)
	const int32_t distance = Lua::getNumber<int32_t>(L, 2);
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		Lua::pushString(L, creature->getDescription(distance));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetPathTo(lua_State* L) {
	// creature:getPathTo(pos[, minTargetDist = 0[, maxTargetDist = 1[, fullPathSearch = true[, clearSight = true[, maxSearchDist = 0]]]]])
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const Position &position = Lua::getPosition(L, 2);

	FindPathParams fpp;
	fpp.minTargetDist = Lua::getNumber<int32_t>(L, 3, 0);
	fpp.maxTargetDist = Lua::getNumber<int32_t>(L, 4, 1);
	fpp.fullPathSearch = Lua::getBoolean(L, 5, fpp.fullPathSearch);
	fpp.clearSight = Lua::getBoolean(L, 6, fpp.clearSight);
	fpp.maxSearchDist = Lua::getNumber<int32_t>(L, 7, fpp.maxSearchDist);

	std::vector<Direction> dirList;
	if (creature->getPathTo(position, dirList, fpp)) {
		lua_newtable(L);

		int index = 0;
		for (const Direction dir : dirList) {
			lua_pushnumber(L, dir);
			lua_rawseti(L, -2, ++index);
		}
	} else {
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int CreatureFunctions::luaCreatureMove(lua_State* L) {
	// creature:move(direction)
	// creature:move(tile[, flags = 0])
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	if (Lua::isNumber(L, 2)) {
		const Direction direction = Lua::getNumber<Direction>(L, 2);
		if (direction > DIRECTION_LAST) {
			lua_pushnil(L);
			return 1;
		}
		lua_pushnumber(L, g_game().internalMoveCreature(creature, direction, FLAG_NOLIMIT));
	} else {
		const auto &tile = Lua::getUserdataShared<Tile>(L, 2);
		if (!tile) {
			lua_pushnil(L);
			return 1;
		}
		lua_pushnumber(L, g_game().internalMoveCreature(creature, tile, Lua::getNumber<uint32_t>(L, 3)));
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetZoneType(lua_State* L) {
	// creature:getZoneType()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getZoneType());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetZones(lua_State* L) {
	// creature:getZones()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (creature == nullptr) {
		lua_pushnil(L);
		return 1;
	}

	const auto zones = creature->getZones();
	lua_createtable(L, static_cast<int>(zones.size()), 0);
	int index = 0;
	for (const auto &zone : zones) {
		index++;
		Lua::pushUserdata<Zone>(L, zone);
		Lua::setMetatable(L, -1, "Zone");
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int CreatureFunctions::luaCreatureSetIcon(lua_State* L) {
	// creature:setIcon(key, category, icon[, number])
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	const auto key = Lua::getString(L, 2);
	const auto category = Lua::getNumber<CreatureIconCategory_t>(L, 3);
	const auto count = Lua::getNumber<uint16_t>(L, 5, 0);
	CreatureIcon creatureIcon;
	if (category == CreatureIconCategory_t::Modifications) {
		const auto icon = Lua::getNumber<CreatureIconModifications_t>(L, 4);
		creatureIcon = CreatureIcon(icon, count);
	} else {
		const auto icon = Lua::getNumber<CreatureIconQuests_t>(L, 4);
		creatureIcon = CreatureIcon(icon, count);
	}

	creature->setIcon(key, creatureIcon);
	Lua::pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureGetIcons(lua_State* L) {
	// creature:getIcons()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	auto icons = creature->getIcons();
	lua_createtable(L, static_cast<int>(icons.size()), 0);
	for (auto &icon : icons) {
		lua_createtable(L, 0, 3);
		Lua::setField(L, "category", static_cast<uint8_t>(icon.category));
		Lua::setField(L, "icon", icon.serialize());
		Lua::setField(L, "count", icon.count);
		lua_rawseti(L, -2, static_cast<int>(icon.category));
	}
	return 1;
}

int CreatureFunctions::luaCreatureGetIcon(lua_State* L) {
	// creature:getIcon(key)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	const auto key = Lua::getString(L, 2);
	auto icon = creature->getIcon(key);
	if (icon.isSet()) {
		lua_createtable(L, 0, 3);
		Lua::setField(L, "category", static_cast<uint8_t>(icon.category));
		Lua::setField(L, "icon", icon.serialize());
		Lua::setField(L, "count", icon.count);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureFunctions::luaCreatureRemoveIcon(lua_State* L) {
	// creature:removeIcon(key)
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	const auto key = Lua::getString(L, 2);
	creature->removeIcon(key);
	Lua::pushBoolean(L, true);
	return 1;
}

int CreatureFunctions::luaCreatureClearIcons(lua_State* L) {
	// creature:clearIcons()
	const auto &creature = Lua::getUserdataShared<Creature>(L, 1);
	if (!creature) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	creature->clearIcons();
	Lua::pushBoolean(L, true);
	return 1;
}
