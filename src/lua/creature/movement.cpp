/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/creature/movement.hpp"

#include "lib/di/container.hpp"
#include "creatures/combat/combat.hpp"
#include "creatures/combat/condition.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "lua/callbacks/event_callback.hpp"
#include "lua/callbacks/events_callbacks.hpp"
#include "lua/creature/events.hpp"
#include "lua/scripts/scripts.hpp"
#include "creatures/players/vocations/vocation.hpp"
#include "items/item.hpp"
#include "lua/functions/events/move_event_functions.hpp"

MoveEvents &MoveEvents::getInstance() {
	return inject<MoveEvents>();
}

void MoveEvents::clear() {
	uniqueIdMap.clear();
	actionIdMap.clear();
	itemIdMap.clear();
	positionsMap.clear();
}

bool MoveEvents::registerLuaItemEvent(const std::shared_ptr<MoveEvent> &moveEvent) {
	auto itemIdVector = moveEvent->getItemIdsVector();
	if (itemIdVector.empty()) {
		return false;
	}

	std::vector<uint32_t> tmpVector;
	tmpVector.reserve(itemIdVector.size());

	for (const auto &itemId : itemIdVector) {
		if (moveEvent->getEventType() == MOVE_EVENT_EQUIP) {
			ItemType &it = Item::items.getItemType(itemId);
			it.wieldInfo = moveEvent->getWieldInfo();
			it.minReqLevel = moveEvent->getReqLevel();
			it.minReqMagicLevel = moveEvent->getReqMagLv();
			it.vocationString = moveEvent->getVocationString();
		}
		if (registerEvent(moveEvent, itemId, itemIdMap)) {
			tmpVector.emplace_back(itemId);
		}
	}

	itemIdVector = std::move(tmpVector);
	return !itemIdVector.empty();
}

bool MoveEvents::registerLuaActionEvent(const std::shared_ptr<MoveEvent> &moveEvent) {
	auto actionIdVector = moveEvent->getActionIdsVector();
	if (actionIdVector.empty()) {
		return false;
	}

	std::vector<uint32_t> tmpVector;
	tmpVector.reserve(actionIdVector.size());

	for (const auto &actionId : actionIdVector) {
		if (registerEvent(moveEvent, actionId, actionIdMap)) {
			tmpVector.emplace_back(actionId);
		}
	}

	actionIdVector = std::move(tmpVector);
	return !actionIdVector.empty();
}

bool MoveEvents::registerLuaUniqueEvent(const std::shared_ptr<MoveEvent> &moveEvent) {
	auto uniqueIdVector = moveEvent->getUniqueIdsVector();
	if (uniqueIdVector.empty()) {
		return false;
	}

	std::vector<uint32_t> tmpVector;
	tmpVector.reserve(uniqueIdVector.size());

	for (const auto &uniqueId : uniqueIdVector) {
		if (registerEvent(moveEvent, uniqueId, uniqueIdMap)) {
			tmpVector.emplace_back(uniqueId);
		}
	}

	uniqueIdVector = std::move(tmpVector);
	return !uniqueIdVector.empty();
}

bool MoveEvents::registerLuaPositionEvent(const std::shared_ptr<MoveEvent> &moveEvent) {
	auto positionVector = moveEvent->getPositionsVector();
	if (positionVector.empty()) {
		return false;
	}

	std::vector<Position> tmpVector;
	tmpVector.reserve(positionVector.size());

	for (const auto &position : positionVector) {
		if (registerEvent(moveEvent, position, positionsMap)) {
			tmpVector.emplace_back(position);
		}
	}

	positionVector = std::move(tmpVector);
	return !positionVector.empty();
}

bool MoveEvents::registerLuaEvent(const std::shared_ptr<MoveEvent> &moveEvent) {
	// Check if event is correct
	if (registerLuaItemEvent(moveEvent)
	    || registerLuaUniqueEvent(moveEvent)
	    || registerLuaActionEvent(moveEvent)
	    || registerLuaPositionEvent(moveEvent)) {
		return true;
	} else {
		g_logger().warn(
			"[{}] missing id, aid, uid or position for script: {}",
			__FUNCTION__,
			moveEvent->getScriptInterface()->getLoadingScriptName()
		);
		return false;
	}
}

