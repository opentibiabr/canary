local mType = Game.createMonsterType("Tarbaz")
local monster = {}

monster.description = "tarbaz"
monster.experience = 50000
monster.outfit = {
	lookType = 842,
	lookHead = 0,
	lookBody = 21,
	lookLegs = 19,
	lookFeet = 3,
	lookAddons = 2,
	lookMount = 0
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "undead"
monster.corpse = 25151
monster.speed = 320
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "You are a failure.", yell = false}
}

monster.loot = {
	{id = 25172, chance = 1000000},
	{id = 6558, chance = 10000},
	{id = 6558, chance = 10000},
	{id = 6558, chance = 10000},
	{id = 6558, chance = 10000},
	{id = 6558, chance = 10000},
	{id = 2154, chance = 1000},
	{id = 2148, chance = 98000, maxCount = 184},
	{id = 7590, chance = 23000, maxCount = 10},
	{id = 7632, chance = 14000, maxCount = 5},
	{id = 7633, chance = 14000, maxCount = 5},
	{id = 8472, chance = 46100, maxCount = 10},
	{id = 8473, chance = 23000, maxCount = 10},
	{id = 9970, chance = 10000, maxCount = 8},
	{id = 2146, chance = 12000, maxCount = 9},
	{id = 2143, chance = 12000, maxCount = 8},
	{id = 2155, chance = 1000},
	{id = 7888, chance = 4000},
	{id = 7896, chance = 1000},
	{id = 7897, chance = 1000},
	{id = 2150, chance = 10000, maxCount = 5},
	{id = 2152, chance = 8000, maxCount = 58},
	{id = 18413, chance = 10000, maxCount = 5},
	{id = 18414, chance = 10000, maxCount = 5},
	{id = 18415, chance = 10000, maxCount = 5},
	{id = 2153, chance = 1000},
	{id = 25523, chance = 800},
	{id = 25383, chance = 800},
	{id = 2155, chance = 1000},
	{id = 8910, chance = 4000},
	{id = 25413, chance = 500, unique = true}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -1000, maxDamage = -2000},
	{name ="combat", interval = 3000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -1000, length = 10, spread = 3, effect = CONST_ME_HITBYFIRE, target = false},
	{name ="speed", interval = 2000, chance = 25, speedChange = -600, radius = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -700, radius = 5, effect = CONST_ME_HITBYFIRE, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -800, length = 10, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -800, length = 8, spread = 3, effect = CONST_ME_FIREATTACK, target = false}
}

monster.defenses = {
	defense = 120,
	armor = 100,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 900, maxDamage = 3500, effect = CONST_ME_MAGIC_GREEN, target = false},
	{name ="speed", interval = 3000, chance = 30, speedChange = 460, effect = CONST_ME_MAGIC_RED, target = false, duration = 7000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 10},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
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
