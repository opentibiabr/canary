/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/creature/raids.hpp"

#include "config/configmanager.hpp"
#include "creatures/monsters/monster.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "server/network/webhook/webhook.hpp"
#include "utils/pugicast.hpp"

Raids::Raids() {
	scriptInterface.initState();
}

bool Raids::loadFromXml() {
	if (g_configManager().getBoolean(DISABLE_LEGACY_RAIDS) || isLoaded()) {
		return true;
	}

	pugi::xml_document doc;
	auto folder = g_configManager().getString(DATA_DIRECTORY) + "/raids/raids.xml";
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	for (const auto &raidNode : doc.child("raids").children()) {
		std::string name, file;
		uint32_t interval, margin;

		pugi::xml_attribute attr;
		if ((attr = raidNode.attribute("name"))) {
			name = attr.as_string();
		} else {
			g_logger().error("{} - Name tag missing for raid", __FUNCTION__);
			continue;
		}

		if ((attr = raidNode.attribute("file"))) {
			file = attr.as_string();
		} else {
			std::ostringstream ss;
			ss << "raids/" << name << ".xml";
			file = ss.str();
			g_logger().warn("{} - "
			                "'file' tag missing for raid: {} using default: {}",
			                __FUNCTION__, name, file);
		}

		interval = pugi::cast<uint32_t>(raidNode.attribute("interval2").value()) * 60;
		if (interval == 0) {
			g_logger().error("{} - "
			                 "'interval2' tag missing or zero "
			                 "(would divide by 0) for raid: {}",
			                 __FUNCTION__, name);
			continue;
		}

		if ((attr = raidNode.attribute("margin"))) {
			margin = pugi::cast<uint32_t>(attr.value()) * 60 * 1000;
		} else {
			g_logger().warn("{} - "
			                "'margin' tag missing for raid: {}",
			                __FUNCTION__, name);
			margin = 0;
		}

		bool repeat;
		if ((attr = raidNode.attribute("repeat"))) {
			repeat = booleanString(attr.as_string());
		} else {
			repeat = false;
		}

		auto newRaid = std::make_shared<Raid>(name, interval, margin, repeat);
		if (newRaid->loadFromXml(g_configManager().getString(DATA_DIRECTORY) + "/raids/" + file)) {
			raidList.push_back(newRaid);
		} else {
			g_logger().error("{} - Failed to load raid: {}", __FUNCTION__, name);
		}
	}

	loaded = true;
	return true;
}

static constexpr int32_t MAX_RAND_RANGE = 10000000;

bool Raids::startup() {
	if (!isLoaded() || isStarted() || g_configManager().getBoolean(DISABLE_LEGACY_RAIDS)) {
		return false;
	}

	setLastRaidEnd(OTSYS_TIME());

	checkRaidsEvent = g_dispatcher().scheduleEvent(
		CHECK_RAIDS_INTERVAL * 1000, [this] { checkRaids(); }, "Raids::checkRaids"
	);

	started = true;
	return started;
}