bool MoveEvents::registerEvent(const std::shared_ptr<MoveEvent> &moveEvent, int32_t id, std::map<int32_t, MoveEventList> &moveListMap) const {
	const auto it = moveListMap.find(id);
	if (it == moveListMap.end()) {
		MoveEventList moveEventList;
		moveEventList.moveEvent[moveEvent->getEventType()].push_back(moveEvent);
		moveListMap[id] = moveEventList;
		return true;
	} else {
		std::list<std::shared_ptr<MoveEvent>> &moveEventList = it->second.moveEvent[moveEvent->getEventType()];
		for (const auto &existingMoveEvent : moveEventList) {
			if (existingMoveEvent->getSlot() == moveEvent->getSlot()) {
				g_logger().warn(
					"[{}] duplicate move event found: {}, for script: {}",
					__FUNCTION__,
					id,
					moveEvent->getScriptInterface()->getLoadingScriptName()
				);
				return false;
			}
		}
		moveEventList.push_back(moveEvent);
		return true;
	}
}

std::shared_ptr<MoveEvent> MoveEvents::getEvent(const std::shared_ptr<Item> &item, MoveEvent_t eventType, Slots_t slot) {
	uint32_t slotp;
	switch (slot) {
		case CONST_SLOT_HEAD:
			slotp = SLOTP_HEAD;
			break;
		case CONST_SLOT_NECKLACE:
			slotp = SLOTP_NECKLACE;
			break;
		case CONST_SLOT_BACKPACK:
			slotp = SLOTP_BACKPACK;
			break;
		case CONST_SLOT_ARMOR:
			slotp = SLOTP_ARMOR;
			break;
		case CONST_SLOT_RIGHT:
			slotp = SLOTP_RIGHT;
			break;
		case CONST_SLOT_LEFT:
			slotp = SLOTP_LEFT;
			break;
		case CONST_SLOT_LEGS:
			slotp = SLOTP_LEGS;
			break;
		case CONST_SLOT_FEET:
			slotp = SLOTP_FEET;
			break;
		case CONST_SLOT_AMMO:
			slotp = SLOTP_AMMO;
			break;
		case CONST_SLOT_RING:
			slotp = SLOTP_RING;
			break;
		default:
			slotp = 0;
			break;
	}

	if (item->hasAttribute(ItemAttribute_t::ACTIONID)) {
		auto it = actionIdMap.find(item->getAttribute<uint16_t>(ItemAttribute_t::ACTIONID));
		if (it != actionIdMap.end()) {
			const std::list<std::shared_ptr<MoveEvent>> moveEventList = it->second.moveEvent[eventType];
			for (const auto &moveEvent : moveEventList) {
				if ((moveEvent->getSlot() & slotp) != 0) {
					return moveEvent;
				}
			}
		}
	}

	auto it = itemIdMap.find(item->getID());
	if (it != itemIdMap.end()) {
		const std::list<std::shared_ptr<MoveEvent>> &moveEventList = it->second.moveEvent[eventType];
		for (const auto &moveEvent : moveEventList) {
			if ((moveEvent->getSlot() & slotp) != 0) {
				return moveEvent;
			}
		}
	}
	return nullptr;
}

std::shared_ptr<MoveEvent> MoveEvents::getEvent(const std::shared_ptr<Item> &item, MoveEvent_t eventType) {
	std::map<int32_t, MoveEventList>::iterator it;
	if (item->hasAttribute(ItemAttribute_t::UNIQUEID)) {
		it = uniqueIdMap.find(item->getAttribute<uint16_t>(ItemAttribute_t::UNIQUEID));
		if (it != uniqueIdMap.end()) {
			std::list<std::shared_ptr<MoveEvent>> &moveEventList = it->second.moveEvent[eventType];
			if (!moveEventList.empty()) {
				return *moveEventList.begin();
			}
		}
	}

	if (item->hasAttribute(ItemAttribute_t::ACTIONID)) {
		it = actionIdMap.find(item->getAttribute<uint16_t>(ItemAttribute_t::ACTIONID));
		if (it != actionIdMap.end()) {
			std::list<std::shared_ptr<MoveEvent>> &moveEventList = it->second.moveEvent[eventType];
			if (!moveEventList.empty()) {
				return *moveEventList.begin();
			}
		}
	}

	it = itemIdMap.find(item->getID());
	if (it != itemIdMap.end()) {
		std::list<std::shared_ptr<MoveEvent>> &moveEventList = it->second.moveEvent[eventType];
		if (!moveEventList.empty()) {
			return *moveEventList.begin();
		}
	}
	return nullptr;
}

