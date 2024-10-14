/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#pragma once

#include "creatures/creatures_definitions.hpp"
#include "wheel_definitions.hpp"
#include "enums/player_wheel.hpp"

class PlayerWheel;

class GemModifierStrategy {
public:
	explicit GemModifierStrategy(PlayerWheel &wheel) :
		m_wheel(wheel) { }
	virtual ~GemModifierStrategy() = default;
	virtual void execute() = 0;

protected:
	PlayerWheel &m_wheel;
};

class GemModifierResistanceStrategy : public GemModifierStrategy {
public:
	explicit GemModifierResistanceStrategy(PlayerWheel &wheel, CombatType_t combatType, int32_t resistance) :
		GemModifierStrategy(wheel),
		m_combatType(combatType),
		m_resistance(resistance) { }

	void execute() override;

private:
	CombatType_t m_combatType;
	int32_t m_resistance;
};

class GemModifierStatStrategy : public GemModifierStrategy {
public:
	explicit GemModifierStatStrategy(PlayerWheel &wheel, WheelStat_t stat, int32_t value) :
		GemModifierStrategy(wheel),
		m_stat(stat),
		m_value(value) { }

	void execute() override;

private:
	WheelStat_t m_stat;
	int32_t m_value;
};

class GemModifierRevelationStrategy : public GemModifierStrategy {
public:
	explicit GemModifierRevelationStrategy(PlayerWheel &wheel, WheelGemAffinity_t affinity, [[maybe_unused]] uint16_t value) :
		GemModifierStrategy(wheel),
		m_affinity(affinity) { }

	void execute() override;

private:
	WheelGemAffinity_t m_affinity;
	uint16_t m_value;
};

class GemModifierSpellBonusStrategy : public GemModifierStrategy {
public:
	explicit GemModifierSpellBonusStrategy(PlayerWheel &wheel, std::string spellName, WheelSpells::Bonus bonus) :
		GemModifierStrategy(wheel),
		m_spellName(std::move(spellName)),
		m_bonus(bonus) { }

	void execute() override;

private:
	std::string m_spellName;
	WheelSpells::Bonus m_bonus;
};

class WheelModifierContext {
public:
	explicit WheelModifierContext(PlayerWheel &wheel, Vocation_t vocation) :
		m_wheel(wheel), m_vocation(vocation) { }

	void addStrategies(WheelGemBasicModifier_t modifier);
	void addStrategies(WheelGemSupremeModifier_t modifier);

	void resetStrategies() {
		m_strategies.clear();
	}

	void executeStrategies();

private:
	std::vector<std::unique_ptr<GemModifierStrategy>> m_strategies;
	PlayerWheel &m_wheel;
	Vocation_t m_vocation;
};

