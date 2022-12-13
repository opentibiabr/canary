/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
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

#include "pch.hpp"

#include "lua/creature/raids.h"
#include "utils/pugicast.h"
#include "game/game.h"
#include "game/scheduling/scheduler.h"
#include "creatures/monsters/monster.h"
#include "server/network/webhook/webhook.h"

Raids::Raids() {
	scriptInterface.initState();
}

Raids::~Raids() {
	for (Raid* raid : raidList) {
		delete raid;
	}
}

bool Raids::loadFromXml() {
	if (isLoaded()) {
		return true;
	}

	pugi::xml_document doc;
	auto folder = g_configManager().getString(DATA_DIRECTORY) + "/raids/raids.xml";
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	for (auto raidNode : doc.child("raids").children()) {
		std::string name, file;
		uint32_t interval, margin;

		pugi::xml_attribute attr;
		if ((attr = raidNode.attribute("name"))) {
			name = attr.as_string();
		} else {
			SPDLOG_ERROR("{} - Name tag missing for raid", __FUNCTION__);
			continue;
		}

		if ((attr = raidNode.attribute("file"))) {
			file = attr.as_string();
		} else {
			std::ostringstream ss;
			ss << "raids/" << name << ".xml";
			file = ss.str();
			SPDLOG_WARN("{} - "
						"'file' tag missing for raid: {} using default: {}",
						__FUNCTION__, name, file);
		}

		interval = pugi::cast<uint32_t>(raidNode.attribute("interval2").value()) * 60;
		if (interval == 0) {
			SPDLOG_ERROR("{} - "
                         "'interval2' tag missing or zero "
                         "(would divide by 0) for raid: {}", __FUNCTION__, name);
			continue;
		}

		if ((attr = raidNode.attribute("margin"))) {
			margin = pugi::cast<uint32_t>(attr.value()) * 60 * 1000;
		} else {
			SPDLOG_WARN("{} - "
						"'margin' tag missing for raid: {}", __FUNCTION__, name);
			margin = 0;
		}

		bool repeat;
		if ((attr = raidNode.attribute("repeat"))) {
			repeat = booleanString(attr.as_string());
		} else {
			repeat = false;
		}

		Raid* newRaid = new Raid(name, interval, margin, repeat);
		if (newRaid->loadFromXml(g_configManager().getString(DATA_DIRECTORY) + "/raids/" + file)) {
			raidList.push_back(newRaid);
		} else {
			SPDLOG_ERROR("{} - Failed to load raid: {}", __FUNCTION__, name);
			delete newRaid;
		}
	}

	loaded = true;
	return true;
}

static constexpr int32_t MAX_RAND_RANGE = 10000000;

bool Raids::startup() {
	if (!isLoaded() || isStarted()) {
		return false;
	}

	setLastRaidEnd(OTSYS_TIME());

	checkRaidsEvent = g_scheduler().addEvent(createSchedulerTask(CHECK_RAIDS_INTERVAL * 1000, std::bind(&Raids::checkRaids, this)));

	started = true;
	return started;
}

void Raids::checkRaids() {
	if (!getRunning()) {
		uint64_t now = OTSYS_TIME();

		for (auto it = raidList.begin(), end = raidList.end(); it != end; ++it) {
			Raid* raid = *it;
			if (now >= (getLastRaidEnd() + raid->getMargin())) {
				if (((MAX_RAND_RANGE * CHECK_RAIDS_INTERVAL) / raid->getInterval()) >= static_cast<uint32_t>(uniform_random(0, static_cast<int64_t>(MAX_RAND_RANGE)))) {
					setRunning(raid);
					raid->startRaid();

					if (!raid->canBeRepeated()) {
						raidList.erase(it);
					}
					break;
				}
			}
		}
	}

	checkRaidsEvent = g_scheduler().addEvent(createSchedulerTask(CHECK_RAIDS_INTERVAL * 1000, std::bind(&Raids::checkRaids, this)));
}

