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

#include "lua/creature/actions.h"
#include "items/bed.h"
#include "items/containers/container.h"
#include "game/game.h"
#include "utils/pugicast.h"
#include "creatures/combat/spells.h"
#include "items/containers/rewards/rewardchest.h"

Actions::Actions() :
	scriptInterface("Action Interface") {
	scriptInterface.initState();
}

Actions::~Actions() = default;

void Actions::clearMap(ActionUseMap& map, bool fromLua) {
	for (auto it = map.begin(); it != map.end(); ) {
		if (fromLua == it->second.fromLua) {
			it = map.erase(it);
		} else {
			++it;
		}
	}
}

void Actions::clear() {
	useItemMap.clear();
	uniqueItemMap.clear();
	actionItemMap.clear();
	actionPositionMap.clear();
}

void Actions::clear(bool fromLua) {
	clearMap(useItemMap, fromLua);
	clearMap(uniqueItemMap, fromLua);
	clearMap(actionItemMap, fromLua);

	// Clear position map
	for (auto it = actionPositionMap.begin(); it != actionPositionMap.end(); ) {
		if (fromLua == it->second.fromLua) {
			it = actionPositionMap.erase(it);
		} else {
			++it;
		}
	}

	reInitState(fromLua);
}

LuaScriptInterface& Actions::getScriptInterface() {
	return scriptInterface;
}

std::string Actions::getScriptBaseName() const {
	return "actions";
}

Event_ptr Actions::getEvent(const std::string& nodeName) {
	if (strcasecmp(nodeName.c_str(), "action") != 0) {
		return nullptr;
	}
	return Event_ptr(new Action(&scriptInterface));
}

