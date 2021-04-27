local mType = Game.createMonsterType("Feroxa5")
local monster = {}

monster.name = "Feroxa"
monster.description = "Feroxa"
monster.experience = 0
monster.outfit = {
	lookType = 731,
	lookHead = 57,
	lookBody = 76,
	lookLegs = 77,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 150000
monster.maxHealth = 150000
monster.race = "blood"
monster.corpse = 24745
monster.speed = 350
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 2
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
	{id = 18413, chance = 10000, maxCount = 5},
	{id = 18414, chance = 10000, maxCount = 5},
	{id = 18418, chance = 10000, maxCount = 5},
	{id = 2158, chance = 2500},
	{id = 2156, chance = 2500},
	{id = 2195, chance = 1500},
	{id = 2152, chance = 100000, maxCount = 50},
	{id = 8473, chance = 10000, maxCount = 5},
	{id = 7590, chance = 10000, maxCount = 5},
	{id = 7591, chance = 10000, maxCount = 5},
	{id = 24718, chance = 10000, unique = true},
	{id = 24716, chance = 1500},
	{id = 24740, chance = 1500},
	{id = 7436, chance = 1500},
	{id = 7419, chance = 1500},
	{id = 24741, chance = 1500},
	{id = 24742, chance = 1500},
	{id = 24760, chance = 12000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -1400, maxDamage = -1800},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -1050, radius = 6, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -700, maxDamage = -1250, length = 9, spread = 1, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -450, maxDamage = -700, radius = 7, effect = CONST_ME_BLOCKHIT, target = false}
}

monster.defenses = {
	defense = 55,
	armor = 50,
	{name ="speed", interval = 2000, chance = 12, speedChange = 1250, effect = CONST_ME_MAGIC_RED, target = false, duration = 10000},
	{name ="feroxa summon", interval = 2000, chance = 20, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
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