void Raids::clear() {
	g_scheduler().stopEvent(checkRaidsEvent);
	checkRaidsEvent = 0;

	for (Raid* raid : raidList) {
		raid->stopEvents();
		delete raid;
	}
	raidList.clear();

	loaded = false;
	started = false;
	running = nullptr;
	lastRaidEnd = 0;

	scriptInterface.reInitState();
}

bool Raids::reload() {
	clear();
	return loadFromXml();
}

Raid* Raids::getRaidByName(const std::string& name) {
	for (Raid* raid : raidList) {
		if (strcasecmp(raid->getName().c_str(), name.c_str()) == 0) {
			return raid;
		}
	}
	return nullptr;
}

Raid::~Raid() {
	for (RaidEvent* raidEvent : raidEvents) {
		delete raidEvent;
	}
}

bool Raid::loadFromXml(const std::string& filename) {
	if (isLoaded()) {
		return true;
	}

	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file(filename.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, filename, result);
		return false;
	}

	for (auto eventNode : doc.child("raid").children()) {
		RaidEvent* event;
		if (strcasecmp(eventNode.name(), "announce") == 0) {
			event = new AnnounceEvent();
		} else if (strcasecmp(eventNode.name(), "singlespawn") == 0) {
			event = new SingleSpawnEvent();
		} else if (strcasecmp(eventNode.name(), "areaspawn") == 0) {
			event = new AreaSpawnEvent();
		} else if (strcasecmp(eventNode.name(), "script") == 0) {
			event = new ScriptEvent(&g_game().raids.getScriptInterface());
		} else {
			continue;
		}

		if (event->configureRaidEvent(eventNode)) {
			raidEvents.push_back(event);
		} else {
			SPDLOG_ERROR("{} - "
                         "In file: {}, eventNode: {}", __FUNCTION__, filename, eventNode.name());
			delete event;
		}
	}

	//sort by delay time
	std::sort(raidEvents.begin(), raidEvents.end(), [](const RaidEvent* lhs, const RaidEvent* rhs) {
		return lhs->getDelay() < rhs->getDelay();
	});

	loaded = true;
	return true;
}

void Raid::startRaid() {
	RaidEvent* raidEvent = getNextRaidEvent();
	if (raidEvent) {
		state = RAIDSTATE_EXECUTING;
		nextEventEvent = g_scheduler().addEvent(createSchedulerTask(raidEvent->getDelay(), std::bind(&Raid::executeRaidEvent, this, raidEvent)));
	}
}

void Raid::executeRaidEvent(RaidEvent* raidEvent) {
	if (raidEvent->executeEvent()) {
		nextEvent++;
		RaidEvent* newRaidEvent = getNextRaidEvent();

		if (newRaidEvent) {
			uint32_t ticks = static_cast<uint32_t>(std::max<int32_t>(RAID_MINTICKS, newRaidEvent->getDelay() - raidEvent->getDelay()));
			nextEventEvent = g_scheduler().addEvent(createSchedulerTask(ticks, std::bind(&Raid::executeRaidEvent, this, newRaidEvent)));
		} else {
			resetRaid();
		}
	} else {
		resetRaid();
	}
}

void Raid::resetRaid() {
	nextEvent = 0;
	state = RAIDSTATE_IDLE;
	g_game().raids.setRunning(nullptr);
	g_game().raids.setLastRaidEnd(OTSYS_TIME());
}

void Raid::stopEvents() {
	if (nextEventEvent != 0) {
		g_scheduler().stopEvent(nextEventEvent);
		nextEventEvent = 0;
	}
}

RaidEvent* Raid::getNextRaidEvent() {
	if (nextEvent < raidEvents.size()) {
		return raidEvents[nextEvent];
	} else {
		return nullptr;
	}
}

