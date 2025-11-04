local mType = Game.createMonsterType("Frost Dragon")
local monster = {}

monster.description = "a frost dragon"
monster.experience = 2100
monster.outfit = {
	lookType = 248,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 317
monster.Bestiary = {
	class = "Dragon",
	race = BESTY_RACE_DRAGON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Okolnir, Razachai, Ice Witch Temple, Frost Dragon Tunnel, \z
	Yakchal Crypt (only during Yakchals awakening ritual), Dragonblaze Peaks, Deeper Banuta, Chyllfroest.",
}

monster.health = 1800
monster.maxHealth = 1800
monster.race = "undead"
monster.corpse = 7091
monster.speed = 106
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 250,
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
	{ text = "YOU WILL FREEZE!", yell = true },
	{ text = "ZCHHHHH!", yell = true },
	{ text = "I am so cool.", yell = false },
	{ text = "Chill out!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 94990, maxCount = 243 }, -- Gold Coin
	{ id = 3583, chance = 71113, maxCount = 3 }, -- Dragon Ham
	{ id = 2842, chance = 8547 }, -- Book (Gemmed)
	{ id = 3450, chance = 16773, maxCount = 6 }, -- Power Bolt
	{ id = 3732, chance = 11729 }, -- Green Mushroom
	{ id = 2903, chance = 2872 }, -- Golden Mug
	{ id = 3029, chance = 5258 }, -- Small Sapphire
	{ id = 3051, chance = 4565 }, -- Energy Ring
	{ id = 7441, chance = 4401 }, -- Ice Cube
	{ id = 3061, chance = 400 }, -- Life Crystal
	{ id = 7290, chance = 555 }, -- Shard
	{ id = 3373, chance = 433 }, -- Strange Helmet
	{ id = 3284, chance = 179 }, -- Ice Rapier
	{ id = 3428, chance = 239 }, -- Tower Shield
	{ id = 3392, chance = 209 }, -- Royal Helmet
	{ id = 7402, chance = 137 }, -- Dragon Slayer
	{ id = 3386, chance = 181 }, -- Dragon Scale Mail
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -225 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -175, maxDamage = -380, length = 8, spread = 3, effect = CONST_ME_POFF, target = false },
	{ name = "speed", interval = 2000, chance = 5, speedChange = -700, radius = 3, effect = CONST_ME_POFF, target = false, duration = 12000 },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -850, length = 7, spread = 3, effect = CONST_ME_ICEATTACK, target = false, duration = 18000 },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_ICEDAMAGE, minDamage = -60, maxDamage = -120, radius = 3, effect = CONST_ME_ICETORNADO, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -240, radius = 4, effect = CONST_ME_ICEAREA, target = true },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -220, length = 1, spread = 3, effect = CONST_ME_POFF, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -600, radius = 4, effect = CONST_ME_ICEAREA, target = true, duration = 12000 },
}

monster.defenses = {
	defense = 45,
	armor = 38,
	mitigation = 1.07,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 290, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
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
