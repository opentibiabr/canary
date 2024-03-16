/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/monsters/monsters.hpp"
#include "lua/functions/creatures/monster/loot_functions.hpp"

int LootFunctions::luaCreateLoot(lua_State* L) {
    try {
        auto newLoot = std::make_shared<Loot>();
        pushUserdata<Loot>(L, newLoot);
        setMetatable(L, -1, "Loot");
        return 1;
    } catch (const std::exception& e) {
        g_logger().warn("Error creating loot: {}", e.what());
        lua_pushnil(L);
        return 1;
    }
}

int LootFunctions::luaLootSetId(lua_State* L) {
    try {
        const auto loot = getUserdataShared<Loot>(L, 1);
        if (!loot) {
            g_logger().warn("[LootFunctions::luaLootSetId] - Invalid loot object");
            lua_pushnil(L);
            return 1;
        }
        if (!isNumber(L, 2)) {
            g_logger().warn("[LootFunctions::luaLootSetId] - Unknown loot item loot, int value expected");
            lua_pushnil(L);
            return 1;
        }
        uint16_t id = getNumber<uint16_t>(L, 2);
        loot->lootBlock.id = id;
        pushBoolean(L, true);
        return 1;
    } catch (const std::exception& e) {
        g_logger().warn("Error setting loot ID: {}", e.what());
        lua_pushnil(L);
        return 1;
    }
}

int LootFunctions::luaLootSetIdFromName(lua_State* L) {
    try {
        const auto loot = getUserdataShared<Loot>(L, 1);

        if (!loot || !isString(L, 2)) {
            g_logger().warn("[LootFunctions::luaLootSetIdFromName] - Unknown loot item or invalid argument type");
            lua_pushnil(L);
            return 1;
        }

        auto name = getString(L, 2);
        auto ids = Item::items.nameToItems.equal_range(asLowerCaseString(name));

        if (ids.first == Item::items.nameToItems.cend()) {
            g_logger().warn("[LootFunctions::luaLootSetIdFromName] - Unknown loot item {}", name);
            lua_pushnil(L);
            return 1;
        }

        if (std::next(ids.first) != ids.second) {
            g_logger().warn("[LootFunctions::luaLootSetIdFromName] - Non-unique loot item {}", name);
            lua_pushnil(L);
            return 1;
        }

        loot->lootBlock.id = ids.first->second;

        pushBoolean(L, true);
        return 1;
    } catch (const std::exception& e) {
        g_logger().warn("Error setting loot ID from name: {}", e.what());
        lua_pushnil(L);
        return 1;
    }
}

int LootFunctions::luaLootSetSubType(lua_State* L) {
    try {
        const int expectedArgs = 2;
        if (lua_gettop(L) != expectedArgs) {
            g_logger().error("Wrong number of arguments. Expected {}, got {}", expectedArgs, lua_gettop(L));
            lua_pushnil(L);
            return 1;
        }

        auto loot = getUserdataShared<Loot>(L, 1);
        if (!loot) {
            g_logger().error("Invalid loot object");
            lua_pushnil(L);
            return 1;
        }

        uint16_t subtype = static_cast<uint16_t>(luaL_checkinteger(L, 2));
        loot->lootBlock.subType = subtype;

        lua_pushboolean(L, true);
        return 1;
    } catch (const std::exception& e) {
        g_logger().error("Error setting loot subtype: {}", e.what());
        lua_pushnil(L);
        return 1;
    }
}

