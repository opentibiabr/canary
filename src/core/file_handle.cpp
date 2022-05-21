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

#include "file_handle.hpp"
#include "utils/tools.h"

#include <stdio.h>
#include <assert.h>

uint8_t NodeFileWriteHandle::NODE_START = ::NODE_START;
uint8_t NodeFileWriteHandle::NODE_END = ::NODE_END;
uint8_t NodeFileWriteHandle::ESCAPE_CHAR = ::ESCAPE_CHAR;

void FileHandle::close()
{
	if (file) {
		fclose(file);
		file = nullptr;
	}
}

std::string FileHandle::getErrorMessage() const
{
	switch(errorCode) {
		case FILE_NO_ERROR: return "No error";
		case FILE_COULD_NOT_OPEN: return "Could not open file";
		case FILE_INVALID_IDENTIFIER: return "File magic number not recognized";
		case FILE_STRING_TOO_LONG: return "Too long string encountered";
		case FILE_READ_ERROR: return "Failed to read from file";
		case FILE_WRITE_ERROR: return "Failed to write to file";
		case FILE_SYNTAX_ERROR: return "Node file syntax error";
		case FILE_PREMATURE_END: return "File end encountered unexpectedly";
		default: return "Unknown error";
	}
}

//=============================================================================
// File read handle

FileReadHandle::FileReadHandle(const std::string& initName) : fileName(initName)
{
#if defined __VISUALC__ && defined _UNICODE
	file = _wfopen(string2wstring(initName).c_str(), L"rb");
#else
	file = fopen(initName.c_str(), "rb");
#endif
	if (!file || ferror(file)) {
		setErrorCode(FILE_COULD_NOT_OPEN);
	} else {
		fseek(file, 0, SEEK_END);
		fileSize = ftell(file);
		fseek(file, 0, SEEK_SET);
	}
}

FileReadHandle::~FileReadHandle() = default;

uint8_t FileReadHandle::getU8() {
	uint8_t value = 0;
	if (ferror(file) != 0) {
		return 0;
	}

	fread(&value, 1, 1, file);
	return value;
}

uint16_t FileReadHandle::getU16() {
	uint16_t value;
	if (ferror(file) != 0) {
		return 0;
	}

	fread(&value, 2, 1, file);
	return value;
}

uint32_t FileReadHandle::getU32() {
	uint32_t value;
	if (ferror(file) != 0) {
		return 0;
	}

	fread(&value, 4, 1, file);
	return value;
}

uint64_t FileReadHandle::getU64() {
	uint64_t value;
	if (ferror(file) != 0) {
		return 0;
	}

	fread(&value, 8, 1, file);
	return value;
}

int8_t FileReadHandle::get8() {
	int8_t value;
	if (ferror(file) != 0) {
		return 0;
	}

	fread(&value, 1, 1, file);
	return value;
}

int32_t FileReadHandle::get32() {
	uint32_t value;
	if (ferror(file) != 0) {
		return 0;
	}

	fread(&value, 4, 1, file);
	return value;
}

std::string FileReadHandle::getRawString(size_t sz)
{
	std::string string;
	string.resize(sz);
	size_t o = fread(const_cast<char*>(string.data()), 1, sz, file);
	if (o != sz) {
		setErrorCode(FILE_READ_ERROR);
		return std::string();
	}
	return string;
}

std::string FileReadHandle::getString()
{
	std::string string;
	uint16_t value = g_binaryNode.getU16();
	if (!value) {
		setErrorCode(FILE_READ_ERROR);
		return std::string();
	}
	string = getRawString(value);
	return string;
}

std::string FileReadHandle::getLongString()
{
	std::string string;
	uint32_t value = g_binaryNode.getU32();
	if (!value) {
		setErrorCode(FILE_READ_ERROR);
		return std::string();
	}
	string = getRawString(value);
	return string;
}

bool FileReadHandle::seek(size_t offset)
{
	return fseek(file, long(offset), SEEK_SET) == 0;
}

bool FileReadHandle::seekRelative(size_t offset)
{
	return fseek(file, long(offset), SEEK_CUR) == 0;
}

