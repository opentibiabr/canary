/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_LUA_SCRIPTS_SCRIPT_ENVIRONMENT_HPP_
#define SRC_LUA_SCRIPTS_SCRIPT_ENVIRONMENT_HPP_

#include "database/database.h"
#include "declarations.hpp"

class Thing;
class Creature;
class Item;
class Container;
class Npc;

class LuaScriptInterface;
class Cylinder;
class Game;

class ScriptEnvironment {
	public:
		ScriptEnvironment();
		virtual~ScriptEnvironment();

		// non-copyable
		ScriptEnvironment(const ScriptEnvironment &) = delete;
		ScriptEnvironment & operator = (const ScriptEnvironment &) = delete;

		void resetEnv();

		void setScriptId(int32_t newScriptId, LuaScriptInterface * newScriptInterface) {
				this -> scriptId = newScriptId;
				this -> interface = newScriptInterface;
		}
		bool setCallbackId(int32_t callbackId, LuaScriptInterface * scriptInterface);

		int32_t getScriptId() const {
				return scriptId;
		}
		LuaScriptInterface * getScriptInterface() {
				return interface;
		}

		void setTimerEvent() {
				timerEvent = true;
		}

		void getEventInfo(int32_t & scriptId, LuaScriptInterface * & scriptInterface, int32_t & callbackId, bool & timerEvent) const;

		void addTempItem(Item * item);
		static void removeTempItem(Item * item);
		uint32_t addThing(Thing * thing);
		void insertItem(uint32_t uid, Item * item);

		static DBResult_ptr getResultByID(uint32_t id);
		static uint32_t addResult(DBResult_ptr res);
		static bool removeResult(uint32_t id);

		void setNpc(Npc * npc) {
				curNpc = npc;
		}
		Npc * getNpc() const {
				return curNpc;
		}

		Thing * getThingByUID(uint32_t uid);
		Item * getItemByUID(uint32_t uid);
		Container * getContainerByUID(uint32_t uid);
		void removeItemByUID(uint32_t uid);

	private:
		using VariantVector = std::vector <const LuaVariant *>;
		using StorageMap = std::map < uint32_t, int32_t >;
		using DBResultMap = std::map < uint32_t, DBResult_ptr>;

		LuaScriptInterface * interface;

		// for npc scripts
		Npc * curNpc = nullptr;

		// temporary item list
		static std::multimap < ScriptEnvironment * , Item * > tempItems;

		// local item map
		phmap::flat_hash_map < uint32_t, Item * > localMap;
		uint32_t lastUID = std::numeric_limits < uint16_t > ::max();

		// script file id
		int32_t scriptId;
		int32_t callbackId;
		bool timerEvent;

		// result map
		static uint32_t lastResultId;
		static DBResultMap tempResults;
};

#endif  // SRC_LUA_SCRIPTS_SCRIPT_ENVIRONMENT_HPP_
