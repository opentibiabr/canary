#pragma once

#include "world/world_layers.hpp"
#include <memory>

class Item;
class Cylinder;
class PropWriteStream;

enum class WorldConfigurationMode { Legacy,
	                                World,
	                                Mixed };
enum class WorldPersistence { Ordinary,
	                          External,
	                          Conflict };

struct WorldObjectToken {
	std::string id;
	uint64_t generation = 0;
	uint64_t epoch = 0;
};

struct WorldLegacyWrite {
	std::filesystem::path file;
	std::string table, key, occurrence, responsibility;
	world_layers::Position position;
	uint16_t itemId = 0;
};

// Game owns the configuration. Bindings are weak and access is confined to the
// game thread. A token never prolongs an item's or Lua callback's lifetime.
class WorldLayerRuntime {
public:
	WorldLayerRuntime();
	~WorldLayerRuntime();
	WorldLayerRuntime(const WorldLayerRuntime &) = delete;
	WorldLayerRuntime &operator=(const WorldLayerRuntime &) = delete;

	bool prepare();
	bool captureBaseMap();
	bool readyForStartup() const;
	bool apply();
	WorldConfigurationMode mode() const;
	bool isDeclared(const std::string &id) const;
	bool isFixture(const Item* item) const;
	bool allowLegacy(const WorldLegacyWrite &write, const std::shared_ptr<Item> &item);
	bool allowLuaCreation(const world_layers::Position &position, uint16_t itemId);
	const world_layers::Project* declarations() const;
	const world_layers::Object* object(const std::string &id) const;
	std::shared_ptr<Item> item(const std::string &id);
	std::optional<world_layers::Position> position(const std::string &id);
	std::optional<WorldObjectToken> token(const std::string &id);
	bool resolve(const WorldObjectToken &token);
	std::string identity(const std::shared_ptr<Item> &item);
	void invalidateCallbacks();
	void removed(const std::shared_ptr<Item> &item);
	void transformed(const std::shared_ptr<Item> &original, const std::shared_ptr<Item> &replacement);
	bool canMove(const std::shared_ptr<Item> &item, const std::shared_ptr<Cylinder> &destination, uint32_t count);
	void moved(const std::shared_ptr<Item> &item);
	void cloned(const std::shared_ptr<Item> &item);
	void beginMovement(const std::shared_ptr<Item> &item);
	void endMovement();
	bool serializeHouseAttributes(const std::shared_ptr<Item> &item, PropWriteStream &stream);
	WorldPersistence persistence(const std::shared_ptr<Item> &item);
	void restored(const std::shared_ptr<Item> &item);
	void persistenceError();

private:
	struct State;
	std::unique_ptr<State> state;
};
