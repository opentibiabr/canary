local function roomIsOccupied(centerPosition, rangeX, rangeY)
	local spectators = Game.getSpectators(centerPosition, false, true, rangeX, rangeX, rangeY, rangeY)
	if #spectators ~= 0 then
		return true
	end
	return false
end

local function clearBossRoom(playerId, bossId, centerPosition, rangeX, rangeY, exitPosition)
	local spectators = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY)
	local spectator
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
	{
		bossName = 'the snapper',
		storage = 34100,
		teleportPosition = {x = 32608, y = 32714, z = 8},
		playerPosition = Position(32610, 32723, 8),
		bossPosition = Position(32617, 32732, 8),
		centerPosition = Position(32613, 32727, 8),
		rangeX = 5, rangeY = 5,
		flamePosition = Position(32612, 32733, 8)
	},
	{
		bossName = 'hide',
		storage = 34101,
		teleportPosition = {x = 32822, y = 32693, z = 8},
		playerPosition = Position(32815, 32703, 8),
		bossPosition = Position(32816, 32712, 8),
		centerPosition = Position(32816, 32707, 8),
		rangeX = 6, rangeY = 5,
		flamePosition = Position(32810, 32704, 8)
	},
	{
		bossName = 'deathbine',
		storage = 34102,
		teleportPosition = {x = 32722, y = 32762, z = 8},
		playerPosition = Position(32715, 32736, 8),
		bossPosition = Position(32714, 32713, 8),
		centerPosition = Position(32716, 32724, 8),
		rangeX = 9, rangeY = 13,
		flamePosition = Position(32726, 32727, 8)
	},
	{
		bossName = 'the bloodtusk',
		storage = 34103,
		teleportPosition = {x = 32104, y = 31116, z = 2},
		playerPosition = Position(32102, 31124, 2),
		bossPosition = Position(32102, 31134, 2),
		centerPosition = Position(32101, 31129, 2),
		rangeX = 5, rangeY = 6,
		flamePosition = Position(32093, 31130, 2)
	},
	{
		bossName = 'shardhead',
		storage = 34104,
		teleportPosition = {x = 32141, y = 31144, z = 3},
		playerPosition = Position(32152, 31137, 3),
		bossPosition = Position(32159, 31132, 3),
		centerPosition = Position(32155, 31136, 3),
		rangeX = 5, rangeY = 7,
		flamePosition = Position(32149, 31137, 3)
	},
	{
		bossName = 'esmeralda',
		storage = 34105,
		teleportPosition = {x = 32758, y = 31245, z = 9},
		playerPosition = Position(32759, 31252, 9),
		bossPosition = Position(32759, 31258, 9),
		centerPosition = Position(32759, 31254, 9),
		rangeX = 4, rangeY = 4,
		flamePosition = Position(32758, 31248, 9)
	},
	{
		bossName = 'fleshcrawler',
		storage = 34106,
		teleportPosition = {x = 33044, y = 32794, z = 11},
		playerPosition = Position(33100, 32785, 11),
		bossPosition = Position(33121, 32797, 11),
		centerPosition = Position(33112, 32789, 11),
		rangeX = 15, rangeY = 13,
		flamePosition = Position(33106, 32775, 11)
	},
	{
		bossName = 'ribstride',
		storage = 34107,
		teleportPosition = {x = 33109, y = 32803, z = 13},
		playerPosition = Position(33012, 32813, 13),
		bossPosition = Position(33013, 32801, 13),
		centerPosition = Position(33012, 32805, 13),
		rangeX = 10, rangeY = 9,
		flamePosition = Position(33018, 32814, 13)
	},
	{
		bossName = 'the bloodweb',
		storage = 34108,
		teleportPosition = {x = 32122, y = 31188, z = 4},
		playerPosition = Position(32019, 31037, 8),
		bossPosition = Position(32032, 31033, 8),
		centerPosition = Position(32023, 31033, 8),
		rangeX = 11, rangeY = 11,
		flamePosition = Position(32010, 31031, 8)
	},
	{
		bossName = 'thul',
		storage = 34109,
		teleportPosition = {x = 32085, y = 32782, z = 12},
		playerPosition = Position(32078, 32780, 13),
		bossPosition = Position(32088, 32780, 13),
		centerPosition = Position(32083, 32781, 13),
		rangeX = 6, rangeY = 6,
		flamePosition = Position(32086, 32776, 13)
	},
	{
		bossName = 'the old widow',
		storage = 34110,
		teleportPosition = {x = 32814, y = 32280, z = 8},
		playerPosition = Position(32805, 32280, 8),
		bossPosition = Position(32797, 32281, 8),
		centerPosition = Position(32801, 32276, 8),
		rangeX = 5, rangeY = 5,
		flamePosition = Position(32808, 32283, 8)
	},
	{
		bossName = 'hemming',
		storage = 34111,
		teleportPosition = {x = 32992, y = 31443, z = 7},
		playerPosition = Position(32999, 31452, 8),
		bossPosition = Position(33013, 31441, 8),
		centerPosition = Position(33006, 31445, 8),
		rangeX = 9, rangeY = 7,
		flamePosition = Position(33005, 31437, 8)
	},
	{
		bossName = 'tormentor',
		storage = 34112,
		teleportPosition = {x = 32072, y = 31283, z = 10},
		playerPosition = Position(32043, 31258, 11),
		bossPosition = Position(32058, 31267, 11),
		centerPosition = Position(32051, 31264, 11),
		rangeX = 11, rangeY = 14,
		flamePosition = Position(32051, 31249, 11)
	},
	{
		bossName = 'flameborn',
		storage = 34113,
		teleportPosition = {x = 32816, y = 31026, z = 7},
		playerPosition = Position(32940, 31064, 8),
		bossPosition = Position(32947, 31058, 8),
		centerPosition = Position(32944, 31060, 8),
		rangeX = 11, rangeY = 10,
		flamePosition = Position(32818, 31026, 7)
	},
	{
		bossName = 'fazzrah',
		storage = 34114,
		teleportPosition = {x = 33310, y = 31183, z = 7},
		playerPosition = Position(32993, 31175, 7),
		bossPosition = Position(33005, 31174, 7),
		centerPosition = Position(33003, 31177, 7),
		rangeX = 14, rangeY = 6,
		flamePosition = Position(33007, 31171, 7)
	},
	{
		bossName = 'tromphonyte',
		storage = 34115,
		teleportPosition = {x = 33136, y = 31186, z = 8},
		playerPosition = Position(33111, 31184, 8),
		bossPosition = Position(33120, 31195, 8),
		centerPosition = Position(33113, 31188, 8),
		rangeX = 11, rangeY = 18,
		flamePosition = Position(33109, 31168, 8)
	},
	{
		bossName = 'sulphur scuttler',
		storage = 34116,
		teleportPosition = {x = 33286, y = 31112, z = 8},
		playerPosition = Position(33269, 31046, 9),
		bossPosition = Position(33274, 31037, 9),
		centerPosition = Position(33088, 31012, 8),
		rangeX = 11, rangeY = 11,
		flamePosition = Position(0, 0, 0)
	},
	{
		bossName = 'bruise payne',
		storage = 34117,
		teleportPosition = {x = 32679, y = 31114, z = 3},
		playerPosition = Position(33237, 31006, 2),
		bossPosition = Position(33266, 31016, 2),
		centerPosition = Position(33251, 31016, 2),
		rangeX = 22, rangeY = 11,
		flamePosition = Position(33260, 31003, 2)
	},
	{
		bossName = 'the many',
		storage = 34118,
		teleportPosition = {x = 32920, y = 32883, z = 8},
		playerPosition = Position(32921, 32893, 8),
		bossPosition = Position(32926, 32903, 8),
		centerPosition = Position(32921, 32898, 8),
		rangeX = 5, rangeY = 6,
		flamePosition = Position(32921, 32890, 8)
	},
	{
		bossName = 'the noxious spawn',
		storage = 34119,
		teleportPosition = {x = 32842, y = 32660, z = 11},
		playerPosition = Position(32842, 32667, 11),
		bossPosition = Position(32843, 32675, 11),
		centerPosition = Position(32843, 32670, 11),
		rangeX = 5, rangeY = 5,
		flamePosition = Position(0, 0, 0)
	},
	{
		bossName = 'gorgo',
		storage = 34120,
		teleportPosition = {x = 32799, y = 32501, z = 11},
		playerPosition = Position(32759, 32447, 11),
		bossPosition = Position(32763, 32435, 11),
		centerPosition = Position(32759, 32440, 11),
		rangeX = 9, rangeY = 10,
		flamePosition = Position(32768, 32440, 11)
	},
	{
		bossName = 'stonecracker',
		storage = 34121,
		teleportPosition = {x = 33251, y = 31719, z = 14},
		playerPosition = Position(33259, 31694, 15),
		bossPosition = Position(33257, 31705, 15),
		centerPosition = Position(33259, 31670, 15),
		rangeX = 5, rangeY = 7,
		flamePosition = Position(33259, 31689, 15)
	},
	{
		bossName = 'leviathan',
		storage = 34122,
		teleportPosition = {x = 31926, y = 31071, z = 10},
		playerPosition = Position(31915, 31071, 10),
		bossPosition = Position(31903, 31072, 10),
		centerPosition = Position(31909, 31072, 10),
		rangeX = 8, rangeY = 7,
		flamePosition = Position(31918, 31071, 10)
	},
	{
		bossName = 'kerberos',
		storage = 34123,
		teleportPosition = {x = 32044, y = 32547, z = 14},
		playerPosition = Position(32048, 32581, 15),
		bossPosition = Position(32032, 32565, 15),
		centerPosition = Position(32041, 32569, 15),
		rangeX = 11, rangeY = 13,
		flamePosition = Position(32030, 32555, 15)
	},
	{
		bossName = 'ethershreck',
		storage = 34124,
		teleportPosition = {x = 33115, y = 31004, z = 8},
		playerPosition = Position(33089, 31021, 8),
		bossPosition = Position(33085, 31004, 8),
		centerPosition = Position(33088, 31012, 8),
		rangeX = 11, rangeY = 11,
		flamePosition = Position(33076, 31007, 8)
	},
	{
		bossName = 'paiz the pauperizer',
		storage = 34125,
		teleportPosition = {x = 33066, y = 31104, z = 2},
		playerPosition = Position(33069, 31110, 1),
		bossPosition = Position(33082, 31105, 1),
		centerPosition = Position(33076, 31110, 1),
		rangeX = 8, rangeY = 6,
		flamePosition = Position(33076, 31110, 1)
	},
	{
		bossName = 'bretzecutioner',
		storage = 34126,
		teleportPosition = {x = 32003, y = 31189, z = 10},
		playerPosition = Position(31973, 31184, 10),
		bossPosition = Position(31979, 31176, 10),
		centerPosition = Position(31973, 31177, 10),
		rangeX = 15, rangeY = 10,
		flamePosition = Position(31973, 31166, 10)
	},
	{
		bossName = 'zanakeph',
		storage = 34127,
		teleportPosition = {x = 33095, y = 31075, z = 12},
		playerPosition = Position(33077, 31040, 12),
		bossPosition = Position(33082, 31056, 12),
		centerPosition = Position(33077, 31050, 12),
		rangeX = 13, rangeY = 10,
		flamePosition = Position(33070, 31039, 12)
	},
	{
		bossName = 'tiquandas revenge',
		storage = Storage.KillingInTheNameOf.MissionTiquandasRevenge,
		teleportPosition = {x = 32877, y = 32583, z = 7},
		playerPosition = Position(32888, 32580, 4),
		bossPosition = Position(32888, 32586, 4),
		centerPosition = Position(32748, 32293, 10),
		rangeX = 8, rangeY = 7,
		flamePosition = Position(33076, 31029, 11)
	},
	{
		bossName = 'demodras',
		storage = Storage.KillingInTheNameOf.MissionDemodras,
		teleportPosition = {x = 32769, y = 32290, z = 10},
		playerPosition = Position(32748, 32287, 10),
		bossPosition = Position(32747, 32294, 10),
		centerPosition = Position(32887, 32583, 4),
		rangeX = 6, rangeY = 5,
		flamePosition = Position(33076, 31029, 12)
	},
	{
		bossName = 'necropharus',
		storage = Storage.KillingInTheNameOf.LugriNecromancers,
		teleportPosition = {x = 33046, y = 32439, z = 11},
		playerPosition = Position(33028, 32426, 12),
		bossPosition = Position(33026, 32422, 12),
		centerPosition = Position(33028, 32424, 12),
		rangeX = 6, rangeY = 5,
		flamePosition = Position(33070, 31035, 12)
	},
	{
		bossName = 'the horned fox',
		storage = Storage.KillingInTheNameOf.BudrikMinos,
		teleportPosition = {x = 32450, y = 31988, z = 9},
		playerPosition = Position(32458, 31994, 9),
		bossPosition = Position(32458, 32005, 9),
		centerPosition = Position(32450, 31400, 9),
		rangeX = 5, rangeY = 8,
		flamePosition = Position(33070, 31029, 12)
	},
	{
		bossName = {"Brutus Bloodbeard", "Deadeye Devious", "lethal lissy", "Ron The Ripper"},
		storage = Storage.KillingInTheNameOf.PirateTask,
		teleportPosition = {x = 31978, y = 32853, z = 1},
		playerPosition = Position(31976, 32896, 0),
		bossPosition = Position(31983, 32897, 0),
		centerPosition = Position(31982, 32897, 0),
		rangeX = 5, rangeY = 8,
		flamePosition = Position(31987, 32896, 0)
	},
	{
		bossName = "merikh the slaughterer",
		storage = Storage.KillingInTheNameOf.GreenDjinnTask,
		teleportPosition = {x = 32870, y = 31112, z = 4},
		playerPosition = Position(32876, 31120, 8),
		bossPosition = Position(32875, 31112, 8),
		centerPosition = Position(32875, 31116, 8),
		rangeX = 6, rangeY = 6,
		flamePosition = Position(32875, 31124, 8)
	},
	{
		bossName = "fahim the wise",
		storage = Storage.KillingInTheNameOf.BlueDjinnTask,
		teleportPosition = {x = 32815, y = 31119, z = 3},
		playerPosition = Position(32811, 31121, 2),
		bossPosition = Position(32811, 31114, 2),
		centerPosition = Position(32811, 31118, 2),
		rangeX = 5, rangeY = 5,
		flamePosition = Position(32807, 31117, 2)
	}
}