//=============================================================================
// Node file read handle

NodeFileReadHandle::NodeFileReadHandle()
{
	lastWasStart = false;
	cache = nullptr;
	cacheSize = 32768;
	cacheLenght = 0;
	localReadIndex = 0;
	binaryRootNode = nullptr;
}

NodeFileReadHandle::~NodeFileReadHandle() = default;

std::shared_ptr<BinaryNode> NodeFileReadHandle::getNode(std::shared_ptr<BinaryNode> parent)
{
	std::shared_ptr<BinaryNode> newNode = std::make_shared<BinaryNode>();
	newNode->init(this, parent);
	return newNode;
}

//=============================================================================
// Memory based node file read handle

MemoryNodeFileReadHandle::MemoryNodeFileReadHandle(uint8_t* initData, size_t initSize)
{
	assign(initData, initSize);
}

MemoryNodeFileReadHandle::~MemoryNodeFileReadHandle() = default;

void MemoryNodeFileReadHandle::assign(uint8_t* data, size_t size)
{
	binaryRootNode = nullptr;
	// Highly volatile, but we know we're not gonna modify
	cache = data;
	cacheSize = cacheLenght = size;
	localReadIndex = 0;
}

bool MemoryNodeFileReadHandle::renewCache()
{
	return false;
}

std::shared_ptr<BinaryNode> MemoryNodeFileReadHandle::getRootNode()
{
	assert(binaryRootNode == nullptr); // You should never do this twice

	localReadIndex++; // Skip first NODE_START
	lastWasStart = true;
	binaryRootNode = getNode(nullptr);
	binaryRootNode->load();
	return binaryRootNode;
}

//=============================================================================
// File based node file read handle

DiskNodeFileReadHandle::DiskNodeFileReadHandle(const std::string& initName, const std::vector<std::string>& initAcceptableIdentifiers) : fileName(initName), fileAcceptableIdentifiers(initAcceptableIdentifiers)
{
#if defined __VISUALC__ && defined _UNICODE
	file = _wfopen(string2wstring(initName).c_str(), L"rb");
#else
	file = fopen(initName.c_str(), "rb");
#endif
	if (!file || ferror(file)) {
		setErrorCode(FILE_COULD_NOT_OPEN);
		return;
	}

	char ver[4];
	if (fread(ver, 1, 4, file) != 4) {
		fclose(file);
		setErrorCode(FILE_SYNTAX_ERROR);
		return;
	}

	// 0x00 00 00 00 is accepted as a wildcard version
	if (ver[0] != 0 || ver[1] != 0 || ver[2] != 0 || ver[3] != 0) {
		bool accepted = false;
		for(std::vector<std::string>::const_iterator id_iter = fileAcceptableIdentifiers.begin();
		id_iter != fileAcceptableIdentifiers.end(); ++id_iter)
		{
			if (memcmp(ver, id_iter->c_str(), 4) == 0) {
				accepted = true;
				break;
			}
		}

		if (!accepted) {
			fclose(file);
			setErrorCode(FILE_SYNTAX_ERROR);
			return;
		}
	}

	fseek(file, 0, SEEK_END);
	fileSize = ftell(file);
	fseek(file, 4, SEEK_SET);
}

DiskNodeFileReadHandle::~DiskNodeFileReadHandle() = default;

bool DiskNodeFileReadHandle::renewCache()
{
	if (!cache) {
		cache = (uint8_t*)malloc(cacheSize);
	}
	cacheLenght = fread(cache, 1, cacheSize, file);

	if (cacheLenght == 0 || ferror(file)) {
		return false;
	}
	localReadIndex = 0;
	return true;
}

std::shared_ptr<BinaryNode> DiskNodeFileReadHandle::getRootNode()
{
	assert(binaryRootNode == nullptr); // You should never do this twice
	uint8_t first;
	fread(&first, 1, 1, file);
	if (first == NODE_START) {
		binaryRootNode = getNode(nullptr);
		binaryRootNode->load();
		return binaryRootNode;
	} else {
		setErrorCode(FILE_SYNTAX_ERROR);
		return nullptr;
	}
}

