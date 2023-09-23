/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#pragma once

#include "io/io_wheel.hpp"

class Spell;
class Player;
class Creature;
class NetworkMessage;
class IOWheel;

class PlayerWheel {
public:
	explicit PlayerWheel(Player &initPlayer);

	/*
	 * Functions for load and save player database informations
	 */
	void loadDBPlayerSlotPointsOnLogin();
	bool saveDBPlayerSlotPointsOnLogout() const;

	/*
	 * Functions for manipulate the client bytes
	 */
	bool checkSavePointsBySlotType(WheelSlots_t slotType, uint16_t points);

	/**
	 * @brief Handles retry errors for saving slot points.
	 *
	 * @details This function iterates over the retry table and attempts to save slot points for each entry.
	 * @details If the points are successfully saved, the error counter is decremented. If the points cannot be saved,
	 * @details the entry is added to a temporary table for further retry.
	 *
	 * @param retryTable The vector containing the slot information to be retried.
	 * @param errors The error counter that keeps track of the number of errors encountered.
	 */
	void saveSlotPointsHandleRetryErrors(std::vector<SlotInfo> &retryTable, int &errors);

	/**
	 * @brief Saves the slot points when the save (ok) button is pressed.
	 * @param msg Network message containing slot data.
	 * @details If maximum number of points allowed for the slot, an error message is sent to the player and the function returns.
	 */
	void saveSlotPointsOnPressSaveButton(NetworkMessage &msg);
	void addPromotionScrolls(NetworkMessage &msg) const;
	void sendOpenWheelWindow(NetworkMessage &msg, uint32_t ownerId) const;
	void sendGiftOfLifeCooldown() const;

	/*
	 * Functions for load relevant wheel data
	 */
	void initializePlayerData();

	/*
	 * Wheel Spells Methods
	 */
	int getSpellAdditionalTarget(const std::string &spellName) const;
	int getSpellAdditionalDuration(const std::string &spellName) const;
	bool getSpellAdditionalArea(const std::string &spellName) const;

	/*
	 * Functions for manage slots
	 */
	bool canSelectSlotFullOrPartial(WheelSlots_t slot) const;
	bool canPlayerSelectPointOnSlot(WheelSlots_t slot, bool recursive) const;

	/*
	 * Functions for manage points
	 */
	/**
	 * @brief Returns the total wheel points for the player.
	 *
	 * This function calculates the wheel points for the player based on their level.
	 * Extra points can either be included or not in the calculation depending on the value of the includeExtraPoints parameter.
	 *
	 * @note In the sendOpenWheelWindow function, extra points are not included (false is passed) because they are already sent separately in a different byte.
	 *
	 * @param includeExtraPoints If true, extra points are included in the total returned. If false, only the base points are returned. Default is true.
	 * @return The total wheel points for the player. Includes extra points if includeExtraPoints is true.
	 */
	uint16_t getWheelPoints(bool includeExtraPoints = true) const;
	uint16_t getExtraPoints() const;
	uint8_t getMaxPointsPerSlot(WheelSlots_t slot) const;
	uint16_t getUnusedPoints() const;

	void resetPlayerBonusData();

	void setPlayerCombatStats(CombatType_t type, int32_t leechAmount);

	void reloadPlayerData();

	void registerPlayerBonusData();

	void loadPlayerBonusData();

	void loadDedicationAndConvictionPerks();

	/**
	 * @brief Adds a spell to the spells vector.
	 * @details This function adds a spell to the player's spells vector, only if the spell doesn't already exist in the vector.
	 * @param spellName The name of the spell to be added.
	 */
	void addSpellToVector(const std::string &spellName);
	void loadRevelationPerks();

	WheelStageEnum_t getPlayerSliceStage(const std::string &color) const;

	void printPlayerWheelMethodsBonusData(const PlayerWheelMethodsBonusData &bonusData) const;

private:
	/*
	 * Open wheel functions helpers
	 */
	bool canOpenWheel() const;

	/**
	 * @brief Get the options available to the player for changing points.

	 * @param ownerId The ID of the owner to check for.
	 * @return uint8_t The option code representing what the player can do:
	 * @return 0 for "Cannot change points",
	 * @return  1 for "Can increase and decrease points",
	 * @return 2 for "Can increase points but cannot decrease id".

	 * @details
	 * The function starts by checking if the player ID matches the provided owner ID.
	 * If they do not match, the function returns 0, indicating that the player cannot change points.

	 * If the player ID does match the owner ID, the function checks if the player is within the temple range,
	 * assumed to be within 10 square meters. If the player is within the temple range,
	 * the function returns 1, indicating that the player can increase and decrease points.

	 * If the player is not within the temple range, the function returns 2,
	 * indicating that the player can increase points but cannot decrease the ID.
	 */
	uint8_t getOptions(uint32_t ownerId) const;
	uint8_t getPlayerVocationEnum() const;

