local mType = Game.createMonsterType("Bulltaur Brute")
local monster = {}

monster.description = "a Bulltaur Brute"
monster.experience = 4700
monster.outfit = {
	lookType = 1717,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 6560
monster.maxHealth = 6560
monster.race = "blood"
monster.corpse = 44709
monster.speed = 170
monster.manaCost = 0

monster.raceId = 2447
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Bulltaurs Lair",
}

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "It's hammer time!", yell = false },
	{ text = "I'll do some downsizing!", yell = false },
	{ text = "This will be a smash hit!!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 53314, maxCount = 33 }, -- Platinum Coin
	{ id = 9057, chance = 10235, maxCount = 3 }, -- Small Topaz
	{ id = 44736, chance = 16124 }, -- Bulltaur Horn
	{ id = 44737, chance = 9848 }, -- Bulltaur Hoof
	{ id = 44738, chance = 12460 }, -- Bulltaur Armor Scrap
	{ id = 3036, chance = 1169 }, -- Violet Gem
	{ id = 3097, chance = 2772 }, -- Dwarven Ring
	{ id = 21175, chance = 3042 }, -- Mino Shield
	{ id = 3040, chance = 720 }, -- Gold Nugget
	{ id = 3041, chance = 1269 }, -- Blue Gem
	{ id = 3048, chance = 1131 }, -- Might Ring
	{ id = 3322, chance = 918 }, -- Dragon Hammer
	{ id = 32769, chance = 580 }, -- White Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -170, maxDamage = -300 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -450, maxDamage = -600, range = 3, radius = 1, target = true, effect = CONST_ME_SLASH },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -500, range = 3, radius = 1, target = true, effect = CONST_ME_MORTAREA },
}

monster.defenses = {
	defense = 100,
	armor = 78,
	mitigation = 2.22,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "drunk", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
