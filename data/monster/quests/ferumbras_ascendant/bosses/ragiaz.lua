local mType = Game.createMonsterType("Ragiaz")
local monster = {}

monster.description = "ragiaz"
monster.experience = 100000
monster.outfit = {
	lookType = 862,
	lookHead = 76,
	lookBody = 57,
	lookLegs = 19,
	lookFeet = 0,
	lookAddons = 3,
	lookMount = 0
}

monster.health = 380000
monster.maxHealth = 380000
monster.race = "undead"
monster.corpse = 25151
monster.speed = 340
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
}

monster.loot = {
	{id = 25172, chance = 1000000},
	{id = 6558, chance = 10000},
	{id = 6558, chance = 10000},
	{id = 6558, chance = 10000},
	{id = 6558, chance = 10000},
	{id = 6558, chance = 10000},
	{id = 2154, chance = 1000},
	{id = 18419, chance = 3000, maxCount = 5},
	{id = 18420, chance = 3000, maxCount = 5},
	{id = 18421, chance = 3000, maxCount = 5},
	{id = 2143, chance = 3000, maxCount = 8},
	{id = 2146, chance = 3000, maxCount = 9},
	{id = 2148, chance = 98000, maxCount = 200},
	{id = 2150, chance = 3000, maxCount = 5},
	{id = 2152, chance = 8000, maxCount = 58},
	{id = 2155, chance = 1000},
	{id = 2156, chance = 1000},
	{id = 2158, chance = 1000},
	{id = 2436, chance = 4000},
	{id = 25414, chance = 100, unique = true},
	{id = 25522, chance = 700},
	{id = 25523, chance = 700},
	{id = 6500, chance = 11000},
	{id = 7420, chance = 500},
	{id = 7426, chance = 4000},
	{id = 7590, chance = 3000, maxCount = 5},
	{id = 7591, chance = 3100, maxCount = 5},
	{id = 7632, chance = 3000, maxCount = 5},
	{id = 7633, chance = 3000, maxCount = 5},
	{id = 8472, chance = 3100, maxCount = 5},
	{id = 8473, chance = 3000, maxCount = 5},
	{id = 9970, chance = 3000, maxCount = 8}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -1400, maxDamage = -2300},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -900, radius = 4, effect = CONST_ME_SMALLCLOUDS, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -900, range = 4, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_POFF, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -1000, maxDamage = -1200, length = 10, spread = 3, effect = CONST_ME_MAGIC_GREEN, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -1500, maxDamage = -1900, length = 10, spread = 3, effect = CONST_ME_GROUNDSHAKER, target = false},
	{name ="speed", interval = 2000, chance = 20, speedChange = -600, radius = 7, effect = CONST_ME_POFF, target = false, duration = 20000}
}

monster.defenses = {
	defense = 25,
	armor = 25,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 2000, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 20, speedChange = 600, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 4000},
	{name ="ragiaz transform", interval = 2000, chance = 8, target = false}
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
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 30}
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
