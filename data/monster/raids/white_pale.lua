local mType = Game.createMonsterType("White Pale")
local monster = {}

monster.description = "White Pale"
monster.experience = 390
monster.outfit = {
	lookType = 564,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 500
monster.maxHealth = 500
monster.race = "blood"
monster.corpse = 21295
monster.speed = 170
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0
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
}

monster.loot = {
	{id = 21400, chance = 200},
	{id = 2148, chance = 80000, maxCount = 100},
	{id = 2148, chance = 70000, maxCount = 100},
	{id = 21693, chance = 500},
	{id = 21692, chance = 500},
	{id = 2168, chance = 1000},
	{id = 2145, chance = 7000},
	{id = 2666, chance = 70000, maxCount = 4},
	{id = 10609, chance = 70000},
	{id = 2439, chance = 70000},
	{id = 11192, chance = 70000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 45, attack = 40},
	{name ="combat", interval = 2000, chance = 14, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -110, radius = 5, effect = CONST_ME_SMALLPLANTS, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 12, minDamage = -200, maxDamage = -300, radius = 3, effect = CONST_ME_HITAREA, target = false},
	{name ="white pale paralyze", interval = 2000, chance = 11, target = false}
}

monster.defenses = {
	defense = 11,
	armor = 8,
	{name ="white pale summon", interval = 2000, chance = 12, target = false}
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
