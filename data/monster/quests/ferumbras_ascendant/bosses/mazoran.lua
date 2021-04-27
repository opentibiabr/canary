local mType = Game.createMonsterType("Mazoran")
local monster = {}

monster.description = "mazoran"
monster.experience = 60000
monster.outfit = {
	lookType = 842,
	lookHead = 77,
	lookBody = 79,
	lookLegs = 78,
	lookFeet = 94,
	lookAddons = 3,
	lookMount = 0
}

monster.health = 370000
monster.maxHealth = 370000
monster.race = "fire"
monster.corpse = 25151
monster.speed = 400
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
	runHealth = 1,
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
	{text = "ASHES TO ASHES, TASTE MY FIRE!", yell = false},
	{text = "BUUURN!", yell = false},
	{text = "UNLEASH THE FIRE!", yell = false}
}

monster.loot = {
	{id = 25172, chance = 1000000},
	{id = 18419, chance = 23000, maxCount = 5},
	{id = 18420, chance = 23000, maxCount = 5},
	{id = 18421, chance = 23000, maxCount = 5},
	{id = 2143, chance = 12000, maxCount = 8},
	{id = 2146, chance = 12000, maxCount = 9},
	{id = 2148, chance = 98000, maxCount = 200},
	{id = 2150, chance = 10000, maxCount = 5},
	{id = 2152, chance = 8000, maxCount = 58},
	{id = 2155, chance = 1000},
	{id = 2158, chance = 1000},
	{id = 2167, chance = 4000},
	{id = 2432, chance = 3000},
	{id = 25416, chance = 500},
	{id = 2542, chance = 500, unique = true},
	{id = 25522, chance = 500},
	{id = 25523, chance = 500},
	{id = 6500, chance = 11000},
	{id = 7382, chance = 1000},
	{id = 7590, chance = 23000, maxCount = 5},
	{id = 7632, chance = 14000, maxCount = 5},
	{id = 7633, chance = 14000, maxCount = 5},
	{id = 7890, chance = 1000},
	{id = 7894, chance = 1000},
	{id = 7899, chance = 1000},
	{id = 8472, chance = 46100, maxCount = 5},
	{id = 8473, chance = 23000, maxCount = 5},
	{id = 9970, chance = 10000, maxCount = 8},
	{id = 9971, chance = 3000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -1500, maxDamage = -2500},
	{name ="combat", interval = 3000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -1000, length = 10, spread = 3, effect = CONST_ME_HITBYFIRE, target = false},
	{name ="speed", interval = 2000, chance = 25, speedChange = -600, radius = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -700, radius = 5, effect = CONST_ME_HITBYFIRE, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -800, length = 10, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -800, length = 8, spread = 3, effect = CONST_ME_FIREATTACK, target = false}
}

monster.defenses = {
	defense = 25,
	armor = 25,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 2090, maxDamage = 4500, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 35, speedChange = 700, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 6000},
	{name ="mazoran fire", interval = 30000, chance = 45, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 10},
	{type = COMBAT_FIREDAMAGE, percent = 100},
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
