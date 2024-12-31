local mType = Game.createMonsterType("The Primal Menace")
local monster = {}

local thePrimalMenaceConfig = {
	Storage = {
		Initialized = 1,
		SpawnPos = 2,
		NextPodSpawn = 3,
		NextMonsterSpawn = 4,
		PrimalBeasts = 5, -- List of monsters and when they were created in order to turn them into fungosaurus {monster, created}
	},

	-- Spawn area
	SpawnRadius = 5,

	-- Monster spawn time
	MonsterConfig = {
		IntervalBase = 30,
		IntervalReductionPer10PercentHp = 0.98,
		IntervalReductionPerHazard = 0.985,

		CountBase = 4,
		CountVarianceRate = 0.5,
		CountGrowthPerHazard = 1.05,
		CountMax = 6,

		MonsterPool = {
			"Emerald Tortoise (Primal)",
			"Gore Horn (Primal)",
			"Gorerilla (Primal)",
			"Headpecker (Primal)",
			"Hulking Prehemoth (Primal)",
			"Mantosaurus (Primal)",
			"Nighthunter (Primal)",
			"Noxious Ripptor (Primal)",
			"Sabretooth (Primal)",
			"Stalking Stalk (Primal)",
			"Sulphider (Primal)",
		},
	},

	PodConfig = {
		IntervalBase = 30,
		IntervalReductionPer10PercentHp = 0.98,
		IntervalReductionPerHazard = 0.985,

		CountBase = 2,
		CountVarianceRate = 0.5,
		CountGrowthPerHazard = 1.1,
		CountMax = 4,
	},
}

monster.description = "The Primal Menace"
monster.experience = 0
monster.outfit = {
	lookType = 1566,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ThePrimalMenaceDeath",
	"ThePrimeOrdealBossDeath",
}

monster.health = 400000
monster.maxHealth = 400000
monster.race = "blood"
monster.corpse = 39530
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -0, maxDamage = -763 },
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_EARTHDAMAGE, minDamage = -1500, maxDamage = -2200, length = 10, spread = 3, effect = CONST_ME_CARNIPHILA, target = false },
	{ name = "combat", interval = 2500, chance = 35, type = COMBAT_FIREDAMAGE, minDamage = -700, maxDamage = -1000, length = 10, spread = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "big death wave", interval = 3500, chance = 25, minDamage = -250, maxDamage = -300, target = false },
	{ name = "combat", interval = 5000, chance = 25, type = COMBAT_ENERGYDAMAGE, effect = CONST_ME_ENERGYHIT, minDamage = -1200, maxDamage = -1300, range = 4, target = false },
	{ name = "combat", interval = 2700, chance = 35, type = COMBAT_EARTHDAMAGE, shootEffect = CONST_ANI_POISON, effect = CONST_ANI_EARTH, minDamage = -600, maxDamage = -1800, range = 4, target = true },
}

monster.defenses = {
	defense = 80,
	armor = 100,
	mitigation = 3.72,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 40 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "drunk", condition = true },
	{ type = "bleed", condition = false },
}

local function initialize(monster)
	if monster:getStorageValue(thePrimalMenaceConfig.Storage.Initialized) == true then
		return
	end

	monster:setStorageValue(thePrimalMenaceConfig.Storage.SpawnPos, monster:getPosition())
	monster:setStorageValue(thePrimalMenaceConfig.Storage.NextPodSpawn, os.time() + 20)
	monster:setStorageValue(thePrimalMenaceConfig.Storage.NextMonsterSpawn, os.time() + 10)
	monster:setStorageValue(thePrimalMenaceConfig.Storage.PrimalBeasts, {})

	monster:setStorageValue(thePrimalMenaceConfig.Storage.Initialized, true)
end

-- Functions for the fight
local function getHazardPoints(monster)
	local hazard = Hazard.getByName("hazard.gnomprona-gardens")
	if not hazard then
		return 0
	end

	local _, hazardPoints = hazard:getHazardPlayerAndPoints(monster:getDamageMap())
	return hazardPoints
end

local function setNextTimeToSpawn(monster, spawnStorageValue, spawnConfig, hazardPoints)
	local intervalBase = spawnConfig.IntervalBase
	local intervalReductionPer10PercentHp = spawnConfig.IntervalReductionPer10PercentHp
	local intervalReductionPerHazard = spawnConfig.IntervalReductionPerHazard

	local maxHealth = monster:getMaxHealth()
	local currentHealth = monster:getHealth()
	local count10PercentHpMissing = math.floor((maxHealth - currentHealth) / maxHealth * 10)

	local interval = intervalBase * (intervalReductionPer10PercentHp ^ count10PercentHpMissing) * (intervalReductionPerHazard ^ hazardPoints)

	local nextTimeToSpawn = os.time() + interval
	monster:setStorageValue(spawnStorageValue, nextTimeToSpawn)
end

