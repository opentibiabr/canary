/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/creature.hpp"
#include "lua/creature/movement.hpp"
#include "lua/functions/events/move_event_functions.hpp"

int MoveEventFunctions::luaCreateMoveEvent(lua_State* L) {
	// MoveEvent()
	const auto moveevent = std::make_shared<MoveEvent>(getScriptEnv()->getScriptInterface());
	pushUserdata<MoveEvent>(L, moveevent);
	setMetatable(L, -1, "MoveEvent");
	return 1;
}

int MoveEventFunctions::luaMoveEventType(lua_State* L) {
	// moveevent:type(callback)
	const auto moveevent = getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		std::string typeName = getString(L, 2);
		std::string tmpStr = asLowerCaseString(typeName);
		if (tmpStr == "stepin") {
			moveevent->setEventType(MOVE_EVENT_STEP_IN);
			moveevent->stepFunction = moveevent->StepInField;
		} else if (tmpStr == "stepout") {
			moveevent->setEventType(MOVE_EVENT_STEP_OUT);
			moveevent->stepFunction = moveevent->StepOutField;
		} else if (tmpStr == "equip") {
			moveevent->setEventType(MOVE_EVENT_EQUIP);
			moveevent->equipFunction = moveevent->EquipItem;
		} else if (tmpStr == "deequip") {
			moveevent->setEventType(MOVE_EVENT_DEEQUIP);
			moveevent->equipFunction = moveevent->DeEquipItem;
		} else if (tmpStr == "additem") {
			moveevent->setEventType(MOVE_EVENT_ADD_ITEM_ITEMTILE);
			moveevent->moveFunction = moveevent->AddItemField;
		} else if (tmpStr == "removeitem") {
			moveevent->setEventType(MOVE_EVENT_REMOVE_ITEM);
			moveevent->moveFunction = moveevent->RemoveItemField;
		} else {
			g_logger().error("[MoveEventFunctions::luaMoveEventType] - "
			                 "No valid event name: {}",
			                 typeName);
			pushBoolean(L, false);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventRegister(lua_State* L) {
	// moveevent:register()
	const auto moveevent = getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		// If not scripted, register item event
		// Example: unscripted_equipments.lua
		if (!moveevent->isLoadedCallback()) {
			pushBoolean(L, g_moveEvents().registerLuaItemEvent(moveevent));
			return 1;
		}

		pushBoolean(L, g_moveEvents().registerLuaEvent(moveevent));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventOnCallback(lua_State* L) {
	// moveevent:onEquip / deEquip / etc. (callback)
	const auto moveevent = getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		if (!moveevent->loadCallback()) {
			pushBoolean(L, false);
			return 1;
		}

		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventSlot(lua_State* L) {
	// moveevent:slot(slot)
	const auto moveevent = getUserdataShared<MoveEvent>(L, 1);
	if (!moveevent) {
		lua_pushnil(L);
		return 1;
	}

	if (moveevent->getEventType() == MOVE_EVENT_EQUIP || moveevent->getEventType() == MOVE_EVENT_DEEQUIP) {
		std::string slotName = asLowerCaseString(getString(L, 2));
		if (slotName == "head") {
			moveevent->setSlot(SLOTP_HEAD);
		} else if (slotName == "necklace") {
			moveevent->setSlot(SLOTP_NECKLACE);
		} else if (slotName == "backpack") {
			moveevent->setSlot(SLOTP_BACKPACK);
		} else if (slotName == "armor" || slotName == "body") {
			moveevent->setSlot(SLOTP_ARMOR);
		} else if (slotName == "right-hand") {
			moveevent->setSlot(SLOTP_RIGHT);
		} else if (slotName == "left-hand") {
			moveevent->setSlot(SLOTP_LEFT);
		} else if (slotName == "hand" || slotName == "shield") {
			moveevent->setSlot(SLOTP_RIGHT | SLOTP_LEFT);
		} else if (slotName == "legs") {
			moveevent->setSlot(SLOTP_LEGS);
		} else if (slotName == "feet") {
			moveevent->setSlot(SLOTP_FEET);
		} else if (slotName == "ring") {
			moveevent->setSlot(SLOTP_RING);
		} else if (slotName == "ammo") {
			moveevent->setSlot(SLOTP_AMMO);
		} else {
			g_logger().warn("[MoveEventFunctions::luaMoveEventSlot] - "
			                "Unknown slot type: {}",
			                slotName);
			pushBoolean(L, false);
			return 1;
		}
	}

	pushBoolean(L, true);
	return 1;
}

int MoveEventFunctions::luaMoveEventLevel(lua_State* L) {
	// moveevent:level(lvl)
	const auto moveevent = getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		moveevent->setRequiredLevel(getNumber<uint32_t>(L, 2));
		moveevent->setWieldInfo(WIELDINFO_LEVEL);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventMagLevel(lua_State* L) {
	// moveevent:magicLevel(lvl)
	const auto moveevent = getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		moveevent->setRequiredMagLevel(getNumber<uint32_t>(L, 2));
		moveevent->setWieldInfo(WIELDINFO_MAGLV);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventPremium(lua_State* L) {
	// moveevent:premium(bool)
	const auto moveevent = getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		moveevent->setNeedPremium(getBoolean(L, 2));
		moveevent->setWieldInfo(WIELDINFO_PREMIUM);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventVocation(lua_State* L) {
	// moveevent:vocation(vocName[, showInDescription = false, lastVoc = false])
	const auto moveevent = getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		moveevent->addVocEquipMap(getString(L, 2));
		moveevent->setWieldInfo(WIELDINFO_VOCREQ);
		std::string tmp;
		bool showInDescription = false;
		bool lastVoc = false;
		if (getBoolean(L, 3)) {
			showInDescription = getBoolean(L, 3);
		}
		if (getBoolean(L, 4)) {
			lastVoc = getBoolean(L, 4);
		}
		if (showInDescription) {
			if (moveevent->getVocationString().empty()) {
				tmp = asLowerCaseString(getString(L, 2));
				tmp += "s";
				moveevent->setVocationString(tmp);
			} else {
				tmp = moveevent->getVocationString();
				if (lastVoc) {
					tmp += " and ";
				} else {
					tmp += ", ";
				}
				tmp += asLowerCaseString(getString(L, 2));
				tmp += "s";
				moveevent->setVocationString(tmp);
			}
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventItemId(lua_State* L) {
	// moveevent:id(ids)
	const auto moveevent = getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				moveevent->setItemId(getNumber<uint32_t>(L, 2 + i));
			}
		} else {
			moveevent->setItemId(getNumber<uint32_t>(L, 2));
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventActionId(lua_State* L) {
	// moveevent:aid(ids)
	const auto moveevent = getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				moveevent->setActionId(getNumber<uint32_t>(L, 2 + i));
			}
		} else {
			moveevent->setActionId(getNumber<uint32_t>(L, 2));
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventUniqueId(lua_State* L) {
	// moveevent:uid(ids)
	const auto moveevent = getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				moveevent->setUniqueId(getNumber<uint32_t>(L, 2 + i));
			}
		} else {
			moveevent->setUniqueId(getNumber<uint32_t>(L, 2));
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventPosition(lua_State* L) {
	// moveevent:position(positions)
	const auto moveevent = getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				moveevent->setPosition(getPosition(L, 2 + i));
			}
		} else {
			moveevent->setPosition(getPosition(L, 2));
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
