local function roomIsOccupied(centerPosition,
		rangeX, rangeY)
	local spectators = Game.getSpectators(centerPosition, false, true,
		rangeX,
		rangeX, rangeY, rangeY)
	if #spectators ~= 0 then
		return true
	end
	return false
end

function clearBossRoom(playerId, bossId,
		centerPosition,
		rangeX, rangeY, exitPosition)
	local spectators, spectator = Game.getSpectators(centerPosition, false, false,
		rangeX,
		rangeX, rangeY, rangeY)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isPlayer() and spectator.uid == playerId then
			spectator:teleportTo(exitPosition)
			exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
		end
		if spectator:isMonster() and spectator.uid == bossId then
			spectator:remove()
		end
	end
end

local bosses = {
	[3230] = {
		bossName = 'the snapper',
		storage = 34100,
		playerPosition = Position(32610, 32723, 8),
		bossPosition = Position(32617, 32732, 8),
		centerPosition = Position(32613, 32727, 8),
		rangeX = 5, rangeY = 5,
		flamePosition = Position(32612, 32733, 8)
	},
	[3231] = {
		bossName = 'hide',
		storage = 34101,
		playerPosition = Position(32815, 32703, 8),
		bossPosition = Position(32816, 32712, 8),
		centerPosition = Position(32816, 32707, 8),
		rangeX = 6, rangeY = 5,
		flamePosition = Position(32810, 32704, 8)
	},
	[3232] = {
		bossName = 'deathbine',
		storage = 34102,
		playerPosition = Position(32715, 32736, 8),
		bossPosition = Position(32714, 32713, 8),
		centerPosition = Position(32716, 32724, 8),
		rangeX = 9, rangeY = 13,
		flamePosition = Position(32726, 32727, 8)
	},
	[3233] = {
		bossName = 'the bloodtusk',
		storage = 34103,
		playerPosition = Position(32102, 31124, 2),
		bossPosition = Position(32102, 31134, 2),
		centerPosition = Position(32101, 31129, 2),
		rangeX = 5, rangeY = 6,
		flamePosition = Position(32093, 31130, 2)
	},
	[3234] = {
		bossName = 'shardhead',
		storage = 34104,
		playerPosition = Position(32152, 31137, 3),
		bossPosition = Position(32159, 31132, 3),
		centerPosition = Position(32155, 31136, 3),
		rangeX = 5, rangeY = 7,
		flamePosition = Position(32149, 31137, 3)
	},
	[3235] = {
		bossName = 'esmeralda',
		storage = 34105,
		playerPosition = Position(32759, 31252, 9),
		bossPosition = Position(32759, 31258, 9),
		centerPosition = Position(32759, 31254, 9),
		rangeX = 4, rangeY = 4,
		flamePosition = Position(32758, 31248, 9)
	},
	[3236] = {
		bossName = 'fleshcrawler',
		storage = 34106,
		playerPosition = Position(33100, 32785, 11),
		bossPosition = Position(33121, 32797, 11),
		centerPosition = Position(33112, 32789, 11),
		rangeX = 15, rangeY = 13,
		flamePosition = Position(33106, 32775, 11)
	},
	[3237] = {
		bossName = 'ribstride',
		storage = 34107,
		playerPosition = Position(33012, 32813, 13),
		bossPosition = Position(33013, 32801, 13),
		centerPosition = Position(33012, 32805, 13),
		rangeX = 10, rangeY = 9,
		flamePosition = Position(33018, 32814, 13)
	},
	[3238] = {
		bossName = 'the bloodweb',
		storage = 34108,
		playerPosition = Position(32019, 31037, 8),
		bossPosition = Position(32032, 31033, 8),
		centerPosition = Position(32023, 31033, 8),
		rangeX = 11, rangeY = 11,
		flamePosition = Position(32010, 31031, 8)
	},
	[3239] = {
		bossName = 'thul',
		storage = 34109,
		playerPosition = Position(32078, 32780, 13),
		bossPosition = Position(32088, 32780, 13),
		centerPosition = Position(32083, 32781, 13),
		rangeX = 6, rangeY = 6,
		flamePosition = Position(32086, 32776, 13)
	},
	[3240] = {
		bossName = 'the old widow',
		storage = 34110,
		playerPosition = Position(32805, 32280, 8),
		bossPosition = Position(32797, 32281, 8),
		centerPosition = Position(32801, 32276, 8),
		rangeX = 5, rangeY = 5,
		flamePosition = Position(32808, 32283, 8)
	},
	[3241] = {
		bossName = 'hemming',
		storage = 34111,
		playerPosition = Position(32999, 31452, 8),
		bossPosition = Position(33013, 31441, 8),
		centerPosition = Position(33006, 31445, 8),
		rangeX = 9, rangeY = 7,
		flamePosition = Position(33005, 31437, 8)
	},
	[3242] = {
		bossName = 'tormentor',
		storage = 34112,
		playerPosition = Position(32043, 31258, 11),
		bossPosition = Position(32058, 31267, 11),
		centerPosition = Position(32051, 31264, 11),
		rangeX = 11, rangeY = 14,
		flamePosition = Position(32051, 31249, 11)
	},
	[3243] = {
		bossName = 'flameborn',
		storage = 34113,
		playerPosition = Position(32940, 31064, 8),
		bossPosition = Position(32947, 31058, 8),
		centerPosition = Position(32944, 31060, 8),
		rangeX = 11, rangeY = 10,
		flamePosition = Position(32818, 31026, 7)
	},
	[3244] = {
		bossName = 'fazzrah',
		storage = 34114,
		playerPosition = Position(32993, 31175, 7),
		bossPosition = Position(33005, 31174, 7),
		centerPosition = Position(33003, 31177, 7),
		rangeX = 14, rangeY = 6,
		flamePosition = Position(33007, 31171, 7)
	},
	[3245] = {
		bossName = 'tromphonyte',
		storage = 34115,
		playerPosition = Position(33111, 31184, 8),
		bossPosition = Position(33120, 31195, 8),
		centerPosition = Position(33113, 31188, 8),
		rangeX = 11, rangeY = 18,
		flamePosition = Position(33109, 31168, 8)
	},
	[3246] = {
		bossName = 'sulphur scuttler',
		storage = 34116,
		playerPosition = Position(33269, 31046, 9),
		bossPosition = Position(33274, 31037, 9),
		centerPosition = Position(33088, 31012, 8),
		rangeX = 11, rangeY = 11,
		flamePosition = Position(0, 0, 0)
	},
	[3247] = {
		bossName = 'bruise payne',
		storage = 34117,
		playerPosition = Position(33237, 31006, 2),
		bossPosition = Position(33266, 31016, 2),
		centerPosition = Position(33251, 31016, 2),
		rangeX = 22, rangeY = 11,
		flamePosition = Position(33260, 31003, 2)
	},
	[3248] = {
		bossName = 'the many',
		storage = 34118,
		playerPosition = Position(32921, 32893, 8),
		bossPosition = Position(32926, 32903, 8),
		centerPosition = Position(32921, 32898, 8),
		rangeX = 5, rangeY = 6,
		flamePosition = Position(32921, 32890, 8)
	},
	[3249] = {
		bossName = 'the noxious spawn',
		storage = 34119,
		playerPosition = Position(32842, 32667, 11),
		bossPosition = Position(32843, 32675, 11),
		centerPosition = Position(32843, 32670, 11),
		rangeX = 5, rangeY = 5,
		flamePosition = Position(0, 0, 0)
	},
	[3250] = {
		bossName = 'gorgo',
		storage = 34120,
		playerPosition = Position(32759, 32447, 11),
		bossPosition = Position(32763, 32435, 11),
		centerPosition = Position(32759, 32440, 11),
		rangeX = 9, rangeY = 10,
		flamePosition = Position(32768, 32440, 11)
	},
	[3251] = {
		bossName = 'stonecracker',
		storage = 34121,
		playerPosition = Position(33259, 31694, 15),
		bossPosition = Position(33257, 31705, 15),
		centerPosition = Position(33259, 31670, 15),
		rangeX = 5, rangeY = 7,
		flamePosition = Position(33259, 31689, 15)
	},
	[3252] = {
		bossName = 'leviathan',
		storage = 34122,
		playerPosition = Position(31915, 31071, 10),
		bossPosition = Position(31903, 31072, 10),
		centerPosition = Position(31909, 31072, 10),
		rangeX = 8, rangeY = 7,
		flamePosition = Position(31918, 31071, 10)
	},
	[3253] = {
		bossName = 'kerberos',
		storage = 34123,
		playerPosition = Position(32048, 32581, 15),
		bossPosition = Position(32032, 32565, 15),
		centerPosition = Position(32041, 32569, 15),
		rangeX = 11, rangeY = 13,
		flamePosition = Position(32030, 32555, 15)
	},
	[3254] = {
		bossName = 'ethershreck',
		storage = 34124,
		playerPosition = Position(33089, 31021, 8),
		bossPosition = Position(33085, 31004, 8),
		centerPosition = Position(33088, 31012, 8),
		rangeX = 11, rangeY = 11,
		flamePosition = Position(33076, 31007, 8)
	},
	[3255] = {
		bossName = 'paiz the pauperizer',
		storage = 34125,
		playerPosition = Position(33069, 31110, 1),
		bossPosition = Position(33082, 31105, 1),
		centerPosition = Position(33076, 31110, 1),
		rangeX = 8, rangeY = 6,
		flamePosition = Position(33076, 31110, 1)
	},
	[3256] = {
		bossName = 'bretzecutioner',
		storage = 34126,
		playerPosition = Position(31973, 31184, 10),
		bossPosition = Position(31979, 31176, 10),
		centerPosition = Position(31973, 31177, 10),
		rangeX = 15, rangeY = 10,
		flamePosition = Position(31973, 31166, 10)
	},
	[3257] = {
		bossName = 'zanakeph',
		storage = 34127,
		playerPosition = Position(33077, 31040, 12),
		bossPosition = Position(33082, 31056, 12),
		centerPosition = Position(33077, 31050, 12),
		rangeX = 13, rangeY = 10,
		flamePosition = Position(33070, 31039, 12)
	},
	[3258] = {
		bossName = 'tiquandas revenge',
		storage = Storage.KillingInTheNameOf.TiquandasRevengeTeleport,
		playerPosition = Position(32888, 32580, 4),
		bossPosition = Position(32888, 32586, 4),
		centerPosition = Position(32748, 32293, 10),
		rangeX = 8, rangeY = 7,
		flamePosition = Position(33076, 31029, 11)
	},
	[3259] = {
		bossName = 'demodras',
		storage = Storage.KillingInTheNameOf.DemodrasTeleport,
		playerPosition = Position(32748, 32287, 10),
		bossPosition = Position(32747, 32294, 10),
		centerPosition = Position(32887, 32583, 4),
		rangeX = 6, rangeY = 5,
		flamePosition = Position(33076, 31029, 12)
	},
	[3260] = {
		bossName = 'necropharus',
		storage = 17521,
		playerPosition = Position(33028, 32426, 12),
		bossPosition = Position(33026, 32422, 12),
		centerPosition = Position(33028, 32424, 12),
		rangeX = 6, rangeY = 5,
		flamePosition = Position(33070, 31035, 12)
	},
	[3261] = {
		bossName = 'the horned fox',
		storage = 17522,
		playerPosition = Position(32458, 31994, 9),
		bossPosition = Position(32458, 32005, 9),
		centerPosition = Position(32450, 31400, 9),
		rangeX = 5, rangeY = 8,
		flamePosition = Position(33070, 31029, 12)
	},
	[3262] = {
		bossName = 'lethal lissy',
		storage = 17523,
		playerPosition = Position(31976, 32896, 0),
		bossPosition = Position(31983, 32897, 0),
		centerPosition = Position(31982, 32897, 0),
		rangeX = 5, rangeY = 8,
		flamePosition = Position(31987, 32896, 0)
	}
}

local boss = MoveEvent()

function boss.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local boss = bosses[item.uid] or bosses[item:getActionId()]
	if not boss then
		return true
	end

	if player:getStorageValue(boss.storage) ~= 1 or roomIsOccupied(boss.centerPosition, boss.rangeX, boss.rangeY) then
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	player:setStorageValue(boss.storage, 0)
	player:teleportTo(boss.playerPosition)
	boss.playerPosition:sendMagicEffect(CONST_ME_TELEPORT)

	local monster = Game.createMonster(boss.bossName, boss.bossPosition)
	if not monster then
		return true
	end

	addEvent(clearBossRoom, 60 * 10 * 1000, player.uid, monster.uid, boss.centerPosition, boss.rangeX, boss.rangeY, fromPosition)
	player:say(
		"You have ten minutes to kill and loot this boss. Otherwise you will lose that chance and will be kicked out.",
		TALKTYPE_MONSTER_SAY
	)
	return true
end

boss:type("stepin")

for index, value in pairs(bosses) do
	boss:uid(index)
end

boss:register()
