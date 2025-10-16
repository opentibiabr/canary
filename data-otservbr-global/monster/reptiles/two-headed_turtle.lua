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
	{ id = 3035, chance = 80000, maxCount = 27 }, -- platinum coin
	{ id = 237, chance = 23000 }, -- strong mana potion
	{ id = 239, chance = 23000 }, -- great health potion
	{ id = 7573, chance = 23000 }, -- bone
	{ id = 39409, chance = 23000 }, -- twoheaded turtle heads
	{ id = 39410, chance = 23000 }, -- hydrophytes
	{ id = 814, chance = 5000 }, -- terra amulet
	{ id = 819, chance = 5000 }, -- glacier shoes
	{ id = 828, chance = 5000 }, -- lightning headband
	{ id = 3010, chance = 5000 }, -- emerald bangle
	{ id = 3017, chance = 5000 }, -- silver brooch
	{ id = 3371, chance = 5000 }, -- knight legs
	{ id = 3565, chance = 5000 }, -- cape
	{ id = 8072, chance = 5000 }, -- spellbook of enlightenment
	{ id = 24391, chance = 5000 }, -- coral brooch
	{ id = 24392, chance = 5000 }, -- gemmed figurine
	{ id = 39408, chance = 5000 }, -- small tropical fish
	{ id = 27488, chance = 1000 }, -- gold nugget
	{ id = 10422, chance = 1000 }, -- clay lump
	{ id = 32769, chance = 260 }, -- white gem
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
