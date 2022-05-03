/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef SRC_LUA_CREATURE_CREATUREEVENT_H_
#define SRC_LUA_CREATURE_CREATUREEVENT_H_

#include "declarations.hpp"
#include "lua/scripts/luascript.h"
#include "lua/scripts/scripts.h"

class CreatureEvent;
using CreatureEvent_ptr = std::unique_ptr<CreatureEvent>;

class CreatureEvent final : public Script {
	public:
		explicit CreatureEvent(LuaScriptInterface* interface);

		CreatureEventType_t getEventType() const {
			return type;
		}
		void setEventType(CreatureEventType_t eventType) {
			type = eventType;
		}
		const std::string& getName() const {
			return eventName;
		}
		void setName(const std::string& name) {
			eventName = name;
		}
		const std::string& getFileName() const {
			return fileName;
		}
		void setFileName(const std::string& scriptName) {
			fileName = scriptName;
		}
		bool isLoaded() const {
			return loaded;
		}
		void setLoaded(bool b) {
			loaded = b;
		}

		void clearEvent();
		void copyEvent(CreatureEvent* creatureEvent);

		//scripting
		bool executeOnLogin(Player* player) const;
		bool executeOnLogout(Player* player) const;
		bool executeOnThink(Creature* creature, uint32_t interval);
		bool executeOnPrepareDeath(Creature* creature, Creature* killer);
		bool executeOnDeath(Creature* creature, Item* corpse, Creature* killer, Creature* mostDamageKiller, bool lastHitUnjustified, bool mostDamageUnjustified);
		void executeOnKill(Creature* creature, Creature* target, bool lastHit);
		bool executeAdvance(Player* player, skills_t, uint32_t, uint32_t);
		void executeModalWindow(Player* player, uint32_t modalWindowId, uint8_t buttonId, uint8_t choiceId);
		bool executeTextEdit(Player* player, Item* item, const std::string& text);
		void executeHealthChange(Creature* creature, Creature* attacker, CombatDamage& damage);
		void executeManaChange(Creature* creature, Creature* attacker, CombatDamage& damage);
		void executeExtendedOpcode(Player* player, uint8_t opcode, const std::string& buffer);
		//

	private:
		std::string getScriptTypeName() const override;

		std::string eventName;
		std::string fileName;
		CreatureEventType_t type;
		bool loaded;
};

class CreatureEvents final : public Scripts {
	public:
		CreatureEvents() = default;

		// non-copyable
		CreatureEvents(const CreatureEvents&) = delete;
		CreatureEvents& operator=(const CreatureEvents&) = delete;

		static CreatureEvents& getInstance() {
			// Guaranteed to be destroyed
			static CreatureEvents instance;
			// Instantiated on first use
			return instance;
		}

		// global events
		bool playerLogin(Player* player) const;
		bool playerLogout(Player* player) const;
		bool playerAdvance(Player* player, skills_t, uint32_t, uint32_t);

		CreatureEvent* getEventByName(const std::string& name, bool forceLoaded = true);

		bool registerLuaEvent(CreatureEvent* event);
		void removeInvalidEvents();
		void clear();

	private:
		//creature events
		using CreatureEventMap = std::map<std::string, CreatureEvent>;
		CreatureEventMap creatureEvents;
};

constexpr auto g_creatureEvents = &CreatureEvents::getInstance;

#endif  // SRC_LUA_CREATURE_CREATUREEVENT_H_
