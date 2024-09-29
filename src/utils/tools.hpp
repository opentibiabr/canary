/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "utils/utils_definitions.hpp"
#include "declarations.hpp"
#include "enums/item_attribute.hpp"
#include "game/movement/position.hpp"
#include "enums/object_category.hpp"

namespace pugi {
	struct xml_parse_result;
}

#ifndef USE_PRECOMPILED_HEADERS
	#include <random>
#endif

void printXMLError(const std::string &where, const std::string &fileName, const pugi::xml_parse_result &result);

std::string transformToSHA1(const std::string &input);

uint16_t getStashSize(const StashItemList &itemList);

std::string generateToken(const std::string &secret, uint32_t ticks);

void replaceString(std::string &str, const std::string &sought, const std::string &replacement);
void trim_right(std::string &source, char t);
void trim_left(std::string &source, char t);
std::string keepFirstWordOnly(std::string &str);

void toLowerCaseString(std::string &source);
std::string asLowerCaseString(std::string source);
std::string asUpperCaseString(std::string source);

std::string toCamelCase(const std::string &str);
std::string toPascalCase(const std::string &str);
std::string toSnakeCase(const std::string &str);
std::string toKebabCase(const std::string &str);
std::string toStartCaseWithSpace(const std::string &str);

using StringVector = std::vector<std::string>;
using IntegerVector = std::vector<int32_t>;

StringVector explodeString(const std::string &inString, const std::string &separator, int32_t limit = -1);
IntegerVector vectorAtoi(const StringVector &stringVector);
constexpr bool hasBitSet(uint32_t flag, uint32_t flags) {
	return (flags & flag) != 0;
}

std::mt19937 &getRandomGenerator();
int32_t uniform_random(int32_t minNumber, int32_t maxNumber);
int32_t normal_random(int32_t minNumber, int32_t maxNumber);
bool boolean_random(double probability = 0.5);

BedItemPart_t getBedPart(std::string_view string);
Direction getDirection(const std::string &string);
Position getNextPosition(Direction direction, Position pos);

/**
 * @param exactDiagonalOnly - defines if diagonals are calculated only for dy = dx (true) or any dx != 0 and dy != 0 (false).
 */
Direction getDirectionTo(const Position &from, const Position &to, bool exactDiagonalOnly = true);

std::string getFirstLine(const std::string &str);

std::string formatDate(time_t time);
std::string formatDateShort(time_t time);
std::string formatTime(time_t time);
/**
 * @brief Format the enum name by replacing underscores with spaces and converting to lowercase.
 * @param name The enum name to format.
 * @return A string with the formatted enum name.
 */
std::string formatEnumName(std::string_view name);
std::time_t getTimeNow();
int64_t getTimeMsNow();
int64_t getTimeUsNow();
std::string convertIPToString(uint32_t ip);

void trimString(std::string &str);

MagicEffectClasses getMagicEffect(const std::string &strValue);
ShootType_t getShootType(const std::string &strValue);
Ammo_t getAmmoType(const std::string &strValue);
WeaponAction_t getWeaponAction(const std::string &strValue);
Skulls_t getSkullType(const std::string &strValue);
ImbuementTypes_t getImbuementType(const std::string &strValue);
/**
 * @Deprecated
 * It will be dropped with monsters. Use RespawnPeriod_t instead.
 */
SpawnType_t getSpawnType(const std::string &strValue);

std::string getSkillName(uint8_t skillid);

uint32_t adlerChecksum(const uint8_t* data, size_t len);

std::string ucfirst(std::string str);
std::string ucwords(std::string str);
bool booleanString(const std::string &str);

std::string getWeaponName(WeaponType_t weaponType);
WeaponType_t getWeaponType(const std::string &name);
MoveEvent_t getMoveEventType(const std::string &name);

std::string getCombatName(CombatType_t combatType);
CombatType_t getCombatTypeByName(const std::string &combatname);

/**
 * @brief Convert the CombatType_t enumeration to its corresponding index.
 * @param combatType The CombatType_t enumeration to convert.
 * @return The corresponding index of the CombatType_t enumeration.
 * If the CombatType_t is out of range, this function will log an error and return an empty size_t.
 */
size_t combatTypeToIndex(CombatType_t combatType);

