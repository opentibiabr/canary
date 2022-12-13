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

#include "pch.hpp"

#include "core.hpp"

#include "utils/tools.h"

#include <fmt/chrono.h>

void printXMLError(const std::string& where, const std::string& fileName, const pugi::xml_parse_result& result)
{
	SPDLOG_ERROR("[{}] Failed to load {}: {}", where, fileName, result.description());

	FILE* file = fopen(fileName.c_str(), "rb");
	if (!file) {
		return;
	}

	char buffer[32768];
	uint32_t currentLine = 1;
	std::string line;

	size_t offset = static_cast<size_t>(result.offset);
	size_t lineOffsetPosition = 0;
	size_t index = 0;
	size_t bytes;
	do {
		bytes = fread(buffer, 1, 32768, file);
		for (size_t i = 0; i < bytes; ++i) {
			char ch = buffer[i];
			if (ch == '\n') {
				if ((index + i) >= offset) {
					lineOffsetPosition = line.length() - ((index + i) - offset);
					bytes = 0;
					break;
				}
				++currentLine;
				line.clear();
			} else {
				line.push_back(ch);
			}
		}
		index += bytes;
	} while (bytes == 32768);
	fclose(file);

	SPDLOG_ERROR("Line {}:", currentLine);
	SPDLOG_ERROR("{}", line);
	for (size_t i = 0; i < lineOffsetPosition; i++) {
		if (line[i] == '\t') {
			SPDLOG_ERROR("\t");
		} else {
			SPDLOG_ERROR(" ");
		}
	}
	SPDLOG_ERROR("^");
}

static uint32_t circularShift(int bits, uint32_t value)
{
	return (value << bits) | (value >> (32 - bits));
}

static void processSHA1MessageBlock(const uint8_t* messageBlock, uint32_t* H)
{
	uint32_t W[80];
	for (int i = 0; i < 16; ++i) {
		const size_t offset = i << 2;
		W[i] = messageBlock[offset] << 24 | messageBlock[offset + 1] << 16 | messageBlock[offset + 2] << 8 | messageBlock[offset + 3];
	}

	for (int i = 16; i < 80; ++i) {
		W[i] = circularShift(1, W[i - 3] ^ W[i - 8] ^ W[i - 14] ^ W[i - 16]);
	}

	uint32_t A = H[0], B = H[1], C = H[2], D = H[3], E = H[4];

	for (int i = 0; i < 20; ++i) {
		const uint32_t tmp = circularShift(5, A) + ((B & C) | ((~B) & D)) + E + W[i] + 0x5A827999;
		E = D; D = C; C = circularShift(30, B); B = A; A = tmp;
	}

	for (int i = 20; i < 40; ++i) {
		const uint32_t tmp = circularShift(5, A) + (B ^ C ^ D) + E + W[i] + 0x6ED9EBA1;
		E = D; D = C; C = circularShift(30, B); B = A; A = tmp;
	}

	for (int i = 40; i < 60; ++i) {
		const uint32_t tmp = circularShift(5, A) + ((B & C) | (B & D) | (C & D)) + E + W[i] + 0x8F1BBCDC;
		E = D; D = C; C = circularShift(30, B); B = A; A = tmp;
	}

	for (int i = 60; i < 80; ++i) {
		const uint32_t tmp = circularShift(5, A) + (B ^ C ^ D) + E + W[i] + 0xCA62C1D6;
		E = D; D = C; C = circularShift(30, B); B = A; A = tmp;
	}

	H[0] += A;
	H[1] += B;
	H[2] += C;
	H[3] += D;
	H[4] += E;
}

std::string transformToSHA1(const std::string& input)
{
	uint32_t H[] = {
		0x67452301,
		0xEFCDAB89,
		0x98BADCFE,
		0x10325476,
		0xC3D2E1F0
	};

	uint8_t messageBlock[64];
	size_t index = 0;

	uint32_t length_low = 0;
	uint32_t length_high = 0;
	for (char ch : input) {
		messageBlock[index++] = ch;

		length_low += 8;
		if (length_low == 0) {
			length_high++;
		}

		if (index == 64) {
			processSHA1MessageBlock(messageBlock, H);
			index = 0;
		}
	}

	messageBlock[index++] = 0x80;

	if (index > 56) {
		while (index < 64) {
			messageBlock[index++] = 0;
		}

		processSHA1MessageBlock(messageBlock, H);
		index = 0;
	}

	while (index < 56) {
		messageBlock[index++] = 0;
	}

	messageBlock[56] = length_high >> 24;
	messageBlock[57] = length_high >> 16;
	messageBlock[58] = length_high >> 8;
	messageBlock[59] = length_high;

	messageBlock[60] = length_low >> 24;
	messageBlock[61] = length_low >> 16;
	messageBlock[62] = length_low >> 8;
	messageBlock[63] = length_low;

	processSHA1MessageBlock(messageBlock, H);

	char hexstring[41];
	static const char hexDigits[] = {"0123456789abcdef"};
	for (int hashByte = 20; --hashByte >= 0;) {
		const uint8_t byte = H[hashByte >> 2] >> (((3 - hashByte) & 3) << 3);
		index = hashByte << 1;
		hexstring[index] = hexDigits[byte >> 4];
		hexstring[index + 1] = hexDigits[byte & 15];
	}
	return std::string(hexstring, 40);
}

uint16_t getStashSize(StashItemList itemList)
{
	uint16_t size = 0;
	for (auto item : itemList) {
		size += ceil(item.second / 100.0);
	}
	return size;
}

std::string generateToken(const std::string& key, uint32_t ticks)
{
	// generate message from ticks
	std::string message(8, 0);
	for (uint8_t i = 8; --i; ticks >>= 8) {
		message[i] = static_cast<char>(ticks & 0xFF);
	}

	// hmac key pad generation
	std::string iKeyPad(64, 0x36), oKeyPad(64, 0x5C);
	for (uint8_t i = 0; i < key.length(); ++i) {
		iKeyPad[i] ^= key[i];
		oKeyPad[i] ^= key[i];
	}

	oKeyPad.reserve(84);

	// hmac concat inner pad with message
	iKeyPad.append(message);

	// hmac first pass
	message.assign(transformToSHA1(iKeyPad));

	// hmac concat outer pad with message, conversion from hex to int needed
	for (uint8_t i = 0; i < message.length(); i += 2) {
		oKeyPad.push_back(static_cast<char>(std::stol(message.substr(i, 2), nullptr, 16)));
	}

	// hmac second pass
	message.assign(transformToSHA1(oKeyPad));

	// calculate hmac offset
	uint32_t offset = static_cast<uint32_t>(std::stol(message.substr(39, 1), nullptr, 16) & 0xF);

	// get truncated hash
	uint32_t truncHash = std::stol(message.substr(2 * offset, 8), nullptr, 16) & 0x7FFFFFFF;
	message.assign(std::to_string(truncHash));

	// return only last AUTHENTICATOR_DIGITS (default 6) digits, also asserts exactly 6 digits
	uint32_t hashLen = message.length();
	message.assign(message.substr(hashLen - std::min(hashLen, AUTHENTICATOR_DIGITS)));
	message.insert(0, AUTHENTICATOR_DIGITS - std::min(hashLen, AUTHENTICATOR_DIGITS), '0');
	return message;
}

