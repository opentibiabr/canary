/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/players/gamestore/player_store_detail.hpp"

#include "kv/kv.hpp"

std::string StoreDetail::toString() const {
	return fmt::format("Description: {}, Coin Amount: {}, CreatedAt: {}, Is Gold: {}", description, coinAmount, createdAt, isGold);
}

ValueWrapper StoreDetail::serialize() const {
	return {
		{ "description", description },
		{ "coinAmount", coinAmount },
		{ "created_at", createdAt },
		{ "is_gold", isGold }
	};
}

StoreDetail StoreDetail::deserialize(const ValueWrapper &val) {
	auto map = val.get<MapType>();
	return {
		map["description"]->get<StringType>(),
		map["coinAmount"]->get<IntType>(),
		map["created_at"]->get<IntType>(),
		map["is_gold"]->get<BooleanType>()
	};
}
