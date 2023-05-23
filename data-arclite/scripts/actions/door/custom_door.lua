local doorIds = {}
for index, value in ipairs(CustomDoorTable) do
	if not table.contains(doorIds, value.openDoor) then
		table.insert(doorIds, value.openDoor)
	end

	if not table.contains(doorIds, value.closedDoor) then
		table.insert(doorIds, value.closedDoor)
	end
end

local customDoor = Action()
function customDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if Creature.checkCreatureInsideDoor(player, toPosition) then
		return true
	end

	for index, value in ipairs(CustomDoorTable) do
		 if value.closedDoor == item.itemid then
			item:transform(value.openDoor)
			return true
		end
	end
	for index, value in ipairs(CustomDoorTable) do
		if value.openDoor == item.itemid then
			item:transform(value.closedDoor)
			return true
		end
	end
	return true
end

for index, value in ipairs(doorIds) do
	customDoor:id(value)
end

customDoor:register()