/**
 * @brief Convert the CombatType_t enumeration to its corresponding string representation.
 * @param combatType The CombatType_t enumeration to convert.
 * @return The corresponding string representation of the CombatType_t enumeration.
 * If the CombatType_t is out of range, this function will log an error and return an empty string.
 */
std::string combatTypeToName(CombatType_t combatType);

CombatType_t indexToCombatType(size_t v);

ItemAttribute_t stringToItemAttribute(const std::string &str);

const char* getReturnMessage(ReturnValue value);

void sleep_for(uint64_t ms);
void capitalizeWords(std::string &source);
void capitalizeWordsIgnoringString(std::string &source, const std::string &stringToIgnore);
void consoleHandlerExit();
NameEval_t validateName(const std::string &name);

bool isCaskItem(uint16_t itemId);

std::string getObjectCategoryName(ObjectCategory_t category);
bool isValidObjectCategory(ObjectCategory_t category);

int64_t OTSYS_TIME(bool useTime = false);
void UPDATE_OTSYS_TIME();

SpellGroup_t stringToSpellGroup(const std::string &value);

uint8_t forgeBonus(int32_t number);

std::string formatPrice(std::string price, bool space /* = false*/);
std::vector<std::string> split(const std::string &str, char delimiter = ',');
std::string getFormattedTimeRemaining(uint32_t time);

unsigned int getNumberOfCores();

static inline Cipbia_Elementals_t getCipbiaElement(CombatType_t combatType) {
	switch (combatType) {
		case COMBAT_PHYSICALDAMAGE:
			return CIPBIA_ELEMENTAL_PHYSICAL;
		case COMBAT_ENERGYDAMAGE:
			return CIPBIA_ELEMENTAL_ENERGY;
		case COMBAT_EARTHDAMAGE:
			return CIPBIA_ELEMENTAL_EARTH;
		case COMBAT_FIREDAMAGE:
			return CIPBIA_ELEMENTAL_FIRE;
		case COMBAT_LIFEDRAIN:
			return CIPBIA_ELEMENTAL_LIFEDRAIN;
		case COMBAT_HEALING:
			return CIPBIA_ELEMENTAL_HEALING;
		case COMBAT_DROWNDAMAGE:
			return CIPBIA_ELEMENTAL_DROWN;
		case COMBAT_ICEDAMAGE:
			return CIPBIA_ELEMENTAL_ICE;
		case COMBAT_HOLYDAMAGE:
			return CIPBIA_ELEMENTAL_HOLY;
		case COMBAT_DEATHDAMAGE:
			return CIPBIA_ELEMENTAL_DEATH;
		case COMBAT_MANADRAIN:
			return CIPBIA_ELEMENTAL_MANADRAIN;
		case COMBAT_AGONYDAMAGE:
			return CIPBIA_ELEMENTAL_AGONY;
		case COMBAT_NEUTRALDAMAGE:
			return CIPBIA_ELEMENTAL_AGONY;
		default:
			return CIPBIA_ELEMENTAL_UNDEFINED;
	}
}

std::string formatNumber(uint64_t number);

std::string getPlayerSubjectPronoun(PlayerPronoun_t pronoun, PlayerSex_t sex, const std::string &name);
std::string getPlayerObjectPronoun(PlayerPronoun_t pronoun, PlayerSex_t sex, const std::string &name);
std::string getPlayerPossessivePronoun(PlayerPronoun_t pronoun, PlayerSex_t sex, const std::string &name);
std::string getPlayerReflexivePronoun(PlayerPronoun_t pronoun, PlayerSex_t sex, const std::string &name);
std::string getVerbForPronoun(PlayerPronoun_t pronoun, bool pastTense = false);

std::string formatWithArticle(const std::string &value, bool withSpace = true);

std::string toKey(const std::string &str);

static inline double quadraticPoly(double a, double b, double c, double x) {
	return a * x * x + b * x + c;
}

uint8_t convertWheelGemAffinityToDomain(uint8_t affinity);

template <typename EnumType, typename UnderlyingType = std::underlying_type_t<EnumType>>
UnderlyingType enumToValue(EnumType value) {
	return static_cast<UnderlyingType>(value);
}

