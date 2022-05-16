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
	FileHandle() : errorCode(FILE_NO_ERROR), file(nullptr) {}
	virtual ~FileHandle() {close();}

	// Ensure it's not copyable
	NONCOPYABLE(FileHandle);

	virtual void close();
	virtual bool isOpen() {
		return file != nullptr;
	}
	virtual bool isLoaded() {
		return isOpen() && errorCode == FILE_NO_ERROR && ferror(file) == 0;
	}
	void setErrorCode(FileHandleError newErrorCode) {
		errorCode = newErrorCode;
	}
	std::string getErrorMessage();
public:
	FileHandleError errorCode;
	FILE* file;
};

class FileReadHandle : public FileHandle
{
public:
	explicit FileReadHandle(const std::string& name);
	virtual ~FileReadHandle();

	uint8_t getU8();
	uint16_t getU16();
	uint32_t getU32();
	uint64_t getU64();

	int8_t get8();
	int32_t get32();

	uint8_t* getRawNumber(size_t sz);
	std::string getRawString(size_t sz);
	std::string getString();
	std::string getLongString();

	virtual void close();
	bool seek(size_t offset);
	bool seekRelative(size_t offset);
	void skip(size_t offset) {seekRelative(offset);}
	size_t size() {return fileSize;}
	size_t tell() {
		if(file) {
			return ftell(file);
		}
		return 0;
	}
protected:
	size_t fileSize;

	template<class T>
	bool getType(T& classType) {
		fread(&classType, sizeof(classType), 1, file);
		return ferror(file) == 0;
	}
};

class NodeFileReadHandle;
class DiskNodeFileReadHandle;
class MemoryNodeFileReadHandle;

class BinaryNode
{
public:
	BinaryNode(NodeFileReadHandle* file, BinaryNode* parent);
	~BinaryNode();

	NONCOPYABLE(BinaryNode);

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
	uint8_t* getRawNumber(size_t size);
	std::string getRawString(size_t size);
	std::string getString();
	std::string getLongString();

	BinaryNode* getChild();
	// Returns this on success, nullptr on failure
	BinaryNode* advance();

	std::string getStringData() const {
		return stringData;
	}

	bool canRead() {
		return readOffsetSize < stringData.size();
	}
protected:
	void load();
	std::string stringData;
	size_t readOffsetSize;
	NodeFileReadHandle* file;
	BinaryNode* parent;
	BinaryNode* child;

	friend class DiskNodeFileReadHandle;
	friend class MemoryNodeFileReadHandle;
};

class NodeFileReadHandle : public FileHandle
{
public:
	NodeFileReadHandle();
	virtual ~NodeFileReadHandle();

	virtual BinaryNode* getRootNode() = 0;

	virtual size_t size() = 0;
	virtual size_t tell() = 0;
protected:
	BinaryNode* getNode(BinaryNode* parent);
	void freeNode(BinaryNode* node);
	// Returns false when end-of-file is reached
	virtual bool renewCache() = 0;

	bool last_was_start;
	uint8_t* cache;
	size_t cache_size;
	size_t cache_length;
	size_t local_read_index;

	BinaryNode* root_node;

	std::stack<void*> unused;

	friend class BinaryNode;
};

class DiskNodeFileReadHandle : public NodeFileReadHandle
{
public:
	DiskNodeFileReadHandle(const std::string& name, const std::vector<std::string>& acceptable_identifiers);
	virtual ~DiskNodeFileReadHandle();

	virtual void close();
	virtual BinaryNode* getRootNode();

	virtual size_t size() {return fileSize;}
	virtual size_t tell() {if(file) return ftell(file); return 0;}
protected:
	virtual bool renewCache();

	size_t fileSize;
};

class MemoryNodeFileReadHandle : public NodeFileReadHandle
{
public:
	// Does NOT claim ownership of the memory it is given.
	MemoryNodeFileReadHandle(const uint8_t* data, size_t size);
	virtual ~MemoryNodeFileReadHandle();

	void assign(const uint8_t* data, size_t size);

	virtual void close();
	virtual BinaryNode* getRootNode();

	virtual size_t size() {return cache_size;}
	virtual size_t tell() {return local_read_index;}
	virtual bool isLoaded() {return true;}
protected:
	virtual bool renewCache();

	uint8_t* index;
};

class FileWriteHandle : public FileHandle
{
public:
	explicit FileWriteHandle(const std::string& name);
	virtual ~FileWriteHandle();

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
	virtual ~NodeFileWriteHandle();

	bool addNode(uint8_t nodetype);
	bool endNode();

	bool addU8(uint8_t u8);
	bool addByte(uint8_t u8);
	bool addU16(uint16_t u16);
	bool addU32(uint32_t u32);
	bool addU64(uint64_t u64);
	bool addString(const std::string& str);
	bool addLongString(const std::string& str);
	bool addRAW(std::string& str);
	bool addRAW(const uint8_t* ptr, size_t sz);
	bool addRAW(const char* c) {return addRAW(reinterpret_cast<const uint8_t*>(c), strlen(c));}

protected:
	virtual void renewCache() = 0;

	static uint8_t NODE_START;
	static uint8_t NODE_END;
	static uint8_t ESCAPE_CHAR;

	uint8_t* cache;
	size_t cache_size;
	size_t local_write_index;

	inline void writeBytes(const uint8_t* ptr, size_t sz) {
		if(sz) {
			do {
				if(*ptr == NODE_START || *ptr == NODE_END || *ptr == ESCAPE_CHAR) {
					cache[local_write_index++] = ESCAPE_CHAR;
					if(local_write_index >= cache_size) {
						renewCache();
					}
				}
				cache[local_write_index++] = *ptr;
				if(local_write_index >= cache_size) {
					renewCache();
				}
				++ptr;
				--sz;
			} while(sz != 0);
		}
	}
};

class DiskNodeFileWriteHandle : public NodeFileWriteHandle {
public:
	DiskNodeFileWriteHandle(const std::string& name, const std::string& identifier);
	virtual ~DiskNodeFileWriteHandle();

	virtual void close();
protected:
	virtual void renewCache();
};

class MemoryNodeFileWriteHandle : public NodeFileWriteHandle {
public:
	MemoryNodeFileWriteHandle();
	virtual ~MemoryNodeFileWriteHandle();

	void reset();
	virtual void close();

	uint8_t* getMemory();
	size_t getSize();
protected:
	virtual void renewCache();
};

#endif  // SRC_CORE_FILEHANDLE_HPP_
