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

#ifndef SRC_UTILS_TOOLS_H_
#define SRC_UTILS_TOOLS_H_

#include "utils/utils_definitions.hpp"
#include "declarations.hpp"
#include "game/movement/position.h"

void printXMLError(const std::string& where, const std::string& fileName, const pugi::xml_parse_result& result);

std::string transformToSHA1(const std::string& input);

uint16_t getStashSize(StashItemList itemList);

std::string generateToken(const std::string& secret, uint32_t ticks);

void replaceString(std::string& str, const std::string& sought, const std::string& replacement);
void trim_right(std::string& source, char t);
void trim_left(std::string& source, char t);
void toLowerCaseString(std::string& source);
std::string asLowerCaseString(std::string source);
std::string asUpperCaseString(std::string source);

using StringVector = std::vector<std::string>;
using IntegerVector = std::vector<int32_t>;

StringVector explodeString(const std::string& inString, const std::string& separator, int32_t limit = -1);
IntegerVector vectorAtoi(const StringVector& stringVector);
constexpr bool hasBitSet(uint32_t flag, uint32_t flags) {
	return (flags & flag) != 0;
}

std::mt19937& getRandomGenerator();
int64_t uniform_random(int64_t minNumber, int64_t maxNumber);
int64_t normal_random(int64_t minNumber, int64_t maxNumber);
bool boolean_random(double probability = 0.5);

Direction getDirection(const std::string& string);
Position getNextPosition(Direction direction, Position pos);
Direction getDirectionTo(const Position& from, const Position& to);

std::string getFirstLine(const std::string& str);

std::string formatDate(time_t time);
std::string formatDateShort(time_t time);
std::time_t getTimeNow();
std::string convertIPToString(uint32_t ip);

void trimString(std::string& str);

MagicEffectClasses getMagicEffect(const std::string& strValue);
ShootType_t getShootType(const std::string& strValue);
Ammo_t getAmmoType(const std::string& strValue);
WeaponAction_t getWeaponAction(const std::string& strValue);
Skulls_t getSkullType(const std::string& strValue);
ImbuementTypes_t getImbuementType(const std::string& strValue);
std::string getCombatName(CombatType_t combatType);
/**
 * @Deprecated
 * It will be dropped with monsters. Use RespawnPeriod_t instead.
 */
SpawnType_t getSpawnType(const std::string& strValue);
CombatType_t getCombatType(const std::string& combatname);

std::string getSkillName(uint8_t skillid);

uint32_t adlerChecksum(const uint8_t* data, size_t len);

std::string ucfirst(std::string str);
std::string ucwords(std::string str);
bool booleanString(const std::string& str);

std::string getWeaponName(WeaponType_t weaponType);

size_t combatTypeToIndex(CombatType_t combatType);
CombatType_t indexToCombatType(size_t v);

ItemAttrTypes stringToItemAttribute(const std::string& str);

const char* getReturnMessage(ReturnValue value);

void capitalizeWords(std::string &source);
void consoleHandlerExit();
NameEval_t validateName(const std::string &name);

bool isCaskItem(uint16_t itemId);

std::string getObjectCategoryName(ObjectCategory_t category);

int64_t OTSYS_TIME();

SpellGroup_t stringToSpellGroup(const std::string &value);

uint8_t forgeBonus(int32_t number);

std::string formatPrice(std::string price, bool space/* = false*/);

static inline Cipbia_Elementals_t getCipbiaElement(CombatType_t combatType) {
	switch (combatType) {
		case COMBAT_PHYSICALDAMAGE: return CIPBIA_ELEMENTAL_PHYSICAL;
		case COMBAT_ENERGYDAMAGE: return CIPBIA_ELEMENTAL_ENERGY;
		case COMBAT_EARTHDAMAGE: return CIPBIA_ELEMENTAL_EARTH;
		case COMBAT_FIREDAMAGE: return CIPBIA_ELEMENTAL_FIRE;
		case COMBAT_LIFEDRAIN: return CIPBIA_ELEMENTAL_LIFEDRAIN;
		case COMBAT_HEALING: return CIPBIA_ELEMENTAL_HEALING;
		case COMBAT_DROWNDAMAGE: return CIPBIA_ELEMENTAL_DROWN;
		case COMBAT_ICEDAMAGE: return CIPBIA_ELEMENTAL_ICE;
		case COMBAT_HOLYDAMAGE: return CIPBIA_ELEMENTAL_HOLY;
		case COMBAT_DEATHDAMAGE: return CIPBIA_ELEMENTAL_DEATH;
		default: return CIPBIA_ELEMENTAL_UNDEFINED;
	}
}

#endif  // SRC_UTILS_TOOLS_H_
