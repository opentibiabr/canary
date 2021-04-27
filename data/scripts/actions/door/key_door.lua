local doorId = {}
local keyLockedDoor = {}
local keyUnlockedDoor = {}
for index, value in ipairs(KeyDoorTable) do
	if not table.contains(doorId, value.closedDoor) then
		table.insert(doorId, value.closedDoor)
	end
	if not table.contains(doorId, value.lockedDoor) then
		table.insert(doorId, value.lockedDoor)
	end
	if not table.contains(doorId, value.openDoor) then
		table.insert(doorId, value.openDoor)
	end
	if not table.contains(keyLockedDoor, value.lockedDoor) then
		table.insert(keyLockedDoor, value.lockedDoor)
	end
	if not table.contains(keyUnlockedDoor, value.closedDoor) then
		table.insert(keyUnlockedDoor, value.closedDoor)
	end
end

for index, value in pairs(keysID) do
	if not table.contains(doorId, value) then
		table.insert(doorId, value)
	end
end

local keyDoor = Action()
function keyDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- It is locked msg
	if table.contains(keyLockedDoor, item.itemid) or (table.contains(keyUnlockedDoor, item.itemid) and table.contains({1001, 101}, item.actionid)) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is locked.")
		return true
	end

	-- onUse unlocked key door
	for index, value in ipairs(KeyDoorTable) do
		if value.closedDoor == item.itemid then
			item:transform(value.openDoor)
			return true
		end
	end
	for index, value in ipairs(KeyDoorTable) do
		if value.openDoor == item.itemid then
			if Creature.checkCreatureInsideDoor(player, toPosition) then
				return false
			end
			item:transform(value.closedDoor)
			return true
		end
	end

	-- Key use on door (locked key door)
	if target.actionid > 0 then
		for index, value in ipairs(KeyDoorTable) do
			if item.actionid ~= target.actionid and value.lockedDoor == target.itemid then
				player:sendCancelMessage("The key does not match.")
				return true
			end
			if item.actionid == target.actionid then
				if value.lockedDoor == target.itemid then
					target:transform(value.openDoor)
					return true
				elseif table.contains({value.openDoor, value.closedDoor}, target.itemid) then
					target:transform(value.lockedDoor)
					return true
				end
			end
		end
	end
	return false
end

for key, value in pairs(doorId) do
	keyDoor:id(value)
end

keyDoor:register()
