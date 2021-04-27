local mType = Game.createMonsterType("The Duke Of The Depths")
local monster = {}

monster.description = "The Duke Of The Depths"
monster.experience = 40000
monster.outfit = {
	lookType = 1047,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 50000
monster.maxHealth = 50000
monster.race = "blood"
monster.corpse = 32008
monster.speed = 270
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 50
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
	{id = 2152, chance = 67610, maxCount = 58},
	{id = 2160, chance = 67610},
	{id = 18413, chance = 14710, maxCount = 4},
	{id = 2149, chance = 13160, maxCount = 12},
	{id = 9970, chance = 11480, maxCount = 12},
	{id = 2150, chance = 14520, maxCount = 12},
	{id = 7590, chance = 14520, maxCount = 18},
	{id = 2145, chance = 14520, maxCount = 2},
	{id = 2147, chance = 14520, maxCount = 12},
	{id = 7591, chance = 14520, maxCount = 8},
	{id = 8472, chance = 14520, maxCount = 10},
	{id = 8473, chance = 14520, maxCount = 8},
	{id = 7440, chance = 10060},
	{id = 2156, chance = 14520},
	{id = 2154, chance = 14520},
	{id = 30854, chance = 10000},
	{id = 9814, chance = 17230},
	{id = 5892, chance = 14520},
	{id = 2187, chance = 14520},
	{id = 2432, chance = 15810},
	{id = 2392, chance = 14520},
	{id = 7884, chance = 14520},
	{id = 12410, chance = 14520},
	{id = 2197, chance = 14520},
	{id = 9822, chance = 14520},
	{id = 5904, chance = 14520},
	{id = 30892, chance = 1000},
	{id = 30886, chance = 600},
	{id = 30884, chance = 510},
	{id = 30885, chance = 560},
	{id = 25377, chance = 580},
	{id = 30761, chance = 520},
	{id = 30883, chance = 400}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -800},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -1000, range = 3, length = 6, spread = 8, effect = CONST_ME_FIREAREA, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -1000, range = 3, length = 9, spread = 4, effect = CONST_ME_HITBYFIRE, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -135, maxDamage = -1000, radius = 2, effect = CONST_ME_EXPLOSIONAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1000, radius = 8, effect = CONST_ME_HITAREA, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 40
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 60},
	{type = COMBAT_ENERGYDAMAGE, percent = 60},
	{type = COMBAT_EARTHDAMAGE, percent = 60},
	{type = COMBAT_FIREDAMAGE, percent = -100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 60},
	{type = COMBAT_HOLYDAMAGE , percent = 60},
	{type = COMBAT_DEATHDAMAGE , percent = 60}
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
