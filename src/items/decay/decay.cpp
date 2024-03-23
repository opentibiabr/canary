/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "items/decay/decay.hpp"

#include "lib/di/container.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"

Decay &Decay::getInstance() {
	return inject<Decay>();
}

void Decay::startDecay(std::shared_ptr<Item> item) {
	if (!item) {
		return;
	}

	const auto decayState = item->getDecaying();
	if (decayState == DECAYING_STOPPING || (!item->canDecay() && decayState == DECAYING_TRUE)) {
		stopDecay(item);
		return;
	}

	if (!item->canDecay() || decayState == DECAYING_TRUE) {
		return;
	}

	const auto duration = item->getAttribute<int64_t>(ItemAttribute_t::DURATION);
	if (duration <= 0 && item->hasAttribute(ItemAttribute_t::DURATION)) {
		internalDecayItem(item);
		return;
	}

	if (duration > 0) {
		if (item->hasAttribute(ItemAttribute_t::DURATION_TIMESTAMP)) {
			stopDecay(item);
		}

		int64_t timestamp = OTSYS_TIME() + duration;
		if (decayMap.empty()) {
			eventId = g_dispatcher().scheduleEvent(
				std::max<int32_t>(SCHEDULER_MINTICKS, duration), [this] { checkDecay(); }, "Decay::checkDecay"
			);
		} else {
			if (timestamp < decayMap.begin()->first) {
				g_dispatcher().stopEvent(eventId);
				eventId = g_dispatcher().scheduleEvent(
					std::max<int32_t>(SCHEDULER_MINTICKS, duration), [this] { checkDecay(); }, "Decay::checkDecay"
				);
			}
		}

		item->setDecaying(DECAYING_TRUE);
		item->setAttribute(ItemAttribute_t::DURATION_TIMESTAMP, timestamp);
		decayMap[timestamp].push_back(item);
	}
}

void Decay::stopDecay(std::shared_ptr<Item> item) {
	if (item->hasAttribute(ItemAttribute_t::DECAYSTATE)) {
		auto timestamp = item->getAttribute<int64_t>(ItemAttribute_t::DURATION_TIMESTAMP);
		if (item->hasAttribute(ItemAttribute_t::DURATION_TIMESTAMP)) {
			auto it = decayMap.find(timestamp);
			if (it != decayMap.end()) {
				auto &decayItems = it->second;

				size_t i = 0, end = decayItems.size();
				auto decayItem = decayItems[i];
				if (end == 1) {
					if (item == decayItem) {
						if (item->hasAttribute(ItemAttribute_t::DURATION)) {
							// Incase we removed duration attribute don't assign new duration
							item->setDuration(item->getDuration());
						}
						item->removeAttribute(ItemAttribute_t::DECAYSTATE);

						decayMap.erase(it);
					}
					return;
				}
				while (i < end) {
					decayItem = decayItems[i];
					if (item == decayItem) {
						if (item->hasAttribute(ItemAttribute_t::DURATION)) {
							// Incase we removed duration attribute don't assign new duration
							item->setDuration(item->getDuration());
						}
						item->removeAttribute(ItemAttribute_t::DECAYSTATE);

						decayItems[i] = decayItems.back();
						decayItems.pop_back();
						return;
					}
					++i;
				}
			}
			item->removeAttribute(ItemAttribute_t::DURATION_TIMESTAMP);
		} else {
			item->removeAttribute(ItemAttribute_t::DECAYSTATE);
		}
	}
}

void Decay::checkDecay() {
	int64_t timestamp = OTSYS_TIME();

	std::vector<std::shared_ptr<Item>> tempItems;
	tempItems.reserve(32); // Small preallocation

	auto it = decayMap.begin(), end = decayMap.end();
	while (it != end) {
		if (it->first > timestamp) {
			break;
		}

		// Iterating here is unsafe so let's copy our items into temporary vector
		auto &decayItems = it->second;
		tempItems.reserve(tempItems.size() + decayItems.size());
		for (auto &decayItem : decayItems) {
			tempItems.push_back(decayItem);
		}
		it = decayMap.erase(it);
	}

	for (const auto &item : tempItems) {
		if (!item->canDecay()) {
			item->setDuration(item->getDuration());
			item->setDecaying(DECAYING_FALSE);
		} else {
			item->setDecaying(DECAYING_FALSE);
			internalDecayItem(item);
		}
	}

	if (it != end) {
		eventId = g_dispatcher().scheduleEvent(
			std::max<int32_t>(SCHEDULER_MINTICKS, static_cast<int32_t>(it->first - timestamp)), [this] { checkDecay(); }, "Decay::checkDecay"
		);
	}
}

void Decay::internalDecayItem(std::shared_ptr<Item> item) {
	const ItemType &it = Item::items[item->getID()];
	// Remove the item and halt the decay process if a player triggers a bug where the item's decay ID matches its equip or de-equip transformation ID
	if (it.id == it.transformEquipTo || it.id == it.transformDeEquipTo) {
		g_game().internalRemoveItem(item);
		auto player = item->getHoldingPlayer();
		if (player) {
			g_logger().error("[{}] - internalDecayItem failed to player {}, item id is same from transform equip/deequip, "
							 " item id: {}, equip to id: '{}', deequip to id '{}'",
							 __FUNCTION__, player->getName(), it.id, it.transformEquipTo, it.transformDeEquipTo);
		}
		return;
	}

	if (it.decayTo != 0) {
		std::shared_ptr<Player> player = item->getHoldingPlayer();
		if (player) {
			bool needUpdateSkills = false;
			for (int32_t i = SKILL_FIRST; i <= SKILL_LAST; ++i) {
				if (it.abilities && item->getSkill(static_cast<skills_t>(i)) != 0) {
					needUpdateSkills = true;
					player->setVarSkill(static_cast<skills_t>(i), -item->getSkill(static_cast<skills_t>(i)));
				}
			}

			if (needUpdateSkills) {
				player->sendSkills();
			}

			bool needUpdateStats = false;
			for (int32_t s = STAT_FIRST; s <= STAT_LAST; ++s) {
				if (item->getStat(static_cast<stats_t>(s)) != 0) {
					needUpdateStats = true;
					needUpdateSkills = true;
					player->setVarStats(static_cast<stats_t>(s), -item->getStat(static_cast<stats_t>(s)));
				}
				if (it.abilities && it.abilities->statsPercent[s] != 0) {
					needUpdateStats = true;
					player->setVarStats(static_cast<stats_t>(s), -static_cast<int32_t>(player->getDefaultStats(static_cast<stats_t>(s)) * ((it.abilities->statsPercent[s] - 100) / 100.f)));
				}
			}

			if (needUpdateStats) {
				player->sendStats();
			}

			if (needUpdateSkills) {
				player->sendSkills();
			}
		}
		g_game().transformItem(item, static_cast<uint16_t>(it.decayTo));
	} else {
		if (item->isLoadedFromMap()) {
			return;
		}

		ReturnValue ret = g_game().internalRemoveItem(item);
		if (ret != RETURNVALUE_NOERROR) {
			g_logger().error("[Decay::internalDecayItem] - internalDecayItem failed, "
							 "error code: {}, item id: {}",
							 static_cast<uint32_t>(ret), item->getID());
		}
	}
}
