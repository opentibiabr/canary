local mType = Game.createMonsterType("Zamulosh2")
local monster = {}

monster.name = "Zamulosh"
monster.description = "zamulosh"
monster.experience = 55000
monster.outfit = {
	lookType = 862,
	lookHead = 16,
	lookBody = 12,
	lookLegs = 73,
	lookFeet = 55,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 300000
monster.maxHealth = 300000
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
	canPushCreatures = false,
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
	{text = "I AM ZAMULOSH!", yell = false}
}

monster.loot = {
	{id = 25172, chance = 1000000},
	{id = 2148, chance = 98000, maxCount = 200},
	{id = 7632, chance = 14000, maxCount = 5},
	{id = 7633, chance = 14000, maxCount = 5},
	{id = 2146, chance = 12000, maxCount = 9},
	{id = 2143, chance = 12000, maxCount = 8},
	{id = 2150, chance = 10000, maxCount = 5},
	{id = 9970, chance = 10000, maxCount = 8},
	{id = 2152, chance = 8000, maxCount = 58},
	{id = 6500, chance = 11000},
	{id = 18416, chance = 10000, maxCount = 6},
	{id = 18417, chance = 10000, maxCount = 6},
	{id = 18418, chance = 10000, maxCount = 6},
	{id = 2156, chance = 1000},
	{id = 2154, chance = 1000},
	{id = 2155, chance = 1000},
	{id = 2158, chance = 1000},
	{id = 2169, chance = 6000},
	{id = 2214, chance = 6000},
	{id = 25523, chance = 770},
	{id = 8878, chance = 770},
	{id = 25382, chance = 670},
	{id = 25418, chance = 500, unique = true},
	{id = 25211, chance = 500, unique = true}
}

monster.attacks = {
	{name ="melee", interval = 3000, chance = 100, minDamage = -1500, maxDamage = -2300},
	{name ="combat", interval = 1000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -800, length = 12, spread = 3, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -2600, maxDamage = -3300, length = 12, spread = 3, effect = CONST_ME_TELEPORT, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -900, maxDamage = -1500, length = 6, spread = 2, effect = CONST_ME_FIREAREA, target = false},
	{name ="speed", interval = 2000, chance = 35, speedChange = -600, radius = 8, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 220, maxDamage = 535, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 15},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 15},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 15},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 15}
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
