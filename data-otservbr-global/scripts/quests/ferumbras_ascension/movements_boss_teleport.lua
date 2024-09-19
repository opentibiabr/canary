local config = {
	[24830] = {
		storage = Storage.Quest.U10_90.FerumbrasAscension.Razzagorn,
		cooldownStorage = Storage.Quest.U10_90.FerumbrasAscension.RazzagornTime,
		bossName = "Razzagorn",
	},
	[24831] = {
		storage = Storage.Quest.U10_90.FerumbrasAscension.Ragiaz,
		cooldownStorage = Storage.Quest.U10_90.FerumbrasAscension.RagiazTime,
		bossName = "Ragiaz",
	},
	[24832] = {
		storage = Storage.Quest.U10_90.FerumbrasAscension.Zamulosh,
		cooldownStorage = Storage.Quest.U10_90.FerumbrasAscension.ZamuloshTime,
		bossName = "Zamulosh",
	},
	[24833] = {
		storage = Storage.Quest.U10_90.FerumbrasAscension.Mazoran,
		cooldownStorage = Storage.Quest.U10_90.FerumbrasAscension.MazoranTime,
		bossName = "Mazoran",
	},
	[24834] = {
		storage = Storage.Quest.U10_90.FerumbrasAscension.Tarbaz,
		cooldownStorage = Storage.Quest.U10_90.FerumbrasAscension.TarbazTime,
		bossName = "Tarbaz",
	},
	[24835] = {
		storage = Storage.Quest.U10_90.FerumbrasAscension.Shulgrax,
		cooldownStorage = Storage.Quest.U10_90.FerumbrasAscension.ShulgraxTime,
		bossName = "Shulgrax",
	},
	[24836] = {
		storage = Storage.Quest.U10_90.FerumbrasAscension.Plagirath,
		cooldownStorage = Storage.Quest.U10_90.FerumbrasAscension.PlagirathTime,
		bossName = "Plagirath",
	},
}

local bossTeleport = MoveEvent()

function bossTeleport.onStepIn(creature, item, position, fromPosition)
	local teleportConfig = config[item.actionid]
	if not teleportConfig then
		return false
	end
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local cooldownStorage = teleportConfig.cooldownStorage
	local bossName = teleportConfig.bossName
	local cooldownTime = player:getStorageValue(cooldownStorage)

	if cooldownTime > os.time() then
		local remainingTime = cooldownTime - os.time()
		local hours = math.floor(remainingTime / 3600)
		local minutes = math.floor((remainingTime % 3600) / 60)
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	if player:getStorageValue(teleportConfig.storage) ~= 1 then
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	return true
end

bossTeleport:type("stepin")

for index, value in pairs(config) do
	bossTeleport:aid(index)
end

bossTeleport:register()
