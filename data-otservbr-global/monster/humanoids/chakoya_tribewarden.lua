local mType = Game.createMonsterType("Chakoya Tribewarden")
local monster = {}

monster.description = "a chakoya tribewarden"
monster.experience = 40
monster.outfit = {
	lookType = 249,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 319
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Inukaya, Chyllfroest, Chakoya Iceberg, Nibelor (during a quest).",
}

monster.health = 68
monster.maxHealth = 68
monster.race = "blood"
monster.corpse = 7320
monster.speed = 62
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
	{ text = "Quisavu tukavi!", yell = false },
	{ text = "Si siyoqua jamjam!", yell = false },
	{ text = "Achuq! jinuma!", yell = false },
	{ text = "Si ji jusipa!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 65660, maxCount = 20 }, -- Gold Coin
	{ id = 3578, chance = 22275 }, -- Fish
	{ id = 3294, chance = 4737 }, -- Short Sword
	{ id = 20356, chance = 500 }, -- Fireproof Horn
	{ id = 3441, chance = 1429 }, -- Bone Shield
	{ id = 7159, chance = 181 }, -- Green Perch
	{ id = 7381, chance = 197 }, -- Mammoth Whopper
	{ id = 7158, chance = 127 }, -- Rainbow Trout
	{ id = 3580, chance = 88 }, -- Northern Pike
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -30 },
}

monster.defenses = {
	defense = 10,
	armor = 9,
	mitigation = 0.33,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
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
