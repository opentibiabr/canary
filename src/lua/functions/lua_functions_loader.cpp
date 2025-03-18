/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/lua_functions_loader.hpp"

#include "creatures/combat/spells.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/npcs/npc.hpp"
#include "creatures/players/player.hpp"
#include "creatures/players/grouping/guild.hpp"
#include "game/zones/zone.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "game/movement/teleport.hpp"
#include "lua/functions/core/core_functions.hpp"
#include "lua/functions/creatures/creature_functions.hpp"
#include "lua/functions/events/events_functions.hpp"
#include "lua/functions/items/item_functions.hpp"
#include "lua/functions/map/map_functions.hpp"
#include "lua/functions/core/game/zone_functions.hpp"
#include "lua/global/lua_variant.hpp"

#include "enums/lua_variant_type.hpp"

class LuaScriptInterface;

void Lua::load(lua_State* L) {
	if (!L) {
		g_game().dieSafely("Invalid lua state, cannot load lua functions.");
	}

	luaL_openlibs(L);

	CoreFunctions::init(L);
	CreatureFunctions::init(L);
	EventFunctions::init(L);
	ItemFunctions::init(L);
	MapFunctions::init(L);
	ZoneFunctions::init(L);
}

std::string Lua::getErrorDesc(ErrorCode_t code) {
	switch (code) {
		case LUA_ERROR_PLAYER_NOT_FOUND:
			return "Player not found";
		case LUA_ERROR_CREATURE_NOT_FOUND:
			return "Creature not found";
		case LUA_ERROR_NPC_NOT_FOUND:
			return "Npc not found";
		case LUA_ERROR_NPC_TYPE_NOT_FOUND:
			return "Npc type not found";
		case LUA_ERROR_MONSTER_NOT_FOUND:
			return "Monster not found";
		case LUA_ERROR_MONSTER_TYPE_NOT_FOUND:
			return "Monster type not found";
		case LUA_ERROR_ITEM_NOT_FOUND:
			return "Item not found";
		case LUA_ERROR_THING_NOT_FOUND:
			return "Thing not found";
		case LUA_ERROR_TILE_NOT_FOUND:
			return "Tile not found";
		case LUA_ERROR_HOUSE_NOT_FOUND:
			return "House not found";
		case LUA_ERROR_COMBAT_NOT_FOUND:
			return "Combat not found";
		case LUA_ERROR_CONDITION_NOT_FOUND:
			return "Condition not found";
		case LUA_ERROR_AREA_NOT_FOUND:
			return "Area not found";
		case LUA_ERROR_CONTAINER_NOT_FOUND:
			return "Container not found";
		case LUA_ERROR_VARIANT_NOT_FOUND:
			return "Variant not found";
		case LUA_ERROR_VARIANT_UNKNOWN:
			return "Unknown variant type";
		case LUA_ERROR_SPELL_NOT_FOUND:
			return "Spell not found";
		case LUA_ERROR_ACTION_NOT_FOUND:
			return "Action not found";
		case LUA_ERROR_TALK_ACTION_NOT_FOUND:
			return "TalkAction not found";
		case LUA_ERROR_ZONE_NOT_FOUND:
			return "Zone not found";
		default:
			return "Bad error code";
	}
}

int Lua::protectedCall(lua_State* L, int nargs, int nresults) {
	if (const int ret = validateDispatcherContext(__FUNCTION__); ret != 0) {
		return ret;
	}

	const int error_index = lua_gettop(L) - nargs;
	lua_pushcfunction(L, luaErrorHandler);
	lua_insert(L, error_index);

	const int ret = lua_pcall(L, nargs, nresults, error_index);
	lua_remove(L, error_index);
	return ret;
}

