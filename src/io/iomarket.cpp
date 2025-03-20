/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "io/iomarket.hpp"

#include "config/configmanager.hpp"
#include "database/databasetasks.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "game/scheduling/save_manager.hpp"
#include "io/iologindata.hpp"
#include "items/containers/inbox/inbox.hpp"
#include "creatures/players/player.hpp"

uint8_t IOMarket::getTierFromDatabaseTable(const std::string &string) {
	auto tier = static_cast<uint8_t>(std::atoi(string.c_str()));
	if (tier > g_configManager().getNumber(FORGE_MAX_ITEM_TIER)) {
		g_logger().error("{} - Failed to get number value {} for tier table result", __FUNCTION__, tier);
		return 0;
	}

	return tier;
}

MarketOfferList IOMarket::getActiveOffers(MarketAction_t action) {
	MarketOfferList offerList;

	std::string query = fmt::format(
		"SELECT `id`, `itemtype`, `amount`, `price`, `tier`, `created`, `anonymous`, "
		"(SELECT `name` FROM `players` WHERE `id` = `player_id`) AS `player_name` "
		"FROM `market_offers` WHERE `sale` = {}",
		action
	);

	DBResult_ptr result = g_database().storeQuery(query);
	if (!result) {
		return offerList;
	}

	const int32_t marketOfferDuration = g_configManager().getNumber(MARKET_OFFER_DURATION);

	do {
		MarketOffer offer;
		offer.itemId = result->getNumber<uint16_t>("itemtype");
		offer.amount = result->getNumber<uint16_t>("amount");
		offer.price = result->getNumber<uint64_t>("price");
		offer.timestamp = result->getNumber<uint32_t>("created") + marketOfferDuration;
		offer.counter = (result->getNumber<uint32_t>("id") ^ 0xABCDEF) & 0xFFFF;
		if (result->getNumber<uint16_t>("anonymous") == 0) {
			offer.playerName = result->getString("player_name");
		} else {
			offer.playerName = "Anonymous";
		}
		offer.tier = getTierFromDatabaseTable(result->getString("tier"));
		offerList.push_back(offer);
	} while (result->next());
	return offerList;
}

MarketOfferList IOMarket::getActiveOffers(MarketAction_t action, uint16_t itemId, uint8_t tier) {
	MarketOfferList offerList;

	std::ostringstream query;
	query << "SELECT `id`, `amount`, `price`, `tier`, `created`, `anonymous`, (SELECT `name` FROM `players` WHERE `id` = `player_id`) AS `player_name` FROM `market_offers` WHERE `sale` = " << action << " AND `itemtype` = " << itemId << " AND `tier` = " << std::to_string(tier);

	DBResult_ptr result = Database::getInstance().storeQuery(query.str());
	if (!result) {
		return offerList;
	}

	const int32_t marketOfferDuration = g_configManager().getNumber(MARKET_OFFER_DURATION);

	do {
		MarketOffer offer;
		offer.itemId = itemId;
		offer.amount = result->getNumber<uint16_t>("amount");
		offer.price = result->getNumber<uint64_t>("price");
		offer.timestamp = result->getNumber<uint32_t>("created") + marketOfferDuration;
		offer.counter = (result->getNumber<uint32_t>("id") ^ 0xABCDEF) & 0xFFFF;
		if (result->getNumber<uint16_t>("anonymous") == 0) {
			offer.playerName = result->getString("player_name");
		} else {
			offer.playerName = "Anonymous";
		}
		offer.tier = getTierFromDatabaseTable(result->getString("tier"));
		offerList.push_back(offer);
	} while (result->next());
	return offerList;
}

