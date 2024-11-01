/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "declarations.hpp"

class MoveEvent;
class LuaScriptInterface;
class Item;
class Tile;
class Creature;
class Player;

struct MoveEventList {
	std::list<std::shared_ptr<MoveEvent>> moveEvent[MOVE_EVENT_LAST];
};

using VocEquipMap = std::map<uint16_t, bool>;

class MoveEvents {
public:
	MoveEvents() = default;
	~MoveEvents() = default;

	// non-copyable
	MoveEvents(const MoveEvents &) = delete;
	MoveEvents &operator=(const MoveEvents &) = delete;

	static MoveEvents &getInstance();

	uint32_t onCreatureMove(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &tile, MoveEvent_t eventType);
	uint32_t onPlayerEquip(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, Slots_t slot, bool isCheck);
	uint32_t onPlayerDeEquip(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, Slots_t slot);
	uint32_t onItemMove(const std::shared_ptr<Item> &item, const std::shared_ptr<Tile> &tile, bool isAdd);

	std::map<Position, MoveEventList> getPositionsMap() const {
		return positionsMap;
	}

	bool hasPosition(Position position) const {
		if (const auto it = positionsMap.find(position);
		    it != positionsMap.end()) {
			return true;
		}
		return false;
	}

	void setPosition(Position position, MoveEventList moveEventList) {
		positionsMap.try_emplace(position, moveEventList);
	}

	std::map<int32_t, MoveEventList> getItemIdMap() const {
		return itemIdMap;
	}

	bool hasItemId(int32_t itemId) const {
		if (const auto it = itemIdMap.find(itemId);
		    it != itemIdMap.end()) {
			return true;
		}
		return false;
	}

	void setItemId(int32_t itemId, MoveEventList moveEventList) {
		itemIdMap.try_emplace(itemId, moveEventList);
	}

	std::map<int32_t, MoveEventList> getUniqueIdMap() const {
		return uniqueIdMap;
	}

	bool hasUniqueId(int32_t uniqueId) const {
		if (const auto it = uniqueIdMap.find(uniqueId);
		    it != uniqueIdMap.end()) {
			return true;
		}
		return false;
	}

	void setUniqueId(int32_t uniqueId, MoveEventList moveEventList) {
		uniqueIdMap.try_emplace(uniqueId, moveEventList);
	}

	std::map<int32_t, MoveEventList> getActionIdMap() const {
		return actionIdMap;
	}

	bool hasActionId(int32_t actionId) const {
		if (const auto it = actionIdMap.find(actionId);
		    it != actionIdMap.end()) {
			return true;
		}
		return false;
	}

	void setActionId(int32_t actionId, MoveEventList moveEventList) {
		actionIdMap.try_emplace(actionId, moveEventList);
	}

	std::shared_ptr<MoveEvent> getEvent(const std::shared_ptr<Item> &item, MoveEvent_t eventType);

	bool registerLuaItemEvent(const std::shared_ptr<MoveEvent> &moveEvent);
	bool registerLuaActionEvent(const std::shared_ptr<MoveEvent> &moveEvent);
	bool registerLuaUniqueEvent(const std::shared_ptr<MoveEvent> &moveEvent);
	bool registerLuaPositionEvent(const std::shared_ptr<MoveEvent> &moveEvent);
	bool registerLuaEvent(const std::shared_ptr<MoveEvent> &event);
	void clear();

private:
	bool registerEvent(const std::shared_ptr<MoveEvent> &moveEvent, int32_t id, std::map<int32_t, MoveEventList> &moveListMap) const;
	bool registerEvent(const std::shared_ptr<MoveEvent> &moveEvent, const Position &position, std::map<Position, MoveEventList> &moveListMap) const;
	std::shared_ptr<MoveEvent> getEvent(const std::shared_ptr<Tile> &tile, MoveEvent_t eventType);

	std::shared_ptr<MoveEvent> getEvent(const std::shared_ptr<Item> &item, MoveEvent_t eventType, Slots_t slot);

	std::map<int32_t, MoveEventList> uniqueIdMap;
	std::map<int32_t, MoveEventList> actionIdMap;
	std::map<int32_t, MoveEventList> itemIdMap;
	std::map<Position, MoveEventList> positionsMap;
};

constexpr auto g_moveEvents = MoveEvents::getInstance;

class MoveEvent final : public SharedObject {
public:
	explicit MoveEvent();

	MoveEvent_t getEventType() const;
	void setEventType(MoveEvent_t type);

	uint32_t fireStepEvent(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Item> &item, const Position &pos) const;
	uint32_t fireAddRemItem(const std::shared_ptr<Item> &item, const std::shared_ptr<Item> &tileItem, const Position &pos) const;
	uint32_t fireAddRemItem(const std::shared_ptr<Item> &item, const Position &pos) const;
	uint32_t fireEquip(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, Slots_t slot, bool isCheck);

