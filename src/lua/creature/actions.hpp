/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/scripts.hpp"
#include "declarations.hpp"
#include "lua/scripts/luascript.hpp"

class Action;
class Position;

class Action : public Script {
public:
	explicit Action(LuaScriptInterface* interface);

	// Scripting
	virtual bool executeUse(std::shared_ptr<Player> player, std::shared_ptr<Item> item, const Position &fromPosition, std::shared_ptr<Thing> target, const Position &toPosition, bool isHotkey);

	bool getAllowFarUse() const {
		return allowFarUse;
	}

	void setAllowFarUse(bool allow) {
		allowFarUse = allow;
	}

	bool getCheckLineOfSight() const {
		return checkLineOfSight;
	}

	void setCheckLineOfSight(bool state) {
		checkLineOfSight = state;
	}

	bool getCheckFloor() const {
		return checkFloor;
	}

	void setCheckFloor(bool state) {
		checkFloor = state;
	}

	std::vector<uint16_t> getItemIdsVector() const {
		return itemIds;
	}

	void setItemIdsVector(uint16_t id) {
		itemIds.emplace_back(id);
	}

	std::vector<uint16_t> getUniqueIdsVector() const {
		return uniqueIds;
	}

	void setUniqueIdsVector(uint16_t id) {
		uniqueIds.emplace_back(id);
	}

	std::vector<uint16_t> getActionIdsVector() const {
		return actionIds;
	}

	void setActionIdsVector(uint16_t id) {
		actionIds.emplace_back(id);
	}

	std::vector<Position> getPositionsVector() const {
		return positions;
	}

	void setPositionsVector(Position pos) {
		positions.emplace_back(pos);
	}

	bool hasPosition(Position position) {
		return std::ranges::find_if(positions.begin(), positions.end(), [position](Position storedPosition) {
				   if (storedPosition == position) {
					   return true;
				   }
				   return false;
			   })
			!= positions.end();
	}

	std::vector<Position> getPositions() const {
		return positions;
	}
	void setPositions(Position pos) {
		positions.emplace_back(pos);
	}

	virtual ReturnValue canExecuteAction(std::shared_ptr<Player> player, const Position &toPos);

	virtual bool hasOwnErrorHandler() {
		return false;
	}

	virtual std::shared_ptr<Thing> getTarget(std::shared_ptr<Player> player, std::shared_ptr<Creature> targetCreature, const Position &toPosition, uint8_t toStackPos) const;

private:
	std::string getScriptTypeName() const override {
		return "onUse";
	}

	std::function<bool(
		std::shared_ptr<Player> player, std::shared_ptr<Item> item,
		const Position &fromPosition, std::shared_ptr<Thing> target,
		const Position &toPosition, bool isHotkey
	)>
		useFunction = nullptr;

	// Atributes
	bool allowFarUse = false;
	bool checkFloor = true;
	bool checkLineOfSight = true;

	// IDs
	std::vector<uint16_t> itemIds;
	std::vector<uint16_t> uniqueIds;
	std::vector<uint16_t> actionIds;
	std::vector<Position> positions;

	friend class Actions;
};

class Actions final : public Scripts {
public:
	Actions();
	~Actions();

	// non-copyable
	Actions(const Actions &) = delete;
	Actions &operator=(const Actions &) = delete;

	static Actions &getInstance() {
		return inject<Actions>();
	}

	bool useItem(std::shared_ptr<Player> player, const Position &pos, uint8_t index, std::shared_ptr<Item> item, bool isHotkey);
	bool useItemEx(std::shared_ptr<Player> player, const Position &fromPos, const Position &toPos, uint8_t toStackPos, std::shared_ptr<Item> item, bool isHotkey, std::shared_ptr<Creature> creature = nullptr);

	ReturnValue canUse(std::shared_ptr<Player> player, const Position &pos);
	ReturnValue canUse(std::shared_ptr<Player> player, const Position &pos, std::shared_ptr<Item> item);
	ReturnValue canUseFar(std::shared_ptr<Creature> creature, const Position &toPos, bool checkLineOfSight, bool checkFloor);

	bool registerLuaItemEvent(const std::shared_ptr<Action> action);
	bool registerLuaUniqueEvent(const std::shared_ptr<Action> action);
	bool registerLuaActionEvent(const std::shared_ptr<Action> action);
	bool registerLuaPositionEvent(const std::shared_ptr<Action> action);
	bool registerLuaEvent(const std::shared_ptr<Action> action);
	// Clear maps for reloading
	void clear();

private:
	bool hasPosition(Position position) const {
		if (auto it = actionPositionMap.find(position);
		    it != actionPositionMap.end()) {
			return true;
		}
		return false;
	}

	[[nodiscard]] std::map<Position, std::shared_ptr<Action>> getPositionsMap() const {
		return actionPositionMap;
	}

	void setPosition(Position position, std::shared_ptr<Action> action) {
		actionPositionMap.try_emplace(position, action);
	}

	bool hasItemId(uint16_t itemId) const {
		if (auto it = useItemMap.find(itemId);
		    it != useItemMap.end()) {
			return true;
		}
		return false;
	}

	void setItemId(uint16_t itemId, const std::shared_ptr<Action> action) {
		useItemMap.try_emplace(itemId, action);
	}

	bool hasUniqueId(uint16_t uniqueId) const {
		if (auto it = uniqueItemMap.find(uniqueId);
		    it != uniqueItemMap.end()) {
			return true;
		}
		return false;
	}

	void setUniqueId(uint16_t uniqueId, const std::shared_ptr<Action> action) {
		uniqueItemMap.try_emplace(uniqueId, action);
	}

	bool hasActionId(uint16_t actionId) const {
		if (auto it = actionItemMap.find(actionId);
		    it != actionItemMap.end()) {
			return true;
		}
		return false;
	}

	void setActionId(uint16_t actionId, const std::shared_ptr<Action> action) {
		actionItemMap.try_emplace(actionId, action);
	}

	ReturnValue internalUseItem(std::shared_ptr<Player> player, const Position &pos, uint8_t index, std::shared_ptr<Item> item, bool isHotkey);
	static void showUseHotkeyMessage(std::shared_ptr<Player> player, std::shared_ptr<Item> item, uint32_t count);

	using ActionUseMap = std::map<uint16_t, std::shared_ptr<Action>>;
	ActionUseMap useItemMap;
	ActionUseMap uniqueItemMap;
	ActionUseMap actionItemMap;
	std::map<Position, std::shared_ptr<Action>> actionPositionMap;

	std::shared_ptr<Action> getAction(std::shared_ptr<Item> item);
};

constexpr auto g_actions = Actions::getInstance;
