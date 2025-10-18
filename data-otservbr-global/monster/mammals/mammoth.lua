local mType = Game.createMonsterType("Mammoth")
local monster = {}

monster.description = "a mammoth"
monster.experience = 160
monster.outfit = {
	lookType = 199,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 260
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Formorgar Glacier, Tyrsung, around the Barbarian Settlements, Mammoth Shearing Factory, Chyllfroest.",
}

monster.health = 320
monster.maxHealth = 320
monster.race = "blood"
monster.corpse = 6074
monster.speed = 95
monster.manaCost = 500

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
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Troooooot!", yell = false },
	{ text = "Hooooot-Toooooot!", yell = false },
	{ text = "Tooooot.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 85797, maxCount = 40 }, -- Gold Coin
	{ id = 3582, chance = 30846, maxCount = 3 }, -- Ham
	{ id = 10321, chance = 7654, maxCount = 2 }, -- Mammoth Tusk
	{ id = 3577, chance = 56270 }, -- Meat
	{ id = 10307, chance = 4498 }, -- Thick Fur
	{ id = 7381, chance = 2391 }, -- Mammoth Whopper
	{ id = 3443, chance = 328 }, -- Tusk Shield
	{ id = 7432, chance = 519 }, -- Furry Club
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -110 },
}

monster.defenses = {
	defense = 25,
	armor = 20,
	mitigation = 0.41,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
