/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_IO_IOMAPSERIALIZE_H_
#define SRC_IO_IOMAPSERIALIZE_H_

#include "map/map.h"

class IOMapSerialize {
	public:
		static void loadHouseItems(Map* map);
		static bool SaveHouseItemsGuard();
		static bool saveHouseItems();
		static bool loadHouseInfo();
		static bool SaveHouseInfoGuard();
		static bool saveHouseInfo();

	private:
		static void saveItem(PropWriteStream &stream, const Item* item);
		static void saveTile(PropWriteStream &stream, const Tile* tile);

		static bool loadContainer(PropStream &propStream, Container* container);
		static bool loadItem(PropStream &propStream, Cylinder* parent, bool isHouseItem = false);
};

#endif // SRC_IO_IOMAPSERIALIZE_H_
