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

#include "resource_manager.hpp"

#include <physfs.h>
#include <filesystem>

void ResourceManager::init(const char* argv0)
{
	PHYSFS_init(argv0);
	PHYSFS_permitSymbolicLinks(1);
}

void ResourceManager::terminate()
{
	PHYSFS_deinit();
}

bool ResourceManager::discoverWorkDir(const std::string& existentFile)
{
	// Search for current server directory
	std::string possiblePaths[] = {
		g_resources().getBaseDir(),
		g_resources().getBaseDir() + "../"
	};

	bool foundWorkDir = false;
	for (const std::string& fileDirectory : possiblePaths) {
		if (!PHYSFS_mount(fileDirectory.c_str(), nullptr, 0)) {
			SPDLOG_ERROR("[ResourceManager::discoverWorkDir] - Cannot mount: {}", fileDirectory);
			continue;
		}

		if (PHYSFS_exists(existentFile.c_str())) {
			SPDLOG_DEBUG("[ResourceManager::discoverWorkDir] - Found work dir at {},", fileDirectory);
			m_workDir = fileDirectory;
			foundWorkDir = true;
			break;
		}
		PHYSFS_unmount(fileDirectory.c_str());
	}

	return foundWorkDir;
}

bool ResourceManager::setupUserWriteDir(const std::string& appWriteDirName)
{
	const std::string userDir = getUserDir();
	std::string dirName;
#ifndef WIN32
	dirName = fmt::format(".{}", appWriteDirName);
#else
	dirName = appWriteDirName;
#endif
	const std::string writeDir = userDir + dirName;
	if (!PHYSFS_setWriteDir(writeDir.c_str())) {
		if (!PHYSFS_setWriteDir(userDir.c_str()) || !PHYSFS_mkdir(dirName.c_str())) {
			SPDLOG_ERROR("[ResourceManager::setupUserWriteDir] - Unable to create write directory '{}': {}", writeDir, PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
			return false;
		}
	}
	return setWriteDir(writeDir);
}

bool ResourceManager::setWriteDir(const std::string& writeDir, bool)
{
	if (!PHYSFS_setWriteDir(writeDir.c_str())) {
		SPDLOG_ERROR("ResourceManager::setWriteDir] - Unable to set write directory '{}': {}", writeDir, PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
		return false;
	}

	if (!m_writeDir.empty()) {
		removeSearchPath(m_writeDir);
	}

	m_writeDir = writeDir;

	if (!addSearchPath(writeDir)) {
		SPDLOG_ERROR("[ResourceManager::setWriteDir] - Unable to add write '{}' directory to search path", writeDir);
	}

	return true;
}

bool ResourceManager::addSearchPath(const std::string& path, bool pushFront)
{
	std::string savePath = path;
	if (!PHYSFS_mount(path.c_str(), nullptr, pushFront ? 0 : 1)) {
		bool foundPath = false;
		for (const std::string& searchPath : searchPaths) {
			std::string newPath = searchPath + path;
			if (PHYSFS_mount(newPath.c_str(), nullptr, pushFront ? 0 : 1)) {
				savePath = newPath;
				foundPath = true;
				break;
			}
		}

		if (!foundPath) {
			SPDLOG_ERROR("[ResourceManager::addSearchPath] - Could not add '{}' to directory search path. Reason {}", path, PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
			return false;
		}
	}
	if (pushFront) {
		searchPaths.push_front(savePath);
	}
	else
	{
		searchPaths.push_back(savePath);
	}
	return true;
}

bool ResourceManager::removeSearchPath(const std::string& path)
{
	if (!PHYSFS_unmount(path.c_str())) {
		SPDLOG_ERROR("[ResourceManager::removeSearchPath] - Cannot unmount path {}, reason {}", path, PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
		return false;
	}
	const auto iteratePaths = std::find(searchPaths.begin(), searchPaths.end(), path);
	assert(iteratePaths != searchPaths.end());
	searchPaths.erase(iteratePaths);
	return true;
}

void ResourceManager::searchAndAddPackages(const std::string& packagesDir, const std::string& packageExt)
{
	auto files = listDirectoryFiles(packagesDir);
	for (auto iterateFiles = files.rbegin(); iterateFiles != files.rend(); ++iterateFiles) {
		const std::string& file = *iterateFiles;

		if (!file.ends_with(packageExt)) {
			continue;
		}
		std::string package = getRealDir(packagesDir) + "/" + file;
		if (!addSearchPath(package, true)) {
			SPDLOG_ERROR("[ResourceManager::searchAndAddPackages] - Unable to read package '{}', reason {}", package, PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
		}
	}
}

bool ResourceManager::fileExists(const std::string& fileName)
{
	return (PHYSFS_exists(resolvePath(fileName).c_str()) && !directoryExists(fileName));
}

bool ResourceManager::directoryExists(const std::string& directoryName)
{
	PHYSFS_Stat stat = {};
	if (!PHYSFS_stat(resolvePath(directoryName).c_str(), &stat)) {
		SPDLOG_ERROR("[ResourceManager::directoryExists] - Not found directory '{}', reason {}", directoryName, PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
		return false;
	}

	return stat.filetype == PHYSFS_FILETYPE_DIRECTORY;
}

void ResourceManager::readFileStream(const std::string& fileName, std::iostream& out)
{
	const std::string buffer = readFileContents(fileName);
	if (buffer.length() == 0) {
		out.clear(std::ios::eofbit);
		return;
	}
	out.clear(std::ios::goodbit);
	out.write(&buffer[0], buffer.length());
	out.seekg(0, std::ios::beg);
}

std::string ResourceManager::readFileContents(const std::string& fileName)
{
	const std::string fullPath = resolvePath(fileName);
	PHYSFS_File* file = PHYSFS_openRead(fullPath.c_str());
	if (!file) {
		SPDLOG_ERROR("[ResourceManager::readFileContents] - Unable to open file '{}', reason {}", fullPath, PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
	}

	const int fileSize = PHYSFS_fileLength(file);
	std::string buffer(fileSize, 0);
	PHYSFS_readBytes(file, static_cast<void*>(&buffer[0]), fileSize);
	PHYSFS_close(file);
	return buffer;
}

bool ResourceManager::writeFileBuffer(const std::string& fileName, const char* data, uint64_t size)
{
	PHYSFS_file* file = PHYSFS_openWrite(fileName.c_str());
	if (!file) {
		SPDLOG_ERROR("[ResourceManager::writeFileBuffer] - Failed to write file '{}', reason {}", fileName, PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
		return false;
	}

	PHYSFS_writeBytes(file, (void*)data, size);
	PHYSFS_close(file);
	return true;
}

bool ResourceManager::writeFileStream(const std::string& fileName, std::iostream& in)
{
	const std::streampos oldPos = in.tellg();
	in.seekg(0, std::ios::end);
	const std::streampos size = in.tellg();
	in.seekg(0, std::ios::beg);
	std::vector<char> buffer(size);
	in.read(&buffer[0], size);
	const bool ret = writeFileBuffer(fileName, (const char*)&buffer[0], size);
	in.seekg(oldPos, std::ios::beg);
	return ret;
}

bool ResourceManager::writeFileContents(const std::string& fileName, const std::string& data)
{
	return writeFileBuffer(fileName, (const char*)data.c_str(), data.size());
}

FileStream* ResourceManager::openFile(const std::string& fileName)
{
	const std::string fullPath = getRealPath(fileName);
	PHYSFS_File* file = PHYSFS_openRead(fullPath.c_str());
	if (!file) {
		SPDLOG_ERROR("[ResourceManager::openFile] - Unable to open file '{}', reason {}", fullPath, PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
	}
	return { new FileStream(fullPath, file, false) };
}

FileStream* ResourceManager::appendFile(const std::string& fileName)
{
	PHYSFS_File* file = PHYSFS_openAppend(fileName.c_str());
	if (!file)
		SPDLOG_ERROR("failed to append file '{}': {}", fileName, PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
	return { new FileStream(fileName, file, true) };
}

FileStream* ResourceManager::createFile(const std::string& fileName)
{
	PHYSFS_File* file = PHYSFS_openWrite(fileName.c_str());
	if (!file) {
		SPDLOG_ERROR("[ResourceManager::createFile] - Failed to create file '{}', reason {}", fileName, PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
	}
	return { new FileStream(fileName, file, true) };
}

bool ResourceManager::deleteFile(const std::string& fileName)
{
	return PHYSFS_delete(resolvePath(fileName).c_str()) != 0;
}

bool ResourceManager::makeDir(const std::string& directory)
{
	return PHYSFS_mkdir(directory.c_str());
}

std::list<std::string> ResourceManager::listDirectoryFiles(const std::string& directoryPath)
{
	std::list<std::string> files;
	auto* const rc = PHYSFS_enumerateFiles(resolvePath(directoryPath).c_str());

	for (int i = 0; rc[i] != nullptr; i++)
		files.emplace_back(rc[i]);

	PHYSFS_freeList(rc);
	return files;
}

std::vector<std::string> ResourceManager::getDirectoryFiles(const std::string& path, bool filenameOnly, bool recursive)
{
	if (!std::filesystem::exists(path))
		return {};

	const std::filesystem::path p(path);
	return discoverPath(p, filenameOnly, recursive);
}

std::vector<std::string> ResourceManager::discoverPath(const std::filesystem::path& path, bool filenameOnly, bool recursive)
{
	std::vector<std::string> files;

	/* Before doing anything, we have to add this directory to search path,
	 * this is needed so it works correctly when one wants to open a file.  */
	addSearchPath(path.generic_string(), true);
	for (std::filesystem::directory_iterator it(path), end; it != end; ++it) {
		if (std::filesystem::is_directory(it->path().generic_string()) && recursive) {
			std::vector<std::string> subfiles = discoverPath(it->path(), filenameOnly, recursive);
			files.insert(files.end(), subfiles.begin(), subfiles.end());
		} else {
			if (filenameOnly)
				files.push_back(it->path().filename().string());
			else
				files.push_back(it->path().generic_string() + "/" + it->path().filename().string());
		}
	}

	return files;
}

std::string ResourceManager::resolvePath(const std::string& path)
{
	std::string fullPath;
	if (path.starts_with("/"))
		fullPath = path;
	else {
		const std::string scriptPath = "/" + getWorkDir();
		if (!scriptPath.empty())
			fullPath += scriptPath + "/";
		fullPath += path;
	}
	if (!(fullPath.starts_with("/")))
		SPDLOG_WARN("The following file path is not fully resolved: {}", path);

	size_t pos = 0;
		std::string search = "//";
		std::string replacement = "/";
		while ((pos = fullPath.find(search, pos)) != std::string::npos) {
			fullPath.replace(pos, search.length(), replacement);
			pos += replacement.length();
	}
	return fullPath;
}

std::string ResourceManager::getRealDir(const std::string& path)
{
	std::string dir;
	const char* cdir = PHYSFS_getRealDir(resolvePath(path).c_str());
	if (cdir)
		dir = cdir;
	return dir;
}

std::string ResourceManager::getRealPath(const std::string& path)
{
	return getRealDir(path) + "/" + path;
}

std::string ResourceManager::getBaseDir()
{
	return PHYSFS_getBaseDir();
}

std::string ResourceManager::getUserDir()
{
	return PHYSFS_getPrefDir("otclient", "otclient");
}

std::string ResourceManager::guessFilePath(const std::string& filename, const std::string& type)
{
	if (isFileType(filename, type))
		return filename;
	return filename + "." + type;
}

bool ResourceManager::isFileType(const std::string& filename, const std::string& type)
{
	if (filename.ends_with(std::string(".") + type))
		return true;
	return false;
}