void Lua::reportError(const char* function, const std::string &error_desc, bool stack_trace /* = false*/) {
	int32_t scriptId;
	int32_t callbackId;
	bool timerEvent;
	LuaScriptInterface* scriptInterface;
	getScriptEnv()->getEventInfo(scriptId, scriptInterface, callbackId, timerEvent);

	std::stringstream logMsg;
	logMsg << "Lua Script Error Detected\n";
	logMsg << "---------------------------------------\n";
	if (scriptInterface) {
		logMsg << "Interface: " << scriptInterface->getInterfaceName() << "\n";
		if (scriptId) {
			logMsg << "Script ID: " << scriptInterface->getFileById(scriptId) << "\n";
		}
		if (timerEvent) {
			logMsg << "Timer Event: Yes\n";
		}
		if (callbackId) {
			logMsg << "Callback ID: " << scriptInterface->getFileById(callbackId) << "\n";
		}
	}
	if (function && strcmp(function, "N/A") != 0) {
		logMsg << "Function: " << function << "\n";
	}
	logMsg << "Error Description: " << error_desc << "\n";
	if (stack_trace && scriptInterface) {
		const std::string stackTrace = scriptInterface->getStackTrace(error_desc);
		if (!stackTrace.empty() && stackTrace != "N/A") {
			logMsg << "Stack Trace:\n"
				   << stackTrace << "\n";
		}
	}
	logMsg << "---------------------------------------\n";

	g_logger().error(logMsg.str());
}

int Lua::luaErrorHandler(lua_State* L) {
	const std::string &errorMessage = popString(L);
	const auto interface = getScriptEnv()->getScriptInterface();
	if (!interface) {
		g_logger().error("[{}]: LuaScriptInterface not found, error: {}", __FUNCTION__, errorMessage);
		return 0;
	}

	assert(interface); // This fires if the ScriptEnvironment hasn't been setup
	pushString(L, interface->getStackTrace(errorMessage));
	return 1;
}

void Lua::pushVariant(lua_State* L, const LuaVariant &var) {
	if (validateDispatcherContext(__FUNCTION__)) {
		return;
	}

	lua_createtable(L, 0, 4);
	setField(L, "type", var.type);
	switch (var.type) {
		case VARIANT_NUMBER:
			setField(L, "number", var.number);
			break;
		case VARIANT_STRING:
			setField(L, "string", var.text);
			break;
		case VARIANT_TARGETPOSITION:
		case VARIANT_POSITION: {
			pushPosition(L, var.pos);
			lua_setfield(L, -2, "pos");
			break;
		}
		default:
			break;
	}
	setField(L, "instantName", var.instantName);
	setField(L, "runeName", var.runeName);
	setMetatable(L, -1, "Variant");
}

void Lua::pushThing(lua_State* L, const std::shared_ptr<Thing> &thing) {
	if (validateDispatcherContext(__FUNCTION__)) {
		return;
	}

	if (!thing) {
		lua_createtable(L, 0, 4);
		setField(L, "uid", 0);
		setField(L, "itemid", 0);
		setField(L, "actionid", 0);
		setField(L, "type", 0);
		return;
	}

	if (const auto &item = thing->getItem()) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else if (const auto &creature = thing->getCreature()) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}
}

void Lua::pushCylinder(lua_State* L, const std::shared_ptr<Cylinder> &cylinder) {
	if (validateDispatcherContext(__FUNCTION__)) {
		return;
	}

	if (const auto &creature = cylinder->getCreature()) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
	} else if (const auto &parentItem = cylinder->getItem()) {
		pushUserdata<Item>(L, parentItem);
		setItemMetatable(L, -1, parentItem);
	} else if (const auto &tile = cylinder->getTile()) {
		pushUserdata<Tile>(L, tile);
		setMetatable(L, -1, "Tile");
	} else if (cylinder == VirtualCylinder::virtualCylinder) {
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
}

void Lua::pushString(lua_State* L, const std::string &value) {
	if (validateDispatcherContext(__FUNCTION__)) {
		return;
	}

	lua_pushlstring(L, value.c_str(), value.length());
}

void Lua::pushNumber(lua_State* L, lua_Number value) {
	if (validateDispatcherContext(__FUNCTION__)) {
		return;
	}

	lua_pushnumber(L, value);
}

void Lua::pushCallback(lua_State* L, int32_t callback) {
	if (validateDispatcherContext(__FUNCTION__)) {
		return;
	}

	lua_rawgeti(L, LUA_REGISTRYINDEX, callback);
}

std::string Lua::popString(lua_State* L) {
	if (lua_gettop(L) == 0) {
		return {};
	}

	std::string str(getString(L, -1));
	lua_pop(L, 1);
	return str;
}

int32_t Lua::popCallback(lua_State* L) {
	return luaL_ref(L, LUA_REGISTRYINDEX);
}

