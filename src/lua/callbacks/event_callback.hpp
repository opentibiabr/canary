/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

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

	LuaScriptInterface* getScriptInterface() const noexcept;
	bool loadScriptId();
	int32_t getScriptId() const noexcept;
	void setScriptId(int32_t newScriptId) noexcept;
	bool isLoadedScriptId() const noexcept;
	bool canExecute() const;

	void setEnabled(bool enabled) noexcept {
		m_enabled = enabled;
	}
	bool isEnabled() const noexcept {
		return m_enabled;
	}

	void setPriority(int32_t priority) noexcept {
		m_priority = std::clamp(priority, -1000, 1000);
	}
	int32_t getPriority() const noexcept {
		return m_priority;
	}

	template <typename... Args>
	[[nodiscard]] bool execute(Args &&... args) const;

	/**
	 * @brief Retrieves the callback name.
	 * @return The callback name as a string.
	 */
	std::string getName() const;

	/**
	 * @brief Retrieves the skip registration status of the callback.
	 * @return True if the callback is true for skip duplication check and register again the event, false otherwise.
	 */
	bool skipDuplicationCheck() const;

	/**
	 * @brief Sets the skip duplication check status for the callback.
	 * @param skip True to skip duplication check, false otherwise.
	 */
	void setSkipDuplicationCheck(bool skip);

	/**
	 * @brief Retrieves the script type name.
	 * @return The script type name as a string.
	 */
	std::string getScriptTypeName() const;

	/**
	 * @brief Sets a new script type name.
	 * @param newName The new name to set for the script type.
	 */
	void setScriptTypeName(std::string_view newName);

	/**
	 * @brief Retrieves the type of the event callback.
	 * @return The type of the event callback as defined in the EventCallback_t enumeration.
	 */
	EventCallback_t getType() const;

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
	getScriptInterface()->pushFunction(getScriptId());

	int argc = 0;
	((pushArgument(L, std::forward<Args>(args)), ++argc), ...);

	const bool result = getScriptInterface()->callFunction(argc);
	return result;
}