void replaceString(std::string& str, const std::string& sought, const std::string& replacement)
{
	size_t pos = 0;
	size_t start = 0;
	size_t soughtLen = sought.length();
	size_t replaceLen = replacement.length();

	while ((pos = str.find(sought, start)) != std::string::npos) {
		str = str.substr(0, pos) + replacement + str.substr(pos + soughtLen);
		start = pos + replaceLen;
	}
}

void trim_right(std::string& source, char t)
{
	source.erase(source.find_last_not_of(t) + 1);
}

void trim_left(std::string& source, char t)
{
	source.erase(0, source.find_first_not_of(t));
}

void toLowerCaseString(std::string& source)
{
	std::transform(source.begin(), source.end(), source.begin(), tolower);
}

std::string asLowerCaseString(std::string source)
{
	toLowerCaseString(source);
	return source;
}

std::string asUpperCaseString(std::string source)
{
	std::transform(source.begin(), source.end(), source.begin(), toupper);
	return source;
}

StringVector explodeString(const std::string& inString, const std::string& separator, int32_t limit/* = -1*/)
{
	StringVector returnVector;
	std::string::size_type start = 0, end = 0;

	while (--limit != -1 && (end = inString.find(separator, start)) != std::string::npos) {
		returnVector.push_back(inString.substr(start, end - start));
		start = end + separator.size();
	}

	returnVector.push_back(inString.substr(start));
	return returnVector;
}

IntegerVector vectorAtoi(const StringVector& stringVector)
{
	IntegerVector returnVector;
	for (const auto& string : stringVector) {
		returnVector.push_back(std::stoi(string));
	}
	return returnVector;
}

std::mt19937& getRandomGenerator()
{
	static std::random_device rd;
	static std::mt19937 generator(rd());
	return generator;
}

int64_t uniform_random(int64_t minNumber, int64_t maxNumber)
{
	static std::uniform_int_distribution<int64_t> uniformRand;
	if (minNumber == maxNumber) {
		return minNumber;
	} else if (minNumber > maxNumber) {
		std::swap(minNumber, maxNumber);
	}
	return uniformRand(getRandomGenerator(), std::uniform_int_distribution<int64_t>::param_type(minNumber, maxNumber));
}

int64_t normal_random(int64_t minNumber, int64_t maxNumber)
{
	static std::normal_distribution<float> normalRand(0.5f, 0.25f);
	if (minNumber == maxNumber) {
		return minNumber;
	} else if (minNumber > maxNumber) {
		std::swap(minNumber, maxNumber);
	}

	int64_t increment;
	const int64_t diff = maxNumber - minNumber;
	const float v = normalRand(getRandomGenerator());
	if (v < 0.0) {
		increment = diff / 2;
	} else if (v > 1.0) {
		increment = (diff + 1) / 2;
	} else {
		increment = round(v * diff);
	}
	return minNumber + increment;
}

bool boolean_random(double probability/* = 0.5*/)
{
	static std::bernoulli_distribution booleanRand;
	return booleanRand(getRandomGenerator(), std::bernoulli_distribution::param_type(probability));
}

void trimString(std::string& str)
{
	str.erase(str.find_last_not_of(' ') + 1);
	str.erase(0, str.find_first_not_of(' '));
}

std::string convertIPToString(uint32_t ip)
{
	char buffer[17];

	int res = sprintf(buffer, "%u.%u.%u.%u", ip & 0xFF, (ip >> 8) & 0xFF, (ip >> 16) & 0xFF, (ip >> 24));
	if (res < 0) {
		return {};
	}

	return buffer;
}

std::string formatDate(time_t time)
{
	return fmt::format("{:%d/%m/%Y %H:%M:%S}", fmt::localtime(time));
}

std::string formatDateShort(time_t time)
{
	return fmt::format("{:%Y-%m-%d %X}", fmt::localtime(time));
}

std::time_t getTimeNow() {
	return std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
}

Direction getDirection(const std::string& string)
{
	Direction direction = DIRECTION_NORTH;

	if (string == "north" || string == "n" || string == "0") {
		direction = DIRECTION_NORTH;
	} else if (string == "east" || string == "e" || string == "1") {
		direction = DIRECTION_EAST;
	} else if (string == "south" || string == "s" || string == "2") {
		direction = DIRECTION_SOUTH;
	} else if (string == "west" || string == "w" || string == "3") {
		direction = DIRECTION_WEST;
	} else if (string == "southwest" || string == "south west" || string == "south-west" || string == "sw" || string == "4") {
		direction = DIRECTION_SOUTHWEST;
	} else if (string == "southeast" || string == "south east" || string == "south-east" || string == "se" || string == "5") {
		direction = DIRECTION_SOUTHEAST;
	} else if (string == "northwest" || string == "north west" || string == "north-west" || string == "nw" || string == "6") {
		direction = DIRECTION_NORTHWEST;
	} else if (string == "northeast" || string == "north east" || string == "north-east" || string == "ne" || string == "7") {
		direction = DIRECTION_NORTHEAST;
	}

	return direction;
}

Position getNextPosition(Direction direction, Position pos)
{
	switch (direction) {
		case DIRECTION_NORTH:
			pos.y--;
			break;

		case DIRECTION_SOUTH:
			pos.y++;
			break;

		case DIRECTION_WEST:
			pos.x--;
			break;

		case DIRECTION_EAST:
			pos.x++;
			break;

		case DIRECTION_SOUTHWEST:
			pos.x--;
			pos.y++;
			break;

		case DIRECTION_NORTHWEST:
			pos.x--;
			pos.y--;
			break;

		case DIRECTION_NORTHEAST:
			pos.x++;
			pos.y--;
			break;

		case DIRECTION_SOUTHEAST:
			pos.x++;
			pos.y++;
			break;

		default:
			break;
	}

	return pos;
}

Direction getDirectionTo(const Position& from, const Position& to)
{
	Direction dir;

	int32_t x_offset = Position::getOffsetX(from, to);
	if (x_offset < 0) {
		dir = DIRECTION_EAST;
		x_offset = std::abs(x_offset);
	} else {
		dir = DIRECTION_WEST;
	}

	int32_t y_offset = Position::getOffsetY(from, to);
	if (y_offset >= 0) {
		if (y_offset > x_offset) {
			dir = DIRECTION_NORTH;
		} else if (y_offset == x_offset) {
			if (dir == DIRECTION_EAST) {
				dir = DIRECTION_NORTHEAST;
			} else {
				dir = DIRECTION_NORTHWEST;
			}
		}
	} else {
		y_offset = std::abs(y_offset);
		if (y_offset > x_offset) {
			dir = DIRECTION_SOUTH;
		} else if (y_offset == x_offset) {
			if (dir == DIRECTION_EAST) {
				dir = DIRECTION_SOUTHEAST;
			} else {
				dir = DIRECTION_SOUTHWEST;
			}
		}
	}
	return dir;
}

