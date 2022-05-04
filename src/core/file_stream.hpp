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

#ifndef SRC_CORE_FILESTREAM_HPP
#define SRC_CORE_FILESTREAM_HPP

#include "resource_manager.hpp"
#include "binary_tree.hpp"
#include "utils/databuffer.hpp"

struct PHYSFS_File;

class BinaryTree;

class FileStream
{
public:
	FileStream(std::string newFileName, PHYSFS_File* newFileHandle, bool newWriteable);
	FileStream(std::string newFileName, const std::string& newuffer);

	void cache();
	void close();
	void flush();
	void write(const void* buffer, uint64_t count);
	int64_t read(void* buffer, uint64_t size, uint64_t nmemb = 1);
	void seek(uint64_t pos);
	void skip(uint64_t len);
	uint64_t size();
	uint64_t tell();
	bool eof();
	std::string name() { return fileName; }

	uint8_t getU8();
	uint16_t getU16();
	uint32_t getU32();
	uint64_t getU64();
	int8_t get8();
	int16_t get16();
	int32_t get32();
	int64_t get64();
	std::string getString();
	BinaryTree* getBinaryTree();

	void startNode(uint8_t n);
	void endNode();
	void addU8(uint8_t v);
	void addU16(uint16_t v);
	void addU32(uint32_t v);
	void addU64(uint64_t v);
	void add8(int8_t v);
	void add16(int16_t v);
	void add32(int32_t v);
	void add64(int64_t v);
	void addString(const std::string& v);
	void addPosition(uint16_t x, uint16_t y, uint8_t z) { addU16(x); addU16(y); addU8(z); }

	PHYSFS_File* getPhysfsFile() {
		return physfsFile;
	}
	void setPhysfsFile(PHYSFS_File* newFile) {
		physfsFile = newFile;
	}
	bool isInitializedPhysfsFile() {
		if (physfsFile) {
			return true;
		}
		return false;
	}

	DataBuffer<uint8_t> dataBuffer;

private:
	void checkWrite();
	void throwError(const std::string& message, bool physfsError = false);

	std::string fileName;
	PHYSFS_File* physfsFile;
	uint64_t seekPosition;
	bool writeable;
	bool caching;
};

#endif  // SRC_CORE_FILESTREAM_HPP