bool MoveEvents::registerEvent(const std::shared_ptr<MoveEvent> &moveEvent, const Position &position, std::map<Position, MoveEventList> &moveListMap) const {
	const auto it = moveListMap.find(position);
	if (it == moveListMap.end()) {
		MoveEventList moveEventList;
		moveEventList.moveEvent[moveEvent->getEventType()].push_back(moveEvent);
		moveListMap[position] = moveEventList;
		return true;
	} else {
		std::list<std::shared_ptr<MoveEvent>> &moveEventList = it->second.moveEvent[moveEvent->getEventType()];
		if (!moveEventList.empty()) {
			g_logger().warn(
				"[{}] duplicate move event found: {}, for script {}",
				__FUNCTION__,
				position.toString(),
				moveEvent->getScriptInterface()->getLoadingScriptName()
			);
			return false;
		}

		moveEventList.push_back(moveEvent);
		return true;
	}
}

std::shared_ptr<MoveEvent> MoveEvents::getEvent(const std::shared_ptr<Tile> &tile, MoveEvent_t eventType) {
	if (const auto it = positionsMap.find(tile->getPosition());
	    it != positionsMap.end()) {
		std::list<std::shared_ptr<MoveEvent>> &moveEventList = it->second.moveEvent[eventType];
		if (!moveEventList.empty()) {
			return *moveEventList.begin();
		}
	}
	return nullptr;
}

uint32_t MoveEvents::onCreatureMove(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &tile, MoveEvent_t eventType) {
	const Position &pos = tile->getPosition();

	uint32_t ret = 1;

	auto moveEvent = getEvent(tile, eventType);
	if (moveEvent) {
		ret &= moveEvent->fireStepEvent(creature, nullptr, pos);
	}

	for (size_t i = tile->getFirstIndex(), j = tile->getLastIndex(); i < j; ++i) {
		const auto &thing = tile->getThing(i);
		if (!thing) {
			continue;
		}

		const auto &tileItem = thing->getItem();
		if (!tileItem) {
			continue;
		}

		moveEvent = getEvent(tileItem, eventType);
		if (moveEvent) {
			const auto step = moveEvent->fireStepEvent(creature, tileItem, pos);
			// If there is any problem in the function, we will kill the loop
			if (step == 0) {
				break;
			}
			ret &= step;
		}
	}
	return ret;
}

uint32_t MoveEvents::onPlayerEquip(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, Slots_t slot, bool isCheck) {
	const auto &moveEvent = getEvent(item, MOVE_EVENT_EQUIP, slot);
	if (!moveEvent) {
		return 1;
	}
	g_events().eventPlayerOnInventoryUpdate(player, item, slot, true);
	g_callbacks().executeCallback(EventCallback_t::playerOnInventoryUpdate, &EventCallback::playerOnInventoryUpdate, player, item, slot, true);
	return moveEvent->fireEquip(player, item, slot, isCheck);
}

uint32_t MoveEvents::onPlayerDeEquip(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, Slots_t slot) {
	const auto &moveEvent = getEvent(item, MOVE_EVENT_DEEQUIP, slot);
	if (!moveEvent) {
		return 1;
	}
	g_events().eventPlayerOnInventoryUpdate(player, item, slot, false);
	g_callbacks().executeCallback(EventCallback_t::playerOnInventoryUpdate, &EventCallback::playerOnInventoryUpdate, player, item, slot, false);
	return moveEvent->fireEquip(player, item, slot, false);
}