using MagicEffectNames = phmap::flat_hash_map<std::string, MagicEffectClasses>;
using ShootTypeNames = phmap::flat_hash_map<std::string, ShootType_t>;
using CombatTypeNames = phmap::flat_hash_map<CombatType_t, std::string, std::hash<int32_t>>;
using AmmoTypeNames = phmap::flat_hash_map<std::string, Ammo_t>;
using WeaponActionNames = phmap::flat_hash_map<std::string, WeaponAction_t>;
using SkullNames = phmap::flat_hash_map<std::string, Skulls_t>;
using ImbuementTypeNames = phmap::flat_hash_map<std::string, ImbuementTypes_t>;

/**
 * @Deprecated
 * It will be dropped with monsters. Use RespawnPeriod_t instead.
 */
using SpawnTypeNames = phmap::flat_hash_map<std::string, SpawnType_t>;

MagicEffectNames magicEffectNames = {
	{"assassin",			CONST_ME_ASSASSIN},
	{"bluefireworks",		CONST_ME_BLUE_FIREWORKS },
	{"bluebubble",			CONST_ME_LOSEENERGY},
	{"blackspark",			CONST_ME_HITAREA},
	{"blueshimmer",			CONST_ME_MAGIC_BLUE},
	{"bluenote",			CONST_ME_SOUND_BLUE},
	{"bubbles",				CONST_ME_BUBBLES},
	{"bluefirework",		CONST_ME_FIREWORK_BLUE},
	{"bigclouds",			CONST_ME_BIGCLOUDS},
	{"bigplants",			CONST_ME_BIGPLANTS},
	{"bloodysteps",			CONST_ME_BLOODYSTEPS},
	{"bats",				CONST_ME_BATS},
	{"blueenergyspark",		CONST_ME_BLUE_ENERGY_SPARK },
	{"blueghost",			CONST_ME_BLUE_GHOST },
	{"blacksmoke",			CONST_ME_BLACKSMOKE},
	{"carniphila",			CONST_ME_CARNIPHILA},
	{"cake",				CONST_ME_CAKE},
	{"confettihorizontal",	CONST_ME_CONFETTI_HORIZONTAL},
	{"confettivertical",	CONST_ME_CONFETTI_VERTICAL},
	{"criticaldagame",		CONST_ME_CRITICAL_DAMAGE},
	{"dice",				CONST_ME_CRAPS},
	{"dragonhead",			CONST_ME_DRAGONHEAD},
	{"explosionarea",		CONST_ME_EXPLOSIONAREA},
	{"explosion",			CONST_ME_EXPLOSIONHIT},
	{"energy",				CONST_ME_ENERGYHIT},
	{"energyarea",			CONST_ME_ENERGYAREA},
	{"earlythunder",		CONST_ME_EARLY_THUNDER },
	{"fire",				CONST_ME_HITBYFIRE},
	{"firearea",			CONST_ME_FIREAREA},
	{"fireattack",			CONST_ME_FIREATTACK},
	{"ferumbras",			CONST_ME_FERUMBRAS},
	{"greenspark",			CONST_ME_HITBYPOISON},
	{"greenbubble",			CONST_ME_GREEN_RINGS},
	{"greennote",			CONST_ME_SOUND_GREEN},
	{"greenshimmer",		CONST_ME_MAGIC_GREEN},
	{"giftwraps",			CONST_ME_GIFT_WRAPS},
	{"groundshaker",		CONST_ME_GROUNDSHAKER},
	{"giantice",			CONST_ME_GIANTICE},
	{"greensmoke",			CONST_ME_GREENSMOKE},
	{"greenenergyspark",	CONST_ME_GREEN_ENERGY_SPARK },
	{"greenfireworks",		CONST_ME_GREEN_FIREWORKS },
	{"hearts",				CONST_ME_HEARTS},
	{"holydamage",			CONST_ME_HOLYDAMAGE},
	{"holyarea",			CONST_ME_HOLYAREA},
	{"icearea",				CONST_ME_ICEAREA},
	{"icetornado",			CONST_ME_ICETORNADO},
	{"iceattack",			CONST_ME_ICEATTACK},
	{"insects",				CONST_ME_INSECTS},
	{"mortarea",			CONST_ME_MORTAREA},
	{"mirrorhorizontal",	CONST_ME_MIRRORHORIZONTAL},
	{"mirrorvertical",		CONST_ME_MIRRORVERTICAL},
	{"magicpowder",			CONST_ME_MAGIC_POWDER },
	{"orcshaman",			CONST_ME_ORCSHAMAN},
	{"orcshamanfire",		CONST_ME_ORCSHAMAN_FIRE},
	{"orangeenergyspark",	CONST_ME_ORANGE_ENERGY_SPARK },
	{"orangefireworks",		CONST_ME_ORANGE_FIREWORKS },
	{"poff",				CONST_ME_POFF},
	{"poison",				CONST_ME_POISONAREA},
	{"purplenote",			CONST_ME_SOUND_PURPLE},
	{"purpleenergy",		CONST_ME_PURPLEENERGY},
	{"plantattack",			CONST_ME_PLANTATTACK},
	{"plugingfish",			CONST_ME_PLUNGING_FISH},
	{"purplesmoke",			CONST_ME_PURPLESMOKE},
	{"pixieexplosion",		CONST_ME_PIXIE_EXPLOSION },
	{"pixiecoming",			CONST_ME_PIXIE_COMING },
	{"pixiegoing",			CONST_ME_PIXIE_GOING },
	{"pinkbeam",			CONST_ME_PINK_BEAM },
	{"pinkvortex",			CONST_ME_PINK_VORTEX },
	{"pinkenergyspark",		CONST_ME_PINK_ENERGY_SPARK },
	{"pinkfireworks",		CONST_ME_PINK_FIREWORKS },
	{"redspark",			CONST_ME_DRAWBLOOD},
	{"redshimmer",			CONST_ME_MAGIC_RED},
	{"rednote",				CONST_ME_SOUND_RED},
	{"redfirework",			CONST_ME_FIREWORK_RED},
	{"redsmoke",			CONST_ME_REDSMOKE},
	{"ragiazbonecapsule",	CONST_ME_RAGIAZ_BONECAPSULE},
	{"stun",				CONST_ME_STUN},
	{"sleep",				CONST_ME_SLEEP},
	{"smallclouds",			CONST_ME_SMALLCLOUDS},
	{"stones",				CONST_ME_STONES},
	{"smallplants",			CONST_ME_SMALLPLANTS},
	{"skullhorizontal",		CONST_ME_SKULLHORIZONTAL},
	{"skullvertical",		CONST_ME_SKULLVERTICAL},
	{"stepshorizontal",		CONST_ME_STEPSHORIZONTAL},
	{"stepsvertical",		CONST_ME_STEPSVERTICAL},
	{"smoke",				CONST_ME_SMOKE},
	{"storm",				CONST_ME_STORM },
	{"stonestorm",			CONST_ME_STONE_STORM },
	{"teleport",			CONST_ME_TELEPORT},
	{"tutorialarrow",		CONST_ME_TUTORIALARROW},
	{"tutorialsquare",		CONST_ME_TUTORIALSQUARE},
	{"thunder",				CONST_ME_THUNDER},
	{"treasuremap",			CONST_ME_TREASURE_MAP },
	{"yellowspark",			CONST_ME_BLOCKHIT},
	{"yellowbubble",		CONST_ME_YELLOW_RINGS},
	{"yellownote",			CONST_ME_SOUND_YELLOW},
	{"yellowfirework",		CONST_ME_FIREWORK_YELLOW},
	{"yellowenergy",		CONST_ME_YELLOWENERGY},
	{"yalaharighost",		CONST_ME_YALAHARIGHOST},
	{"yellowsmoke",			CONST_ME_YELLOWSMOKE},
	{"yellowenergyspark",	CONST_ME_YELLOW_ENERGY_SPARK },
	{"whitenote",			CONST_ME_SOUND_WHITE},
	{"watercreature",		CONST_ME_WATERCREATURE},
	{"watersplash",			CONST_ME_WATERSPLASH},
	{"whiteenergyspark",	CONST_ME_WHITE_ENERGY_SPARK },
	{"fatal", 				CONST_ME_FATAL},
	{"dodge", 				CONST_ME_DODGE},
	{"hourglass",			CONST_ME_HOURGLASS},
	{"ferumbras1",			CONST_ME_FERUMBRAS_1},
	{"gazharagoth",			CONST_ME_GAZHARAGOTH},
	{"madmage",				CONST_ME_MAD_MAGE},
	{"horestis",			CONST_ME_HORESTIS},
	{"devovorga",			CONST_ME_DEVOVORGA},
	{"ferumbras2",			CONST_ME_FERUMBRAS_2},
};

