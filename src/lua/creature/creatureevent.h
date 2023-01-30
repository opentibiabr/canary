/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
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
		bool isLoaded() const {
			return loaded;
		}
		void setLoaded(bool b) {
			loaded = b;
		}

		void clearEvent();
		void copyEvent(const CreatureEvent* creatureEvent);

		//scripting
		bool executeOnLogin(Player* player) const;
		bool executeOnLogout(Player* player) const;
		bool executeOnThink(Creature* creature, uint32_t interval) const;
		bool executeOnPrepareDeath(Creature* creature, Creature* killer) const;
		bool executeOnDeath(Creature* creature, Item* corpse, Creature* killer, Creature* mostDamageKiller, bool lastHitUnjustified, bool mostDamageUnjustified) const;
		void executeOnKill(Creature* creature, Creature* target, bool lastHit) const;
		bool executeAdvance(Player* player, skills_t, uint32_t, uint32_t) const;
		void executeModalWindow(Player* player, uint32_t modalWindowId, uint8_t buttonId, uint8_t choiceId) const;
		bool executeTextEdit(Player* player, Item* item, const std::string& text) const;
		void executeHealthChange(Creature* creature, Creature* attacker, CombatDamage& damage) const;
		void executeManaChange(Creature* creature, Creature* attacker, CombatDamage& damage) const;
		void executeExtendedOpcode(Player* player, uint8_t opcode, const std::string& buffer) const;
		//

	private:
		std::string getScriptTypeName() const override;

		std::string eventName;
		CreatureEventType_t type = CREATURE_EVENT_NONE;
		bool loaded = false;
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
		bool playerAdvance(Player* player, skills_t, uint32_t, uint32_t) const;

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
