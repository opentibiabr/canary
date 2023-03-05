/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "game/game.h"
#include "lua/creature/events.h"
#include "lua/creature/movement.h"

void MoveEvents::clear() {
	uniqueIdMap.clear();
	actionIdMap.clear();
	itemIdMap.clear();
	positionsMap.clear();
}

bool MoveEvents::registerLuaItemEvent(MoveEvent &moveEvent) {
	auto itemIdVector = moveEvent.getItemIdsVector();
	if (itemIdVector.empty()) {
		return false;
	}

	std::vector<uint32_t> tmpVector;
	tmpVector.reserve(itemIdVector.size());

	for (const auto &itemId : itemIdVector) {
		if (moveEvent.getEventType() == MOVE_EVENT_EQUIP) {
			ItemType &it = Item::items.getItemType(itemId);
			it.wieldInfo = moveEvent.getWieldInfo();
			it.minReqLevel = moveEvent.getReqLevel();
			it.minReqMagicLevel = moveEvent.getReqMagLv();
			it.vocationString = moveEvent.getVocationString();
		}
		if (registerEvent(moveEvent, itemId, itemIdMap)) {
			tmpVector.emplace_back(itemId);
		}
	}

	itemIdVector = std::move(tmpVector);
	return !itemIdVector.empty();
}

