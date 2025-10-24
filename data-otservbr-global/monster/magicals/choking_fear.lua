local mType = Game.createMonsterType("Choking Fear")
local monster = {}

monster.description = "a choking fear"
monster.experience = 4700
monster.outfit = {
	lookType = 586,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1015
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "All over the surface of Upper Roshamuul and Nightmare Isles.",
}

monster.health = 5800
monster.maxHealth = 5800
monster.race = "undead"
monster.corpse = 20159
monster.speed = 190
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 5,
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
	{ text = "Ah, sweet air... don't you miss it?", yell = false },
	{ text = "Murr tat muuza!", yell = false },
	{ text = "kchh", yell = false },
	{ text = "hsssss", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 91373, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 96245, maxCount = 8 }, -- Platinum Coin
	{ id = 16123, chance = 44653, maxCount = 2 }, -- Brown Crystal Splinter
	{ id = 7642, chance = 18276, maxCount = 3 }, -- Great Spirit Potion
	{ id = 238, chance = 18595, maxCount = 3 }, -- Great Mana Potion
	{ id = 7643, chance = 17992, maxCount = 3 }, -- Ultimate Health Potion
	{ id = 20202, chance = 13578 }, -- Dead Weight
	{ id = 20206, chance = 14056 }, -- Hemp Rope
	{ id = 16124, chance = 9153, maxCount = 3 }, -- Blue Crystal Splinter
	{ id = 5913, chance = 4543 }, -- Brown Piece of Cloth
	{ id = 3052, chance = 4468 }, -- Life Ring
	{ id = 3344, chance = 3363 }, -- Beastslayer Axe
	{ id = 5914, chance = 2618 }, -- Yellow Piece of Cloth
	{ id = 3051, chance = 2785 }, -- Energy Ring
	{ id = 3098, chance = 3267 }, -- Ring of Healing
	{ id = 3415, chance = 1408 }, -- Guardian Shield
	{ id = 16121, chance = 1388 }, -- Green Crystal Shard
	{ id = 7451, chance = 902 }, -- Shadow Sceptre
	{ id = 5911, chance = 1060 }, -- Red Piece of Cloth
	{ id = 8074, chance = 706 }, -- Spellbook of Mind Control
	{ id = 10389, chance = 540 }, -- Traditional Sai
	{ id = 813, chance = 444 }, -- Terra Boots
	{ id = 8082, chance = 637 }, -- Underworld Rod
	{ id = 8084, chance = 589 }, -- Springsprout Rod
	{ id = 20062, chance = 453 }, -- Cluster of Solace
	{ id = 811, chance = 469 }, -- Terra Mantle
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -499, condition = { type = CONDITION_POISON, totalDamage = 600, interval = 4000 } },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -700, maxDamage = -900, length = 5, spread = 0, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -300, radius = 1, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_SLEEP, target = true },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -800, radius = 1, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_SLEEP, target = true, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -130, maxDamage = -300, radius = 4, effect = CONST_ME_SOUND_RED, target = false },
	{ name = "choking fear drown", interval = 2000, chance = 20, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -250, maxDamage = -500, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 35,
	armor = 65,
	mitigation = 1.94,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 80, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 2 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 55 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
