local destinations = {
	[28810] = Position(32838, 32304, 9),
	[28811] = Position(32839, 32320, 9),
	[28812] = Position(32844, 32310, 9),
	[28813] = Position(32847, 32307, 9),
	[28814] = Position(32856, 32306, 9),
	[28815] = Position(32827, 32308, 9),
	[28816] = Position(32840, 32317, 9),
	[28817] = Position(32855, 32296, 9),
	[28818] = Position(32857, 32307, 9),
	[28819] = Position(32856, 32289, 9),
	[28820] = Position(32843, 32313, 9),
	[28821] = Position(32861, 32320, 9),
	[28822] = Position(32841, 32323, 9),
	[28823] = Position(32847, 32287, 9),
	[28824] = Position(32854, 32323, 9),
	[28825] = Position(32855, 32304, 9),
	[28826] = Position(32841, 32323, 9),
	[28827] = Position(32861, 32317, 9),
	[28828] = Position(32827, 32314, 9),
	[28829] = Position(32858, 32296, 9),
	[28830] = Position(32861, 32301, 9),
	[28831] = Position(32855, 32321, 9),
	[28832] = Position(32855, 32320, 9),
	[28833] = Position(32855, 32318, 9),
	[28834] = Position(32855, 32319, 9)
}

local tileTeleport = MoveEvent()

function tileTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:teleportTo(destinations[item.actionid])
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

tileTeleport:type("stepin")

for index, value in pairs(destinations) do
	tileTeleport:aid(index)
end

tileTeleport:register()
