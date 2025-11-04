local mType = Game.createMonsterType("Juggernaut")
local monster = {}

monster.description = "a juggernaut"
monster.experience = 11200
monster.outfit = {
	lookType = 244,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 296
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Deep in Pits of Inferno (Apocalypse's throne room), The Dark Path, The Blood Halls, \z
	The Vats, The Hive, The Shadow Nexus, a room deep in Formorgar Mines, Roshamuul Prison, \z
	Oramond Dungeon, Grounds of Destruction and Halls of Ascension.",
}

monster.health = 18000
monster.maxHealth = 18000
monster.race = "blood"
monster.corpse = 6335
monster.speed = 170
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
	staticAttackChance = 60,
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
	{ text = "RAAARRR!", yell = true },
	{ text = "GRRRRRR!", yell = true },
	{ text = "WAHHHH!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 95209, maxCount = 194 }, -- Gold Coin
	{ id = 3035, chance = 74483, maxCount = 15 }, -- Platinum Coin
	{ id = 3582, chance = 61425, maxCount = 8 }, -- Ham
	{ id = 6499, chance = 41040 }, -- Demonic Essence
	{ id = 5944, chance = 30096 }, -- Soul Orb
	{ id = 238, chance = 23034, maxCount = 3 }, -- Great Mana Potion
	{ id = 239, chance = 22917, maxCount = 3 }, -- Great Health Potion
	{ id = 7365, chance = 10932, maxCount = 15 }, -- Onyx Arrow
	{ id = 7368, chance = 16469, maxCount = 10 }, -- Assassin Star
	{ id = 6558, chance = 30201, maxCount = 4 }, -- Flask of Demonic Blood
	{ id = 9057, chance = 15516, maxCount = 5 }, -- Small Topaz
	{ id = 3030, chance = 17143, maxCount = 5 }, -- Small Ruby
	{ id = 3033, chance = 15284, maxCount = 5 }, -- Small Amethyst
	{ id = 3032, chance = 17300, maxCount = 5 }, -- Small Emerald
	{ id = 3028, chance = 16394, maxCount = 5 }, -- Small Diamond
	{ id = 281, chance = 7826 }, -- Giant Shimmering Pearl (Green)
	{ id = 3039, chance = 12146 }, -- Red Gem
	{ id = 9058, chance = 6072, maxCount = 2 }, -- Gold Ingot
	{ id = 7452, chance = 4522 }, -- Spiked Squelcher
	{ id = 7413, chance = 5897 }, -- Titan Axe
	{ id = 3370, chance = 5021 }, -- Knight Armor
	{ id = 3038, chance = 2633 }, -- Green Gem
	{ id = 3342, chance = 1986 }, -- War Axe
	{ id = 3036, chance = 1279 }, -- Violet Gem
	{ id = 3360, chance = 590 }, -- Golden Armor
	{ id = 3414, chance = 502 }, -- Mastermind Shield
	{ id = 3019, chance = 455 }, -- Demonbone Amulet
	{ id = 3481, chance = 348 }, -- Closed Trap
	{ id = 3340, chance = 342 }, -- Heavy Mace
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1470 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -780, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 70,
	mitigation = 1.74,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 520, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 400, maxDamage = 900, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
