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

#ifndef SRC_CORE_FILEHANDLE_HPP_
#define SRC_CORE_FILEHANDLE_HPP_

#include <stdexcept>
#include <string>
#include <stack>
#include <stdio.h>

enum FileHandleError {
	FILE_NO_ERROR,
	FILE_COULD_NOT_OPEN,
	FILE_INVALID_IDENTIFIER,
	FILE_STRING_TOO_LONG,
	FILE_READ_ERROR,
	FILE_WRITE_ERROR,
	FILE_SYNTAX_ERROR,
	FILE_PREMATURE_END,
};

enum NodeType {
	NODE_START = 0xfe,
	NODE_END = 0xff,
	ESCAPE_CHAR = 0xfd,
};

class FileHandle
{
public:
	FileHandle() {
		errorCode = FILE_NO_ERROR;
		file = nullptr;
	}

	virtual ~FileHandle() = default;

	// Ensure it's not copyable
	NONCOPYABLE(FileHandle);

	void close();
	virtual bool isOpen() {
		return file != nullptr;
	}
	virtual bool isLoaded() {
		return isOpen() && errorCode == FILE_NO_ERROR && ferror(file) == 0;
	}
	void setErrorCode(FileHandleError newErrorCode) {
		errorCode = newErrorCode;
	}
	std::string getErrorMessage() const;
public:
	FileHandleError errorCode;
	FILE* file;
};

class FileReadHandle : public FileHandle
{
public:
	explicit FileReadHandle(const std::string& initName);
	~FileReadHandle() override;

	uint8_t getU8();
	uint16_t getU16();
	uint32_t getU32();
	uint64_t getU64();

	int8_t get8();
	int32_t get32();

	std::string getRawString(size_t sz);
	std::string getString();
	std::string getLongString();

	bool seek(size_t offset);
	bool seekRelative(size_t offset);
	void skip(size_t offset) {seekRelative(offset);}
	size_t size() const {
		return fileSize;
	}
	size_t tell() const {
		if(file) {
			return ftell(file);
		}
		return 0;
	}
private:
	size_t fileSize = 0;
	std::string fileName;

	template<class T>
	bool getType(T& classType) {
		fread(&classType, sizeof(classType), 1, file);
		return ferror(file) == 0;
	}
};

class NodeFileReadHandle;
class DiskNodeFileReadHandle;
class MemoryNodeFileReadHandle;

class BinaryNode : public std::enable_shared_from_this<BinaryNode>
{
public:
	BinaryNode() = default;
	~BinaryNode() = default;

	NONCOPYABLE(BinaryNode);

	std::shared_ptr<BinaryNode> getPtr() {
		if (this != nullptr) {
			return this->shared_from_this();
		}
		SPDLOG_ERROR("[BinaryNode::getPtr] - The pointer 'this' is nullptr");
		return nullptr;
	}

	void init(NodeFileReadHandle* file, std::shared_ptr<BinaryNode> parent);
	uint8_t getU8();
	uint16_t getU16();
	uint32_t getU32();
	uint64_t getU64();
	int8_t get8();
	bool skip(size_t sz) {
		if(readOffsetSize + sz > stringData.size()) {
			readOffsetSize = stringData.size();
			return false;
		}
		readOffsetSize += sz;
		return true;
	}
	std::string getRawString(size_t size);
	std::string getString();
	std::string getLongString();

	std::shared_ptr<BinaryNode> getChild();
	// Returns this on success, nullptr on failure
	std::shared_ptr<BinaryNode> advance();

	std::string getStringData() const {
		return stringData;
	}

	std::string getSize(size_t& size) const {
		size = stringData.size();
		return stringData.data();
	}

	bool canRead() const {
		return readOffsetSize < stringData.size();
	}
private:
	void load();
	std::string stringData;
	size_t readOffsetSize;
	NodeFileReadHandle* file;
	std::shared_ptr<BinaryNode> parent;
	std::shared_ptr<BinaryNode> child;

	friend class DiskNodeFileReadHandle;
	friend class MemoryNodeFileReadHandle;
};

inline BinaryNode g_binaryNode;

class NodeFileReadHandle : public FileHandle
{
public:
	NodeFileReadHandle();
	~NodeFileReadHandle() override;

	virtual std::shared_ptr<BinaryNode> getRootNode() = 0;

	virtual size_t size() = 0;
	virtual size_t tell() = 0;
private:
	std::shared_ptr<BinaryNode> getNode(std::shared_ptr<BinaryNode> parent);
	// Returns false when end-of-file is reached
	virtual bool renewCache() = 0;

	bool lastWasStart;
	uint8_t* cache;
	size_t cacheSize;
	size_t cacheLenght;
	size_t localReadIndex;

	std::shared_ptr<BinaryNode> binaryRootNode;

