local destination = {
	[64007] = Position(33345, 31347, 7), --Falcon
	[64008] = Position(33357, 31308, 4), --Falcon
	[64009] = Position(33382, 31292, 7), --Falcon
	[64010] = Position(33327, 31351, 7), --Falcon
	[64011] = Position(33201, 31765, 1), --Falcon
	[64012] = Position(33327, 31351, 7), --Falcon
	[64013] = Position(32958, 32324, 8), --Deep desert
	[64014] = Position(33110, 32386, 7), --Deep desert
}

local teleport = MoveEvent()

function teleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = destination[item.actionid]
	if teleport then
		player:teleportTo(teleport)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		teleport:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

teleport:type("stepin")

for index, value in pairs(destination) do
	teleport:aid(index)
end

teleport:register()