ShootTypeNames shootTypeNames = {
	{"arrow",				CONST_ANI_ARROW},
	{"bolt",				CONST_ANI_BOLT},
	{"burstarrow",			CONST_ANI_BURSTARROW},
	{"cake",				CONST_ANI_CAKE},
	{"crystallinearrow",	CONST_ANI_CRYSTALLINEARROW},
	{"drillbolt",			CONST_ANI_DRILLBOLT},
	{"death",				CONST_ANI_DEATH},
	{"energy",				CONST_ANI_ENERGY},
	{"enchantedspear",		CONST_ANI_ENCHANTEDSPEAR},
	{"etherealspear",		CONST_ANI_ETHEREALSPEAR},
	{"eartharrow",			CONST_ANI_EARTHARROW},
	{"explosion",			CONST_ANI_EXPLOSION},
	{"earth",				CONST_ANI_EARTH},
	{"energyball",			CONST_ANI_ENERGYBALL},
	{"envenomedarrow",		CONST_ANI_ENVENOMEDARROW},
	{"fire",				CONST_ANI_FIRE},
	{"flasharrow",			CONST_ANI_FLASHARROW},
	{"flammingarrow",		CONST_ANI_FLAMMINGARROW},
	{"greenstar",			CONST_ANI_GREENSTAR},
	{"gloothspear",			CONST_ANI_GLOOTHSPEAR},
	{"huntingspear",		CONST_ANI_HUNTINGSPEAR},
	{"holy",				CONST_ANI_HOLY},
	{"infernalbolt",		CONST_ANI_INFERNALBOLT},
	{"ice",					CONST_ANI_ICE},
	{"largerock",			CONST_ANI_LARGEROCK},
	{"leafstar",			CONST_ANI_LEAFSTAR},
	{"onyxarrow",			CONST_ANI_ONYXARROW},
	{"redstar",				CONST_ANI_REDSTAR},
	{"royalspear",			CONST_ANI_ROYALSPEAR},
	{"spear",				CONST_ANI_SPEAR},
	{"sniperarrow",			CONST_ANI_SNIPERARROW},
	{"smallstone",			CONST_ANI_SMALLSTONE},
	{"smallice",			CONST_ANI_SMALLICE},
	{"smallholy",			CONST_ANI_SMALLHOLY},
	{"smallearth",			CONST_ANI_SMALLEARTH},
	{"snowball",			CONST_ANI_SNOWBALL},
	{"suddendeath",			CONST_ANI_SUDDENDEATH},
	{"shiverarrow",			CONST_ANI_SHIVERARROW},
	{"simplearrow",			CONST_ANI_SIMPLEARROW},
	{"poisonarrow",			CONST_ANI_POISONARROW},
	{"powerbolt",			CONST_ANI_POWERBOLT},
	{"poison",				CONST_ANI_POISON},
	{"prismaticbolt",		CONST_ANI_PRISMATICBOLT},
	{"piercingbolt",		CONST_ANI_PIERCINGBOLT},
	{"throwingstar",		CONST_ANI_THROWINGSTAR},
	{"vortexbolt",			CONST_ANI_VORTEXBOLT},
	{"throwingknife",		CONST_ANI_THROWINGKNIFE},
	{"tarsalarrow",			CONST_ANI_TARSALARROW},
	{"whirlwindsword",		CONST_ANI_WHIRLWINDSWORD},
	{"whirlwindaxe",		CONST_ANI_WHIRLWINDAXE},
	{"whirlwindclub",		CONST_ANI_WHIRLWINDCLUB},
	{"diamondarrow",		CONST_ANI_DIAMONDARROW},
	{"spectralbolt",		CONST_ANI_SPECTRALBOLT},
	{"royalstar",			CONST_ANI_ROYALSTAR},
};

CombatTypeNames combatTypeNames = {
	{COMBAT_DROWNDAMAGE,			"drown"			},
	{COMBAT_DEATHDAMAGE,			"death"			},
	{COMBAT_ENERGYDAMAGE,			"energy"		},
	{COMBAT_EARTHDAMAGE,			"earth"			},
	{COMBAT_FIREDAMAGE,				"fire"			},
	{COMBAT_HEALING,					"healing"		},
	{COMBAT_HOLYDAMAGE,				"holy"			},
	{COMBAT_ICEDAMAGE,				"ice"				},
	{COMBAT_UNDEFINEDDAMAGE,	"undefined"	},
	{COMBAT_LIFEDRAIN,				"lifedrain"	},
	{COMBAT_MANADRAIN,				"manadrain"	},
	{COMBAT_PHYSICALDAMAGE, 	"physical"	},
};