int LootFunctions::luaLootSetChance(lua_State* L) {
    try {
        const int expectedArgs = 2;
        if (lua_gettop(L) != expectedArgs) {
            g_logger().error("Wrong number of arguments. Expected {}, got {}", expectedArgs, lua_gettop(L));
            lua_pushnil(L);
            return 1;
        }

        auto loot = getUserdataShared<Loot>(L, 1);
        if (!loot) {
            g_logger().error("Invalid loot object");
            lua_pushnil(L);
            return 1;
        }

        uint32_t chance = static_cast<uint32_t>(luaL_checkinteger(L, 2));
        loot->lootBlock.chance = chance;

        lua_pushboolean(L, true);
        return 1;
    } catch (const std::exception& e) {
        g_logger().warn("Error setting loot chance: {}", e.what());
        lua_pushnil(L);
        return 1;
    }
}

int LootFunctions::luaLootSetMinCount(lua_State* L) {
    try {
        const int expectedArgs = 2;
        if (lua_gettop(L) != expectedArgs) {
            g_logger().error("Wrong number of arguments. Expected {}, got {}", expectedArgs, lua_gettop(L));
            lua_pushnil(L);
            return 1;
        }

        auto loot = getUserdataShared<Loot>(L, 1);
        if (!loot) {
            g_logger().error("Invalid loot object");
            lua_pushnil(L);
            return 1;
        }

        uint32_t minCount = static_cast<uint32_t>(luaL_checkinteger(L, 2));
        loot->lootBlock.countmin = minCount;

        lua_pushboolean(L, true);
        return 1;
    } catch (const std::exception& e) {
        g_logger().warn("Error setting min count: {}", e.what());
        lua_pushnil(L);
        return 1;
    }
}

int LootFunctions::luaLootSetMaxCount(lua_State* L) {
    try {
        const int expectedArgs = 2;
        if (lua_gettop(L) != expectedArgs) {
            g_logger().error("Wrong number of arguments. Expected {}, got {}", expectedArgs, lua_gettop(L));
            lua_pushnil(L);
            return 1;
        }

        auto loot = getUserdataShared<Loot>(L, 1);
        if (!loot) {
            g_logger().error("Invalid loot object");
            lua_pushnil(L);
            return 1;
        }

        uint32_t maxCount = static_cast<uint32_t>(luaL_checkinteger(L, 2));
        loot->lootBlock.countmax = maxCount;

        lua_pushboolean(L, true);
        return 1;
    } catch (const std::exception& e) {
        g_logger().warn("Error setting max count: {}", e.what());
        lua_pushnil(L);
        return 1;
    }
}

int LootFunctions::luaLootSetActionId(lua_State* L) {
    try {
        const int expectedArgs = 2;
        if (lua_gettop(L) != expectedArgs) {
            g_logger().error("Wrong number of arguments. Expected {}, got {}", expectedArgs, lua_gettop(L));
            lua_pushnil(L);
            return 1;
        }

        auto loot = getUserdataShared<Loot>(L, 1);
        if (!loot) {
            g_logger().error("Invalid loot object");
            lua_pushnil(L);
            return 1;
        }

        uint32_t actionId = static_cast<uint32_t>(luaL_checkinteger(L, 2));
        loot->lootBlock.actionId = actionId;

        lua_pushboolean(L, true);
        return 1;
    } catch (const std::exception& e) {
        g_logger().error("Error setting action ID: {}", e.what());
        lua_pushnil(L);
        return 1;
    }
}

int LootFunctions::luaLootSetText(lua_State* L) {
    try {
        const int expectedArgs = 2;
        if (lua_gettop(L) != expectedArgs) {
            g_logger().error("Wrong number of arguments. Expected {}, got {}", expectedArgs, lua_gettop(L));
            lua_pushnil(L);
            return 1;
        }

        auto loot = getUserdataShared<Loot>(L, 1);
        if (!loot) {
            g_logger().error("Invalid loot object");
            lua_pushnil(L);
            return 1;
        }

        const char* text = luaL_checkstring(L, 2);
        loot->lootBlock.text = text;

        lua_pushboolean(L, true);
        return 1;
    } catch (const std::exception& e) {
        g_logger().error("Error setting loot text: {}", e.what());
        lua_pushnil(L);
        return 1;
    }
}

