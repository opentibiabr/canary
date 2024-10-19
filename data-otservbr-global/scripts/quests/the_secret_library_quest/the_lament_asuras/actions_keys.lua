local doors = {
	[1] = { key = 28476, position = Position(32813, 32813, 9) },
	[2] = { key = 28477, position = Position(32864, 32810, 9) },
}

local locked = 23873
local opened = 23877

local function revert(position)
	local lockedDoor = Tile(position):getItemById(opened)
	if lockedDoor then
		lockedDoor:transform(locked)
	end
end

local actions_asura_keys = Action()

function actions_asura_keys.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for _, k in pairs(doors) do
		if item.itemid == k.key then
			if toPosition == k.position and target.itemid == locked then
				target:transform(opened)
				addEvent(revert, 10 * 1000, target:getPosition())
			end
		end
	end

	return true
end

for _, door in pairs(doors) do
	actions_asura_keys:id(door.key)
end

actions_asura_keys:register()
