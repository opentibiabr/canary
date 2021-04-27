local mType = Game.createMonsterType("Zavarash")
local monster = {}

monster.description = "Zavarash"
monster.experience = 21000
monster.outfit = {
	lookType = 12,
	lookHead = 19,
	lookBody = 0,
	lookLegs = 77,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 35000
monster.maxHealth = 35000
monster.race = "blood"
monster.corpse = 6068
monster.speed = 440
monster.manaCost = 0
monster.maxSummons = 2

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
	targetDistance = 4,
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

monster.summons = {
	{name = "dark torturer", chance = 100, interval = 1000, max = 2}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Harrr, Harrr!", yell = true}
}

monster.loot = {
	{id = 22396, chance = 100000},
	{id = 2148, chance = 100000, maxCount = 197},
	{id = 2152, chance = 100000, maxCount = 50},
	{id = 5954, chance = 100000},
	{id = 22598, chance = 60000},
	{id = 6500, chance = 60000},
	{id = 7632, chance = 40000},
	{id = 18414, chance = 40000, maxCount = 8},
	{id = 7590, chance = 34440, maxCount = 10},
	{id = 8473, chance = 34440, maxCount = 10},
	{id = 8472, chance = 34440, maxCount = 5},
	{id = 18413, chance = 30000, maxCount = 8},
	{id = 18415, chance = 30000, maxCount = 8},
	{id = 2155, chance = 20000},
	{id = 2515, chance = 15030},
	{id = 2427, chance = 15030},
	{id = 2158, chance = 15030},
	{id = 9971, chance = 15030},
	{id = 7428, chance = 15030},
	{id = 2452, chance = 12940},
	{id = 2519, chance = 11540},
	{id = 22610, chance = 10000},
	{id = 8891, chance = 9620},
	{id = 7387, chance = 8390},
	{id = 2520, chance = 6290},
	{id = 2514, chance = 1400},
	{id = 7431, chance = 700},
	{id = 8877, chance = 350},
	{id = 8928, chance = 170}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -6000, range = 7, shootEffect = CONST_ANI_THROWINGKNIFE, target = false}
}

monster.defenses = {
	defense = 65,
	armor = 55,
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 400, maxDamage = 600, radius = 8, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 18, speedChange = 784, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 7000},
	{name ="invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50},
	{type = COMBAT_ENERGYDAMAGE, percent = 50},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 50},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
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
