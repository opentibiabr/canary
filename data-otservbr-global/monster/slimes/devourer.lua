local mType = Game.createMonsterType("Devourer")
local monster = {}

monster.description = "a devourer"
monster.experience = 1755
monster.outfit = {
	lookType = 617,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1056
monster.Bestiary = {
	class = "Slime",
	race = BESTY_RACE_SLIME,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Rathleton Sewers, Lower Rathleton, Oramond/Western Plains, \z
		Underground Glooth Factory, Jaccus Maxxen's Dungeon.",
}

monster.health = 1900
monster.maxHealth = 1900
monster.race = "venom"
monster.corpse = 21113
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
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
	level = 4,
	color = 139,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "*gulp*", yell = false },
	{ text = "*Bruaarrr!*", yell = false },
	{ text = "*omnnommm nomm*", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 99000, maxCount = 165 }, -- Gold Coin
	{ id = 3035, chance = 56000, maxCount = 2 }, -- Platinum Coin
	{ id = 21182, chance = 13700 }, -- Glob of Glooth
	{ id = 3030, chance = 5700, maxCount = 3 }, -- Small Ruby
	{ id = 3029, chance = 5600, maxCount = 3 }, -- Small Sapphire
	{ id = 3032, chance = 5600, maxCount = 3 }, -- Small Emerald
	{ id = 3033, chance = 5500, maxCount = 3 }, -- Small Amethyst
	{ id = 9057, chance = 5500, maxCount = 3 }, -- Small Topaz
	{ id = 3028, chance = 5400, maxCount = 3 }, -- Small Diamond
	{ id = 21180, chance = 2800 }, -- Glooth Axe
	{ id = 21178, chance = 2700 }, -- Glooth Club
	{ id = 21179, chance = 2600 }, -- Glooth Blade
	{ id = 3034, chance = 2400 }, -- Talon
	{ id = 21158, chance = 1600 }, -- Glooth Spear
	{ id = 3037, chance = 1600 }, -- Yellow Gem
	{ id = 21183, chance = 950 }, -- Glooth Amulet
	{ id = 8084, chance = 940 }, -- Springsprout Rod
	{ id = 3065, chance = 700 }, -- Terra Rod
	{ id = 21164, chance = 280 }, -- Glooth Cape
	{ id = 3038, chance = 110 }, -- Green Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 62, attack = 50, condition = { type = CONDITION_POISON, totalDamage = 360, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -40, maxDamage = -125, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_EARTHDAMAGE, minDamage = -50, maxDamage = -160, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_GREEN_RINGS, target = true },
	{ name = "devourer wave", interval = 2000, chance = 5, minDamage = -50, maxDamage = -150, target = false },
	{ name = "devourer paralyze", interval = 2000, chance = 9, target = false },
	{ name = "combat", interval = 2000, chance = 11, type = COMBAT_EARTHDAMAGE, minDamage = -50, maxDamage = -150, length = 1, spread = 0, effect = CONST_ME_SMOKE, target = false },
	{ name = "combat", interval = 2000, chance = 7, type = COMBAT_EARTHDAMAGE, minDamage = -120, maxDamage = -135, radius = 4, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 45,
	mitigation = 1.46,
	{ name = "combat", interval = 2000, chance = 6, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
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
