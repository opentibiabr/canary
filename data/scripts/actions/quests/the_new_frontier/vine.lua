local config = {
	[3153] = Position(33022, 31536, 6),
	[3154] = Position(33020, 31536, 4)
}

local theNewFrontierVine = Action()
function theNewFrontierVine.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[item.uid]
	if not targetPosition then
		return true
	end

	player:teleportTo(targetPosition)
	targetPosition:sendMagicEffect(CONST_ME_POFF)
	return true
end

theNewFrontierVine:uid(3153,3154)
theNewFrontierVine:register()