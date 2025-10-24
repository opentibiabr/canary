local mType = Game.createMonsterType("Lost Exile")
local monster = {}

monster.description = "a lost exile"
monster.experience = 1800
monster.outfit = {
	lookType = 537,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"LastExileDeath",
}

monster.raceId = 1529
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "South east of the Gnome Deep Hub's entrance.",
}

monster.health = 1600
monster.maxHealth = 1600
monster.race = "blood"
monster.corpse = 17684
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "**", yell = false },
	{ text = "**", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 59500, maxCount = 2 }, -- Platinum Coin
	{ id = 17847, chance = 12950 }, -- Wimp Tooth Chain
	{ id = 12600, chance = 12400 }, -- Coal
	{ id = 236, chance = 9760, maxCount = 3 }, -- Strong Health Potion
	{ id = 3725, chance = 14430, maxCount = 2 }, -- Brown Mushroom
	{ id = 17850, chance = 12240 }, -- Holy Ash
	{ id = 17855, chance = 14950 }, -- Red Hair Dye
	{ id = 17856, chance = 6240 }, -- Basalt Fetish
	{ id = 9057, chance = 10320 }, -- Small Topaz
	{ id = 17830, chance = 9760 }, -- Bonecarving Knife
	{ id = 17857, chance = 7680 }, -- Basalt Figurine
	{ id = 17848, chance = 9440 }, -- Lost Husher's Staff
	{ id = 238, chance = 10080, maxCount = 2 }, -- Great Mana Potion
	{ id = 17831, chance = 9240 }, -- Bone Fetish
	{ id = 17849, chance = 8119 }, -- Skull Shatterer
	{ id = 3097, chance = 2320 }, -- Dwarven Ring
	{ id = 3415, chance = 920 }, -- Guardian Shield
	{ id = 17829, chance = 880 }, -- Buckle
	{ id = 10422, chance = 640 }, -- Clay Lump
	{ id = 3318, chance = 1200 }, -- Knight Axe
	{ id = 813, chance = 760 }, -- Terra Boots
	{ id = 27653, chance = 480 }, -- Suspicious Device
	{ id = 3428, chance = 120 }, -- Tower Shield
	{ id = 812, chance = 240 }, -- Terra Legs
	{ id = 3320, chance = 320 }, -- Fire Axe
	{ id = 3324, chance = 520 }, -- Skull Staff
	{ id = 7452, chance = 160 }, -- Spiked Squelcher
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -120 },
	{ name = "sudden death rune", interval = 2000, chance = 15, minDamage = -150, maxDamage = -350, range = 3, length = 6, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -150, maxDamage = -250, range = 3, length = 5, spread = 5, effect = CONST_ME_SMOKE, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -150, maxDamage = -290, range = 3, length = 5, spread = 5, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_POISONAREA, target = false },
	{ name = "sudden death rune", interval = 2000, chance = 15, minDamage = -70, maxDamage = -250, range = 7, target = false },
	{ name = "drunk", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_ENERGY, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 0, maxDamage = 160, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