	friend class BinaryNode;
	friend class MemoryNodeFileReadHandle;
	friend class DiskNodeFileReadHandle;
};

class DiskNodeFileReadHandle : public NodeFileReadHandle
{
public:
	DiskNodeFileReadHandle(const std::string& initName, const std::vector<std::string>& initAcceptableIdentifiers);
	~DiskNodeFileReadHandle() override;

	std::shared_ptr<BinaryNode> getRootNode() override;

	size_t size() override {
		return fileSize;
	}
	size_t tell() override {
		if(file) {
			return ftell(file);
		}
		return 0;
	}
private:
	bool renewCache() override;

	const std::string& fileName;
	const std::vector<std::string>& fileAcceptableIdentifiers;

	size_t fileSize = 0;
};

class MemoryNodeFileReadHandle : public NodeFileReadHandle
{
public:
	// Does NOT claim ownership of the memory it is given.
	MemoryNodeFileReadHandle(uint8_t* initData, size_t initSize);
	~MemoryNodeFileReadHandle() override;

	void assign(uint8_t* data, size_t size);

	std::shared_ptr<BinaryNode> getRootNode() override;

	size_t size() override {
		return cacheSize;
	}
	size_t tell() override {
		return localReadIndex;
	}
	bool isLoaded() {
		return true;
	}
private:
	bool renewCache() override;

	uint8_t* index;
};

class FileWriteHandle : public FileHandle
{
public:
	explicit FileWriteHandle(const std::string& initName);
	~FileWriteHandle() override;

	inline bool addU8(uint8_t u8) {return addType(u8);}
	inline bool addByte(uint8_t u8) {return addType(u8);}
	inline bool addU16(uint16_t u16) {return addType(u16);}
	inline bool addU32(uint32_t u32) {return addType(u32);}
	inline bool addU64(uint64_t u64) {return addType(u64);}
	bool addString(const std::string& str);
	bool addString(const char* str);
	bool addLongString(const std::string& str);
	bool addRAW(const std::string& str);
	bool addRAW(const uint8_t* ptr, size_t sz);
	bool addRAW(const char* c) {return addRAW(reinterpret_cast<const uint8_t*>(c), strlen(c));}

protected:
	template<class T>
	bool addType(T classType) {
		fwrite(&classType, sizeof(classType), 1, file);
		return ferror(file) == 0;
	}
};

class NodeFileWriteHandle : public FileHandle
{
public:
	NodeFileWriteHandle();
	~NodeFileWriteHandle() override;

	bool addNode(uint8_t nodetype);
	bool endNode();

	bool addByte(uint8_t u8);
	bool addU8(uint8_t u8);
	bool addU16(uint16_t u16);
	bool addU32(uint32_t u32);
	bool addU64(uint64_t u64);

	bool addInt8(int8_t int8);
	bool addInt16(int16_t int16);
	bool addInt32(int32_t int32);
	bool addInt64(int64_t int64);
	bool addString(const std::string& str);
	bool addLongString(const std::string& str);
	bool addRAW(std::string& str);
	bool addRAW(const uint8_t* ptr, size_t sz);
	bool addRAW(const char* c) {
		return addRAW(reinterpret_cast<const uint8_t*>(c), strlen(c));
	}

private:
	virtual void renewCache() = 0;

	static uint8_t NODE_START;
	static uint8_t NODE_END;
	static uint8_t ESCAPE_CHAR;

	uint8_t* cache;
	size_t cacheSize;
	size_t localWriteIndex;

	inline void writeBytes(const uint8_t* ptr, size_t size) {
		if(!size) {
			SPDLOG_ERROR("[NodeFileWriteHandle::writeBytes] - Size is missing or wrong");
			return;
		}

		do {
			if(*ptr == NODE_START || *ptr == NODE_END || *ptr == ESCAPE_CHAR) {
				cache[localWriteIndex++] = ESCAPE_CHAR;
				if(localWriteIndex >= cacheSize) {
					renewCache();
				}
			}
			cache[localWriteIndex++] = *ptr;
			if(localWriteIndex >= cacheSize) {
				renewCache();
			}
			++ptr;
			--size;
		} while(size != 0);
	}

	friend class DiskNodeFileWriteHandle;
	friend class MemoryNodeFileWriteHandle;
};

class DiskNodeFileWriteHandle : public NodeFileWriteHandle {
public:
	DiskNodeFileWriteHandle(const std::string& initName, const std::string& initIdentifier);
	~DiskNodeFileWriteHandle() override;

protected:
	void renewCache() override;
};

class MemoryNodeFileWriteHandle : public NodeFileWriteHandle {
public:
	MemoryNodeFileWriteHandle();
	~MemoryNodeFileWriteHandle() override;

	void reset();

	uint8_t* getMemory() const;
	size_t getSize() const;
protected:
	void renewCache() override;
};

#endif  // SRC_CORE_FILEHANDLE_HPP_
