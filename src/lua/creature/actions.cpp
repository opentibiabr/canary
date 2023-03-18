/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/creature/actions.h"
#include "items/bed.h"
#include "items/containers/container.h"
#include "game/game.h"
#include "creatures/combat/spells.h"
#include "items/containers/rewards/rewardchest.h"

Actions::Actions() = default;
Actions::~Actions() = default;

void Actions::clear() {
	useItemMap.clear();
	uniqueItemMap.clear();
	actionItemMap.clear();
	actionPositionMap.clear();
}

bool Actions::registerLuaItemEvent(Action* action) {
	auto itemIdVector = action->getItemIdsVector();
	if (itemIdVector.empty()) {
		return false;
	}

	std::vector<uint16_t> tmpVector;
	tmpVector.reserve(itemIdVector.size());

	for (const auto &itemId : itemIdVector) {
		// Check if the item is already registered and prevent it from being registered again
		if (hasItemId(itemId)) {
			SPDLOG_WARN(
				"[{}] - Duplicate "
				"registered item with id: {} in range from id: {}, to id: {}, for script: {}",
				__FUNCTION__,
				itemId,
				itemIdVector.at(0),
				itemIdVector.at(itemIdVector.size() - 1),
				action->getScriptInterface()->getLoadingScriptName()
			);
			continue;
		}

		// Register item in the action item map
		setItemId(itemId, std::move(*action));
		tmpVector.emplace_back(itemId);
	}

	itemIdVector = std::move(tmpVector);
	return !itemIdVector.empty();
}

bool Actions::registerLuaUniqueEvent(Action* action) {
	auto uniqueIdVector = action->getUniqueIdsVector();
	if (uniqueIdVector.empty()) {
		return false;
	}

	std::vector<uint16_t> tmpVector;
	tmpVector.reserve(uniqueIdVector.size());

	for (const auto &uniqueId : uniqueIdVector) {
		// Check if the unique is already registered and prevent it from being registered again
		if (!hasUniqueId(uniqueId)) {
			// Register unique id the unique item map
			setUniqueId(uniqueId, std::move(*action));
			tmpVector.emplace_back(uniqueId);
		} else {
			SPDLOG_WARN(
				"[{}] duplicate registered item with uid: {} in range from uid: {}, to uid: {}, for script: {}",
				__FUNCTION__,
				uniqueId,
				uniqueIdVector.at(0),
				uniqueIdVector.at(uniqueIdVector.size() - 1),
				action->getScriptInterface()->getLoadingScriptName()
			);
		}
	}

	uniqueIdVector = std::move(tmpVector);
	return !uniqueIdVector.empty();
}

bool Actions::registerLuaActionEvent(Action* action) {
	auto actionIdVector = action->getActionIdsVector();
	if (actionIdVector.empty()) {
		return false;
	}

	std::vector<uint16_t> tmpVector;
	tmpVector.reserve(actionIdVector.size());

	for (const auto &actionId : actionIdVector) {
		// Check if the unique is already registered and prevent it from being registered again
		if (!hasActionId(actionId)) {
			// Register action in the action item map
			setActionId(actionId, std::move(*action));
			tmpVector.emplace_back(actionId);
		} else {
			SPDLOG_WARN(
				"[{}] duplicate registered item with aid: {} in range from aid: {}, to aid: {}, for script: {}",
				__FUNCTION__,
				actionId,
				actionIdVector.at(0),
				actionIdVector.at(actionIdVector.size() - 1),
				action->getScriptInterface()->getLoadingScriptName()
			);
		}
	}

	actionIdVector = std::move(tmpVector);
	return !actionIdVector.empty();
}

bool Actions::registerLuaPositionEvent(Action* action) {
	auto positionVector = action->getPositionsVector();
	if (positionVector.empty()) {
		return false;
	}

	std::vector<Position> tmpVector;
	tmpVector.reserve(positionVector.size());

	for (const auto &position : positionVector) {
		// Check if the position is already registered and prevent it from being registered again
		if (!hasPosition(position)) {
			// Register position in the action position map
			setPosition(position, std::move(*action));
			tmpVector.emplace_back(position);
		} else {
			SPDLOG_WARN(
				"[{}] duplicate registered script with range position: {}, for script: {}",
				__FUNCTION__,
				position.toString(),
				action->getScriptInterface()->getLoadingScriptName()
			);
		}
	}

	positionVector = std::move(tmpVector);
	return !positionVector.empty();
}

