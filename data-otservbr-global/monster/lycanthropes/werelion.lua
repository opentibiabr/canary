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
	{ id = 3035, chance = 94464 }, -- Platinum Coin
	{ id = 7642, chance = 60104 }, -- Great Spirit Potion
	{ id = 3383, chance = 24808 }, -- Dark Armor
	{ id = 676, chance = 5571 }, -- Small Enchanted Ruby
	{ id = 3577, chance = 10940 }, -- Meat
	{ id = 7449, chance = 6670 }, -- Crystal Sword
	{ id = 9691, chance = 15676 }, -- Lion's Mane
	{ id = 22083, chance = 1635 }, -- Moonlight Crystals
	{ id = 3017, chance = 4845 }, -- Silver Brooch
	{ id = 3028, chance = 4366 }, -- Small Diamond
	{ id = 3279, chance = 3341 }, -- War Hammer
	{ id = 3379, chance = 2285 }, -- Doublet
	{ id = 3421, chance = 2875 }, -- Dark Shield
	{ id = 7413, chance = 1677 }, -- Titan Axe
	{ id = 7452, chance = 1361 }, -- Spiked Squelcher
	{ id = 7454, chance = 2765 }, -- Glorious Axe
	{ id = 8042, chance = 2203 }, -- Spirit Cloak
	{ id = 22193, chance = 2396 }, -- Onyx Chip
	{ id = 24391, chance = 1817 }, -- Coral Brooch
	{ id = 25737, chance = 2473 }, -- Rainbow Quartz
	{ id = 33945, chance = 3660 }, -- Ivory Carving
	{ id = 7456, chance = 912 }, -- Noble Axe
	{ id = 34008, chance = 545 }, -- White Silk Flower
	{ id = 33781, chance = 434 }, -- Lion Figurine
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