MarketOfferList IOMarket::getOwnOffers(MarketAction_t action, uint32_t playerId) {
	MarketOfferList offerList;

	const int32_t marketOfferDuration = g_configManager().getNumber(MARKET_OFFER_DURATION);

	std::ostringstream query;
	query << "SELECT `id`, `amount`, `price`, `created`, `itemtype`, `tier` FROM `market_offers` WHERE `player_id` = " << playerId << " AND `sale` = " << action;

	DBResult_ptr result = Database::getInstance().storeQuery(query.str());
	if (!result) {
		return offerList;
	}

	do {
		MarketOffer offer;
		offer.amount = result->getNumber<uint16_t>("amount");
		offer.price = result->getNumber<uint64_t>("price");
		offer.timestamp = result->getNumber<uint32_t>("created") + marketOfferDuration;
		offer.counter = (result->getNumber<uint32_t>("id") ^ 0xABCDEF) & 0xFFFF;
		offer.itemId = result->getNumber<uint16_t>("itemtype");
		offer.tier = getTierFromDatabaseTable(result->getString("tier"));
		offerList.push_back(offer);
	} while (result->next());
	return offerList;
}

HistoryMarketOfferList IOMarket::getOwnHistory(MarketAction_t action, uint32_t playerId) {
	HistoryMarketOfferList offerList;

	std::ostringstream query;
	query << "SELECT `itemtype`, `amount`, `price`, `expires_at`, `state`, `tier` FROM `market_history` WHERE `player_id` = " << playerId << " AND `sale` = " << action;

	DBResult_ptr result = Database::getInstance().storeQuery(query.str());
	if (!result) {
		return offerList;
	}

	do {
		HistoryMarketOffer offer {};
		offer.itemId = result->getNumber<uint16_t>("itemtype");
		offer.amount = result->getNumber<uint16_t>("amount");
		offer.price = result->getNumber<uint64_t>("price");
		offer.timestamp = result->getNumber<uint32_t>("expires_at");
		offer.tier = getTierFromDatabaseTable(result->getString("tier"));

		MarketOfferState_t offerState = static_cast<MarketOfferState_t>(result->getNumber<uint16_t>("state"));
		if (offerState == OFFERSTATE_ACCEPTEDEX) {
			offerState = OFFERSTATE_ACCEPTED;
		}

		offer.state = offerState;

		offerList.push_back(offer);
	} while (result->next());
	return offerList;
}

void IOMarket::processExpiredOffers(const DBResult_ptr &result, bool) {
	if (!result) {
		return;
	}

	do {
		if (!IOMarket::moveOfferToHistory(result->getNumber<uint32_t>("id"), OFFERSTATE_EXPIRED)) {
			continue;
		}

		const auto playerId = result->getNumber<uint32_t>("player_id");
		const auto amount = result->getNumber<uint16_t>("amount");
		auto tier = getTierFromDatabaseTable(result->getString("tier"));
		if (result->getNumber<uint16_t>("sale") == 1) {
			const ItemType &itemType = Item::items[result->getNumber<uint16_t>("itemtype")];
			if (itemType.id == 0) {
				continue;
			}

			const auto &player = g_game().getPlayerByGUID(playerId, true);
			if (!player) {
				continue;
			}

			const auto &playerInbox = player->getInbox();

			if (itemType.stackable) {
				uint16_t tmpAmount = amount;
				while (tmpAmount > 0) {
					uint16_t stackCount = std::min<uint16_t>(100, tmpAmount);
					const auto &item = Item::CreateItem(itemType.id, stackCount);
					if (g_game().internalAddItem(playerInbox, item, INDEX_WHEREEVER, FLAG_NOLIMIT) != RETURNVALUE_NOERROR) {
						g_logger().error("[{}] Ocurred an error to add item with id {} to player {}", __FUNCTION__, itemType.id, player->getName());

						break;
					}

					if (tier != 0) {
						item->setAttribute(ItemAttribute_t::TIER, tier);
					}

					tmpAmount -= stackCount;
				}
			} else {
				int32_t subType;
				if (itemType.charges != 0) {
					subType = itemType.charges;
				} else {
					subType = -1;
				}

				for (uint16_t i = 0; i < amount; ++i) {
					const auto &item = Item::CreateItem(itemType.id, subType);
					if (g_game().internalAddItem(playerInbox, item, INDEX_WHEREEVER, FLAG_NOLIMIT) != RETURNVALUE_NOERROR) {
						break;
					}

					if (tier != 0) {
						item->setAttribute(ItemAttribute_t::TIER, tier);
					}
				}
			}

			if (player->isOffline()) {
				g_saveManager().savePlayer(player);
			}
		} else {
			uint64_t totalPrice = result->getNumber<uint64_t>("price") * amount;

			const auto &player = g_game().getPlayerByGUID(playerId);
			if (player) {
				player->setBankBalance(player->getBankBalance() + totalPrice);
			} else {
				IOLoginData::increaseBankBalance(playerId, totalPrice);
			}
		}
	} while (result->next());
}

