/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/combat/combat.hpp"
#include "game/game.hpp"
#include "lua/functions/creatures/combat/combat_functions.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "lua/global/lua_variant.hpp"

int CombatFunctions::luaCombatCreate(lua_State* L) {
    // Combat()
    auto combatPtr = g_luaEnvironment().createCombatObject(getScriptEnv()->getScriptInterface());
    if (combatPtr) {
        pushUserdata<Combat>(L, combatPtr);
        setMetatable(L, -1, "Combat");
    } else {
        lua_pushnil(L);
    }
    return 1;
}

int CombatFunctions::luaCombatSetParameter(lua_State* L) {
    // combat:setParameter(key, value)
    auto combat = getUserdataShared<Combat>(L, 1);
    if (!combat) {
        lua_pushboolean(L, false);
        return 1;
    }

    CombatParam_t key = static_cast<CombatParam_t>(getNumber<int>(L, 2));
    uint32_t value = 0;
    if (lua_isboolean(L, 3)) {
        value = lua_toboolean(L, 3) ? 1 : 0;
    } else if (lua_isnumber(L, 3)) {
        value = static_cast<uint32_t>(lua_tonumber(L, 3));
    } else {
        lua_pushstring(L, "Invalid value type for combat parameter");
        lua_error(L);
        return 0;
    }

    combat->setParam(key, value);
    lua_pushboolean(L, true);
    return 1;
}

int CombatFunctions::luaCombatSetFormula(lua_State* L) {
    // combat:setFormula(type, mina, minb, maxa, maxb)
    auto combat = getUserdataShared<Combat>(L, 1);
    if (!combat) {
        lua_pushboolean(L, false);
        return 1;
    }

    if (lua_gettop(L) != 6) {
        lua_pushstring(L, "Incorrect number of arguments");
        lua_error(L);
        return 0;
    }

    formulaType_t type = static_cast<formulaType_t>(getNumber<int>(L, 2));
    double mina = lua_tonumber(L, 3);
    double minb = lua_tonumber(L, 4);
    double maxa = lua_tonumber(L, 5);
    double maxb = lua_tonumber(L, 6);

    combat->setPlayerCombatValues(type, mina, minb, maxa, maxb);
    lua_pushboolean(L, true);
    return 1;
}

int CombatFunctions::luaCombatSetArea(lua_State* L) {
    // combat:setArea(area)
    if (getScriptEnv()->getScriptId() != EVENT_ID_LOADING) {
        reportErrorFunc("This function can only be used while loading the script.");
        lua_pushnil(L);
        return 1;
    }

    auto areaId = getNumber<uint32_t>(L, 2);
    const auto& area = g_luaEnvironment().getAreaObject(areaId);
    if (!area) {
        reportErrorFunc(getErrorDesc(LUA_ERROR_AREA_NOT_FOUND));
        lua_pushnil(L);
        return 1;
    }

    auto combat = getUserdataShared<Combat>(L, 1);
    if (combat) {
        auto areaClone = area->clone();
        combat->setArea(areaClone);
        lua_pushboolean(L, true);
    } else {
        lua_pushnil(L);
    }
    return 1;
}

int CombatFunctions::luaCombatSetCondition(lua_State* L) {
    // combat:addCondition(condition)
    auto condition = getUserdataShared<Condition>(L, 2);
    auto combat = getUserdata<Combat>(L, 1);
    if (combat && condition) {
        combat->addCondition(condition->clone());
        lua_pushboolean(L, true);
    } else {
        lua_pushnil(L);
    }
    return 1;
}

int CombatFunctions::luaCombatSetCallback(lua_State* L) {
    // combat:setCallback(key, function)
    auto combat = getUserdataShared<Combat>(L, 1);
    if (!combat) {
        lua_pushnil(L);
        return 1;
    }

    CallBackParam_t key = static_cast<CallBackParam_t>(getNumber<int>(L, 2));
    if (!combat->setCallback(key)) {
        lua_pushnil(L);
        return 1;
    }

    auto callback = combat->getCallback(key);
    if (!callback) {
        lua_pushnil(L);
        return 1;
    }

    std::string function = getString(L, 3);
    pushBoolean(L, callback->loadCallBack(getScriptEnv()->getScriptInterface(), function));
    return 1;
}

int CombatFunctions::luaCombatSetOrigin(lua_State* L) {
    // combat:setOrigin(origin)
    auto combat = getUserdataShared<Combat>(L, 1);
    if (combat) {
        combat->setOrigin(getNumber<CombatOrigin>(L, 2));
        lua_pushboolean(L, true);  // Indica sucesso
    } else {
        lua_pushboolean(L, false);  // Indica falha
    }
    return 1;
}

int CombatFunctions::luaCombatExecute(lua_State* L) {
    // combat:execute(creature, variant)
    auto combat = getUserdataShared<Combat>(L, 1);
    if (!combat) {
        pushBoolean(L, false);
        return 1;
    }

    std::shared_ptr<Creature> creature = getCreature(L, 2);

    const LuaVariant &variant = getVariant(L, 3);
    combat->setInstantSpellName(variant.instantName);
    combat->setRuneSpellName(variant.runeName);

    bool result = false;

    switch (variant.type) {
        case VARIANT_NUMBER: {
            std::shared_ptr<Creature> target = g_game().getCreatureByID(variant.number);
            if (target) {
                if (combat->hasArea()) {
                    result = combat->doCombat(creature, target->getPosition());
                } else {
                    result = combat->doCombat(creature, target);
                }
            }
            break;
        }

        case VARIANT_POSITION: {
            result = combat->doCombat(creature, variant.pos);
            break;
        }

        case VARIANT_TARGETPOSITION: {
            if (combat->hasArea()) {
                result = combat->doCombat(creature, variant.pos);
            } else {
                combat->postCombatEffects(creature, creature->getPosition(), variant.pos);
                g_game().addMagicEffect(variant.pos, CONST_ME_POFF);
                result = true;
            }
            break;
        }

        case VARIANT_STRING: {
            std::shared_ptr<Player> target = g_game().getPlayerByName(variant.text);
            if (target) {
                result = combat->doCombat(creature, target);
            }
            break;
        }

        case VARIANT_NONE: {
            reportErrorFunc(getErrorDesc(LUA_ERROR_VARIANT_NOT_FOUND));
            break;
        }

        default: {
            break;
        }
    }

    pushBoolean(L, result);
    return 1;
}
