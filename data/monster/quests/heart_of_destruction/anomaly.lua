local mType = Game.createMonsterType("Anomaly")
local monster = {}

monster.description = "Anomaly"
monster.experience = 50000
monster.outfit = {
	lookType = 876,
	lookHead = 19,
	lookBody = 98,
	lookLegs = 19,
	lookFeet = 79,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "venom"
monster.corpse = 26220
monster.speed = 400
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.events = {
	"AnomalyTransform",
	"HeartBossDeath"
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Brzlll! Brzzzl!", yell = false}
}

monster.loot = {
	{id = 25377, chance = 100000, maxCount = 4},
	{id = 26165, chance = 100000},
	{id = 26166, chance = 100000},
	{id = 2148, chance = 100000, maxCount = 200},
	{id = 2152, chance = 100000, maxCount = 30},
	{id = 18413, chance = 8000, maxCount = 3},
	{id = 18414, chance = 8000, maxCount = 3},
	{id = 18415, chance = 8000, maxCount = 3},
	{id = 2150, chance = 8000, maxCount = 10},
	{id = 2145, chance = 8000, maxCount = 10},
	{id = 9970, chance = 8000, maxCount = 10},
	{id = 7590, chance = 8000, maxCount = 10},
	{id = 8472, chance = 8000, maxCount = 5},
	{id = 8473, chance = 8000, maxCount = 5},
	{id = 26201, chance = 8000, maxCount = 5},
	{id = 2154, chance = 8000},
	{id = 2158, chance = 6000},
	{id = 2155, chance = 6000},
	{id = 26198, chance = 3500},-- collar of blue plasma
	{id = 26185, chance = 3500},
	{id = 26187, chance = 3500},
	{id = 26167, chance = 8000},
	{id = 26175, chance = 8000},
	{id = 18450, chance = 4000, unique = true},
	{id = 7901, chance = 4000},
	{id = 7427, chance = 3000},
	{id = 7451, chance = 3000},
	{id = 8901, chance = 3000},
	{id = 7895, chance = 2500},
	{id = 7898, chance = 2500},
	{id = 26130, chance = 1600, unique = true},
	{id = 26133, chance = 1600, unique = true},
	{id = 6553, chance = 1600, unique = true},
	{id = 7633, chance = 1600, maxCount = 3}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -1400},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -600, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true},
	{name ="anomaly wave", interval = 2000, chance = 25, minDamage = -500, maxDamage = -900, target = false},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -600, maxDamage = -1000, length = 9, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -600, length = 9, spread = 3, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="anomaly break", interval = 2000, chance = 40, target = false}
}

monster.defenses = {
	defense = 100,
	armor = 100,
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 150, maxDamage = 400, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -20},
	{type = COMBAT_ENERGYDAMAGE, percent = -20},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = -20},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType.onThink = function(monster, interval)
end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature)
end

mType.onMove = function(monster, creature, fromPosition, toPosition)
end

mType.onSay = function(monster, creature, type, message)
end

mType:register(monster)