//=============================================================================
// Binary file node
uint8_t BinaryNode::getU8() {
	uint8_t value = 0;
	if (readOffsetSize + 1 > stringData.size()) {
		readOffsetSize = stringData.size();
		SPDLOG_ERROR("[BinaryNode::getU8] - Failed to read value", value);
		return value;
	}
	value = *(uint8_t*)(stringData.data() + readOffsetSize);

	readOffsetSize += 1;
	return value;
}

uint16_t BinaryNode::getU16() {
	uint16_t value = 0;
	if (readOffsetSize + 2 > stringData.size()) {
		readOffsetSize = stringData.size();
		SPDLOG_ERROR("[BinaryNode::getU16] - Failed to read value", value);
		return value;
	}
	value = *(uint16_t*)(stringData.data() + readOffsetSize);

	readOffsetSize += 2;
	return value;
}

uint32_t BinaryNode::getU32() {
	uint32_t value = 0;
	if (readOffsetSize + 4 > stringData.size()) {
		readOffsetSize = stringData.size();
		SPDLOG_ERROR("[BinaryNode::getU32] - Failed to read value", value);
		return 0;
	}
	value = *(uint32_t*)(stringData.data() + readOffsetSize);

	readOffsetSize += 4;
	return value;
}

uint64_t BinaryNode::getU64() {
	uint64_t value = 0;
	if (readOffsetSize + 8 > stringData.size()) {
		readOffsetSize = stringData.size();
		SPDLOG_ERROR("[BinaryNode::getU64] - Failed to read value", value);
		return value;
	}
	value = *(uint64_t*)(stringData.data() + readOffsetSize);

	readOffsetSize += 8;
	return value;
}

void BinaryNode::init(NodeFileReadHandle* nodeFileHeadHandle, std::shared_ptr<BinaryNode> binaryNodeParent) {
	readOffsetSize = 0;
	file = nodeFileHeadHandle;
	parent = binaryNodeParent;
	child = nullptr;
}

std::shared_ptr<BinaryNode> BinaryNode::getChild()
{
	assert(file);
	assert(child == nullptr);

	if (file->lastWasStart) {
		child = file->getNode(getPtr());
		child->load();
		return child;
	}
	return nullptr;
}

std::string BinaryNode::getRawString(size_t size)
{
	std::string string;
	if (readOffsetSize + size > stringData.size()) {
		readOffsetSize = stringData.size();
		return std::string();
	}
	string.assign(stringData.data() + readOffsetSize, size);
	readOffsetSize += size;
	return string;
}

std::string BinaryNode::getString()
{
	std::string string;
	uint16_t value = BinaryNode::getU16();
	if (!value) {
		return std::string();
	}

	string = getRawString(value);
	return string;
}

std::string BinaryNode::getLongString()
{
	std::string string;
	uint32_t value = BinaryNode::getU32();
	if (!value) {
		return std::string();
	}
	string = getRawString(value);
	return string;
}

std::shared_ptr<BinaryNode> BinaryNode::advance()
{
	// Advance this to the next position
	assert(file);

	if (file->errorCode != FILE_NO_ERROR)
		return nullptr;

	if (child == nullptr) {
		getChild();
	}
	// We need to move the cursor to the next node, since we're still iterating our child node!
	while(child) {
		// both functions modify ourselves and sets child to nullptr, so loop will be aborted
		// possibly change to assignment ?
		child->getChild();
		child->advance();
	}

	if (file->lastWasStart) {
		return nullptr;
	}

	// Last was end (0xff)
	// Read next byte to decide if there is another node following this
	uint8_t*& cache = file->cache;
	size_t& cacheLenght = file->cacheLenght;
	size_t& localReadIndex = file->localReadIndex;

	// Failed to renew, exit
	if (localReadIndex >= cacheLenght && !file->renewCache()) {
		parent->child = nullptr;
		return nullptr;
	}

	uint8_t op = cache[localReadIndex];
	++localReadIndex;

	if (op == NODE_START) {
		// Another node follows this.
		// Load this node as the next one
		readOffsetSize = 0;
		stringData.clear();
		load();
		return getPtr();
	} else if (op == NODE_END) {
		// End of this child-tree
		parent->child = nullptr;
		file->lastWasStart = false;
		return nullptr;
	} else {
		file->setErrorCode(FILE_SYNTAX_ERROR);
		return nullptr;
	}
}

