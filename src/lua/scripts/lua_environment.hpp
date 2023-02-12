/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#ifndef SRC_LUA_SCRIPTS_LUA_ENVIRONMENT_HPP_
#define SRC_LUA_SCRIPTS_LUA_ENVIRONMENT_HPP_

#include "creatures/combat/combat.h"
#include "declarations.hpp"
#include "lua/scripts/luascript.h"
#include "items/weapons/weapons.h"

class AreaCombat;
class Combat;
class Cylinder;
class Game;
class GlobalFunctions;

class LuaEnvironment : public LuaScriptInterface {
	public:
		LuaEnvironment();
		~LuaEnvironment();

		// non-copyable
		LuaEnvironment(const LuaEnvironment &) = delete;
		LuaEnvironment &operator=(const LuaEnvironment &) = delete;

		bool initState() override;
		bool reInitState();
		bool closeState() override;

		LuaScriptInterface* getTestInterface();

		std::shared_ptr<Combat> getCombatObject(uint32_t id) const;
		std::shared_ptr<Combat> createCombatObject(LuaScriptInterface* interface);
		void clearCombatObjects(LuaScriptInterface* interface);

		template <typename T>
		std::shared_ptr<T> createWeaponObject(LuaScriptInterface* interface) {
			auto weapon = std::make_shared<T>(interface);
			int weaponId = ++lastWeaponId;
			weaponMap[weaponId] = weapon;
			weaponIdMap[interface].push_back(weaponId);
			return weapon;
		}

		template <typename T>
		std::shared_ptr<T> getWeaponObject(uint32_t id) const {
			auto it = weaponMap.find(id);
			if (it == weaponMap.end()) {
				return nullptr;
			}
			return it->second;
		}

		void clearWeaponObjects(LuaScriptInterface* interface) {
			auto it = weaponIdMap.find(interface);
			if (it == weaponIdMap.end()) {
				return;
			}

			it->second.clear();
			weaponMap.clear();
		}

		AreaCombat* getAreaObject(uint32_t id) const;
		uint32_t createAreaObject(LuaScriptInterface* interface);
		void clearAreaObjects(LuaScriptInterface* interface);

	private:
		void executeTimerEvent(uint32_t eventIndex);

		phmap::flat_hash_map<uint32_t, LuaTimerEventDesc> timerEvents;
		uint32_t lastEventTimerId = 1;

		phmap::flat_hash_map<uint32_t, AreaCombat*> areaMap;
		phmap::flat_hash_map<LuaScriptInterface*, std::vector<uint32_t>> areaIdMap;
		uint32_t lastAreaId = 0;

		phmap::flat_hash_map<uint32_t, std::shared_ptr<Combat>> combatMap;
		phmap::flat_hash_map<LuaScriptInterface*, std::vector<uint32_t>> combatIdMap;
		uint32_t lastCombatId = 0;

		phmap::flat_hash_map<uint32_t, std::shared_ptr<Weapon>> weaponMap;
		phmap::flat_hash_map<LuaScriptInterface*, std::vector<uint32_t>> weaponIdMap;
		uint32_t lastWeaponId = 0;

		LuaScriptInterface* testInterface = nullptr;

		friend class LuaScriptInterface;
		friend class GlobalFunctions;
		friend class CombatSpell;
};

inline LuaEnvironment g_luaEnvironment;

#endif // SRC_LUA_SCRIPTS_LUA_ENVIRONMENT_HPP_
