local mType = Game.createMonsterType("Chagorz")
local monster = {}

monster.description = "Chagorz"
monster.experience = 180000
monster.outfit = {
	lookType = 1666,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "undead"
monster.corpse = 44024
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20
}

monster.bosstiary = {
	bossRaceId = 2366,
	bossRace = RARITY_NEMESIS
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.events = {"RottenbloodBossDeath"}

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
}

monster.voices = {
}

monster.loot = {
	{id = 3043, chance = 10000, maxCount = 6}, 
	{id = 16124, chance = 10000, maxCount = 15},
	{id = 7368, chance = 10000, maxCount = 100}, 
	{id = 6499, chance = 1000, maxCount = 2}, 
	{id = 7643, chance = 10000, maxCount = 10}, 
	{id = 238, chance = 10000, maxCount = 10}, 
	{id = 7642, chance = 10000, maxCount = 10},
	{id = 43855, chance = 500}, -- darklight heart
	{id = 43854, chance = 18500, maxCount = 2},
	{id = 43853, chance = 28500, maxCount = 3},
	{id = 43966, chance = 500},
	{id = 44008, chance = 7000, maxCount = 3},
	{id = 43900, chance = 1000, maxCount = 1},
	{id = 43504, chance = 10000, maxCount = 2},
	{name = "giant ruby", chance = 2840},
	{name = "magic sulphur", chance = 2740},
	{name = "yellow gem", chance = 2900},
	{name = "mastermind potion", chance = 2900, maxCount = 10},
	{name = "violet gem", chance = 1500},
	{id = 8076, chance = 3360},
	{id = 7453, chance = 4610},
	{id = 8098, chance = 3450},
	{id = 3364, chance = 4450}, 
	{id = 8051, chance = 7450}, 
	{id = 23267, chance = 10000, maxCount = 5},
	{id = 23234, chance = 3000, maxCount = 2},
	{id = 23236, chance = 3000, maxCount = 3},
	{id = 23238, chance = 3000, maxCount = 3},
	{id = 23263, chance = 3000, maxCount = 3},
	{id = 8090, chance = 5300},
	{name = "depth calcei", chance = 7000},
	{name = "blossom bag", chance = 8000},
	{name = "calopteryx cape", chance = 14000},
	{name = "earthborn titan armor", chance = 5000},
	{name = "golden boots", chance = 800}
	

}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -1300, maxDamage = -2250},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_EARTHDAMAGE, minDamage = -500, maxDamage = -900, radius = 4, effect = CONST_ME_GREEN_RINGS, target = false},
	{name ="combat", interval = 2000, chance = 50, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -900, range = 4, radius = 4, effect = 241, target = true},
	{name ="combat", interval = 2000, chance = 35, type = COMBAT_EARTHDAMAGE, minDamage = -1000, maxDamage = -1200, length = 10, spread = 3, effect = CONST_ME_POFF, target = false},
	{name ="combat", interval = 2000, chance = 39, type = COMBAT_LIFEDRAIN, minDamage = -1500, maxDamage = -1900, length = 10, spread = 3, effect = 225, target = false},
	{name ="speed", interval = 2000, chance = 29, speedChange = -600, radius = 7, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 20000},
}

monster.defenses = {
	defense = 105,
	armor = 105,
	{name ="combat", interval = 3000, chance = 10, type = COMBAT_HEALING, minDamage = 700, maxDamage = 1500, effect = 236, target = false},
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 15},
	{type = COMBAT_ENERGYDAMAGE, percent = 15},
	{type = COMBAT_EARTHDAMAGE, percent = 15},
	{type = COMBAT_FIREDAMAGE, percent = 15},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 15},
	{type = COMBAT_HOLYDAMAGE , percent = 15},
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