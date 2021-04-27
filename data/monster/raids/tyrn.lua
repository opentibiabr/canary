local mType = Game.createMonsterType("Tyrn")
local monster = {}

monster.description = "Tyrn"
monster.experience = 6900
monster.outfit = {
	lookType = 562,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 12000
monster.maxHealth = 12000
monster.race = "blood"
monster.corpse = 21287
monster.speed = 300
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5
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
	{text = "GRRR", yell = false},
	{text = "GRROARR", yell = false}
}

monster.loot = {
	{id = 21400, chance = 5000},
	{id = 21695, chance = 3000},
	{id = 2672, chance = 55000, maxCount = 3},
	{id = 2268, chance = 15000},
	{id = 2148, chance = 100000, maxCount = 50},
	{id = 2152, chance = 60000, maxCount = 8},
	{id = 7368, chance = 30000, maxCount = 5},
	{id = 7588, chance = 25000, maxCount = 5},
	{id = 7589, chance = 25000, maxCount = 5},
	{id = 10582, chance = 100000},
	{id = 2156, chance = 9000},
	{id = 2154, chance = 9000},
	{id = 2153, chance = 9000},
	{id = 2515, chance = 9000},
	{id = 8873, chance = 9000},
	{id = 2145, chance = 15000, maxCount = 5},
	{id = 2150, chance = 15000, maxCount = 5},
	{id = 2149, chance = 15000, maxCount = 5},
	{id = 2146, chance = 15000, maxCount = 5},
	{id = 9970, chance = 15000, maxCount = 5},
	{id = 2147, chance = 15000, maxCount = 5}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 70, attack = 130},
	{name ="drunk", interval = 2000, chance = 8, radius = 8, effect = CONST_ME_SOUND_YELLOW, target = false, duration = 25000},
	{name ="combat", interval = 2000, chance = 33, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -190, range = 7, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_ENERGYAREA, target = true},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -300, range = 7, radius = 4, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_EXPLOSIONHIT, target = true},
	{name ="tyrn electrify", interval = 2000, chance = 11, target = false},
	{name ="tyrn skill reducer", interval = 2000, chance = 14, target = false}
}

monster.defenses = {
	defense = 68,
	armor = 58,
	{name ="combat", interval = 2000, chance = 33, type = COMBAT_HEALING, minDamage = 200, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="invisible", interval = 2000, chance = 11, effect = CONST_ME_ENERGYHIT},
	{name ="tyrn heal", interval = 1000, chance = 100, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 10},
	{type = COMBAT_FIREDAMAGE, percent = 30},
	{type = COMBAT_LIFEDRAIN, percent = 100},
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
