/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_LUA_FUNCTIONS_EVENTS_EVENTS_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_EVENTS_EVENTS_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"
#include "lua/functions/events/action_functions.hpp"
#include "lua/functions/events/creature_event_functions.hpp"
#include "lua/functions/events/events_scheduler_functions.hpp"
#include "lua/functions/events/global_event_functions.hpp"
#include "lua/functions/events/move_event_functions.hpp"
#include "lua/functions/events/talk_action_functions.hpp"

class EventFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			ActionFunctions::init(L);
			CreatureEventFunctions::init(L);
			EventsSchedulerFunctions::init(L);
			GlobalEventFunctions::init(L);
			MoveEventFunctions::init(L);
			TalkActionFunctions::init(L);
			/* Move, Creature, Talk, Global events goes all here */
		}

	private:
	};

#endif  // SRC_LUA_FUNCTIONS_EVENTS_EVENTS_FUNCTIONS_HPP_
