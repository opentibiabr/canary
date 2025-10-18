local mType = Game.createMonsterType("Thanatursus")
local monster = {}

monster.description = "a thanatursus"
monster.experience = 6300
monster.outfit = {
	lookType = 1134,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1728
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Haunted Temple, Court of Winter, Dream Labyrinth.",
}

monster.health = 7200
monster.maxHealth = 7200
monster.race = "blood"
monster.corpse = 30069
monster.speed = 200
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
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Uuuuuuuuuaaaaaarg!!!", yell = false },
	{ text = "Nobody will ever escape from this place, muwahaha!!!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 12 }, -- Platinum Coin
	{ id = 3577, chance = 50008, maxCount = 3 }, -- Meat
	{ id = 3582, chance = 15543 }, -- Ham
	{ id = 10306, chance = 12539, maxCount = 6 }, -- Essence of a Bad Dream
	{ id = 3269, chance = 12260 }, -- Halberd
	{ id = 813, chance = 9590 }, -- Terra Boots
	{ id = 7643, chance = 8570 }, -- Ultimate Health Potion
	{ id = 830, chance = 6290 }, -- Terra Hood
	{ id = 7642, chance = 6584, maxCount = 3 }, -- Great Spirit Potion
	{ id = 3318, chance = 5554 }, -- Knight Axe
	{ id = 21175, chance = 5040 }, -- Mino Shield
	{ id = 3421, chance = 3670 }, -- Dark Shield
	{ id = 3073, chance = 4190 }, -- Wand of Cosmic Energy
	{ id = 3344, chance = 4192 }, -- Beastslayer Axe
	{ id = 3293, chance = 2860 }, -- Sickle
	{ id = 3429, chance = 2930 }, -- Black Shield
	{ id = 14042, chance = 3053 }, -- Warrior's Shield
	{ id = 3313, chance = 2580 }, -- Obsidian Lance
	{ id = 9633, chance = 1870 }, -- Bloody Pincers
	{ id = 7413, chance = 1630 }, -- Titan Axe
	{ id = 16096, chance = 1600 }, -- Wand of Defiance
	{ id = 14040, chance = 1954 }, -- Warrior's Axe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -450 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -250, maxDamage = -400, radius = 3, effect = CONST_ME_HOLYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -280, maxDamage = -450, length = 4, spread = 0, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -400, radius = 6, effect = CONST_ME_BLOCKHIT, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 78,
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_HEALING, minDamage = 150, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
