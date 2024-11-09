local config = {
	boss = {
		name = "",
		position = Position(32208, 32048, 14),
	},
	requiredLevel = 250,
	timeToFightAgain = 20 * 60 * 60,
	timeToDefeat = 30 * 60,
	playerPositions = {
		{ pos = Position(32208, 32021, 13), teleport = Position(32207, 32041, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32208, 32022, 13), teleport = Position(32207, 32041, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32208, 32023, 13), teleport = Position(32207, 32041, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32208, 32024, 13), teleport = Position(32207, 32041, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32208, 32025, 13), teleport = Position(32207, 32041, 14), effect = CONST_ME_TELEPORT },
	},
	monsters = {
		["Maxxenius"] = {
			{ name = "Generator", pos = Position(32205, 32048, 14) },
			{ name = "Generator", pos = Position(32210, 32045, 14) },
			{ name = "Generator", pos = Position(32210, 32051, 14) },
		},
		["Alptramun"] = {
			{ name = "unpleasant dream", pos = Position(32208, 32048, 14) },
			{ name = "unpleasant dream", pos = Position(32208, 32048, 14) },
		},
		["Izcandar The Banished"] = {
			{ name = "the heat of summer", pos = Position(32204, 32053, 14), delay = 15 * 1000 },
			{ name = "the heat of summer", pos = Position(32201, 32047, 14), delay = 15 * 1000 },
			{ name = "the heat of summer", pos = Position(32204, 32043, 14), delay = 15 * 1000 },
			{ name = "the cold of winter", pos = Position(32211, 32042, 14), delay = 15 * 1000 },
			{ name = "the cold of winter", pos = Position(32214, 32048, 14), delay = 15 * 1000 },
			{ name = "the cold of winter", pos = Position(32210, 32053, 14), delay = 15 * 1000 },
		},
		["Plagueroot"] = {
			{ name = "plant attendant", pos = Position(32204, 32047, 14), delay = 15 * 1000 },
			{ name = "plant attendant", pos = Position(32212, 32043, 14), delay = 15 * 1000 },
			{ name = "plant attendant", pos = Position(32212, 32050, 14), delay = 15 * 1000 },
		},
		["Malofur Mangrinder"] = {
			{ name = "whirling blades", pos = Position(32200, 32046, 14) },
			{ name = "whirling blades", pos = Position(32200, 32050, 14) },
			{ name = "whirling blades", pos = Position(32202, 32049, 14) },
			{ name = "whirling blades", pos = Position(32202, 32051, 14) },
			{ name = "whirling blades", pos = Position(32205, 32043, 14) },
			{ name = "whirling blades", pos = Position(32200, 32050, 14) },
			{ name = "whirling blades", pos = Position(32205, 32048, 14) },
			{ name = "whirling blades", pos = Position(32205, 32055, 14) },
			{ name = "whirling blades", pos = Position(32206, 32051, 14) },
			{ name = "whirling blades", pos = Position(32206, 32040, 14) },
			{ name = "whirling blades", pos = Position(32207, 32043, 14) },
			{ name = "whirling blades", pos = Position(32207, 32048, 14) },
			{ name = "whirling blades", pos = Position(32208, 32051, 14) },
			{ name = "whirling blades", pos = Position(32209, 32048, 14) },
			{ name = "whirling blades", pos = Position(32209, 32055, 14) },
			{ name = "whirling blades", pos = Position(32210, 32051, 14) },
			{ name = "whirling blades", pos = Position(32211, 32042, 14) },
			{ name = "whirling blades", pos = Position(32211, 32044, 14) },
			{ name = "whirling blades", pos = Position(32211, 32046, 14) },
			{ name = "whirling blades", pos = Position(32214, 32043, 14) },
			{ name = "whirling blades", pos = Position(32214, 32049, 14) },
			{ name = "whirling blades", pos = Position(32213, 32052, 14) },
		},
	},
	bossPosition = Position(32207, 32051, 14),
	specPos = {
		from = Position(32199, 32039, 14),
		to = Position(32229, 32055, 14),
	},
	exit = Position(32210, 32035, 13),
}

local function configureLever()
	local bossDate = {
		["Monday"] = "Plagueroot",
		["Tuesday"] = "Malofur Mangrinder",
		["Wednesday"] = "Maxxenius",
		["Thursday"] = "Alptramun",
		["Friday"] = "Izcandar The Banished",
		["Saturday"] = "Maxxenius",
		["Sunday"] = "Alptramun",
	}
	local bossName = bossDate[os.date("%A")]
	config.boss.name = bossName
	config.monsters = config.monsters[bossName]
	if bossName == "Maxxenius" then
		config.onUseExtra = function()
			Game.setStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.AlptramunSummonsKilled, 0)
		end
	elseif bossName == "Izcandar The Banished" then
		config.onUseExtra = function()
			Game.setStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.IzcandarOutfit, 0)
		end
	end
end

configureLever()
local dreamCourtsLever = BossLever(config)
dreamCourtsLever:position({ x = 32208, y = 32020, z = 13 })
dreamCourtsLever:register()
