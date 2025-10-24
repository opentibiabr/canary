local mType = Game.createMonsterType("Lost Husher")
local monster = {}

monster.description = "a lost husher"
monster.experience = 1100
monster.outfit = {
	lookType = 537,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 924
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Caves of the Lost, Lower Spike and in the Lost Dwarf version of the Forsaken Mine.",
}

monster.health = 1600
monster.maxHealth = 1600
monster.race = "blood"
monster.corpse = 17684
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	targetDistance = 4,
	runHealth = 0,
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
	{ text = "Arr far zwar!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 59850, maxCount = 2 }, -- Platinum Coin
	{ id = 17856, chance = 5920 }, -- Basalt Fetish
	{ id = 17857, chance = 7720 }, -- Basalt Figurine
	{ id = 17831, chance = 7610 }, -- Bone Fetish
	{ id = 17830, chance = 8450 }, -- Bonecarving Knife
	{ id = 3725, chance = 15090, maxCount = 2 }, -- Brown Mushroom
	{ id = 12600, chance = 11890 }, -- Coal
	{ id = 238, chance = 10320, maxCount = 2 }, -- Great Mana Potion
	{ id = 17850, chance = 11650 }, -- Holy Ash
	{ id = 17848, chance = 9180 }, -- Lost Husher's Staff
	{ id = 17855, chance = 15390 }, -- Red Hair Dye
	{ id = 17849, chance = 9030 }, -- Skull Shatterer
	{ id = 9057, chance = 9830 }, -- Small Topaz
	{ id = 236, chance = 10480, maxCount = 3 }, -- Strong Health Potion
	{ id = 17847, chance = 12040 }, -- Wimp Tooth Chain
	{ id = 3097, chance = 2710 }, -- Dwarven Ring
	{ id = 17829, chance = 720 }, -- Buckle
	{ id = 3415, chance = 960 }, -- Guardian Shield
	{ id = 3318, chance = 780 }, -- Knight Axe
	{ id = 813, chance = 640 }, -- Terra Boots
	{ id = 10422, chance = 880 }, -- Clay Lump
	{ id = 3320, chance = 270 }, -- Fire Axe
	{ id = 3324, chance = 480 }, -- Skull Staff
	{ id = 7452, chance = 270 }, -- Spiked Squelcher
	{ id = 812, chance = 210 }, -- Terra Legs
	{ id = 3428, chance = 190 }, -- Tower Shield
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -300, length = 6, spread = 0, effect = CONST_ME_BLACKSMOKE, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -200, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -150, maxDamage = -250, range = 7, radius = 2, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_MAGIC_GREEN, target = true },
	{ name = "drunk", interval = 2000, chance = 10, radius = 4, effect = CONST_ME_SOUND_RED, target = false, duration = 6000 },
}

monster.defenses = {
	defense = 25,
	armor = 55,
	mitigation = 1.35,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 75, maxDamage = 92, effect = CONST_ME_YELLOWENERGY, target = false },
	{ name = "invisible", interval = 2000, chance = 15, effect = CONST_ME_TELEPORT },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