	// Members variables
	const uint16_t m_minLevelToStartCountPoints = 50;
	uint16_t m_pointsPerLevel = 1;

public:
	// Wheel of destiny
	void onThink(bool force = false);
	void checkAbilities();
	void checkGiftOfLife();
	bool checkBattleInstinct();
	bool checkPositionalTatics();
	bool checkBallisticMastery();
	bool checkCombatMastery();
	bool checkDivineEmpowerment();
	int32_t checkDrainBodyLeech(std::shared_ptr<Creature> target, skills_t skill) const;
	int32_t checkBeamMasteryDamage() const;
	int32_t checkBattleHealingAmount() const;
	int32_t checkBlessingGroveHealingByTarget(std::shared_ptr<Creature> target) const;
	int32_t checkTwinBurstByTarget(std::shared_ptr<Creature> target) const;
	int32_t checkExecutionersThrow(std::shared_ptr<Creature> target) const;
	int32_t checkDivineGrenade(std::shared_ptr<Creature> target) const;
	int32_t checkAvatarSkill(WheelAvatarSkill_t skill) const;
	int32_t checkFocusMasteryDamage();
	int32_t checkElementSensitiveReduction(CombatType_t type) const;
	// Wheel of destiny - General functions:
	void reduceAllSpellsCooldownTimer(int32_t value);
	void resetUpgradedSpells();
	void upgradeSpell(const std::string &name);
	void downgradeSpell(const std::string &name);
	// Wheel of destiny - Header set:
	/**
	 * @brief Sets the value of a specific stage in the Wheel of Destiny.
	 *
	 * This function sets the value of the specified stage in the Wheel of Destiny to the provided value.
	 *
	 * @param type The type of the stage to set.
	 * @param value The value to set for the stage.
	 */
	void setStage(WheelStage_t type, uint8_t value);

	/**
	 * @brief Sets the on-think timer value for a specific on-think type in the Wheel of Destiny.
	 *
	 * This function sets the on-think timer value for the specified on-think type in the Wheel of Destiny
	 * to the provided time value.
	 *
	 * @param type The type of the on-think timer to set.
	 * @param time The time value to set for the on-think timer.
	 */
	void setOnThinkTimer(WheelOnThink_t type, int64_t time);

	/**
	 * @brief Sets the value of a specific major stat in the Wheel of Destiny.
	 *
	 * This function sets the value of the specified major stat in the Wheel of Destiny to the provided value.
	 *
	 * @param type The type of the major stat to set.
	 * @param value The value to set for the major stat.
	 */
	void setMajorStat(WheelMajor_t type, int32_t value);

	/**
	 * @brief Sets the value of a specific instant in the Wheel of Destiny.
	 *
	 * This function sets the value of the specified instant in the Wheel of Destiny to the provided toggle value.
	 *
	 * @param type The type of the instant to set.
	 * @param toggle The toggle value to set for the instant.
	 */
	void setInstant(WheelInstant_t type, bool toggle);

	/**
	 * @brief Sets the value of a specific stat in the Wheel of Destiny.
	 *
	 * This function sets the value of the specified stat in the Wheel of Destiny to the provided value.
	 *
	 * @param type The type of the stat to set.
	 * @param value The value to set for the stat.
	 */
	void setStat(WheelStat_t type, int32_t value);

	/**
	 * @brief Sets the value of a specific resistance in the Wheel of Destiny.
	 *
	 * This function sets the value of the specified resistance in the Wheel of Destiny to the provided value.
	 *
	 * @param type The type of the resistance to set.
	 * @param value The value to set for the resistance.
	 */
	void setResistance(CombatType_t type, int32_t value);

	/**
	 * @brief Sets the value of a specific instant in the Wheel of Destiny based on its spell name.
	 *
	 * This function sets the value of the specified instant in the Wheel of Destiny based on its name,
	 * toggling it on or off. It also applies additional effects based on the instant name.
	 *
	 * @param name The name of the instant to set.
	 * @param value The toggle value to set for the instant.
	 */
	void setSpellInstant(const std::string &name, bool value);
	void resetResistance();

