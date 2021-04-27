local mType = Game.createMonsterType("World Devourer")
local monster = {}

monster.description = "World Devourer"
monster.experience = 77700
monster.outfit = {
	lookType = 875,
	lookHead = 82,
	lookBody = 79,
	lookLegs = 81,
	lookFeet = 113,
	lookAddons = 3,
	lookMount = 0
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "venom"
monster.corpse = 0
monster.speed = 450
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
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	pet = false
}

monster.events = {
	"HeartBossDeath"
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
	{id = 2148, chance = 100000, maxCount = 100},
	{id = 2152, chance = 100000, maxCount = 20},
	{id = 18413, chance = 10000, maxCount = 3},
	{id = 7590, chance = 10000, maxCount = 5},
	{id = 8472, chance = 10000, maxCount = 5},
	{id = 18415, chance = 10000, maxCount = 3},
	{id = 8473, chance = 10000, maxCount = 5},
	{id = 18414, chance = 10000, maxCount = 3},
	{id = 26163, chance = 10000},
	{id = 26164, chance = 10000},
	{id = 7632, chance = 5000},
	{id = 7633, chance = 5000},
	{id = 26166, chance = 10000},
	{id = 26176, chance = 10000},
	{id = 2155, chance = 10000},
	{id = 25377, chance = 100000},
	{id = 7426, chance = 10000},
	{id = 7901, chance = 8000},
	{id = 26189, chance = 8000},
	{id = 2153, chance = 8000},
	{id = 26130, chance = 6000, unique = true},
	{id = 26133, chance = 6000, unique = true},
	{id = 26342, chance = 4000, unique = true},
	{id = 26340, chance = 2000, unique = true}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1600},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -400, maxDamage = -800, length = 10, spread = 3, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -800, radius = 4, effect = CONST_ME_SMALLCLOUDS, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -800, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_YELLOWENERGY, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -600, maxDamage = -1200, length = 10, spread = 3, effect = CONST_ME_LOSEENERGY, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, radius = 8, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="anomaly break", interval = 2000, chance = 40, target = false},
	{name ="devourer summon", interval = 2000, chance = 25, target = false}
}

monster.defenses = {
	defense = 150,
	armor = 150
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
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
