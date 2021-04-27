local config = {
	[50122] = Position(32704, 31507, 12), -- small tunnel with golems
	[50123] = Position(32661, 31495, 13), -- mushroom quest
	[50124] = Position(32687, 31470, 13), -- wagon maze
	[50125] = Position(32690, 31495, 11) -- room with lava that I couldn't find, setting destination to the same as mushroom quest
}

local theHiddenCoalExit = Action()
function theHiddenCoalExit.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[item.actionid]
	if not targetPosition then
		return true
	end

	player:teleportTo(targetPosition)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	item:remove()
	return true
end

theHiddenCoalExit:aid(50122,50123,50124,50125)
theHiddenCoalExit:register()