[[maybe_unused]] static int32_t getHealthValue(Vocation_t vocation, WheelGemBasicModifier_t modifier) {
	static const std::unordered_map<WheelGemBasicModifier_t, std::unordered_map<Vocation_t, int32_t>> stats = {
		{
			WheelGemBasicModifier_t::Vocation_Health,
			{
				{ Vocation_t::VOCATION_KNIGHT, 300 },
				{ Vocation_t::VOCATION_PALADIN, 200 },
				{ Vocation_t::VOCATION_SORCERER, 100 },
				{ Vocation_t::VOCATION_DRUID, 100 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Health_FireResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 150 },
				{ Vocation_t::VOCATION_PALADIN, 100 },
				{ Vocation_t::VOCATION_SORCERER, 50 },
				{ Vocation_t::VOCATION_DRUID, 50 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Health_EnergyResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 150 },
				{ Vocation_t::VOCATION_PALADIN, 100 },
				{ Vocation_t::VOCATION_SORCERER, 50 },
				{ Vocation_t::VOCATION_DRUID, 50 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Health_EarthResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 150 },
				{ Vocation_t::VOCATION_PALADIN, 100 },
				{ Vocation_t::VOCATION_SORCERER, 50 },
				{ Vocation_t::VOCATION_DRUID, 50 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Health_IceResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 150 },
				{ Vocation_t::VOCATION_PALADIN, 100 },
				{ Vocation_t::VOCATION_SORCERER, 50 },
				{ Vocation_t::VOCATION_DRUID, 50 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mixed,
			{
				{ Vocation_t::VOCATION_KNIGHT, 150 },
				{ Vocation_t::VOCATION_PALADIN, 100 },
				{ Vocation_t::VOCATION_SORCERER, 50 },
				{ Vocation_t::VOCATION_DRUID, 50 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mixed2,
			{
				{ Vocation_t::VOCATION_KNIGHT, 150 },
				{ Vocation_t::VOCATION_PALADIN, 100 },
				{ Vocation_t::VOCATION_SORCERER, 50 },
				{ Vocation_t::VOCATION_DRUID, 50 },
			},
		},
	};

	auto modifierIt = stats.find(modifier);
	if (modifierIt != stats.end()) {
		auto vocationIt = modifierIt->second.find(vocation);
		if (vocationIt != modifierIt->second.end()) {
			return vocationIt->second;
		}
	}
	return 0;
}

[[maybe_unused]] static int32_t getManaValue(Vocation_t vocation, WheelGemBasicModifier_t modifier) {
	static const std::unordered_map<WheelGemBasicModifier_t, std::unordered_map<Vocation_t, int32_t>> stats = {
		{
			WheelGemBasicModifier_t::Vocation_Mana_FireResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 50 },
				{ Vocation_t::VOCATION_PALADIN, 150 },
				{ Vocation_t::VOCATION_SORCERER, 300 },
				{ Vocation_t::VOCATION_DRUID, 300 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mana_EnergyResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 50 },
				{ Vocation_t::VOCATION_PALADIN, 150 },
				{ Vocation_t::VOCATION_SORCERER, 300 },
				{ Vocation_t::VOCATION_DRUID, 300 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mana_Earth_Resistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 50 },
				{ Vocation_t::VOCATION_PALADIN, 150 },
				{ Vocation_t::VOCATION_SORCERER, 300 },
				{ Vocation_t::VOCATION_DRUID, 300 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mana_Ice_Resistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 50 },
				{ Vocation_t::VOCATION_PALADIN, 150 },
				{ Vocation_t::VOCATION_SORCERER, 300 },
				{ Vocation_t::VOCATION_DRUID, 300 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mana,
			{
				{ Vocation_t::VOCATION_KNIGHT, 100 },
				{ Vocation_t::VOCATION_PALADIN, 300 },
				{ Vocation_t::VOCATION_SORCERER, 600 },
				{ Vocation_t::VOCATION_DRUID, 600 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mixed,
			{
				{ Vocation_t::VOCATION_PALADIN, 100 },
				{ Vocation_t::VOCATION_SORCERER, 150 },
				{ Vocation_t::VOCATION_DRUID, 150 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Capacity,
			{
				{ Vocation_t::VOCATION_KNIGHT, 50 },
				{ Vocation_t::VOCATION_PALADIN, 150 },
				{ Vocation_t::VOCATION_SORCERER, 300 },
				{ Vocation_t::VOCATION_DRUID, 300 },
			},
		}
	};

	auto modifierIt = stats.find(modifier);
	if (modifierIt != stats.end()) {
		auto vocationIt = modifierIt->second.find(vocation);
		if (vocationIt != modifierIt->second.end()) {
			return vocationIt->second;
		}
	}
	return 0;
}

[[maybe_unused]] static int32_t getCapacityValue(Vocation_t vocation, WheelGemBasicModifier_t modifier) {
	static const std::unordered_map<WheelGemBasicModifier_t, std::unordered_map<Vocation_t, int32_t>> stats = {
		{
			WheelGemBasicModifier_t::Vocation_Capacity_FireResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 250 },
				{ Vocation_t::VOCATION_PALADIN, 200 },
				{ Vocation_t::VOCATION_SORCERER, 100 },
				{ Vocation_t::VOCATION_DRUID, 100 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Capacity_EnergyResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 250 },
				{ Vocation_t::VOCATION_PALADIN, 200 },
				{ Vocation_t::VOCATION_SORCERER, 100 },
				{ Vocation_t::VOCATION_DRUID, 100 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Capacity_EarthResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 250 },
				{ Vocation_t::VOCATION_PALADIN, 200 },
				{ Vocation_t::VOCATION_SORCERER, 100 },
				{ Vocation_t::VOCATION_DRUID, 100 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Capacity_IceResistance,
			{
				{ Vocation_t::VOCATION_KNIGHT, 250 },
				{ Vocation_t::VOCATION_PALADIN, 200 },
				{ Vocation_t::VOCATION_SORCERER, 100 },
				{ Vocation_t::VOCATION_DRUID, 100 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Capacity,
			{
				{ Vocation_t::VOCATION_KNIGHT, 250 },
				{ Vocation_t::VOCATION_PALADIN, 200 },
				{ Vocation_t::VOCATION_SORCERER, 100 },
				{ Vocation_t::VOCATION_DRUID, 100 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mixed,
			{
				{ Vocation_t::VOCATION_KNIGHT, 125 },
			},
		},
		{
			WheelGemBasicModifier_t::Vocation_Mixed2,
			{
				{ Vocation_t::VOCATION_KNIGHT, 250 },
				{ Vocation_t::VOCATION_PALADIN, 200 },
				{ Vocation_t::VOCATION_SORCERER, 100 },
				{ Vocation_t::VOCATION_DRUID, 100 },
			},
		}
	};

	auto modifierIt = stats.find(modifier);
	if (modifierIt != stats.end()) {
		auto vocationIt = modifierIt->second.find(vocation);
		if (vocationIt != modifierIt->second.end()) {
			return vocationIt->second;
		}
	}
	return 0;
}
