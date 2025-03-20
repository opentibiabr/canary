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
#include "creatures/players/components/wheel/wheel_definitions.hpp"
#include "creatures/players/components/wheel/wheel_spells.hpp"

class Player;

struct PlayerWheelMethodsBonusData;

enum class WheelGemAffinity_t : uint8_t;

/**
 * @brief Represents the bonus data for the wheel of destiny in the game.
 *
 * @details The `IOWheelBonusData` class encapsulates the bonus data for the wheel of destiny in the game. It provides information about various bonuses, such as statistics, revelations, increases, decreases, leeching, and spells, that can be obtained by spinning the wheel.
 */
class IOWheelBonusData {
public:
	virtual ~IOWheelBonusData() = default;

	/**
	 * @brief Contains data arrays for various bonuses in the wheel of destiny.
	 *
	 * @details This struct provides a collection of data arrays that represent different bonuses in the wheel of destiny.
	 * @details It includes statistics for each stage of the wheel, bonuses for increasing specific aspects, bonuses for decreasing specific aspects, bonuses for leeching mana and life, and bonuses for different spells of different vocations.
	 */
	struct DataArray {
		struct Stats {
			int damage = 0;
			int healing = 0;
		};

		struct Revelation {
			std::array<Stats, magic_enum::enum_count<WheelStageEnum_t>() + 1> stats = {
				Stats { 4, 4 },
				Stats { 9, 9 },
				Stats { 20, 20 }
			};
		};

		struct Spells {
			struct Druid {
				std::array<WheelSpells::Bonus, 3> grade;
				std::string name;
			};

			struct Knight {
				std::array<WheelSpells::Bonus, 3> grade;
				std::string name;
			};

			struct Paladin {
				std::array<WheelSpells::Bonus, 3> grade;
				std::string name;
			};

			struct Sorcerer {
				std::array<WheelSpells::Bonus, 3> grade;
				std::string name;
			};

			std::array<Druid, 5> druid;
			std::array<Knight, 5> knight;
			std::array<Paladin, 5> paladin;
			std::array<Sorcerer, 5> sorcerer;
		};

		Spells spells;
		Revelation revelation;
	};

	/**
	 * @brief Data array containing various bonuses for the wheel of destiny.
	 *
	 * @details The `m_wheelBonusData` member variable is a data array that stores various bonuses for the wheel of destiny in the game.
	 * @details It provides information about different types of bonuses, such as spells, revelations, and specific attributes for each spell grade.
	 * @details The data is organized in a structured format for easy access and manipulation.
	 */
	DataArray m_wheelBonusData;
};

/**
 * @brief Represents the wheel of destiny and its functionalities.
 *
 * @details The `IOWheel` class represents the wheel of destiny in the game and provides various functionalities related to it.
 * @details It manages the initialization of global data, retrieval of wheel bonus data, revelation statistics, focus spells, slot priority orders, and mapping of wheel slots to their corresponding bonus functions for different vocations.
 *
 * @details The class also provides helper methods for initializing map data, initializing spells for each vocation, and performing specific actions related to the wheel, such as adding spells, increasing resistance, and determining vocation types.
 *
 * @details The `IOWheel` class inherits from `IOWheelBonusData`, which contains the data array of wheel bonuses.
 */
class IOWheel : public IOWheelBonusData {
public:
	/**
	 * @brief Initializes the global data of the wheel of destiny.
	 *
	 * @details This function initializes the global data required for the wheel of destiny.
	 * @details It can be called to reload the data if necessary.
	 *
	 * @param reload Flag indicating whether to reload the data.
	 * @return `true` if the global data initialization is successful, `false` otherwise.
	 */
	bool initializeGlobalData(bool reload = false);

	/**
	 * @brief Retrieves the wheel bonus data.
	 *
	 * @details This function returns a constant reference to the `IOWheelBonusData::DataArray` containing the wheel bonus data.
	 *
	 * @return A constant reference to the `IOWheelBonusData::DataArray` containing the wheel bonus data.
	 */
	const IOWheelBonusData::DataArray &getWheelBonusData() const;

	/**
	 * @brief Retrieves the focus spells associated with the IOWheel.
	 * @return A const reference to a std::vector<std::string> containing the focus spells associated with the IOWheel.
	 *
	 * @details The function accesses the focus spells through the static member variable InternalPlayerWheel::m_focusSpells.
	 * @details It returns a const reference to this vector, allowing read-only access to the focus spells.
	 */
	const std::vector<std::string> &getFocusSpells() const;