// Metatables
void Lua::setMetatable(lua_State* L, int32_t index, const std::string &name) {
	if (validateDispatcherContext(__FUNCTION__)) {
		return;
	}

	luaL_getmetatable(L, name.c_str());
	lua_setmetatable(L, index - 1);
}

void Lua::setWeakMetatable(lua_State* L, int32_t index, const std::string &name) {
	static phmap::flat_hash_set<std::string> weakObjectTypes;
	if (validateDispatcherContext(__FUNCTION__)) {
		return;
	}

	const std::string &weakName = name + "_weak";

	const auto result = weakObjectTypes.emplace(name);
	if (result.second) {
		luaL_getmetatable(L, name.c_str());
		const int childMetatable = lua_gettop(L);

		luaL_newmetatable(L, weakName.c_str());
		const int metatable = lua_gettop(L);

		for (static const std::vector<std::string> methodKeys = { "__index", "__metatable", "__eq" };
		     const std::string &metaKey : methodKeys) {
			lua_getfield(L, childMetatable, metaKey.c_str());
			lua_setfield(L, metatable, metaKey.c_str());
		}

		for (static const std::vector<int> methodIndexes = { 'h', 'p', 't' };
		     const int metaIndex : methodIndexes) {
			lua_rawgeti(L, childMetatable, metaIndex);
			lua_rawseti(L, metatable, metaIndex);
		}

		lua_pushnil(L);
		lua_setfield(L, metatable, "__gc");

		lua_pushstring(L, name.c_str());
		lua_setfield(L, metatable, "__name");

		lua_remove(L, childMetatable);
	} else {
		luaL_getmetatable(L, weakName.c_str());
	}
	lua_setmetatable(L, index - 1);
}

void Lua::setItemMetatable(lua_State* L, int32_t index, const std::shared_ptr<Item> &item) {
	if (validateDispatcherContext(__FUNCTION__)) {
		return;
	}

	if (item && item->getContainer()) {
		luaL_getmetatable(L, "Container");
	} else if (item && item->getTeleport()) {
		luaL_getmetatable(L, "Teleport");
	} else {
		luaL_getmetatable(L, "Item");
	}
	lua_setmetatable(L, index - 1);
}

void Lua::setCreatureMetatable(lua_State* L, int32_t index, const std::shared_ptr<Creature> &creature) {
	if (validateDispatcherContext(__FUNCTION__)) {
		return;
	}

	if (creature && creature->getPlayer()) {
		luaL_getmetatable(L, "Player");
	} else if (creature && creature->getMonster()) {
		luaL_getmetatable(L, "Monster");
	} else {
		luaL_getmetatable(L, "Npc");
	}
	lua_setmetatable(L, index - 1);
}

CombatDamage Lua::getCombatDamage(lua_State* L) {
	CombatDamage damage;
	damage.primary.value = getNumber<int32_t>(L, -4);
	damage.primary.type = getNumber<CombatType_t>(L, -3);
	damage.secondary.value = getNumber<int32_t>(L, -2);
	damage.secondary.type = getNumber<CombatType_t>(L, -1);

	lua_pop(L, 4);
	return damage;
}

// Get
std::string Lua::getFormatedLoggerMessage(lua_State* L) {
	const std::string format = getString(L, 1);
	const int n = lua_gettop(L);
	fmt::dynamic_format_arg_store<fmt::format_context> args;

	for (int i = 2; i <= n; i++) {
		if (isString(L, i)) {
			args.push_back(lua_tostring(L, i));
		} else if (isNumber(L, i)) {
			args.push_back(lua_tonumber(L, i));
		} else if (isBoolean(L, i)) {
			args.push_back(lua_toboolean(L, i) ? "true" : "false");
		} else if (isUserdata(L, i)) {
			const LuaData_t userType = getUserdataType(L, i);
			args.push_back(getUserdataTypeName(userType));
		} else if (isTable(L, i)) {
			args.push_back("table");
		} else if (isNil(L, i)) {
			args.push_back("nil");
		} else if (isFunction(L, i)) {
			args.push_back("function");
		} else {
			g_logger().warn("[{}] invalid param type", __FUNCTION__);
		}
	}

	try {
		return fmt::vformat(format, args);
	} catch (const fmt::format_error &e) {
		g_logger().debug("[{}] format error: {}", __FUNCTION__, e.what());
		reportErrorFunc(fmt::format("Format error, {}", e.what()));
	}

	return {};
}