int LootFunctions::luaLootSetNameItem(lua_State* L) {
    try {
        const int expectedArgs = 2;
        if (lua_gettop(L) != expectedArgs) {
            g_logger().error("Wrong number of arguments. Expected {}, got {}", expectedArgs, lua_gettop(L));
            lua_pushnil(L);
            return 1;
        }

        auto loot = getUserdataShared<Loot>(L, 1);
        if (!loot) {
            g_logger().error("Invalid loot object");
            lua_pushnil(L);
            return 1;
        }

        const char* name = luaL_checkstring(L, 2);
        loot->lootBlock.name = name;

        lua_pushboolean(L, true);
        return 1;
    } catch (const std::exception& e) {
        g_logger().error("Error setting loot name: {}", e.what());
        lua_pushnil(L);
        return 1;
    }
}

int LootFunctions::luaLootSetArticle(lua_State* L) {
    try {
        const int expectedArgs = 2;
        if (lua_gettop(L) != expectedArgs) {
            g_logger().error("Wrong number of arguments. Expected {}, got {}", expectedArgs, lua_gettop(L));
            lua_pushnil(L);
            return 1;
        }

        auto loot = getUserdataShared<Loot>(L, 1);
        if (!loot) {
            g_logger().error("Invalid loot object");
            lua_pushnil(L);
            return 1;
        }

        const char* article = luaL_checkstring(L, 2);
        loot->lootBlock.article = article;

        lua_pushboolean(L, true);
        return 1;
    } catch (const std::exception& e) {
        g_logger().error("Error setting loot article: {}", e.what());
        lua_pushnil(L);
        return 1;
    }
}

int LootFunctions::luaLootSetAttack(lua_State* L) {
    try {
        const int expectedArgs = 2;
        if (lua_gettop(L) != expectedArgs) {
            g_logger().error("Wrong number of arguments. Expected {}, got {}", expectedArgs, lua_gettop(L));
            lua_pushnil(L);
            return 1;
        }

        auto loot = getUserdataShared<Loot>(L, 1);
        if (!loot) {
            g_logger().error("Invalid loot object");
            lua_pushnil(L);
            return 1;
        }

        uint32_t attack = static_cast<uint32_t>(luaL_checkinteger(L, 2));
        loot->lootBlock.attack = attack;

        lua_pushboolean(L, true);
        return 1;
    } catch (const std::exception& e) {
        g_logger().error("Error setting loot attack: {}", e.what());
        lua_pushnil(L);
        return 1;
    }
}

int LootFunctions::luaLootSetDefense(lua_State* L) {
    try {
        const int expectedArgs = 2;
        if (lua_gettop(L) != expectedArgs) {
            g_logger().error("Wrong number of arguments. Expected {}, got {}", expectedArgs, lua_gettop(L));
            lua_pushnil(L);
            return 1;
        }

        auto loot = getUserdataShared<Loot>(L, 1);
        if (!loot) {
            g_logger().error("Invalid loot object");
            lua_pushnil(L);
            return 1;
        }

        uint32_t defense = static_cast<uint32_t>(luaL_checkinteger(L, 2));
        loot->lootBlock.defense = defense;

        lua_pushboolean(L, true);
        return 1;
    } catch (const std::exception& e) {
        g_logger().error("Error setting loot defense: {}", e.what());
        lua_pushnil(L);
        return 1;
    }
}

int LootFunctions::luaLootSetExtraDefense(lua_State* L) {
    try {
        const int expectedArgs = 2;
        if (lua_gettop(L) != expectedArgs) {
            g_logger().error("Wrong number of arguments. Expected {}, got {}", expectedArgs, lua_gettop(L));
            lua_pushnil(L);
            return 1;
        }

        auto loot = getUserdataShared<Loot>(L, 1);
        if (!loot) {
            g_logger().error("Invalid loot object");
            lua_pushnil(L);
            return 1;
        }

        uint32_t extraDefense = static_cast<uint32_t>(luaL_checkinteger(L, 2));
        loot->lootBlock.extraDefense = extraDefense;

        lua_pushboolean(L, true);
        return 1;
    } catch (const std::exception& e) {
        g_logger().error("Error setting loot extra defense: {}", e.what());
        lua_pushnil(L);
        return 1;
    }
}

