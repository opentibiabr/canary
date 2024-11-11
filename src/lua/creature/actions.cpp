/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/creature/actions.hpp"

#include "config/configmanager.hpp"
#include "creatures/combat/spells.hpp"
#include "creatures/players/player.hpp"
#include "enums/account_group_type.hpp"
#include "game/game.hpp"
#include "items/bed.hpp"
#include "items/containers/container.hpp"
#include "items/containers/depot/depotlocker.hpp"
#include "items/containers/rewards/reward.hpp"
#include "items/containers/rewards/rewardchest.hpp"
#include "lua/scripts/scripts.hpp"
#include "lib/di/container.hpp"

Actions::Actions() = default;
Actions::~Actions() = default;

Actions &Actions::getInstance() {
	return inject<Actions>();
}

void Actions::clear() {
	useItemMap.clear();
	uniqueItemMap.clear();
	actionItemMap.clear();
	actionPositionMap.clear();
}

bool Actions::registerLuaItemEvent(const std::shared_ptr<Action> &action) {
	auto itemIdVector = action->getItemIdsVector();
	if (itemIdVector.empty()) {
		return false;
	}

	std::vector<uint16_t> tmpVector;
	tmpVector.reserve(itemIdVector.size());

	for (const auto &itemId : itemIdVector) {
		// Check if the item is already registered and prevent it from being registered again
		if (hasItemId(itemId)) {
			g_logger().warn(
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
		setItemId(itemId, action);
		tmpVector.emplace_back(itemId);
	}

	itemIdVector = std::move(tmpVector);
	return !itemIdVector.empty();
}

bool Actions::registerLuaUniqueEvent(const std::shared_ptr<Action> &action) {
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
			setUniqueId(uniqueId, action);
			tmpVector.emplace_back(uniqueId);
		} else {
			g_logger().warn(
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

bool Actions::registerLuaActionEvent(const std::shared_ptr<Action> &action) {
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
			setActionId(actionId, action);
			tmpVector.emplace_back(actionId);
		} else {
			g_logger().warn(
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

bool Actions::registerLuaPositionEvent(const std::shared_ptr<Action> &action) {
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
			setPosition(position, action);
			tmpVector.emplace_back(position);
		} else {
			g_logger().warn(
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

bool Actions::registerLuaEvent(const std::shared_ptr<Action> &action) {
	// Call all register lua events
	if (registerLuaItemEvent(action) || registerLuaUniqueEvent(action) || registerLuaActionEvent(action) || registerLuaPositionEvent(action)) {
		return true;
	} else {
		g_logger().warn(
			"[{}] missing id/aid/uid/position for one script event, for script: {}",
			__FUNCTION__,
			action->getScriptInterface()->getLoadingScriptName()
		);
		return false;
	}
	g_logger().debug("[{}] missing or incorrect script: {}", __FUNCTION__, action->getScriptInterface()->getLoadingScriptName());
	return false;
}

ReturnValue Actions::canUse(const std::shared_ptr<Player> &player, const Position &pos) const {
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

ReturnValue Actions::canUse(const std::shared_ptr<Player> &player, const Position &pos, const std::shared_ptr<Item> &item) {
	const auto &action = getAction(item);
	if (action != nullptr) {
		return action->canExecuteAction(player, pos);
	}
	return RETURNVALUE_NOERROR;
}

ReturnValue Actions::canUseFar(const std::shared_ptr<Creature> &creature, const Position &toPos, bool checkLineOfSight, bool checkFloor) const {
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

	if (checkLineOfSight && !g_game().canThrowObjectTo(creaturePos, toPos, checkFloor ? SightLine_CheckSightLineAndFloor : SightLine_CheckSightLine)) {
		return RETURNVALUE_CANNOTTHROW;
	}

	return RETURNVALUE_NOERROR;
}

std::shared_ptr<Action> Actions::getAction(const std::shared_ptr<Item> &item) {
	if (item->hasAttribute(ItemAttribute_t::UNIQUEID)) {
		const auto it = uniqueItemMap.find(item->getAttribute<uint16_t>(ItemAttribute_t::UNIQUEID));
		if (it != uniqueItemMap.end()) {
			return it->second;
		}
	}

	if (item->hasAttribute(ItemAttribute_t::ACTIONID)) {
		const auto it = actionItemMap.find(item->getAttribute<uint16_t>(ItemAttribute_t::ACTIONID));
		if (it != actionItemMap.end()) {
			return it->second;
		}
	}

	const auto it = useItemMap.find(item->getID());
	if (it != useItemMap.end()) {
		return it->second;
	}

	if (const auto iteratePositions = actionPositionMap.find(item->getPosition());
	    iteratePositions != actionPositionMap.end()) {
		if (const auto &tile = item->getTile()) {
			if (const auto &player = item->getHoldingPlayer();
			    player && item->getTopParent() == player) {
				g_logger().debug("[Actions::getAction] - The position only is valid for use item in the map, player name {}", player->getName());
				return nullptr;
			}

			return iteratePositions->second;
		}
	}

	// rune items
	return g_spells().getRuneSpell(item->getID());
}

ReturnValue Actions::internalUseItem(const std::shared_ptr<Player> &player, const Position &pos, uint8_t index, const std::shared_ptr<Item> &item, bool isHotkey) {
	if (const auto &door = item->getDoor()) {
		if (!door->canUse(player)) {
			return RETURNVALUE_CANNOTUSETHISOBJECT;
		}
	}

	auto itemId = item->getID();
	const ItemType &itemType = Item::items[itemId];
	auto transformTo = itemType.m_transformOnUse;
	const auto &action = getAction(item);
	if (!action && transformTo > 0 && itemId != transformTo) {
		if (g_game().transformItem(item, transformTo) == nullptr) {
			g_logger().warn("[{}] item with id {} failed to transform to item {}", __FUNCTION__, itemId, transformTo);
			return RETURNVALUE_CANNOTUSETHISOBJECT;
		}

		return RETURNVALUE_NOERROR;
	} else if (transformTo > 0 && action) {
		g_logger().warn("[{}] item with id {} already have action registered and cannot be use transformTo tag", __FUNCTION__, itemId);
	}

	if (action != nullptr) {
		if (action->isLoadedScriptId()) {
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

	if (const auto &bed = item->getBed()) {
		if (!bed->canUse(player)) {
			return RETURNVALUE_CANNOTUSETHISOBJECT;
		}

		if (bed->trySleep(player)) {
			player->setBedItem(bed);
			g_game().sendOfflineTrainingDialog(player);
		}

		return RETURNVALUE_NOERROR;
	}

	if (const auto &container = item->getContainer()) {
		std::shared_ptr<Container> openContainer;

		// depot container
		if (const auto &depot = container->getDepotLocker()) {
			const auto &myDepotLocker = player->getDepotLocker(depot->getDepotId());
			myDepotLocker->setParent(depot->getParent()->getTile());
			openContainer = myDepotLocker;
			player->setLastDepotId(depot->getDepotId());
		} else {
			openContainer = container;
		}

		// reward chest
		if (container->getRewardChest() != nullptr && container->getParent()) {
			if (!player->hasOtherRewardContainerOpen(container->getParent()->getContainer())) {
				player->removeEmptyRewards();
			}

			const auto &playerRewardChest = player->getRewardChest();
			if (playerRewardChest->empty()) {
				return RETURNVALUE_REWARDCHESTISEMPTY;
			}

			playerRewardChest->setParent(container->getParent()->getTile());
			for (const auto &[mapRewardId, reward] : player->rewardMap) {
				reward->setParent(playerRewardChest);
			}

			openContainer = playerRewardChest;
		}

		const auto rewardId = container->getAttribute<time_t>(ItemAttribute_t::DATE);
		// Reward container proxy created when the boss dies
		if (container->getID() == ITEM_REWARD_CONTAINER && !container->getReward()) {
			const auto &reward = player->getReward(rewardId, false);
			if (!reward) {
				return RETURNVALUE_THISISIMPOSSIBLE;
			}
			if (reward->empty()) {
				return RETURNVALUE_REWARDCONTAINERISEMPTY;
			}
			reward->setParent(container->getRealParent());
			openContainer = reward;
		}

		const uint32_t corpseOwner = container->getCorpseOwner();
		if (container->isRewardCorpse()) {
			// only players who participated in the fight can open the corpse
			if (player->getGroup()->id >= GROUP_TYPE_GAMEMASTER) {
				return RETURNVALUE_YOUCANTOPENCORPSEADM;
			}
			const auto &reward = player->getReward(rewardId, false);
			if (!reward) {
				return RETURNVALUE_YOUARENOTTHEOWNER;
			}
			if (reward->empty()) {
				return RETURNVALUE_REWARDCONTAINERISEMPTY;
			}
		} else if (corpseOwner != 0 && !player->canOpenCorpse(corpseOwner)) {
			return RETURNVALUE_YOUARENOTTHEOWNER;
		}

		// open/close container
		const int32_t oldContainerId = player->getContainerID(openContainer);
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

bool Actions::useItem(const std::shared_ptr<Player> &player, const Position &pos, uint8_t index, const std::shared_ptr<Item> &item, bool isHotkey) {
	const ItemType &it = Item::items[item->getID()];
	if (it.isRune() || it.type == ITEM_TYPE_POTION) {
		if (player->walkExhausted()) {
			player->sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
			return false;
		}
	}
	if (isHotkey) {
		const uint16_t subType = item->getSubType();
		showUseHotkeyMessage(player, item, player->getItemTypeCount(item->getID(), subType != item->getItemCount() ? subType : -1));
	}

	ReturnValue ret = internalUseItem(player, pos, index, item, isHotkey);
	if (ret != RETURNVALUE_NOERROR) {
		player->sendCancelMessage(ret);
		return false;
	}

	if (it.isRune() || it.type == ITEM_TYPE_POTION) {
		player->setNextPotionAction(OTSYS_TIME() + g_configManager().getNumber(ACTIONS_DELAY_INTERVAL));
	} else {
		player->setNextAction(OTSYS_TIME() + g_configManager().getNumber(ACTIONS_DELAY_INTERVAL));
	}

	// only send cooldown icon if it's an multi use item
	if (it.isMultiUse()) {
		player->sendUseItemCooldown(g_configManager().getNumber(ACTIONS_DELAY_INTERVAL));
	}
	return true;
}

bool Actions::useItemEx(const std::shared_ptr<Player> &player, const Position &fromPos, const Position &toPos, uint8_t toStackPos, const std::shared_ptr<Item> &item, bool isHotkey, const std::shared_ptr<Creature> &creature /* = nullptr*/) {
	const ItemType &it = Item::items[item->getID()];
	if (it.isRune() || it.type == ITEM_TYPE_POTION) {
		if (player->walkExhausted()) {
			player->sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
			return false;
		}
	}

	const std::shared_ptr<Action> action = getAction(item);
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
		const uint16_t subType = item->getSubType();
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

	if (it.isRune() || it.type == ITEM_TYPE_POTION) {
		player->setNextPotionAction(OTSYS_TIME() + g_configManager().getNumber(EX_ACTIONS_DELAY_INTERVAL));
	} else {
		player->setNextAction(OTSYS_TIME() + g_configManager().getNumber(EX_ACTIONS_DELAY_INTERVAL));
	}

	if (it.isMultiUse()) {
		player->sendUseItemCooldown(g_configManager().getNumber(EX_ACTIONS_DELAY_INTERVAL));
	}
	return true;
}

void Actions::showUseHotkeyMessage(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, uint32_t count) {
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
Action::Action() = default;

LuaScriptInterface* Action::getScriptInterface() const {
	return &g_scripts().getScriptInterface();
}

bool Action::loadScriptId() {
	LuaScriptInterface &luaInterface = g_scripts().getScriptInterface();
	m_scriptId = luaInterface.getEvent();
	if (m_scriptId == -1) {
		g_logger().error("[MoveEvent::loadScriptId] Failed to load event. Script name: '{}', Module: '{}'", luaInterface.getLoadingScriptName(), luaInterface.getInterfaceName());
		return false;
	}

	return true;
}

int32_t Action::getScriptId() const {
	return m_scriptId;
}

void Action::setScriptId(int32_t newScriptId) {
	m_scriptId = newScriptId;
}

bool Action::isLoadedScriptId() const {
	return m_scriptId != 0;
}

ReturnValue Action::canExecuteAction(const std::shared_ptr<Player> &player, const Position &toPos) {
	if (!allowFarUse) {
		return g_actions().canUse(player, toPos);
	}

	return g_actions().canUseFar(player, toPos, checkLineOfSight, checkFloor);
}

std::shared_ptr<Thing> Action::getTarget(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &targetCreature, const Position &toPosition, uint8_t toStackPos) const {
	if (targetCreature != nullptr) {
		return targetCreature;
	}
	return g_game().internalGetThing(player, toPosition, toStackPos, 0, STACKPOS_USETARGET);
}

bool Action::executeUse(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, const Position &fromPosition, const std::shared_ptr<Thing> &target, const Position &toPosition, bool isHotkey) {
	// onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Action::executeUse - Player {}, on item {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), item->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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