bool RaidEvent::configureRaidEvent(const pugi::xml_node& eventNode) {
	pugi::xml_attribute delayAttribute = eventNode.attribute("delay");
	if (!delayAttribute) {
		SPDLOG_ERROR("{} - 'delay' tag missing", __FUNCTION__);
		return false;
	}

	delay = std::max<uint32_t>(RAID_MINTICKS, pugi::cast<uint32_t>(delayAttribute.value()));
	return true;
}

bool AnnounceEvent::configureRaidEvent(const pugi::xml_node& eventNode) {
	if (!RaidEvent::configureRaidEvent(eventNode)) {
		return false;
	}

	pugi::xml_attribute messageAttribute = eventNode.attribute("message");
	if (!messageAttribute) {
		SPDLOG_ERROR("{} - "
                    "'message' tag missing for announce event", __FUNCTION__);
		return false;
	}
	message = messageAttribute.as_string();

	pugi::xml_attribute typeAttribute = eventNode.attribute("type");
	if (typeAttribute) {
		std::string tmpStrValue = asLowerCaseString(typeAttribute.as_string());
		if (tmpStrValue == "warning") {
			messageType = MESSAGE_GAME_HIGHLIGHT;
		} else if (tmpStrValue == "event") {
			messageType = MESSAGE_EVENT_ADVANCE;
		} else if (tmpStrValue == "default") {
			messageType = MESSAGE_EVENT_ADVANCE;
		} else if (tmpStrValue == "description") {
			messageType = MESSAGE_LOOK;
		} else if (tmpStrValue == "smallstatus") {
			messageType = MESSAGE_FAILURE;
		} else if (tmpStrValue == "redconsole") {
			messageType = MESSAGE_GAMEMASTER_CONSOLE;
		} else {
			SPDLOG_WARN("{} - "
						"Unknown type tag missing for announce event, "
						"using default: {}", __FUNCTION__,
						static_cast<uint32_t>(messageType));
		}
	} else {
		messageType = MESSAGE_EVENT_ADVANCE;
		SPDLOG_WARN("{} - "
					"Type tag missing for announce event, "
					"using default: {}", __FUNCTION__,
					static_cast<uint32_t>(messageType));
	}
	return true;
}

bool AnnounceEvent::executeEvent() {
	std::string url = g_configManager().getString(DISCORD_WEBHOOK_URL);
	g_game().broadcastMessage(message, messageType);
	webhook_send_message("Incoming raid!", message, WEBHOOK_COLOR_RAID, url);
	return true;
}

bool SingleSpawnEvent::configureRaidEvent(const pugi::xml_node& eventNode) {
	if (!RaidEvent::configureRaidEvent(eventNode)) {
		return false;
	}

	pugi::xml_attribute attr;
	if ((attr = eventNode.attribute("name"))) {
		monsterName = attr.as_string();
	} else {
		SPDLOG_ERROR("{} - "
                    "'Name' tag missing for singlespawn event", __FUNCTION__);
		return false;
	}

	if ((attr = eventNode.attribute("x"))) {
		position.x = pugi::cast<uint16_t>(attr.value());
	} else {
		SPDLOG_ERROR("{} - "
                    "'X' tag missing for singlespawn event", __FUNCTION__);
		return false;
	}

	if ((attr = eventNode.attribute("y"))) {
		position.y = pugi::cast<uint16_t>(attr.value());
	} else {
		SPDLOG_ERROR("{} - "
                    "'Y' tag missing for singlespawn event", __FUNCTION__);
		return false;
	}

	if ((attr = eventNode.attribute("z"))) {
		position.z = pugi::cast<uint16_t>(attr.value());
	} else {
		SPDLOG_ERROR("{} - "
                    "'Z' tag missing for singlespawn event", __FUNCTION__);
		return false;
	}
	return true;
}