std::string Lua::getString(lua_State* L, int32_t arg) {
	size_t len;
	const char* c_str = lua_tolstring(L, arg, &len);
	if (!c_str || len == 0) {
		return {};
	}
	return std::string(c_str, len);
}

Position Lua::getPosition(lua_State* L, int32_t arg, int32_t &stackpos) {
	Position position;
	position.x = getField<uint16_t>(L, arg, "x");
	position.y = getField<uint16_t>(L, arg, "y");
	position.z = getField<uint8_t>(L, arg, "z");

	lua_getfield(L, arg, "stackpos");
	if (lua_isnil(L, -1) == 1) {
		stackpos = 0;
	} else {
		stackpos = getNumber<int32_t>(L, -1);
	}

	lua_pop(L, 4);
	return position;
}

Position Lua::getPosition(lua_State* L, int32_t arg) {
	Position position;
	position.x = getField<uint16_t>(L, arg, "x");
	position.y = getField<uint16_t>(L, arg, "y");
	position.z = getField<uint8_t>(L, arg, "z");

	lua_pop(L, 3);
	return position;
}

Outfit_t Lua::getOutfit(lua_State* L, int32_t arg) {
	Outfit_t outfit;
	outfit.lookMountFeet = getField<uint8_t>(L, arg, "lookMountFeet");
	outfit.lookMountLegs = getField<uint8_t>(L, arg, "lookMountLegs");
	outfit.lookMountBody = getField<uint8_t>(L, arg, "lookMountBody");
	outfit.lookMountHead = getField<uint8_t>(L, arg, "lookMountHead");
	outfit.lookFamiliarsType = getField<uint16_t>(L, arg, "lookFamiliarsType");
	outfit.lookMount = getField<uint16_t>(L, arg, "lookMount");
	outfit.lookAddons = getField<uint8_t>(L, arg, "lookAddons");

	outfit.lookFeet = getField<uint8_t>(L, arg, "lookFeet");
	outfit.lookLegs = getField<uint8_t>(L, arg, "lookLegs");
	outfit.lookBody = getField<uint8_t>(L, arg, "lookBody");
	outfit.lookHead = getField<uint8_t>(L, arg, "lookHead");

	outfit.lookTypeEx = getField<uint16_t>(L, arg, "lookTypeEx");
	outfit.lookType = getField<uint16_t>(L, arg, "lookType");

	lua_pop(L, 13);
	return outfit;
}

LuaVariant Lua::getVariant(lua_State* L, int32_t arg) {
	LuaVariant var;
	var.instantName = getFieldString(L, arg, "instantName");
	var.runeName = getFieldString(L, arg, "runeName");
	switch (var.type = getField<LuaVariantType_t>(L, arg, "type")) {
		case VARIANT_NUMBER: {
			var.number = getField<uint32_t>(L, arg, "number");
			lua_pop(L, 4);
			break;
		}

		case VARIANT_STRING: {
			var.text = getFieldString(L, arg, "string");
			lua_pop(L, 4);
			break;
		}

		case VARIANT_POSITION:
		case VARIANT_TARGETPOSITION: {
			lua_getfield(L, arg, "pos");
			var.pos = getPosition(L, lua_gettop(L));
			lua_pop(L, 4);
			break;
		}

		default: {
			var.type = VARIANT_NONE;
			lua_pop(L, 3);
			break;
		}
	}
	return var;
}

std::shared_ptr<Thing> Lua::getThing(lua_State* L, int32_t arg) {
	std::shared_ptr<Thing> thing;
	if (lua_getmetatable(L, arg) != 0) {
		lua_rawgeti(L, -1, 't');
		switch (getNumber<LuaData_t>(L, -1)) {
			case LuaData_t::Item:
				thing = Lua::getUserdataShared<Item>(L, arg, "Item");
				break;
			case LuaData_t::Container:
				thing = Lua::getUserdataShared<Container>(L, arg, "Container");
				break;
			case LuaData_t::Teleport:
				thing = Lua::getUserdataShared<Teleport>(L, arg, "Teleport");
				break;
			case LuaData_t::Player:
				thing = Lua::getUserdataShared<Player>(L, arg, "Player");
				break;
			case LuaData_t::Monster:
				thing = Lua::getUserdataShared<Monster>(L, arg, "Monster");
				break;
			case LuaData_t::Npc:
				thing = Lua::getUserdataShared<Npc>(L, arg, "Npc");
				break;
			default:
				thing = nullptr;
				break;
		}
		lua_pop(L, 2);
	} else {
		thing = getScriptEnv()->getThingByUID(getNumber<uint32_t>(L, arg));
	}
	return thing;
}

