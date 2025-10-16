local mType = Game.createMonsterType("Dragolisk")
local monster = {}

monster.description = "a dragolisk"
monster.experience = 5050
monster.outfit = {
	lookType = 1707,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2456
monster.Bestiary = {
	class = "Dragon",
	race = BESTY_RACE_DRAGON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 5,
	Occurrence = 0,
	Locations = "Nimmersatt's Breeding Ground",
}

monster.health = 6180
monster.maxHealth = 6180
monster.race = "blood"
monster.corpse = 44654
monster.speed = 165
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
	{ text = "Just Look at me!", yell = false },
	{ text = "I'll stare you down", yell = false },
	{ text = "Let me have a look", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 36 }, -- platinum coin
	{ id = 36706, chance = 23000 }, -- red gem
	{ id = 44743, chance = 23000 }, -- nimmersatts seal
	{ id = 44746, chance = 23000 }, -- dragolisk eye
	{ id = 44747, chance = 23000 }, -- dragolisk poison gland
	{ id = 3038, chance = 5000 }, -- green gem
	{ id = 7643, chance = 5000 }, -- ultimate health potion
	{ id = 11457, chance = 5000 }, -- dragons tail
	{ id = 23373, chance = 1000 }, -- ultimate mana potion
	{ id = 3416, chance = 260 }, -- dragon shield
	{ id = 48095, chance = 80000 }, -- dragolisk soul core
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{ name = "combat", interval = 3000, chance = 27, type = COMBAT_PHYSICALDAMAGE, minDamage = -220, maxDamage = -250, length = 7, spread = 0, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2500, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -250, radius = 4, effect = CONST_ME_POFF, target = true },
	{ name = "death chain", interval = 2500, chance = 20, minDamage = -250, maxDamage = -300, range = 7 },
}

monster.defenses = {
	defense = 86,
	armor = 86,
	mitigation = 2.11,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
