local mType = Game.createMonsterType("Gazer Spectre")
local monster = {}

monster.description = "a gazer spectre"
monster.experience = 4200
monster.outfit = {
	lookType = 1122,
	lookHead = 94,
	lookBody = 21,
	lookLegs = 77,
	lookFeet = 78,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1725
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Haunted Temple, Buried Cathedral",
}

monster.health = 4500
monster.maxHealth = 4500
monster.race = "blood"
monster.corpse = 30167
monster.speed = 195
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
	{ text = "Deathhh... is... a.... doooor!!", yell = false },
	{ text = "Tiiimeee... is... a... windowww!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 3028, chance = 23000 }, -- small diamond
	{ id = 16123, chance = 23000 }, -- brown crystal splinter
	{ id = 3029, chance = 23000 }, -- small sapphire
	{ id = 36706, chance = 23000 }, -- red gem
	{ id = 16126, chance = 23000 }, -- red crystal fragment
	{ id = 676, chance = 23000 }, -- small enchanted ruby
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ id = 31164, chance = 5000 }, -- golden idol of tukh
	{ id = 8093, chance = 5000 }, -- wand of draconia
	{ id = 3071, chance = 5000 }, -- wand of inferno
	{ id = 30205, chance = 5000 }, -- red ectoplasm
	{ id = 826, chance = 5000 }, -- magma coat
	{ id = 24962, chance = 5000 }, -- prismatic quartz
	{ id = 677, chance = 5000 }, -- small enchanted emerald
	{ id = 22193, chance = 5000 }, -- onyx chip
	{ id = 30180, chance = 1000 }, -- hexagonal ruby
	{ id = 3081, chance = 260 }, -- stone skin amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2500, chance = 35, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -350, range = 7, shootEffect = CONST_ANI_FIRE, target = false },
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -450, radius = 5, range = 5, effect = CONST_ME_FIREATTACK, target = true },
	{ name = "combat", interval = 3700, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -400, range = 7, effect = CONST_ME_YELLOWENERGY, shootEffect = CONST_ANI_ENERGYBALL, target = true },
}

monster.defenses = {
	defense = 78,
	armor = 68,
	mitigation = 2.02,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.reflects = {
	{ type = COMBAT_FIREDAMAGE, percent = 133 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 85 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 70 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -30 },
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