uint32_t MoveEvents::onItemMove(const std::shared_ptr<Item> &item, const std::shared_ptr<Tile> &tile, bool isAdd) {
	MoveEvent_t eventType1, eventType2;
	if (isAdd) {
		eventType1 = MOVE_EVENT_ADD_ITEM;
		eventType2 = MOVE_EVENT_ADD_ITEM_ITEMTILE;
	} else {
		eventType1 = MOVE_EVENT_REMOVE_ITEM;
		eventType2 = MOVE_EVENT_REMOVE_ITEM_ITEMTILE;
	}

	uint32_t ret = 1;
	auto moveEvent = getEvent(tile, eventType1);
	if (moveEvent) {
		// No tile item
		ret &= moveEvent->fireAddRemItem(item, tile->getPosition());
	}

	moveEvent = getEvent(item, eventType1);
	if (moveEvent) {
		// No tile item
		ret &= moveEvent->fireAddRemItem(item, tile->getPosition());
	}

	for (size_t i = tile->getFirstIndex(), j = tile->getLastIndex(); i < j; ++i) {
		const auto &thing = tile->getThing(i);
		if (!thing) {
			continue;
		}

		const auto &tileItem = thing->getItem();
		if (!tileItem) {
			continue;
		}

		moveEvent = getEvent(tileItem, eventType2);
		if (moveEvent) {
			const auto &moveItem = moveEvent->fireAddRemItem(item, tileItem, tile->getPosition());
			// If there is any problem in the function, we will kill the loop
			if (moveItem == 0) {
				break;
			}
		}
	}

	return ret;
}

/*
================
 MoveEvent class
================
*/

MoveEvent::MoveEvent() = default;

std::string MoveEvent::getScriptTypeName() const {
	switch (eventType) {
		case MOVE_EVENT_STEP_IN:
			return "onStepIn";
		case MOVE_EVENT_STEP_OUT:
			return "onStepOut";
		case MOVE_EVENT_EQUIP:
			return "onEquip";
		case MOVE_EVENT_DEEQUIP:
			return "onDeEquip";
		case MOVE_EVENT_ADD_ITEM:
			return "onAddItem";
		case MOVE_EVENT_REMOVE_ITEM:
			return "onRemoveItem";
		default:
			g_logger().error(
				"[{}] invalid event type for script: {}",
				__FUNCTION__,
				getScriptInterface()->getLoadingScriptName()
			);
			return {};
	}
}

LuaScriptInterface* MoveEvent::getScriptInterface() const {
	return &g_scripts().getScriptInterface();
}

bool MoveEvent::loadScriptId() {
	LuaScriptInterface &luaInterface = g_scripts().getScriptInterface();
	m_scriptId = luaInterface.getEvent();
	if (m_scriptId == -1) {
		g_logger().error("[MoveEvent::loadScriptId] Failed to load event. Script name: '{}', Module: '{}'", luaInterface.getLoadingScriptName(), luaInterface.getInterfaceName());
		return false;
	}

	return true;
}

int32_t MoveEvent::getScriptId() const {
	return m_scriptId;
}

void MoveEvent::setScriptId(int32_t newScriptId) {
	m_scriptId = newScriptId;
}

bool MoveEvent::isLoadedScriptId() const {
	return m_scriptId != 0;
}

uint32_t MoveEvent::StepInField(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Item> &item, const Position &) {
	if (creature == nullptr) {
		g_logger().error("[MoveEvent::StepInField] - Creature is nullptr");
		return 0;
	}

	if (item == nullptr) {
		g_logger().error("[MoveEvent::StepInField] - Item is nullptr");
		return 0;
	}

	const auto &field = item->getMagicField();
	if (field) {
		field->onStepInField(creature);
		return 1;
	}

	return LUA_ERROR_ITEM_NOT_FOUND;
}

uint32_t MoveEvent::StepOutField(const std::shared_ptr<Creature> &, const std::shared_ptr<Item> &, const Position &) {
	return 1;
}

uint32_t MoveEvent::AddItemField(const std::shared_ptr<Item> &item, const std::shared_ptr<Item> &, const Position &) {
	if (item == nullptr) {
		g_logger().error("[MoveEvent::AddItemField] - Item is nullptr");
		return 0;
	}

	if (const auto &field = item->getMagicField()) {
		const auto &tile = item->getTile();
		if (tile == nullptr) {
			g_logger().debug("[MoveEvent::AddItemField] - Tile is nullptr");
			return 0;
		}
		const CreatureVector* creatures = tile->getCreatures();
		if (creatures == nullptr) {
			g_logger().debug("[MoveEvent::AddItemField] - Creatures is nullptr");
			return 0;
		}
		for (auto &creature : *creatures) {
			if (field == nullptr) {
				g_logger().debug("[MoveEvent::AddItemField] - MagicField is nullptr");
				return 0;
			}

			field->onStepInField(creature);
		}
		return 1;
	}
	return LUA_ERROR_ITEM_NOT_FOUND;
}