bool SingleSpawnEvent::executeEvent() {
	Monster* monster = Monster::createMonster(monsterName);
	if (!monster) {
		SPDLOG_ERROR("{} - Cant create monster {}", __FUNCTION__,
                    monsterName);
		return false;
	}

	if (!g_game().placeCreature(monster, position, false, true)) {
		delete monster;
		SPDLOG_ERROR("{} - Cant create monster {}", __FUNCTION__,
                    monsterName);
		return false;
	}

	monster->setForgeMonster(false);
	return true;
}

bool AreaSpawnEvent::configureRaidEvent(const pugi::xml_node& eventNode) {
	if (!RaidEvent::configureRaidEvent(eventNode)) {
		return false;
	}

	pugi::xml_attribute attr;
	if ((attr = eventNode.attribute("radius"))) {
		int32_t radius = pugi::cast<int32_t>(attr.value());
		Position centerPos;

		if ((attr = eventNode.attribute("centerx"))) {
			centerPos.x = pugi::cast<uint16_t>(attr.value());
		} else {
			SPDLOG_ERROR("{} - "
                         ""
                         "'centerx' tag missing for areaspawn event", __FUNCTION__);
			return false;
		}

		if ((attr = eventNode.attribute("centery"))) {
			centerPos.y = pugi::cast<uint16_t>(attr.value());
		} else {
			SPDLOG_ERROR("{} - "
                         "'centery' tag missing for areaspawn event", __FUNCTION__);
			return false;
		}

		if ((attr = eventNode.attribute("centerz"))) {
			centerPos.z = pugi::cast<uint16_t>(attr.value());
		} else {
			SPDLOG_ERROR("{} - "
                         "centerz' tag missing for areaspawn event", __FUNCTION__);
			return false;
		}

		fromPos.x = std::max<int32_t>(0, centerPos.getX() - radius);
		fromPos.y = std::max<int32_t>(0, centerPos.getY() - radius);
		fromPos.z = centerPos.z;

		toPos.x = std::min<int32_t>(0xFFFF, centerPos.getX() + radius);
		toPos.y = std::min<int32_t>(0xFFFF, centerPos.getY() + radius);
		toPos.z = centerPos.z;
	} else {
		if ((attr = eventNode.attribute("fromx"))) {
			fromPos.x = pugi::cast<uint16_t>(attr.value());
		} else {
			SPDLOG_ERROR("{} - "
                         "'fromx' tag missing for areaspawn event", __FUNCTION__);
			return false;
		}

		if ((attr = eventNode.attribute("fromy"))) {
			fromPos.y = pugi::cast<uint16_t>(attr.value());
		} else {
			SPDLOG_ERROR("{} - "
                         "'fromy' tag missing for areaspawn event", __FUNCTION__);
			return false;
		}

		if ((attr = eventNode.attribute("fromz"))) {
			fromPos.z = pugi::cast<uint16_t>(attr.value());
		} else {
			SPDLOG_ERROR("{} - "
                         "'fromz' tag missing for areaspawn event", __FUNCTION__);
			return false;
		}

		if ((attr = eventNode.attribute("tox"))) {
			toPos.x = pugi::cast<uint16_t>(attr.value());
		} else {
			SPDLOG_ERROR("{} - "
                         "'tox' tag missing for areaspawn event", __FUNCTION__);
			return false;
		}

		if ((attr = eventNode.attribute("toy"))) {
			toPos.y = pugi::cast<uint16_t>(attr.value());
		} else {
			SPDLOG_ERROR("{} - "
                         "'toy' tag missing for areaspawn event", __FUNCTION__);
			return false;
		}

		if ((attr = eventNode.attribute("toz"))) {
			toPos.z = pugi::cast<uint16_t>(attr.value());
		} else {
			SPDLOG_ERROR("{} - "
                         "'toz' tag missing for areaspawn event", __FUNCTION__);
			return false;
		}
	}

	for (auto monsterNode : eventNode.children()) {
		const char* name;

		if ((attr = monsterNode.attribute("name"))) {
			name = attr.value();
		} else {
			SPDLOG_ERROR("{} - "
                         "'name' tag missing for monster node", __FUNCTION__);
			return false;
		}

		uint32_t minAmount;
		if ((attr = monsterNode.attribute("minamount"))) {
			minAmount = pugi::cast<uint32_t>(attr.value());
		} else {
			minAmount = 0;
		}

		uint32_t maxAmount;
		if ((attr = monsterNode.attribute("maxamount"))) {
			maxAmount = pugi::cast<uint32_t>(attr.value());
		} else {
			maxAmount = 0;
		}

		if (maxAmount == 0 && minAmount == 0) {
			if ((attr = monsterNode.attribute("amount"))) {
				minAmount = pugi::cast<uint32_t>(attr.value());
				maxAmount = minAmount;
			} else {
				SPDLOG_ERROR("{} - "
                         "'amount' tag missing for monster node", __FUNCTION__);
				return false;
			}
		}

		spawnMonsterList.emplace_back(name, minAmount, maxAmount);
	}
	return true;
}

