local dryadPos = {
	-- unique id, destination
	-- entrance
	[33331] = Position(33202 , 32012, 11),
	
	-- exit
	[33332] = Position(33264 , 32012, 7)

}

local dryadAction = Action()

function dryadAction.onUse(player, item, target, position, fromPosition)
	local destination = dryadPos[item.uid]
	if not destination then
		return true
	end

	player:teleportTo(destination)
	player:getPosition():sendMagicEffect(CONST_ME_WATERSPLASH)
	return true
end

for i, x in pairs(dryadPos) do
	dryadAction:uid(i)
end

dryadAction:register()