uint32_t MoveEvent::RemoveItemField(const std::shared_ptr<Item> &, const std::shared_ptr<Item> &, const Position &) {
	return 1;
}

uint32_t MoveEvent::EquipItem(const std::shared_ptr<MoveEvent> &moveEvent, const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, Slots_t slot, bool isCheck) {
	if (player == nullptr) {
		g_logger().error("[MoveEvent::EquipItem] - Player is nullptr");
		return 0;
	}

	if (item == nullptr) {
		g_logger().error("[MoveEvent::EquipItem] - Item is nullptr");
		return 0;
	}

	if (!player->hasFlag(PlayerFlags_t::IgnoreWeaponCheck) && moveEvent->getWieldInfo() != 0) {
		if (player->getLevel() < moveEvent->getReqLevel() || player->getMagicLevel() < moveEvent->getReqMagLv()) {
			return 0;
		}

		if (moveEvent->isPremium() && !player->isPremium()) {
			return 0;
		}

		const std::map<uint16_t, bool> &vocEquipMap = moveEvent->getVocEquipMap();
		if (!vocEquipMap.empty() && !vocEquipMap.contains(player->getVocationId())) {
			return 0;
		}
	}

	if (isCheck) {
		return 1;
	}

	const ItemType &it = Item::items[item->getID()];
	if (it.transformEquipTo != 0) {
		g_game().transformItem(item, it.transformEquipTo);
	}

	if (player->isItemAbilityEnabled(slot)) {
		g_logger().debug("[{}] item ability is already enabled", __FUNCTION__);
		return 1;
	}

	player->setItemAbility(slot, true);

	for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); slotid++) {
		player->updateImbuementTrackerStats();
		ImbuementInfo imbuementInfo;
		if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
			continue;
		}

		player->addItemImbuementStats(imbuementInfo.imbuement);
	}

	if (it.abilities) {
		if (it.abilities->invisible) {
			const auto &condition = Condition::createCondition(static_cast<ConditionId_t>(slot), CONDITION_INVISIBLE, -1, 0);
			player->addCondition(condition);
		}

		if (it.abilities->manaShield) {
			const auto &condition = Condition::createCondition(static_cast<ConditionId_t>(slot), CONDITION_MANASHIELD, -1, 0);
			player->addCondition(condition);
		}

		if (item->getSpeed() != 0) {
			g_game().changePlayerSpeed(player, item->getSpeed());
		}

		player->addConditionSuppressions(it.abilities->conditionSuppressions);
		player->sendIcons();

		if (it.abilities->regeneration) {
			const auto &condition = Condition::createCondition(static_cast<ConditionId_t>(slot), CONDITION_REGENERATION, -1, 0);

			if (it.abilities->getHealthGain() != 0) {
				condition->setParam(CONDITION_PARAM_HEALTHGAIN, it.abilities->getHealthGain());
			}

			if (it.abilities->getHealthTicks() != 0) {
				condition->setParam(CONDITION_PARAM_HEALTHTICKS, it.abilities->getHealthTicks());
			}

			if (it.abilities->getManaGain() != 0) {
				condition->setParam(CONDITION_PARAM_MANAGAIN, it.abilities->getManaGain());
			}

			if (it.abilities->getManaTicks() != 0) {
				condition->setParam(CONDITION_PARAM_MANATICKS, it.abilities->getManaTicks());
			}

			player->addCondition(condition);
		}

		// Skill and stats modifiers
		for (int32_t i = SKILL_FIRST; i <= SKILL_LAST; ++i) {
			if (item->getSkill(static_cast<skills_t>(i)) != 0) {
				player->setVarSkill(static_cast<skills_t>(i), item->getSkill(static_cast<skills_t>(i)));
			}
		}

		for (int32_t s = STAT_FIRST; s <= STAT_LAST; ++s) {
			if (item->getStat(static_cast<stats_t>(s)) != 0) {
				player->setVarStats(static_cast<stats_t>(s), item->getStat(static_cast<stats_t>(s)));
			}

			if (it.abilities->statsPercent[s]) {
				player->setVarStats(static_cast<stats_t>(s), static_cast<int32_t>(player->getDefaultStats(static_cast<stats_t>(s)) * ((it.abilities->statsPercent[s] - 100) / 100.f)));
			}
		}
	}

	// Updates the main backpack as unasigned if there is no item equipped
	if (slot == CONST_SLOT_BACKPACK) {
		g_logger().debug("[{}] does not have backpack, trying to add new container as unasigned", __FUNCTION__);
		player->setMainBackpackUnassigned(item->getContainer());
	}

	player->sendStats();
	player->sendSkills();
	return 1;
}

