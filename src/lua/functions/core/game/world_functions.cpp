#include "lua/functions/core/game/world_functions.hpp"

#include "game/game.hpp"
#include "items/item.hpp"
#include "lua/functions/lua_functions_loader.hpp"
#include "world/world_behaviors.hpp"
#include "world/world_runtime.hpp"
#include "world/world_runtime_items.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <charconv>
	#include <cmath>
	#include <limits>
	#include <type_traits>
#endif

struct WorldObject {
	std::string id;
	std::optional<WorldObjectToken> guard;
	std::shared_ptr<bool> invocation;
};
struct WorldContext {
	WorldObjectToken object;
	std::shared_ptr<bool> invocation;
	world_layers::Value::Record parameters;
	std::map<std::string, world_layers::Parameter> parameterTypes;
	std::map<std::string, std::vector<world_layers::Reference>> relations;
	std::map<std::string, world_layers::RelationType> relationTypes;
};
struct WorldReference {
	WorldObjectToken owner;
	world_layers::Reference reference;
	std::optional<WorldObjectToken> target;
	std::shared_ptr<bool> invocation;
};

template <>
struct LuaUserdataTraits<WorldObject> {
	static constexpr std::string_view name = "WorldObject";
};
template <>
struct LuaUserdataTraits<WorldContext> {
	static constexpr std::string_view name = "WorldContext";
};
template <>
struct LuaUserdataTraits<WorldReference> {
	static constexpr std::string_view name = "WorldReference";
};
template <>
struct LuaUserdataTraits<WorldBehaviorRegistration> {
	static constexpr std::string_view name = "WorldBehavior";
};

namespace {
	WorldLayerRuntime &runtime() {
		return g_game().worldLayers();
	}
	bool valid(const std::shared_ptr<WorldObject> &object) {
		return object && runtime().isDeclared(object->id) && (!object->guard || (object->invocation ? *object->invocation && runtime().callbackEpoch() == object->guard->epoch : runtime().resolve(*object->guard)));
	}
	bool valid(const std::shared_ptr<WorldContext> &context) {
		return context && context->invocation && *context->invocation && runtime().callbackEpoch() == context->object.epoch;
	}
	bool valid(const std::shared_ptr<WorldReference> &reference) {
		return reference && reference->invocation && *reference->invocation && runtime().callbackEpoch() == reference->owner.epoch && reference->target && runtime().resolve(*reference->target);
	}
	void pushObject(lua_State* L, const std::string &id, std::optional<WorldObjectToken> guard = std::nullopt, const std::shared_ptr<bool> &invocation = {}) {
		const auto object = std::make_shared<WorldObject>(WorldObject { id, std::move(guard), invocation });
		if (!valid(object)) {
			lua_pushnil(L);
			return;
		}
		Lua::pushSharedUserdata<WorldObject>(L, object);
	}
	void pushReference(lua_State* L, const WorldObjectToken &owner, const world_layers::Reference &reference, const std::shared_ptr<bool> &invocation) {
		Lua::pushSharedUserdata<WorldReference>(L, std::make_shared<WorldReference>(WorldReference { owner, reference, runtime().token(reference.object), invocation }));
	}
	world_layers::Position valuePosition(const world_layers::Value &value) {
		const auto &record = std::get<world_layers::Value::Record>(value.data);
		return { static_cast<int32_t>(std::get<int64_t>(record.at("x").data)), static_cast<int32_t>(std::get<int64_t>(record.at("y").data)), static_cast<int32_t>(std::get<int64_t>(record.at("z").data)) };
	}
	void pushValue(lua_State* L, const world_layers::Value &value, const world_layers::Parameter* type, const WorldObjectToken &owner, const std::shared_ptr<bool> &invocation) {
		if (type && type->type == "position") {
			Lua::pushPosition(L, world_runtime::native(valuePosition(value)));
			return;
		}
		if (type && type->type == "objectRef") {
			const auto &record = std::get<world_layers::Value::Record>(value.data);
			world_layers::Reference reference;
			reference.object = std::get<std::string>(record.at("object").data);
			if (const auto offset = record.find("offset"); offset != record.end()) {
				reference.offset = valuePosition(offset->second);
			}
			pushReference(L, owner, reference, invocation);
			return;
		}
		std::visit([&](const auto &data) {
			using T = std::decay_t<decltype(data)>;
			if constexpr (std::is_same_v<T, std::monostate>) {
				lua_pushnil(L);
			} else if constexpr (std::is_same_v<T, bool>) {
				Lua::pushBoolean(L, data);
			} else if constexpr (std::is_arithmetic_v<T>) {
				lua_pushnumber(L, static_cast<lua_Number>(data));
			} else if constexpr (std::is_same_v<T, std::string>) {
				Lua::pushString(L, data);
			} else if constexpr (std::is_same_v<T, world_layers::Value::List>) {
				lua_createtable(L, static_cast<int>(data.size()), 0);
				int i = 1;
				for (const auto &entry : data) {
					pushValue(L, entry, type && type->element.size() == 1 ? &type->element.front() : nullptr, owner, invocation);
					lua_rawseti(L, -2, i++);
				}
			} else {
				lua_createtable(L, 0, static_cast<int>(data.size()));
				for (const auto &[name, entry] : data) {
					const auto schema = type ? type->fields.find(name) : std::map<std::string, world_layers::Parameter>::const_iterator {};
					pushValue(L, entry, type && schema != type->fields.end() ? &schema->second : nullptr, owner, invocation);
					lua_setfield(L, -2, name.c_str());
				}
			}
		},
		           value.data);
	}
	bool tokenField(lua_State* L, const char* field, uint64_t &value) {
		lua_getfield(L, 1, field);
		if (lua_type(L, -1) != LUA_TSTRING) {
			lua_pop(L, 1);
			return false;
		}
		const auto text = Lua::getString(L, -1);
		lua_pop(L, 1);
		const auto parsed = std::from_chars(text.data(), text.data() + text.size(), value);
		return parsed.ec == std::errc {} && parsed.ptr == text.data() + text.size() && value != 0;
	}
}

