local config = {
-- outside wagons --
	[50136] = Position(32618, 31899, 9),
	[50137] = Position(32620, 31899, 9),
	[50138] = Position(32614, 31899, 9),
	[50139] = Position(32616, 31899, 9),
-- kaz main gate wagons --
	[50140] = Position(32673, 31975, 15), -- Steamboat
	[50141] = Position(32625, 31921, 11), -- Temple
	[50142] = Position(32605, 31902, 9), -- Shops
	[50143] = Position(32654, 31902, 8), -- Depot
-- kaz temple wagons --
	[50144] = Position(32575, 31974, 9), -- Main gate
	[50145] = Position(32674, 31975, 15), -- Steamboat
	[50146] = Position(32605, 31907, 9), -- Shops
	[50147] = Position(32655, 31902, 8), -- Depot
-- kaz steamboat wagons --
	[50148] = Position(32575, 31977, 9), -- Main gate
	[50149] = Position(32626, 31921, 11), -- Temple
	[50150] = Position(32605, 31908, 9), -- Shops
	[50151] = Position(32660, 31902, 8), -- Depot
-- kaz depot wagons --
	[50152] = Position(32575, 31968, 9), -- Main gate
	[50153] = Position(32631, 31921, 11), -- Temple
	[50154] = Position(32605, 31903, 9), -- Shops
	[50155] = Position(32679, 31975, 15), -- Steamboat
-- kaz shop wagons --
	[50156] = Position(32678, 31975, 15), -- Steamboat
	[50157] = Position(32630, 31921, 11), -- Temple
	[50158] = Position(32659, 31902, 8), -- Depot
	[50159] = Position(32575, 31971, 9), -- Main gate
-- inside to outside wagons --
	[50230] = Position(32600, 31875, 7), -- Kazordoon Surface North
	[50231] = Position(32577, 31929, 0), -- Colossus Top
	[50232] = Position(32619, 31944, 7), -- Kazordoon Surface South
	[50233] = Position(32553, 31930, 7), -- Kazordoon Surface West
-- Lost Cavern
	[50245] = Position(32526, 31840, 9), -- To: Entrance Area
	[50246] = Position(32559, 31852, 7), -- To: Entrance Door
	[50247] = Position(32499, 31827, 9), -- To: Crystal Storage
	[50248] = Position(32517, 31806, 9), -- To: Crystal Mining
	[50249] = Position(32515, 31827, 9), -- To: Entrance Area
	[50250] = Position(32489, 31812, 9), -- To: Crystal Cultivation
	[50251] = Position(32495, 31833, 9), -- To: Crystal Storage
	[50252] = Position(32511, 31806, 9), -- To: Crystal Mining
	[50253] = Position(32498, 31807, 9), -- To: Crystal Cultivation
	[50254] = Position(32516, 31829, 9) -- To: Entrance Area
}

local oreWagons = Action()

function oreWagons.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[item.actionid]
	if not targetPosition then
		return true
	end

	if item.actionid < 50245 and player:getStorageValue(Storage.WagonTicket) < os.time() then
		player:say("Purchase a weekly ticket from Gewen, Lokur in the post office, The Lukosch brothers or from Brodrosch on the steamboat.", TALKTYPE_MONSTER_SAY)
		return true
	end

	player:addAchievementProgress('Rollercoaster', 100)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(targetPosition)
	targetPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

for index, value in pairs(config) do
	oreWagons:aid(index)
end

oreWagons:register()