	// Wheel of destiny - Header get:
	bool getInstant(WheelInstant_t type) const;
	bool getHealingLinkUpgrade(const std::string &spell) const;
	uint8_t getStage(const std::string name) const;
	uint8_t getStage(WheelStage_t type) const;
	WheelSpellGrade_t getSpellUpgrade(const std::string &name) const;
	int32_t getMajorStat(WheelMajor_t type) const;
	int32_t getStat(WheelStat_t type) const;
	int32_t getResistance(CombatType_t type) const;
	int32_t getMajorStatConditional(const std::string &instant, WheelMajor_t major) const;
	int64_t getOnThinkTimer(WheelOnThink_t type) const;
	bool getInstant(const std::string name) const;
	double getMitigationMultiplier() const;

	// Wheel of destiny - Specific functions
	uint32_t getGiftOfLifeTotalCooldown() const;
	uint8_t getGiftOfLifeValue() const;
	int32_t getGiftOfCooldown() const;
	void setGiftOfCooldown(int32_t value, bool isOnThink);
	void decreaseGiftOfCooldown(int32_t value);

	void sendOpenWheelWindow(uint32_t ownerId) const;

	uint16_t getPointsBySlotType(uint8_t slotType) const;

	const std::array<uint16_t, 37> &getSlots() const;

	void setPointsBySlotType(uint8_t slotType, uint16_t points);

	std::shared_ptr<Spell> getCombatDataSpell(CombatDamage &damage);

	const PlayerWheelMethodsBonusData &getBonusData() const;

	PlayerWheelMethodsBonusData &getBonusData();

	void setWheelBonusData(const PlayerWheelMethodsBonusData &newBonusData);

	// Combat functions
	uint8_t getBeamAffectedTotal(const CombatDamage &tmpDamage) const;
	void updateBeamMasteryDamage(CombatDamage &tmpDamage, uint8_t &beamAffectedTotal, uint8_t &beamAffectedCurrent) const;
	/**
	 * @brief Checks if the player has the "Battle Healing" instant active and, if so, heals the player.
	 *
	 * This function checks if a creature is a player and if the player is not removed from the game world.
	 * If the player has the "Battle Healing" instant active, the player is healed by an amount defined by the
	 * checkBattleHealingAmount() function.
	 *
	 * @param creature The creature to check and potentially heal.
	 */
	void healIfBattleHealingActive() const;
	/**
	 * @brief Adjusts the incoming damage based on the player's resistance and avatar skill.
	 *
	 * This function uses the player's Wheel of Destiny to calculate resistance to a specific type of damage.
	 * It then applies this resistance to the incoming damage. Afterwards, it further reduces the damage
	 * based on the player's avatar skill.
	 *
	 * @param damage The incoming damage, which will be adjusted within this function.
	 * @param combatType The type of combat or damage to be resisted.
	 */
	void adjustDamageBasedOnResistanceAndSkill(int32_t &damage, CombatType_t combatType) const;

	/**
	 * @brief Calculate and return all values required for the mitigation calculation.
	 * @return The calculated mitigation value.
	 */
	float calculateMitigation() const;

private:
	friend class Player;
	// Reference to the player
	Player &m_player;

	// Starting count in 1 (1-37), slot enums are from 1 to 36, but the index always starts at 0 in c++
	std::array<uint16_t, 37> m_wheelSlots = {};

	PlayerWheelMethodsBonusData m_playerBonusData;

	std::array<uint8_t, static_cast<size_t>(WheelStage_t::TOTAL_COUNT)> m_stages = { 0 };
	std::array<int64_t, static_cast<size_t>(WheelOnThink_t::TOTAL_COUNT)> m_onThink = { 0 };
	std::array<int32_t, static_cast<size_t>(WheelStat_t::TOTAL_COUNT)> m_stats = { 0 };
	std::array<int32_t, static_cast<size_t>(WheelMajor_t::TOTAL_COUNT)> m_majorStats = { 0 };
	std::array<bool, static_cast<size_t>(WheelInstant_t::TOTAL_COUNT)> m_instant = { false };
	std::array<int32_t, COMBAT_COUNT> m_resistance = { 0 };

	int32_t m_creaturesNearby = 0;
	std::map<std::string, WheelSpellGrade_t> m_spellsSelected;
	std::vector<std::string> m_learnedSpellsSelected;
};
