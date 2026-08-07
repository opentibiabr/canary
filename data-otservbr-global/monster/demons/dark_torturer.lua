local mType = Game.createMonsterType("Dark Torturer")
local monster = {}

monster.description = "a dark torturer"
monster.experience = 4650
monster.outfit = {
	lookType = 234,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 285
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Pits of Inferno, Vengoth, The Inquisition Quest's Blood Halls, Oramond Dungeon, \z
	Oramond Fury Dungeon, Roshamuul Prison, Grounds of Damnation and Halls of Ascension.",
}

monster.health = 7350
monster.maxHealth = 7350
monster.race = "undead"
monster.corpse = 6327
monster.speed = 185
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
	staticAttackChance = 80,
	targetDistance = 1,
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
	{ text = "You like it, don't you?", yell = false },
	{ text = "IahaEhheAie!", yell = false },
	{ text = "It's party time!", yell = false },
	{ text = "Harrr, Harrr!", yell = false },
	{ text = "The torturer is in!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 198 }, -- Gold Coin
	{ id = 3582, chance = 65000, maxCount = 2 }, -- Ham
	{ id = 3035, chance = 58000, maxCount = 8 }, -- Platinum Coin
	{ id = 6558, chance = 35000, maxCount = 3 }, -- Flask of Demonic Blood
	{ id = 5944, chance = 25000 }, -- Soul Orb
	{ id = 238, chance = 15200, maxCount = 2 }, -- Great Mana Potion
	{ id = 239, chance = 10100, maxCount = 2 }, -- Great Health Potion
	{ id = 6499, chance = 9300 }, -- Demonic Essence
	{ id = 3461, chance = 5000 }, -- Saw
	{ id = 3554, chance = 3900 }, -- Steel Boots
	{ id = 9058, chance = 3100 }, -- Gold Ingot
	{ id = 5021, chance = 2900, maxCount = 2 }, -- Orichalcum Pearl
	{ id = 7368, chance = 2100, maxCount = 5 }, -- Assassin Star
	{ id = 5479, chance = 2000 }, -- Cat's Paw
	{ id = 6299, chance = 1700 }, -- Death Ring
	{ id = 5801, chance = 850 }, -- Jewelled Backpack
	{ id = 7412, chance = 790 }, -- Butcher's Axe
	{ id = 7388, chance = 350 }, -- Vile Axe
	{ id = 3364, chance = 39 }, -- Golden Legs
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -781, range = 7, shootEffect = CONST_ANI_THROWINGKNIFE, target = false },
	{ name = "dark torturer skill reducer", interval = 2000, chance = 5, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 45,
	mitigation = 1.74,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 90 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
