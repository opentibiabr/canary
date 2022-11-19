local config = {
	[4] = {{x = 33021, y = 31536, z = 4}, Position(33022, 31536, 6)},
	[6] = {{x = 33021, y = 31536, z = 6}, Position(33021, 31536, 4)}
}

local theNewFrontierVine = Action()
function theNewFrontierVine.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[player:getPosition().z]
	if not targetPosition then
		return true
	end

	player:teleportTo(targetPosition[2])
	targetPosition[2]:sendMagicEffect(CONST_ME_POFF)
	return true
end

for _, pos in pairs(config) do
	theNewFrontierVine:position(pos[1])
end
theNewFrontierVine:register()