void Raids::checkRaids() {
	if (g_configManager().getBoolean(DISABLE_LEGACY_RAIDS)) {
		return;
	}
	if (!getRunning()) {
		const uint64_t now = OTSYS_TIME();

		for (auto it = raidList.begin(), end = raidList.end(); it != end; ++it) {
			const auto &raid = *it;
			if (now >= (getLastRaidEnd() + raid->getMargin())) {
				const auto roll = static_cast<uint32_t>(uniform_random(0, MAX_RAND_RANGE));
				const auto required = static_cast<uint32_t>(MAX_RAND_RANGE * raid->getInterval()) / CHECK_RAIDS_INTERVAL;
				const auto shouldStart = required >= roll;
				if (shouldStart) {
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

	checkRaidsEvent = g_dispatcher().scheduleEvent(
		CHECK_RAIDS_INTERVAL * 1000, [this] { checkRaids(); }, "Raids::checkRaids"
	);
}

void Raids::clear() {
	g_dispatcher().stopEvent(checkRaidsEvent);
	checkRaidsEvent = 0;

	for (const auto &raid : raidList) {
		raid->stopEvents();
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

std::shared_ptr<Raid> Raids::getRaidByName(const std::string &name) const {
	for (const auto &raid : raidList) {
		if (strcasecmp(raid->getName().c_str(), name.c_str()) == 0) {
			return raid;
		}
	}
	return nullptr;
}

bool Raid::loadFromXml(const std::string &filename) {
	if (isLoaded()) {
		return true;
	}

	pugi::xml_document doc;
	const pugi::xml_parse_result result = doc.load_file(filename.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, filename, result);
		return false;
	}

	for (const auto &eventNode : doc.child("raid").children()) {
		std::shared_ptr<RaidEvent> event;
		if (strcasecmp(eventNode.name(), "announce") == 0) {
			event = std::make_shared<AnnounceEvent>();
		} else if (strcasecmp(eventNode.name(), "singlespawn") == 0) {
			event = std::make_shared<SingleSpawnEvent>();
		} else if (strcasecmp(eventNode.name(), "areaspawn") == 0) {
			event = std::make_shared<AreaSpawnEvent>();
		} else if (strcasecmp(eventNode.name(), "script") == 0) {
			event = std::make_shared<ScriptEvent>(&g_game().raids.getScriptInterface());
		} else {
			continue;
		}

		if (event->configureRaidEvent(eventNode)) {
			raidEvents.push_back(event);
		} else {
			g_logger().error("{} - "
			                 "In file: {}, eventNode: {}",
			                 __FUNCTION__, filename, eventNode.name());
		}
	}

	// sort by delay time
	std::ranges::sort(raidEvents, [](const std::shared_ptr<RaidEvent> &lhs, const std::shared_ptr<RaidEvent> &rhs) {
		return lhs->getDelay() < rhs->getDelay();
	});

	loaded = true;
	return true;
}

void Raid::startRaid() {
	const auto raidEvent = getNextRaidEvent();
	if (raidEvent) {
		state = RAIDSTATE_EXECUTING;
		nextEventEvent = g_dispatcher().scheduleEvent(
			raidEvent->getDelay(), [this, raidEvent] { executeRaidEvent(raidEvent); }, "Raid::executeRaidEvent"
		);
	} else {
		g_logger().warn("[raids] Raid {} has no events", name);
		resetRaid();
	}
}

void Raid::executeRaidEvent(const std::shared_ptr<RaidEvent> &raidEvent) {
	if (raidEvent->executeEvent()) {
		nextEvent++;
		const auto newRaidEvent = getNextRaidEvent();

		if (newRaidEvent) {
			const uint32_t ticks = static_cast<uint32_t>(std::max<int32_t>(RAID_MINTICKS, newRaidEvent->getDelay() - raidEvent->getDelay()));
			nextEventEvent = g_dispatcher().scheduleEvent(
				ticks, [this, newRaidEvent] { executeRaidEvent(newRaidEvent); }, __FUNCTION__
			);
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
		g_dispatcher().stopEvent(nextEventEvent);
		nextEventEvent = 0;
	}
}

std::shared_ptr<RaidEvent> Raid::getNextRaidEvent() {
	if (nextEvent < raidEvents.size()) {
		return raidEvents[nextEvent];
	} else {
		return nullptr;
	}
}

bool RaidEvent::configureRaidEvent(const pugi::xml_node &eventNode) {
	const pugi::xml_attribute delayAttribute = eventNode.attribute("delay");
	if (!delayAttribute) {
		g_logger().error("{} - 'delay' tag missing", __FUNCTION__);
		return false;
	}

	delay = std::max<uint32_t>(RAID_MINTICKS, pugi::cast<uint32_t>(delayAttribute.value()));
	return true;
}

bool AnnounceEvent::configureRaidEvent(const pugi::xml_node &eventNode) {
	if (!RaidEvent::configureRaidEvent(eventNode)) {
		return false;
	}

	const pugi::xml_attribute messageAttribute = eventNode.attribute("message");
	if (!messageAttribute) {
		g_logger().error("{} - "
		                 "'message' tag missing for announce event",
		                 __FUNCTION__);
		return false;
	}
	message = messageAttribute.as_string();

	const pugi::xml_attribute typeAttribute = eventNode.attribute("type");
	if (typeAttribute) {
		const std::string tmpStrValue = asLowerCaseString(typeAttribute.as_string());
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
			g_logger().warn("{} - "
			                "Unknown type tag missing for announce event, "
			                "using default: {}",
			                __FUNCTION__, static_cast<uint32_t>(messageType));
		}
	} else {
		messageType = MESSAGE_EVENT_ADVANCE;
		g_logger().warn("{} - "
		                "Type tag missing for announce event, "
		                "using default: {}",
		                __FUNCTION__, static_cast<uint32_t>(messageType));
	}
	return true;
}

bool AnnounceEvent::executeEvent() {
	g_game().broadcastMessage(message, messageType);
	g_webhook().sendMessage(fmt::format(":space_invader: {}", message));
	return true;
}

bool SingleSpawnEvent::configureRaidEvent(const pugi::xml_node &eventNode) {
	if (!RaidEvent::configureRaidEvent(eventNode)) {
		return false;
	}

	pugi::xml_attribute attr;
	if ((attr = eventNode.attribute("name"))) {
		monsterName = attr.as_string();
	} else {
		g_logger().error("{} - "
		                 "'Name' tag missing for singlespawn event",
		                 __FUNCTION__);
		return false;
	}

	if ((attr = eventNode.attribute("x"))) {
		position.x = pugi::cast<uint16_t>(attr.value());
	} else {
		g_logger().error("{} - "
		                 "'X' tag missing for singlespawn event",
		                 __FUNCTION__);
		return false;
	}

	if ((attr = eventNode.attribute("y"))) {
		position.y = pugi::cast<uint16_t>(attr.value());
	} else {
		g_logger().error("{} - "
		                 "'Y' tag missing for singlespawn event",
		                 __FUNCTION__);
		return false;
	}

	if ((attr = eventNode.attribute("z"))) {
		position.z = pugi::cast<uint16_t>(attr.value());
	} else {
		g_logger().error("{} - "
		                 "'Z' tag missing for singlespawn event",
		                 __FUNCTION__);
		return false;
	}
	return true;
}

bool SingleSpawnEvent::executeEvent() {
	const auto &monster = Monster::createMonster(monsterName);
	if (!monster) {
		g_logger().error("{} - Cant create monster {}", __FUNCTION__, monsterName);
		return false;
	}

	if (!g_game().placeCreature(monster, position, false, true)) {
		g_logger().error("{} - Cant create monster {}", __FUNCTION__, monsterName);
		return false;
	}

	monster->setForgeMonster(false);
	monster->onSpawn(position);
	return true;
}

bool AreaSpawnEvent::configureRaidEvent(const pugi::xml_node &eventNode) {
	if (!RaidEvent::configureRaidEvent(eventNode)) {
		return false;
	}

	pugi::xml_attribute attr;
	if ((attr = eventNode.attribute("radius"))) {
		const auto radius = pugi::cast<int32_t>(attr.value());
		Position centerPos;

		if ((attr = eventNode.attribute("centerx"))) {
			centerPos.x = pugi::cast<uint16_t>(attr.value());
		} else {
			g_logger().error("{} - "
			                 ""
			                 "'centerx' tag missing for areaspawn event",
			                 __FUNCTION__);
			return false;
		}

		if ((attr = eventNode.attribute("centery"))) {
			centerPos.y = pugi::cast<uint16_t>(attr.value());
		} else {
			g_logger().error("{} - "
			                 "'centery' tag missing for areaspawn event",
			                 __FUNCTION__);
			return false;
		}

		if ((attr = eventNode.attribute("centerz"))) {
			centerPos.z = pugi::cast<uint16_t>(attr.value());
		} else {
			g_logger().error("{} - "
			                 "centerz' tag missing for areaspawn event",
			                 __FUNCTION__);
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
			g_logger().error("{} - "
			                 "'fromx' tag missing for areaspawn event",
			                 __FUNCTION__);
			return false;
		}

		if ((attr = eventNode.attribute("fromy"))) {
			fromPos.y = pugi::cast<uint16_t>(attr.value());
		} else {
			g_logger().error("{} - "
			                 "'fromy' tag missing for areaspawn event",
			                 __FUNCTION__);
			return false;
		}

		if ((attr = eventNode.attribute("fromz"))) {
			fromPos.z = pugi::cast<uint16_t>(attr.value());
		} else {
			g_logger().error("{} - "
			                 "'fromz' tag missing for areaspawn event",
			                 __FUNCTION__);
			return false;
		}

		if ((attr = eventNode.attribute("tox"))) {
			toPos.x = pugi::cast<uint16_t>(attr.value());
		} else {
			g_logger().error("{} - "
			                 "'tox' tag missing for areaspawn event",
			                 __FUNCTION__);
			return false;
		}

		if ((attr = eventNode.attribute("toy"))) {
			toPos.y = pugi::cast<uint16_t>(attr.value());
		} else {
			g_logger().error("{} - "
			                 "'toy' tag missing for areaspawn event",
			                 __FUNCTION__);
			return false;
		}

		if ((attr = eventNode.attribute("toz"))) {
			toPos.z = pugi::cast<uint16_t>(attr.value());
		} else {
			g_logger().error("{} - "
			                 "'toz' tag missing for areaspawn event",
			                 __FUNCTION__);
			return false;
		}
	}

	for (const auto &monsterNode : eventNode.children()) {
		const char* name;

		if ((attr = monsterNode.attribute("name"))) {
			name = attr.value();
		} else {
			g_logger().error("{} - "
			                 "'name' tag missing for monster node",
			                 __FUNCTION__);
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
				g_logger().error("{} - "
				                 "'amount' tag missing for monster node",
				                 __FUNCTION__);
				return false;
			}
		}

		spawnMonsterList.emplace_back(name, minAmount, maxAmount);
	}
	return true;
}

bool AreaSpawnEvent::executeEvent() {
	for (const MonsterSpawn &spawn : spawnMonsterList) {
		const uint32_t amount = uniform_random(spawn.minAmount, spawn.maxAmount);
		for (uint32_t i = 0; i < amount; ++i) {
			const std::shared_ptr<Monster> &monster = Monster::createMonster(spawn.name);
			if (!monster) {
				g_logger().error("{} - Can't create monster {}", __FUNCTION__, spawn.name);
				return false;
			}

			for (int32_t tries = 0; tries < MAXIMUM_TRIES_PER_MONSTER; tries++) {
				const auto &tile = g_game().map.getTile(static_cast<uint16_t>(uniform_random(fromPos.x, toPos.x)), static_cast<uint16_t>(uniform_random(fromPos.y, toPos.y)), static_cast<uint8_t>(uniform_random(fromPos.z, toPos.z)));
				if (!tile) {
					continue;
				}

				const auto &topCreature = tile->getTopCreature();
				if (!tile->isMovableBlocking() && !tile->hasFlag(TILESTATE_PROTECTIONZONE) && topCreature == nullptr && g_game().placeCreature(monster, tile->getPosition(), false, true)) {
					monster->setForgeMonster(false);
					break;
				}
			}
		}
	}
	return true;
}

bool ScriptEvent::configureRaidEvent(const pugi::xml_node &eventNode) {
	if (!RaidEvent::configureRaidEvent(eventNode)) {
		return false;
	}

	const pugi::xml_attribute scriptAttribute = eventNode.attribute("script");
	if (!scriptAttribute) {
		g_logger().error("{} - "
		                 "No script file found for raid",
		                 __FUNCTION__);
		return false;
	}

	std::string scriptName = std::string(scriptAttribute.as_string());

	if (!loadScript(g_configManager().getString(DATA_DIRECTORY) + "/raids/scripts/" + scriptName, scriptName)) {
		g_logger().error("[{}] can not load raid script: {}", __FUNCTION__, scriptName);
		return false;
	}

	setScriptName(scriptName);

	return true;
}

std::string ScriptEvent::getScriptEventName() const {
	return "onRaid";
}

bool ScriptEvent::executeEvent() {
	// onRaid()
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("{} - Script with name {} "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 __FUNCTION__, getScriptName());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(scriptId, scriptInterface);

	scriptInterface->pushFunction(scriptId);

	return scriptInterface->callFunction(0);
}
