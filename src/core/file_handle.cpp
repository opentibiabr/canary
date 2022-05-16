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
	if(file) {
		fclose(file);
		file = nullptr;
	}
}

std::string FileHandle::getErrorMessage()
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
	}
	if(file == nullptr) {
		return "Could not open file (2)";
	}
	if(ferror(file)) {
		return "Internal file error #" + fromIntToString(ferror(file));
	}
	return "No error";
}

//=============================================================================
// File read handle

FileReadHandle::FileReadHandle(const std::string& name) : fileSize(0)
{
#if defined __VISUALC__ && defined _UNICODE
	file = _wfopen(string2wstring(name).c_str(), L"rb");
#else
	file = fopen(name.c_str(), "rb");
#endif
	if(!file || ferror(file)) {
		setErrorCode(FILE_COULD_NOT_OPEN);
	} else {
		fseek(file, 0, SEEK_END);
		fileSize = ftell(file);
		fseek(file, 0, SEEK_SET);
	}
}

FileReadHandle::~FileReadHandle()
{
	////
}

void FileReadHandle::close()
{
	fileSize = 0;
	FileHandle::close();
}
uint8_t FileReadHandle::getU8() {
	uint8_t value;
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

uint8_t* FileReadHandle::getRawNumber(size_t sz)
{
	uint8_t* value;
	size_t o = fread(value, 1, sz, file);
	if(o != sz) {
		setErrorCode(FILE_READ_ERROR);
		return 0;
	}
	return value;
}

std::string FileReadHandle::getRawString(size_t sz)
{
	std::string string;
	string.resize(sz);
	size_t o = fread(const_cast<char*>(string.data()), 1, sz, file);
	if(o != sz) {
		setErrorCode(FILE_READ_ERROR);
		return std::string();
	}
	return string;
}

std::string FileReadHandle::getString()
{
	std::string string;
	uint16_t value;// = BinaryNode::getU16();
	if(!value) {
		setErrorCode(FILE_READ_ERROR);
		return std::string();
	}
	string = getRawString(value);
	return string;
}

std::string FileReadHandle::getLongString()
{
	std::string string;
	uint32_t value; //= BinaryNode::getU32();
	if(!value) {
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

NodeFileReadHandle::NodeFileReadHandle() :
	last_was_start(false),
	cache(nullptr),
	cache_size(32768),
	cache_length(0),
	local_read_index(0),
	root_node(nullptr)
{
	////
}

NodeFileReadHandle::~NodeFileReadHandle()
{
	while(!unused.empty()) {
		free(unused.top());
		unused.pop();
	}
}

BinaryNode* NodeFileReadHandle::getNode(BinaryNode* parent)
{
	void* mem;
	if(unused.empty()) {
		mem = malloc(sizeof(BinaryNode));
	} else {
		mem = unused.top();
		unused.pop();
	}
	return new(mem) BinaryNode(this, parent);
}

void NodeFileReadHandle::freeNode(BinaryNode* node)
{
	if(node) {
		node->~BinaryNode();
		unused.push(node);
	}
}

//=============================================================================
// Memory based node file read handle

MemoryNodeFileReadHandle::MemoryNodeFileReadHandle(const uint8_t* data, size_t size)
{
	assign(data, size);
}

void MemoryNodeFileReadHandle::assign(const uint8_t* data, size_t size)
{
	freeNode(root_node);
	root_node = nullptr;
	// Highly volatile, but we know we're not gonna modify
	cache = const_cast<uint8_t*>(data);
	cache_size = cache_length = size;
	local_read_index = 0;
}

MemoryNodeFileReadHandle::~MemoryNodeFileReadHandle()
{
	freeNode(root_node);
}

void MemoryNodeFileReadHandle::close()
{
	assign(nullptr, 0);
}

bool MemoryNodeFileReadHandle::renewCache()
{
	return false;
}

BinaryNode* MemoryNodeFileReadHandle::getRootNode()
{
	assert(root_node == nullptr); // You should never do this twice

	local_read_index++; // Skip first NODE_START
	last_was_start = true;
	root_node = getNode(nullptr);
	root_node->load();
	return root_node;
}

//=============================================================================
// File based node file read handle

DiskNodeFileReadHandle::DiskNodeFileReadHandle(const std::string& name, const std::vector<std::string>& acceptable_identifiers) :
	fileSize(0)
{
#if defined __VISUALC__ && defined _UNICODE
	file = _wfopen(string2wstring(name).c_str(), L"rb");
#else
	file = fopen(name.c_str(), "rb");
#endif
	if(!file || ferror(file)) {
		setErrorCode(FILE_COULD_NOT_OPEN);
	} else {
		char ver[4];
		if(fread(ver, 1, 4, file) != 4) {
			fclose(file);
			setErrorCode(FILE_SYNTAX_ERROR);
			return;
		}

		// 0x00 00 00 00 is accepted as a wildcard version

		if(ver[0] != 0 || ver[1] != 0 || ver[2] != 0 || ver[3] != 0) {
			bool accepted = false;
			for(std::vector<std::string>::const_iterator id_iter = acceptable_identifiers.begin(); id_iter != acceptable_identifiers.end(); ++id_iter) {
				if(memcmp(ver, id_iter->c_str(), 4) == 0) {
					accepted = true;
					break;
				}
			}

			if(!accepted) {
				fclose(file);
				setErrorCode(FILE_SYNTAX_ERROR);
				return;
			}
		}

		fseek(file, 0, SEEK_END);
		fileSize = ftell(file);
		fseek(file, 4, SEEK_SET);
	}
}

DiskNodeFileReadHandle::~DiskNodeFileReadHandle()
{
	close();
}

void DiskNodeFileReadHandle::close()
{
	freeNode(root_node);
	fileSize = 0;
	FileHandle::close();
	free(cache);
}

bool DiskNodeFileReadHandle::renewCache()
{
	if(!cache) {
		cache = (uint8_t*)malloc(cache_size);
	}
	cache_length = fread(cache, 1, cache_size, file);

	if(cache_length == 0 || ferror(file)) {
		return false;
	}
	local_read_index = 0;
	return true;
}

BinaryNode* DiskNodeFileReadHandle::getRootNode()
{
	assert(root_node == nullptr); // You should never do this twice
	uint8_t first;
	fread(&first, 1, 1, file);
	if(first == NODE_START) {
		root_node = getNode(nullptr);
		root_node->load();
		return root_node;
	} else {
		setErrorCode(FILE_SYNTAX_ERROR);
		return nullptr;
	}
}

//=============================================================================
// Binary file node
uint8_t BinaryNode::getU8() {
	uint8_t value = 0;
	if(readOffsetSize + 1 > stringData.size()) {
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
	if(readOffsetSize + 2 > stringData.size()) {
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
	if(readOffsetSize + 4 > stringData.size()) {
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
	if(readOffsetSize + 8 > stringData.size()) {
		readOffsetSize = stringData.size();
		SPDLOG_ERROR("[BinaryNode::getU64] - Failed to read value", value);
		return value;
	}
	value = *(uint64_t*)(stringData.data() + readOffsetSize);

	readOffsetSize += 8;
	return value;
}

BinaryNode::BinaryNode(NodeFileReadHandle* file, BinaryNode* parent) :
	readOffsetSize(0),
	file(file),
	parent(parent),
	child(nullptr)
{
	////
}

BinaryNode::~BinaryNode()
{
	file->freeNode(child);
}

BinaryNode* BinaryNode::getChild()
{
	assert(file);
	assert(child == nullptr);

	if(file->last_was_start) {
		child = file->getNode(this);
		child->load();
		return child;
	}
	return nullptr;
}

uint8_t* BinaryNode::getRawNumber(size_t size)
{
	uint8_t* uintSize;
	if(readOffsetSize + size > stringData.size()) {
		readOffsetSize = stringData.size();
		return 0;
	}
	memcpy(uintSize, stringData.data() + readOffsetSize, size);
	readOffsetSize += size;
	return uintSize;
}

std::string BinaryNode::getRawString(size_t size)
{
	std::string string;
	if(readOffsetSize + size > stringData.size()) {
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
	if(!value) {
		return std::string();
	}

	string = getRawString(value);
	return string;
}

std::string BinaryNode::getLongString()
{
	std::string string;
	uint32_t value = BinaryNode::getU32();
	if(!value) {
		return std::string();
	}
	string = getRawString(value);
	return string;
}

BinaryNode* BinaryNode::advance()
{
	// Advance this to the next position
	assert(file);

	if(file->errorCode != FILE_NO_ERROR)
		return nullptr;

	if(child == nullptr) {
		getChild();
	}
	// We need to move the cursor to the next node, since we're still iterating our child node!
	while(child) {
		// both functions modify ourselves and sets child to nullptr, so loop will be aborted
		// possibly change to assignment ?
		child->getChild();
		child->advance();
	}

	if(file->last_was_start) {
		return nullptr;
	} else {
		// Last was end (0xff)
		// Read next byte to decide if there is another node following this
		uint8_t*& cache = file->cache;
		size_t& cache_length = file->cache_length;
		size_t& local_read_index = file->local_read_index;

		if(local_read_index >= cache_length) {
			if(!file->renewCache()) {
				// Failed to renew, exit
				parent->child = nullptr;
				file->freeNode(this);
				return nullptr;
			}
		}

		uint8_t op = cache[local_read_index];
		++local_read_index;

		if(op == NODE_START) {
			// Another node follows this.
			// Load this node as the next one
			readOffsetSize = 0;
			stringData.clear();
			load();
			return this;
		} else if(op == NODE_END) {
			// End of this child-tree
			parent->child = nullptr;
			file->last_was_start = false;
			file->freeNode(this);
			return nullptr;
		} else {
			file->setErrorCode(FILE_SYNTAX_ERROR);
			return nullptr;
		}
	}
}

void BinaryNode::load()
{
	assert(file);
	// Read until next node starts
	uint8_t*& cache = file->cache;
	size_t& cache_length = file->cache_length;
	size_t& local_read_index = file->local_read_index;
	while(true) {
		if(local_read_index >= cache_length) {
			if(!file->renewCache()) {
				// Failed to renew, exit
				file->setErrorCode(FILE_PREMATURE_END);
				return;
			}
		}

		uint8_t op = cache[local_read_index];
		++local_read_index;

		switch(op) {
			case NODE_START: {
				file->last_was_start = true;
				return;
			}

			case NODE_END: {
				file->last_was_start = false;
				return;
			}

			case ESCAPE_CHAR: {
				if(local_read_index >= cache_length) {
					if(!file->renewCache()) {
						// Failed to renew, exit
						file->setErrorCode(FILE_PREMATURE_END);
						return;
					}
				}

				op = cache[local_read_index];
				++local_read_index;
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

FileWriteHandle::FileWriteHandle(const std::string& name)
{
#if defined __VISUALC__ && defined _UNICODE
	file = _wfopen(string2wstring(name).c_str(), L"wb");
#else
	file = fopen(name.c_str(), "wb");
#endif
	if(file == nullptr || ferror(file)) {
		setErrorCode(FILE_COULD_NOT_OPEN);
	}
}

FileWriteHandle::~FileWriteHandle()
{
	////
}

bool FileWriteHandle::addString(const std::string& str)
{
	if(str.size() > 0xFFFF) {
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
	if(len > 0xFFFF) {
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

bool FileWriteHandle::addRAW(const uint8_t* ptr, size_t sz)
{
	fwrite(ptr, 1, sz, file);
	return ferror(file) == 0;
}

//=============================================================================
// Disk based node file write handle

DiskNodeFileWriteHandle::DiskNodeFileWriteHandle(const std::string& name, const std::string& identifier)
{
#if defined __VISUALC__ && defined _UNICODE
	file = _wfopen(string2wstring(name).c_str(), L"wb");
#else
	file = fopen(name.c_str(), "wb");
#endif
	if(!file || ferror(file)) {
		setErrorCode(FILE_COULD_NOT_OPEN);
		return;
	}
	if(identifier.length() != 4) {
		setErrorCode(FILE_INVALID_IDENTIFIER);
		return;
	}

	fwrite(identifier.c_str(), 1, 4, file);
	if(!cache) {
		cache = (uint8_t*)malloc(cache_size+1);
	}
	local_write_index = 0;
}

DiskNodeFileWriteHandle::~DiskNodeFileWriteHandle()
{
	close();
}

void DiskNodeFileWriteHandle::close()
{
	if(file) {
		renewCache();
		fclose(file);
		file = nullptr;
		setErrorCode(FILE_NO_ERROR);
	}
}

void DiskNodeFileWriteHandle::renewCache()
{
	if(cache) {
		fwrite(cache, local_write_index, 1, file);
		if(ferror(file) != 0) {
			setErrorCode(FILE_WRITE_ERROR);
		}
	} else {
		cache = (uint8_t*)malloc(cache_size+1);
	}
	local_write_index = 0;
}

//=============================================================================
// Memory based node file write handle

MemoryNodeFileWriteHandle::MemoryNodeFileWriteHandle()
{
	if(!cache) {
		cache = (uint8_t*)malloc(cache_size+1);
	}
	local_write_index = 0;
}

MemoryNodeFileWriteHandle::~MemoryNodeFileWriteHandle()
{
	close();
}

void MemoryNodeFileWriteHandle::reset()
{
	memset(cache, 0xAA, cache_size);
	local_write_index = 0;
}

void MemoryNodeFileWriteHandle::close()
{
	free(cache);
	cache = nullptr;
}

uint8_t* MemoryNodeFileWriteHandle::getMemory()
{
	return cache;
}

size_t MemoryNodeFileWriteHandle::getSize()
{
	return local_write_index;
}

void MemoryNodeFileWriteHandle::renewCache()
{
	if(cache) {
		cache_size = cache_size * 2;
		cache = (uint8_t*)realloc(cache, cache_size);
		if(!cache) {
			exit(1);
		}
	} else {
		cache = (uint8_t*)malloc(cache_size+1);
	}
}

//=============================================================================
// Node file write handle

NodeFileWriteHandle::NodeFileWriteHandle() :
	cache(nullptr),
	cache_size(0x7FFF),
	local_write_index(0)
{
	////
}

NodeFileWriteHandle::~NodeFileWriteHandle()
{
	free(cache);
}

bool NodeFileWriteHandle::addNode(uint8_t nodetype)
{
	cache[local_write_index++] = NODE_START;
	if(local_write_index >= cache_size) {
		renewCache();
	}

	cache[local_write_index++] = nodetype;
	if(local_write_index >= cache_size) {
		renewCache();
	}

	return errorCode == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::endNode()
{
	cache[local_write_index++] = NODE_END;
	if(local_write_index >= cache_size) {
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

bool NodeFileWriteHandle::addString(const std::string& str)
{
	if(str.size() > 0xFFFF) {
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
