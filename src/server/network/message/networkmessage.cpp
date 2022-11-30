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

void NetworkMessage::addString(const std::string& value)
{
	size_t stringLen = value.length();
	if (value.empty()) {
		SPDLOG_DEBUG("[NetworkMessage::addString] - Value string is empty");
	}
	if (!canAdd(stringLen + 2)) {
		SPDLOG_ERROR("[NetworkMessage::addString] - NetworkMessage size is wrong: {}", stringLen);
		return;
	}
	if (stringLen > NETWORKMESSAGE_MAXSIZE) {
		SPDLOG_ERROR("[NetworkMessage::addString] - Exceded NetworkMessage max size: {}, actually size: {}", NETWORKMESSAGE_MAXSIZE, stringLen);
		return;
	}

	add<uint16_t>(stringLen);
	memcpy(buffer + info.position, value.c_str(), stringLen);
	info.position += stringLen;
	info.length += stringLen;
}

void NetworkMessage::addDouble(double value, uint8_t precision/* = 2*/)
{
	addByte(precision);
	add<uint32_t>((value * std::pow(static_cast<float>(10), precision)) + std::numeric_limits<int32_t>::max());
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

void NetworkMessage::addPosition(const Position& pos)
{
	add<uint16_t>(pos.x);
	add<uint16_t>(pos.y);
	addByte(pos.z);
}
