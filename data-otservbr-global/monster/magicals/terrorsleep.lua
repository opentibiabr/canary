local mType = Game.createMonsterType("Terrorsleep")
local monster = {}

monster.description = "a terrorsleep"
monster.experience = 6900
monster.outfit = {
	lookType = 587,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1016
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Roshamuul Mines, Roshamuul Cistern.",
}

monster.health = 7200
monster.maxHealth = 7200
monster.race = "blood"
monster.corpse = 20163
monster.speed = 180
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
	canWalkOnEnergy = false,
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
	{ text = "Aktat Roshok! Marruk!", yell = false },
	{ text = "I will eat you in your sleep.", yell = false },
	{ text = "I am the darkness around you...", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 189 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 238, chance = 33000, maxCount = 2 }, -- Great Mana Potion
	{ id = 7643, chance = 21000 }, -- Ultimate Health Potion
	{ id = 3033, chance = 18300, maxCount = 3 }, -- Small Amethyst
	{ id = 9057, chance = 14800, maxCount = 3 }, -- Small Topaz
	{ id = 20204, chance = 14100 }, -- Bowl of Terror Sweat
	{ id = 16125, chance = 14100 }, -- Cyan Crystal Fragment
	{ id = 20203, chance = 14100 }, -- Trapped Bad Dream Monster
	{ id = 16124, chance = 13600 }, -- Blue Crystal Splinter
	{ id = 3030, chance = 13300, maxCount = 3 }, -- Small Ruby
	{ id = 3032, chance = 11100, maxCount = 3 }, -- Small Emerald
	{ id = 16119, chance = 8300 }, -- Blue Crystal Shard
	{ id = 5912, chance = 5000 }, -- Blue Piece of Cloth
	{ id = 3370, chance = 3300 }, -- Knight Armor
	{ id = 5909, chance = 2800 }, -- White Piece of Cloth
	{ id = 3567, chance = 2300 }, -- Blue Robe
	{ id = 5895, chance = 2300 }, -- Fish Fin
	{ id = 50152, chance = 2000 }, -- Collar of Orange Plasma
	{ id = 3369, chance = 1800 }, -- Warrior Helmet
	{ id = 20029, chance = 1500 }, -- Broken Dream
	{ id = 3281, chance = 1300 }, -- Giant Sword
	{ id = 20062, chance = 1000 }, -- Cluster of Solace
	{ id = 5911, chance = 1000 }, -- Red Piece of Cloth
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 20, minDamage = -1000, maxDamage = -1500, radius = 7, effect = CONST_ME_YELLOW_RINGS, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -100, maxDamage = -300, radius = 5, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "feversleep skill reducer", interval = 2000, chance = 7, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -350, maxDamage = -500, length = 6, spread = 0, effect = CONST_ME_YELLOWENERGY, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -450, radius = 1, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 50,
	armor = 50,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 300, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
	-- { name = "invisible", interval = 2000, chance = 15, effect = CONST_ME_HITAREA },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 300, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 55 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
