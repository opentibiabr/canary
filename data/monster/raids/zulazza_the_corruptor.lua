local mType = Game.createMonsterType("Zulazza The Corruptor")
local monster = {}

monster.description = "Zulazza The Corruptor"
monster.experience = 10000
monster.outfit = {
	lookType = 334,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 46500
monster.maxHealth = 46500
monster.race = "blood"
monster.corpse = 11107
monster.speed = 290
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 1500,
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
	{text = "I'm Zulazza, and you won't forget me that fazzt.", yell = false},
	{text = "Zzaion is our last zztand! I will not leave wizzout a fight!", yell = false},
	{text = "Behind zze Great Gate liezz your doom!", yell = false},
	{text = "Oh, HE will take revenge on zzizz azzault when you zztep in front of HIZZ fazze!", yell = false}
}

monster.loot = {
	{id = 7591, chance = 30500},
	{id = 2152, chance = 41325, maxCount = 30},
	{id = 2148, chance = 49650, maxCount = 100},
	{id = 9808, chance = 50500},
	{id = 9971, chance = 33000, maxCount = 4},
	{id = 2158, chance = 30500},
	{id = 2155, chance = 20500},
	{id = 8473, chance = 10500},
	{id = 11118, chance = 5500},
	{id = 5944, chance = 19250, maxCount = 4},
	{id = 2528, chance = 15500},
	{id = 7366, chance = 8100, maxCount = 67},
	{id = 7632, chance = 28000, maxCount = 2},
	{id = 2154, chance = 15500},
	{id = 2156, chance = 10500},
	{id = 7440, chance = 10500},
	{id = 2153, chance = 25500},
	{id = 7590, chance = 20500},
	{id = 8882, chance = 5500},
	{id = 2514, chance = 5500},
	{id = 2127, chance = 10500},
	{id = 8891, chance = 5500},
	{id = 2515, chance = 5500}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 200, attack = 200},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -500, maxDamage = -800, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -800, radius = 3, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -130, range = 7, effect = CONST_ME_MAGIC_GREEN, target = true},
	{name ="speed", interval = 2000, chance = 20, speedChange = -500, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000}
}

monster.defenses = {
	defense = 119,
	armor = 96,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 2000, maxDamage = 3000, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 70},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = 30}
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
