local mType = Game.createMonsterType("Rhindeer")
local monster = {}

monster.description = "a rhindeer"
monster.experience = 5600
monster.outfit = {
	lookType = 1606,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2342
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Ingol",
}

monster.health = 8650
monster.maxHealth = 8650
monster.race = "blood"
monster.corpse = 42230
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 200,
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
	{ text = "Harrumph!!", yell = false },
	{ text = "Destroy!", yell = false },
	{ text = "Snort!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 76586 }, -- Platinum Coin
	{ id = 3036, chance = 5342 }, -- Violet Gem
	{ id = 16123, chance = 10005 }, -- Brown Crystal Splinter
	{ id = 25737, chance = 6166 }, -- Rainbow Quartz
	{ id = 40587, chance = 5636 }, -- Rhindeer Antlers
	{ id = 238, chance = 3721 }, -- Great Mana Potion
	{ id = 3037, chance = 2023 }, -- Yellow Gem
	{ id = 3370, chance = 1286 }, -- Knight Armor
	{ id = 7413, chance = 2329 }, -- Titan Axe
	{ id = 3053, chance = 706 }, -- Time Ring
	{ id = 3340, chance = 709 }, -- Heavy Mace
	{ id = 3414, chance = 671 }, -- Mastermind Shield
	{ id = 23543, chance = 937 }, -- Collar of Green Plasma
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -471 },
	{ name = "combat", interval = 2000, chance = 20, minDamage = -265, maxDamage = -415, range = 3, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = true },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -325, maxDamage = -400, range = 7, shootEffect = CONST_ANI_POISONARROW, target = true },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -265, maxDamage = -411, range = 1, radius = 4, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -300, range = 2, effect = CONST_ME_GROUNDSHAKER, target = true },
}

monster.defenses = {
	defense = 50,
	armor = 68,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