void IOMarket::checkExpiredOffers() {
	const time_t lastExpireDate = getTimeNow() - g_configManager().getNumber(MARKET_OFFER_DURATION);

	std::ostringstream query;
	query << "SELECT `id`, `amount`, `price`, `itemtype`, `player_id`, `sale`, `tier` FROM `market_offers` WHERE `created` <= " << lastExpireDate;
	g_databaseTasks().store(query.str(), IOMarket::processExpiredOffers);

	int32_t checkExpiredMarketOffersEachMinutes = g_configManager().getNumber(CHECK_EXPIRED_MARKET_OFFERS_EACH_MINUTES);
	if (checkExpiredMarketOffersEachMinutes <= 0) {
		return;
	}

	g_dispatcher().scheduleEvent(checkExpiredMarketOffersEachMinutes * 60 * 1000, IOMarket::checkExpiredOffers, __FUNCTION__);
}

uint32_t IOMarket::getPlayerOfferCount(uint32_t playerId) {
	std::ostringstream query;
	query << "SELECT COUNT(*) AS `count` FROM `market_offers` WHERE `player_id` = " << playerId;

	DBResult_ptr result = Database::getInstance().storeQuery(query.str());
	if (!result) {
		return 0;
	}
	return result->getNumber<int32_t>("count");
}

MarketOfferEx IOMarket::getOfferByCounter(uint32_t timestamp, uint16_t counter) {
	MarketOfferEx offer;

	const int32_t created = timestamp - g_configManager().getNumber(MARKET_OFFER_DURATION);

	std::ostringstream query;
	query << "SELECT `id`, `sale`, `itemtype`, `amount`, `created`, `price`, `player_id`, `anonymous`, `tier`, (SELECT `name` FROM `players` WHERE `id` = `player_id`) AS `player_name` FROM `market_offers` WHERE `created` = " << created << " AND ((`id` ^ 0xABCDEF) & 65535) = " << counter << " LIMIT 1";

	DBResult_ptr result = Database::getInstance().storeQuery(query.str());
	if (!result) {
		offer.id = 0;
		return offer;
	}

	offer.id = result->getNumber<uint32_t>("id");
	offer.type = static_cast<MarketAction_t>(result->getNumber<uint16_t>("sale"));
	offer.amount = result->getNumber<uint16_t>("amount");
	offer.counter = (result->getNumber<uint32_t>("id") ^ 0xABCDEF) & 0xFFFF;
	offer.timestamp = result->getNumber<uint32_t>("created");
	offer.price = result->getNumber<uint64_t>("price");
	offer.itemId = result->getNumber<uint16_t>("itemtype");
	offer.playerId = result->getNumber<uint32_t>("player_id");
	offer.tier = getTierFromDatabaseTable(result->getString("tier"));
	if (result->getNumber<uint16_t>("anonymous") == 0) {
		offer.playerName = result->getString("player_name");
	} else {
		offer.playerName = "Anonymous";
	}
	return offer;
}