local boss = MoveEvent()

function boss.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	for a = 1, #bosses do
		if player:getPosition() == Position(bosses[a].teleportPosition) then
			if player:getStorageValue(bosses[a].storage) ~= 1 or roomIsOccupied(bosses[a].centerPosition, bosses[a].rangeX, bosses[a].rangeY) then
				player:teleportTo(fromPosition)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				return true
			end
			player:setStorageValue(bosses[a].storage, 2)
			player:teleportTo(bosses[a].playerPosition)
			bosses[a].playerPosition:sendMagicEffect(CONST_ME_TELEPORT)
			local monster
			if player:getPosition() == Position({x = 31978, y = 32853, z = 1}) then
				local randomBoss = math.random(4)
				monster = Game.createMonster(bosses[a].bossName[randomBoss], bosses[a].bossPosition)
			else
				monster = Game.createMonster(bosses[a].bossName, bosses[a].bossPosition)
			end
			if not monster then
				return true
			end
			addEvent(clearBossRoom, 60 * 10 * 1000, player.uid, monster.uid, bosses[a].centerPosition, bosses[a].rangeX, bosses[a].rangeY, fromPosition)
			player:say("You have ten minutes to kill and loot this boss. Otherwise you will lose that chance and will be kicked out.", TALKTYPE_MONSTER_SAY)
		end
	end
	return true
end

for index = 1, #bosses do
	boss:position(bosses[index].teleportPosition)
end
boss:register()
