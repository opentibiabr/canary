/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <functional>
	#include <type_traits>
	#include <utility>
	#include <vector>
#endif

#include "lua/callbacks/callbacks_definitions.hpp"
#include "lua/scripts/luascript.hpp"

class Creature;
class Player;
class Tile;
class Party;
class ItemType;
class Monster;
class Zone;
class Thing;
class Item;
class Cylinder;
class Npc;
class Container;

struct lua_State;
struct Position;
struct CombatDamage;
struct Outfit_t;

enum Direction : uint8_t;
enum ReturnValue : uint16_t;
enum SpeakClasses : uint8_t;
enum Slots_t : uint8_t;
enum ZoneType_t : uint8_t;
enum skills_t : int8_t;
enum CombatType_t : uint8_t;
enum CombatOrigin : uint8_t;
enum TextColor_t : uint8_t;

/**
 * @class EventCallback
 * @brief Represents an individual event callback within the game.
 *
 * @details This class encapsulates a specific event callback, allowing for the definition,
 * registration, and execution of custom behavior tied to specific game events.
 * @note It inherits from the Script class, providing scripting capabilities.
 */
class EventCallback {
private:
	EventCallback_t m_callbackType = EventCallback_t::none; ///< The type of the event callback.
	std::string m_scriptTypeName; ///< The name associated with the script type.
	std::string m_callbackName; ///< The name of the callback.
	bool m_skipDuplicationCheck = false; ///< Whether the callback is silent error for already registered log error.

	int32_t m_scriptId { kInvalidScriptId };
	bool m_enabled = true;
	int32_t m_priority = 0;
	LuaScriptInterface* m_scriptInterface = nullptr; ///< Non-owning pointer to script interface.

	struct DamageRef {
		CombatDamage* damage;
		int registryIndex;
	};

	template <typename ArgT>
	static void pushCallbackArgument(lua_State* L, ArgT &&arg, std::vector<DamageRef> &damageRefs, int &argc);
	static void pushDamageReference(lua_State* L, CombatDamage &damage, std::vector<DamageRef> &damageRefs, int &argc);
	static void applyDamageReferences(lua_State* L, const std::vector<DamageRef> &damageRefs);
	static void updateDamageEntry(lua_State* L, int index, const char* field, CombatType_t &type, int32_t &value);
	static void updateDamageOrigin(lua_State* L, int index, CombatOrigin &origin);
	static void updateDamageCritical(lua_State* L, int index, bool &critical);
	template <typename T>
	static void updateNumberField(lua_State* L, int index, const char* field, T &value);
	static void updateBooleanField(lua_State* L, int index, const char* field, bool &value);

	static void pushArgument(lua_State* L, const std::shared_ptr<Player> &player);
	static void pushArgument(lua_State* L, const std::shared_ptr<Item> &item);
	static void pushArgument(lua_State* L, const std::shared_ptr<Creature> &creature);
	static void pushArgument(lua_State* L, const std::shared_ptr<Party> &party);
	static void pushArgument(lua_State* L, const std::shared_ptr<Monster> &monster);
	static void pushArgument(lua_State* L, const std::shared_ptr<Container> &container);
	static void pushArgument(lua_State* L, const std::shared_ptr<Zone> &zone);
	static void pushArgument(lua_State* L, const std::shared_ptr<Tile> &tile);
	static void pushArgument(lua_State* L, const std::shared_ptr<Thing> &thing);
	static void pushArgument(lua_State* L, const std::shared_ptr<Cylinder> &cylinder);
	static void pushArgument(lua_State* L, const ItemType* itemType);
	static void pushArgument(lua_State* L, CombatDamage &damage);
	static void pushArgument(lua_State* L, const Position &position);
	static void pushArgument(lua_State* L, const Outfit_t &outfit);
	static void pushArgument(lua_State* L, const std::string &value);
	static void pushArgument(lua_State* L, int32_t value);
	static void pushArgument(lua_State* L, uint32_t value);
	static void pushArgument(lua_State* L, uint64_t value);
	static void pushArgument(lua_State* L, uint8_t value);
	static void pushArgument(lua_State* L, std::reference_wrapper<CombatDamage> value);
	static void pushArgument(lua_State* L, bool value);
	static void pushArgument(lua_State* L, Direction value);
	static void pushArgument(lua_State* L, ReturnValue value);
	static void pushArgument(lua_State* L, SpeakClasses value);
	static void pushArgument(lua_State* L, Slots_t value);
	static void pushArgument(lua_State* L, ZoneType_t value);
	static void pushArgument(lua_State* L, skills_t value);
	static void pushArgument(lua_State* L, CombatType_t value);
	static void pushArgument(lua_State* L, TextColor_t value);

public:
	static constexpr int32_t kInvalidScriptId = -1;

	explicit EventCallback(const std::string &callbackName, bool skipDuplicationCheck, LuaScriptInterface* interface = nullptr);

	[[nodiscard]] LuaScriptInterface* getScriptInterface() const noexcept;
	bool loadScriptId();
	[[nodiscard]] int32_t getScriptId() const noexcept;
	void setScriptId(int32_t newScriptId) noexcept;
	[[nodiscard]] bool isLoadedScriptId() const noexcept;
	[[nodiscard]] bool canExecute() const;

	void setEnabled(bool enabled) noexcept {
		m_enabled = enabled;
	}
	[[nodiscard]] bool isEnabled() const noexcept {
		return m_enabled;
	}

