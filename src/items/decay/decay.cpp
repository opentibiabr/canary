/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "items/decay/decay.h"
#include "game/game.h"
#include "game/scheduling/scheduler.h"

void Decay::startDecay(Item* item) {
	if (!item || item->getLoadedFromMap()) {
		return;
	}

	auto decayState = item->getDecaying();
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
			eventId = g_scheduler().addEvent(createSchedulerTask(std::max<int32_t>(SCHEDULER_MINTICKS, duration), std::bind(&Decay::checkDecay, this)));
		} else {
			if (timestamp < decayMap.begin()->first) {
				g_scheduler().stopEvent(eventId);
				eventId = g_scheduler().addEvent(createSchedulerTask(std::max<int32_t>(SCHEDULER_MINTICKS, duration), std::bind(&Decay::checkDecay, this)));
			}
		}

		item->incrementReferenceCounter();
		item->setDecaying(DECAYING_TRUE);
		item->setAttribute(ItemAttribute_t::DURATION_TIMESTAMP, timestamp);
		decayMap[timestamp].push_back(item);
	}
}

void Decay::stopDecay(Item* item) {
	if (item->hasAttribute(ItemAttribute_t::DECAYSTATE)) {
		auto timestamp = item->getAttribute<int64_t>(ItemAttribute_t::DURATION_TIMESTAMP);
		if (item->hasAttribute(ItemAttribute_t::DURATION_TIMESTAMP)) {
			auto it = decayMap.find(timestamp);
			if (it != decayMap.end()) {
				std::vector<Item*> &decayItems = it->second;

				size_t i = 0, end = decayItems.size();
				if (end == 1) {
					if (item == decayItems[i]) {
						if (item->hasAttribute(ItemAttribute_t::DURATION)) {
							// Incase we removed duration attribute don't assign new duration
							item->setDuration(item->getDuration());
						}
						item->removeAttribute(ItemAttribute_t::DECAYSTATE);
						g_game().ReleaseItem(item);

						decayMap.erase(it);
					}
					return;
				}
				while (i < end) {
					if (item == decayItems[i]) {
						if (item->hasAttribute(ItemAttribute_t::DURATION)) {
							// Incase we removed duration attribute don't assign new duration
							item->setDuration(item->getDuration());
						}
						item->removeAttribute(ItemAttribute_t::DECAYSTATE);
						g_game().ReleaseItem(item);

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

	std::vector<Item*> tempItems;
	tempItems.reserve(32); // Small preallocation

	auto it = decayMap.begin(), end = decayMap.end();
	while (it != end) {
		if (it->first > timestamp) {
			break;
		}

		// Iterating here is unsafe so let's copy our items into temporary vector
		std::vector<Item*> &decayItems = it->second;
		tempItems.insert(tempItems.end(), decayItems.begin(), decayItems.end());
		it = decayMap.erase(it);
	}

	for (Item* item : tempItems) {
		if (!item->canDecay()) {
			item->setDuration(item->getDuration());
			item->setDecaying(DECAYING_FALSE);
		} else {
			item->setDecaying(DECAYING_FALSE);
			internalDecayItem(item);
		}

		g_game().ReleaseItem(item);
	}

	if (it != end) {
		eventId = g_scheduler().addEvent(createSchedulerTask(std::max<int32_t>(SCHEDULER_MINTICKS, static_cast<int32_t>(it->first - timestamp)), std::bind(&Decay::checkDecay, this)));
	}
}

void Decay::internalDecayItem(Item* item) {
	const ItemType &it = Item::items[item->getID()];
	if (it.decayTo != 0) {
		Player* player = item->getHoldingPlayer();
		if (player) {
			bool needUpdateSkills = false;
			for (int32_t i = SKILL_FIRST; i <= SKILL_LAST; ++i) {
				if (it.abilities && it.abilities->skills[i] != 0) {
					needUpdateSkills = true;
					player->setVarSkill(static_cast<skills_t>(i), -it.abilities->skills[i]);
				}
			}

			if (needUpdateSkills) {
				player->sendSkills();
			}

			bool needUpdateStats = false;
			for (int32_t s = STAT_FIRST; s <= STAT_LAST; ++s) {
				if (it.abilities && it.abilities->stats[s] != 0) {
					needUpdateStats = true;
					needUpdateSkills = true;
					player->setVarStats(static_cast<stats_t>(s), -it.abilities->stats[s]);
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
		if (item->getLoadedFromMap()) {
			return;
		}

		ReturnValue ret = g_game().internalRemoveItem(item);
		if (ret != RETURNVALUE_NOERROR) {
			SPDLOG_ERROR("[Decay::internalDecayItem] - internalDecayItem failed, "
						 "error code: {}, item id: {}",
						 static_cast<uint32_t>(ret), item->getID());
		}
	}
}
