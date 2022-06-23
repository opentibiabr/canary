/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "otpch.h"

#include "file_handle.hpp"
#include "utils/tools.h"

#include <stdio.h>
#include <assert.h>

uint8_t NodeFileWriteHandle::NODE_START = ::NODE_START;
uint8_t NodeFileWriteHandle::NODE_END = ::NODE_END;
uint8_t NodeFileWriteHandle::ESCAPE_CHAR = ::ESCAPE_CHAR;

FileHandle::FileHandle() = default;

FileHandle::~FileHandle() = default;

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

/*
 ==============================
 * Class FileReadHandle
  ==============================
*/

FileReadHandle::FileReadHandle(const std::string& initName) : fileName(initName)
{
#if defined __VISUALC__ && defined _UNICODE
	setFile(_wfopen(string2wstring(initName).c_str(), L"rb"));
#else
	setFile(fopen(initName.c_str(), "rb"));
#endif
	if (getFile() == nullptr || ferror(getFile())) {
		setErrorCode(FILE_COULD_NOT_OPEN);
	} else {
		fseek(getFile(), 0, SEEK_END);
		fileSize = ftell(getFile());
		fseek(getFile(), 0, SEEK_SET);
	}
}

FileReadHandle::~FileReadHandle() = default;

uint8_t FileReadHandle::getU8() const
{
	uint8_t value = 0;
	if (ferror(getFile()) != 0) {
		return 0;
	}

	
	if (auto size = fread(&value, 1, 1, getFile());
	size != 0)
	{
		return value;
	}

	return 0;
}

uint16_t FileReadHandle::getU16() const
{
	uint16_t value;
	if (ferror(getFile()) != 0) {
		return 0;
	}

	if (auto size = fread(&value, 2, 1, getFile());
	size != 0)
	{
		return value;
	}

	return 0;
}

uint32_t FileReadHandle::getU32() const
{
	uint32_t value;
	if (ferror(getFile()) != 0) {
		return 0;
	}

	if (auto size = fread(&value, 4, 1, getFile());
	size != 0)
	{
		return value;
	}

	return 0;
}

uint64_t FileReadHandle::getU64() const
{
	uint64_t value;
	if (ferror(getFile()) != 0) {
		return 0;
	}

	if (auto size = fread(&value, 8, 1, getFile());
	size != 0)
	{
		return value;
	}

	return 0;
}

int8_t FileReadHandle::get8() const
{
	int8_t value;
	if (ferror(getFile()) != 0) {
		return 0;
	}

	if (auto size = fread(&value, 1, 1, getFile());
	size != 0)
	{
		return value;
	}

	return 0;
}

int32_t FileReadHandle::get32() const
{
	uint32_t value;
	if (ferror(getFile()) != 0) {
		return 0;
	}

	if (auto size = fread(&value, 4, 1, getFile());
	size != 0)
	{
		return value;
	}

	return 0;
}

std::string FileReadHandle::getRawString(size_t size)
{
	std::string string;
	string.resize(size);
	if (size_t o = fread(string.data(), 1, size, getFile());
	o != size)
	{
		setErrorCode(FILE_READ_ERROR);
		return std::string();
	}
	return string;
}

std::string FileReadHandle::getString()
{
	std::string string;
	BinaryNode binaryNode;
	const uint16_t value = binaryNode.getU16();
	if (value == 0) {
		setErrorCode(FILE_READ_ERROR);
		return std::string();
	}
	string = getRawString(value);
	return string;
}

std::string FileReadHandle::getLongString()
{
	std::string string;
	BinaryNode binaryNode;
	const uint32_t value = binaryNode.getU32();
	if (value == 0) {
		setErrorCode(FILE_READ_ERROR);
		return std::string();
	}
	string = getRawString(value);
	return string;
}

bool FileReadHandle::seek(size_t offset) const
{
	return fseek(getFile(), long(offset), SEEK_SET) == 0;
}

bool FileReadHandle::seekRelative(size_t offset) const
{
	return fseek(getFile(), long(offset), SEEK_CUR) == 0;
}

/*
 ==============================
 * Class NodeFileReadhandle
  ==============================
*/

NodeFileReadHandle::NodeFileReadHandle() = default;

NodeFileReadHandle::~NodeFileReadHandle() = default;