local function spawnCount(spawnConfig, hazardPoints)
	local countBase = spawnConfig.CountBase
	local countVarianceRate = spawnConfig.CountVarianceRate
	local countGrowthPerHazard = spawnConfig.CountGrowthPerHazard
	local countMax = spawnConfig.CountMax

	local directions = { -1, 1 }
	local variance = math.random() * countVarianceRate * directions[math.random(#directions)]
	local count = math.floor(countBase * (countGrowthPerHazard ^ hazardPoints) + variance)

	return math.min(count, countMax)
end

local function getSpawnPosition(monster)
	local attempts = 6
	local attempt = 0
	local spawnPosition = nil
	local radius = thePrimalMenaceConfig.SpawnRadius
	local centerPos = monster:getStorageValue(thePrimalMenaceConfig.Storage.SpawnPos)

	while not spawnPosition and attempt < attempts do
		local centerX = centerPos.x
		local centerY = centerPos.y

		local directions = { -1, 1 }
		local xCoord = centerX + math.ceil(math.random() * radius) * directions[math.random(#directions)]
		local yCoord = centerY + math.ceil(math.random() * radius) * directions[math.random(#directions)]

		local positionAttempt = Position(xCoord, yCoord, centerPos.z)
		local spawnTile = Tile(positionAttempt)
		if spawnTile and spawnTile:getCreatureCount() == 0 and not spawnTile:hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) then
			spawnPosition = positionAttempt
		end
		attempt = attempt + 1
	end

	-- Fallback
	if not spawnPosition then
		spawnPosition = centerPos
	end

	return spawnPosition
end

local function spawnTimer(monsterId, spawnPosition, spawnCallback)
	local time_to_spawn = 3
	for i = 1, time_to_spawn do
		addEvent(function()
			spawnPosition:sendMagicEffect(CONST_ME_TELEPORT)
		end, i * 1000)
	end
	addEvent(function()
		spawnCallback(monsterId, spawnPosition)
	end, time_to_spawn * 1000)
end

local function spawnPod(monsterId, position)
	createPrimalPod(position)
end

local function spawnPods(monster, hazardPoints)
	local count = spawnCount(thePrimalMenaceConfig.PodConfig, hazardPoints)
	for i = 1, count do
		local spawnPosition = getSpawnPosition(monster)
		spawnTimer(monster:getId(), spawnPosition, spawnPod)
	end
end

local function handlePodSpawn(monster, hazardPoints)
	local nextSpawn = monster:getStorageValue(thePrimalMenaceConfig.Storage.NextPodSpawn)
	if nextSpawn - os.time() < 0 then
		spawnPods(monster, hazardPoints)

		setNextTimeToSpawn(monster, thePrimalMenaceConfig.Storage.NextPodSpawn, thePrimalMenaceConfig.PodConfig, hazardPoints)
	end
end

local function spawnMonster(monsterId, spawnPosition)
	local monster = Monster(monsterId)
	if not monster then
		return
	end

	local randomMonsterIndex = math.random(#thePrimalMenaceConfig.MonsterConfig.MonsterPool)
	local primalMonster = Game.createMonster(thePrimalMenaceConfig.MonsterConfig.MonsterPool[randomMonsterIndex], spawnPosition)
	if not primalMonster then
		logger.error("Cannot create primal monster {}", thePrimalMenaceConfig.MonsterConfig.MonsterPool[randomMonsterIndex])
		return
	end
	local primalBeastEntry = {
		MonsterId = primalMonster:getId(),
		Created = os.time(),
	}

	local primalBeasts = monster:getStorageValue(thePrimalMenaceConfig.Storage.PrimalBeasts)
	table.insert(primalBeasts, primalBeastEntry)
	monster:setStorageValue(thePrimalMenaceConfig.Storage.PrimalBeasts, primalBeasts)
end

local function spawnMonsters(monster, hazardPoints)
	local count = spawnCount(thePrimalMenaceConfig.MonsterConfig, hazardPoints)
	for i = 1, count do
		local spawnPosition = getSpawnPosition(monster)
		spawnTimer(monster:getId(), spawnPosition, spawnMonster)
	end
end

local function handleMonsterSpawn(monster, hazardPoints)
	local nextSpawn = monster:getStorageValue(thePrimalMenaceConfig.Storage.NextMonsterSpawn)
	if nextSpawn - os.time() < 0 then
		spawnMonsters(monster, hazardPoints)

		setNextTimeToSpawn(monster, thePrimalMenaceConfig.Storage.NextMonsterSpawn, thePrimalMenaceConfig.MonsterConfig, hazardPoints)
	end
end

local function handlePrimalBeasts(monster)
	local primalBeasts = monster:getStorageValue(thePrimalMenaceConfig.Storage.PrimalBeasts)
	local indexesToRemove = {}

	for index, beastData in pairs(primalBeasts) do
		local primalMonster = Monster(beastData.MonsterId)
		local created = beastData.Created
		if not primalMonster or not primalMonster:getHealth() or primalMonster:getHealth() == 0 then
			table.insert(indexesToRemove, index)
		elseif os.time() - created > 20 and primalMonster:getHealth() > 0 then
			local position = primalMonster:getPosition()
			primalMonster:remove()
			table.insert(indexesToRemove, index)
			if position then
				Game.createMonster("Fungosaurus", position)
			end
		end
	end

	for i = #indexesToRemove, 1, -1 do
		local indexToRemove = indexesToRemove[i]
		table.remove(primalBeasts, indexToRemove)
	end

	monster:setStorageValue(thePrimalMenaceConfig.Storage.PrimalBeasts, primalBeasts)
end

mType.onThink = function(monster, interval)
	if monster:getStorageValue(thePrimalMenaceConfig.Storage.Initialized) == -1 then
		initialize(monster)
	end

	local hazardPoints = getHazardPoints(monster)
	handleMonsterSpawn(monster, hazardPoints)
	handlePodSpawn(monster, hazardPoints)
	handlePrimalBeasts(monster)
end

mType:register(monster)
