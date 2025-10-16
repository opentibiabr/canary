local mType = Game.createMonsterType("Feral Sphinx")
local monster = {}

monster.description = "a feral sphinx"
monster.experience = 8800
monster.outfit = {
	lookType = 1188,
	lookHead = 76,
	lookBody = 75,
	lookLegs = 57,
	lookFeet = 0,
	lookAddons = 2,
	lookMount = 0,
}

monster.raceId = 1807
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Kilmaresh, south of Issavi.",
}

monster.health = 9800
monster.maxHealth = 9800
monster.race = "blood"
monster.corpse = 31658
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
	{ text = "I am not as kind as my sisters!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 3 }, -- platinum coin
	{ id = 31437, chance = 23000 }, -- sphinx feather
	{ id = 3085, chance = 23000 }, -- dragon necklace
	{ id = 817, chance = 23000 }, -- magma amulet
	{ id = 3071, chance = 23000 }, -- wand of inferno
	{ id = 3029, chance = 23000 }, -- small sapphire
	{ id = 36706, chance = 23000 }, -- red gem
	{ id = 16121, chance = 23000 }, -- green crystal shard
	{ id = 16125, chance = 23000 }, -- cyan crystal fragment
	{ id = 818, chance = 5000 }, -- magma boots
	{ id = 821, chance = 5000 }, -- magma legs
	{ id = 3320, chance = 5000 }, -- fire axe
	{ id = 827, chance = 5000 }, -- magma monocle
	{ id = 8093, chance = 5000 }, -- wand of draconia
	{ id = 31438, chance = 5000 }, -- sphinx tiara
	{ id = 677, chance = 5000 }, -- small enchanted emerald
	{ id = 3041, chance = 5000 }, -- blue gem
	{ id = 3038, chance = 5000 }, -- green gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "fire wave", interval = 2000, chance = 15, minDamage = -350, maxDamage = -500, length = 1, spread = 0, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -500, radius = 4, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -550, range = 1, shootEffect = CONST_ANI_FIRE, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_HOLYDAMAGE, minDamage = -400, maxDamage = -580, length = 6, spread = 3, effect = CONST_ME_HOLYAREA, target = false },
}

monster.defenses = {
	defense = 90,
	armor = 90,
	mitigation = 2.69,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 425, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