AmmoTypeNames ammoTypeNames = {
	{"arrow",				AMMO_ARROW},
	{"bolt",				AMMO_BOLT},
	{"poisonarrow",			AMMO_ARROW},
	{"burstarrow",			AMMO_ARROW},
	{"enchantedspear",		AMMO_SPEAR},
	{"etherealspear",		AMMO_SPEAR},
	{"eartharrow",			AMMO_ARROW},
	{"flasharrow",			AMMO_ARROW},
	{"flammingarrow",		AMMO_ARROW},
	{"huntingspear",		AMMO_SPEAR},
	{"infernalbolt",		AMMO_BOLT},
	{"largerock",			AMMO_STONE},
	{"onyxarrow",			AMMO_ARROW},
	{"powerbolt",			AMMO_BOLT},
	{"piercingbolt",		AMMO_BOLT},
	{"royalspear",			AMMO_SPEAR},
	{"snowball",			AMMO_SNOWBALL},
	{"smallstone",			AMMO_STONE},
	{"spear",				AMMO_SPEAR},
	{"sniperarrow",			AMMO_ARROW},
	{"shiverarrow",			AMMO_ARROW},
	{"throwingstar",		AMMO_THROWINGSTAR},
	{"throwingknife",		AMMO_THROWINGKNIFE},
	{"diamondarrow",		AMMO_ARROW},
	{"spectralbolt",		AMMO_BOLT},

};

WeaponActionNames weaponActionNames = {
	{"move",				WEAPONACTION_MOVE},
	{"removecharge",		WEAPONACTION_REMOVECHARGE},
	{"removecount",			WEAPONACTION_REMOVECOUNT},
};

SkullNames skullNames = {
	{"black",				SKULL_BLACK},
	{"green",				SKULL_GREEN},
	{"none",				SKULL_NONE},
	{"orange",				SKULL_ORANGE},
	{"red",					SKULL_RED},
	{"yellow",				SKULL_YELLOW},
	{"white",				SKULL_WHITE},
};

const ImbuementTypeNames imbuementTypeNames = {
	{"elemental damage", IMBUEMENT_ELEMENTAL_DAMAGE},
	{"life leech", IMBUEMENT_LIFE_LEECH},
	{"mana leech", IMBUEMENT_MANA_LEECH},
	{"critical hit", IMBUEMENT_CRITICAL_HIT},
	{"elemental protection death", IMBUEMENT_ELEMENTAL_PROTECTION_DEATH},
	{"elemental protection earth", IMBUEMENT_ELEMENTAL_PROTECTION_EARTH},
	{"elemental protection fire", IMBUEMENT_ELEMENTAL_PROTECTION_FIRE},
	{"elemental protection ice", IMBUEMENT_ELEMENTAL_PROTECTION_ICE},
	{"elemental protection energy", IMBUEMENT_ELEMENTAL_PROTECTION_ENERGY},
	{"elemental protection holy", IMBUEMENT_ELEMENTAL_PROTECTION_HOLY},
	{"increase speed", IMBUEMENT_INCREASE_SPEED},
	{"skillboost axe", IMBUEMENT_SKILLBOOST_AXE},
	{"skillboost sword", IMBUEMENT_SKILLBOOST_SWORD},
	{"skillboost club", IMBUEMENT_SKILLBOOST_CLUB},
	{"skillboost shielding", IMBUEMENT_SKILLBOOST_SHIELDING},
	{"skillboost distance", IMBUEMENT_SKILLBOOST_DISTANCE},
	{"skillboost magic level", IMBUEMENT_SKILLBOOST_MAGIC_LEVEL},
	{"increase capacity", IMBUEMENT_INCREASE_CAPACITY}
};

/**
 * @Deprecated
 * It will be dropped with monsters. Use RespawnPeriod_t instead.
 */
SpawnTypeNames spawnTypeNames = {
	{"all",					RESPAWN_IN_ALL },
	{"day",					RESPAWN_IN_DAY },
	{"dayandcave",			RESPAWN_IN_DAY_CAVE },
	{"night",				RESPAWN_IN_NIGHT },
	{"nightandcave",		RESPAWN_IN_NIGHT_CAVE },
};

MagicEffectClasses getMagicEffect(const std::string& strValue)
{
	auto magicEffect = magicEffectNames.find(strValue);
	if (magicEffect != magicEffectNames.end()) {
		return magicEffect->second;
	}
	return CONST_ME_NONE;
}

ShootType_t getShootType(const std::string& strValue)
{
	auto shootType = shootTypeNames.find(strValue);
	if (shootType != shootTypeNames.end()) {
		return shootType->second;
	}
	return CONST_ANI_NONE;
}

std::string getCombatName(CombatType_t combatType)
{
	auto combatName = combatTypeNames.find(combatType);
	if (combatName != combatTypeNames.end()) {
		return combatName->second;
	}
	return "unknown";
}

CombatType_t getCombatType(const std::string& combatname)
{
	auto it = std::find_if(combatTypeNames.begin(), combatTypeNames.end(), [combatname](std::pair<CombatType_t, std::string> const& pair) {
		return pair.second == combatname;
	});

	return it != combatTypeNames.end() ? it->first : COMBAT_NONE;
}

Ammo_t getAmmoType(const std::string& strValue)
{
	auto ammoType = ammoTypeNames.find(strValue);
	if (ammoType != ammoTypeNames.end()) {
		return ammoType->second;
	}
	return AMMO_NONE;
}

WeaponAction_t getWeaponAction(const std::string& strValue)
{
	auto weaponAction = weaponActionNames.find(strValue);
	if (weaponAction != weaponActionNames.end()) {
		return weaponAction->second;
	}
	return WEAPONACTION_NONE;
}

Skulls_t getSkullType(const std::string& strValue)
{
	auto skullType = skullNames.find(strValue);
	if (skullType != skullNames.end()) {
		return skullType->second;
	}
	return SKULL_NONE;
}

ImbuementTypes_t getImbuementType(const std::string& strValue)
{
	auto imbuementType = imbuementTypeNames.find(strValue);
	if (imbuementType != imbuementTypeNames.end()) {
		return imbuementType->second;
	}
	return IMBUEMENT_NONE;
}

/**
 * @Deprecated
 * It will be dropped with monsters. Use RespawnPeriod_t instead.
 */
SpawnType_t getSpawnType(const std::string& strValue)
{
	auto spawnType = spawnTypeNames.find(strValue);
	if (spawnType != spawnTypeNames.end()) {
		return spawnType->second;
	}
	return RESPAWN_IN_ALL;
}

std::string getSkillName(uint8_t skillid)
{
	switch (skillid) {
		case SKILL_FIST:
			return "fist fighting";

		case SKILL_CLUB:
			return "club fighting";

		case SKILL_SWORD:
			return "sword fighting";

		case SKILL_AXE:
			return "axe fighting";

		case SKILL_DISTANCE:
			return "distance fighting";

		case SKILL_SHIELD:
			return "shielding";

		case SKILL_FISHING:
			return "fishing";

		case SKILL_CRITICAL_HIT_CHANCE:
			return "critical hit chance";

		case SKILL_CRITICAL_HIT_DAMAGE:
			return "critical extra damage";

		case SKILL_LIFE_LEECH_CHANCE:
			return "life leech chance";

		case SKILL_LIFE_LEECH_AMOUNT:
			return "life leech amount";

		case SKILL_MANA_LEECH_CHANCE:
			return "mana leech chance";

		case SKILL_MANA_LEECH_AMOUNT:
			return "mana leech amount";

		case SKILL_MAGLEVEL:
			return "magic level";

		case SKILL_LEVEL:
			return "level";

		default:
			return "unknown";
	}
}

