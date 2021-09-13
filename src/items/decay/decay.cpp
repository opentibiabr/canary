/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
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

#include "items/decay/decay.h"
#include "game/game.h"
#include "game/scheduling/scheduler.h"

extern Game g_game;
Decay g_decay;

void Decay::startDecay(Item* item, int32_t duration)
{
	if (item->hasAttribute(ITEM_ATTRIBUTE_DURATION_TIMESTAMP)) {
		stopDecay(item, item->getIntAttr(ITEM_ATTRIBUTE_DURATION_TIMESTAMP));
	}

	int64_t timestamp = OTSYS_TIME() + static_cast<int64_t>(duration);
	if (decayMap.empty()) {
		eventId = g_scheduler.addEvent(createSchedulerTask(std::max<int32_t>(SCHEDULER_MINTICKS, duration), std::bind(&Decay::checkDecay, this)));
	} else {
		if (timestamp < decayMap.begin()->first) {
			g_scheduler.stopEvent(eventId);
			eventId = g_scheduler.addEvent(createSchedulerTask(std::max<int32_t>(SCHEDULER_MINTICKS, duration), std::bind(&Decay::checkDecay, this)));
		}
	}

	item->incrementReferenceCounter();
	item->setDecaying(DECAYING_TRUE);
	item->setDurationTimestamp(timestamp);
	decayMap[timestamp].push_back(item);
}

void Decay::stopDecay(Item* item, int64_t timestamp)
{
	auto it = decayMap.find(timestamp);
	if (it != decayMap.end()) {
		std::vector<Item*>& decayItems = it->second;

		size_t i = 0, end = decayItems.size();
		if (end == 1) {
			if (item == decayItems[i]) {
				if (item->hasAttribute(ITEM_ATTRIBUTE_DURATION)) {
					//Incase we removed duration attribute don't assign new duration
					item->setDuration(item->getDuration());
				}
				item->removeAttribute(ITEM_ATTRIBUTE_DECAYSTATE);
				g_game.ReleaseItem(item);

				decayMap.erase(it);
			}
			return;
		}
		while (i < end) {
			if (item == decayItems[i]) {
				if (item->hasAttribute(ITEM_ATTRIBUTE_DURATION)) {
					//Incase we removed duration attribute don't assign new duration
					item->setDuration(item->getDuration());
				}
				item->removeAttribute(ITEM_ATTRIBUTE_DECAYSTATE);
				g_game.ReleaseItem(item);

				std::swap(decayItems[i], decayItems.back());
				decayItems.pop_back();
				return;
			}
			++i;
		}
	}
}

void Decay::checkDecay()
{
	int64_t timestamp = OTSYS_TIME();

	std::vector<Item*> tempItems;
	tempItems.reserve(32);// Small preallocation

	auto it = decayMap.begin(), end = decayMap.end();
	while (it != end) {
		if (it->first > timestamp) {
			break;
		}

		// Iterating here is unsafe so let's copy our items into temporary vector
		std::vector<Item*>& decayItems = it->second;
		tempItems.insert(tempItems.end(), decayItems.begin(), decayItems.end());
		it = decayMap.erase(it);
	}

	for (Item* item : tempItems) {
		if (!item->canDecay()) {
			item->setDuration(item->getDuration());
			item->setDecaying(DECAYING_FALSE);
		} else {
			item->setDecaying(DECAYING_FALSE);
			g_game.internalDecayItem(item);
		}

		g_game.ReleaseItem(item);
	}

	if (it != end) {
		eventId = g_scheduler.addEvent(createSchedulerTask(std::max<int32_t>(SCHEDULER_MINTICKS, static_cast<int32_t>(it->first - timestamp)), std::bind(&Decay::checkDecay, this)));
	}
}