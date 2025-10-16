local mType = Game.createMonsterType("Crystal Spider")
local monster = {}

monster.description = "a crystal spider"
monster.experience = 900
monster.outfit = {
	lookType = 263,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 330
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Atop of the Formorgar Glacier and deep inside Formorgar Mines, Frost Dragon Tunnel, \z
	Ice Witch Temple, Nibelor Ice Cave, the Crystal Caves in The Inquisition Quest, Mushroom Gardens, \z
	Crystal Gardens.",
}

monster.health = 1250
monster.maxHealth = 1250
monster.race = "venom"
monster.corpse = 7344
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 20,
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
	canPushCreatures = false,
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
	{ text = "Screeech!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 197 }, -- gold coin
	{ id = 237, chance = 23000 }, -- strong mana potion
	{ id = 3357, chance = 23000 }, -- plate armor
	{ id = 7364, chance = 23000, maxCount = 6 }, -- sniper arrow
	{ id = 6093, chance = 5000 }, -- crystal ring
	{ id = 3008, chance = 5000 }, -- crystal necklace
	{ id = 3053, chance = 5000 }, -- time ring
	{ id = 3351, chance = 5000 }, -- steel helmet
	{ id = 5879, chance = 5000 }, -- spider silk
	{ id = 7741, chance = 5000 }, -- ice cube
	{ id = 7449, chance = 5000 }, -- crystal sword
	{ id = 829, chance = 1000 }, -- glacier mask
	{ id = 3370, chance = 1000 }, -- knight armor
	{ id = 3371, chance = 1000 }, -- knight legs
	{ id = 7290, chance = 1000 }, -- shard
	{ id = 5801, chance = 260 }, -- jewelled backpack
	{ id = 3055, chance = 260 }, -- platinum amulet
	{ id = 7437, chance = 260 }, -- sapphire hammer
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250, condition = { type = CONDITION_POISON, totalDamage = 160, interval = 4000 } },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -800, range = 7, radius = 6, effect = CONST_ME_POFF, target = false, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -50, maxDamage = -100, range = 7, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = true },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -600, range = 7, shootEffect = CONST_ANI_SNOWBALL, target = true, duration = 10000 },
}

monster.defenses = {
	defense = 0,
	armor = 43,
	mitigation = 1.60,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 250, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
