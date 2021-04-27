local mType = Game.createMonsterType("Mawhawk")
local monster = {}

monster.description = "Mawhawk"
monster.experience = 14000
monster.outfit = {
	lookType = 595,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 45000
monster.maxHealth = 45000
monster.race = "blood"
monster.corpse = 22629
monster.speed = 270
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
}

monster.loot = {
	{id = 22396, chance = 30000, maxCount = 2},
	{id = 22532, chance = 30000},
	{id = 22598, chance = 30000, maxCount = 2, unique = true},
	{id = 2148, chance = 10000, maxCount = 100},
	{id = 2152, chance = 10000, maxCount = 25},
	{id = 2392, chance = 10000},
	{id = 5880, chance = 10000},
	{id = 5895, chance = 10000},
	{id = 5911, chance = 10000},
	{id = 5925, chance = 10000},
	{id = 7404, chance = 10000},
	{id = 7407, chance = 10000},
	{id = 7418, chance = 10000},
	{id = 18414, chance = 10000, maxCount = 3},
	{id = 18415, chance = 10000, maxCount = 3},
	{id = 18416, chance = 10000, maxCount = 5},
	{id = 18418, chance = 10000, maxCount = 5}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 90, attack = 90},
	{name ="combat", interval = 1800, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -685, length = 7, spread = 3, effect = CONST_ME_STONES, target = false},
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_EARTHDAMAGE, minDamage = -250, maxDamage = -590, radius = 6, effect = CONST_ME_BIGPLANTS, target = false}
}

monster.defenses = {
	defense = 55,
	armor = 55
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
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
