/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "declarations.hpp"
#include "lib/di/container.hpp"
#include "lua/scripts/luascript.hpp"
#include "lua/scripts/scripts.hpp"

class CreatureEvent;

class CreatureEvent final : public Script {
public:
	explicit CreatureEvent(LuaScriptInterface* interface);

	CreatureEventType_t getEventType() const {
		return type;
	}
	void setEventType(CreatureEventType_t eventType) {
		type = eventType;
	}
	const std::string &getName() const {
		return eventName;
	}
	void setName(const std::string &name) {
		eventName = name;
	}
	bool isLoaded() const {
		return loaded;
	}
	void setLoaded(bool b) {
		loaded = b;
	}

	void clearEvent();
	void copyEvent(const std::shared_ptr<CreatureEvent> creatureEvent);

	// scripting
	bool executeOnLogin(std::shared_ptr<Player> player) const;
	bool executeOnLogout(std::shared_ptr<Player> player) const;
	bool executeOnThink(std::shared_ptr<Creature> creature, uint32_t interval) const;
	bool executeOnPrepareDeath(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> killer) const;
	bool executeOnDeath(std::shared_ptr<Creature> creature, std::shared_ptr<Item> corpse, std::shared_ptr<Creature> killer, std::shared_ptr<Creature> mostDamageKiller, bool lastHitUnjustified, bool mostDamageUnjustified) const;
	void executeOnKill(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> target, bool lastHit) const;
	bool executeAdvance(std::shared_ptr<Player> player, skills_t, uint32_t, uint32_t) const;
	void executeModalWindow(std::shared_ptr<Player> player, uint32_t modalWindowId, uint8_t buttonId, uint8_t choiceId) const;
	bool executeTextEdit(std::shared_ptr<Player> player, std::shared_ptr<Item> item, const std::string &text) const;
	void executeHealthChange(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> attacker, CombatDamage &damage) const;
	void executeManaChange(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> attacker, CombatDamage &damage) const;
	void executeExtendedOpcode(std::shared_ptr<Player> player, uint8_t opcode, const std::string &buffer) const;
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
	CreatureEvents(const CreatureEvents &) = delete;
	CreatureEvents &operator=(const CreatureEvents &) = delete;

	static CreatureEvents &getInstance() {
		return inject<CreatureEvents>();
	}

	// global events
	bool playerLogin(std::shared_ptr<Player> player) const;
	bool playerLogout(std::shared_ptr<Player> player) const;
	bool playerAdvance(std::shared_ptr<Player> player, skills_t, uint32_t, uint32_t) const;

	std::shared_ptr<CreatureEvent> getEventByName(const std::string &name, bool forceLoaded = true);

	bool registerLuaEvent(const std::shared_ptr<CreatureEvent> event);
	void removeInvalidEvents();
	void clear();

private:
	// creature events
	using CreatureEventMap = std::map<std::string, std::shared_ptr<CreatureEvent>>;
	CreatureEventMap creatureEvents;
};

constexpr auto g_creatureEvents = CreatureEvents::getInstance;
