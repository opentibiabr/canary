local setting = {1948, 1968, 5542, 20474, 20475, 28656, 31262}

local ladder = Action()

function ladder.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if table.contains(setting, item.itemid) then
		fromPosition:moveUpstairs()
	else
		fromPosition.z = fromPosition.z + 1
	end

	if player:isPzLocked() and Tile(fromPosition):hasFlag(TILESTATE_PROTECTIONZONE) then
		player:sendCancelMessage(RETURNVALUE_PLAYERISPZLOCKED)
		return true
	end

	player:teleportTo(fromPosition, false)
	return true
end

for index, value in ipairs(setting) do
    ladder:id(value)
end

ladder:register()