bool Actions::registerEvent(Event_ptr event, const pugi::xml_node& node) {
	//event is guaranteed to be an Action
	Action_ptr action{static_cast<Action*>(event.release())};

	pugi::xml_attribute attr;
	if ((attr = node.attribute("itemid"))) {
		uint16_t id = pugi::cast<uint16_t>(attr.value());

		auto result = useItemMap.emplace(id, std::move(*action));
		if (!result.second) {
			SPDLOG_WARN("[Actions::registerEvent] - Duplicate registered item with "
				"id: {}", id);
		}
		return result.second;
	} else if ((attr = node.attribute("fromid"))) {
		pugi::xml_attribute toIdAttribute = node.attribute("toid");
		if (!toIdAttribute) {
			SPDLOG_WARN("[Actions::registerEvent] - Missing toid in fromid: {}",
				attr.as_string());
			return false;
		}

		uint16_t fromId = pugi::cast<uint16_t>(attr.value());
		uint16_t iterId = fromId;
		uint16_t toId = pugi::cast<uint16_t>(toIdAttribute.value());

		auto result = useItemMap.emplace(iterId, *action);
		if (!result.second) {
			SPDLOG_WARN("[Actions::registerEvent] - Duplicate "
						"registered item with id: {} in fromid: {}, toid: {}", iterId, fromId, toId);
		}

		bool success = result.second;
		while (++iterId <= toId) {
			result = useItemMap.emplace(iterId, *action);
			if (!result.second) {
				SPDLOG_WARN("[Actions::registerEvent] - Duplicate "
							"registered item with id: {} in fromid: {}, toid: {}", iterId, fromId, toId);
				continue;
			}
			success = true;
		}
		return success;
	} else if ((attr = node.attribute("uniqueid"))) {
		uint16_t uid = pugi::cast<uint16_t>(attr.value());

		auto result = uniqueItemMap.emplace(uid, std::move(*action));
		if (!result.second) {
			SPDLOG_WARN("[Actions::registerEvent] - Duplicate "
						"registered item with uniqueid: {}", uid);
		}
		return result.second;
	} else if ((attr = node.attribute("fromuid"))) {
		pugi::xml_attribute toUidAttribute = node.attribute("touid");
		if (!toUidAttribute) {
			SPDLOG_WARN("[Actions::registerEvent] - Missing touid in fromuid: {}",
						attr.as_string());
			return false;
		}

		uint16_t fromUid = pugi::cast<uint16_t>(attr.value());
		uint16_t iterUid = fromUid;
		uint16_t toUid = pugi::cast<uint16_t>(toUidAttribute.value());

		auto result = uniqueItemMap.emplace(iterUid, *action);
		if (!result.second) {
			SPDLOG_WARN("[Actions::registerEvent] - Duplicate "
						"registered item with unique id: {} in fromuid: {}, touid: {}",
						iterUid, fromUid, toUid);
		}

		bool success = result.second;
		while (++iterUid <= toUid) {
			result = uniqueItemMap.emplace(iterUid, *action);
			if (!result.second) {
				SPDLOG_WARN("[Actions::registerEvent] - Duplicate "
							"registered item with unique id: {} in fromuid: {}, touid: {}",
							iterUid, fromUid, toUid);
				continue;
			}
			success = true;
		}
		return success;
	} else if ((attr = node.attribute("actionid"))) {
		uint16_t aid = pugi::cast<uint16_t>(attr.value());

		auto result = actionItemMap.emplace(aid, std::move(*action));
		if (!result.second) {
			SPDLOG_WARN("[Actions::registerEvent] - Duplicate "
						"registered item with actionid: {}", aid);
		}
		return result.second;
	} else if ((attr = node.attribute("fromaid"))) {
		pugi::xml_attribute toAidAttribute = node.attribute("toaid");
		if (!toAidAttribute) {
			SPDLOG_WARN("[Actions::registerEvent()] - Missing toaid in fromaid: {}",
						attr.as_string());
			return false;
		}

		uint16_t fromAid = pugi::cast<uint16_t>(attr.value());
		uint16_t iterAid = fromAid;
		uint16_t toAid = pugi::cast<uint16_t>(toAidAttribute.value());

		auto result = actionItemMap.emplace(iterAid, *action);
		if (!result.second) {
			SPDLOG_WARN("[Actions::registerEvent] - Duplicate "
						"registered item with action id: {} in fromaid: {}, toaid: {}",
						iterAid, fromAid, toAid);
		}

		bool success = result.second;
		while (++iterAid <= toAid) {
			result = actionItemMap.emplace(iterAid, *action);
			if (!result.second) {
				SPDLOG_WARN("[Actions::registerEvent] - Duplicate "
							"registered item with action id: {} in fromaid: {}, toaid: {}",
							iterAid, fromAid, toAid);
				continue;
			}
			success = true;
		}
		return success;
	}
	return false;
}

bool Actions::registerLuaItemEvent(Action* action) {
	auto itemIdVector = action->getItemIdsVector();
	if (itemIdVector.empty()) {
		return false;
	}

	std::for_each(itemIdVector.begin(), itemIdVector.end(), [this, &action, &itemIdVector](uint16_t &itemId) {
		// Check if the item is already registered and prevent it from being registered again
		if (hasItemId(itemId)) {
			SPDLOG_WARN("[Actions::registerLuaItemEvent] - Duplicate "
						"registered item with id: {} in range from id: {}, to id: {}",
						itemId, itemIdVector.at(0), itemIdVector.at(itemIdVector.size() - 1));
			return false;
		}

		// Register item in the action item map
		setItemId(itemId, std::move(*action));
		return true;
	});
	itemIdVector.clear();
	itemIdVector.shrink_to_fit();
	return true;
}