uint32_t MoveEvent::DeEquipItem(const std::shared_ptr<MoveEvent> &, const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, Slots_t slot, bool) {
	if (player == nullptr) {
		g_logger().error("[MoveEvent::EquipItem] - Player is nullptr");
		return 0;
	}

	if (item == nullptr) {
		g_logger().error("[MoveEvent::EquipItem] - Item is nullptr");
		return 0;
	}

	if (!player->isItemAbilityEnabled(slot)) {
		g_logger().debug("[{}] item ability is not enabled", __FUNCTION__);
		return 1;
	}

	const ItemType &it = Item::items[item->getID()];
	player->setItemAbility(slot, false);

	for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); slotid++) {
		player->updateImbuementTrackerStats();
		ImbuementInfo imbuementInfo;
		if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
			continue;
		}

		player->removeItemImbuementStats(imbuementInfo.imbuement);
	}

	if (it.abilities) {
		if (it.abilities->invisible) {
			player->removeCondition(CONDITION_INVISIBLE, static_cast<ConditionId_t>(slot));
		}

		if (it.abilities->manaShield) {
			player->removeCondition(CONDITION_MANASHIELD, static_cast<ConditionId_t>(slot));
		}

		if (it.abilities->regeneration) {
			player->removeCondition(CONDITION_REGENERATION, static_cast<ConditionId_t>(slot));
		}

		for (int32_t s = STAT_FIRST; s <= STAT_LAST; ++s) {
			if (it.abilities->statsPercent[s]) {
				player->setVarStats(static_cast<stats_t>(s), -static_cast<int32_t>(player->getDefaultStats(static_cast<stats_t>(s)) * ((it.abilities->statsPercent[s] - 100) / 100.f)));
			}
		}
	}

	for (int32_t i = SKILL_FIRST; i <= SKILL_LAST; ++i) {
		if (item->getSkill(static_cast<skills_t>(i)) != 0) {
			player->setVarSkill(static_cast<skills_t>(i), -item->getSkill(static_cast<skills_t>(i)));
		}
	}

	for (int32_t s = STAT_FIRST; s <= STAT_LAST; ++s) {
		if (item->getStat(static_cast<stats_t>(s))) {
			player->setVarStats(static_cast<stats_t>(s), -item->getStat(static_cast<stats_t>(s)));
		}
	}

	if (item->getSpeed() != 0) {
		g_game().changePlayerSpeed(player, -item->getSpeed());
	}

	player->removeConditionSuppressions();
	player->sendIcons();

	if (it.transformDeEquipTo != 0) {
		g_game().transformItem(item, it.transformDeEquipTo);
	}

	player->sendStats();
	player->sendSkills();
	return 1;
}

MoveEvent_t MoveEvent::getEventType() const {
	return eventType;
}

void MoveEvent::setEventType(MoveEvent_t type) {
	eventType = type;
}

uint32_t MoveEvent::fireStepEvent(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Item> &item, const Position &pos) const {
	if (isLoadedScriptId()) {
		return executeStep(creature, item, pos);
	} else {
		return stepFunction(creature, item, pos);
	}
}

bool MoveEvent::executeStep(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Item> &item, const Position &pos) const {
	// onStepIn(creature, item, pos, fromPosition)
	// onStepOut(creature, item, pos, fromPosition)

	// Check if the new position is the same as the old one
	// If it is, log a warning and either teleport the player to their temple position if item type is an teleport
	const auto fromPosition = creature->getLastPosition();
	if (const auto &player = creature->getPlayer(); item && fromPosition == pos && getEventType() == MOVE_EVENT_STEP_IN) {
		if (const ItemType &itemType = Item::items[item->getID()]; player && itemType.isTeleport()) {
			g_logger().warn("[{}] cannot teleport player: {}, to the same position: {} of fromPosition: {}", __FUNCTION__, player->getName(), pos.toString(), fromPosition.toString());
			g_game().internalTeleport(player, player->getTemplePosition());
			player->sendMagicEffect(player->getTemplePosition(), CONST_ME_TELEPORT);
			player->sendCancelMessage(getReturnMessage(RETURNVALUE_CONTACTADMINISTRATOR));
			return false;
		}
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		if (item != nullptr) {
			g_logger().error("[MoveEvent::executeStep - Creature {} item {}, position {}] "
			                 "Call stack overflow. Too many lua script calls being nested.",
			                 creature->getName(), item->getName(), pos.toString());
		} else {
			g_logger().error("[MoveEvent::executeStep - Creature {}, position {}] "
			                 "Call stack overflow. Too many lua script calls being nested.",
			                 creature->getName(), pos.toString());
		}
		return false;
	}

	const auto scriptInterface = getScriptInterface();
	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(getScriptId(), scriptInterface);

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(getScriptId());
	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	LuaScriptInterface::pushThing(L, item);
	LuaScriptInterface::pushPosition(L, pos);
	LuaScriptInterface::pushPosition(L, fromPosition);

	return scriptInterface->callFunction(4);
}

