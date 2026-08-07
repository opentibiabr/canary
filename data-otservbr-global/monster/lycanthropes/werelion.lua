local mType = Game.createMonsterType("Werelion")
local monster = {}

monster.description = "a werelion"
monster.experience = 2200
monster.outfit = {
	lookType = 1301,
	lookHead = 58,
	lookBody = 2,
	lookLegs = 94,
	lookFeet = 10,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 1965
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Lion Sanctum.",
}

monster.health = 2800
monster.maxHealth = 2800
monster.race = "blood"
monster.corpse = 33825
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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
	runHealth = 5,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
}

monster.loot = {
	{ id = 3035, chance = 85000, maxCount = 4 }, -- Platinum Coin
	{ id = 7642, chance = 55000, maxCount = 2 }, -- Great Spirit Potion
	{ id = 3383, chance = 23000 }, -- Dark Armor
	{ id = 9691, chance = 14500 }, -- Lion's Mane
	{ id = 3577, chance = 10100 }, -- Meat
	{ id = 7449, chance = 6100 }, -- Crystal Sword
	{ id = 676, chance = 5400, maxCount = 5 }, -- Small Enchanted Ruby
	{ id = 3017, chance = 4300 }, -- Silver Brooch
	{ id = 3028, chance = 3900 }, -- Small Diamond
	{ id = 33945, chance = 3600 }, -- Ivory Carving
	{ id = 3279, chance = 2500 }, -- War Hammer
	{ id = 22193, chance = 2400 }, -- Onyx Chip
	{ id = 25737, chance = 2200, maxCount = 3 }, -- Rainbow Quartz
	{ id = 3421, chance = 2200 }, -- Dark Shield
	{ id = 8042, chance = 2100 }, -- Spirit Cloak
	{ id = 3379, chance = 2000 }, -- Doublet
	{ id = 7454, chance = 1900 }, -- Glorious Axe
	{ id = 24391, chance = 1700 }, -- Coral Brooch
	{ id = 22083, chance = 1400 }, -- Moonlight Crystals
	{ id = 7413, chance = 1300 }, -- Titan Axe
	{ id = 7452, chance = 1300 }, -- Spiked Squelcher
	{ id = 7456, chance = 810 }, -- Noble Axe
	{ id = 34008, chance = 480 }, -- White Silk Flower
	{ id = 33781, chance = 400 }, -- Lion Figurine
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "werelion wave", interval = 2000, chance = 20, minDamage = -150, maxDamage = -250, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HOLYDAMAGE, minDamage = -300, maxDamage = -410, range = 3, effect = CONST_ME_HOLYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HOLYDAMAGE, minDamage = -170, maxDamage = -350, range = 3, shootEffect = CONST_ANI_HOLY, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 38,
	mitigation = 0.91,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 45 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
