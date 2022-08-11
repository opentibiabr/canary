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

#ifndef SRC_CREATURES_PLAYERS_VOCATIONS_VOCATION_H_
#define SRC_CREATURES_PLAYERS_VOCATIONS_VOCATION_H_

#include "declarations.hpp"
#include "items/item.h"

class Vocation
{
	public:
		explicit Vocation(uint16_t initId) : id(initId) {}

		const std::string& getVocName() const {
			return name;
		}
		const std::string& getVocDescription() const {
			return description;
		}
		uint64_t getReqSkillTries(uint8_t skill, uint16_t level);
		uint64_t getReqMana(uint32_t magLevel);

		uint16_t getId() const {
			return id;
		}

		uint8_t getClientId() const {
			return clientId;
		}

		uint8_t getBaseId() const {
			return baseId;
		}

		uint32_t getHPGain() const {
			return gainHP;
		}
		uint32_t getManaGain() const {
			return gainMana;
		}
		uint32_t getCapGain() const {
			return gainCap;
		}

		uint32_t getManaGainTicks() const {
			return gainManaTicks / g_configManager().getFloat(RATE_MANA_REGEN_SPEED);
		}

		uint32_t getManaGainAmount() const {
			return gainManaAmount * g_configManager().getFloat(RATE_MANA_REGEN);
		}

		uint32_t getHealthGainTicks() const {
			return gainHealthTicks / g_configManager().getFloat(RATE_HEALTH_REGEN_SPEED);
		}

		uint32_t getHealthGainAmount() const {
			return gainHealthAmount * g_configManager().getFloat(RATE_HEALTH_REGEN);
		}

		uint8_t getSoulMax() const {
			return soulMax;
		}

		uint32_t getSoulGainTicks() const {
			return gainSoulTicks / g_configManager().getFloat(RATE_SOUL_REGEN_SPEED);
		}

		uint32_t getBaseAttackSpeed() const {
			return attackSpeed;
		}

		uint32_t getAttackSpeed() const {
			return attackSpeed / g_configManager().getFloat(RATE_ATTACK_SPEED);
		}

		uint32_t getBaseSpeed() const {
			return baseSpeed;
		}

		uint32_t getFromVocation() const {
			return fromVocation;
		}

		bool getMagicShield() const {
			return magicShield;
		}
		bool canCombat() const {
			return combat;
		}

		float meleeDamageMultiplier = 1.0f;
		float distDamageMultiplier = 1.0f;
		float defenseMultiplier = 1.0f;
		float armorMultiplier = 1.0f;

	private:
		friend class Vocations;

		std::map<uint32_t, uint64_t> cacheMana;
		std::map<uint32_t, uint32_t> cacheSkill[SKILL_LAST + 1];

		std::string name = "none";
		std::string description;

		float skillMultipliers[SKILL_LAST + 1] = {1.5f, 2.0f, 2.0f, 2.0f, 2.0f, 1.5f, 1.1f};
		float manaMultiplier = 4.0f;

		uint32_t gainHealthTicks = 6;
		uint32_t gainHealthAmount = 1;
		uint32_t gainManaTicks = 6;
		uint32_t gainManaAmount = 1;
		uint32_t gainCap = 500;
		uint32_t gainMana = 5;
		uint32_t gainHP = 5;
		uint32_t fromVocation = VOCATION_NONE;
		uint32_t attackSpeed = 1500;
		uint32_t baseSpeed = 110;
		uint16_t id;

		bool magicShield = false;
		bool combat = true;

		uint32_t gainSoulTicks = 120000;

		uint8_t soulMax = 100;
		uint8_t clientId = 0;
		uint8_t baseId = 0;

		static uint32_t skillBase[SKILL_LAST + 1];
};

class Vocations
{
	public:
		Vocations() = default;

		Vocations(Vocations const&) = delete;
		void operator=(Vocations const&) = delete;

		static Vocations& getInstance() {
			// Guaranteed to be destroyed
			static Vocations instance;
			// Instantiated on first use
			return instance;
		}

		bool loadFromXml();

		Vocation* getVocation(uint16_t id);
    	const std::map<uint16_t, Vocation>& getVocations() const {return vocationsMap;}
		uint16_t getVocationId(const std::string& name) const;
		uint16_t getPromotedVocation(uint16_t vocationId) const;

	private:
		std::map<uint16_t, Vocation> vocationsMap;
};

constexpr auto g_vocations = &Vocations::getInstance;

#endif  // SRC_CREATURES_PLAYERS_VOCATIONS_VOCATION_H_