uint32_t MoveEvent::fireEquip(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, Slots_t toSlot, bool isCheck) {
	if (isLoadedScriptId()) {
		if (!equipFunction || equipFunction(static_self_cast<MoveEvent>(), player, item, toSlot, isCheck) == 1) {
			if (executeEquip(player, item, toSlot, isCheck)) {
				return 1;
			}
		}
		return 0;
	} else {
		return equipFunction(static_self_cast<MoveEvent>(), player, item, toSlot, isCheck);
	}
}

bool MoveEvent::executeEquip(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, Slots_t onSlot, bool isCheck) const {
	// onEquip(player, item, slot, isCheck)
	// onDeEquip(player, item, slot, isCheck)
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[MoveEvent::executeEquip - Player {} item {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), item->getName());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");
	LuaScriptInterface::pushThing(L, item);
	lua_pushnumber(L, onSlot);
	LuaScriptInterface::pushBoolean(L, isCheck);

	return getScriptInterface()->callFunction(4);
}

uint32_t MoveEvent::fireAddRemItem(const std::shared_ptr<Item> &item, const std::shared_ptr<Item> &fromTile, const Position &pos) const {
	if (isLoadedScriptId()) {
		return executeAddRemItem(item, fromTile, pos);
	} else {
		if (!moveFunction) {
			g_logger().error("[MoveEvent::fireAddRemItem - Item {} item on position: {}] "
			                 "Move function is nullptr.",
			                 item->getName(), pos.toString());
			return 0;
		}

		return moveFunction(item, fromTile, pos);
	}
}

bool MoveEvent::executeAddRemItem(const std::shared_ptr<Item> &item, const std::shared_ptr<Item> &fromTile, const Position &pos) const {
	// onAddItem(moveitem, tileitem, pos)
	// onRemoveItem(moveitem, tileitem, pos)
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[MoveEvent::executeAddRemItem - "
		                 "Item {} item on tile x: {} y: {} z: {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 item->getName(), pos.getX(), pos.getY(), pos.getZ());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());
	LuaScriptInterface::pushThing(L, item);
	LuaScriptInterface::pushThing(L, fromTile);
	LuaScriptInterface::pushPosition(L, pos);

	return getScriptInterface()->callFunction(3);
}

uint32_t MoveEvent::fireAddRemItem(const std::shared_ptr<Item> &item, const Position &pos) const {
	if (isLoadedScriptId()) {
		return executeAddRemItem(item, pos);
	} else {
		if (!moveFunction) {
			g_logger().error("[MoveEvent::fireAddRemItem - Item {} item on position: {}] "
			                 "Move function is nullptr.",
			                 item->getName(), pos.toString());
			return 0;
		}

		return moveFunction(item, nullptr, pos);
	}
}

bool MoveEvent::executeAddRemItem(const std::shared_ptr<Item> &item, const Position &pos) const {
	// onaddItem(moveitem, pos)
	// onRemoveItem(moveitem, pos)
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[MoveEvent::executeAddRemItem - "
		                 "Item {} item on position: {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 item->getName(), pos.toString());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());
	LuaScriptInterface::pushThing(L, item);
	LuaScriptInterface::pushPosition(L, pos);

	return getScriptInterface()->callFunction(2);
}

void MoveEvent::addVocEquipMap(const std::string &vocName) {
	const uint16_t vocationId = g_vocations().getVocationId(vocName);
	vocEquipMap[vocationId] = true;
}