bool MoveEvents::registerLuaActionEvent(MoveEvent &moveEvent) {
	auto actionIdVector = moveEvent.getActionIdsVector();
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

bool MoveEvents::registerLuaUniqueEvent(MoveEvent &moveEvent) {
	auto uniqueIdVector = moveEvent.getUniqueIdsVector();
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

bool MoveEvents::registerLuaPositionEvent(MoveEvent &moveEvent) {
	auto positionVector = moveEvent.getPositionsVector();
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

bool MoveEvents::registerLuaEvent(MoveEvent &moveEvent) {
	// Check if event is correct
	if (registerLuaItemEvent(moveEvent)
		|| registerLuaUniqueEvent(moveEvent)
		|| registerLuaActionEvent(moveEvent)
		|| registerLuaPositionEvent(moveEvent)) {
		return true;
	} else {
		SPDLOG_WARN(
			"[{}] missing id, aid, uid or position for script: {}",
			__FUNCTION__,
			moveEvent.getScriptInterface()->getLoadingScriptName()
		);
		return false;
	}
	SPDLOG_DEBUG(
		"[{}] missing or incorrect event for script: {}",
		__FUNCTION__,
		moveEvent->getScriptInterface()->getLoadingScriptName()
	);
	return false;
}

bool MoveEvents::registerEvent(MoveEvent &moveEvent, int32_t id, std::map<int32_t, MoveEventList> &moveListMap) const {
	auto it = moveListMap.find(id);
	if (it == moveListMap.end()) {
		MoveEventList moveEventList;
		moveEventList.moveEvent[moveEvent.getEventType()].push_back(std::move(moveEvent));
		moveListMap[id] = moveEventList;
		return true;
	} else {
		std::list<MoveEvent> &moveEventList = it->second.moveEvent[moveEvent.getEventType()];
		for (MoveEvent &existingMoveEvent : moveEventList) {
			if (existingMoveEvent.getSlot() == moveEvent.getSlot()) {
				SPDLOG_WARN(
					"[{}] duplicate move event found: {}, for script: {}",
					__FUNCTION__,
					id,
					moveEvent.getScriptInterface()->getLoadingScriptName()
				);
				return false;
			}
		}
		moveEventList.push_back(std::move(moveEvent));
		return true;
	}
}

MoveEvent* MoveEvents::getEvent(Item &item, MoveEvent_t eventType, Slots_t slot) {
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

	if (item.hasAttribute(ItemAttribute_t::ACTIONID)) {
		std::map<int32_t, MoveEventList>::iterator it = actionIdMap.find(item.getAttribute<uint16_t>(ItemAttribute_t::ACTIONID));
		if (it != actionIdMap.end()) {
			std::list<MoveEvent> &moveEventList = it->second.moveEvent[eventType];
			for (MoveEvent &moveEvent : moveEventList) {
				if ((moveEvent.getSlot() & slotp) != 0) {
					return &moveEvent;
				}
			}
		}
	}

	auto it = itemIdMap.find(item.getID());
	if (it != itemIdMap.end()) {
		std::list<MoveEvent> &moveEventList = it->second.moveEvent[eventType];
		for (MoveEvent &moveEvent : moveEventList) {
			if ((moveEvent.getSlot() & slotp) != 0) {
				return &moveEvent;
			}
		}
	}
	return nullptr;
}

MoveEvent* MoveEvents::getEvent(Item &item, MoveEvent_t eventType) {
	std::map<int32_t, MoveEventList>::iterator it;
	if (item.hasAttribute(ItemAttribute_t::UNIQUEID)) {
		it = uniqueIdMap.find(item.getAttribute<uint16_t>(ItemAttribute_t::UNIQUEID));
		if (it != uniqueIdMap.end()) {
			std::list<MoveEvent> &moveEventList = it->second.moveEvent[eventType];
			if (!moveEventList.empty()) {
				return &(*moveEventList.begin());
			}
		}
	}

	if (item.hasAttribute(ItemAttribute_t::ACTIONID)) {
		it = actionIdMap.find(item.getAttribute<uint16_t>(ItemAttribute_t::ACTIONID));
		if (it != actionIdMap.end()) {
			std::list<MoveEvent> &moveEventList = it->second.moveEvent[eventType];
			if (!moveEventList.empty()) {
				return &(*moveEventList.begin());
			}
		}
	}

	it = itemIdMap.find(item.getID());
	if (it != itemIdMap.end()) {
		std::list<MoveEvent> &moveEventList = it->second.moveEvent[eventType];
		if (!moveEventList.empty()) {
			return &(*moveEventList.begin());
		}
	}
	return nullptr;
}

bool MoveEvents::registerEvent(MoveEvent &moveEvent, const Position &position, std::map<Position, MoveEventList> &moveListMap) const {
	auto it = moveListMap.find(position);
	if (it == moveListMap.end()) {
		MoveEventList moveEventList;
		moveEventList.moveEvent[moveEvent.getEventType()].push_back(std::move(moveEvent));
		moveListMap[position] = moveEventList;
		return true;
	} else {
		std::list<MoveEvent> &moveEventList = it->second.moveEvent[moveEvent.getEventType()];
		if (!moveEventList.empty()) {
			SPDLOG_WARN(
				"[{}] duplicate move event found: {}, for script {}",
				__FUNCTION__,
				position.toString(),
				moveEvent.getScriptInterface()->getLoadingScriptName()
			);
			return false;
		}

		moveEventList.push_back(std::move(moveEvent));
		return true;
	}
}

MoveEvent* MoveEvents::getEvent(Tile &tile, MoveEvent_t eventType) {
	if (auto it = positionsMap.find(tile.getPosition());
		it != positionsMap.end()) {
		std::list<MoveEvent> &moveEventList = it->second.moveEvent[eventType];
		if (!moveEventList.empty()) {
			return &(*moveEventList.begin());
		}
	}
	return nullptr;
}

uint32_t MoveEvents::onCreatureMove(Creature &creature, Tile &tile, MoveEvent_t eventType) {
	const Position &pos = tile.getPosition();

	uint32_t ret = 1;

	MoveEvent* moveEvent = getEvent(tile, eventType);
	if (moveEvent) {
		ret &= moveEvent->fireStepEvent(creature, nullptr, pos);
	}

	for (size_t i = tile.getFirstIndex(), j = tile.getLastIndex(); i < j; ++i) {
		Thing* thing = tile.getThing(i);
		if (!thing) {
			continue;
		}

		Item* tileItem = thing->getItem();
		if (!tileItem) {
			continue;
		}

		moveEvent = getEvent(*tileItem, eventType);
		if (moveEvent) {
			auto step = moveEvent->fireStepEvent(creature, tileItem, pos);
			// If there is any problem in the function, we will kill the loop
			if (step == 0) {
				break;
			}
			ret &= step;
		}
	}
	return ret;
}

uint32_t MoveEvents::onPlayerEquip(Player &player, Item &item, Slots_t slot, bool isCheck) {
	MoveEvent* moveEvent = getEvent(item, MOVE_EVENT_EQUIP, slot);
	if (!moveEvent) {
		return 1;
	}
	g_events().eventPlayerOnInventoryUpdate(&player, &item, slot, true);
	return moveEvent->fireEquip(player, item, slot, isCheck);
}

uint32_t MoveEvents::onPlayerDeEquip(Player &player, Item &item, Slots_t slot) {
	MoveEvent* moveEvent = getEvent(item, MOVE_EVENT_DEEQUIP, slot);
	if (!moveEvent) {
		return 1;
	}
	g_events().eventPlayerOnInventoryUpdate(&player, &item, slot, false);
	return moveEvent->fireEquip(player, item, slot, false);
}

uint32_t MoveEvents::onItemMove(Item &item, Tile &tile, bool isAdd) {
	MoveEvent_t eventType1, eventType2;
	if (isAdd) {
		eventType1 = MOVE_EVENT_ADD_ITEM;
		eventType2 = MOVE_EVENT_ADD_ITEM_ITEMTILE;
	} else {
		eventType1 = MOVE_EVENT_REMOVE_ITEM;
		eventType2 = MOVE_EVENT_REMOVE_ITEM_ITEMTILE;
	}

	uint32_t ret = 1;
	MoveEvent* moveEvent = getEvent(tile, eventType1);
	if (moveEvent) {
		// No tile item
		ret &= moveEvent->fireAddRemItem(item, tile.getPosition());
	}

	moveEvent = getEvent(item, eventType1);
	if (moveEvent) {
		// No tile item
		ret &= moveEvent->fireAddRemItem(item, tile.getPosition());
	}

	for (size_t i = tile.getFirstIndex(), j = tile.getLastIndex(); i < j; ++i) {
		Thing* thing = tile.getThing(i);
		if (!thing) {
			continue;
		}

		Item* tileItem = thing->getItem();
		if (!tileItem) {
			continue;
		}

		moveEvent = getEvent(*tileItem, eventType2);
		if (moveEvent) {
			auto moveItem = moveEvent->fireAddRemItem(item, *tileItem, tile.getPosition());
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
MoveEvent::MoveEvent(LuaScriptInterface* interface) :
	Script(interface) { }

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
			SPDLOG_ERROR(
				"[{}] invalid event type for script: {}",
				__FUNCTION__,
				getScriptInterface()->getLoadingScriptName()
			);
			return std::string();
	}
}

uint32_t MoveEvent::StepInField(Creature* creature, Item* item, const Position &) {
	if (creature == nullptr) {
		SPDLOG_ERROR("[MoveEvent::StepInField] - Creature is nullptr");
		return 0;
	}

	if (item == nullptr) {
		SPDLOG_ERROR("[MoveEvent::StepInField] - Item is nullptr");
		return 0;
	}

	MagicField* field = item->getMagicField();
	if (field) {
		field->onStepInField(*creature);
		return 1;
	}

	return LUA_ERROR_ITEM_NOT_FOUND;
}

uint32_t MoveEvent::StepOutField(Creature*, Item*, const Position &) {
	return 1;
}

uint32_t MoveEvent::AddItemField(Item* item, Item*, const Position &) {
	if (item == nullptr) {
		SPDLOG_ERROR("[MoveEvent::AddItemField] - Item is nullptr");
		return 0;
	}

	if (MagicField* field = item->getMagicField()) {
		Tile* tile = item->getTile();
		if (tile == nullptr) {
			SPDLOG_DEBUG("[MoveEvent::AddItemField] - Tile is nullptr");
			return 0;
		}
		const CreatureVector* creatures = tile->getCreatures();
		if (creatures == nullptr) {
			SPDLOG_DEBUG("[MoveEvent::AddItemField] - Creatures is nullptr");
			return 0;
		}
		for (Creature* creature : *creatures) {
			if (field == nullptr) {
				SPDLOG_DEBUG("[MoveEvent::AddItemField] - MagicField is nullptr");
				return 0;
			}

			field->onStepInField(*creature);
		}
		return 1;
	}
	return LUA_ERROR_ITEM_NOT_FOUND;
}

uint32_t MoveEvent::RemoveItemField(Item*, Item*, const Position &) {
	return 1;
}

uint32_t MoveEvent::EquipItem(MoveEvent* moveEvent, Player* player, Item* item, Slots_t slot, bool isCheck) {
	if (player == nullptr) {
		SPDLOG_ERROR("[MoveEvent::EquipItem] - Player is nullptr");
		return 0;
	}

	if (item == nullptr) {
		SPDLOG_ERROR("[MoveEvent::EquipItem] - Item is nullptr");
		return 0;
	}

	if (player->isItemAbilityEnabled(slot)) {
		return 1;
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
	} else {
		player->setItemAbility(slot, true);
	}

	for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); slotid++) {
		ImbuementInfo imbuementInfo;
		if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
			continue;
		}

		player->addItemImbuementStats(imbuementInfo.imbuement);
	}

	if (it.abilities) {
		if (it.abilities->invisible) {
			Condition* condition = Condition::createCondition(static_cast<ConditionId_t>(slot), CONDITION_INVISIBLE, -1, 0);
			player->addCondition(condition);
		}

		if (it.abilities->manaShield) {
			Condition* condition = Condition::createCondition(static_cast<ConditionId_t>(slot), CONDITION_MANASHIELD, -1, 0);
			player->addCondition(condition);
		}

		if (it.abilities->speed != 0) {
			g_game().changePlayerSpeed(*player, it.abilities->speed);
		}

		if (it.abilities->conditionSuppressions != 0) {
			player->addConditionSuppressions(it.abilities->conditionSuppressions);
			player->sendIcons();
		}

		if (it.abilities->regeneration) {
			Condition* condition = Condition::createCondition(static_cast<ConditionId_t>(slot), CONDITION_REGENERATION, -1, 0);

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

		for (uint16_t combat = 0; combat <= 11; combat++) {
			if (it.abilities->specializedMagicLevel[combat] != 0)
				player->setSpecializedMagicLevel(indexToCombatType(combat), it.abilities->specializedMagicLevel[combat]);
		}

		if (it.abilities->perfectShotRange != 0) {
			player->setPerfectShotDamage(it.abilities->perfectShotRange, it.abilities->perfectShotDamage);
		}

		if (it.abilities->magicShieldCapacityFlat != 0) {
			player->setMagicShieldCapacityFlat(it.abilities->magicShieldCapacityFlat);
		}

		if (it.abilities->magicShieldCapacityPercent != 0) {
			player->setMagicShieldCapacityPercent(it.abilities->magicShieldCapacityPercent);
		}

		if (it.abilities->cleavePercent != 0) {
			player->setCleavePercent(it.abilities->cleavePercent);
		}

		// Skill and stats modifiers
		for (int32_t i = SKILL_FIRST; i <= SKILL_LAST; ++i) {
			if (it.abilities->skills[i]) {
				player->setVarSkill(static_cast<skills_t>(i), it.abilities->skills[i]);
			}
		}

		for (int32_t s = STAT_FIRST; s <= STAT_LAST; ++s) {
			if (it.abilities->stats[s]) {
				player->setVarStats(static_cast<stats_t>(s), it.abilities->stats[s]);
			}

			if (it.abilities->statsPercent[s]) {
				player->setVarStats(static_cast<stats_t>(s), static_cast<int32_t>(player->getDefaultStats(static_cast<stats_t>(s)) * ((it.abilities->statsPercent[s] - 100) / 100.f)));
			}
		}
	}

	player->sendStats();
	player->sendSkills();
	return 1;
}

uint32_t MoveEvent::DeEquipItem(MoveEvent*, Player* player, Item* item, Slots_t slot, bool) {
	if (player == nullptr) {
		SPDLOG_ERROR("[MoveEvent::EquipItem] - Player is nullptr");
		return 0;
	}

	if (item == nullptr) {
		SPDLOG_ERROR("[MoveEvent::EquipItem] - Item is nullptr");
		return 0;
	}

	if (!player->isItemAbilityEnabled(slot)) {
		return 1;
	}

	player->setItemAbility(slot, false);

	const ItemType &it = Item::items[item->getID()];
	if (it.transformDeEquipTo != 0) {
		g_game().transformItem(item, it.transformDeEquipTo);
	}

	for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); slotid++) {
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

		if (it.abilities->speed != 0) {
			g_game().changePlayerSpeed(*player, -it.abilities->speed);
		}

		if (it.abilities->conditionSuppressions != 0) {
			player->removeConditionSuppressions(it.abilities->conditionSuppressions);
			player->sendIcons();
		}

		if (it.abilities->regeneration) {
			player->removeCondition(CONDITION_REGENERATION, static_cast<ConditionId_t>(slot));
		}

		for (uint16_t combat = 0; combat <= 11; combat++) {
			if (it.abilities->specializedMagicLevel[combat] != 0)
				player->setSpecializedMagicLevel(indexToCombatType(combat), -it.abilities->specializedMagicLevel[combat]);
		}

		if (it.abilities->perfectShotRange != 0) {
			player->setPerfectShotDamage(it.abilities->perfectShotRange, -it.abilities->perfectShotDamage);
		}

		if (it.abilities->cleavePercent != 0) {
			player->setCleavePercent(-it.abilities->cleavePercent);
		}

		if (it.abilities->magicShieldCapacityFlat != 0) {
			player->setMagicShieldCapacityFlat(-it.abilities->magicShieldCapacityFlat);
		}

		if (it.abilities->magicShieldCapacityPercent != 0) {
			player->setMagicShieldCapacityPercent(-it.abilities->magicShieldCapacityPercent);
		}

		// Skill and stats modifiers
		for (int32_t i = SKILL_FIRST; i <= SKILL_LAST; ++i) {
			if (it.abilities->skills[i] != 0) {
				player->setVarSkill(static_cast<skills_t>(i), -it.abilities->skills[i]);
			}
		}

		for (int32_t s = STAT_FIRST; s <= STAT_LAST; ++s) {
			if (it.abilities->stats[s]) {
				player->setVarStats(static_cast<stats_t>(s), -it.abilities->stats[s]);
			}

			if (it.abilities->statsPercent[s]) {
				player->setVarStats(static_cast<stats_t>(s), -static_cast<int32_t>(player->getDefaultStats(static_cast<stats_t>(s)) * ((it.abilities->statsPercent[s] - 100) / 100.f)));
			}
		}
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

uint32_t MoveEvent::fireStepEvent(Creature &creature, Item* item, const Position &pos) const {
	if (isLoadedCallback()) {
		return executeStep(creature, item, pos);
	} else {
		return stepFunction(&creature, item, pos);
	}
}

bool MoveEvent::executeStep(Creature &creature, Item* item, const Position &pos) const {
	// onStepIn(creature, item, pos, fromPosition)
	// onStepOut(creature, item, pos, fromPosition)

	// Check if the new position is the same as the old one
	// If it is, log a warning and either teleport the player to their temple position if item type is an teleport
	auto fromPosition = creature.getLastPosition();
	if (auto player = creature.getPlayer(); item && fromPosition == pos && getEventType() == MOVE_EVENT_STEP_IN) {
		if (const ItemType &itemType = Item::items[item->getID()]; player && itemType.isTeleport()) {
			SPDLOG_WARN("[{}] cannot teleport player: {}, to the same position: {} of fromPosition: {}", __FUNCTION__, player->getName(), pos.toString(), fromPosition.toString());
			g_game().internalTeleport(player, player->getTemplePosition());
			player->sendMagicEffect(player->getTemplePosition(), CONST_ME_TELEPORT);
			player->sendCancelMessage(getReturnMessage(RETURNVALUE_CONTACTADMINISTRATOR));
		}

		return false;
	}

	if (!getScriptInterface()->reserveScriptEnv()) {
		if (item != nullptr) {
			SPDLOG_ERROR("[MoveEvent::executeStep - Creature {} item {}, position {}] "
						 "Call stack overflow. Too many lua script calls being nested.",
						 creature.getName(), item->getName(), pos.toString());
		} else {
			SPDLOG_ERROR("[MoveEvent::executeStep - Creature {}, position {}] "
						 "Call stack overflow. Too many lua script calls being nested.",
						 creature.getName(), pos.toString());
		}
		return false;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());
	LuaScriptInterface::pushUserdata<Creature>(L, &creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, &creature);
	LuaScriptInterface::pushThing(L, item);
	LuaScriptInterface::pushPosition(L, pos);
	LuaScriptInterface::pushPosition(L, fromPosition);

	return getScriptInterface()->callFunction(4);
}

uint32_t MoveEvent::fireEquip(Player &player, Item &item, Slots_t toSlot, bool isCheck) {
	g_game().playerRequestInventoryImbuements(player.getID());
	if (isLoadedCallback()) {
		if (!equipFunction || equipFunction(this, &player, &item, toSlot, isCheck) == 1) {
			if (executeEquip(player, item, toSlot, isCheck)) {
				return 1;
			}
		}
		return 0;
	} else {
		return equipFunction(this, &player, &item, toSlot, isCheck);
	}
}

bool MoveEvent::executeEquip(Player &player, Item &item, Slots_t onSlot, bool isCheck) const {
	// onEquip(player, item, slot, isCheck)
	// onDeEquip(player, item, slot, isCheck)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[MoveEvent::executeEquip - Player {} item {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 player.getName(), item.getName());
		return false;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());
	LuaScriptInterface::pushUserdata<Player>(L, &player);
	LuaScriptInterface::setMetatable(L, -1, "Player");
	LuaScriptInterface::pushThing(L, &item);
	lua_pushnumber(L, onSlot);
	LuaScriptInterface::pushBoolean(L, isCheck);

	return getScriptInterface()->callFunction(4);
}

uint32_t MoveEvent::fireAddRemItem(Item &item, Item &fromTile, const Position &pos) const {
	if (isLoadedCallback()) {
		return executeAddRemItem(item, fromTile, pos);
	} else {
		return moveFunction(&item, &fromTile, pos);
	}
}

bool MoveEvent::executeAddRemItem(Item &item, Item &fromTile, const Position &pos) const {
	// onAddItem(moveitem, tileitem, pos)
	// onRemoveItem(moveitem, tileitem, pos)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[MoveEvent::executeAddRemItem - "
					 "Item {} item on tile x: {} y: {} z: {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 item.getName(), pos.getX(), pos.getY(), pos.getZ());
		return false;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());
	LuaScriptInterface::pushThing(L, &item);
	LuaScriptInterface::pushThing(L, &fromTile);
	LuaScriptInterface::pushPosition(L, pos);

	return getScriptInterface()->callFunction(3);
}

uint32_t MoveEvent::fireAddRemItem(Item &item, const Position &pos) const {
	if (isLoadedCallback()) {
		return executeAddRemItem(item, pos);
	} else {
		return moveFunction(&item, nullptr, pos);
	}
}

bool MoveEvent::executeAddRemItem(Item &item, const Position &pos) const {
	// onaddItem(moveitem, pos)
	// onRemoveItem(moveitem, pos)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[MoveEvent::executeAddRemItem - "
					 "Item {} item on tile x: {} y: {} z: {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 item.getName(), pos.getX(), pos.getY(), pos.getZ());
		return false;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());
	LuaScriptInterface::pushThing(L, &item);
	LuaScriptInterface::pushPosition(L, pos);

	return getScriptInterface()->callFunction(2);
}
