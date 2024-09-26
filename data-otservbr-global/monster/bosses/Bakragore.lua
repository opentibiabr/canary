local mType = Game.createMonsterType("Bakragore")
local monster = {}

monster.description = "Bakragore"
monster.experience = 550000
monster.outfit = {
	lookType = 1671,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 660000
monster.maxHealth = 660000
monster.race = "undead"
monster.corpse = 44012
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20
}

monster.bosstiary = {
	bossRaceId = 2367,
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

monster.events = {
	"RottenbloodBossDeath"
}

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
}

monster.voices = {
}

monster.loot = {
	{id = 3043, chance = 10000, maxCount = 50}, 
	{id = 7643, chance = 40000, maxCount = 20},
	{id = 238, chance = 40000, maxCount = 20}, 
	{id = 7642, chance = 40000, maxCount = 20}, 
	{name = "white gem", chance = 30000, maxCount = 1},
	{name = "giant sapphire", chance = 3000, maxCount = 1},
	{id = 44008, chance = 500, maxCount = 1}, -- moonlight ipomea's stamen.
	{name = "fireborn giant armor", chance = 18000},
	{name = "royal crossbow", chance = 18000},
	{name = "stomper", chance = 13000},
	{name = "blue gem", chance = 9000},
	{name = "gold ring", chance = 9000},
	{name = "steel boots", chance = 9000},
	{name = "thunder hammer", chance = 9000},
	{id = 43855, chance = 552, maxCount = 1}, --darklight heart
	{id = 43854, chance = 29500, maxCount = 2},
	{id = 43853, chance = 455, maxCount = 1}, --darklight core
	{id = 43901, chance = 400},
	{id = 23267, chance = 750},
	{id = 23234, chance = 700},
	{id = 23236, chance = 600},
	{id = 23238, chance = 800},
	{id = 44048, chance = 400}, -- Spirit Horseshoe ( Spirit of Purity Mount x4 )
	{id = 3278, chance = 50}, -- Magic Longsword Ultra Rare
	{id = 43963, chance = 320}, -- figurine bakragore
	{id = 43968, chance = 300}, -- bakragore's amalgamation
	{id = 9058, chance = 800}, -- gold ingot
	{id = 43860, chance = 100}, -- Bag you covet
	{id = 43864, chance = 100}, -- Sanguine Items ( not grand )
	{id = 43866, chance = 100},
	{id = 43868, chance = 100},
	{id = 43870, chance = 100},
	{id = 43872, chance = 100},
	{id = 43874, chance = 100},
	{id = 43876, chance = 100},
	{id = 43877, chance = 100},
	{id = 43879, chance = 100},
	{id = 43881, chance = 100},
	{id = 43882, chance = 100},
	{id = 43884, chance = 100},
	{id = 43885, chance = 100},
	{id = 43887, chance = 100},
	{id = 36478, chance = 100}


}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -3000},
	{name ="combat", interval = 3000, chance = 55, type = COMBAT_ICEDAMAGE, minDamage = -900, maxDamage = -1100, range = 7, radius = 7, shootEffect = CONST_ANI_ICE, effect = 243, target = true},
	{name ="combat", interval = 2000, chance = 60, type = COMBAT_DEATHDAMAGE, minDamage = -100, maxDamage = -1000, length = 8, spread = 3, effect = 250, target = false},
	{name ="combat", interval = 3000, chance = 53, type = COMBAT_FIREDAMAGE, minDamage = -1000, maxDamage = -2000, length = 8, spread = 3, effect = 249, target = false},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_ICEDAMAGE, minDamage = -950, maxDamage = -2400, range = 7, radius = 3, shootEffect = 37, effect = 241, target = true},
	{name ="combat", interval = 2000, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -1000, maxDamage = -2500, length = 8, spread = 3, effect = 244, target = false},
}

monster.defenses = {
	defense = 135,
	armor = 135,
	{name ="combat", interval = 1000, chance = 15, type = COMBAT_HEALING, minDamage = 2500, maxDamage = 3500, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 4000, chance = 80, speedChange = 700, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000}
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