#pragma once

#include <optional>
#include <string>
#include <unordered_map>
#include <vector>

struct ClientVersion {
	std::string version;
	std::string url;
	std::string changelog;
	bool required = false;
};

// In-memory store of available client versions per platform, loaded from
// data/api_versions.json at API startup. Operators populate the file with their
// own release URLs; the engine ships no defaults so a public canary build never
// advertises a third party's downloads.
class VersionStore {
public:
	static VersionStore &getInstance();

	// Reads data/api_versions.json. Missing file or parse errors are non-fatal:
	// the store stays empty and check-update simply returns hasUpdate=false.
	void loadFromFile(const std::string &path);

	// Returns the newest version for `platform` strictly greater than `currentVersion`,
	// or std::nullopt if none. Versions are dotted, leading numeric segments only.
	std::optional<ClientVersion> findUpdate(const std::string &platform, const std::string &currentVersion) const;

private:
	std::unordered_map<std::string, std::vector<ClientVersion>> versionsByPlatform;

	static bool isNewerVersion(const std::string &current, const std::string &candidate);
};
