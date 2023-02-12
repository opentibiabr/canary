local walls = {
	{ x = 32760, y = 32288, z = 14},
	{ x = 32761, y = 32288, z = 14},
	{ x = 32762, y = 32288, z = 14},
	{ x = 32763, y = 32288, z = 14},
	{ x = 32764, y = 32288, z = 14},
	{ x = 32764, y = 32289, z = 14},
	{ x = 32764, y = 32290, z = 14},
	{ x = 32764, y = 32291, z = 14},
	{ x = 32764, y = 32292, z = 14},
	{ x = 32763, y = 32292, z = 14},
	{ x = 32762, y = 32292, z = 14},
	{ x = 32761, y = 32292, z = 14},
	{ x = 32760, y = 32292, z = 14},
	{ x = 32760, y = 32291, z = 14},
	{ x = 32760, y = 32290, z = 14},
	{ x = 32760, y = 32289, z = 14}
}

local wallTeleport = MoveEvent()

function wallTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	for i = 1, #walls do
		if Tile(Position(walls[i])):hasFlag(TILESTATE_IMMOVABLEBLOCKSOLID) then
			player:teleportTo(Position(32762, 32305, 14))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end

	player:teleportTo(Position(32852, 32287, 14))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

wallTeleport:type("stepin")
wallTeleport:uid(9030)
wallTeleport:register()
