#include "world/world_behaviors.hpp"

#include "creatures/creature.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "items/item.hpp"
#include "lua/creature/actions.hpp"
#include "lua/creature/movement.hpp"
#include "lua/functions/core/game/world_functions.hpp"
#include "lua/scripts/scripts.hpp"
#include "world/world_runtime.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <limits>
	#include <set>
#endif

namespace {
	const world_layers::Value* eventOption(const world_layers::BehaviorBinding &binding, const std::string &event, const std::string &name) {
		const auto eventOptions = binding.eventOptions.find(event);
		if (eventOptions == binding.eventOptions.end()) {
			return nullptr;
		}
		const auto option = eventOptions->second.find(name);
		return option == eventOptions->second.end() ? nullptr : &option->second;
	}

	const bool* booleanOption(const world_layers::BehaviorBinding &binding, const std::string &event, const std::string &name) {
		const auto value = eventOption(binding, event, name);
		return value ? std::get_if<bool>(&value->data) : nullptr;
	}

	const int64_t* integerOption(const world_layers::BehaviorBinding &binding, const std::string &event, const std::string &name) {
		const auto value = eventOption(binding, event, name);
		return value ? std::get_if<int64_t>(&value->data) : nullptr;
	}

	uint32_t slotMask(const world_layers::BehaviorBinding &binding, const std::string &event) {
		const auto value = eventOption(binding, event, "slots");
		const auto slots = value ? std::get_if<world_layers::Value::List>(&value->data) : nullptr;
		uint32_t mask = 0;
		if (!slots) {
			return mask;
		}
		for (const auto &entry : *slots) {
			const auto name = std::get_if<std::string>(&entry.data);
			if (!name) {
				continue;
			}
			if (*name == "head") {
				mask |= SLOTP_HEAD;
			} else if (*name == "necklace") {
				mask |= SLOTP_NECKLACE;
			} else if (*name == "backpack") {
				mask |= SLOTP_BACKPACK;
			} else if (*name == "armor") {
				mask |= SLOTP_ARMOR;
			} else if (*name == "right-hand") {
				mask |= SLOTP_RIGHT;
			} else if (*name == "left-hand") {
				mask |= SLOTP_LEFT;
			} else if (*name == "hand") {
				mask |= SLOTP_HAND;
			} else if (*name == "legs") {
				mask |= SLOTP_LEGS;
			} else if (*name == "feet") {
				mask |= SLOTP_FEET;
			} else if (*name == "ring") {
				mask |= SLOTP_RING;
			} else if (*name == "ammo") {
				mask |= SLOTP_AMMO;
			}
		}
		return mask;
	}

	uint32_t slotFlag(uint8_t slot) {
		switch (static_cast<Slots_t>(slot)) {
			case CONST_SLOT_HEAD:
				return SLOTP_HEAD;
			case CONST_SLOT_NECKLACE:
				return SLOTP_NECKLACE;
			case CONST_SLOT_BACKPACK:
				return SLOTP_BACKPACK;
			case CONST_SLOT_ARMOR:
				return SLOTP_ARMOR;
			case CONST_SLOT_RIGHT:
				return SLOTP_RIGHT;
			case CONST_SLOT_LEFT:
				return SLOTP_LEFT;
			case CONST_SLOT_LEGS:
				return SLOTP_LEGS;
			case CONST_SLOT_FEET:
				return SLOTP_FEET;
			case CONST_SLOT_RING:
				return SLOTP_RING;
			case CONST_SLOT_AMMO:
				return SLOTP_AMMO;
			default:
				return 0;
		}
	}

	std::shared_ptr<MoveEvent> equipmentEvent(const world_layers::BehaviorBinding &binding, const std::string &event) {
		auto moveEvent = std::make_shared<MoveEvent>();
		moveEvent->setSlot(slotMask(binding, event));
		if (const auto level = integerOption(binding, event, "level")) {
			moveEvent->setRequiredLevel(static_cast<uint32_t>(*level));
			moveEvent->setWieldInfo(WIELDINFO_LEVEL);
		}
		if (const auto magicLevel = integerOption(binding, event, "magicLevel")) {
			moveEvent->setRequiredMagLevel(static_cast<uint32_t>(*magicLevel));
			moveEvent->setWieldInfo(WIELDINFO_MAGLV);
		}
		if (const auto premium = booleanOption(binding, event, "premium")) {
			moveEvent->setNeedPremium(*premium);
			moveEvent->setWieldInfo(WIELDINFO_PREMIUM);
		}
		if (const auto value = eventOption(binding, event, "vocations")) {
			if (const auto vocations = std::get_if<world_layers::Value::List>(&value->data)) {
				for (const auto &entry : *vocations) {
					if (const auto vocation = std::get_if<std::string>(&entry.data)) {
						moveEvent->addVocEquipMap(*vocation);
					}
				}
				moveEvent->setWieldInfo(WIELDINFO_VOCREQ);
			}
		}
		if (const auto value = eventOption(binding, event, "vocationDescription")) {
			if (const auto description = std::get_if<std::string>(&value->data)) {
				moveEvent->setVocationString(*description);
			}
		}
		return moveEvent;
	}

