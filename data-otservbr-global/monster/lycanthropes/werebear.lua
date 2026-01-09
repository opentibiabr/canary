local mType = Game.createMonsterType("Werebear")
local monster = {}

monster.description = "a werebear"
monster.experience = 2100
monster.outfit = {
	lookType = 720,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1142
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Grimvale underground, were-beasts cave south-west of Edron and in the Last Sanctum east of Cormaya.",
}

monster.health = 2400
monster.maxHealth = 2400
monster.race = "blood"
monster.corpse = 22010
monster.speed = 110
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
	runHealth = 275,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "GROOOWL", yell = true },
	{ text = "GRRR", yell = true },
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 3 }, -- Platinum Coin
	{ id = 3031, chance = 80544, maxCount = 100 }, -- Gold Coin
	{ id = 22057, chance = 15106 }, -- Werebear Fur
	{ id = 22056, chance = 14782 }, -- Werebear Skull
	{ id = 3582, chance = 12335, maxCount = 3 }, -- Ham
	{ id = 22083, chance = 960 }, -- Moonlight Crystals
	{ id = 239, chance = 5188 }, -- Great Health Potion
	{ id = 5896, chance = 2977 }, -- Bear Paw
	{ id = 5902, chance = 2724 }, -- Honeycomb
	{ id = 7643, chance = 1914 }, -- Ultimate Health Potion
	{ id = 675, chance = 1645 }, -- Small Enchanted Sapphire
	{ id = 22060, chance = 1220 }, -- Werewolf Amulet
	{ id = 7432, chance = 984 }, -- Furry Club
	{ id = 3081, chance = 1152 }, -- Stone Skin Amulet
	{ id = 7439, chance = 1001 }, -- Berserk Potion
	{ id = 22085, chance = 556 }, -- Fur Armor
	{ id = 3053, chance = 766 }, -- Time Ring
	{ id = 7452, chance = 489 }, -- Spiked Squelcher
	{ id = 7383, chance = 747 }, -- Relic Sword
	{ id = 22103, chance = 154 }, -- Werebear Trophy
	{ id = 7419, chance = 131 }, -- Dreaded Cleaver
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 50, maxDamage = -485 },
	{ name = "speed", interval = 4000, chance = 20, radius = 7, effect = CONST_ME_POFF, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -65, maxDamage = -335, radius = 4, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 38,
	mitigation = 0.91,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 45 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