bool Actions::registerLuaUniqueEvent(Action* action) {
	auto uniqueIdVector = action->getUniqueIdsVector();
	if (uniqueIdVector.empty()) {
		return false;
	}

	std::for_each(uniqueIdVector.begin(), uniqueIdVector.end(), [this, &action, &uniqueIdVector](uint16_t &uniqueId) {
		// Check if the unique is already registered and prevent it from being registered again
		if (hasUniqueId(uniqueId)) {
			SPDLOG_WARN("[Actions::registerLuaUniqueEvent] - Duplicate "
						"registered item with uid: {} in range from uid: {}, to uid: {}",
						uniqueId, uniqueIdVector.at(0), uniqueIdVector.at(uniqueIdVector.size() - 1));
			return false;
		}

		// Register unique id the unique item map
		setUniqueId(uniqueId, std::move(*action));
		return true;
	});

	uniqueIdVector.clear();
	uniqueIdVector.shrink_to_fit();
	return true;
}

bool Actions::registerLuaActionEvent(Action* action) {
	auto actionIdVector = action->getActionIdsVector();
	if (actionIdVector.empty()) {
		return false;
	}

	std::for_each(actionIdVector.begin(), actionIdVector.end(), [this, &action, &actionIdVector](uint16_t &actionId) {
		// Check if the unique is already registered and prevent it from being registered again
		if (hasActionId(actionId)) {
			SPDLOG_WARN("[Actions::registerLuaActionEvent] - Duplicate "
						"registered item with aid: {} in range from aid: {}, to aid: {}",
						actionId, actionIdVector.at(0), actionIdVector.at(actionIdVector.size() - 1));
			return false;
		}

		// Register action in the action item map
		setActionId(actionId, std::move(*action));
		return true;
	});

	actionIdVector.clear();
	actionIdVector.shrink_to_fit();
	return true;
}

bool Actions::registerLuaPositionEvent(Action* action) {
	auto positionVector = action->getPositionsVector();
	if (positionVector.empty()) {
		return false;
	}

	for (Position position : positionVector) {
		// Check if the position is already registered and prevent it from being registered again
		if (hasPosition(position)) {
			SPDLOG_WARN("[Actions::registerLuaPositionEvent] - Duplicate "
						"registered script with range position: {}", position.toString());
			continue;
		}

		// Register position in the action position map
		setPosition(position, std::move(*action));
	}

	positionVector.clear();
	positionVector.shrink_to_fit();
	return true;
}

bool Actions::registerLuaEvent(Action* event) {
	Action_ptr action{ event };

	// Call all register lua events
	if (registerLuaItemEvent(event) || registerLuaUniqueEvent(event) || registerLuaActionEvent(event) || registerLuaPositionEvent(event)) {
		return true;
	} else {
		SPDLOG_WARN("[Actions::registerLuaEvent] - "
				"Missing id/aid/uid/position for one script event");
		return false;
	}
	SPDLOG_DEBUG("[Actions::registerLuaEvent] - Missing or incorrect script event");
	return false;
}

ReturnValue Actions::canUse(const Player* player, const Position& pos) {
	if (pos.x != 0xFFFF) {
		const Position& playerPos = player->getPosition();
		if (playerPos.z != pos.z) {
			return playerPos.z > pos.z ? RETURNVALUE_FIRSTGOUPSTAIRS : RETURNVALUE_FIRSTGODOWNSTAIRS;
		}

		if (!Position::areInRange<1, 1>(playerPos, pos)) {
			return RETURNVALUE_TOOFARAWAY;
		}
	}
	return RETURNVALUE_NOERROR;
}

ReturnValue Actions::canUse(const Player* player, const Position& pos, const Item* item) {
	Action* action = getAction(item);
	if (action != nullptr) {
		return action->canExecuteAction(player, pos);
	}
	return RETURNVALUE_NOERROR;
}

ReturnValue Actions::canUseFar(const Creature* creature, const Position& toPos,
										bool checkLineOfSight, bool checkFloor) {
	if (toPos.x == 0xFFFF) {
		return RETURNVALUE_NOERROR;
	}

	const Position& creaturePos = creature->getPosition();
	if (checkFloor && creaturePos.z != toPos.z) {
		return creaturePos.z > toPos.z ?
					RETURNVALUE_FIRSTGOUPSTAIRS : RETURNVALUE_FIRSTGODOWNSTAIRS;
	}

	if (!Position::areInRange<7, 5>(toPos, creaturePos)) {
		return RETURNVALUE_TOOFARAWAY;
	}

	if (checkLineOfSight && !g_game().canThrowObjectTo(creaturePos, toPos)) {
		return RETURNVALUE_CANNOTTHROW;
	}

	return RETURNVALUE_NOERROR;
}