uint32_t adlerChecksum(const uint8_t* data, size_t length)
{
	if (length > NETWORKMESSAGE_MAXSIZE) {
		return 0;
	}

	const uint16_t adler = 65521;

	uint32_t a = 1, b = 0;

	while (length > 0) {
		size_t tmp = length > 5552 ? 5552 : length;
		length -= tmp;

		do {
			a += *data++;
			b += a;
		} while (--tmp);

		a %= adler;
		b %= adler;
	}

	return (b << 16) | a;
}

std::string ucfirst(std::string str)
{
	for (char& i : str) {
		if (i != ' ') {
			i = toupper(i);
			break;
		}
	}
	return str;
}

std::string ucwords(std::string str)
{
	size_t strLength = str.length();
	if (strLength == 0) {
		return str;
	}

	str[0] = toupper(str.front());
	for (size_t i = 1; i < strLength; ++i) {
		if (str[i - 1] == ' ') {
			str[i] = toupper(str[i]);
		}
	}

	return str;
}

bool booleanString(const std::string& str)
{
	if (str.empty()) {
		return false;
	}

	char ch = tolower(str.front());
	return ch != 'f' && ch != 'n' && ch != '0';
}

std::string getWeaponName(WeaponType_t weaponType)
{
	switch (weaponType) {
		case WEAPON_SWORD: return "sword";
		case WEAPON_CLUB: return "club";
		case WEAPON_AXE: return "axe";
		case WEAPON_DISTANCE: return "distance";
		case WEAPON_WAND: return "wand";
		case WEAPON_AMMO: return "ammunition";
		default: return std::string();
	}
}

size_t combatTypeToIndex(CombatType_t combatType)
{
	switch (combatType) {
		case COMBAT_PHYSICALDAMAGE:
			return 0;
		case COMBAT_ENERGYDAMAGE:
			return 1;
		case COMBAT_EARTHDAMAGE:
			return 2;
		case COMBAT_FIREDAMAGE:
			return 3;
		case COMBAT_UNDEFINEDDAMAGE:
			return 4;
		case COMBAT_LIFEDRAIN:
			return 5;
		case COMBAT_MANADRAIN:
			return 6;
		case COMBAT_HEALING:
			return 7;
		case COMBAT_DROWNDAMAGE:
			return 8;
		case COMBAT_ICEDAMAGE:
			return 9;
		case COMBAT_HOLYDAMAGE:
			return 10;
		case COMBAT_DEATHDAMAGE:
			return 11;
		default:
			return 0;
	}
}

CombatType_t indexToCombatType(size_t v)
{
	return static_cast<CombatType_t>(1 << v);
}

ItemAttrTypes stringToItemAttribute(const std::string& str)
{
	if (str == "aid") {
		return ITEM_ATTRIBUTE_ACTIONID;
	} else if (str == "uid") {
		return ITEM_ATTRIBUTE_UNIQUEID;
	} else if (str == "description") {
		return ITEM_ATTRIBUTE_DESCRIPTION;
	} else if (str == "text") {
		return ITEM_ATTRIBUTE_TEXT;
	} else if (str == "date") {
		return ITEM_ATTRIBUTE_DATE;
	} else if (str == "writer") {
		return ITEM_ATTRIBUTE_WRITER;
	} else if (str == "name") {
		return ITEM_ATTRIBUTE_NAME;
	} else if (str == "article") {
		return ITEM_ATTRIBUTE_ARTICLE;
	} else if (str == "pluralname") {
		return ITEM_ATTRIBUTE_PLURALNAME;
	} else if (str == "weight") {
		return ITEM_ATTRIBUTE_WEIGHT;
	} else if (str == "attack") {
		return ITEM_ATTRIBUTE_ATTACK;
	} else if (str == "defense") {
		return ITEM_ATTRIBUTE_DEFENSE;
	} else if (str == "extradefense") {
		return ITEM_ATTRIBUTE_EXTRADEFENSE;
	} else if (str == "armor") {
		return ITEM_ATTRIBUTE_ARMOR;
	} else if (str == "hitchance") {
		return ITEM_ATTRIBUTE_HITCHANCE;
	} else if (str == "shootrange") {
		return ITEM_ATTRIBUTE_SHOOTRANGE;
	} else if (str == "owner") {
		return ITEM_ATTRIBUTE_OWNER;
	} else if (str == "duration") {
		return ITEM_ATTRIBUTE_DURATION;
	} else if (str == "decaystate") {
		return ITEM_ATTRIBUTE_DECAYSTATE;
	} else if (str == "corpseowner") {
		return ITEM_ATTRIBUTE_CORPSEOWNER;
	} else if (str == "charges") {
		return ITEM_ATTRIBUTE_CHARGES;
	} else if (str == "fluidtype") {
		return ITEM_ATTRIBUTE_FLUIDTYPE;
	} else if (str == "doorid") {
		return ITEM_ATTRIBUTE_DOORID;
	} else if (str == "timestamp") {
		return ITEM_ATTRIBUTE_DURATION_TIMESTAMP;
	}
	return ITEM_ATTRIBUTE_NONE;
}

std::string getFirstLine(const std::string& str)
{
	std::string firstLine;
	firstLine.reserve(str.length());
	for (const char c : str) {
		if (c == '\n') {
			break;
		}
		firstLine.push_back(c);
	}
	return firstLine;
}

