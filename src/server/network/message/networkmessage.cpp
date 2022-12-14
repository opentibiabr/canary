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

#include <limits>

#include "server/network/message/networkmessage.h"
#include "items/containers/container.h"
#include "creatures/creature.h"

int32_t NetworkMessage::decodeHeader()
{
	int32_t newSize = buffer[0] | buffer[1] << 8;
	info.length = newSize;
	return info.length;
}

std::string NetworkMessage::getString(uint16_t stringLen/* = 0*/)
{
	if (stringLen == 0) {
		stringLen = get<uint16_t>();
	}

	if (!canRead(stringLen)) {
		return std::string();
	}

	char* v = reinterpret_cast<char*>(buffer) + info.position; //does not break strict aliasing
	info.position += stringLen;
	return std::string(v, stringLen);
}

Position NetworkMessage::getPosition()
{
	Position pos;
	pos.x = get<uint16_t>();
	pos.y = get<uint16_t>();
	pos.z = getByte();
	return pos;
}

void NetworkMessage::addString(const std::string& function, const std::string& value)
{
	size_t stringLen = value.length();
	if (value.empty()) {
		SPDLOG_DEBUG("Value string is empty");
	}
	if (stringLen > NETWORKMESSAGE_MAXSIZE) {
		SPDLOG_ERROR("Exceded NetworkMessage max size: {}, actually size: {}", NETWORKMESSAGE_MAXSIZE, stringLen);
		return;
	}

	addU16(function, static_cast<uint16_t>(stringLen));
	memcpy(buffer + info.position, value.c_str(), stringLen);
	info.position += stringLen;
	info.length += stringLen;
}

void NetworkMessage::addDouble(const std::string &function, double value, uint8_t precision/* = 2*/)
{
	addByte(function, precision);
	addU32(function, static_cast<uint32_t>((value * std::pow(static_cast<float>(10), precision)) + std::numeric_limits<int32_t>::max()));
}

void NetworkMessage::addBytes(const char* bytes, size_t size)
{
	if (bytes == nullptr) {
		SPDLOG_ERROR("[NetworkMessage::addBytes] - Bytes is nullptr");
		return;
	}
	if (!canAdd(size)) {
		SPDLOG_ERROR("[NetworkMessage::addBytes] - NetworkMessage size is wrong: {}", size);
		return;
	}
	if (size > NETWORKMESSAGE_MAXSIZE) {
		SPDLOG_ERROR("[NetworkMessage::addBytes] - Exceded NetworkMessage max size: {}, actually size: {}", NETWORKMESSAGE_MAXSIZE, size);
		return;
	}

	memcpy(buffer + info.position, bytes, size);
	info.position += size;
	info.length += size;
}

void NetworkMessage::addPaddingBytes(size_t n)
{
	#define canAdd(size) ((size + info.position) < NETWORKMESSAGE_MAXSIZE)
	if (!canAdd(n)) {
		return;
	}
	#undef canAdd

	memset(buffer + info.position, 0x33, n);
	info.length += n;
}

void NetworkMessage::addPosition(const std::string &function, const Position& pos)
{
	addU16(function, pos.x);
	addU16(function, pos.y);
	addByte(function, pos.z);
}

void NetworkMessage::addByte(const std::string &function, uint8_t value) {
	if (value > std::numeric_limits<uint8_t>::max()) {
		SPDLOG_WARN("Could not add byte in function {}, exceeded uint8_t size", function);
		value = 0;
	}

	buffer[info.position++] = value;
	info.length++;
}

void NetworkMessage::addU16(const std::string &function, uint16_t value) {
	// If uint16_t overflows, send 0 for avoid errors
	if (value > std::numeric_limits<uint16_t>::max()) {
		SPDLOG_WARN("Could not add byte in function {}, exceeded uint16_t size", function);
		value = 0;
	}

	writeU16(&buffer[info.position], value);
	info.position += sizeof(value);
	info.length += sizeof(value);
}

void NetworkMessage::addU32(const std::string &function, uint32_t value) {
	// If uint16_t overflows, send 0 for avoid errors
	if (value > std::numeric_limits<uint32_t>::max()) {
		SPDLOG_WARN("Could not add byte in function {}, exceeded uint32_t size", function);
		value = 0;
	}

	writeU32(&buffer[info.position], value);
	info.position += sizeof(value);
	info.length += sizeof(value);
}

void NetworkMessage::addU64(const std::string &function, uint64_t value) {
	// If uint16_t overflows, send 0 for avoid errors
	if (value > std::numeric_limits<uint64_t>::max()) {
		SPDLOG_WARN("Could not add byte in function {}, exceeded uint64_t size", function);
		value = 0;
	}

	writeU64(&buffer[info.position], value);
	info.position += sizeof(value);
	info.length += sizeof(value);
}

void NetworkMessage::add16(const std::string &function, int16_t value) {
	// If uint16_t overflows, send 0 for avoid errors
	if (value > std::numeric_limits<int16_t>::max()) {
		SPDLOG_WARN("Could not add byte in function {}, exceeded int16_t size", function);
		value = 0;
	}

	write16(&buffer[info.position], value);
	info.position += sizeof(value);
	info.length += sizeof(value);
}

void NetworkMessage::add32(const std::string &function, int32_t value) {
	// If uint16_t overflows, send 0 for avoid errors
	if (value > std::numeric_limits<int32_t>::max()) {
		SPDLOG_WARN("Could not add byte in function {}, exceeded int32_t size", function);
		value = 0;
	}

	write32(&buffer[info.position], value);
	info.position += sizeof(value);
	info.length += sizeof(value);
}

void NetworkMessage::add64(const std::string &function, int64_t value) {
	// If uint16_t overflows, send 0 for avoid errors
	if (value > std::numeric_limits<int64_t>::max()) {
		SPDLOG_WARN("Could not add byte in function {}, exceeded int64_t size", function);
		value = 0;
	}

	write64(&buffer[info.position], value);
	info.position += sizeof(value);
	info.length += sizeof(value);
}
