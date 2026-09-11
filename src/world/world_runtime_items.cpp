#include "world/world_runtime_items.hpp"

#include "game/movement/teleport.hpp"
#include "items/containers/container.hpp"
#include "items/item.hpp"
#include "items/tile.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
#endif

namespace world_runtime {
	using world_layers::Value;

	namespace {
		const std::map<std::string, ItemAttribute_t> nativeAttributes {
			{ "aid", ItemAttribute_t::ACTIONID }, { "uid", ItemAttribute_t::UNIQUEID }, { "text", ItemAttribute_t::TEXT }, { "description", ItemAttribute_t::DESCRIPTION }, { "name", ItemAttribute_t::NAME }, { "article", ItemAttribute_t::ARTICLE }, { "plural", ItemAttribute_t::PLURALNAME }, { "writer", ItemAttribute_t::WRITER }, { "date", ItemAttribute_t::DATE }
		};

		Value customValue(const CustomAttribute* value) {
			if (!value) {
				return {};
			}
			if (value->hasValue<int64_t>()) {
				return Value { value->getInteger() };
			}
			if (value->hasValue<double>()) {
				return Value { value->getDouble() };
			}
			if (value->hasValue<bool>()) {
				return Value { value->getBool() };
			}
			return Value { value->getString() };
		}
	}

	Position native(const world_layers::Position &p) {
		return { static_cast<uint16_t>(p.x), static_cast<uint16_t>(p.y), static_cast<uint8_t>(p.z) };
	}
	world_layers::Position portable(const Position &p) {
		return { p.x, p.y, p.z };
	}
	uint16_t uid(const std::shared_ptr<Item> &item) {
		return item->getAttribute<uint16_t>(ItemAttribute_t::UNIQUEID);
	}

	std::vector<std::shared_ptr<Item>> mapOrderedItems(const TileItemVector &items) {
		std::vector<std::shared_ptr<Item>> result;
		result.reserve(items.size());
		// OTBM/RME order is bottom-to-top. The server stores down items in
		// reverse order before the always-on-top group; gameplay keeps that
		// native order, while occurrence selectors use the authored order.
		result.insert(result.end(), items.getBeginTopItem(), items.getEndTopItem());
		for (auto it = items.getEndDownItem(); it != items.getBeginDownItem();) {
			result.push_back(*--it);
		}
		return result;
	}

	Value::Record overrides(const world_layers::Object &object) {
		auto result = object.attributes;
		if (object.aidOverride || object.aid) {
			result["aid"] = Value { int64_t(object.aid) };
		}
		if (object.uidOverride || object.uid) {
			result["uid"] = Value { int64_t(object.uid) };
		}
		return result;
	}

	Value::Record captureAttributes(const std::shared_ptr<Item> &item, const Value::Record &fields) {
		Value::Record result;
		for (const auto &[name, value] : fields) {
			if (name == "custom") {
				Value::Record custom;
				for (const auto &[key, unused] : std::get<Value::Record>(value.data)) {
					custom[key] = customValue(item->getCustomAttribute(key));
				}
				result[name] = Value { std::move(custom) };
			} else if (const auto it = nativeAttributes.find(name); it != nativeAttributes.end()) {
				if (!item->hasAttribute(it->second)) {
					result[name] = Value {};
				} else if (ItemAttributeHelper::isAttributeInteger(it->second)) {
					result[name] = Value { item->getAttribute<int64_t>(it->second) };
				} else {
					result[name] = Value { item->getAttribute<std::string>(it->second) };
				}
			}
		}
		return result;
	}

	void applyAttributes(const std::shared_ptr<Item> &item, const Value::Record &values) {
		for (const auto &[name, value] : values) {
			if (name == "custom") {
				for (const auto &[key, custom] : std::get<Value::Record>(value.data)) {
					item->removeCustomAttribute(key);
					std::visit([&](const auto &scalar) {
						using T = std::decay_t<decltype(scalar)>;
						if constexpr (std::is_same_v<T, bool> || std::is_same_v<T, int64_t> || std::is_same_v<T, double> || std::is_same_v<T, std::string>) {
							item->setCustomAttribute(key, scalar);
						}
					},
					           custom.data);
				}
			} else if (const auto it = nativeAttributes.find(name); it != nativeAttributes.end()) {
				item->removeAttribute(it->second);
				if (const auto integer = std::get_if<int64_t>(&value.data)) {
					if ((name != "aid" && name != "uid") || *integer != 0) {
						item->setAttribute(it->second, *integer);
					}
				} else if (const auto text = std::get_if<std::string>(&value.data)) {
					item->setAttribute(it->second, *text);
				}
			}
		}
	}

	world_layers::MapItem snapshot(const std::shared_ptr<Item> &item, std::unordered_map<uint64_t, std::shared_ptr<Item>> &items, bool ground) {
		world_layers::MapItem result;
		result.key = reinterpret_cast<uintptr_t>(item.get());
		result.itemId = item->getID();
		result.uid = uid(item);
		result.aid = item->getAttribute<uint16_t>(ItemAttribute_t::ACTIONID);
		result.ground = ground;
		items[result.key] = item;
		for (const auto &[name, type] : nativeAttributes) {
			if (name == "aid" || name == "uid" || !item->hasAttribute(type)) {
				continue;
			}
			if (ItemAttributeHelper::isAttributeInteger(type)) {
				result.attributes[name] = Value { item->getAttribute<int64_t>(type) };
			} else {
				result.attributes[name] = Value { item->getAttribute<std::string>(type) };
			}
		}
		Value::Record custom;
		for (const auto &[name, value] : item->getCustomAttributeMap()) {
			if (!name.starts_with("__world.")) {
				custom[name] = customValue(&value);
			}
		}
		if (!custom.empty()) {
			result.attributes["custom"] = Value { std::move(custom) };
		}
		if (const auto teleport = item->getTeleport()) {
			result.teleport = true;
			result.destination = portable(teleport->getDestPos());
		}
		if (const auto container = item->getContainer()) {
			result.container = true;
			for (const auto &child : container->getItemList()) {
				result.children.push_back(snapshot(child, items));
			}
		}
		return result;
	}

	bool attach(const std::shared_ptr<Cylinder> &parent, const std::shared_ptr<Item> &item, uint32_t order) {
		if (!parent || !item || item->getParent()) {
			return false;
		}
		if (const auto container = parent->getContainer()) {
			return container->insertWorldItem(item, order);
		}
		if (const auto tile = parent->getTile()) {
			if ((Item::items[item->getID()].isGroundTile() && tile->getGround())
			    || (tile->getItemList() && tile->getItemList()->size() >= 0xffff)) {
				return false;
			}
		}
		parent->internalAddThing(item);
		if (parent->getThingIndex(item) >= 0) {
			return true;
		}
		item->resetParent();
		return false;
	}

	std::string marker(const std::shared_ptr<Item> &item, const std::string &project) {
		const auto owner = item->getCustomAttribute("__world.project");
		const auto identity = item->getCustomAttribute("__world.object");
		return owner && identity && owner->hasValue<std::string>() && identity->hasValue<std::string>() && owner->getString() == project ? identity->getString() : "";
	}
	void mark(const std::shared_ptr<Item> &item, const std::string &project, const std::string &id) {
		item->setCustomAttribute("__world.project", project);
		item->setCustomAttribute("__world.object", id);
	}
	void unmark(const std::shared_ptr<Item> &item) {
		item->removeCustomAttribute("__world.project");
		item->removeCustomAttribute("__world.object");
	}
}
