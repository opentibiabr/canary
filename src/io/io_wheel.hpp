/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#ifndef SRC_IO_IO_WHEEL_HPP_
#define SRC_IO_IO_WHEEL_HPP_

// Definitions of wheel of destiny enums
#include "creatures/players/wheel/wheel_definitions.hpp"

#include "creatures/creatures_definitions.hpp"

class Player;

class IOWheelBonusData {
	public:
		virtual ~IOWheelBonusData() = default;

		struct DataArray {
				struct Stats {
						int damage = 0;
						int healing = 0;
				};

				struct Revelation {
						std::array<Stats, static_cast<size_t>(WheelStageEnum_t::TOTAL_COUNT)> stats = {
							Stats { 4, 4 },
							Stats { 9, 9 },
							Stats { 20, 20 }
						};
				} revelation;

				struct Increase {
						bool area = false;
						int damage = 0;
						int heal = 0;
						int aditionalTarget = 0;
						int damageReduction = 0;
						int duration = 0;
						int criticalDamage = 0;
						int criticalChance = 0;
				};
				struct Decrease {
						int cooldown = 0;
						int manaCost = 0;
						uint8_t secondaryGroupCooldown = 0;
				};

				struct Leech {
						int mana = 0;
						int life = 0;
				};

				struct Spells {
						struct Grade {
								Leech leech;
								Increase increase;
								Decrease decrease;
						};

						struct Druid {
								std::array<Grade, 3> grade;
								std::string name;
						};

						struct Knight {
								std::array<Grade, 3> grade;
								std::string name;
						};

						struct Paladin {
								std::array<Grade, 3> grade;
								std::string name;
						};

						struct Sorcerer {
								std::array<Grade, 3> grade;
								std::string name;
						};

						std::array<Druid, 5> druid;
						std::array<Knight, 5> knight;
						std::array<Paladin, 5> paladin;
						std::array<Sorcerer, 5> sorcerer;
				} spells;
		};

		DataArray m_wheelBonusData;
};

class IOWheel : IOWheelBonusData {
	public:
		bool initializeGlobalData(bool reload = false);

		const IOWheelBonusData::DataArray &getWheelBonusData() const;

		std::pair<int, int> getRevelationStatByStage(WheelStageEnum_t stageType) const;

		const std::vector<std::string> &getFocusSpells() const;

		int8_t getSlotPrioritaryOrder(WheelSlots_t slot);

		/// Type alias for the function used in the wheel map.
		using VocationBonusFunction = std::function<void(Player &, uint16_t, uint8_t, PlayerWheelMethodsBonusData &)>;
		/// Type alias for the wheel map that associates slots with their corresponding bonus functions.
		using VocationBonusMap = std::map<WheelSlots_t, VocationBonusFunction>;
		const VocationBonusMap &getWheelMapFunctions() const;

	private:
		VocationBonusMap m_vocationBonusMap;

		std::vector<std::string> m_focusSpells {
			{ "Eternal Winter",
			  "Hell's Core",
			  "Rage of the Skies",
			  "Wrath of Nature" }
		};

		/*
		 * Wheel spells helper methods
		 */
		void initializeMapData();
		void initializeDruidSpells();
		void initializeKnightSpells();
		void initializePaladinSpells();
		void initializeSorcererSpells();

		// Wheel methods
		// Helpers methods
		bool isPointsOnSlot(Player &player, uint16_t points, WheelSlots_t slotType) const;
		bool isKnight(uint8_t vocationId) const;
		bool isPaladin(uint8_t vocationId) const;
		bool isSorcerer(uint8_t vocationId) const;
		bool isDruid(uint8_t vocationId) const;
		void addSpell(Player &player, PlayerWheelMethodsBonusData &bonusData, WheelSlots_t slotType, uint16_t points, const std::string &spellName);
		void increaseResistance(Player &player, PlayerWheelMethodsBonusData &bonusData, WheelSlots_t slotType, uint16_t points, CombatType_t combat, int16_t value);

		/**
		 * @brief Initialize the wheel map functions.
		 *
		 * This function initializes the vocation bonus map, which associates slots with their corresponding
		 * bonus functions. The map is populated with slot-function pairs, where each function is bound to
		 * the current instance of the `IOWheel` object.
		 */
		void initializeWheelMapFunctions();

		/*
		 * Wheel slots informations load
		 */
		void slotGreen200(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotGreenTop150(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotGreenTop100(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);

		void slotRedTop100(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotRedTop150(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotRed200(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);

		void slotGreenBottom150(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotGreenMiddle100(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotGreenTop75(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);

		void slotRedTop75(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotRedMiddle100(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotRedBottom150(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);

		void slotGreenBottom100(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotGreenBottom75(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotGreen50(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);

		void slotRed50(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotRedBottom75(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotRedBottom100(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);

		void slotBlueTop100(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotBlueTop75(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotBlue50(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);

		void slotPurple50(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotPurpleTop75(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotPurpleTop100(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);

		void slotBlueTop150(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotBlueMiddle100(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotBlueBottom75(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);

		void slotPurpleBottom75(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotPurpleMiddle100(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotPurpleTop150(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);

		void slotBlue200(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotBlueBottom150(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotBlueBottom100(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);

		void slotPurpleBottom100(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotPurpleBottom150(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
		void slotPurple200(Player &player, uint16_t points, uint8_t vocationCipId, PlayerWheelMethodsBonusData &bonusData);
};

#endif // SRC_IO_IO_WHEEL_HPP_