	std::filesystem::path behaviorPath(const std::filesystem::path &file) {
		std::error_code error;
		const auto path = std::filesystem::weakly_canonical(file, error);
		return error ? std::filesystem::path {} : path;
	}
	class WorldAction final : public Action {
	public:
		WorldAction(std::string id, const world_layers::BehaviorBinding &binding) :
			id(std::move(id)) {
			if (const auto option = booleanOption(binding, "onUse", "allowFarUse")) {
				setAllowFarUse(*option);
			}
			if (const auto option = booleanOption(binding, "onUse", "blockWalls")) {
				setCheckLineOfSight(*option);
			}
			if (const auto option = booleanOption(binding, "onUse", "checkFloor")) {
				setCheckFloor(*option);
			}
		}
		bool executeUse(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, const Position &from, const std::shared_ptr<Thing> &target, const Position &to, bool hotkey) override {
			return g_game().worldLayers().behaviors().use(id, player, item, from, target, to, hotkey);
		}

	private:
		std::string id;
	};
}

struct WorldBehaviors::State {
	explicit State(WorldLayerRuntime &world) :
		world(world) { }
	WorldLayerRuntime &world;
	uint64_t epoch = 1;
	std::filesystem::path loading;
	bool fileFailed = false;
	std::map<std::string, WorldBehaviorRegistration> staged, registered;
	std::set<int32_t> callbackIds;
	std::map<std::string, std::map<std::string, const world_layers::BehaviorBinding*>> bindings;
	std::map<std::string, std::set<std::string>> owned;
	std::map<std::string, std::shared_ptr<Action>> actions;
	std::map<std::string, std::map<std::string, std::shared_ptr<MoveEvent>>> equipment;
	std::set<std::pair<std::string, std::string>> reported;

	const world_layers::BehaviorBinding* binding(const std::string &id, const std::string &event) const {
		const auto object = bindings.find(id);
		if (object == bindings.end()) {
			return nullptr;
		}
		const auto found = object->second.find(event);
		return found == object->second.end() ? nullptr : found->second;
	}
	bool unavailable(const std::string &id, const std::string &event) {
		if (reported.emplace(id, event).second) {
			g_logger().error("World behavior unavailable for {} / {}; legacy fallback is disabled", id, event);
		}
		return false;
	}
	template <typename PushArguments>
	bool call(const std::string &id, const std::string &event, PushArguments pushArguments) {
		const auto configured = binding(id, event);
		const auto token = world.token(id, event == "onRemoveItem");
		const auto project = world.declarations();
		const auto descriptor = configured && project ? project->behavior(configured->id) : nullptr;
		if (!configured || !token || !descriptor) {
			return unavailable(id, event);
		}
		const auto implementation = registered.find(configured->id);
		if (implementation == registered.end() || implementation->second.epoch != epoch || implementation->second.version != configured->contractVersion) {
			return unavailable(id, event);
		}
		const auto callback = implementation->second.events.find(event);
		if (callback == implementation->second.events.end()) {
			return unavailable(id, event);
		}
		const auto scriptId = callback->second;
		if (!Lua::reserveScriptEnv()) {
			return unavailable(id, event);
		}
		auto &interface = g_scripts().getScriptInterface();
		auto L = interface.getLuaState();
		const auto base = lua_gettop(L);
		Lua::getScriptEnv()->setScriptId(scriptId, &interface);
		if (!interface.pushFunction(scriptId)) {
			lua_settop(L, base);
			Lua::resetScriptEnv();
			return unavailable(id, event);
		}
		// Copy values before invoking Lua: a script may synchronously reload scripts
		// and retire the registration while this invocation is on the stack.
		const auto invocation = std::make_shared<bool>(true);
		WorldFunctions::pushContext(L, *token, *configured, *descriptor, invocation);
		const int arguments = 1 + pushArguments(L);
		const int status = Lua::protectedCall(L, arguments, 1);
		*invocation = false;
		const bool result = status == 0 && lua_type(L, -1) == LUA_TBOOLEAN && lua_toboolean(L, -1);
		if (status != 0) {
			Lua::reportErrorFunc(Lua::getString(L, -1));
		} else if (lua_type(L, -1) != LUA_TBOOLEAN) {
			Lua::reportErrorFunc("World behavior must return a boolean");
		}
		lua_settop(L, base);
		Lua::resetScriptEnv();
		return result;
	}
};

