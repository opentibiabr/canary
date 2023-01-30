/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_CREATURES_APPEARANCE_MOUNTS_MOUNTS_H_
#define SRC_CREATURES_APPEARANCE_MOUNTS_MOUNTS_H_


struct Mount
{
	Mount(uint8_t initId, uint16_t initClientId, std::string initName, int32_t initSpeed, bool initPremium,
																							std::string initType) :
		name(initName), speed(initSpeed), clientId(initClientId), id(initId), premium(initPremium),
		type(initType) {}

	std::string name;
	int32_t speed;
	uint16_t clientId;
	uint8_t id;
	bool premium;
	std::string type;
};

class Mounts
{
	public:
		bool reload();
		bool loadFromXml();
		Mount* getMountByID(uint8_t id);
		Mount* getMountByName(const std::string& name);
		Mount* getMountByClientID(uint16_t clientId);

		const std::vector<Mount>& getMounts() const {
			return mounts;
		}

	private:
		std::vector<Mount> mounts;
};

#endif  // SRC_CREATURES_APPEARANCE_MOUNTS_MOUNTS_H_
