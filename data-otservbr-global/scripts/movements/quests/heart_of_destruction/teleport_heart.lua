local vortex = {
	[14321] = Position(32149, 31359, 14), -- Charger TP 1
	[14322] = Position(32092, 31330, 12), -- Charger Exit
	[14324] = Position(32104, 31329, 12), -- Anomaly Exit
	[14325] = Position(32216, 31380, 14), -- Main Room
	[14340] = Position(32159, 31329, 11), -- Main Room Exit
	[14341] = Position(32078, 31320, 13), -- Cracklers Exit
	[14343] = Position(32088, 31321, 13), -- Rupture Exit
	[14345] = Position(32230, 31358, 11), -- Realityquake Exit
	[14347] = Position(32225, 31347, 11), -- Unstable Sparks Exit
	[14348] = Position(32218, 31375, 14), -- Eradicator Exit (Main Room)
	[14350] = Position(32208, 31372, 14), -- Outburst Exit (Main Room)
	[14352] = Position(32214, 31376, 14), -- World Devourer Exit (Main Room)
	[14354] = Position(32112, 31375, 14), -- World Devourer (Reward Room)
}

local accessVortex = {
	-- Anomaly enter
	[14323] = {
		position = Position(32246, 31252, 14),
		storage = 14320,
		storageTime = 14321
	},
	-- Rupture enter
	[14342] = {
		position = Position(32305, 31249, 14),
		storage = 14322,
		storageTime = 14323
	},
	-- Realityquake enter
	[14344] = {
		position = Position(32181, 31240, 14),
		storage = 14324,
		storageTime = 14325
	},
}

local finalBosses = {
	-- Eradicator enter
	[14346] = {
		position = Position(32336, 31293, 14),
		storage1 = 14326,
		storage2 = 14327,
		storage3 = 14328,
		storageTime = 14329
	},
	-- Outburst enter
	[14349] = {
		position = Position(32204, 31290, 14),
		storage1 = 14326,
		storage2 = 14327,
		storage3 = 14328,
		storageTime = 14331
	}
}

local teleportHeart = MoveEvent()

function teleportHeart.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local normalVortex = vortex[item.actionid]
	local bossVortex = accessVortex[item.actionid]
	local uBosses = finalBosses[item.actionid]
	if normalVortex then
		player:teleportTo(normalVortex)
	elseif bossVortex then
		if player:getStorageValue(bossVortex.storage) >= 1 then
			if player:getStorageValue(bossVortex.storageTime) < os.time() then
				player:teleportTo(bossVortex.position)
			else
				player:teleportTo(fromPosition)
				player:sendTextMessage(19, "It's too early for you to endure this challenge again.")
			end
		else
			player:teleportTo(fromPosition)
			player:sendTextMessage(19, "You don't have access to this portal.")
		end
	elseif uBosses then
		if player:getStorageValue(uBosses.storage1) >= 1
		and player:getStorageValue(uBosses.storage2) >= 1
		and player:getStorageValue(uBosses.storage3) >= 1 then
			if player:getStorageValue(uBosses.storageTime) < os.time() then
				player:teleportTo(uBosses.position)
			else
				player:teleportTo(fromPosition)
				player:sendTextMessage(19, "It's too early for you to endure this challenge again.")
			end
		else
			player:teleportTo(fromPosition)
			player:sendTextMessage(19, "You don't have access to this portal.")
		end
	elseif item.actionid == 14351 then
		if player:getStorageValue(14330) >= 1
		and player:getStorageValue(14332) >= 1 then
			if player:getStorageValue(14333) < os.time() then
				player:teleportTo(Position(32272, 31384, 14))
			else
				player:teleportTo(fromPosition)
				player:sendTextMessage(19, "It's too early for you to endure this challenge again.")
			end
		else
			player:teleportTo(fromPosition)
			player:sendTextMessage(19, "You don't have access to this portal.")
		end
	elseif item.actionid == 14353 then -- Remove storages from mini bosses
		player:teleportTo(Position(32214, 31376, 14))
		player:setStorageValue(14334, -1)
		player:setStorageValue(14335, -1)
		player:setStorageValue(14336, -1)
		player:unregisterEvent("DevourerStorage")
	end
	return true
end

teleportHeart:type("stepin")

for index, value in pairs(vortex) do
	teleportHeart:aid(index)
end

teleportHeart:register()