	using VocationBonusFunction = std::function<void(const std::shared_ptr<Player> &, uint16_t, uint8_t, PlayerWheelMethodsBonusData &)>;
	using VocationBonusMap = std::map<WheelSlots_t, VocationBonusFunction>;
	/**
	 * @brief Retrieves the mapping of wheel slots to vocation bonus functions.
	 * @return A constant reference to the mapping of wheel slots to vocation bonus functions.
	 *
	 * @see VocationBonusFunction
	 * @see VocationBonusMap
	 *
	 * @details The function returns a constant reference to a `VocationBonusMap` object, which represents the mapping
	 * of wheel slots to vocation bonus functions. The mapping is used to associate each wheel slot with a specific vocation bonus function that is called when the wheel slot is activated or triggered.
	 *
	 * @details The `VocationBonusFunction` type is defined as a `std::function` that takes references to a `Player` object, an `uint16_t` value, an `uint8_t` value, and a `PlayerWheelMethodsBonusData` object. It represents the signature of the vocation bonus function.
	 *
	 * @details The `VocationBonusMap` type is defined as a `std::map` that maps `WheelSlots_t` values to `VocationBonusFunction` objects. It provides a way to associate each wheel slot with its corresponding vocation bonus function.
	 *
	 * @details By returning a constant reference to the mapping, this function allows external code to access and utilize the mapping without modifying it.
	 */
	const VocationBonusMap &getWheelMapFunctions() const;

	/**
	 * @brief Retrieves the revelation stats by stage type.
	 * @param stageType The stage type for which to retrieve the revelation stats.
	 * @return A `std::pair<int, int>` containing the damage and healing stats associated with the specified stage type.
	 *
	 * @details The function accesses the `m_wheelBonusData.revelation.stats` array based on the provided stage type.
	 * @details The array index is calculated by subtracting 1 from the numeric value of the stage type (converted to an unsigned 8-bit integer).
	 * @details The resulting stats are then used to create and return a `std::pair<int, int>`, where the first element represents the damage stat, and the second element represents the healing stat.
	 */
	std::pair<int, int> getRevelationStatByStage(WheelStageEnum_t stageType) const;

	/**
	 * @brief Retrieves the prioritary order of a given wheel slot.
	 * @param slot The wheel slot for which to retrieve the prioritary order.
	 *
	 * @return The prioritary order of the specified wheel slot as an int8_t value.
	 *
	 * @details The function takes a `WheelSlots_t` parameter `slot` and evaluates its value against different slot types to determine the corresponding prioritary order. The prioritary order is an integer value that indicates the priority of the wheel slot for certain operations or calculations.
	 * @details If the specified slot does not match any known slot types, an error message is logged, and -1 is returned.
	 */
	int8_t getSlotPrioritaryOrder(WheelSlots_t slot) const;

	/**
	 * @brief Private helper functions of the IOWheel class.
	 * @details These functions are used internally by the class to assist in data initialization, wheel processing, and other tasks related to the class functionality.
	 * @details By keeping them private, we adhere to the principle of encapsulation, hiding implementation details and restricting their access to the internal scope of the class.
	 * @details Changing these functions to public without proper care can lead to issues such as violation of encapsulation and unexpected behaviors. If there is a need to expose part of the functionality of these functions to external code, it is recommended to create additional public functions that encapsulate the call to the private functions. This way, the encapsulation of the private functions is maintained, while providing a controlled interface to the external code.
	 * @details This modular approach preserves the class cohesion, facilitates maintenance, and reduces the risks of errors and unexpected behaviors when accessing the class functionalities.
	 */
private:
	/**
	 * @brief Map for storing vocation bonus information.
	 * @details This map stores the vocation bonus information, where the key represents the wheel slot type and the value represents the corresponding function associated with the slot. It serves as a lookup table for the wheel slots and their associated functions.
	 * @note Modifying or accessing this map without proper understanding and care can result in unexpected behavior or broken functionality. Exercise caution when working with this map.
	 */
	VocationBonusMap m_vocationBonusMap;

	/**
	 * @brief Initializes the wheel map data and spells for each vocation.
	 * @details This function is responsible for initializing the wheel map data and spells for each vocation, including the druid, knight, paladin, and sorcerer. It calls the respective helper functions to set up the spell information for each vocation.
	 * @note This function should be called before using the wheel map data or accessing vocation spells.
	 */
	void initializeMapData();

	/**
	 * @brief Initializes the spells for the druid vocation.
	 * @details This function sets up the spell information for the druid vocation in the wheel bonus data.
	 * @details It assigns names and specific grades of effects to each spell.
	 * @note Make sure to call this function before using druid spells.
	 */
	void initializeDruidSpells();

	/**
	 * @brief Initializes the spells for the knight vocation.
	 * @details This function sets up the spell information for the knight vocation in the wheel bonus data.
	 * @details It assigns names and specific grades of effects to each spell.
	 * @note Make sure to call this function before using knight spells.
	 */
	void initializeKnightSpells();

	/**
	 * @brief Initializes the spells for the paladin vocation.
	 * @details This function sets up the spell information for the paladin vocation in the wheel bonus data.
	 * @details It assigns names and specific grades of effects to each spell.
	 * @note Make sure to call this function before using paladin spells.
	 */
	void initializePaladinSpells();