Action* Actions::getAction(const Item* item) {
	if (item->hasAttribute(ITEM_ATTRIBUTE_UNIQUEID)) {
		auto it = uniqueItemMap.find(item->getUniqueId());
		if (it != uniqueItemMap.end()) {
			return &it->second;
		}
	}

	if (item->hasAttribute(ITEM_ATTRIBUTE_ACTIONID)) {
		auto it = actionItemMap.find(item->getActionId());
		if (it != actionItemMap.end()) {
			return &it->second;
		}
	}

	auto it = useItemMap.find(item->getID());
	if (it != useItemMap.end()) {
		return &it->second;
	}


	if (auto iteratePositions = actionPositionMap.find(item->getPosition());
	iteratePositions != actionPositionMap.end())
	{
		if (const Tile * tile = item->getTile();
		tile)
		{
			if (const Player* player = item->getHoldingPlayer();
			player && item->getTopParent() == player)
			{
				SPDLOG_DEBUG("[Actions::getAction] - The position only is valid for use item in the map, player name {}", player->getName());
				return nullptr;
			}

			return &iteratePositions->second;
		}
	}

	//rune items
	return g_spells().getRuneSpell(item->getID());
}

ReturnValue Actions::internalUseItem(Player* player, const Position& pos, uint8_t index, Item* item, bool isHotkey) {
	if (Door* door = item->getDoor()) {
		if (!door->canUse(player)) {
			return RETURNVALUE_CANNOTUSETHISOBJECT;
		}
	}

	Action* action = getAction(item);
	if (action != nullptr) {
		if (action->isScripted()) {
			if (action->executeUse(player, item, pos, nullptr, pos, isHotkey)) {
				return RETURNVALUE_NOERROR;
			}

			if (item->isRemoved()) {
				return RETURNVALUE_CANNOTUSETHISOBJECT;
			}
		} else if (action->function) {
			if (action->function(player, item, pos, nullptr, pos, isHotkey)) {
				return RETURNVALUE_NOERROR;
			}
		}
	}

	if (BedItem* bed = item->getBed()) {
		if (!bed->canUse(player)) {
			return RETURNVALUE_CANNOTUSETHISOBJECT;
		}

		if (bed->trySleep(player)) {
			player->setBedItem(bed);
			g_game().sendOfflineTrainingDialog(player);
		}

		return RETURNVALUE_NOERROR;
	}

	if (Container* container = item->getContainer()) {
		Container* openContainer;

		//depot container
		if (DepotLocker* depot = container->getDepotLocker()) {
			DepotLocker* myDepotLocker = player->getDepotLocker(depot->getDepotId());
			myDepotLocker->setParent(depot->getParent()->getTile());
			openContainer = myDepotLocker;
			player->setLastDepotId(depot->getDepotId());
		} else {
			openContainer = container;
		}

		//reward chest
		if (container->getRewardChest() != nullptr) {
			RewardChest* myRewardChest = player->getRewardChest();
			if (myRewardChest->size() == 0) {
				return RETURNVALUE_REWARDCHESTISEMPTY;
			}

			myRewardChest->setParent(container->getParent()->getTile());
			for (auto& it : player->rewardMap) {
				it.second->setParent(myRewardChest);
			}

			openContainer = myRewardChest;
		}

		//reward container proxy created when the boss dies
		if (container->getID() == ITEM_REWARD_CONTAINER && !container->getReward()) {
			if (Reward* reward = player->getReward(container->getIntAttr(ITEM_ATTRIBUTE_DATE), false)) {
				reward->setParent(container->getRealParent());
				openContainer = reward;
			} else {
				return RETURNVALUE_THISISIMPOSSIBLE;
			}
		}

		uint32_t corpseOwner = container->getCorpseOwner();
		if (container->isRewardCorpse()) {
			//only players who participated in the fight can open the corpse
			if (player->getGroup()->id >= account::GROUP_TYPE_GAMEMASTER || player->getAccountType() >= account::ACCOUNT_TYPE_SENIORTUTOR) {
				return RETURNVALUE_YOUCANTOPENCORPSEADM;
			}
			if (!player->getReward(container->getIntAttr(ITEM_ATTRIBUTE_DATE), false)) {
				return RETURNVALUE_YOUARENOTTHEOWNER;
			}
		} else if (corpseOwner != 0 && !player->canOpenCorpse(corpseOwner)) {
			return RETURNVALUE_YOUARENOTTHEOWNER;
		}

		//open/close container
		int32_t oldContainerId = player->getContainerID(openContainer);
		if (oldContainerId != -1) {
			player->onCloseContainer(openContainer);
			player->closeContainer(oldContainerId);
		} else {
			player->addContainer(index, openContainer);
			player->onSendContainer(openContainer);
		}

		return RETURNVALUE_NOERROR;
	}

	const ItemType& it = Item::items[item->getID()];
	if (it.canReadText) {
		if (it.canWriteText) {
			player->setWriteItem(item, it.maxTextLen);
			player->sendTextWindow(item, it.maxTextLen, true);
		} else {
			player->setWriteItem(nullptr);
			player->sendTextWindow(item, 0, false);
		}

		return RETURNVALUE_NOERROR;
	}

	return RETURNVALUE_CANNOTUSETHISOBJECT;
}

