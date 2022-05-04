/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 * <https://github.com/opentibiabr/canary>
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

#include "otpch.h"

#include "file_stream.hpp"
#include "binary_tree.hpp"
#include "utils/math.hpp"

#include <physfs.h>
#include <fmt/core.h>

FileStream::FileStream(std::string newFileName, PHYSFS_File* newfileHandle, bool newWriteable) :
	fileName(std::move(newFileName)),
	physfsFile(newfileHandle),
	seekPosition(0),
	writeable(newWriteable),
	caching(false)
{}

FileStream::FileStream(std::string newFileName, const std::string& buffer) :
	fileName(std::move(newFileName)),
	physfsFile(nullptr),
	seekPosition(0),
	writeable(false),
	caching(true)
{
	dataBuffer.resize(buffer.length());
	memcpy(&dataBuffer[0], &buffer[0], buffer.length());
}

void FileStream::cache()
{
	caching = true;

	if (!writeable) {
		if (!isInitializedPhysfsFile()) {
			SPDLOG_ERROR("[FileStream::cache] - PHYSFS File is not initialized");
			return;
		}

		// Cache entire file into data buffer
		seekPosition = PHYSFS_tell(getPhysfsFile());
		PHYSFS_seek(getPhysfsFile(), 0);
		const int64_t size = PHYSFS_fileLength(getPhysfsFile());
		dataBuffer.resize(size);
		if (PHYSFS_readBytes(getPhysfsFile(), dataBuffer.data(), size) == -1) {
			throwError("[FileStream::cache] - Unable to read file data", true);
		}
		PHYSFS_close(getPhysfsFile());
		setPhysfsFile(nullptr);
	}
}

void FileStream::close()
{
	if (isInitializedPhysfsFile() && PHYSFS_isInit()) {
		if (!PHYSFS_close(getPhysfsFile())) {
			throwError("[FileStream::close] - Close failed", true);
		}
		setPhysfsFile(nullptr);
	}

	dataBuffer.clear();
	seekPosition = 0;
}

void FileStream::flush()
{
	if (!writeable) {
		throwError("[FileStream::flush] - Filestream is not writeable");
	}

	if (isInitializedPhysfsFile()) {
		if (caching) {
			if (!PHYSFS_seek(getPhysfsFile(), 0)) {
				throwError("[FileStream::flush] - Flush seek failed", true);
			}
			const uint64_t len = dataBuffer.size();
			if (PHYSFS_writeBytes(getPhysfsFile(), dataBuffer.data(), len) != len) {
				throwError("[FileStream::flush] - Flush write failed", true);
			}
		}

		if (PHYSFS_flush(getPhysfsFile()) == 0) {
			throwError("[FileStream::flush] - Flush failed", true);
		}
	}
}

int64_t FileStream::read(void* buffer, uint64_t size, uint64_t nmemb)
{
	if (!caching) {
		const int64_t res = PHYSFS_readBytes(getPhysfsFile(), buffer, size * nmemb);
		if (res == -1) {
			throwError("[FileStream::read] - Read failed", true);
		}
		return res;
	}
	int64_t writePos = 0;
	auto* const outBuffer = static_cast<uint8_t*>(buffer);
	for (uint64_t i = 0; i < nmemb; ++i) {
		if (seekPosition + size > dataBuffer.size()) {
			return i;
		}

		for (uint64_t j = 0; j < size; ++j) {
			outBuffer[writePos++] = dataBuffer[seekPosition++];
		}
	}
	return nmemb;
}

void FileStream::write(const void* buffer, uint64_t count)
{
	if (!caching) {
		if (PHYSFS_writeBytes(getPhysfsFile(), buffer, count) != count) {
			throwError("[FileStream::write] - Write failed", true);
		}
	} else {
		dataBuffer.grow(seekPosition + count);
		memcpy(&dataBuffer[seekPosition], buffer, count);
		seekPosition += count;
	}
}

