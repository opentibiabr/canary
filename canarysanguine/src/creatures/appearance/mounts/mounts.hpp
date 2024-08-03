/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

struct Mount {
	Mount(uint8_t initId, uint16_t initClientId, std::string initName, int32_t initSpeed, bool initPremium, std::string initType) :
		name(std::move(initName)), speed(initSpeed), clientId(initClientId), id(initId), premium(initPremium),
		type(std::move(initType)) { }

	std::string name;
	int32_t speed;
	uint16_t clientId;
	uint8_t id;
	bool premium;
	std::string type;
};

class Mounts {
public:
	bool reload();
	bool loadFromXml();
	std::shared_ptr<Mount> getMountByID(uint8_t id);
	std::shared_ptr<Mount> getMountByName(const std::string &name);
	std::shared_ptr<Mount> getMountByClientID(uint16_t clientId);

	[[nodiscard]] const phmap::parallel_flat_hash_set<std::shared_ptr<Mount>> &getMounts() const {
		return mounts;
	}

private:
	phmap::parallel_flat_hash_set<std::shared_ptr<Mount>> mounts;
};