void WorldFunctions::init(lua_State* L) {
	Lua::registerTable(L, "World");
	Lua::registerMethod(L, "World", "get", WorldFunctions::luaWorldGet);
	Lua::registerMethod(L, "World", "resolve", WorldFunctions::luaWorldResolve);
	Lua::registerMethod(L, "World", "fromItem", WorldFunctions::luaWorldFromItem);
	Lua::registerSharedClass<WorldObject>(L, "");
	Lua::registerMethod(L, "WorldObject", "getItem", WorldFunctions::luaWorldObjectGetItem);
	Lua::registerMethod(L, "WorldObject", "getPosition", WorldFunctions::luaWorldObjectGetPosition);
	Lua::registerMethod(L, "WorldObject", "getInitialItemId", WorldFunctions::luaWorldObjectGetInitialItemId);
	Lua::registerMethod(L, "WorldObject", "token", WorldFunctions::luaWorldObjectToken);
	Lua::registerSharedClass<WorldContext>(L, "");
	Lua::registerMethod(L, "WorldContext", "object", WorldFunctions::luaWorldContextObject);
	Lua::registerMethod(L, "WorldContext", "parameter", WorldFunctions::luaWorldContextParameter);
	Lua::registerMethod(L, "WorldContext", "relation", WorldFunctions::luaWorldContextRelation);
	Lua::registerSharedClass<WorldReference>(L, "");
	Lua::registerMethod(L, "WorldReference", "getObject", WorldFunctions::luaWorldReferenceGetObject);
	Lua::registerMethod(L, "WorldReference", "getPosition", WorldFunctions::luaWorldReferenceGetPosition);
	Lua::registerSharedClass<WorldBehaviorRegistration>(L, "", WorldFunctions::luaCreateWorldBehavior);
	Lua::registerMethod(L, "WorldBehavior", "register", WorldFunctions::luaWorldBehaviorRegister);
	Lua::registerMetaMethod(L, "WorldBehavior", "__newindex", WorldFunctions::luaWorldBehaviorNewIndex);
}

void WorldFunctions::pushContext(lua_State* L, const WorldObjectToken &object, const world_layers::BehaviorBinding &binding, const world_layers::BehaviorDescriptor &descriptor, const std::shared_ptr<bool> &invocation) {
	auto context = std::make_shared<WorldContext>();
	context->object = object;
	context->invocation = invocation;
	context->parameters = world_layers::resolveParameters(descriptor, binding);
	context->parameterTypes = descriptor.parameters;
	context->relations = binding.relations;
	context->relationTypes = descriptor.relations;
	Lua::pushSharedUserdata<WorldContext>(L, std::move(context));
}

/***
 * @function World.get
 * @param id string
 * @return WorldObject|nil
 */