	void setPriority(int32_t priority) noexcept {
		m_priority = std::clamp(priority, -1000, 1000);
	}
	[[nodiscard]] int32_t getPriority() const noexcept {
		return m_priority;
	}

	template <typename... Args>
	[[nodiscard]] bool execute(Args &&... args) const;

	/**
	 * @brief Retrieves the callback name.
	 * @return The callback name as a string.
	 */
	[[nodiscard]] std::string getName() const;

	/**
	 * @brief Retrieves the skip registration status of the callback.
	 * @return True if the callback is true for skip duplication check and register again the event, false otherwise.
	 */
	[[nodiscard]] bool skipDuplicationCheck() const;

	/**
	 * @brief Sets the skip duplication check status for the callback.
	 * @param skip True to skip duplication check, false otherwise.
	 */
	void setSkipDuplicationCheck(bool skip);

	/**
	 * @brief Retrieves the script type name.
	 * @return The script type name as a string.
	 */
	[[nodiscard]] std::string getScriptTypeName() const;

	/**
	 * @brief Sets a new script type name.
	 * @param newName The new name to set for the script type.
	 */
	void setScriptTypeName(std::string_view newName);

	/**
	 * @brief Retrieves the type of the event callback.
	 * @return The type of the event callback as defined in the EventCallback_t enumeration.
	 */
	[[nodiscard]] EventCallback_t getType() const;

	/**
	 * @brief Sets the type of the event callback.
	 * @param type The new type to set, as defined in the EventCallback_t enumeration.
	 */
	void setType(EventCallback_t type);
};

template <typename... Args>
[[nodiscard]] bool EventCallback::execute(Args &&... args) const {
	if (!canExecute()) {
		return false;
	}
	if (!Lua::reserveScriptEnv()) {
		g_logger().error("[EventCallback::execute] Call stack overflow. Too many lua script calls being nested.");
		return false;
	}

	ScriptEnvironment* scriptEnvironment = Lua::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	if (!getScriptInterface()->pushFunction(getScriptId())) {
		g_logger().error("[EventCallback::execute] Failed to push callback '{}' to the stack", m_callbackName);
		return false;
	}

	std::vector<DamageRef> damageRefs;
	int argc = 0;
	(pushCallbackArgument(L, std::forward<Args>(args), damageRefs, argc), ...);

	const bool result = getScriptInterface()->callFunction(argc);

	applyDamageReferences(L, damageRefs);

	return result;
}

template <typename ArgT>
void EventCallback::pushCallbackArgument(lua_State* L, ArgT &&arg, std::vector<DamageRef> &damageRefs, int &argc) {
	using ValueT = std::remove_cvref_t<ArgT>;
	if constexpr (std::is_same_v<ValueT, std::reference_wrapper<CombatDamage>>) {
		pushDamageReference(L, arg.get(), damageRefs, argc);
	} else if constexpr (std::is_same_v<ValueT, CombatDamage>) {
		auto &damage = const_cast<CombatDamage &>(arg);
		pushDamageReference(L, damage, damageRefs, argc);
	} else {
		pushArgument(L, std::forward<ArgT>(arg));
		++argc;
	}
}

inline void EventCallback::pushDamageReference(lua_State* L, CombatDamage &damage, std::vector<DamageRef> &damageRefs, int &argc) {
	pushArgument(L, damage);
	lua_pushvalue(L, -1);
	const int ref = luaL_ref(L, LUA_REGISTRYINDEX);
	damageRefs.push_back(DamageRef { &damage, ref });
	++argc;
}

inline void EventCallback::applyDamageReferences(lua_State* L, const std::vector<DamageRef> &damageRefs) {
	for (const auto &entry : damageRefs) {
		lua_rawgeti(L, LUA_REGISTRYINDEX, entry.registryIndex);
		if (lua_istable(L, -1)) {
			const int index = lua_gettop(L);
			updateDamageEntry(L, index, "primary", entry.damage->primary.type, entry.damage->primary.value);
			updateDamageEntry(L, index, "secondary", entry.damage->secondary.type, entry.damage->secondary.value);
			updateDamageOrigin(L, index, entry.damage->origin);
			updateDamageCritical(L, index, entry.damage->critical);
		}
		luaL_unref(L, LUA_REGISTRYINDEX, entry.registryIndex);
		lua_pop(L, 1);
	}
}

inline void EventCallback::updateDamageEntry(lua_State* L, int index, const char* field, CombatType_t &type, int32_t &value) {
	lua_getfield(L, index, field);
	if (!lua_istable(L, -1)) {
		lua_pop(L, 1);
		return;
	}

	updateNumberField(L, -1, "value", value);
	updateNumberField(L, -1, "type", type);
	lua_pop(L, 1);
}

inline void EventCallback::updateDamageOrigin(lua_State* L, int index, CombatOrigin &origin) {
	updateNumberField(L, index, "origin", origin);
}

inline void EventCallback::updateDamageCritical(lua_State* L, int index, bool &critical) {
	updateBooleanField(L, index, "critical", critical);
}

template <typename T>
void EventCallback::updateNumberField(lua_State* L, int index, const char* field, T &value) {
	lua_getfield(L, index, field);
	if (lua_isnumber(L, -1)) {
		value = Lua::getNumber<T>(L, -1);
	}
	lua_pop(L, 1);
}

inline void EventCallback::updateBooleanField(lua_State* L, int index, const char* field, bool &value) {
	lua_getfield(L, index, field);
	if (lua_isboolean(L, -1)) {
		value = Lua::getBoolean(L, -1);
	}
	lua_pop(L, 1);
}
