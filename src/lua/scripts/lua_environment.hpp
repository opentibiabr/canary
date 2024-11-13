/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/combat/combat.hpp"
#include "declarations.hpp"
#include "lua/scripts/luascript.hpp"
#include "items/weapons/weapons.hpp"

#include "lua/global/lua_timer_event_descr.hpp"

class AreaCombat;
class Combat;
class Cylinder;
class Game;
class GlobalFunctions;

class LuaEnvironment final : public LuaScriptInterface {
public:
	static bool shuttingDown;

	LuaEnvironment();
	~LuaEnvironment() override;

	lua_State* getLuaState() override;

	// non-copyable
	LuaEnvironment(const LuaEnvironment &) = delete;
	LuaEnvironment &operator=(const LuaEnvironment &) = delete;

	static LuaEnvironment &getInstance();

	bool initState() override;
	bool reInitState() override;
	bool closeState() override;

	LuaScriptInterface* getTestInterface();

	const std::unique_ptr<AreaCombat> &getAreaObject(uint32_t id) const;
	uint32_t createAreaObject(LuaScriptInterface* interface);
	void clearAreaObjects(LuaScriptInterface* interface);
	static bool isShuttingDown() {
		return shuttingDown;
	}

	void collectGarbage() const;

private:
	void executeTimerEvent(uint32_t eventIndex);

	std::unordered_map<uint32_t, LuaTimerEventDesc> timerEvents;
	uint32_t lastEventTimerId = 1;

	phmap::flat_hash_map<uint32_t, std::unique_ptr<AreaCombat>> areaMap;
	phmap::flat_hash_map<LuaScriptInterface*, std::vector<uint32_t>> areaIdMap;
	uint32_t lastAreaId = 0;

	LuaScriptInterface* testInterface = nullptr;

	friend class LuaScriptInterface;
	friend class GlobalFunctions;
	friend class CombatSpell;
};

constexpr auto g_luaEnvironment = LuaEnvironment::getInstance;
