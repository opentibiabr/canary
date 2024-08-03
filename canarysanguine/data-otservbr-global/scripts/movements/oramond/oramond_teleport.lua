local config = {
	[36489] = Position(33559, 31970, 12), --Glooth
	[42626] = Position(33539, 32014, 6), --Oramond
	[42627] = Position(33491, 31985, 7), --Oramond
	[42630] = Position(33636, 31891, 6), --City
	[42631] = Position(33486, 31982, 7), --City
	[50389] = Position(33651, 31942, 7), --Glooth
}

local oramondTeleport = MoveEvent()

function oramondTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = config[item.actionid]
	if teleport then
		player:teleportTo(teleport)
		fromPosition:sendMagicEffect(CONST_ME_GREEN_RINGS)
		teleport:sendMagicEffect(CONST_ME_GREEN_RINGS)
		player:say("Slrrp!", TALKTYPE_MONSTER_SAY)
	end
	return true
end

oramondTeleport:type("stepin")

for index, value in pairs(config) do
	oramondTeleport:aid(index)
end

oramondTeleport:register()
