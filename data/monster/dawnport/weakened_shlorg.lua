local mType = Game.createMonsterType("Weakened Shlorg")
local monster = {}

monster.description = "Weakened Shlorg"
monster.experience = 6500
monster.outfit = {
	lookType = 565,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "venom"
monster.corpse = 21299
monster.speed = 270
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 60000,
	chance = 0
}

monster.strategiesTarget = {
	nearest = 100,
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
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Tchhh!", yell = false},
	{text = "Slurp!", yell = false}
}

monster.loot = {
	{id = 21400, chance = 3000},
	{id = 2148, chance = 100000, maxCount = 105},
	{id = 2152, chance = 100000, maxCount = 8},
	{id = 21705, chance = 3000},
	{id = 21706, chance = 3000},
	{id = 2154, chance = 10000},
	{id = 2155, chance = 10000},
	{id = 8473, chance = 10000, maxCount = 3},
	{id = 8472, chance = 10000, maxCount = 3},
	{id = 7590, chance = 10000, maxCount = 3},
	{id = 2149, chance = 10000, maxCount = 5},
	{id = 9970, chance = 10000, maxCount = 5},
	{id = 8872, chance = 20000},
	{id = 5910, chance = 10000},
	{id = 5911, chance = 10000},
	{id = 5914, chance = 10000},
	{id = 2409, chance = 20000},
	{id = 8912, chance = 20000},
	{id = 8891, chance = 10000},
	{id = 10584, chance = 100000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 150, attack = 50, condition = {type = CONDITION_POISON, totalDamage = 180, interval = 4000}},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -90, maxDamage = -180, length = 4, spread = 3, effect = CONST_ME_MAGIC_GREEN, target = false},
	{name ="combat", interval = 2000, chance = 14, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -150, radius = 5, effect = CONST_ME_GREEN_RINGS, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 13, minDamage = -360, maxDamage = -440, radius = 5, effect = CONST_ME_GREEN_RINGS, target = false},
	{name ="shlorg paralyze", interval = 2000, chance = 11, target = false}
}

monster.defenses = {
	defense = 15,
	armor = 10,
	{name ="combat", interval = 2000, chance = 35, type = COMBAT_HEALING, minDamage = 95, maxDamage = 150, effect = CONST_ME_MAGIC_RED, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 5},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = 80},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = -5},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
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
