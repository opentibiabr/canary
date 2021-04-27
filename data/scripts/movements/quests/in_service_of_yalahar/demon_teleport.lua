local teleports = {
	[3103] = {destination = Position(32861, 31061, 9), soilPosition = Position(32859, 31056, 9)},
	[3104] = {destination = Position(32856, 31055, 9)},
	[3105] = {destination = Position(32888, 31045, 9), soilPosition = Position(32894, 31044, 9)},
	[3106] = {destination = Position(32894, 31046, 9)},
}

local soilIds = {8302, 8303, 8298, 8299}

local demonTeleport = MoveEvent()

function demonTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = teleports[item.uid]
	if not teleport.soilPosition then
		player:teleportTo(teleport.destination)
		teleport.destination:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local soilItem
	local soilRemoved = false
	for i = 1, #soilIds do
		soilItem = Tile(teleport.soilPosition):getItemById(soilIds[i])
		if soilItem then
			soilItem:remove(1)
			soilRemoved = true
			break
		end
	end

	if not soilRemoved then
		player:teleportTo(fromPosition)
		fromPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
		player:say("You may not enter without a sacrifice of a elemental soil.", TALKTYPE_MONSTER_SAY)
		return true
	end

	player:teleportTo(teleport.destination)
	teleport.destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

demonTeleport:type("stepin")

for index, value in pairs(teleports) do
	demonTeleport:uid(index)
end

demonTeleport:register()
