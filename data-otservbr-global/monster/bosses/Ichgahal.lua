local mType = Game.createMonsterType("Ichgahal")
local monster = {}

monster.description = "Ichgahal"
monster.experience = 180000
monster.outfit = {
	lookType = 1665,
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
monster.corpse = 44018
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20
}

monster.bosstiary = {
	bossRaceId = 2364,
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
	{id = 3043, chance = 10000, maxCount = 30}, 
	{id = 16124, chance = 10000, maxCount = 15},
	{id = 7368, chance = 10000, maxCount = 100}, 
	{id = 6499, chance = 1000, maxCount = 2}, 
	{id = 7643, chance = 10000, maxCount = 10}, 
	{id = 31965, chance = 15000, maxCount = 1},
	{id = 238, chance = 10000, maxCount = 10}, 
	{id = 7642, chance = 10000, maxCount = 10},
	{id = 43854, chance = 18500, maxCount = 2},
	{id = 43853, chance = 28500, maxCount = 3},
	{id = 43964, chance = 500},
	{id = 43851, chance = 22000, maxCount = 4},
	{id = 43855, chance = 500}, --darklight heart
	{id = 43502, chance = 10000, maxCount = 2},
	{id = 16119, chance = 8000, maxCount = 3},
	{id = 16120, chance = 8000, maxCount = 3},
	{id = 16121, chance = 8000, maxCount = 3}, 
	{id = 3033, chance = 8000, maxCount = 10},
	{id = 3028, chance = 8000, maxCount = 10}, 
	{id = 9057, chance = 8000, maxCount = 10},
	{id = 7427, chance = 13000}, 
	{id = 23267, chance = 10000, maxCount = 5},
	{id = 23234, chance = 3000, maxCount = 2},
	{id = 23236, chance = 3000, maxCount = 3},
	{id = 23238, chance = 3000, maxCount = 3},
	{id = 7451, chance = 11000}, 
	{id = 8073, chance = 9000}, 
	{id = 23477, chance = 7600}, 
	{id = 6553, chance = 5500}, 
	{name = "elven mail", chance = 3500},
	{name = "carapace shield", chance = 6500},
	{name = "thaian sword", chance = 17000},
	{name = "zaoan sword", chance = 6500},

}

monster.attacks = {
	{name ="melee", interval = 3000, chance = 100, minDamage = -1500, maxDamage = -2300},
	{name ="combat", interval = 1000, chance = 49, type = COMBAT_PHYSICALDAMAGE, minDamage = -700, maxDamage = -1000, length = 12, spread = 3, effect = 249, target = false},
	{name ="combat", interval = 2000, chance = 90, type = COMBAT_MANADRAIN, minDamage = -2600, maxDamage = -2300, length = 12, spread = 3, effect = CONST_ME_ENERGYAREA, target = false},
	{name ="combat", interval = 2000, chance = 39, type = COMBAT_FIREDAMAGE, minDamage = -900, maxDamage = -1500, length = 6, spread = 2, effect = CONST_ME_FIREAREA, target = false},
	{name ="speed", interval = 2000, chance = 40, speedChange = -600, radius = 8, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000}
}

monster.defenses = {
	defense = 105,
	armor = 105,
	{name ="combat", interval = 3000, chance = 10, type = COMBAT_HEALING, minDamage = 800, maxDamage = 1200, effect = CONST_ME_MAGIC_BLUE, target = false},
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