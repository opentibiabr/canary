local mType = Game.createMonsterType("Roaring Lion")
local monster = {}

monster.description = "a roaring lion"
monster.experience = 800
monster.outfit = {
	lookType = 570,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 981
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Lion's Rock a few floors down.",
}

monster.health = 1000
monster.maxHealth = 1000
monster.race = "blood"
monster.corpse = 19103
monster.speed = 105
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Groarrrr! Rwarrrr!", yell = false },
	{ text = "Growl!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 115 }, -- gold coin
	{ id = 3577, chance = 80000, maxCount = 4 }, -- meat
	{ id = 3582, chance = 80000 }, -- ham
	{ id = 3035, chance = 23000 }, -- platinum coin
	{ id = 9691, chance = 23000 }, -- lions mane
	{ id = 9057, chance = 23000 }, -- small topaz
	{ id = 3033, chance = 23000 }, -- small amethyst
	{ id = 3030, chance = 23000 }, -- small ruby
	{ id = 3029, chance = 23000 }, -- small sapphire
	{ id = 3077, chance = 5000 }, -- ankh
	{ id = 3048, chance = 1000 }, -- might ring
	{ id = 3385, chance = 1000 }, -- crown helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 60, attack = 40 },
}

monster.defenses = {
	defense = 28,
	armor = 28,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