bool Actions::useItem(Player* player, const Position& pos, uint8_t index, Item* item, bool isHotkey) {
	const ItemType& it = Item::items[item->getID()];
	if (it.isRune() || it.type == ITEM_TYPE_POTION) {
		if (player->walkExhausted()) {
			player->sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
			return false;
		}

		player->setNextPotionAction(OTSYS_TIME() + g_configManager().getNumber(ACTIONS_DELAY_INTERVAL));
	} else {
		player->setNextAction(OTSYS_TIME() + g_configManager().getNumber(ACTIONS_DELAY_INTERVAL));
	}

	if (isHotkey) {
		uint16_t subType = item->getSubType();
		showUseHotkeyMessage(player, item, player->getItemTypeCount(item->getID(), subType != item->getItemCount() ? subType : -1));
	}

	ReturnValue ret = internalUseItem(player, pos, index, item, isHotkey);
	if (ret != RETURNVALUE_NOERROR) {
		player->sendCancelMessage(ret);
		return false;
	}

	// only send cooldown icon if it's an multi use item
	if (it.isMultiUse()) {
		player->sendUseItemCooldown(g_configManager().getNumber(ACTIONS_DELAY_INTERVAL));
	}
	return true;
}

bool Actions::useItemEx(Player* player, const Position& fromPos, const Position& toPos,
						uint8_t toStackPos, Item* item, bool isHotkey, Creature* creature/* = nullptr*/) {
	const ItemType& it = Item::items[item->getID()];
	if (it.isRune() || it.type == ITEM_TYPE_POTION) {
		if (player->walkExhausted()) {
			player->sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
			return false;
		}
		player->setNextPotionAction(OTSYS_TIME() + g_configManager().getNumber(EX_ACTIONS_DELAY_INTERVAL));
	} else {
		player->setNextAction(OTSYS_TIME() + g_configManager().getNumber(EX_ACTIONS_DELAY_INTERVAL));
	}

	Action* action = getAction(item);
	if (action == nullptr) {
		player->sendCancelMessage(RETURNVALUE_CANNOTUSETHISOBJECT);
		return false;
	}

	ReturnValue ret = action->canExecuteAction(player, toPos);
	if (ret != RETURNVALUE_NOERROR) {
		player->sendCancelMessage(ret);
		return false;
	}

	if (isHotkey) {
		uint16_t subType = item->getSubType();
		showUseHotkeyMessage(player, item, player->getItemTypeCount(item->getID(), subType != item->getItemCount() ? subType : -1));
	}

	if (action->function) {
		if (action->function(player, item, fromPos, action->getTarget(player, creature, toPos, toStackPos), toPos, isHotkey)) {
			return true;
		}
		return false;
	}

	if (!action->executeUse(player, item, fromPos, action->getTarget(player, creature, toPos, toStackPos), toPos, isHotkey)) {
		if (!action->hasOwnErrorHandler()) {
			player->sendCancelMessage(RETURNVALUE_CANNOTUSETHISOBJECT);
		}
		return false;
	}

	if (it.isMultiUse()) {
		player->sendUseItemCooldown(g_configManager().getNumber(EX_ACTIONS_DELAY_INTERVAL));
	}
	return true;
}

