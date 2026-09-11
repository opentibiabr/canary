#pragma once

#include "world/world_validation.hpp"
#include <memory>

class Item;
class Cylinder;
class TileItemVector;
struct Position;

namespace world_runtime {
	Position native(const world_layers::Position &position);
	world_layers::Position portable(const Position &position);
	uint16_t uid(const std::shared_ptr<Item> &item);
	std::vector<std::shared_ptr<Item>> mapOrderedItems(const TileItemVector &items);
	world_layers::Value::Record overrides(const world_layers::Object &object);
	world_layers::Value::Record captureAttributes(const std::shared_ptr<Item> &item, const world_layers::Value::Record &fields);
	void applyAttributes(const std::shared_ptr<Item> &item, const world_layers::Value::Record &values);
	world_layers::MapItem snapshot(const std::shared_ptr<Item> &item, std::unordered_map<uint64_t, std::shared_ptr<Item>> &items, bool ground = false);
	bool attach(const std::shared_ptr<Cylinder> &parent, const std::shared_ptr<Item> &item, uint32_t order);
	std::string marker(const std::shared_ptr<Item> &item, const std::string &project);
	void mark(const std::shared_ptr<Item> &item, const std::string &project, const std::string &id);
	void unmark(const std::shared_ptr<Item> &item);
}