int LootFunctions::luaLootSetArmor(lua_State* L) {
    try {
        const auto loot = getUserdataShared<Loot>(L, 1);
        if (!loot) {
            g_logger().error("Invalid loot object");
            lua_pushnil(L);
            return 1;
        }
        
        uint32_t armor = 0;
        if (!getNumber(L, 2, armor)) {
            g_logger().error("Invalid armor value");
            lua_pushnil(L);
            return 1;
        }
        
        loot->lootBlock.armor = armor;
        lua_pushboolean(L, true);
        return 1;
    } catch (const std::exception& e) {
        g_logger().error("Error setting loot armor: {}", e.what());
        lua_pushnil(L);
        return 1;
    }
}

// Validate and get correct variable numbers from luaLootSetArmor
static bool getNumber(lua_State* L, int index, uint32_t &value) {
    if (!lua_isnumber(L, index)) {
        return false;
    }
    
    value = static_cast<uint32_t>(lua_tonumber(L, index));
    return true;
}

int LootFunctions::luaLootSetShootRange(lua_State* L) {
    const auto loot = getUserdataShared<Loot>(L, 1);
    if (!loot) {
        g_logger().error("Invalid loot object in luaLootSetShootRange");
        return 0;
    }
    
    if (!lua_isnumber(L, 2)) {
        g_logger().error("Invalid argument type. Number expected in luaLootSetShootRange");
        return 0;
    }

    uint32_t shootRange = static_cast<uint32_t>(lua_tonumber(L, 2));
    loot->lootBlock.shootRange = shootRange;

    lua_pushboolean(L, true);
    return 1;
}

int LootFunctions::luaLootSetHitChance(lua_State* L) {
    const auto loot = getUserdataShared<Loot>(L, 1);
    if (!loot) {
        g_logger().error("Invalid loot object in luaLootSetHitChance");
        return 0;
    }
    
    if (!lua_isnumber(L, 2)) {
        g_logger().error("Invalid argument type. Number expected in luaLootSetHitChance");
        return 0;
    }

    uint32_t hitChance = static_cast<uint32_t>(lua_tonumber(L, 2));
    loot->lootBlock.hitChance = hitChance;

    lua_pushboolean(L, true);
    return 1;
}

int LootFunctions::luaLootSetUnique(lua_State* L) {
    const auto loot = getUserdataShared<Loot>(L, 1);
    if (!loot) {
        g_logger().error("Invalid loot object in luaLootSetUnique");
        return 0;
    }
    
    if (lua_gettop(L) == 1) {
        pushBoolean(L, loot->lootBlock.unique);
        return 1;
    } else if (!lua_isboolean(L, 2)) {
        g_logger().error("Invalid argument type. Boolean expected in luaLootSetUnique");
        return 0;
    }

    loot->lootBlock.unique = lua_toboolean(L, 2);
    lua_pushboolean(L, true);
    return 1;
}

int LootFunctions::luaLootAddChildLoot(lua_State* L) {
    const auto loot = getUserdataShared<Loot>(L, 1);
    if (!loot) {
        g_logger().error("Invalid loot object in luaLootAddChildLoot");
        return 0;
    }
    
    const auto childLoot = getUserdata<Loot>(L, 2);
    if (!childLoot) {
        g_logger().error("Invalid child loot object in luaLootAddChildLoot");
        return 0;
    }
    
    loot->lootBlock.childLoot.push_back(childLoot->lootBlock);
    lua_pushboolean(L, true);
    return 1;
}