const char* getReturnMessage(ReturnValue value)
{
	switch (value) {
		case RETURNVALUE_NOERROR:
			return "No error.";

		case RETURNVALUE_REWARDCHESTISEMPTY:
			return "The chest is currently empty. You did not take part in any battles in the last seven days or already claimed your reward.";

		case RETURNVALUE_DESTINATIONOUTOFREACH:
			return "Destination is out of reach.";

		case RETURNVALUE_NOTMOVEABLE:
			return "You cannot move this object.";

		case RETURNVALUE_DROPTWOHANDEDITEM:
			return "Drop the double-handed object first.";

		case RETURNVALUE_BOTHHANDSNEEDTOBEFREE:
			return "Both hands need to be free.";

		case RETURNVALUE_CANNOTBEDRESSED:
			return "You cannot dress this object there.";

		case RETURNVALUE_PUTTHISOBJECTINYOURHAND:
			return "Put this object in your hand.";

		case RETURNVALUE_PUTTHISOBJECTINBOTHHANDS:
			return "Put this object in both hands.";

		case RETURNVALUE_CANONLYUSEONEWEAPON:
			return "You may only use one weapon.";

		case RETURNVALUE_TOOFARAWAY:
			return "Too far away.";

		case RETURNVALUE_FIRSTGODOWNSTAIRS:
			return "First go downstairs.";

		case RETURNVALUE_FIRSTGOUPSTAIRS:
			return "First go upstairs.";

		case RETURNVALUE_NOTENOUGHCAPACITY:
			return "This object is too heavy for you to carry.";

		case RETURNVALUE_CONTAINERNOTENOUGHROOM:
			return "You cannot put more objects in this container.";

		case RETURNVALUE_ONLYAMMOINQUIVER:
			return "This quiver only holds arrows and bolts.\nYou cannot put any other items in it.";

		case RETURNVALUE_CREATUREBLOCK:
		case RETURNVALUE_NEEDEXCHANGE:
		case RETURNVALUE_NOTENOUGHROOM:
			return "There is not enough room.";

		case RETURNVALUE_CANNOTPICKUP:
			return "You cannot take this object.";

		case RETURNVALUE_CANNOTTHROW:
			return "You cannot throw there.";

		case RETURNVALUE_THEREISNOWAY:
			return "There is no way.";

		case RETURNVALUE_THISISIMPOSSIBLE:
			return "This is impossible.";

		case RETURNVALUE_PLAYERISPZLOCKED:
			return "You can not enter a protection zone after attacking another player.";

		case RETURNVALUE_PLAYERISNOTINVITED:
			return "You are not invited.";

		case RETURNVALUE_CREATUREDOESNOTEXIST:
			return "Creature does not exist.";

		case RETURNVALUE_DEPOTISFULL:
			return "You cannot put more items in this depot.";

		case RETURNVALUE_CANNOTUSETHISOBJECT:
			return "You cannot use this object.";

		case RETURNVALUE_PLAYERWITHTHISNAMEISNOTONLINE:
			return "A player with this name is not online.";

		case RETURNVALUE_NOTREQUIREDLEVELTOUSERUNE:
			return "You do not have the required magic level to use this rune.";

		case RETURNVALUE_YOUAREALREADYTRADING:
			return "You are already trading.";

		case RETURNVALUE_THISPLAYERISALREADYTRADING:
			return "This player is already trading.";

		case RETURNVALUE_YOUMAYNOTLOGOUTDURINGAFIGHT:
			return "You may not logout during or immediately after a fight!";

		case RETURNVALUE_DIRECTPLAYERSHOOT:
			return "You are not allowed to shoot directly on players.";

		case RETURNVALUE_NOTENOUGHLEVEL:
			return "You do not have enough level.";

		case RETURNVALUE_NOTENOUGHMAGICLEVEL:
			return "You do not have enough magic level.";

		case RETURNVALUE_NOTENOUGHMANA:
			return "You do not have enough mana.";

		case RETURNVALUE_NOTENOUGHSOUL:
			return "You do not have enough soul.";

		case RETURNVALUE_YOUAREEXHAUSTED:
			return "You are exhausted.";

		case RETURNVALUE_CANONLYUSETHISRUNEONCREATURES:
			return "You can only use this rune on creatures.";

		case RETURNVALUE_PLAYERISNOTREACHABLE:
			return "Player is not reachable.";

		case RETURNVALUE_CREATUREISNOTREACHABLE:
			return "Creature is not reachable.";

		case RETURNVALUE_ACTIONNOTPERMITTEDINPROTECTIONZONE:
			return "This action is not permitted in a protection zone.";

		case RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER:
			return "You may not attack this player.";

		case RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE:
			return "You may not attack this creature.";

		case RETURNVALUE_YOUMAYNOTATTACKAPERSONINPROTECTIONZONE:
			return "You may not attack a person in a protection zone.";

		case RETURNVALUE_YOUMAYNOTATTACKAPERSONWHILEINPROTECTIONZONE:
			return "You may not attack a person while you are in a protection zone.";

		case RETURNVALUE_YOUCANONLYUSEITONCREATURES:
			return "You can only use it on creatures.";

		case RETURNVALUE_TURNSECUREMODETOATTACKUNMARKEDPLAYERS:
			return "Turn secure mode off if you really want to attack unmarked players.";

		case RETURNVALUE_YOUNEEDPREMIUMACCOUNT:
			return "You need a premium account.";

		case RETURNVALUE_YOUNEEDTOLEARNTHISSPELL:
			return "You need to learn this spell first.";

		case RETURNVALUE_YOURVOCATIONCANNOTUSETHISSPELL:
			return "Your vocation cannot use this spell.";

		case RETURNVALUE_YOUNEEDAWEAPONTOUSETHISSPELL:
			return "You need to equip a weapon to use this spell.";

		case RETURNVALUE_PLAYERISPZLOCKEDLEAVEPVPZONE:
			return "You can not leave a pvp zone after attacking another player.";

		case RETURNVALUE_PLAYERISPZLOCKEDENTERPVPZONE:
			return "You can not enter a pvp zone after attacking another player.";

		case RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE:
			return "This action is not permitted in a non pvp zone.";

		case RETURNVALUE_YOUCANNOTLOGOUTHERE:
			return "You can not logout here.";

		case RETURNVALUE_YOUNEEDAMAGICITEMTOCASTSPELL:
			return "You need a magic item to cast this spell.";

		case RETURNVALUE_CANNOTCONJUREITEMHERE:
			return "You cannot conjure items here.";

		case RETURNVALUE_YOUNEEDTOSPLITYOURSPEARS:
			return "You need to split your spears first.";

		case RETURNVALUE_NAMEISTOOAMBIGUOUS:
			return "Player name is ambiguous.";

		case RETURNVALUE_CANONLYUSEONESHIELD:
			return "You may use only one shield.";

		case RETURNVALUE_NOPARTYMEMBERSINRANGE:
			return "No party members in range.";

		case RETURNVALUE_YOUARENOTTHEOWNER:
			return "You are not the owner.";

		case RETURNVALUE_YOUCANTOPENCORPSEADM:
			return "You can't open this corpse, because you are an Admin.";

		case RETURNVALUE_NOSUCHRAIDEXISTS:
			return "No such raid exists.";

		case RETURNVALUE_ANOTHERRAIDISALREADYEXECUTING:
			return "Another raid is already executing.";

		case RETURNVALUE_TRADEPLAYERFARAWAY:
			return "Trade player is too far away.";

		case RETURNVALUE_YOUDONTOWNTHISHOUSE:
			return "You don't own this house.";

		case RETURNVALUE_TRADEPLAYERALREADYOWNSAHOUSE:
			return "Trade player already owns a house.";

		case RETURNVALUE_TRADEPLAYERHIGHESTBIDDER:
			return "Trade player is currently the highest bidder of an auctioned house.";

		case RETURNVALUE_YOUCANNOTTRADETHISHOUSE:
			return "You can not trade this house.";

		case RETURNVALUE_YOUDONTHAVEREQUIREDPROFESSION:
			return "You don't have the required profession.";

		case RETURNVALUE_NOTENOUGHFISTLEVEL:
			return "You do not have enough fist level";

		case RETURNVALUE_NOTENOUGHCLUBLEVEL:
			return "You do not have enough club level";

		case RETURNVALUE_NOTENOUGHSWORDLEVEL:
			return "You do not have enough sword level";

		case RETURNVALUE_NOTENOUGHAXELEVEL:
			return "You do not have enough axe level";

		case RETURNVALUE_NOTENOUGHDISTANCELEVEL:
			return "You do not have enough distance level";

		case RETURNVALUE_NOTENOUGHSHIELDLEVEL:
			return "You do not have enough shielding level";

		case RETURNVALUE_NOTENOUGHFISHLEVEL:
			return "You do not have enough fishing level";

		case RETURNVALUE_NOTPOSSIBLE:
			return "Sorry, not possible.";

		case RETURNVALUE_CONTACTADMINISTRATOR:
			return "An error has occurred, please contact your administrator.";

		// Any unhandled ReturnValue will go enter here
		default:
			return "Unknown error.";
	}
}