bool Actions::registerLuaEvent(Action* action) {
	Action_ptr actionPtr { action };

	// Call all register lua events
	if (registerLuaItemEvent(action) || registerLuaUniqueEvent(action) || registerLuaActionEvent(action) || registerLuaPositionEvent(action)) {
		return true;
	} else {
		SPDLOG_WARN(
			"[{}] missing id/aid/uid/position for one script event, for script: {}",
			__FUNCTION__,
			action->getScriptInterface()->getLoadingScriptName()
		);
		return false;
	}
	SPDLOG_DEBUG("[{}] missing or incorrect script: {}", __FUNCTION__, action->getScriptInterface()->getLoadingScriptName());
	return false;
}

ReturnValue Actions::canUse(const Player* player, const Position &pos) {
	if (pos.x != 0xFFFF) {
		const Position &playerPos = player->getPosition();
		if (playerPos.z != pos.z) {
			return playerPos.z > pos.z ? RETURNVALUE_FIRSTGOUPSTAIRS : RETURNVALUE_FIRSTGODOWNSTAIRS;
		}

		if (!Position::areInRange<1, 1>(playerPos, pos)) {
			return RETURNVALUE_TOOFARAWAY;
		}
	}
	return RETURNVALUE_NOERROR;
}

ReturnValue Actions::canUse(const Player* player, const Position &pos, const Item* item) {
	Action* action = getAction(item);
	if (action != nullptr) {
		return action->canExecuteAction(player, pos);
	}
	return RETURNVALUE_NOERROR;
}

