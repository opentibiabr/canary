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

#include "binary_tree.hpp"
#include "utils/math.hpp"

BinaryTree::BinaryTree(FileStream* fileStream) :
	binaryFileStream(std::move(fileStream)), seekPosition(0xFFFFFFFF)
{
	seekStartPos = fileStream->tell();
}

void BinaryTree::skipNodes()
{
	while (true) {
		const uint8_t byte = binaryFileStream->getU8();
		switch (byte) {
			case BINARYTREE_NODE_START:
			{
				skipNodes();
				break;
			}
			case BINARYTREE_NODE_END:
			{
				return;
			}
			case BINARYTREE_ESCAPE_CHAR:
			{
				binaryFileStream->getU8();
				break;
			}
			default:
				break;
		}
	}
}

void BinaryTree::unserialize()
{
	if (seekPosition != 0xFFFFFFFF) {
		return;
	}
	seekPosition = 0;

	binaryFileStream->seek(seekStartPos);
	while (true) {
		uint8_t byte = binaryFileStream->getU8();
		switch (byte) {
			case BINARYTREE_NODE_START:
			{
				skipNodes();
				break;
			}
			case BINARYTREE_NODE_END:
			{
				return;
			}
			case BINARYTREE_ESCAPE_CHAR:
			{
				buffer.add(binaryFileStream->getU8());
				break;
			}
			default:
				buffer.add(byte);
				break;
		}
	}
}

std::vector<BinaryTree*> BinaryTree::getChildren()
{
	std::vector<BinaryTree*> children;
	binaryFileStream->seek(seekStartPos);
	while (true) {
		const uint8_t byte = binaryFileStream->getU8();
		switch (byte) {
			case BINARYTREE_NODE_START:
			{
				BinaryTree* binaryTree(new BinaryTree(binaryFileStream));
				children.push_back(binaryTree);
				binaryTree->skipNodes();
				break;
			}
			case BINARYTREE_NODE_END:
			{
				return children;
			}
			case BINARYTREE_ESCAPE_CHAR:
			{
				binaryFileStream->getU8();
				break;
			}
			default:
				break;
		}
	}
}

void BinaryTree::seek(uint64_t position)
{
	unserialize();
	if (position > buffer.size()) {
		SPDLOG_ERROR("[BinaryTree::seek] - Seek failed");
	}
	seekPosition = position;
}

void BinaryTree::skip(uint64_t len)
{
	unserialize();
	seek(tell() + len);
}

uint8_t BinaryTree::getU8()
{
	unserialize();
	if (seekPosition + 1 > buffer.size()) {
		SPDLOG_ERROR("[BinaryTree::getU8] - getU8 failed");
	}
	const uint8_t v = buffer[seekPosition];
	seekPosition += 1;
	return v;
}

uint16_t BinaryTree::getU16()
{
	unserialize();
	if (seekPosition + 2 > buffer.size()) {
		SPDLOG_ERROR("[BinaryTree::getU16] - getU16 failed");
	}
	const uint16_t v = stdext::readULE16(&buffer[seekPosition]);
	seekPosition += 2;
	return v;
}

uint32_t BinaryTree::getU32()
{
	unserialize();
	if (seekPosition + 4 > buffer.size()) {
		SPDLOG_ERROR("[BinaryTree::getU32] - getU32 failed");
	}
	uint32_t v = stdext::readULE32(&buffer[seekPosition]);
	seekPosition += 4;
	return v;
}

uint64_t BinaryTree::getU64()
{
	unserialize();
	if (seekPosition + 8 > buffer.size()) {
		SPDLOG_ERROR("[BinaryTree::getU64] - getU64 failed");
	}
	uint64_t v = stdext::readULE64(&buffer[seekPosition]);
	seekPosition += 8;
	return v;
}

std::string BinaryTree::getString(uint16_t len)
{
	unserialize();
	if (len == 0) {
		len = getU16();
	}

	if (seekPosition + len > buffer.size()) {
		SPDLOG_ERROR("[BinaryTree::getSTring] - String length exceeded buffer size");
	}

	std::string string((char*)&buffer[seekPosition], len);
	seekPosition += len;
	return string;
}

Point BinaryTree::getPoint()
{
	Point point;
	point.x = getU8();
	point.y = getU8();
	return point;
}

OutputBinaryTree::OutputBinaryTree(FileStream* fileStream)
	: binaryFileStream(std::move(fileStream))
{
	startNode(0);
}

void OutputBinaryTree::addU8(uint8_t v)
{
	write(&v, 1);
}

void OutputBinaryTree::addU16(uint16_t v)
{
	uint8_t data[2];
	stdext::writeULE16(data, v);
	write(data, 2);
}

void OutputBinaryTree::addU32(uint32_t v)
{
	uint8_t data[4];
	stdext::writeULE32(data, v);
	write(data, 4);
}

void OutputBinaryTree::addString(const std::string & v)
{
	if (v.size() > 0xFFFF) {
		SPDLOG_ERROR("[OutputBinaryTree::addString] - Too long string");
	}

	addU16(v.length());
	write((const uint8_t*)v.c_str(), v.length());
}

void OutputBinaryTree::addPos(uint16_t x, uint16_t y, uint8_t z)
{
	addU16(x);
	addU16(y);
	addU8(z);
}

void OutputBinaryTree::startNode(uint8_t node)
{
	binaryFileStream->addU8(BINARYTREE_NODE_START);
	write(&node, 1);
}

void OutputBinaryTree::endNode()
{
	binaryFileStream->addU8(BINARYTREE_NODE_END);
}

void OutputBinaryTree::write(const uint8_t * data, size_t size)
{
	for (size_t i = 0; i < size; ++i) {
		if (data[i] == BINARYTREE_NODE_START || data[i] == BINARYTREE_NODE_END || data[i] == BINARYTREE_ESCAPE_CHAR) {
			binaryFileStream->addU8(BINARYTREE_ESCAPE_CHAR);
		}
		binaryFileStream->addU8(data[i]);
	}
}
