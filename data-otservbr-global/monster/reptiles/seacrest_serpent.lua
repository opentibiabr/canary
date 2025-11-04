local mType = Game.createMonsterType("Seacrest Serpent")
local monster = {}

monster.description = "a seacrest serpent"
monster.experience = 2900
monster.outfit = {
	lookType = 675,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1096
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 2,
	Locations = "Seacrest Grounds when Quara Renegades are not spawning.",
}

monster.health = 3000
monster.maxHealth = 3000
monster.race = "venom"
monster.corpse = 21893
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 9,
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
	level = 3,
	color = 212,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "LEAVE THESE GROUNDS...", yell = true },
	{ text = "THE DARK TIDE WILL SWALLOW YOU...", yell = true },
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 3583, chance = 14010 }, -- Dragon Ham
	{ id = 237, chance = 7930, maxCount = 2 }, -- Strong Mana Potion
	{ id = 236, chance = 7640, maxCount = 2 }, -- Strong Health Potion
	{ id = 762, chance = 8230, maxCount = 19 }, -- Shiver Arrow
	{ id = 21801, chance = 11360 }, -- Seacrest Hair
	{ id = 21800, chance = 16670 }, -- Seacrest Scale
	{ id = 21747, chance = 6750 }, -- Seacrest Pearl
	{ id = 281, chance = 1610 }, -- Giant Shimmering Pearl (Green)
	{ id = 3028, chance = 4230, maxCount = 3 }, -- Small Diamond
	{ id = 3027, chance = 2060, maxCount = 3 }, -- Black Pearl
	{ id = 3026, chance = 1970, maxCount = 2 }, -- White Pearl
	{ id = 823, chance = 2040 }, -- Glacier Kilt
	{ id = 5944, chance = 3310 }, -- Soul Orb
	{ id = 819, chance = 1920 }, -- Glacier Shoes
	{ id = 829, chance = 2040 }, -- Glacier Mask
	{ id = 8093, chance = 940 }, -- Wand of Draconia
	{ id = 815, chance = 1050 }, -- Glacier Amulet
	{ id = 21892, chance = 1010 }, -- Crest of the Deep Seas
	{ id = 16096, chance = 230 }, -- Wand of Defiance
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 120, attack = 82 },
	{ name = "combat", interval = 2000, chance = 7, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -260, range = 7, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_SOUND_RED, target = true },
	{ name = "combat", interval = 2000, chance = 11, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -285, radius = 3, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "seacrest serpent wave", interval = 2000, chance = 30, minDamage = 0, maxDamage = -284, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -300, length = 4, spread = 3, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.defenses = {
	defense = 31,
	armor = 51,
	mitigation = 1.21,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 145, maxDamage = 200, effect = CONST_ME_SOUND_BLUE, target = false },
	{ name = "melee", interval = 2000, chance = 10, minDamage = 0, maxDamage = 0 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
