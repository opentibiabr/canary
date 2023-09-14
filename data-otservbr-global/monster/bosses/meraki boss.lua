local mType = Game.createMonsterType("Meraki Boss")
local monster = {}

monster.description = "Meraki Boss"
monster.experience = 2000000
monster.outfit = {
	lookType = 1393,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 5000000
monster.maxHealth = monster.health 
monster.race = "undead"
monster.corpse = 36612
monster.speed = 1000
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20
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

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "TU VAI ESCUTA O RAIO DO PIPOCO NO PE DO OUVIDO", yell = true},
	{text = "PIU", yell = true},
	{text = "CREU", yell = true},
	{text = "AQUI TEM CORAGEM!", yell = true}
}

monster.loot = {
	{id = 3043, chance = 30000, maxCount = 550}, -- crystal coin
	{id = 39546, chance = 50, unique = true}, -- primal bag
	{id = 34109, chance = 50, unique = true}, -- bag you desire
	{id = 43895, chance = 20, unique = true}, -- bag you covet
	{id = 30316, chance = 120, unique = true}, -- surprise bag
	{id = 3422, chance = 80, unique = true}, --  great shield
	{id = 33893, chance = 10000, maxCount = 5}, -- stamina refil 20h
	{id = 31633, chance = 80, unique = true}, -- teleport cube
	{id = 37110, chance = 1000, maxCount = 3}, -- exalted core
	{id = 37109, chance = 2000, maxCount = 35}, -- sliver
	{id = 19082, chance = 1000, maxCount = 2}, -- dust refiler
	{id = 36724, chance = 1000, maxCount = 30}, -- strike enchancment
	{id = 44048, chance = 150, unique = true}, -- spiritual horseshoe
	{id = 37338, chance = 5000, maxCount = 5}, -- remove skull
	{id = 36727, chance = 5000, maxCount = 5}, -- wealth duplex - loot 2x

}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -5000},
	{name ="combat", interval = 3000, chance = 35, type = COMBAT_ICEDAMAGE, minDamage = -900, maxDamage = -1100, range = 7, radius = 7, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = true},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_DEATHDAMAGE, minDamage = -100, maxDamage = -1000, length = 8, spread = 3, effect = CONST_ME_POFF, target = false},
	{name ="combat", interval = 2000, chance = 19, type = COMBAT_DEATHDAMAGE, minDamage = -100, maxDamage = -800, range = 7, radius = 6, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true},
	{name ="combat", interval = 3000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -4000, maxDamage = -6000, length = 8, spread = 3, effect = CONST_ME_HITBYFIRE, target = false},
	{name ="combat", interval = 2000, chance = 14, type = COMBAT_FIREDAMAGE, minDamage = -1600, maxDamage = -3400, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false},
	{name ="combat", interval = 2500, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -480, range = 7, radius = 5, effect = CONST_ME_MAGIC_GREEN, target = false}
}

monster.defenses = {
	defense = 100,
	armor = 100
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50},
	{type = COMBAT_ENERGYDAMAGE, percent = 50},
	{type = COMBAT_EARTHDAMAGE, percent = 50},
	{type = COMBAT_FIREDAMAGE, percent = 50},
	{type = COMBAT_LIFEDRAIN, percent = 50},
	{type = COMBAT_MANADRAIN, percent = 50},
	{type = COMBAT_DROWNDAMAGE, percent = 50},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
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