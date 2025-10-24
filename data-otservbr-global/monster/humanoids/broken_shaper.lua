local mType = Game.createMonsterType("Broken Shaper")
local monster = {}

monster.description = "a broken shaper"
monster.experience = 1800
monster.outfit = {
	lookType = 932,
	lookHead = 94,
	lookBody = 76,
	lookLegs = 0,
	lookFeet = 82,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1321
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Astral Shaper Dungeon, Astral Shaper Ruins, Old Masonry",
}

monster.health = 2200
monster.maxHealth = 2200
monster.race = "blood"
monster.corpse = 25068
monster.speed = 155
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "<grunt>", yell = false },
	{ text = "Raar!!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 173 }, -- Gold Coin
	{ id = 3035, chance = 75270, maxCount = 2 }, -- Platinum Coin
	{ id = 24383, chance = 20240, maxCount = 2 }, -- Cave Turnip
	{ id = 24384, chance = 17640 }, -- Ancient Belt Buckle
	{ id = 24385, chance = 19890 }, -- Cracked Alabaster Vase
	{ id = 24386, chance = 14000 }, -- Rhino Horn Carving
	{ id = 3577, chance = 9770 }, -- Meat
	{ id = 3147, chance = 8230 }, -- Blank Rune
	{ id = 3725, chance = 6050, maxCount = 2 }, -- Brown Mushroom
	{ id = 239, chance = 7060 }, -- Great Health Potion
	{ id = 3029, chance = 5020 }, -- Small Sapphire
	{ id = 5913, chance = 4680 }, -- Brown Piece of Cloth
	{ id = 22193, chance = 4380 }, -- Onyx Chip
	{ id = 5021, chance = 4930, maxCount = 3 }, -- Orichalcum Pearl
	{ id = 24390, chance = 4430 }, -- Ancient Coin
	{ id = 3030, chance = 4070 }, -- Small Ruby
	{ id = 3098, chance = 2600 }, -- Ring of Healing
	{ id = 5914, chance = 2040 }, -- Yellow Piece of Cloth
	{ id = 24391, chance = 1580 }, -- Coral Brooch
	{ id = 8895, chance = 2850 }, -- Rusted Armor
	{ id = 3284, chance = 1190 }, -- Ice Rapier
	{ id = 5912, chance = 1030 }, -- Blue Piece of Cloth
	{ id = 3046, chance = 989 }, -- Magic Light Wand
	{ id = 5911, chance = 500 }, -- Red Piece of Cloth
	{ id = 5909, chance = 980 }, -- White Piece of Cloth
	{ id = 5910, chance = 610 }, -- Green Piece of Cloth
	{ id = 3079, chance = 210 }, -- Boots of Haste
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -150, range = 7, shootEffect = CONST_ANI_SMALLSTONE, target = true },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -100, length = 5, spread = 0, effect = CONST_ME_SOUND_RED, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 37,
	mitigation = 1.46,
	{ name = "speed", interval = 2000, chance = 10, speedChange = 336, effect = CONST_ME_MAGIC_RED, target = false, duration = 2000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 0, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