void BinaryNode::load()
{
	assert(file);
	// Read until next node starts
	uint8_t*& cache = file->cache;
	size_t& cacheLenght = file->cacheLenght;
	size_t& localReadIndex = file->localReadIndex;
	while(true) {
		// Failed to renew, exit
		if (localReadIndex >= cacheLenght && !file->renewCache()) {
			file->setErrorCode(FILE_PREMATURE_END);
			return;
		}

		uint8_t op = cache[localReadIndex];
		++localReadIndex;

		switch(op) {
			case NODE_START: {
				file->lastWasStart = true;
				return;
			}

			case NODE_END: {
				file->lastWasStart = false;
				return;
			}

			case ESCAPE_CHAR: {
				// Failed to renew, exit
				if (localReadIndex >= cacheLenght && !file->renewCache()) {
					file->setErrorCode(FILE_PREMATURE_END);
					return;
				}

				op = cache[localReadIndex];
				++localReadIndex;
				break;
			}

			default:
				break;
		}
		SPDLOG_DEBUG("[BinaryNode::load] - Appending map data...");
		stringData.append(1, op);
	}
}

//=============================================================================
// node file binary write handle

FileWriteHandle::FileWriteHandle(const std::string& initName)
{
#if defined __VISUALC__ && defined _UNICODE
	file = _wfopen(string2wstring(initName).c_str(), L"wb");
#else
	file = fopen(initName.c_str(), "wb");
#endif
	if (file == nullptr || ferror(file)) {
		setErrorCode(FILE_COULD_NOT_OPEN);
	}
}

FileWriteHandle::~FileWriteHandle() = default;

bool FileWriteHandle::addString(const std::string& str)
{
	if (str.size() > 0xFFFF) {
		setErrorCode(FILE_STRING_TOO_LONG);
		return false;
	}
	addU16(uint16_t(str.size()));
	addRAW(str);
	return true;
}

bool FileWriteHandle::addString(const char* str)
{
	size_t len = strlen(str);
	if (len > 0xFFFF) {
		setErrorCode(FILE_STRING_TOO_LONG);
		return false;
	}
	addU16(uint16_t(len));
	fwrite(str, 1, len, file);
	return true;
}

bool FileWriteHandle::addLongString(const std::string& str)
{
	addU32(uint32_t(str.size()));
	addRAW(str);
	return true;
}

bool FileWriteHandle::addRAW(const std::string& str)
{
	fwrite(str.c_str(), 1, str.size(), file);
	return ferror(file) == 0;
}

bool FileWriteHandle::addRAW(const uint8_t* ptr, size_t byte)
{
	fwrite(ptr, 1, byte, file);
	return ferror(file) == 0;
}

//=============================================================================
// Disk based node file write handle

DiskNodeFileWriteHandle::DiskNodeFileWriteHandle(const std::string& initName, const std::string& initIdentifier)
{
#if defined __VISUALC__ && defined _UNICODE
	file = _wfopen(string2wstring(initName).c_str(), L"wb");
#else
	file = fopen(initName.c_str(), "wb");
#endif
	if (!file || ferror(file)) {
		setErrorCode(FILE_COULD_NOT_OPEN);
		return;
	}
	if (initIdentifier.length() != 4) {
		setErrorCode(FILE_INVALID_IDENTIFIER);
		return;
	}

	fwrite(initIdentifier.c_str(), 1, 4, file);
	if (!cache) {
		cache = (uint8_t*)std::malloc(cacheSize+1);
	}
	localWriteIndex = 0;
}

DiskNodeFileWriteHandle::~DiskNodeFileWriteHandle() = default;

void DiskNodeFileWriteHandle::renewCache()
{
	if (cache) {
		fwrite(cache, localWriteIndex, 1, file);
		if (ferror(file) != 0) {
			setErrorCode(FILE_WRITE_ERROR);
		}
	} else {
		cache = (uint8_t*)malloc(cacheSize+1);
	}
	localWriteIndex = 0;
}

