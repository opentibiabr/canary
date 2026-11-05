#pragma once

#include <cstdint>
#include <filesystem>
#include <map>
#include <memory>
#include <optional>
#include <string>

class Action;
class Creature;
class Item;
class Player;
class Thing;
class WorldLayerRuntime;
struct Position;
struct lua_State;
namespace world_layers {
	struct BehaviorBinding;
	struct BehaviorDescriptor;
}

// Registration owns callback identities only. The Scripts interface owns Lua
// functions; clearing scripts invalidates these registrations before reuse.
struct WorldBehaviorRegistration {
	std::string id;
	uint32_t version = 0;
	uint64_t epoch = 0;
	std::map<std::string, int32_t> events;
};

class WorldBehaviors {
public:
	explicit WorldBehaviors(WorldLayerRuntime &world);
	~WorldBehaviors();
	WorldBehaviors(const WorldBehaviors &) = delete;
	WorldBehaviors &operator=(const WorldBehaviors &) = delete;
	bool load();
	void clear();
	bool isScript(const std::filesystem::path &file) const;
	std::shared_ptr<WorldBehaviorRegistration> registration(const std::string &id, uint32_t version);
	bool setCallback(WorldBehaviorRegistration &registration, const std::string &event, lua_State* L);
	bool registerBehavior(const WorldBehaviorRegistration &registration);
	bool owns(const std::shared_ptr<Item> &item, const std::string &event) const;
	std::shared_ptr<Action> action(const std::shared_ptr<Item> &item);
	bool use(const std::string &id, const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, const Position &from, const std::shared_ptr<Thing> &target, const Position &to, bool hotkey);
	std::optional<bool> equip(const std::shared_ptr<Item> &item, const std::shared_ptr<Player> &player, uint8_t slot, bool isCheck, bool equipping);
	std::optional<bool> step(const std::shared_ptr<Item> &item, const std::shared_ptr<Creature> &creature, const Position &position, bool entering);
	std::optional<bool> move(const std::shared_ptr<Item> &owner, const std::shared_ptr<Item> &moving, const std::shared_ptr<Item> &tileItem, const Position &position, bool adding);

private:
	struct State;
	std::unique_ptr<State> state;
};