std::shared_ptr<Creature> Lua::getCreature(lua_State* L, int32_t arg) {
	if (isUserdata(L, arg)) {
		return Lua::getUserdataShared<Creature>(L, arg, "Creature");
	}
	return g_game().getCreatureByID(getNumber<uint32_t>(L, arg));
}

std::shared_ptr<Player> Lua::getPlayer(lua_State* L, int32_t arg, bool allowOffline /* = false */) {
	if (isUserdata(L, arg)) {
		return Lua::getUserdataShared<Player>(L, arg, "Player");
	} else if (isNumber(L, arg)) {
		return g_game().getPlayerByID(getNumber<uint64_t>(L, arg), allowOffline);
	} else if (isString(L, arg)) {
		return g_game().getPlayerByName(getString(L, arg), allowOffline);
	}
	g_logger().warn("Lua::getPlayer: Invalid argument.");
	return nullptr;
}

std::shared_ptr<Guild> Lua::getGuild(lua_State* L, int32_t arg, bool allowOffline /* = false */) {
	if (isUserdata(L, arg)) {
		return Lua::getUserdataShared<Guild>(L, arg, "Guild");
	} else if (isNumber(L, arg)) {
		return g_game().getGuild(getNumber<uint64_t>(L, arg), allowOffline);
	} else if (isString(L, arg)) {
		return g_game().getGuildByName(getString(L, arg), allowOffline);
	}
	g_logger().warn("Lua::getGuild: Invalid argument.");
	return nullptr;
}

std::string Lua::getFieldString(lua_State* L, int32_t arg, const std::string &key) {
	lua_getfield(L, arg, key.c_str());
	return getString(L, -1);
}

LuaData_t Lua::getUserdataType(lua_State* L, int32_t arg) {
	if (lua_getmetatable(L, arg) == 0) {
		return LuaData_t::Unknown;
	}
	lua_rawgeti(L, -1, 't');

	const LuaData_t type = getNumber<LuaData_t>(L, -1);
	lua_pop(L, 2);

	return type;
}

std::string Lua::getUserdataTypeName(LuaData_t userType) {
	return magic_enum::enum_name(userType).data();
}

// Push
void Lua::pushBoolean(lua_State* L, bool value) {
	if (validateDispatcherContext(__FUNCTION__)) {
		return;
	}

	lua_pushboolean(L, value ? 1 : 0);
}

void Lua::pushCombatDamage(lua_State* L, const CombatDamage &damage) {
	if (validateDispatcherContext(__FUNCTION__)) {
		return;
	}

	lua_pushnumber(L, damage.primary.value);
	lua_pushnumber(L, damage.primary.type);
	lua_pushnumber(L, damage.secondary.value);
	lua_pushnumber(L, damage.secondary.type);
	lua_pushnumber(L, damage.origin);
}

void Lua::pushInstantSpell(lua_State* L, const InstantSpell &spell) {
	if (validateDispatcherContext(__FUNCTION__)) {
		return;
	}

	lua_createtable(L, 0, 6);

	setField(L, "name", spell.getName());
	setField(L, "words", spell.getWords());
	setField(L, "level", spell.getLevel());
	setField(L, "mlevel", spell.getMagicLevel());
	setField(L, "mana", spell.getMana());
	setField(L, "manapercent", spell.getManaPercent());

	setMetatable(L, -1, "Spell");
}

void Lua::pushPosition(lua_State* L, const Position &position, int32_t stackpos /* = 0*/) {
	if (validateDispatcherContext(__FUNCTION__)) {
		return;
	}

	lua_createtable(L, 0, 4);

	setField(L, "x", position.x);
	setField(L, "y", position.y);
	setField(L, "z", position.z);
	setField(L, "stackpos", stackpos);

	setMetatable(L, -1, "Position");
}