int64_t OTSYS_TIME()
{
	return std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
}

SpellGroup_t stringToSpellGroup(const std::string &value)
{
	std::string tmpStr = asLowerCaseString(value);
	if (tmpStr == "attack" || tmpStr == "1") {
		return SPELLGROUP_ATTACK;
	} else if (tmpStr == "healing" || tmpStr == "2") {
		return SPELLGROUP_HEALING;
	} else if (tmpStr == "support" || tmpStr == "3") {
		return SPELLGROUP_SUPPORT;
	} else if (tmpStr == "special" || tmpStr == "4") {
		return SPELLGROUP_SPECIAL;
	} else if (tmpStr == "crippling" || tmpStr == "6") {
		return SPELLGROUP_CRIPPLING;
	} else if (tmpStr == "focus" || tmpStr == "7") {
		return SPELLGROUP_FOCUS;
	} else if (tmpStr == "ultimatestrikes" || tmpStr == "8") {
		return SPELLGROUP_ULTIMATESTRIKES;
	}

	return SPELLGROUP_NONE;
}

/**
 * @authors jlcvp, acmh
 * @details
 * capitalize the first letter of every word in source
 * @param source
 */
void capitalizeWords(std::string& source)
{
	toLowerCaseString(source);
	uint8_t size = (uint8_t) source.size();
	for(uint8_t i=0; i< size; i++) {
		if(i==0) {
			source[i] = (char)toupper(source[i]);
		} else if(source[i-1] == ' ' || source[i-1] == '\'') {
			source[i] = (char)toupper(source[i]);
		}
	}
}

/**
 * @details
 * Prevents the console from closing so there is time to read the error information
 * Then can press any key to close
*/
void consoleHandlerExit()
{
	SPDLOG_ERROR("The program will close after pressing the enter key...");
	getchar();
	return;
}

NameEval_t validateName(const std::string &name)
{

	StringVector prohibitedWords = {"owner", "gamemaster", "hoster", "admin", "staff", "tibia", "account", "god", "anal", "ass", "fuck", "sex", "hitler", "pussy", "dick", "rape", "cm", "gm", "tutor", "counsellor", "god"};
	StringVector toks;
	std::regex regexValidChars("^[a-zA-Z' ]+$");

	boost::split(toks, name, boost::is_any_of(" '"));
	if(name.length()<3 || name.length()>14) {
		return INVALID_LENGTH;
	}

	if(!std::regex_match(name, regexValidChars)) { //invalid chars in name
		return INVALID_CHARACTER;
	}

	for(std::string str : toks) {
		if(str.length()<2)
			return INVALID_TOKEN_LENGTH;
		else if(std::find(prohibitedWords.begin(), prohibitedWords.end(),str) != prohibitedWords.end()) { //searching for prohibited words
			return INVALID_FORBIDDEN;
		}
	}

	return VALID;
}
bool isCaskItem(uint16_t itemId)
{
	return (itemId >= ITEM_HEALTH_CASK_START && itemId <= ITEM_HEALTH_CASK_END) ||
		(itemId >= ITEM_MANA_CASK_START && itemId <= ITEM_MANA_CASK_END) ||
		(itemId >= ITEM_SPIRIT_CASK_START && itemId <= ITEM_SPIRIT_CASK_END);
}

std::string getObjectCategoryName(ObjectCategory_t category)
{
	switch (category) {
		case OBJECTCATEGORY_ARMORS: return "Armors";
		case OBJECTCATEGORY_NECKLACES: return "Amulets";
		case OBJECTCATEGORY_BOOTS: return "Boots";
		case OBJECTCATEGORY_CONTAINERS: return "Containers";
		case OBJECTCATEGORY_DECORATION: return "Decoration";
		case OBJECTCATEGORY_FOOD: return "Food";
		case OBJECTCATEGORY_HELMETS: return "Helmets";
		case OBJECTCATEGORY_LEGS: return "Legs";
		case OBJECTCATEGORY_OTHERS: return "Others";
		case OBJECTCATEGORY_POTIONS: return "Potions";
		case OBJECTCATEGORY_RINGS: return "Rings";
		case OBJECTCATEGORY_RUNES: return "Runes";
		case OBJECTCATEGORY_SHIELDS: return "Shields";
		case OBJECTCATEGORY_TOOLS: return "Tools";
		case OBJECTCATEGORY_VALUABLES: return "Valuables";
		case OBJECTCATEGORY_AMMO: return "Weapons: Ammunition";
		case OBJECTCATEGORY_AXES: return "Weapons: Axes";
		case OBJECTCATEGORY_CLUBS: return "Weapons: Clubs";
		case OBJECTCATEGORY_DISTANCEWEAPONS: return "Weapons: Distance";
		case OBJECTCATEGORY_SWORDS: return "Weapons: Swords";
		case OBJECTCATEGORY_WANDS: return "Weapons: Wands";
		case OBJECTCATEGORY_PREMIUMSCROLLS: return "Premium Scrolls";
		case OBJECTCATEGORY_TIBIACOINS: return "Tibia Coins";
		case OBJECTCATEGORY_CREATUREPRODUCTS: return "Creature Products";
		case OBJECTCATEGORY_STASHRETRIEVE: return "Stash Retrieve";
		case OBJECTCATEGORY_GOLD: return "Gold";
		case OBJECTCATEGORY_DEFAULT: return "Unassigned Loot";
		default: return std::string();
	}
}

uint8_t forgeBonus(int32_t number)
{
	// None
	if (number < 7400)
		return 0;
	// Dust not consumed
	else if (number >= 7400 && number < 9000)
		return 1;
	// Cores not consumed
	else if (number >= 9000 && number < 9500)
		return 2;
	// Gold not consumed
	else if (number >= 9500 && number < 9525)
		return 3;
	// Second item retained with decreased tier
	else if (number >= 9525 && number < 9550)
		return 4;
	// Second item retained with unchanged tier
	else if (number >= 9550 && number < 9950)
		return 5;
	// Second item retained with increased tier
	else if (number >= 9950 && number < 9975)
		return 6;
	// Gain two tiers
	else if (number >= 9975)
		return 7;

	return 0;
}

std::string formatPrice(std::string price, bool space/* = false*/)
{
	std::ranges::reverse(price.begin(), price.end());
	price = std::regex_replace(price, std::regex("000"), "k");
	std::ranges::reverse(price.begin(), price.end());
	if (space) {
		price = std::regex_replace(price, std::regex("k"), " k", std::regex_constants::format_first_only);
	}

	return price;
}