bool AreaSpawnEvent::executeEvent() {
	for (const MonsterSpawn& spawn : spawnMonsterList) {
		uint32_t amount = static_cast<uint32_t>(uniform_random(static_cast<int64_t>(spawn.minAmount), static_cast<int64_t>(spawn.maxAmount)));
		for (uint32_t i = 0; i < amount; ++i) {
			Monster* monster = Monster::createMonster(spawn.name);
			if (!monster) {
				SPDLOG_ERROR("{} - Can't create monster {}", __FUNCTION__,
                              spawn.name);
				return false;
			}

			bool success = false;
			for (int32_t tries = 0; tries < MAXIMUM_TRIES_PER_MONSTER; tries++) {
				const Tile* tile = g_game().map.getTile(static_cast<uint16_t>(uniform_random(static_cast<int64_t>(fromPos.x), static_cast<int64_t>(toPos.x))), static_cast<uint16_t>(uniform_random(static_cast<int64_t>(fromPos.y), static_cast<int64_t>(toPos.y))), static_cast<uint8_t>(uniform_random(static_cast<int64_t>(fromPos.z), static_cast<int64_t>(toPos.z))));
				if (tile && !tile->isMoveableBlocking() && !tile->hasFlag(TILESTATE_PROTECTIONZONE) && tile->getTopCreature() == nullptr && g_game().placeCreature(monster, tile->getPosition(), false, true)) {
					success = true;
					monster->setForgeMonster(false);
					break;
				}
			}

			if (!success) {
				delete monster;
			}
		}
	}
	return true;
}

bool ScriptEvent::configureRaidEvent(const pugi::xml_node& eventNode) {
	if (!RaidEvent::configureRaidEvent(eventNode)) {
		return false;
	}

	pugi::xml_attribute scriptAttribute = eventNode.attribute("script");
	if (!scriptAttribute) {
		SPDLOG_ERROR("{} - "
                    "No script file found for raid", __FUNCTION__);
		return false;
	}

	std::string scriptName = std::string(scriptAttribute.as_string());

	if (!loadScript(g_configManager().getString(DATA_DIRECTORY) + "/raids/scripts/" + scriptName)) {
		SPDLOG_ERROR("{} - "
                    "Can not load raid script: {}", __FUNCTION__, scriptName);
		return false;
	}

	setScriptName(scriptName);

	return true;
}

std::string ScriptEvent::getScriptEventName() const {
	return "onRaid";
}

bool ScriptEvent::executeEvent() {
	//onRaid()
	if (!scriptInterface->reserveScriptEnv()) {
		SPDLOG_ERROR("{} - Script with name {} "
                    "Call stack overflow. Too many lua script calls being nested.",
                    __FUNCTION__,
                    getScriptName());
		return false;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	env->setScriptId(scriptId, scriptInterface);

	scriptInterface->pushFunction(scriptId);

	return scriptInterface->callFunction(0);
}
