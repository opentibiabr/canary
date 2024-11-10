/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/events/move_event_functions.hpp"

#include "creatures/creature.hpp"
#include "lua/creature/movement.hpp"
#include "utils/tools.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void MoveEventFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "MoveEvent", "", MoveEventFunctions::luaCreateMoveEvent);
	Lua::registerMethod(L, "MoveEvent", "type", MoveEventFunctions::luaMoveEventType);
	Lua::registerMethod(L, "MoveEvent", "register", MoveEventFunctions::luaMoveEventRegister);
	Lua::registerMethod(L, "MoveEvent", "level", MoveEventFunctions::luaMoveEventLevel);
	Lua::registerMethod(L, "MoveEvent", "magicLevel", MoveEventFunctions::luaMoveEventMagLevel);
	Lua::registerMethod(L, "MoveEvent", "slot", MoveEventFunctions::luaMoveEventSlot);
	Lua::registerMethod(L, "MoveEvent", "id", MoveEventFunctions::luaMoveEventItemId);
	Lua::registerMethod(L, "MoveEvent", "aid", MoveEventFunctions::luaMoveEventActionId);
	Lua::registerMethod(L, "MoveEvent", "uid", MoveEventFunctions::luaMoveEventUniqueId);
	Lua::registerMethod(L, "MoveEvent", "position", MoveEventFunctions::luaMoveEventPosition);
	Lua::registerMethod(L, "MoveEvent", "premium", MoveEventFunctions::luaMoveEventPremium);
	Lua::registerMethod(L, "MoveEvent", "vocation", MoveEventFunctions::luaMoveEventVocation);
	Lua::registerMethod(L, "MoveEvent", "onEquip", MoveEventFunctions::luaMoveEventOnCallback);
	Lua::registerMethod(L, "MoveEvent", "onDeEquip", MoveEventFunctions::luaMoveEventOnCallback);
	Lua::registerMethod(L, "MoveEvent", "onStepIn", MoveEventFunctions::luaMoveEventOnCallback);
	Lua::registerMethod(L, "MoveEvent", "onStepOut", MoveEventFunctions::luaMoveEventOnCallback);
	Lua::registerMethod(L, "MoveEvent", "onAddItem", MoveEventFunctions::luaMoveEventOnCallback);
	Lua::registerMethod(L, "MoveEvent", "onRemoveItem", MoveEventFunctions::luaMoveEventOnCallback);
}

int MoveEventFunctions::luaCreateMoveEvent(lua_State* L) {
	// MoveEvent()
	const auto moveevent = std::make_shared<MoveEvent>();
	Lua::pushUserdata<MoveEvent>(L, moveevent);
	Lua::setMetatable(L, -1, "MoveEvent");
	return 1;
}

int MoveEventFunctions::luaMoveEventType(lua_State* L) {
	// moveevent:type(callback)
	const auto &moveevent = Lua::getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		std::string typeName = Lua::getString(L, 2);
		const std::string tmpStr = asLowerCaseString(typeName);
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
			Lua::pushBoolean(L, false);
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventRegister(lua_State* L) {
	// moveevent:register()
	const auto &moveevent = Lua::getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		// If not scripted, register item event
		// Example: unscripted_equipments.lua
		if (!moveevent->isLoadedScriptId()) {
			Lua::pushBoolean(L, g_moveEvents().registerLuaItemEvent(moveevent));
			return 1;
		}

		Lua::pushBoolean(L, g_moveEvents().registerLuaEvent(moveevent));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventOnCallback(lua_State* L) {
	// moveevent:onEquip / deEquip / etc. (callback)
	const auto &moveevent = Lua::getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		if (!moveevent->loadScriptId()) {
			Lua::pushBoolean(L, false);
			return 1;
		}

		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventSlot(lua_State* L) {
	// moveevent:slot(slot)
	const auto &moveevent = Lua::getUserdataShared<MoveEvent>(L, 1);
	if (!moveevent) {
		lua_pushnil(L);
		return 1;
	}

	if (moveevent->getEventType() == MOVE_EVENT_EQUIP || moveevent->getEventType() == MOVE_EVENT_DEEQUIP) {
		std::string slotName = asLowerCaseString(Lua::getString(L, 2));
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
			Lua::pushBoolean(L, false);
			return 1;
		}
	}

	Lua::pushBoolean(L, true);
	return 1;
}

int MoveEventFunctions::luaMoveEventLevel(lua_State* L) {
	// moveevent:level(lvl)
	const auto &moveevent = Lua::getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		moveevent->setRequiredLevel(Lua::getNumber<uint32_t>(L, 2));
		moveevent->setWieldInfo(WIELDINFO_LEVEL);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventMagLevel(lua_State* L) {
	// moveevent:magicLevel(lvl)
	const auto &moveevent = Lua::getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		moveevent->setRequiredMagLevel(Lua::getNumber<uint32_t>(L, 2));
		moveevent->setWieldInfo(WIELDINFO_MAGLV);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventPremium(lua_State* L) {
	// moveevent:premium(bool)
	const auto &moveevent = Lua::getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		moveevent->setNeedPremium(Lua::getBoolean(L, 2));
		moveevent->setWieldInfo(WIELDINFO_PREMIUM);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventVocation(lua_State* L) {
	// moveevent:vocation(vocName[, showInDescription = false, lastVoc = false])
	const auto &moveevent = Lua::getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		moveevent->addVocEquipMap(Lua::getString(L, 2));
		moveevent->setWieldInfo(WIELDINFO_VOCREQ);
		std::string tmp;
		bool showInDescription = false;
		bool lastVoc = false;
		if (Lua::getBoolean(L, 3)) {
			showInDescription = Lua::getBoolean(L, 3);
		}
		if (Lua::getBoolean(L, 4)) {
			lastVoc = Lua::getBoolean(L, 4);
		}
		if (showInDescription) {
			if (moveevent->getVocationString().empty()) {
				tmp = asLowerCaseString(Lua::getString(L, 2));
				tmp += "s";
				moveevent->setVocationString(tmp);
			} else {
				tmp = moveevent->getVocationString();
				if (lastVoc) {
					tmp += " and ";
				} else {
					tmp += ", ";
				}
				tmp += asLowerCaseString(Lua::getString(L, 2));
				tmp += "s";
				moveevent->setVocationString(tmp);
			}
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventItemId(lua_State* L) {
	// moveevent:id(ids)
	const auto &moveevent = Lua::getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		const int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				moveevent->setItemId(Lua::getNumber<uint32_t>(L, 2 + i));
			}
		} else {
			moveevent->setItemId(Lua::getNumber<uint32_t>(L, 2));
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventActionId(lua_State* L) {
	// moveevent:aid(ids)
	const auto &moveevent = Lua::getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		const int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				moveevent->setActionId(Lua::getNumber<uint32_t>(L, 2 + i));
			}
		} else {
			moveevent->setActionId(Lua::getNumber<uint32_t>(L, 2));
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventUniqueId(lua_State* L) {
	// moveevent:uid(ids)
	const auto &moveevent = Lua::getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		const int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				moveevent->setUniqueId(Lua::getNumber<uint32_t>(L, 2 + i));
			}
		} else {
			moveevent->setUniqueId(Lua::getNumber<uint32_t>(L, 2));
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MoveEventFunctions::luaMoveEventPosition(lua_State* L) {
	// moveevent:position(positions)
	const auto &moveevent = Lua::getUserdataShared<MoveEvent>(L, 1);
	if (moveevent) {
		const int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				moveevent->setPosition(Lua::getPosition(L, 2 + i));
			}
		} else {
			moveevent->setPosition(Lua::getPosition(L, 2));
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