void FileStream::seek(uint64_t pos)
{
	if (!caching) {
		if (!PHYSFS_seek(getPhysfsFile(), pos)) {
			throwError("[FileStream::seek] (1) - Seek failed", true);
		}
	} else {
		if (pos > dataBuffer.size()) {
			throwError("[FileStream::seek] (2) - Seek failed");
		}
		seekPosition = pos;
	}
}

void FileStream::skip(uint64_t len)
{
	seek(tell() + len);
}

uint64_t FileStream::size()
{
	if (!caching) {
		return PHYSFS_fileLength(getPhysfsFile());
	}
	return dataBuffer.size();
}

uint64_t FileStream::tell()
{
	if (!caching) {
		return PHYSFS_tell(getPhysfsFile());
	}
	return seekPosition;
}

bool FileStream::eof()
{
	if (!caching) {
		return PHYSFS_eof(getPhysfsFile());
	}
	return seekPosition >= dataBuffer.size();
}

uint8_t FileStream::getU8()
{
	uint8_t v = 0;
	if (!caching) {
		if (PHYSFS_readBytes(getPhysfsFile(), &v, 1) != 1) {
			throwError("[FileStream::getU8] (1) - Read failed", true);
		}
	} else {
		if (seekPosition + 1 > dataBuffer.size()) {
			throwError("[FileStream::getU8] (2) - Read failed");
		}

		v = dataBuffer[seekPosition];
		seekPosition += 1;
	}
	return v;
}

uint16_t FileStream::getU16()
{
	uint16_t v = 0;
	if (!caching) {
		if (PHYSFS_readULE16(getPhysfsFile(), &v) == 0) {
			throwError("[FileStream::getU16] - Read failed", true);
		}
	}
	return v;
}

uint32_t FileStream::getU32()
{
	uint32_t v = 0;
	if (!caching) {
		if (PHYSFS_readULE32(getPhysfsFile(), &v) == 0) {
			throwError("[FileStream::getU32] - Read failed", true);
		}
	}
	return v;
}

uint64_t FileStream::getU64()
{
	uint64_t v = 0;
	if (!caching) {
		if (PHYSFS_readULE64(getPhysfsFile(), (PHYSFS_uint64*)&v) == 0) {
			throwError("[FileStream::getU64] - Read failed", true);
		}
	}
	return v;
}

int8_t FileStream::get8()
{
	int8_t v = 0;
	if (!caching) {
		if (PHYSFS_readBytes(getPhysfsFile(), &v, 1) != 1) {
			throwError("[FileStream::get8] (1) - Read failed", true);
		}
	} else {
		if (seekPosition + 1 > dataBuffer.size()) {
			throwError("[FileStream::get8] (2) - Read failed");
		}

		v = dataBuffer[seekPosition];
		seekPosition += 1;
	}
	return v;
}

int16_t FileStream::get16()
{
	int16_t v = 0;
	if (!caching) {
		if (PHYSFS_readSLE16(getPhysfsFile(), &v) == 0) {
			throwError("[FileStream::get16] (1) - Read failed", true);
		}
	} else {
		if (seekPosition + 2 > dataBuffer.size()) {
			throwError("[FileStream::get16] (2) - Read failed");
		}
		v = stdext::readSLE16(&dataBuffer[seekPosition]);
		seekPosition += 8;
	}
	return v;
}

int32_t FileStream::get32()
{
	int32_t v = 0;
	if (!caching) {
		if (PHYSFS_readSLE32(getPhysfsFile(), &v) == 0) {
			throwError("[FileStream::get32] (1) - Read failed", true);
		}
	} else {
		if (seekPosition + 4 > dataBuffer.size()) {
			throwError("[FileStream::get32] (2) - Read failed");
		}
		v = stdext::readSLE32(&dataBuffer[seekPosition]);
		seekPosition += 8;
	}
	return v;
}

int64_t FileStream::get64()
{
	int64_t v = 0;
	if (!caching) {
		if (PHYSFS_readSLE64(getPhysfsFile(), (PHYSFS_sint64*)&v) == 0) {
			throwError("[FileStream::get64] (1) - Read failed", true);
		}
	} else {
		if (seekPosition + 8 > dataBuffer.size()) {
			throwError("[FileStream::get64] (2) - Read failed");
		}
		v = stdext::readSLE64(&dataBuffer[seekPosition]);
		seekPosition += 8;
	}
	return v;
}