void Lua::pushOutfit(lua_State* L, const Outfit_t &outfit) {
	if (validateDispatcherContext(__FUNCTION__)) {
		return;
	}

	lua_createtable(L, 0, 13);
	setField(L, "lookType", outfit.lookType);
	setField(L, "lookTypeEx", outfit.lookTypeEx);
	setField(L, "lookHead", outfit.lookHead);
	setField(L, "lookBody", outfit.lookBody);
	setField(L, "lookLegs", outfit.lookLegs);
	setField(L, "lookFeet", outfit.lookFeet);
	setField(L, "lookAddons", outfit.lookAddons);
	setField(L, "lookMount", outfit.lookMount);
	setField(L, "lookMountHead", outfit.lookMountHead);
	setField(L, "lookMountBody", outfit.lookMountBody);
	setField(L, "lookMountLegs", outfit.lookMountLegs);
	setField(L, "lookMountFeet", outfit.lookMountFeet);
	setField(L, "lookFamiliarsType", outfit.lookFamiliarsType);
}

void Lua::registerClass(lua_State* L, const std::string &className, const std::string &baseClass, lua_CFunction newFunction /* = nullptr*/) {
	// className = {}
	lua_newtable(L);
	lua_pushvalue(L, -1);
	lua_setglobal(L, className.c_str());
	const int methods = lua_gettop(L);

	// methodsTable = {}
	lua_newtable(L);
	const int methodsTable = lua_gettop(L);

	if (newFunction) {
		// className.__call = newFunction
		lua_pushcfunction(L, newFunction);
		lua_setfield(L, methodsTable, "__call");
	}

	uint32_t parents = 0;
	if (!baseClass.empty()) {
		lua_getglobal(L, baseClass.c_str());
		lua_rawgeti(L, -1, 'p');
		parents = getNumber<uint32_t>(L, -1) + 1;
		lua_pop(L, 1);
		lua_setfield(L, methodsTable, "__index");
	}

	// setmetatable(className, methodsTable)
	lua_setmetatable(L, methods);

	// className.metatable = {}
	luaL_newmetatable(L, className.c_str());
	const int metatable = lua_gettop(L);

	// className.metatable.__metatable = className
	lua_pushvalue(L, methods);
	lua_setfield(L, metatable, "__metatable");

	// className.metatable.__index = className
	lua_pushvalue(L, methods);
	lua_setfield(L, metatable, "__index");

	// className.metatable['h'] = hash
	lua_pushnumber(L, std::hash<std::string>()(className));
	lua_rawseti(L, metatable, 'h');

	// className.metatable['p'] = parents
	lua_pushnumber(L, parents);
	lua_rawseti(L, metatable, 'p');

	lua_pushstring(L, className.c_str());
	lua_setfield(L, metatable, "__name");

	if (!baseClass.empty()) {
		lua_pushstring(L, baseClass.c_str());
		lua_setfield(L, metatable, "baseclass");
	}

	// className.metatable['t'] = type
	auto userTypeEnum = magic_enum::enum_cast<LuaData_t>(className);
	if (userTypeEnum.has_value()) {
		lua_pushnumber(L, static_cast<lua_Number>(userTypeEnum.value()));
	} else {
		lua_pushnumber(L, static_cast<lua_Number>(LuaData_t::Unknown));
	}
	lua_rawseti(L, metatable, 't');

	// pop className, className.metatable
	lua_pop(L, 2);
}

void Lua::registerMethod(lua_State* L, const std::string &globalName, const std::string &methodName, lua_CFunction func) {
	// globalName.methodName = func
	lua_getglobal(L, globalName.c_str());
	lua_pushcfunction(L, func);
	lua_setfield(L, -2, methodName.c_str());

	// pop globalName
	lua_pop(L, 1);
}

void Lua::registerTable(lua_State* L, const std::string &tableName) {
	// _G[tableName] = {}
	lua_newtable(L);
	lua_setglobal(L, tableName.c_str());
}