void IOMarket::createOffer(uint32_t playerId, MarketAction_t action, uint32_t itemId, uint16_t amount, uint64_t price, uint8_t tier, bool anonymous) {
	std::ostringstream query;
	query << "INSERT INTO `market_offers` (`player_id`, `sale`, `itemtype`, `amount`, `created`, `anonymous`, `price`, `tier`) VALUES (" << playerId << ',' << action << ',' << itemId << ',' << amount << ',' << getTimeNow() << ',' << anonymous << ',' << price << ',' << std::to_string(tier) << ')';
	Database::getInstance().executeQuery(query.str());
}

void IOMarket::acceptOffer(uint32_t offerId, uint16_t amount) {
	std::ostringstream query;
	query << "UPDATE `market_offers` SET `amount` = `amount` - " << amount << " WHERE `id` = " << offerId;
	Database::getInstance().executeQuery(query.str());
}

void IOMarket::deleteOffer(uint32_t offerId) {
	std::ostringstream query;
	query << "DELETE FROM `market_offers` WHERE `id` = " << offerId;
	Database::getInstance().executeQuery(query.str());
}

void IOMarket::appendHistory(uint32_t playerId, MarketAction_t type, uint16_t itemId, uint16_t amount, uint64_t price, time_t timestamp, uint8_t tier, MarketOfferState_t state) {
	std::ostringstream query;
	query << "INSERT INTO `market_history` (`player_id`, `sale`, `itemtype`, `amount`, `price`, `expires_at`, `inserted`, `state`, `tier`) VALUES ("
		  << playerId << ',' << type << ',' << itemId << ',' << amount << ',' << price << ','
		  << timestamp << ',' << getTimeNow() << ',' << state << ',' << std::to_string(tier) << ')';
	g_databaseTasks().execute(query.str());
}

bool IOMarket::moveOfferToHistory(uint32_t offerId, MarketOfferState_t state) {
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `player_id`, `sale`, `itemtype`, `amount`, `price`, `created`, `tier` FROM `market_offers` WHERE `id` = " << offerId;

	DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		return false;
	}

	query.str(std::string());
	query << "DELETE FROM `market_offers` WHERE `id` = " << offerId;
	if (!db.executeQuery(query.str())) {
		return false;
	}

	appendHistory(
		result->getNumber<uint32_t>("player_id"),
		static_cast<MarketAction_t>(result->getNumber<uint16_t>("sale")),
		result->getNumber<uint16_t>("itemtype"),
		result->getNumber<uint16_t>("amount"),
		result->getNumber<uint64_t>("price"),
		getTimeNow(),
		getTierFromDatabaseTable(result->getString("tier")), state
	);
	return true;
}

void IOMarket::updateStatistics() {
	auto query = fmt::format(
		"SELECT sale, itemtype, COUNT(price) AS num, MIN(price) AS min, MAX(price) AS max, SUM(price) AS sum, tier "
		"FROM market_history "
		"WHERE state = '{}' "
		"GROUP BY itemtype, sale, tier",
		OFFERSTATE_ACCEPTED
	);

	DBResult_ptr result = g_database().storeQuery(query);
	if (!result) {
		return;
	}

	do {
		MarketStatistics* statistics = nullptr;
		const auto tier = getTierFromDatabaseTable(result->getString("tier"));
		auto itemId = result->getNumber<uint16_t>("itemtype");
		if (result->getNumber<uint16_t>("sale") == MARKETACTION_BUY) {
			statistics = &purchaseStatistics[itemId][tier];
		} else {
			statistics = &saleStatistics[itemId][tier];
		}

		statistics->numTransactions = result->getNumber<uint32_t>("num");
		statistics->lowestPrice = result->getNumber<uint64_t>("min");
		statistics->totalPrice = result->getNumber<uint64_t>("sum");
		statistics->highestPrice = result->getNumber<uint64_t>("max");
	} while (result->next());
}
