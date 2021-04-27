local mType = Game.createMonsterType("The Last Lore Keeper")
local monster = {}

monster.description = "the last lore keeper"
monster.experience = 45000
monster.outfit = {
	lookType = 939,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 750000
monster.maxHealth = 750000
monster.race = "undead"
monster.corpse = 0
monster.speed = 450
monster.manaCost = 0
monster.maxSummons = 6

monster.changeTarget = {
	interval = 2000,
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
	runHealth = 340,
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

monster.summons = {
	{name = "sword of vengeance", chance = 50, interval = 2000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{id = 18413, chance = 3000, maxCount = 3},
	{id = 2148, chance = 50320, maxCount = 200},
	{id = 2152, chance = 50320, maxCount = 35},
	{id = 25377, chance = 3000, maxCount = 3},
	{id = 5909, chance = 3000, maxCount = 4},
	{id = 18414, chance = 3000, maxCount = 3},
	{id = 27758, chance = 500},
	{id = 2154, chance = 1000},
	{id = 2149, chance = 3000, maxCount = 20},
	{id = 7450, chance = 150, unique = true},
	{id = 5880, chance = 3000, maxCount = 2},
	{id = 10549, chance = 1000},
	{id = 2466, chance = 1000},
	{id = 8472, chance = 3000, maxCount = 10},
	{id = 22413, chance = 400},
	{id = 24849, chance = 3000},
	{id = 10577, chance = 1000},
	{id = 5887, chance = 1000},
	{id = 26189, chance = 3000},
	{id = 8473, chance = 3000, maxCount = 5},
	{id = 26031, chance = 3000, maxCount = 5}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 140, attack = 80},
	{name ="combat", interval = 2000, chance = 7, type = COMBAT_PHYSICALDAMAGE, minDamage = -650, maxDamage = -900, length = 8, spread = 3, effect = CONST_ME_EXPLOSIONAREA, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -850, maxDamage = -2260, length = 10, spread = 3, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -640, maxDamage = -800, radius = 5, effect = CONST_ME_SMALLCLOUDS, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -420, maxDamage = -954, length = 8, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -640, maxDamage = -800, radius = 5, effect = CONST_ME_STONES, target = true},
	{name ="medusa paralyze", interval = 2000, chance = 20, target = false}
}

monster.defenses = {
	defense = 50,
	armor = 50,
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 1500, maxDamage = 3000, effect = CONST_ME_MAGIC_GREEN, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = 20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
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