void Actions::showUseHotkeyMessage(Player* player, const Item* item, uint32_t count) {
	std::ostringstream ss;

	const ItemType& it = Item::items[item->getID()];
	if (!it.showCount) {
		ss << "Using one of " << item->getName() << "...";
	} else if (count == 1) {
		ss << "Using the last " << item->getName() << "...";
	} else {
		ss << "Using one of " << count << ' ' << item->getPluralName() << "...";
	}
	player->sendTextMessage(MESSAGE_HOTKEY_PRESSED, ss.str());
}

Action::Action(LuaScriptInterface* interface) :
	Event(interface), function(nullptr), allowFarUse(false), checkFloor(true), checkLineOfSight(true) {}

bool Action::configureEvent(const pugi::xml_node& node) {
	pugi::xml_attribute allowFarUseAttr = node.attribute("allowfaruse");
	if (allowFarUseAttr != nullptr) {
		allowFarUse = allowFarUseAttr.as_bool();
	}

	pugi::xml_attribute blockWallsAttr = node.attribute("blockwalls");
	if (blockWallsAttr != nullptr) {
		checkLineOfSight = blockWallsAttr.as_bool();
	}

	pugi::xml_attribute checkFloorAttr = node.attribute("checkfloor");
	if (checkFloorAttr != nullptr) {
		checkFloor = checkFloorAttr.as_bool();
	}

	return true;
}

std::string Action::getScriptEventName() const {
	return "onUse";
}

ReturnValue Action::canExecuteAction(const Player* player, const Position& toPos) {
	if (!allowFarUse) {
		return g_actions().canUse(player, toPos);
	}

	return g_actions().canUseFar(player, toPos, checkLineOfSight, checkFloor);
}

Thing* Action::getTarget(Player* player, Creature* targetCreature,
						const Position& toPosition, uint8_t toStackPos) const {
	if (targetCreature != nullptr) {
		return targetCreature;
	}
	return g_game().internalGetThing(player, toPosition, toStackPos, 0, STACKPOS_USETARGET);
}

bool Action::executeUse(Player* player, Item* item, const Position& fromPosition, Thing* target, const Position& toPosition, bool isHotkey) {
	//onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if (!scriptInterface->reserveScriptEnv()) {
		SPDLOG_ERROR("[Action::executeUse - Player {}, on item {}] "
					"Call stack overflow. Too many lua script calls being nested.",
					player->getName(), item->getName());
		return false;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	env->setScriptId(scriptId, scriptInterface);

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(scriptId);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushThing(L, item);
	LuaScriptInterface::pushPosition(L, fromPosition);

	LuaScriptInterface::pushThing(L, target);
	LuaScriptInterface::pushPosition(L, toPosition);

	LuaScriptInterface::pushBoolean(L, isHotkey);
	return scriptInterface->callFunction(6);
}
