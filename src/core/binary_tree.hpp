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

#ifndef SRC_CORE_BINARY_TREE_HPP_
#define SRC_CORE_BINARY_TREE_HPP_

#include "utils/databuffer.hpp"
#include "utils/point.hpp"
#include "file_stream.hpp"

class FileStream;

enum
{
	BINARYTREE_ESCAPE_CHAR = 0xFD,
	BINARYTREE_NODE_START = 0xFE,
	BINARYTREE_NODE_END = 0xFF
};

class BinaryTree
{
public:
	BinaryTree(FileStream* fileStream);

	void seek(uint64_t pos);
	void skip(uint64_t len);
	uint64_t tell() { return seekPosition; }
	uint64_t size() { unserialize(); return buffer.size(); }

	uint8_t getU8();
	uint16_t getU16();
	uint32_t getU32();
	uint64_t getU64();
	std::string getString(uint16_t len = 0);
	Point getPoint();

	std::vector<BinaryTree*> getChildren();
	bool canRead() { unserialize(); return seekPosition < buffer.size(); }

private:
	void unserialize();
	void skipNodes();

	FileStream* binaryFileStream;
	DataBuffer<uint8_t> buffer;
	uint64_t seekPosition;
	uint64_t seekStartPos;
};

class OutputBinaryTree
{
public:
	OutputBinaryTree(FileStream* finish);

	void addU8(uint8_t v);
	void addU16(uint16_t v);
	void addU32(uint32_t v);
	void addString(const std::string& v);
	void addPos(uint16_t x, uint16_t y, uint8_t z);

	void startNode(uint8_t node);
	void endNode();

private:
	FileStream* binaryFileStream;

protected:
	void write(const uint8_t* data, size_t size);
};

#endif  // SRC_CORE_BINARY_TREE_HPP_
