local bosses = {
	["the lord of the lice"] = { teleportPos = Position(33226, 31478, 12), godbreakerPos = Position(33237, 31477, 13) },
	["tarbaz"] = { teleportPos = Position(33460, 32853, 11), godbreakerPos = Position(33427, 32852, 13) },
	["ragiaz"] = { teleportPos = Position(33482, 32345, 13), godbreakerPos = Position(33466, 32392, 13) },
	["plagirath"] = { teleportPos = Position(33174, 31511, 13), godbreakerPos = Position(33204, 31510, 13) },
	["razzagorn"] = { teleportPos = Position(33413, 32467, 14), godbreakerPos = Position(33357, 32440, 13) },
	["zamulosh"] = { teleportPos = Position(33644, 32764, 11), godbreakerPos = Position(33678, 32758, 13) },
	["mazoran"] = { teleportPos = Position(33585, 32699, 14), godbreakerPos = Position(33614, 32679, 15) },
	["shulgrax"] = { teleportPos = Position(33486, 32796, 13), godbreakerPos = Position(33459, 32820, 14) },
	["ferumbras mortal shell"] = { teleportPos = Position(33392, 31485, 14), godbreakerPos = Position(33388, 31414, 14) },
}

local crystals = {
	[1] = { crystalPosition = Position(33390, 31468, 14), globalStorage = GlobalStorage.FerumbrasAscendant.Crystals.Crystal1 },
	[2] = { crystalPosition = Position(33394, 31468, 14), globalStorage = GlobalStorage.FerumbrasAscendant.Crystals.Crystal2 },
	[3] = { crystalPosition = Position(33397, 31471, 14), globalStorage = GlobalStorage.FerumbrasAscendant.Crystals.Crystal3 },
	[4] = { crystalPosition = Position(33397, 31475, 14), globalStorage = GlobalStorage.FerumbrasAscendant.Crystals.Crystal4 },
	[5] = { crystalPosition = Position(33394, 31478, 14), globalStorage = GlobalStorage.FerumbrasAscendant.Crystals.Crystal5 },
	[6] = { crystalPosition = Position(33390, 31478, 14), globalStorage = GlobalStorage.FerumbrasAscendant.Crystals.Crystal6 },
	[7] = { crystalPosition = Position(33387, 31475, 14), globalStorage = GlobalStorage.FerumbrasAscendant.Crystals.Crystal7 },
	[8] = { crystalPosition = Position(33387, 31471, 14), globalStorage = GlobalStorage.FerumbrasAscendant.Crystals.Crystal8 },
}
local function transformCrystal()
	for c = 1, #crystals do
		local crystal = crystals[c]
		Game.getStorageValue(crystal.globalStorage, 0)
		Game.getStorageValue(GlobalStorage.FerumbrasAscendant.Crystals.AllCrystals, 0)
		local item = Tile(crystal.crystalPosition):getItemById(14961)
		if item then
			item:transform(14955)
		end
	end
end

local function revertTeleport(position, itemId, transformId, destination)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
		item:setDestination(destination)
	end
end

local ascendantBossesKill = CreatureEvent("AscendantBossesKill")
function ascendantBossesKill.onDeath(creature)
	local bossConfig = bosses[creature:getName():lower()]
	if not bossConfig then
		return true
	end

	onDeathForDamagingPlayers(creature, function(creature, player)
		if creature:getName():lower() == "ferumbras mortal shell" then
			player:setBossCooldown(creature:getName(), os.time() + 60 * 60 * 14 * 24)
		elseif creature:getName():lower() == "the lord of the lice" then
			player:setStorageValue(Storage.FerumbrasAscension.TheLordOfTheLiceAccess, 1)
		end
	end)

	local teleport = Tile(bossConfig.teleportPos):getItemById(1949)
	if not teleport then
		return true
	end

	if teleport then
		teleport:transform(22761)
		creature:getPosition():sendMagicEffect(CONST_ME_THUNDER)
		teleport:setDestination(bossConfig.godbreakerPos)
		addEvent(revertTeleport, 2 * 60 * 1000, bossConfig.teleportPos, 22761, 1949, Position(33319, 32318, 13))
	end

	if creature:getName():lower() == "ferumbras mortal shell" then
		addEvent(transformCrystal, 2 * 60 * 1000)
	end
	return true
end

ascendantBossesKill:register()