WorldBehaviors::WorldBehaviors(WorldLayerRuntime &world) :
	state(std::make_unique<State>(world)) { }
WorldBehaviors::~WorldBehaviors() = default;

void WorldBehaviors::clear() {
	state->world.invalidateCallbacks();
	state->epoch = state->epoch == std::numeric_limits<uint64_t>::max() ? 0 : state->epoch ? state->epoch + 1
																						   : 0;
	for (const auto id : state->callbackIds) {
		g_scripts().getScriptInterface().removeEvent(id);
	}
	state->callbackIds.clear();
	state->registered.clear();
	state->staged.clear();
	state->reported.clear();
	state->loading.clear();
	// Keep the ownership index and action proxies. Missing implementations must
	// still consume their events after a failed reload.
}

bool WorldBehaviors::isScript(const std::filesystem::path &file) const {
	const auto project = state->world.declarations();
	if (!project) {
		return false;
	}
	const auto path = behaviorPath(file);
	return !path.empty() && std::any_of(project->behaviors.begin(), project->behaviors.end(), [&](const auto &descriptor) { return behaviorPath(descriptor.script) == path; });
}

bool WorldBehaviors::load() {
	const auto project = state->world.declarations();
	if (!project) {
		return true;
	}
	if (!state->epoch) {
		return false;
	}
	state->bindings.clear();
	state->owned.clear();
	state->actions.clear();
	state->equipment.clear();
	std::set<std::filesystem::path> scripts;
	for (const auto &layer : project->layers) {
		if (!layer.enabled) {
			continue;
		}
		for (const auto &object : layer.objects) {
			const auto id = world_layers::objectId(layer, object);
			for (const auto &binding : object.behaviors) {
				for (const auto &event : binding.events) {
					state->bindings[id][event] = &binding;
					state->owned[id].insert(event);
					if (event == "onUse") {
						state->actions.emplace(id, std::make_shared<WorldAction>(id, binding));
					} else if (event == "onEquip" || event == "onDeEquip") {
						state->equipment[id].emplace(event, equipmentEvent(binding, event));
					}
				}
			}
		}
	}
	if (state->world.mode() != WorldConfigurationMode::Legacy) {
		for (const auto &record : project->migrationRecords) {
			for (const auto &claim : record.claims) {
				for (const auto &event : claim.responsibilities) {
					if (!event.starts_with("on")) {
						continue;
					}
					state->owned[claim.object].insert(event);
				}
			}
		}
	}
	for (const auto &descriptor : project->behaviors) {
		scripts.insert(behaviorPath(descriptor.script));
	}
	bool success = true;
	for (const auto &file : scripts) {
		state->loading = file;
		state->fileFailed = false;
		state->staged.clear();
		if (file.empty() || g_scripts().getScriptInterface().loadFile(file.string(), file.filename().string()) != 0) {
			state->fileFailed = true;
		}
		for (const auto &descriptor : project->behaviors) {
			if (behaviorPath(descriptor.script) == file && !state->staged.contains(descriptor.id)) {
				g_logger().error("World descriptor {} has no compatible implementation in {}", descriptor.id, file.generic_string());
				state->fileFailed = true;
			}
		}
		if (state->fileFailed) {
			success = false;
			g_logger().error("World behavior script failed: {}", file.generic_string());
		} else {
			state->registered.insert(state->staged.begin(), state->staged.end());
		}
		state->staged.clear();
	}
	state->loading.clear();
	return success;
}

std::shared_ptr<WorldBehaviorRegistration> WorldBehaviors::registration(const std::string &id, uint32_t version) {
	const auto project = state->world.declarations();
	const auto descriptor = project ? project->behavior(id) : nullptr;
	if (!descriptor || state->loading.empty() || descriptor->contractVersion != version || behaviorPath(descriptor->script) != state->loading) {
		state->fileFailed = true;
		g_logger().error("Cannot register World behavior {} version {} outside its declared script/contract", id, version);
		return nullptr;
	}
	return std::make_shared<WorldBehaviorRegistration>(WorldBehaviorRegistration { id, version, state->epoch, {} });
}

