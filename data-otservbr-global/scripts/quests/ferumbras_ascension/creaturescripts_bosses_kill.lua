local bosses = {
	["the lord of the lice"] = {
		teleportPos = Position(33226, 31478, 12),
		godbreakerPos = Position(33237, 31477, 13),
		cooldown = 44, -- hours
		storage = Storage.Quest.U10_90.FerumbrasAscension.TheLordOfTheLiceTime,
	},
	["tarbaz"] = {
		teleportPos = Position(33460, 32853, 11),
		godbreakerPos = Position(33427, 32852, 13),
		cooldown = 44, -- hours
		storage = Storage.Quest.U10_90.FerumbrasAscension.TarbazTime,
	},
	["ragiaz"] = {
		teleportPos = Position(33482, 32345, 13),
		godbreakerPos = Position(33466, 32392, 13),
		cooldown = 44, -- hours
		storage = Storage.Quest.U10_90.FerumbrasAscension.RagiazTime,
	},
	["plagirath"] = {
		teleportPos = Position(33174, 31511, 13),
		godbreakerPos = Position(33204, 31510, 13),
		cooldown = 44, -- hours
		storage = Storage.Quest.U10_90.FerumbrasAscension.PlagirathTime,
	},
	["razzagorn"] = {
		teleportPos = Position(33357, 32434, 12),
		godbreakerPos = Position(33357, 32440, 13),
		cooldown = 44, -- hours
		storage = Storage.Quest.U10_90.FerumbrasAscension.RazzagornTime,
	},
	["zamulosh"] = {
		teleportPos = Position(33644, 32764, 11),
		godbreakerPos = Position(33678, 32758, 13),
		cooldown = 44, -- hours
		storage = Storage.Quest.U10_90.FerumbrasAscension.ZamuloshTime,
	},
	["mazoran"] = {
		teleportPos = Position(33585, 32699, 14),
		godbreakerPos = Position(33614, 32679, 15),
		cooldown = 44, -- hours
		storage = Storage.Quest.U10_90.FerumbrasAscension.MazoranTime,
	},
	["shulgrax"] = {
		teleportPos = Position(33486, 32796, 13),
		godbreakerPos = Position(33459, 32820, 14),
		cooldown = 44, -- hours
		storage = Storage.Quest.U10_90.FerumbrasAscension.ShulgraxTime,
	},
	["ferumbras mortal shell"] = {
		teleportPos = Position(33392, 31485, 14),
		godbreakerPos = Position(33388, 31414, 14),
		cooldown = 332, -- hours - 13 days and 20 hours
		storage = Storage.Quest.U10_90.FerumbrasAscension.FerumbrasMortalShellTime,
	},
}

local crystals = {
	[1] = { crystalPosition = Position(33390, 31468, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal1 },
	[2] = { crystalPosition = Position(33394, 31468, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal2 },
	[3] = { crystalPosition = Position(33397, 31471, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal3 },
	[4] = { crystalPosition = Position(33397, 31475, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal4 },
	[5] = { crystalPosition = Position(33394, 31478, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal5 },
	[6] = { crystalPosition = Position(33390, 31478, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal6 },
	[7] = { crystalPosition = Position(33387, 31475, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal7 },
	[8] = { crystalPosition = Position(33387, 31471, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal8 },
}

local function transformCrystal(player)
	for c = 1, #crystals do
		local crystal = crystals[c]
		player:setStorageValue(crystal.globalStorage, 0)
		player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Crystals.AllCrystals, 0)
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

local ascendantBossesKill = CreatureEvent("AscendantBossesDeath")

local function formatCooldownMessage(cooldownHours)
	local days = math.floor(cooldownHours / 24)
	local hours = cooldownHours % 24
	if days > 0 then
		return string.format("%d days and %d hours", days, hours)
	else
		return string.format("%d hours", hours)
	end
end

function ascendantBossesKill.onDeath(creature)
	local bossConfig = bosses[creature:getName():lower()]
	if not bossConfig then
		return true
	end

	onDeathForDamagingPlayers(creature, function(creature, player)
		local bossName = creature:getName():lower()
		if bossConfig.storage then
			local cooldownTime = bossConfig.cooldown * 3600
			local nextAvailableTime = os.time() + cooldownTime
			player:setStorageValue(bossConfig.storage, nextAvailableTime)
			local cooldownMessage = formatCooldownMessage(bossConfig.cooldown)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have defeated " .. bossName .. ". You can challenge this boss again in " .. cooldownMessage .. ".")
		end
	end)

	local teleport = Tile(bossConfig.teleportPos):getItemById(1949)
	if teleport then
		teleport:transform(22761)
		teleport:getPosition():sendMagicEffect(CONST_ME_THUNDER)
		teleport:setDestination(bossConfig.godbreakerPos)
		addEvent(revertTeleport, 1 * 60 * 1000, bossConfig.teleportPos, 22761, 1949, Position(33319, 32318, 13))
	end

	if creature:getName():lower() == "ferumbras mortal shell" then
		onDeathForDamagingPlayers(creature, function(creature, player)
			addEvent(transformCrystal, 2 * 60 * 1000, player)
		end)
	end

	return true
end

ascendantBossesKill:register()
