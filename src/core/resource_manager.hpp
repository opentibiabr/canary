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

#ifndef SRC_CORE_RESOURCES_HPP_
#define SRC_CORE_RESOURCES_HPP_

#include "file_stream.hpp"

#include <filesystem>
#include <deque>

class FileStream;

class ResourceManager
{
public:
	ResourceManager() = default;

	// non-copyable
	ResourceManager(const ResourceManager&) = delete;
	ResourceManager& operator=(const ResourceManager&) = delete;

	static ResourceManager& getInstance() {
		// Guaranteed to be destroyed
		static ResourceManager instance;
		// Instantiated on first use
		return instance;
	}

	void init(const char* argv0);
	void terminate();

	bool discoverWorkDir(const std::string& existentFile);
	bool setupUserWriteDir(const std::string& appWriteDirName);
	bool setWriteDir(const std::string& writeDir, bool create = false);

	bool addSearchPath(const std::string& path, bool pushFront = false);
	bool removeSearchPath(const std::string& path);
	void searchAndAddPackages(const std::string& packagesDir, const std::string& packageExt);

	bool fileExists(const std::string& fileName);
	bool directoryExists(const std::string& directoryName);

	void readFileStream(const std::string& fileName, std::iostream& out);
	std::string readFileContents(const std::string& fileName);
	bool writeFileBuffer(const std::string& fileName, const char* data, uint64_t size);
	bool writeFileContents(const std::string& fileName, const std::string& data);
	bool writeFileStream(const std::string& fileName, std::iostream& in);

	FileStream* openFile(const std::string& fileName);
	FileStream* appendFile(const std::string& fileName);
	FileStream* createFile(const std::string& fileName);
	bool deleteFile(const std::string& fileName);

	bool makeDir(const std::string& directory);
	std::list<std::string> listDirectoryFiles(const std::string& directoryPath = "");
	std::vector<std::string> getDirectoryFiles(const std::string& path, bool filenameOnly, bool recursive);

	std::string resolvePath(const std::string& path);
	std::string getRealDir(const std::string& path);
	std::string getRealPath(const std::string& path);
	std::string getBaseDir();
	std::string getUserDir();
	std::string getWriteDir() {
		return m_writeDir;
	}
	std::string getWorkDir() {
		return m_workDir;
	}
	std::deque<std::string> getSearchPaths() {
		return searchPaths;
	}

	std::string guessFilePath(const std::string& filename, const std::string& type);
	bool isFileType(const std::string& filename, const std::string& type);

protected:
	std::vector<std::string> discoverPath(const std::filesystem::path& path, bool filenameOnly, bool recursive);

private:
	std::string m_workDir;
	std::string m_writeDir;
	std::deque<std::string> searchPaths;
};

constexpr auto g_resources = &ResourceManager::getInstance;

#endif  // SRC_CORE_RESOURCES_HPP_