std::shared_ptr<BinaryNode> NodeFileReadHandle::getNode(std::shared_ptr<BinaryNode> parent)
{
	auto newNode = std::make_shared<BinaryNode>();
	newNode->init(this, parent);
	return newNode;
}

/*
 ==============================
 * Class MemoryNodeFileReadHandle
  ==============================
*/

MemoryNodeFileReadHandle::MemoryNodeFileReadHandle(uint8_t* initData, size_t initSize)
{
	assign(initData, initSize);
}

MemoryNodeFileReadHandle::~MemoryNodeFileReadHandle() = default;

void MemoryNodeFileReadHandle::assign(uint8_t* data, size_t size)
{
	binaryRootNode.reset();
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

/*
 ==============================
 * Class DiskNodeFileReadHandle
  ==============================
*/

DiskNodeFileReadHandle::DiskNodeFileReadHandle(const std::string& initName, const std::vector<std::string>& initAcceptableIdentifiers) : fileName(initName), fileAcceptableIdentifiers(initAcceptableIdentifiers)
{
#if defined __VISUALC__ && defined _UNICODE
	setFile(_wfopen(string2wstring(initName).c_str(), L"rb"));
#else
	setFile(fopen(initName.c_str(), "rb"));
#endif
	if (getFile() == nullptr || ferror(getFile())) {
		setErrorCode(FILE_COULD_NOT_OPEN);
		return;
	}

	std::string identifier;
	if (fread(identifier.data(), 1, 4, getFile()) != 4) {
		fclose(getFile());
		setErrorCode(FILE_SYNTAX_ERROR);
		return;
	}

	// 0x00 00 00 00 is accepted as a wildcard version
	if (identifier[0] != 0 || identifier[1] != 0 || identifier[2] != 0 || identifier[3] != 0) {
		bool accepted = false;
		for (const auto &fileIdentifiers : fileAcceptableIdentifiers)
		{
			if (memcmp(identifier.data(), fileIdentifiers.c_str(), 4) == 0) {
				accepted = true;
				break;
			}
		}

		if (!accepted) {
			fclose(getFile());
			setErrorCode(FILE_SYNTAX_ERROR);
			return;
		}
	}

	fseek(getFile(), 0, SEEK_END);
	fileSize = ftell(getFile());
	fseek(getFile(), 4, SEEK_SET);
}

DiskNodeFileReadHandle::~DiskNodeFileReadHandle() = default;

bool DiskNodeFileReadHandle::renewCache()
{
	if (!cache) {
		createUniquePtr(std::make_unique<uint8_t[]>(cacheSize));
		cache = getCachePtr().get();
	}
	cacheLenght = fread(cache, 1, cacheSize, getFile());

	if (cacheLenght == 0 || ferror(getFile())) {
		return false;
	}
	localReadIndex = 0;
	return true;
}

std::shared_ptr<BinaryNode> DiskNodeFileReadHandle::getRootNode()
{
	assert(binaryRootNode == nullptr); // You should never do this twice
	uint8_t first;
	if (auto size = fread(&first, 1, 1, getFile());
	size == 0)
	{
		SPDLOG_ERROR("[DiskNodeFileReadHandle::getRootNode] - Size is 0");
		return nullptr;
	}

	if (first == NODE_START) {
		binaryRootNode = getNode(nullptr);
		binaryRootNode->load();
		return binaryRootNode;
	} else {
		setErrorCode(FILE_SYNTAX_ERROR);
		return nullptr;
	}
}

/*
 ==================
 * Class BinaryNode
  =================
*/

BinaryNode::BinaryNode() = default;
BinaryNode::~BinaryNode() = default;

// Get signed int
int8_t BinaryNode::get8() {
	int8_t value = 0;
	if (readOffsetSize + 1 > stringData.size()) {
		readOffsetSize = stringData.size();
		SPDLOG_ERROR("[BinaryNode::get8] - Failed to read value", value);
		return value;
	}
	value = *(int8_t*)(stringData.data() + readOffsetSize);

	readOffsetSize += 1;
	return value;
}

int16_t BinaryNode::get16() {
	int16_t value = 0;
	if (readOffsetSize + 2 > stringData.size()) {
		readOffsetSize = stringData.size();
		SPDLOG_ERROR("[BinaryNode::get16] - Failed to read value", value);
		return value;
	}
	value = *(int16_t*)(stringData.data() + readOffsetSize);

	readOffsetSize += 2;
	return value;
}

int32_t BinaryNode::get32() {
	int32_t value = 0;
	if (readOffsetSize + 4 > stringData.size()) {
		readOffsetSize = stringData.size();
		SPDLOG_ERROR("[BinaryNode::get32] - Failed to read value", value);
		return 0;
	}
	value = *(int32_t*)(stringData.data() + readOffsetSize);

	readOffsetSize += 4;
	return value;
}

int64_t BinaryNode::get64() {
	int64_t value = 0;
	if (readOffsetSize + 8 > stringData.size()) {
		readOffsetSize = stringData.size();
		SPDLOG_ERROR("[BinaryNode::get64] - Failed to read value", value);
		return value;
	}
	value = *(int64_t*)(stringData.data() + readOffsetSize);

	readOffsetSize += 8;
	return value;
}

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

double BinaryNode::getDouble() {
	double value = 0;
	if (readOffsetSize > stringData.size()) {
		readOffsetSize = stringData.size();
		SPDLOG_ERROR("[BinaryNode::getDouble] - Failed to read value", value);
		return value;
	}

	value = *(double*)(stringData.data() + readOffsetSize);
	return value;
}

bool BinaryNode::getBoolean() {
	bool booleanValue;
	if (getU8() == 0) {
		booleanValue = false;
	} else if (getU8() == 1) {
		booleanValue = true;
	} else {
		SPDLOG_ERROR("[BinaryNode::getBoolean] - Value is not a boolean");
		return false;
	}
	return booleanValue;
}

void BinaryNode::init(NodeFileReadHandle* nodeFileHeadHandle, std::shared_ptr<BinaryNode> binaryNodeParent) {
	readOffsetSize = 0;
	file = nodeFileHeadHandle;
	parent = binaryNodeParent;
	child.reset();
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

	if (file->getErrorCode() != FILE_NO_ERROR)
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
	const size_t& cacheLenght = file->cacheLenght;
	size_t& localReadIndex = file->localReadIndex;

	// Failed to renew, exit
	if (localReadIndex >= cacheLenght && !file->renewCache()) {
		parent->child.reset();
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
		parent->child.reset();
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
	const size_t& cacheLenght = file->cacheLenght;
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
		case NODE_START:
			file->lastWasStart = true;
			return;
		case NODE_END:
			file->lastWasStart = false;
			return;
		case ESCAPE_CHAR:
			// Failed to renew, exit
			if (localReadIndex >= cacheLenght && !file->renewCache()) {
				file->setErrorCode(FILE_PREMATURE_END);
				return;
			}
			op = cache[localReadIndex];
			++localReadIndex;
			break;
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
	setFile(_wfopen(string2wstring(initName).c_str(), L"wb"));
#else
	setFile(fopen(initName.c_str(), "wb"));
#endif
	if (getFile() == nullptr || ferror(getFile())) {
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
	size_t len = strnlength(str, sizeof(str));
	if (len > 0xFFFF) {
		setErrorCode(FILE_STRING_TOO_LONG);
		return false;
	}
	addU16(uint16_t(len));
	fwrite(str, 1, len, getFile());
	return true;
}

bool FileWriteHandle::addLongString(const std::string& str)
{
	addU32(uint32_t(str.size()));
	addRAW(str);
	return true;
}

bool FileWriteHandle::addRAW(const std::string& str) const
{
	fwrite(str.c_str(), 1, str.size(), getFile());
	return ferror(getFile()) == 0;
}

bool FileWriteHandle::addRAW(const uint8_t* ptr, size_t byte) const
{
	fwrite(ptr, 1, byte, getFile());
	return ferror(getFile()) == 0;
}

bool FileWriteHandle::addRAW(const char* str)
{
	size_t size = strnlength(str, sizeof(str));
	if (size == 0) {
		SPDLOG_ERROR("[FileWriteHandle::addRAW] - Size is 0");
		return false;
	}

	return addRAW(std::bit_cast<const uint8_t*>(str), size);
}

//=============================================================================
// Disk based node file write handle

DiskNodeFileWriteHandle::DiskNodeFileWriteHandle(const std::string& initName, const std::string& initIdentifier)
{
#if defined __VISUALC__ && defined _UNICODE
	setFile(_wfopen(string2wstring(initName).c_str(), L"wb"));
#else
	setFile(fopen(initName.c_str(), "wb"));
#endif
	if (getFile() == nullptr || ferror(getFile())) {
		setErrorCode(FILE_COULD_NOT_OPEN);
		return;
	}
	if (initIdentifier.length() != 4) {
		setErrorCode(FILE_INVALID_IDENTIFIER);
		return;
	}

	fwrite(initIdentifier.c_str(), 1, 4, getFile());
	if (!cache) {
		createUniquePtr(std::make_unique<uint8_t[]>(cacheSize + 1));
		cache = getCachePtr().get();
	}
	localWriteIndex = 0;
}

DiskNodeFileWriteHandle::~DiskNodeFileWriteHandle() = default;

void DiskNodeFileWriteHandle::renewCache()
{
	if (cache) {
		fwrite(cache, localWriteIndex, 1, getFile());
		if (ferror(getFile()) != 0) {
			setErrorCode(FILE_WRITE_ERROR);
		}
	} else {
		createUniquePtr(std::make_unique<uint8_t[]>(cacheSize + 1));
		cache = getCachePtr().get();
	}
	localWriteIndex = 0;
}

//=============================================================================
// Memory based node file write handle

MemoryNodeFileWriteHandle::MemoryNodeFileWriteHandle()
{
	if (!cache) {
		createUniquePtr(std::make_unique<uint8_t[]>(cacheSize + 1));
		cache = getCachePtr().get();
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
		createUniquePtr(std::make_unique<uint8_t[]>(cacheSize));
		cache = getCachePtr().get();
		if (!cache) {
			exit(1);
		}
	} else {
		createUniquePtr(std::make_unique<uint8_t[]>(cacheSize + 1));
		cache = getCachePtr().get();
	}
}

//=============================================================================
// Node file write handle

NodeFileWriteHandle::NodeFileWriteHandle() = default;

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

	return getErrorCode() == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::endNode()
{
	cache[localWriteIndex++] = NODE_END;
	if (localWriteIndex >= cacheSize) {
		renewCache();
	}

	return getErrorCode() == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addU8(uint8_t u8)
{
	writeBytes(&u8, sizeof(u8));
	return getErrorCode() == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addByte(uint8_t u8)
{
	writeBytes(&u8, sizeof(u8));
	return getErrorCode() == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addU16(uint16_t u16)
{
	writeBytes(std::bit_cast<uint8_t*>(&u16), sizeof(u16));
	return getErrorCode() == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addU32(uint32_t u32)
{
	writeBytes(std::bit_cast<uint8_t*>(&u32), sizeof(u32));
	return getErrorCode() == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addU64(uint64_t u64)
{
	writeBytes(std::bit_cast<uint8_t*>(&u64), sizeof(u64));
	return getErrorCode() == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addInt8(int8_t int8)
{
	writeBytes(std::bit_cast<uint8_t*>(&int8), sizeof(int8));
	return getErrorCode() == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addInt16(int16_t int16)
{
	writeBytes(std::bit_cast<uint8_t*>(&int16), sizeof(int16));
	return getErrorCode() == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addInt32(int32_t int32)
{
	writeBytes(std::bit_cast<uint8_t*>(&int32), sizeof(int32));
	return getErrorCode() == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addInt64(int64_t int64)
{
	writeBytes(std::bit_cast<uint8_t*>(&int64), sizeof(int64));
	return getErrorCode() == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addString(const std::string& str)
{
	if (str.size() > 0xFFFF) {
		setErrorCode(FILE_STRING_TOO_LONG);
		return false;
	}
	addU16(uint16_t(str.size()));
	addRAW((const uint8_t*)str.c_str(), str.size());
	return getErrorCode() == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addLongString(const std::string& str)
{
	addU32(uint32_t(str.size()));
	addRAW((const uint8_t*)str.c_str(), str.size());
	return getErrorCode() == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addRAW(std::string& str)
{
	writeBytes(std::bit_cast<uint8_t*>(str.data()), str.size());
	return getErrorCode() == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addRAW(const uint8_t* ptr, size_t size)
{
	writeBytes(ptr, size);
	return getErrorCode() == FILE_NO_ERROR;
}

bool NodeFileWriteHandle::addRAW(const char* str)
{
	size_t size = strnlength(str, sizeof(str));
	if (size == 0) {
		SPDLOG_ERROR("[NodeFileWriteHandle::addRAW] - Size is 0");
		return false;
	}

	return addRAW(std::bit_cast<const uint8_t*>(str), size);
}