std::string FileStream::getString()
{
	std::string str;
	const uint16_t len = getU16();
	if (len > 0 && len < 8192) {
		char buffer[8192];
		if (isInitializedPhysfsFile()) {
			if (PHYSFS_readBytes(getPhysfsFile(), buffer, len) == 0) {
				throwError("[FileStream::getString] (1) - Read failed", true);
			}
			else {
				str = std::string(buffer, len);
			}
		} else {
			if (seekPosition + len > dataBuffer.size()) {
				throwError("[FileStream::getString] (2) - Read failed");
			}

			str = std::string((char*)&dataBuffer[seekPosition], len);
			seekPosition += len;
		}
	} else if (len != 0) {
		throwError("[FileStream::getString] - Read failed because string is too big");
	}
	return str;
}

BinaryTree* FileStream::getBinaryTree()
{
	const uint8_t byte = getU8();
	if (byte != BINARYTREE_NODE_START) {
		SPDLOG_ERROR("[FileStream::getBinaryTree] - Failed to read node start: {}", byte);
	}

	return { new BinaryTree(this) };
}

void FileStream::startNode(uint8_t n)
{
	//addU8(BINARYTREE_NODE_START);
	addU8(n);
}

void FileStream::endNode()
{
	//addU8(BINARYTREE_NODE_END);
}

void FileStream::addU8(uint8_t v)
{
	if (!caching) {
		if (PHYSFS_writeBytes(getPhysfsFile(), &v, 1) != 1) {
			throwError("[FileStream::addU8] - Write failed", true);
		}
	} else {
		dataBuffer.add(v);
		seekPosition++;
	}
}

void FileStream::addU16(uint16_t v)
{
	if (!caching) {
		if (PHYSFS_writeULE16(getPhysfsFile(), v) == 0) {
			throwError("[FileStream::addU16] - Write failed", true);
		}
	}
}

void FileStream::addU32(uint32_t v)
{
	if (!caching) {
		if (PHYSFS_writeULE32(getPhysfsFile(), v) == 0) {
			throwError("[FileStream::addU32] - Write failed", true);
		}
	}
}

void FileStream::addU64(uint64_t v)
{
	if (!caching) {
		if (PHYSFS_writeULE64(getPhysfsFile(), v) == 0) {
			throwError("[FileStream::addU64] - Write failed", true);
		}
	}
}

void FileStream::add8(int8_t v)
{
	if (!caching) {
		if (PHYSFS_writeBytes(getPhysfsFile(), &v, 1) != 1) {
			throwError("[FileStream::add8] - Write failed", true);
		}
	} else {
		dataBuffer.add(v);
		seekPosition++;
	}
}

void FileStream::add16(int16_t v)
{
	if (!caching) {
		if (PHYSFS_writeSLE16(getPhysfsFile(), v) == 0) {
			throwError("[FileStream::add16] - Write failed", true);
		}
	}
}

void FileStream::add32(int32_t v)
{
	if (!caching) {
		if (PHYSFS_writeSLE32(getPhysfsFile(), v) == 0) {
			throwError("[FileStream::add32] - Write failed", true);
		}
	}
}

void FileStream::add64(int64_t v)
{
	if (!caching) {
		if (PHYSFS_writeSLE64(getPhysfsFile(), v) == 0) {
			throwError("[FileStream::add64] - Write failed", true);
		}
	}
}

void FileStream::addString(const std::string& v)
{
	addU16(v.length());
	write(v.c_str(), v.length());
}

void FileStream::throwError(const std::string& message, bool physfsError)
{
	std::string completeMessage = fmt::format("[FileStream::throwError] - In file '%s': %s", fileName, message);
	if (physfsError) {
		completeMessage += std::string(": ") + PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode());
	}
	SPDLOG_ERROR(completeMessage);
}
