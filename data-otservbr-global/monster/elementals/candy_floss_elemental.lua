local mType = Game.createMonsterType("Candy Floss Elemental")
local monster = {}

monster.description = "a candy floss elemental"
monster.experience = 3850
monster.outfit = {
	lookType = 1749,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2533
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Dessert Dungeons.",
}

monster.health = 3700
monster.maxHealth = 3700
monster.race = "undead"
monster.corpse = 48345
monster.speed = 105
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
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
	{ text = "Come into my fluffy embrace!", yell = false },
	{ text = "Want fairy floss? I will feed you up.", yell = false },
	{ text = "Did you have to come here, little one? I just wanted to lay around and take it easy.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 149 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 11 }, -- platinum coin
	{ id = 25694, chance = 23000 }, -- fairy wings
	{ id = 3036, chance = 5000 }, -- violet gem
	{ id = 16120, chance = 5000 }, -- violet crystal shard
	{ id = 22194, chance = 5000 }, -- opal
	{ id = 23535, chance = 5000 }, -- energy bar
	{ id = 25737, chance = 5000, maxCount = 2 }, -- rainbow quartz
	{ id = 48116, chance = 5000, maxCount = 3 }, -- gummy rotworm
	{ id = 48544, chance = 5000 }, -- wad of fairy floss
	{ id = 8084, chance = 1000 }, -- springsprout rod
	{ id = 3054, chance = 260 }, -- silver amulet
	{ id = 3093, chance = 260 }, -- club ring
	{ id = 48249, chance = 260, maxCount = 10 }, -- milk chocolate coin
	{ id = 3048, chance = 80000 }, -- might ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -150, maxDamage = -250, range = 7, shootEffect = CONST_ANI_CHERRYBOMB, effect = CONST_ME_STARBURST, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -160, maxDamage = -300, range = 6, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -160, maxDamage = -300, range = 6, radius = 2, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_PIXIE_EXPLOSION, target = true },
}

monster.defenses = {
	defense = 45,
	armor = 45,
	mitigation = 1.26,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 40 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