template <typename EnumType, typename UnderlyingType = std::underlying_type_t<EnumType>>
EnumType enumFromValue(UnderlyingType value) {
	return static_cast<EnumType>(value);
}

#ifdef _WIN32
	#define WIN32_WINNT 0x0501
	#include <dbghelp.h>

	#pragma comment(lib, "Dbghelp.lib")

inline void print_stack_trace() {
	const HANDLE process = GetCurrentProcess();

	SymSetOptions(SYMOPT_LOAD_LINES | SYMOPT_UNDNAME);

	if (!SymInitialize(process, nullptr, TRUE)) {
		const DWORD error = GetLastError();
		std::cerr << "SymInitialize falhou com o erro " << error << std::endl;
		return;
	}

	void* stack[100];
	auto* symbol = static_cast<SYMBOL_INFO*>(calloc(sizeof(SYMBOL_INFO) + MAX_SYM_NAME * sizeof(TCHAR), 1));
	symbol->MaxNameLen = MAX_SYM_NAME;
	symbol->SizeOfStruct = sizeof(SYMBOL_INFO);

	auto* line = static_cast<IMAGEHLP_LINE64*>(malloc(sizeof(IMAGEHLP_LINE64)));
	line->SizeOfStruct = sizeof(IMAGEHLP_LINE64);
	DWORD displacement_line = 0;

	const unsigned short frames = CaptureStackBackTrace(0, 100, stack, nullptr);

	const auto now = std::chrono::system_clock::now();
	const std::time_t now_c = std::chrono::system_clock::to_time_t(now);

	const DWORD threadId = GetCurrentThreadId();

	unsigned int framesToDisplay;
	if (frames > 10) {
		framesToDisplay = frames - 5;
	} else {
		framesToDisplay = frames;
	}

	std::cout << std::endl
			  << "Stack trace capturado em " << std::ctime(&now_c)
			  << "Thread ID: " << threadId
			  << " - Total de frames: " << framesToDisplay << std::endl;

	for (unsigned int i = 0; i < framesToDisplay; i++) {
		const auto address = reinterpret_cast<DWORD64>(stack[i]);
		if (SymFromAddr(process, address, nullptr, symbol)) {
			char undecoratedName[256];
			UnDecorateSymbolName(symbol->Name, undecoratedName, sizeof(undecoratedName), UNDNAME_COMPLETE);

			if (SymGetLineFromAddr64(process, address, &displacement_line, line)) {
				std::cout << std::setw(2) << i << " : "
						  << std::left << std::setw(60) << undecoratedName
						  << " at " << line->FileName << ":" << line->LineNumber
						  << " [0x" << std::hex << symbol->Address << std::dec << "]" << std::endl;
			} else {
				std::cout << std::setw(2) << i << " : "
						  << std::left << std::setw(60) << undecoratedName
						  << " at [Desconhecido]"
						  << " [0x" << std::hex << symbol->Address << std::dec << "]" << std::endl;
			}
		} else {
			const DWORD error = GetLastError();
			std::cerr << "SymFromAddr falhou para o endereço 0x" << std::hex << address << std::dec << " com o erro " << error << std::endl;
		}
	}

	free(symbol);
	free(line);
	SymCleanup(process);
}

#elif defined(__linux__)
	#include <execinfo.h>

inline void print_stack_trace() {
	const int max_frames = 100;
	void* addrlist[max_frames + 1];

	int frames = backtrace(addrlist, sizeof(addrlist) / sizeof(void*));

	if (frames == 0) {
		std::cout << "Nenhum frame de pilha capturado." << std::endl;
		return;
	}

	char** symbollist = backtrace_symbols(addrlist, frames);

	auto now = std::chrono::system_clock::now();
	std::time_t now_c = std::chrono::system_clock::to_time_t(now);

	std::cout << "\nStack trace capturado em " << std::ctime(&now_c)
			  << "Total de frames: " << frames << std::endl;

	int framesToDisplay;
	if (frames > 10) {
		framesToDisplay = frames - 5;
	} else {
		framesToDisplay = frames;
	}

	for (int i = 0; i < framesToDisplay; i++) {
		std::cout << symbollist[i] << std::endl;
	}

	free(symbollist);
}

#else
inline void print_stack_trace() {
	std::cout << "Stack trace não suportado nesta plataforma." << std::endl;
}
#endif
