local mType = Game.createMonsterType("Defiler")
local monster = {}

monster.description = "a defiler"
monster.experience = 3700
monster.outfit = {
	lookType = 238,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 289
monster.Bestiary = {
	class = "Slime",
	race = BESTY_RACE_SLIME,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Pits of Inferno, The Inquisition Quest (The Vats) and Grounds of Plague.",
}

monster.health = 3650
monster.maxHealth = 3650
monster.race = "venom"
monster.corpse = 6532
monster.speed = 80
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
	runHealth = 85,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 3,
	color = 30,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Blubb", yell = false },
	{ text = "Blubb Blubb", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 272 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 6 }, -- platinum coin
	{ id = 6499, chance = 23000 }, -- demonic essence
	{ id = 9054, chance = 23000 }, -- glob of acid slime
	{ id = 9055, chance = 23000 }, -- glob of tar
	{ id = 3032, chance = 23000, maxCount = 3 }, -- small emerald
	{ id = 5944, chance = 23000 }, -- soul orb
	{ id = 3028, chance = 5000, maxCount = 2 }, -- small diamond
	{ id = 3030, chance = 5000, maxCount = 2 }, -- small ruby
	{ id = 3034, chance = 5000 }, -- talon
	{ id = 6299, chance = 5000 }, -- death ring
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ id = 36706, chance = 5000 }, -- red gem
	{ id = 3041, chance = 1000 }, -- blue gem
	{ id = 3038, chance = 1000 }, -- green gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -240, condition = { type = CONDITION_POISON, totalDamage = 150, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -160, maxDamage = -270, range = 7, shootEffect = CONST_ANI_POISON, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -400, maxDamage = -640, range = 7, radius = 7, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -120, maxDamage = -170, radius = 3, effect = CONST_ME_POISONAREA, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -500, maxDamage = -1000, length = 8, spread = 3, effect = CONST_ME_SMALLPLANTS, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -700, length = 8, spread = 3, effect = CONST_ME_SMALLCLOUDS, target = false, duration = 15000 },
}

monster.defenses = {
	defense = 20,
	armor = 60,
	mitigation = 1.32,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 280, maxDamage = 350, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
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