int WorldFunctions::luaWorldGet(lua_State* L) {
	pushObject(L, Lua::getString(L, 1));
	return 1;
}

/***
 * @function World.resolve
 * @param token table
 * @return WorldObject|nil
 */
int WorldFunctions::luaWorldResolve(lua_State* L) {
	WorldObjectToken token;
	if (!lua_istable(L, 1) || !tokenField(L, "generation", token.generation) || !tokenField(L, "epoch", token.epoch)) {
		lua_pushnil(L);
		return 1;
	}
	lua_getfield(L, 1, "id");
	if (lua_type(L, -1) != LUA_TSTRING) {
		lua_pop(L, 1);
		lua_pushnil(L);
		return 1;
	}
	token.id = Lua::getString(L, -1);
	lua_pop(L, 1);
	pushObject(L, token.id, token);
	return 1;
}

/***
 * @function World.fromItem
 * @param item Item
 * @return WorldObject|nil
 */
int WorldFunctions::luaWorldFromItem(lua_State* L) {
	pushObject(L, runtime().identity(Lua::getUserdataShared<Item>(L, 1, "Item")));
	return 1;
}

/***
 * @function WorldObject:getItem
 * @return Item|nil
 */
int WorldFunctions::luaWorldObjectGetItem(lua_State* L) {
	const auto object = Lua::getUserdataShared<WorldObject>(L, 1, "WorldObject");
	const auto item = valid(object) ? runtime().item(object->id) : nullptr;
	if (item) {
		Lua::pushThing(L, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

/***
 * @function WorldObject:getPosition
 * @return Position|nil
 */
int WorldFunctions::luaWorldObjectGetPosition(lua_State* L) {
	const auto object = Lua::getUserdataShared<WorldObject>(L, 1, "WorldObject");
	const auto position = valid(object) ? runtime().position(object->id) : std::nullopt;
	if (position) {
		Lua::pushPosition(L, world_runtime::native(*position));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

/***
 * @function WorldObject:getInitialItemId
 * @return integer|nil
 */
int WorldFunctions::luaWorldObjectGetInitialItemId(lua_State* L) {
	const auto object = Lua::getUserdataShared<WorldObject>(L, 1, "WorldObject");
	const auto definition = valid(object) ? runtime().object(object->id) : nullptr;
	if (definition && definition->kind == world_layers::ObjectKind::Item) {
		lua_pushinteger(L, definition->itemId);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

/***
 * @function WorldObject:token
 * @return table|nil
 */
int WorldFunctions::luaWorldObjectToken(lua_State* L) {
	const auto object = Lua::getUserdataShared<WorldObject>(L, 1, "WorldObject");
	const auto token = valid(object) ? runtime().token(object->id) : std::nullopt;
	if (!token) {
		lua_pushnil(L);
		return 1;
	}
	// Decimal strings retain every generation bit on LuaJIT's double number type.
	lua_createtable(L, 0, 3);
	Lua::pushString(L, token->id);
	lua_setfield(L, -2, "id");
	Lua::pushString(L, std::to_string(token->generation));
	lua_setfield(L, -2, "generation");
	Lua::pushString(L, std::to_string(token->epoch));
	lua_setfield(L, -2, "epoch");
	return 1;
}

/***
 * @function WorldContext:object
 * @return WorldObject|nil
 */
int WorldFunctions::luaWorldContextObject(lua_State* L) {
	const auto context = Lua::getUserdataShared<WorldContext>(L, 1, "WorldContext");
	if (valid(context)) {
		pushObject(L, context->object.id, context->object, context->invocation);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

/***
 * @function WorldContext:parameter
 * @param name string
 * @return boolean|integer|number|string|table|Position|WorldReference|nil
 */
int WorldFunctions::luaWorldContextParameter(lua_State* L) {
	const auto context = Lua::getUserdataShared<WorldContext>(L, 1, "WorldContext");
	if (!valid(context)) {
		lua_pushnil(L);
		return 1;
	}
	const auto name = Lua::getString(L, 2);
	const auto value = context->parameters.find(name);
	const auto type = context->parameterTypes.find(name);
	if (value == context->parameters.end() || type == context->parameterTypes.end()) {
		lua_pushnil(L);
		return 1;
	}
	pushValue(L, value->second, &type->second, context->object, context->invocation);
	return 1;
}

/***
 * @function WorldContext:relation
 * @param name string
 * @return WorldReference|WorldReference[]|nil
 */
int WorldFunctions::luaWorldContextRelation(lua_State* L) {
	const auto context = Lua::getUserdataShared<WorldContext>(L, 1, "WorldContext");
	if (!valid(context)) {
		lua_pushnil(L);
		return 1;
	}
	const auto name = Lua::getString(L, 2);
	const auto relation = context->relations.find(name);
	const auto type = context->relationTypes.find(name);
	if (relation == context->relations.end() || type == context->relationTypes.end()) {
		lua_pushnil(L);
		return 1;
	}
	if (type->second.maximum == 1) {
		if (relation->second.empty()) {
			lua_pushnil(L);
		} else {
			pushReference(L, context->object, relation->second.front(), context->invocation);
		}
	} else {
		lua_createtable(L, static_cast<int>(relation->second.size()), 0);
		int index = 1;
		for (const auto &entry : relation->second) {
			pushReference(L, context->object, entry, context->invocation);
			lua_rawseti(L, -2, index++);
		}
	}
	return 1;
}

/***
 * @function WorldReference:getObject
 * @return WorldObject|nil
 */
int WorldFunctions::luaWorldReferenceGetObject(lua_State* L) {
	const auto reference = Lua::getUserdataShared<WorldReference>(L, 1, "WorldReference");
	if (valid(reference)) {
		pushObject(L, reference->reference.object, reference->target);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

/***
 * @function WorldReference:getPosition
 * @return Position|nil
 */
int WorldFunctions::luaWorldReferenceGetPosition(lua_State* L) {
	const auto reference = Lua::getUserdataShared<WorldReference>(L, 1, "WorldReference");
	auto position = valid(reference) ? runtime().position(reference->reference.object) : std::nullopt;
	if (position) {
		position->x += reference->reference.offset.x;
		position->y += reference->reference.offset.y;
		position->z += reference->reference.offset.z;
	}
	if (position && world_layers::isValidPosition(*position)) {
		Lua::pushPosition(L, world_runtime::native(*position));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

/***
 * @class WorldBehavior
 * @overload fun(id: string, contractVersion: integer): WorldBehavior
 * @field onUse fun(context: WorldContext, player: Player, item: Item, fromPosition: Position, target: Item|Creature|table, toPosition: Position, isHotkey: boolean): boolean
 * @field onStepIn fun(context: WorldContext, creature: Creature, item: Item, position: Position, fromPosition: Position): boolean
 * @field onStepOut fun(context: WorldContext, creature: Creature, item: Item, position: Position, fromPosition: Position): boolean
 * @field onAddItem fun(context: WorldContext, movingItem: Item, tileItem: Item|nil, position: Position): boolean
 * @field onRemoveItem fun(context: WorldContext, movingItem: Item, tileItem: Item|nil, position: Position): boolean
 */
int WorldFunctions::luaCreateWorldBehavior(lua_State* L) {
	const auto version = lua_tonumber(L, 3);
	if (lua_type(L, 2) != LUA_TSTRING || lua_type(L, 3) != LUA_TNUMBER || !std::isfinite(version) || version < 1 || version > std::numeric_limits<uint32_t>::max() || std::trunc(version) != version) {
		Lua::reportErrorFunc("WorldBehavior requires a string identity and a positive uint32 contract version");
		lua_pushnil(L);
		return 1;
	}
	const auto registration = runtime().behaviors().registration(Lua::getString(L, 2), static_cast<uint32_t>(version));
	if (registration) {
		Lua::pushSharedUserdata<WorldBehaviorRegistration>(L, registration);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

/***
 * @function WorldBehavior:register
 * @return boolean
 */
int WorldFunctions::luaWorldBehaviorRegister(lua_State* L) {
	const auto registration = Lua::getUserdataShared<WorldBehaviorRegistration>(L, 1, "WorldBehavior");
	Lua::pushBoolean(L, registration && runtime().behaviors().registerBehavior(*registration));
	return 1;
}

int WorldFunctions::luaWorldBehaviorNewIndex(lua_State* L) {
	const auto registration = Lua::getUserdataShared<WorldBehaviorRegistration>(L, 1, "WorldBehavior");
	const auto name = Lua::getString(L, 2);
	if (!registration || !runtime().behaviors().setCallback(*registration, name, L)) {
		Lua::reportErrorFunc("WorldBehavior callback is unavailable or incompatible: " + name);
	}
	return 0;
}