ReturnValue Actions::canUseFar(const Creature* creature, const Position &toPos, bool checkLineOfSight, bool checkFloor) {
	if (toPos.x == 0xFFFF) {
		return RETURNVALUE_NOERROR;
	}

	const Position &creaturePos = creature->getPosition();
	if (checkFloor && creaturePos.z != toPos.z) {
		return creaturePos.z > toPos.z ? RETURNVALUE_FIRSTGOUPSTAIRS : RETURNVALUE_FIRSTGODOWNSTAIRS;
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
	if (item->hasAttribute(ItemAttribute_t::UNIQUEID)) {
		auto it = uniqueItemMap.find(item->getAttribute<uint16_t>(ItemAttribute_t::UNIQUEID));
		if (it != uniqueItemMap.end()) {
			return &it->second;
		}
	}

	if (item->hasAttribute(ItemAttribute_t::ACTIONID)) {
		auto it = actionItemMap.find(item->getAttribute<uint16_t>(ItemAttribute_t::ACTIONID));
		if (it != actionItemMap.end()) {
			return &it->second;
		}
	}

	auto it = useItemMap.find(item->getID());
	if (it != useItemMap.end()) {
		return &it->second;
	}

	if (auto iteratePositions = actionPositionMap.find(item->getPosition());
		iteratePositions != actionPositionMap.end()) {
		if (const Tile* tile = item->getTile();
			tile) {
			if (const Player* player = item->getHoldingPlayer();
				player && item->getTopParent() == player) {
				SPDLOG_DEBUG("[Actions::getAction] - The position only is valid for use item in the map, player name {}", player->getName());
				return nullptr;
			}

			return &iteratePositions->second;
		}
	}

	// rune items
	return g_spells().getRuneSpell(item->getID());
}

ReturnValue Actions::internalUseItem(Player* player, const Position &pos, uint8_t index, Item* item, bool isHotkey) {
	if (Door* door = item->getDoor()) {
		if (!door->canUse(player)) {
			return RETURNVALUE_CANNOTUSETHISOBJECT;
		}
	}

	Action* action = getAction(item);
	if (action != nullptr) {
		if (action->isLoadedCallback()) {
			if (action->executeUse(player, item, pos, nullptr, pos, isHotkey)) {
				return RETURNVALUE_NOERROR;
			}
			if (item->isRemoved()) {
				return RETURNVALUE_CANNOTUSETHISOBJECT;
			}
		} else if (action->useFunction && action->useFunction(player, item, pos, nullptr, pos, isHotkey)) {
			return RETURNVALUE_NOERROR;
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

		// depot container
		if (DepotLocker* depot = container->getDepotLocker()) {
			DepotLocker* myDepotLocker = player->getDepotLocker(depot->getDepotId());
			myDepotLocker->setParent(depot->getParent()->getTile());
			openContainer = myDepotLocker;
			player->setLastDepotId(depot->getDepotId());
		} else {
			openContainer = container;
		}

		// reward chest
		if (container->getRewardChest() != nullptr) {
			RewardChest* myRewardChest = player->getRewardChest();
			if (!player->hasOtherRewardContainerOpen(dynamic_cast<const Container*>(container->getParent()))) {
				player->removeEmptyRewards();
			}

			if (myRewardChest->size() == 0) {
				return RETURNVALUE_REWARDCHESTISEMPTY;
			}

			myRewardChest->setParent(container->getParent()->getTile());
			for (const auto &[mapRewardId, reward] : player->rewardMap) {
				reward->setParent(myRewardChest);
			}

			openContainer = myRewardChest;
		}

		auto rewardId = container->getAttribute<time_t>(ItemAttribute_t::DATE);
		// Reward container proxy created when the boss dies
		if (container->getID() == ITEM_REWARD_CONTAINER && !container->getReward()) {
			auto reward = player->getReward(rewardId, false);
			if (!reward) {
				return RETURNVALUE_THISISIMPOSSIBLE;
			}
			if (reward->empty()) {
				return RETURNVALUE_REWARDCONTAINERISEMPTY;
			}
			reward->setParent(container->getRealParent());
			openContainer = reward;
		}

		uint32_t corpseOwner = container->getCorpseOwner();
		if (container->isRewardCorpse()) {
			// only players who participated in the fight can open the corpse
			if (player->getGroup()->id >= account::GROUP_TYPE_GAMEMASTER || player->getAccountType() >= account::ACCOUNT_TYPE_SENIORTUTOR) {
				return RETURNVALUE_YOUCANTOPENCORPSEADM;
			}
			if (!player->getReward(rewardId, false)) {
				return RETURNVALUE_YOUARENOTTHEOWNER;
			}
		} else if (corpseOwner != 0 && !player->canOpenCorpse(corpseOwner)) {
			return RETURNVALUE_YOUARENOTTHEOWNER;
		}

		// open/close container
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

	const ItemType &it = Item::items[item->getID()];
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

bool Actions::useItem(Player* player, const Position &pos, uint8_t index, Item* item, bool isHotkey) {
	const ItemType &it = Item::items[item->getID()];
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

bool Actions::useItemEx(Player* player, const Position &fromPos, const Position &toPos, uint8_t toStackPos, Item* item, bool isHotkey, Creature* creature /* = nullptr*/) {
	const ItemType &it = Item::items[item->getID()];
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

	if (action->useFunction) {
		if (action->useFunction(player, item, fromPos, action->getTarget(player, creature, toPos, toStackPos), toPos, isHotkey)) {
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

	const ItemType &it = Item::items[item->getID()];
	if (!it.showCount) {
		ss << "Using one of " << item->getName() << "...";
	} else if (count == 1) {
		ss << "Using the last " << item->getName() << "...";
	} else {
		ss << "Using one of " << count << ' ' << item->getPluralName() << "...";
	}
	player->sendTextMessage(MESSAGE_HOTKEY_PRESSED, ss.str());
}

/*
 ================
 Action interface
 ================
*/

// Action constructor
Action::Action(LuaScriptInterface* interface) :
	Script(interface) { }

ReturnValue Action::canExecuteAction(const Player* player, const Position &toPos) {
	if (!allowFarUse) {
		return g_actions().canUse(player, toPos);
	}

	return g_actions().canUseFar(player, toPos, checkLineOfSight, checkFloor);
}

Thing* Action::getTarget(Player* player, Creature* targetCreature, const Position &toPosition, uint8_t toStackPos) const {
	if (targetCreature != nullptr) {
		return targetCreature;
	}
	return g_game().internalGetThing(player, toPosition, toStackPos, 0, STACKPOS_USETARGET);
}

bool Action::executeUse(Player* player, Item* item, const Position &fromPosition, Thing* target, const Position &toPosition, bool isHotkey) {
	// onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[Action::executeUse - Player {}, on item {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 player->getName(), item->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushThing(L, item);
	LuaScriptInterface::pushPosition(L, fromPosition);

	LuaScriptInterface::pushThing(L, target);
	LuaScriptInterface::pushPosition(L, toPosition);

	LuaScriptInterface::pushBoolean(L, isHotkey);
	return getScriptInterface()->callFunction(6);
}
