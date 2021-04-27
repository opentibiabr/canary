local setting = {
	{storage = 210001, teleportPosition = Position(33032, 32400, 7)}, -- entrance teleport Darashia Northwest
	{storage = 210002, teleportPosition = Position(33215, 32273, 7)}, -- entrance teleport Darashia North
	{storage = 210016, teleportPosition = Position(33255, 32678, 7)} -- {x = 33255, y = 32678, z = 7}
}

local teleports = {
	[64001] = 210001, -- northwest Darashia
	[64002] = 210002, -- north Darashia
	[64003] = 210016  -- north Ankrahmun
}

local teleport = MoveEvent()

function teleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	for i = 1, #setting do
		local table = setting[i]
		local backStorage = table.storage
		if player:getStorageValue(backStorage) >= 1 then
			player:teleportTo(table.teleportPosition)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:setStorageValue(backStorage, 0)
			break
		end
	end

	local storagePortal = teleports[item.uid]
	if storagePortal then
		player:teleportTo(Position(33497, 32616, 8))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:setStorageValue(storagePortal, 1)
	end
	return true
end

teleport:uid(35020, 64001, 64002, 64003)
teleport:register()
