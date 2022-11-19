local teleports = {
	{teleportsPosition = {
		{x = 32628, y = 31863, z = 11},
		{x = 32330, y = 32173, z = 9},
		{x = 32403, y = 32818, z = 6},
		{x = 33187, y = 32384, z = 8},
		{x = 32196, y = 31183, z = 8},
		{x = 33154, y = 31834, z = 10}}, destination = Position(32801, 31766, 9), storageValue = 1, needCrystal = true},
	{teleportPosition = {x = 32803, y = 31798, z = 9}, destination = Position(32627, 31864, 11), storageValue = 1, needCrystal = true},
	{teleportPosition = {x = 32795, y = 31761, z = 10}, destination = Position(33000, 31870, 13), storageValue = 1},
	{teleportPosition = {x = 33000, y = 31871, z = 13}, destination = Position(32795, 31762, 10), storageValue = 1},
	{teleportPosition = {x = 32803, y = 31745, z = 10}, destination = Position(32864, 31844, 11), storageValue = 1},
	{teleportPosition = {x = 32864, y = 31845, z = 11}, destination = Position(32803, 31746, 10), storageValue = 1},
	{teleportPosition = {x = 32796, y = 31780, z = 10}, destination = Position(32988, 31862, 9), storageValue = 120}, -- gnomebase alpha
	{teleportPosition = {x = 32986, y = 31861, z = 9}, destination = Position(32798, 31783, 10), storageValue = 120}, -- city
	{teleportPosition = {x = 33001, y = 31916, z = 9}, destination = Position(32959, 31953, 9), storageValue = 120}, -- golems
	{teleportPosition = {x = 32959, y = 31952, z = 9}, destination = Position(33001, 31915, 9), storageValue = 120}, -- back from golems
	{teleportPosition = {x = 32980, y = 31907, z = 9}, destination = Position(32904, 31894, 13), storageValue = 480}, -- vulcongras
	{teleportPosition = {x = 32904, y = 31893, z = 13}, destination = Position(32979, 31907, 9), storageValue = 480}, -- back from vulcongras
	{teleportPosition = {x = 32805, y = 31743, z = 9}, destination = Position(32329, 32172, 9), storageValue = 1, needCrystal = true},
	{teleportPosition = {x = 32786, y = 31754, z = 9}, destination = Position(32195, 31182, 8), storageValue = 1, needCrystal = true},
	{teleportPosition = {x = 32772, y = 31776, z = 9}, destination = Position(32402, 32816, 6), storageValue = 1, needCrystal = true},
	{teleportPosition = {x = 32831, y = 31797, z = 9}, destination = Position(33153, 31833, 10), storageValue = 1, needCrystal = true},
	{teleportPosition = {x = 32827, y = 31757, z = 9}, destination = Position(33186, 32385, 8), storageValue = 1, needCrystal = true},
	{teleportPosition = {x = 32789, y = 31796, z = 10}, destination = Position(32771, 31800, 10), storageValue = 25, needCrystal = false},
	{teleportPosition = {x = 32772, y = 31799, z = 10}, destination = Position(32790, 31795, 10), storageValue = 25, needCrystal = false}
}

local gnomebaseTeleport = MoveEvent()
function gnomebaseTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	for c = 1, #teleports do
		if teleports[c].teleportsPosition then
			for d = 1, #teleports[c].teleportsPosition do
				if player:getPosition() == Position(teleports[c].teleportsPosition[d]) then
					if player:getStorageValue(Storage.BigfootBurden.QuestLine) < 1 then
						fromPosition:sendMagicEffect(CONST_ME_POFF)
						player:teleportTo(fromPosition)
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have no idea on how to use this device. Xelvar in Kazordoon might tell you more about it.')
						return false
					end

					if player:getPosition() ~= Position(32988, 31862, 9) and player:getStorageValue(Storage.BigfootBurden.QuestLine) < teleports[c].storageValue then
						position:sendMagicEffect(CONST_ME_TELEPORT)
						player:teleportTo(fromPosition)
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your rank among the Gnomes is too low.")
						return false
					end

					if player:getPosition() == Position(32988, 31862, 9) and player:getStorageValue(Storage.BigfootBurden.Rank) < teleports[c].storageValue then
						position:sendMagicEffect(CONST_ME_TELEPORT)
						player:teleportTo(fromPosition)
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your rank among the Gnomes is too low.")
						return false
					end

					if not teleports[c].needCrystal or player:removeItem(16167, 1) then
						player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
						player:teleportTo(teleports[c].destination)
						player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					else
						fromPosition:sendMagicEffect(CONST_ME_POFF)
						player:teleportTo(fromPosition)
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You need a teleport crystal in order to use this device.')
					end
				end
			end
		elseif player:getPosition() == Position(teleports[c].teleportPosition) then
			if player:getStorageValue(Storage.BigfootBurden.QuestLine) < 1 then
				fromPosition:sendMagicEffect(CONST_ME_POFF)
				player:teleportTo(fromPosition)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have no idea on how to use this device. Xelvar in Kazordoon might tell you more about it.')
				return false
			end

			if teleports[c].storageValue < 100 and player:getStorageValue(Storage.BigfootBurden.QuestLine) < teleports[c].storageValue then
				position:sendMagicEffect(CONST_ME_TELEPORT)
				player:teleportTo(fromPosition)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your rank among the Gnomes is too low.")
				return false
			end

			if teleports[c].storageValue >= 100 and player:getStorageValue(Storage.BigfootBurden.Rank) < teleports[c].storageValue then
				position:sendMagicEffect(CONST_ME_TELEPORT)
				player:teleportTo(fromPosition)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your rank among the Gnomes is too low.")
				return false
			end

			if not teleports[c].needCrystal or player:removeItem(16167, 1) then
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				player:teleportTo(teleports[c].destination)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			else
				fromPosition:sendMagicEffect(CONST_ME_POFF)
				player:teleportTo(fromPosition)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You need a teleport crystal in order to use this device.')
			end
		end
	end
	return true
end

for a = 1, #teleports do
	if teleports[a].teleportsPosition then
		for b = 1, #teleports[a].teleportsPosition do
			gnomebaseTeleport:position(teleports[a].teleportsPosition[b])
		end
	else
		gnomebaseTeleport:position(teleports[a].teleportPosition)
	end
end
gnomebaseTeleport:register()