void Lua::registerMetaMethod(lua_State* L, const std::string &className, const std::string &methodName, lua_CFunction func) {
	// className.metatable.methodName = func
	luaL_getmetatable(L, className.c_str());
	lua_pushcfunction(L, func);
	lua_setfield(L, -2, methodName.c_str());

	// pop className.metatable
	lua_pop(L, 1);
}

void Lua::registerVariable(lua_State* L, const std::string &tableName, const std::string &name, lua_Number value) {
	// tableName.name = value
	lua_getglobal(L, tableName.c_str());
	setField(L, name.c_str(), value);

	// pop tableName
	lua_pop(L, 1);
}

void Lua::registerGlobalBoolean(lua_State* L, const std::string &name, bool value) {
	// _G[name] = value
	pushBoolean(L, value);
	lua_setglobal(L, name.c_str());
}

void Lua::registerGlobalMethod(lua_State* L, const std::string &functionName, lua_CFunction func) {
	// _G[functionName] = func
	lua_pushcfunction(L, func);
	lua_setglobal(L, functionName.c_str());
}

void Lua::registerGlobalVariable(lua_State* L, const std::string &name, lua_Number value) {
	// _G[name] = value
	lua_pushnumber(L, value);
	lua_setglobal(L, name.c_str());
}

void Lua::registerGlobalString(lua_State* L, const std::string &variable, const std::string &name) {
	// Example: registerGlobalString(L, "VARIABLE_NAME", "variable string");
	pushString(L, name);
	lua_setglobal(L, variable.c_str());
}

std::string Lua::escapeString(const std::string &string) {
	std::string s = string;
	replaceString(s, "\\", "\\\\");
	replaceString(s, "\"", "\\\"");
	replaceString(s, "'", "\\'");
	replaceString(s, "[[", "\\[[");
	return s;
}

int Lua::luaUserdataCompare(lua_State* L) {
	pushBoolean(L, getUserdata<void>(L, 1) == getUserdata<void>(L, 2));
	return 1;
}

void Lua::registerSharedClass(lua_State* L, const std::string &className, const std::string &baseClass, lua_CFunction newFunction) {
	registerClass(L, className, baseClass, newFunction);
	registerMetaMethod(L, className, "__gc", luaGarbageCollection);
}

int Lua::luaGarbageCollection(lua_State* L) {
	const auto objPtr = static_cast<std::shared_ptr<SharedObject>*>(lua_touserdata(L, 1));
	if (objPtr) {
		objPtr->reset();
	}
	return 0;
}

int Lua::validateDispatcherContext(std::string_view fncName) {
	if (DispatcherContext::isOn() && g_dispatcher().context().isAsync()) {
		g_logger().warn("[{}] The call to lua was ignored because the '{}' task is trying to communicate while in async mode.", fncName, g_dispatcher().context().getName());
		return LUA_ERRRUN;
	}

	return 0;
}

bool Lua::checkMetatableInheritance(lua_State* L, int index, const char* expectedName) {
	if (!lua_getmetatable(L, index)) {
		return false;
	}

	// Traverse the inheritance chain.
	bool found = false;
	while (true) {
		// Check the "__name" field.
		lua_getfield(L, -1, "__name");
		const char* currentName = lua_tostring(L, -1);
		lua_pop(L, 1); // Remove __name.
		if (currentName && strcmp(currentName, expectedName) == 0) {
			found = true;
			break;
		}

		// Check for a "baseclass" field.
		lua_getfield(L, -1, "baseclass");
		if (lua_isstring(L, -1)) {
			const char* baseName = lua_tostring(L, -1);
			lua_pop(L, 1); // Remove baseclass value.
			if (baseName && strcmp(baseName, expectedName) == 0) {
				found = true;
				break;
			}
			// Move to the metatable of the base class.
			luaL_getmetatable(L, baseName);
			if (lua_isnil(L, -1)) {
				lua_pop(L, 1);
				break;
			}
			lua_remove(L, -2); // Remove current metatable.
			continue;
		}
		lua_pop(L, 1); // Remove non-string baseclass.

		// Fallback: try the "__index" table.
		lua_getfield(L, -1, "__index");
		if (!lua_istable(L, -1)) {
			lua_pop(L, 1);
			break;
		}
		lua_remove(L, -2); // Remove current metatable; keep __index.
	}
	lua_pop(L, 1); // Remove final metatable.
	return found;
}
