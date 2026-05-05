#include "pch.hpp"
#include "api/utils/version_store.hpp"

#include <fstream>
#include <sstream>

VersionStore &VersionStore::getInstance() {
	static VersionStore instance;
	return instance;
}

void VersionStore::loadFromFile(const std::string &path) {
	versionsByPlatform.clear();

	std::ifstream in(path);
	if (!in.is_open()) {
		g_logger().info("[VersionStore] {} not found, /api/v1/check-update will report no updates.", path);
		return;
	}

	try {
		nlohmann::json doc;
		in >> doc;
		if (!doc.contains("platforms") || !doc["platforms"].is_object()) {
			g_logger().warn("[VersionStore] {} is missing 'platforms' object.", path);
			return;
		}
		for (const auto &[platform, entries] : doc["platforms"].items()) {
			if (!entries.is_array()) {
				continue;
			}
			auto &bucket = versionsByPlatform[platform];
			for (const auto &entry : entries) {
				bucket.push_back(ClientVersion {
					.version = entry.value("version", ""),
					.url = entry.value("url", ""),
					.changelog = entry.value("changelog", ""),
					.required = entry.value("required", false),
				});
			}
		}
		g_logger().info("[VersionStore] Loaded {} platform(s) from {}.", versionsByPlatform.size(), path);
	} catch (const std::exception &e) {
		g_logger().warn("[VersionStore] Failed to parse {}: {}", path, e.what());
		versionsByPlatform.clear();
	}
}

std::optional<ClientVersion> VersionStore::findUpdate(const std::string &platform, const std::string &currentVersion) const {
	const auto it = versionsByPlatform.find(platform);
	if (it == versionsByPlatform.end()) {
		return std::nullopt;
	}
	for (const auto &candidate : it->second) {
		if (isNewerVersion(currentVersion, candidate.version)) {
			return candidate;
		}
	}
	return std::nullopt;
}

bool VersionStore::isNewerVersion(const std::string &current, const std::string &candidate) {
	const auto split = [](const std::string &s) {
		std::vector<int> parts;
		std::stringstream ss(s);
		std::string segment;
		while (std::getline(ss, segment, '.')) {
			try {
				parts.push_back(std::stoi(segment));
			} catch (...) {
				parts.push_back(0);
			}
		}
		return parts;
	};

	const auto curr = split(current);
	const auto cand = split(candidate);
	const size_t n = std::max(curr.size(), cand.size());
	for (size_t i = 0; i < n; ++i) {
		const int c = i < curr.size() ? curr[i] : 0;
		const int k = i < cand.size() ? cand[i] : 0;
		if (k > c) {
			return true;
		}
		if (k < c) {
			return false;
		}
	}
	return false;
}