	uint32_t getSlot() const {
		return slot;
	}

	// Scripting to lua interface
	bool executeStep(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Item> &item, const Position &pos) const;
	bool executeEquip(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, Slots_t slot, bool isCheck) const;
	bool executeAddRemItem(const std::shared_ptr<Item> &item, const std::shared_ptr<Item> &tileItem, const Position &pos) const;
	// No have tile item
	bool executeAddRemItem(const std::shared_ptr<Item> &item, const Position &pos) const;
	//

	// onEquip information
	uint32_t getReqLevel() const {
		return reqLevel;
	}
	uint32_t getReqMagLv() const {
		return reqMagLevel;
	}
	bool isPremium() const {
		return premium;
	}
	const std::string &getVocationString() const {
		return vocationString;
	}
	void setVocationString(const std::string &str) {
		vocationString = str;
	}
	uint32_t getWieldInfo() const {
		return wieldInfo;
	}
	const std::map<uint16_t, bool> &getVocEquipMap() const {
		return vocEquipMap;
	}
	void addVocEquipMap(const std::string &vocName);
	bool getTileItem() const {
		return tileItem;
	}
	void setTileItem(bool b) {
		tileItem = b;
	}
	std::vector<uint32_t> getItemIdsVector() const {
		return itemIdVector;
	}
	void setItemId(uint32_t id) {
		itemIdVector.emplace_back(id);
	}
	std::vector<uint32_t> getActionIdsVector() const {
		return actionIdVector;
	}
	void setActionId(uint32_t id) {
		actionIdVector.emplace_back(id);
	}
	std::vector<uint32_t> getUniqueIdsVector() const {
		return uniqueIdVector;
	}
	void setUniqueId(uint32_t id) {
		uniqueIdVector.emplace_back(id);
	}
	std::vector<Position> getPositionsVector() const {
		return positionVector;
	}
	void setPosition(Position pos) {
		positionVector.emplace_back(pos);
	}
	void setSlot(uint32_t s) {
		slot = s;
	}
	uint32_t getRequiredLevel() const {
		return reqLevel;
	}
	void setRequiredLevel(uint32_t level) {
		reqLevel = level;
	}
	uint32_t getRequiredMagLevel() const {
		return reqMagLevel;
	}
	void setRequiredMagLevel(uint32_t level) {
		reqMagLevel = level;
	}
	bool needPremium() const {
		return premium;
	}
	void setNeedPremium(bool b) {
		premium = b;
	}
	void setWieldInfo(WieldInfo_t info) {
		wieldInfo |= info;
	}

	static uint32_t StepInField(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Item> &item, const Position &pos);
	static uint32_t StepOutField(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Item> &item, const Position &pos);

	static uint32_t AddItemField(const std::shared_ptr<Item> &item, const std::shared_ptr<Item> &tileItem, const Position &pos);
	static uint32_t RemoveItemField(const std::shared_ptr<Item> &item, const std::shared_ptr<Item> &tileItem, const Position &pos);

	static uint32_t EquipItem(const std::shared_ptr<MoveEvent> &moveEvent, const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, Slots_t slot, bool boolean);
	static uint32_t DeEquipItem(const std::shared_ptr<MoveEvent> &, const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, Slots_t slot, bool boolean);

	std::string getScriptTypeName() const;
	bool loadScriptId();
	int32_t getScriptId() const;
	void setScriptId(int32_t newScriptId);
	bool isLoadedScriptId() const;
	LuaScriptInterface* getScriptInterface() const;

private:
	int32_t m_scriptId {};

	uint32_t slot = SLOTP_WHEREEVER;

	MoveEvent_t eventType = MOVE_EVENT_NONE;
	/// Step function
	std::function<uint32_t(
		std::shared_ptr<Creature> creature,
		std::shared_ptr<Item> item,
		const Position &pos
	)>
		stepFunction;
	// Move function
	std::function<uint32_t(
		std::shared_ptr<Item> item,
		std::shared_ptr<Item> tileItem,
		const Position &pos
	)>
		moveFunction;
	// equipFunction
	std::function<uint32_t(
		std::shared_ptr<MoveEvent> moveEvent,
		const std::shared_ptr<Player> &player,
		std::shared_ptr<Item> item,
		Slots_t slot,
		bool boolean
	)>
		equipFunction;

	// onEquip information
	uint32_t reqLevel = 0;
	uint32_t reqMagLevel = 0;
	bool premium = false;
	std::string vocationString;
	uint32_t wieldInfo = 0;
	std::map<uint16_t, bool> vocEquipMap;
	bool tileItem = false;

	std::vector<uint32_t> itemIdVector;
	std::vector<uint32_t> actionIdVector;
	std::vector<uint32_t> uniqueIdVector;
	std::vector<Position> positionVector;

	friend class MoveEventFunctions;
	friend class ItemParse;
};
