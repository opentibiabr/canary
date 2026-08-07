local mType = Game.createMonsterType("Cobra Vizier")
local monster = {}

monster.description = "a cobra vizier"
monster.experience = 7650
monster.outfit = {
	lookType = 1217,
	lookHead = 19,
	lookBody = 19,
	lookLegs = 67,
	lookFeet = 78,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1824
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Cobra Bastion.",
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 31639
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "COMBINE FORCES MY BRETHEN!", yell = true },
	{ text = "Feel the cobras wrath!", yell = false },
	{ text = "OH NO, YOU WON'T!", yell = true },
}

monster.loot = {
	{ id = 3035, chance = 71000, maxCount = 4 }, -- Platinum Coin
	{ id = 3065, chance = 32000 }, -- Terra Rod
	{ id = 31678, chance = 14600 }, -- Cobra Crest
	{ id = 813, chance = 14000 }, -- Terra Boots
	{ id = 830, chance = 13200 }, -- Terra Hood
	{ id = 3066, chance = 12400 }, -- Snakebite Rod
	{ id = 16125, chance = 10800 }, -- Cyan Crystal Fragment
	{ id = 3039, chance = 7100 }, -- Red Gem
	{ id = 282, chance = 6900 }, -- Giant Shimmering Pearl (Brown)
	{ id = 16127, chance = 5100 }, -- Green Crystal Fragment
	{ id = 24392, chance = 4300 }, -- Gemmed Figurine
	{ id = 16120, chance = 4100 }, -- Violet Crystal Shard
	{ id = 3010, chance = 3400 }, -- Emerald Bangle
	{ id = 3038, chance = 3000 }, -- Green Gem
	{ id = 16126, chance = 2800 }, -- Red Crystal Fragment
	{ id = 3297, chance = 2300 }, -- Serpent Sword
	{ id = 22193, chance = 930, maxCount = 3 }, -- Onyx Chip
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -480 },
	{ name = "explosion wave", interval = 2000, chance = 15, minDamage = -280, maxDamage = -400, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -350, maxDamage = -520, radius = 4, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_GREEN_RINGS, target = true },
	{ name = "death chain", interval = 4000, chance = 30, minDamage = -550, maxDamage = -800, range = 3, target = true },
}

monster.defenses = {
	defense = 82,
	armor = 82,
	mitigation = 2.31,
	{ name = "speed", interval = 2000, chance = 8, speedChange = 250, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onSpawn = function(monster)
	monster:handleCobraOnSpawn()
end

mType:register(monster)
