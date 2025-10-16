local mType = Game.createMonsterType("Ripper Spectre")
local monster = {}

monster.description = "a ripper spectre"
monster.experience = 3500
monster.outfit = {
	lookType = 1122,
	lookHead = 81,
	lookBody = 78,
	lookLegs = 61,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1724
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Haunted Cellar, Buried Cathedral",
}

monster.health = 3800
monster.maxHealth = 3800
monster.race = "blood"
monster.corpse = 30026
monster.speed = 190
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 4 }, -- platinum coin
	{ id = 7642, chance = 23000, maxCount = 2 }, -- great spirit potion
	{ id = 3265, chance = 23000 }, -- two handed sword
	{ id = 3065, chance = 23000 }, -- terra rod
	{ id = 3017, chance = 23000 }, -- silver brooch
	{ id = 3010, chance = 5000 }, -- emerald bangle
	{ id = 10392, chance = 5000 }, -- twin hooks
	{ id = 8084, chance = 5000 }, -- springsprout rod
	{ id = 30204, chance = 5000 }, -- green ectoplasm
	{ id = 3297, chance = 1000 }, -- serpent sword
	{ id = 24391, chance = 5000 }, -- coral brooch
	{ id = 30180, chance = 1000 }, -- hexagonal ruby
	{ id = 7404, chance = 1000 }, -- assassin dagger
	{ id = 3271, chance = 260 }, -- spike sword
	{ id = 7408, chance = 260 }, -- wyvern fang
	{ id = 3081, chance = 260 }, -- stone skin amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -370 },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -425, radius = 4, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "combat", interval = 2800, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -450, radius = 3, effect = CONST_ME_DRAWBLOOD, target = false },
	{ name = "combat", interval = 3500, chance = 37, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -375, length = 3, spread = 2, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 69,
	armor = 69,
	mitigation = 1.91,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.reflects = {
	{ type = COMBAT_EARTHDAMAGE, percent = 133 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 70 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
