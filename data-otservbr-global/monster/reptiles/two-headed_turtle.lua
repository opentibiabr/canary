local mType = Game.createMonsterType("Two-Headed Turtle")
local monster = {}

monster.description = "a two-headed turtle"
monster.experience = 2930
monster.outfit = {
	lookType = 1535,
}

monster.raceId = 2258
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Great Pearl Fan Reef",
}

monster.health = 5010
monster.maxHealth = 5010
monster.race = "blood"
monster.corpse = 39212
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0,
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
	canPushCreatures = false,
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
	{ text = "Krk! Krk!", yell = false },
	{ text = "BONK!", yell = true },
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 27 }, -- Platinum Coin
	{ id = 237, chance = 11731 }, -- Strong Mana Potion
	{ id = 239, chance = 15453 }, -- Great Health Potion
	{ id = 3115, chance = 6003 }, -- Bone
	{ id = 39409, chance = 7849 }, -- Two-Headed Turtle Heads
	{ id = 39410, chance = 10593 }, -- Hydrophytes
	{ id = 281, chance = 3413 }, -- Giant Shimmering Pearl (Green)
	{ id = 814, chance = 1245 }, -- Terra Amulet
	{ id = 819, chance = 4202 }, -- Glacier Shoes
	{ id = 828, chance = 1929 }, -- Lightning Headband
	{ id = 3010, chance = 1146 }, -- Emerald Bangle
	{ id = 3017, chance = 2468 }, -- Silver Brooch
	{ id = 3371, chance = 1769 }, -- Knight Legs
	{ id = 3565, chance = 1190 }, -- Cape
	{ id = 8072, chance = 894 }, -- Spellbook of Enlightenment
	{ id = 24391, chance = 2419 }, -- Coral Brooch
	{ id = 24392, chance = 1824 }, -- Gemmed Figurine
	{ id = 39408, chance = 3434 }, -- Small Tropical Fish
	{ id = 3040, chance = 812 }, -- Gold Nugget
	{ id = 10422, chance = 558 }, -- Clay Lump
	{ id = 32769, chance = 282 }, -- White Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -300 },
	{ name = "combat", interval = 2500, chance = 35, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -300, radius = 4, target = false, effect = CONST_ME_ENERGYHIT },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -300, radius = 3, target = true, effect = CONST_ME_GHOSTLY_BITE },
	{ name = "combat", interval = 3000, chance = 45, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -300, range = 1, radius = 1, target = true, effect = CONST_ME_EXPLOSIONAREA },
}

monster.defenses = {
	defense = 72,
	armor = 72,
	mitigation = 2.02,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
