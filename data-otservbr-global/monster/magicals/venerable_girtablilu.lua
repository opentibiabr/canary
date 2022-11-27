local mType = Game.createMonsterType("Venerable Girtablilu")
local monster = {}

monster.description = "a venerable girtablilu"
monster.experience = 5300
monster.outfit = {
	lookType = 1407,
	lookHead = 38,
	lookBody = 58,
	lookLegs = 114,
	lookFeet = 2,
	lookAddons = 3,
	lookMount = 0
}

monster.raceId = 2098
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Ruins of Nuur"
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 36963
monster.speed = 180

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 4,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "platinum coin", chance = 70000, maxCount = 19},
	{name = "gold ingot", chance = 15920, maxCount = 2},
	{name = "small diamond", chance = 5360, maxCount = 6},
	{name = "cyan crystal fragment", chance = 5210, maxCount = 3},
	{name = "scorpion charm", chance = 5210, maxCount = 1},
	{id = 3039, chance = 4910, maxCount = 1}, -- red gem
	{name = "old girtablilu carapace", chance = 4760, maxCount = 1},
	{name = "violet gem", chance = 4170, maxCount = 1},
	{name = "northwind rod", chance = 3570},
	{name = "wand of cosmic energy", chance = 2680},
	{name = "blue crystal shard", chance = 2530},
	{name = "red crystal fragment", chance = 2530},
	{name = "violet crystal shard", chance = 2530},
	{name = "yellow gem", chance = 2530},
	{name = "underworld rod", chance = 2080},
	{name = "wand of voodoo", chance = 2080},
	{name = "blue gem", chance = 1930},
	{id = 23529, chance = 1930}, -- ring of blue plasma
	{name = "green crystal fragment", chance = 1640},
	{name = "green crystal shard", chance = 1640},
	{name = "wand of defiance", chance = 1340},
	{name = "wood cape", chance = 1340},
	{name = "necrotic rod", chance = 1040},
	{name = "springsprout rod", chance = 1040},
	{name = "wand of decay", chance = 1040}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550, effect = CONST_ME_DRAWBLOOD},
	{name ="combat", interval = 2750, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -500, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -400, length = 4, spread = 3, effect = CONST_ME_HITBYPOISON, target = false},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -400, radius = 3, effect = CONST_ME_HITBYPOISON, target = false},
	{name ="girtablilu poison wave", interval = 2000, chance = 30, minDamage = -200, maxDamage = -400},
}

monster.defenses = {
	defense = 80,
	armor = 80,
	{name ="speed", interval = 1000, chance = 10, speedChange = 160, effect = CONST_ME_POFF, target = false, duration = 4000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}


mType:register(monster)
