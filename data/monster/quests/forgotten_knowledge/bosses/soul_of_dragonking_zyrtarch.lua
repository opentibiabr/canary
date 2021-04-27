local mType = Game.createMonsterType("Soul of Dragonking Zyrtarch")
local monster = {}

monster.description = "soul of dragonking zyrtarch"
monster.experience = 70700
monster.outfit = {
	lookType = 938,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 150000
monster.maxHealth = 150000
monster.race = "fire"
monster.corpse = 27733
monster.speed = 500
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0
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
	{id = 25377, chance = 100000},
	{id = 25172, chance = 100000},
	{id = 2148, chance = 97000, maxCount = 100},
	{id = 2148, chance = 97000, maxCount = 100},
	{id = 2154, chance = 1000},
	{id = 5882, chance = 5000},
	{id = 5889, chance = 500},
	{id = 9980, chance = 500},
	{id = 12644, chance = 300},
	{id = 9970, chance = 3000, maxCount = 5},
	{id = 2149, chance = 3000, maxCount = 5},
	{id = 9971, chance = 500},
	{id = 11308, chance = 100},
	{id = 2150, chance = 3000, maxCount = 5},
	{id = 8849, chance = 500},
	{id = 2158, chance = 1000},
	{id = 8472, chance = 3000, maxCount = 3},
	{id = 2506, chance = 15, unique = true},
	{id = 2156, chance = 1000},
	{id = 18414, chance = 3000, maxCount = 5},
	{id = 18415, chance = 3000, maxCount = 5},
	{id = 5887, chance = 500},
	{id = 7590, chance = 3000, maxCount = 3},
	{id = 2155, chance = 1000},
	{id = 5948, chance = 5000},
	{id = 5904, chance = 500},
	{id = 27623, chance = 500, unique = true},
	{id = 18413, chance = 3000, maxCount = 5},
	{id = 7632, chance = 500},
	{id = 8473, chance = 3000, maxCount = 3},
	{id = 8902, chance = 500},
	{id = 12648, chance = 300, unique = true},
	{id = 2152, chance = 90000, maxCount = 6},
	{id = 2147, chance = 3000, maxCount = 5}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 112, attack = 85},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -110, maxDamage = -495, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -110, maxDamage = -495, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -110, maxDamage = -495, radius = 8, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="charged energy elemental electrify", interval = 2000, chance = 15, minDamage = -1100, maxDamage = -1100, radius = 5, effect = CONST_ME_YELLOWENERGY, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -710, maxDamage = -895, length = 9, spread = 4, effect = CONST_ME_ENERGYAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -710, maxDamage = -895, length = 9, spread = 4, effect = CONST_ME_HITBYFIRE, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -710, maxDamage = -895, length = 9, spread = 3, effect = CONST_ME_FIREAREA, target = false}
}

monster.defenses = {
	defense = 64,
	armor = 52,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 450, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 1},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
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