bool WorldBehaviors::setCallback(WorldBehaviorRegistration &registration, const std::string &event, lua_State* L) {
	const auto project = state->world.declarations();
	const auto descriptor = project ? project->behavior(registration.id) : nullptr;
	if (!descriptor || registration.epoch != state->epoch || state->loading.empty() || behaviorPath(descriptor->script) != state->loading || registration.events.contains(event)
	    || std::find(descriptor->events.begin(), descriptor->events.end(), event) == descriptor->events.end()
	    || L != g_scripts().getScriptInterface().getLuaState() || !lua_isfunction(L, -1)) {
		state->fileFailed = true;
		return false;
	}
	const auto callback = g_scripts().getScriptInterface().getEvent();
	if (callback < 0) {
		state->fileFailed = true;
		return false;
	}
	registration.events.emplace(event, callback);
	state->callbackIds.insert(callback);
	return true;
}

bool WorldBehaviors::registerBehavior(const WorldBehaviorRegistration &registration) {
	const auto project = state->world.declarations();
	const auto descriptor = project ? project->behavior(registration.id) : nullptr;
	if (!descriptor || registration.epoch != state->epoch || registration.version != descriptor->contractVersion || state->loading.empty()
	    || behaviorPath(descriptor->script) != state->loading || state->staged.contains(registration.id) || state->registered.contains(registration.id)
	    || registration.events.size() != descriptor->events.size()) {
		state->fileFailed = true;
		return false;
	}
	for (const auto &event : descriptor->events) {
		if (!registration.events.contains(event)) {
			state->fileFailed = true;
			return false;
		}
	}
	state->staged.emplace(registration.id, registration);
	return true;
}

bool WorldBehaviors::owns(const std::shared_ptr<Item> &item, const std::string &event) const {
	const auto found = state->owned.find(state->world.identity(item));
	return found != state->owned.end() && found->second.contains(event);
}
std::shared_ptr<Action> WorldBehaviors::action(const std::shared_ptr<Item> &item) {
	const auto found = state->actions.find(state->world.identity(item));
	return found == state->actions.end() ? nullptr : found->second;
}

bool WorldBehaviors::use(const std::string &id, const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, const Position &from, const std::shared_ptr<Thing> &target, const Position &to, bool hotkey) {
	if (state->world.identity(item) != id) {
		return false;
	}
	return state->call(id, "onUse", [&](lua_State* L) {
		Lua::pushThing(L, player);
		Lua::pushThing(L, item);
		Lua::pushPosition(L, from);
		Lua::pushThing(L, target);
		Lua::pushPosition(L, to);
		Lua::pushBoolean(L, hotkey);
		return 6;
	});
}

std::optional<bool> WorldBehaviors::equip(const std::shared_ptr<Item> &item, const std::shared_ptr<Player> &player, uint8_t slot, bool isCheck, bool equipping) {
	const auto id = state->world.identity(item);
	const std::string event = equipping ? "onEquip" : "onDeEquip";
	const auto object = state->equipment.find(id);
	if (object == state->equipment.end()) {
		return std::nullopt;
	}
	const auto configured = object->second.find(event);
	if (configured == object->second.end() || (configured->second->getSlot() & slotFlag(slot)) == 0) {
		return std::nullopt;
	}
	const auto nativeResult = equipping
		? MoveEvent::EquipItem(configured->second, player, item, static_cast<Slots_t>(slot), isCheck)
		: MoveEvent::DeEquipItem(configured->second, player, item, static_cast<Slots_t>(slot), false);
	if (nativeResult != 1) {
		return false;
	}
	return state->call(id, event, [&](lua_State* L) {
		Lua::pushThing(L, player);
		Lua::pushThing(L, item);
		lua_pushnumber(L, slot);
		Lua::pushBoolean(L, equipping ? isCheck : false);
		return 4;
	});
}

std::optional<bool> WorldBehaviors::step(const std::shared_ptr<Item> &item, const std::shared_ptr<Creature> &creature, const Position &position, bool entering) {
	const auto id = state->world.identity(item);
	const std::string event = entering ? "onStepIn" : "onStepOut";
	if (!owns(item, event)) {
		return std::nullopt;
	}
	return state->call(id, event, [&](lua_State* L) {
		Lua::pushThing(L, creature);
		Lua::pushThing(L, item);
		Lua::pushPosition(L, position);
		Lua::pushPosition(L, creature->getLastPosition());
		return 4;
	});
}

std::optional<bool> WorldBehaviors::move(const std::shared_ptr<Item> &owner, const std::shared_ptr<Item> &moving, const std::shared_ptr<Item> &tileItem, const Position &position, bool adding) {
	const auto id = state->world.identity(owner);
	const std::string event = adding ? "onAddItem" : "onRemoveItem";
	if (!owns(owner, event)) {
		return std::nullopt;
	}
	return state->call(id, event, [&](lua_State* L) {
		Lua::pushThing(L, moving);
		if (tileItem) {
			Lua::pushThing(L, tileItem);
		} else {
			lua_pushnil(L);
		}
		Lua::pushPosition(L, position);
		return 3;
	});
}
