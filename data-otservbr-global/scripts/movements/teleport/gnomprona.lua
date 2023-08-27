local teleports = {
	{ position = Position(33660, 32895, 14), destination = Position(33669, 32933, 15) },
	{ position = Position(33671, 32933, 15), destination = Position(33660, 32897, 14) },
	{ position = Position(33658, 32919, 15), destination = Position(33669, 32933, 15) },
	{ position = Position(33714, 32797, 14), destination = Position(33555, 32752, 14), access = Storage.Quest.U12_90.PrimalOrdeal.Bosses.MagmaBubbleKilled },
	{ position = Position(33558, 32754, 14), destination = Position(33714, 32799, 14) },
	{ position = Position(33567, 32758, 15), destination = Position(33555, 32752, 14) },
}

local gnomprona = MoveEvent()

function gnomprona.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	for c = 1, #teleports do
		if teleports[c].position then
			if player:getPosition() == Position(teleports[c].position) then
				if teleports[c].access then
					if player:getStorageValue(teleports[c].access) > 0 then
						player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
						player:teleportTo(teleports[c].destination)
						player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					else
						player:teleportTo(fromPosition)
					end
				else
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					player:teleportTo(teleports[c].destination)
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				end
			end
		elseif teleports[c].positions then
			for d = 1, #teleports[c].positions do
				if player:getPosition() == Position(teleports[c].positions[d]) then
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					player:teleportTo(teleports[c].destination)
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				end
			end
		end
	end
end

for a = 1, #teleports do
	if teleports[a].position then
		gnomprona:position(teleports[a].position)
	elseif teleports[a].positions then
		for b = 1, #teleports[a].positions do
			gnomprona:position(teleports[a].positions[b])
		end
	end
end
gnomprona:register()