	/**
	 * @brief Initializes the spells for the sorcerer vocation.
	 * @details This function sets up the spell information for the sorcerer vocation in the wheel bonus data.
	 * @details It assigns names and specific grades of effects to each spell.
	 * @note Make sure to call this function before using sorcerer spells.
	 */
	void initializeSorcererSpells();

	/**
	 * @brief Checks if the number of points is equal to the player's points in the specified slot type.
	 * @param player The player whose points will be checked.
	 * @param points The number of points to be compared.
	 * @param slotType The slot type to be checked.
	 * @return true if the number of points is equal to the player's points in the specified slot type, false otherwise.
	 */
	bool isMaxPointAddedToSlot(const std::shared_ptr<Player> &player, uint16_t points, WheelSlots_t slotType) const;

	/**
	 * @brief Checks if the vocation ID corresponds to a knight.
	 * @param vocationId The vocation ID to be checked.
	 * @return true if the vocation ID corresponds to a knight, false otherwise.
	 */
	bool isKnight(uint8_t vocationId) const;

	/**
	 * @brief Checks if the vocation ID corresponds to a paladin.
	 * @param vocationId The vocation ID to be checked.
	 * @return true if the vocation ID corresponds to a paladin, false otherwise.
	 */
	bool isPaladin(uint8_t vocationId) const;

	/**
	 * @brief Checks if the vocation ID corresponds to a sorcerer.
	 * @param vocationId The vocation ID to be checked.
	 * @return true if the vocation ID corresponds to a sorcerer, false otherwise.
	 */
	bool isSorcerer(uint8_t vocationId) const;

	/**
	 * @brief Checks if the vocation ID corresponds to a druid.
	 * @param vocationId The vocation ID to be checked.
	 * @return true if the vocation ID corresponds to a druid, false otherwise.
	 */
	bool isDruid(uint8_t vocationId) const;

	/**
	 * @brief Adds a spell to the player's bonus data if the number of points is equal to the player's points in the specified slot type.
	 * @param player The player to add the spell to.
	 * @param bonusData The bonus data to update.
	 * @param slotType The slot type to check the points against.
	 * @param points The number of points required to add the spell.
	 * @param spellName The name of the spell to add.
	 */
	void addSpell(const std::shared_ptr<Player> &player, PlayerWheelMethodsBonusData &bonusData, WheelSlots_t slotType, uint16_t points, const std::string &spellName) const;

	/**
	 * @brief Unlock a vessel resonance if the number of points is equal to the player's points in the specified slot type.
	 * @param player The player to receive the vessel resonance.
	 * @param bonusData The bonus data to update.
	 * @param slotType The slot type to check the points against.
	 * @param points The number of points required to add the vessel resonance.
	 */
	void addVesselResonance(const std::shared_ptr<Player> &player, PlayerWheelMethodsBonusData &bonusData, WheelSlots_t slotType, WheelGemAffinity_t affinity, uint16_t points) const;

	/**
	 * @brief Initialize the wheel map functions.
	 *
	 * This function initializes the vocation bonus map, which associates slots with their corresponding
	 * bonus functions. The map is populated with slot-function pairs, where each function is bound to
	 * the current instance of the `IOWheel` object.
	 */
	void initializeWheelMapFunctions();

	/**
	 * @brief Functions related to the initializeWheelMapFunctions
	 *
	 * @details This module contains a set of functions that provide support for WheelMapFunctions.
	 * @details Each function has a specific objective of initializing the information for each vocation, aiming to avoid code repetition.
	 * @details By using these functions, it is possible to configure essential information for each vocation, such as magic, damage protection, and other relevant attributes.
	 * @details It's important to note that although the functions have similar objectives, they are tailored to each specific vocation, allowing for proper customization for each one. Furthermore, these functions are designed to prevent code redundancy, promoting a modular structure that is easy to maintain.
	 * @note Note: Due to the large number of similar functions in this module, we have chosen not to document each function individually to avoid excessive documentation work. However, the information provided in this general description should provide a sufficient overview of the purpose and operation of these functions.
	 */
	void slotGreen200(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotGreenTop150(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotGreenTop100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;

	void slotRedTop100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotRedTop150(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotRed200(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;

	void slotGreenBottom150(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotGreenMiddle100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotGreenTop75(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;

	void slotRedTop75(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotRedMiddle100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotRedBottom150(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;

	void slotGreenBottom100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotGreenBottom75(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotGreen50(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;

	void slotRed50(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotRedBottom75(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotRedBottom100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;

	void slotBlueTop100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotBlueTop75(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotBlue50(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;

	void slotPurple50(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotPurpleTop75(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotPurpleTop100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;

	void slotBlueTop150(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotBlueMiddle100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotBlueBottom75(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;

	void slotPurpleBottom75(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotPurpleMiddle100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotPurpleTop150(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;

	void slotBlue200(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotBlueBottom150(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotBlueBottom100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;

	void slotPurpleBottom100(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotPurpleBottom150(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
	void slotPurple200(const std::shared_ptr<Player> &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData) const;
};
