local mType = Game.createMonsterType("Chakoya Toolshaper")
local monster = {}

monster.description = "a chakoya toolshaper"
monster.experience = 40
monster.outfit = {
	lookType = 259,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 328
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Inukaya, Chyllfroest, Chakoya Iceberg.",
}

monster.health = 80
monster.maxHealth = 80
monster.race = "blood"
monster.corpse = 7320
monster.speed = 68
monster.manaCost = 305

monster.changeTarget = {
	interval = 60000,
	chance = 0,
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
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 80,
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
	{ text = "Chikuva!", yell = false },
	{ text = "Jinuma jamjam!", yell = false },
	{ text = "Suvituka siq chuqua!", yell = false },
	{ text = "Kiyosa sipaju!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 78195, maxCount = 20 }, -- Gold Coin
	{ id = 3578, chance = 31161, maxCount = 2 }, -- Fish
	{ id = 3286, chance = 4584 }, -- Mace
	{ id = 20356, chance = 460 }, -- Fireproof Horn
	{ id = 3441, chance = 705 }, -- Bone Shield
	{ id = 7441, chance = 527 }, -- Ice Cube
	{ id = 3456, chance = 1127 }, -- Pick
	{ id = 7159, chance = 90 }, -- Green Perch
	{ id = 7381, chance = 145 }, -- Mammoth Whopper
	{ id = 3580, chance = 95 }, -- Northern Pike
	{ id = 7158, chance = 121 }, -- Rainbow Trout
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -35 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -45, range = 7, radius = 1, shootEffect = CONST_ANI_SMALLSTONE, target = true },
}

monster.defenses = {
	defense = 10,
	armor = 7,
	mitigation = 0.23,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
