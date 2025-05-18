/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/creatures_definitions.hpp"

enum class WheelGemQuality_t : uint8_t;
enum class WheelGemSupremeModifier_t : uint8_t;

class Vocation {
public:
	explicit Vocation(uint16_t initId) :
		id(initId) { }

	const std::string &getVocName() const;
	const std::string &getVocDescription() const;
	absl::uint128 getTotalSkillTries(uint8_t skill, uint16_t level);
	uint64_t getReqSkillTries(uint8_t skill, uint16_t level);
	absl::uint128 getTotalMana(uint32_t magLevel);
	uint64_t getReqMana(uint32_t magLevel);

	uint16_t getId() const;

	uint8_t getClientId() const;

	uint8_t getBaseId() const;

	uint16_t getAvatarLookType() const;

	uint32_t getHPGain() const;
	uint32_t getManaGain() const;
	uint32_t getCapGain() const;

	uint32_t getManaGainTicks() const;

	uint32_t getManaGainAmount() const;

	uint32_t getHealthGainTicks() const;

	uint32_t getHealthGainAmount() const;

	uint8_t getSoulMax() const;

	uint32_t getSoulGainTicks() const;

	uint32_t getBaseAttackSpeed() const;

	uint32_t getAttackSpeed() const;

	uint32_t getBaseSpeed() const;

	uint32_t getFromVocation() const;

	bool getMagicShield() const;
	bool canCombat() const;

	float meleeDamageMultiplier = 1.0f;
	float distDamageMultiplier = 1.0f;
	float defenseMultiplier = 1.0f;
	float armorMultiplier = 1.0f;

	float mitigationFactor = 1.0f;
	float mitigationPrimaryShield = 1.0f;
	float mitigationSecondaryShield = 1.0f;

	float pvpDamageReceivedMultiplier = 1.0f;
	float pvpDamageDealtMultiplier = 1.0f;

	std::vector<WheelGemSupremeModifier_t> getSupremeGemModifiers();

	uint16_t getWheelGemId(WheelGemQuality_t quality);

private:
	friend class Vocations;

	std::map<uint32_t, uint64_t> cacheMana;
	std::map<uint32_t, absl::uint128> cacheManaTotal;
	std::map<uint32_t, uint32_t> cacheSkill[SKILL_LAST + 1];
	std::map<uint32_t, absl::uint128> cacheSkillTotal[SKILL_LAST + 1];
	std::map<WheelGemQuality_t, std::string> wheelGems;

	std::string name = "none";
	std::string description;

	float skillMultipliers[SKILL_LAST + 1] = { 1.5f, 2.0f, 2.0f, 2.0f, 2.0f, 1.5f, 1.1f };
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
	uint16_t avatarLookType = 0;

	std::vector<WheelGemSupremeModifier_t> m_supremeGemModifiers;

	static uint32_t skillBase[SKILL_LAST + 1];
};

class Vocations {
public:
	Vocations() = default;

	Vocations(const Vocations &) = delete;
	void operator=(const Vocations &) = delete;

	static Vocations &getInstance();

	bool loadFromXml();
	bool reload();

	std::shared_ptr<Vocation> getVocation(uint16_t id);
	const std::map<uint16_t, std::shared_ptr<Vocation>> &getVocations() const;
	uint16_t getVocationId(const std::string &name) const;
	uint16_t getPromotedVocation(uint16_t vocationId) const;

private:
	std::map<uint16_t, std::shared_ptr<Vocation>> vocationsMap;
};

constexpr auto g_vocations = Vocations::getInstance;