//=============================================================================
// Memory based node file write handle

MemoryNodeFileWriteHandle::MemoryNodeFileWriteHandle()
{
	if (!cache) {
		cache = (uint8_t*)malloc(cacheSize+1);
	}
	localWriteIndex = 0;
}

MemoryNodeFileWriteHandle::~MemoryNodeFileWriteHandle() = default;

void MemoryNodeFileWriteHandle::reset()
{
	memset(cache, 0xAA, cacheSize);
	localWriteIndex = 0;
}

uint8_t* MemoryNodeFileWriteHandle::getMemory() const
{
	return cache;
}

size_t MemoryNodeFileWriteHandle::getSize() const
{
	return localWriteIndex;
}

void MemoryNodeFileWriteHandle::renewCache()
{
	if (cache) {
		cacheSize = cacheSize * 2;
		cache = (uint8_t*)realloc(cache, cacheSize);
		if (!cache) {
			exit(1);
		}
	} else {
		cache = (uint8_t*)malloc(cacheSize+1);
	}
}

//=============================================================================
// Node file write handle

NodeFileWriteHandle::NodeFileWriteHandle()
{
	cache = nullptr;
	cacheSize = 0x7FFF;
	localWriteIndex = 0;
}

NodeFileWriteHandle::~NodeFileWriteHandle() = default;

bool NodeFileWriteHandle::addNode(uint8_t nodetype)
{
	cache[localWriteIndex++] = NODE_START;
	if (localWriteIndex >= cacheSize) {
		renewCache();
	}

	cache[localWriteIndex++] = nodetype;
	if (localWriteIndex >= cacheSize) {
		renewCache();
	}

	return errorCode == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::endNode()
{
	cache[localWriteIndex++] = NODE_END;
	if (localWriteIndex >= cacheSize) {
		renewCache();
	}

	return errorCode == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addU8(uint8_t u8)
{
	writeBytes(&u8, sizeof(u8));
	return errorCode == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addByte(uint8_t u8)
{
	writeBytes(&u8, sizeof(u8));
	return errorCode == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addU16(uint16_t u16)
{
	writeBytes(reinterpret_cast<uint8_t*>(&u16), sizeof(u16));
	return errorCode == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addU32(uint32_t u32)
{
	writeBytes(reinterpret_cast<uint8_t*>(&u32), sizeof(u32));
	return errorCode == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addU64(uint64_t u64)
{
	writeBytes(reinterpret_cast<uint8_t*>(&u64), sizeof(u64));
	return errorCode == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addInt8(int8_t int8)
{
	writeBytes(reinterpret_cast<uint8_t*>(&int8), sizeof(int8));
	return errorCode == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addInt16(int16_t int16)
{
	writeBytes(reinterpret_cast<uint8_t*>(&int16), sizeof(int16));
	return errorCode == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addInt32(int32_t int32)
{
	writeBytes(reinterpret_cast<uint8_t*>(&int32), sizeof(int32));
	return errorCode == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addInt64(int64_t int64)
{
	writeBytes(reinterpret_cast<uint8_t*>(&int64), sizeof(int64));
	return errorCode == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addString(const std::string& str)
{
	if (str.size() > 0xFFFF) {
		setErrorCode(FILE_STRING_TOO_LONG);
		return false;
	}
	addU16(uint16_t(str.size()));
	addRAW((const uint8_t*)str.c_str(), str.size());
	return errorCode == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addLongString(const std::string& str)
{
	addU32(uint32_t(str.size()));
	addRAW((const uint8_t*)str.c_str(), str.size());
	return errorCode == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addRAW(std::string& str)
{
	writeBytes(reinterpret_cast<uint8_t*>(const_cast<char*>(str.data())), str.size());
	return errorCode == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addRAW(const uint8_t* ptr, size_t sz)
{
	writeBytes(ptr, sz);
	return errorCode == FILE_NO_ERROR;
}
