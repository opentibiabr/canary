local config = {
	teleports = {
		-- { position = Position(33187, 31190, 7), destination = Position(33217, 31123, 14) }, -- Entrace Nimmersatt's Breeding Ground
		-- { position = Position(33216, 31126,14), destination = Position(33188, 31193, 7) }, -- Leave Nimmersatt's Breeding Ground
		{
			position = Position(32799, 32365, 8),
			destination = Position(32872, 32372, 8),
		}, -- Entrace Bulltaur Lair
		{
			position = Position(32874, 32374, 8),
			destination = Position(32800, 32368, 8),
		}, -- Leave Bulltaur Lair
	},
}

local Omnious_Trashcan = MoveEvent()

function Omnious_Trashcan.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	for c = 1, #config.teleports do
		if config.teleports[c].position then
			if player:getPosition() == Position(config.teleports[c].position) then
				if config.teleports[c].access then
					if player:getStorageValue(config.teleports[c].access) > 0 then
						player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
						player:teleportTo(config.teleports[c].destination)
						player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					else
						player:teleportTo(fromPosition)
					end
				else
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					player:teleportTo(config.teleports[c].destination)
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				end
			end
		elseif config.teleports[c].positions then
			for d = 1, #config.teleports[c].positions do
				if player:getPosition() == Position(config.teleports[c].positions[d]) then
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					player:teleportTo(config.teleports[c].destination)
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				end
			end
		end
	end
end

for a = 1, #config.teleports do
	if config.teleports[a].position then
		Omnious_Trashcan:position(config.teleports[a].position)
	elseif config.teleports[a].positions then
		for b = 1, #config.teleports[a].positions do
			Omnious_Trashcan:position(config.teleports[a].positions[b])
		end
	end
end
Omnious_Trashcan:register()
