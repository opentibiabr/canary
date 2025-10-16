local mType = Game.createMonsterType("Swan Maiden")
local monster = {}

monster.description = "a swan maiden"
monster.experience = 700
monster.outfit = {
	lookType = 138,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 114,
	lookFeet = 78,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1437
monster.Bestiary = {
	class = "Fey",
	race = BESTY_RACE_FEY,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 1,
	Locations = "Feyrist Meadows",
}

monster.health = 800
monster.maxHealth = 800
monster.race = "blood"
monster.corpse = 25831
monster.speed = 117
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
	runHealth = 20,
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
	{ text = "Nightmarish monster! This dream is not meant for you!", yell = false },
	{ text = "You won't steal my robe! Back off!", yell = false },
	{ text = "You are not allowed to lay eyes on me in this shape!", yell = false },
	{ text = "Are you stalking me? You will bitterly regret this!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 89 }, -- gold coin
	{ id = 25691, chance = 23000 }, -- wild flowers
	{ id = 25696, chance = 23000 }, -- colourful snail shell
	{ id = 3739, chance = 5000 }, -- powder herb
	{ id = 3026, chance = 5000, maxCount = 2 }, -- white pearl
	{ id = 3017, chance = 5000 }, -- silver brooch
	{ id = 238, chance = 5000 }, -- great mana potion
	{ id = 3732, chance = 5000 }, -- green mushroom
	{ id = 677, chance = 5000 }, -- small enchanted emerald
	{ id = 24391, chance = 5000 }, -- coral brooch
	{ id = 22194, chance = 5000, maxCount = 2 }, -- opal
	{ id = 3311, chance = 1000 }, -- clerical mace
	{ id = 9013, chance = 1000 }, -- flower wreath
	{ id = 3079, chance = 1000 }, -- boots of haste
	{ id = 8046, chance = 1000 }, -- summer dress
	{ id = 237, chance = 1000 }, -- strong mana potion
	{ id = 25698, chance = 1000 }, -- butterfly ring
	{ id = 7387, chance = 260 }, -- diamond sceptre
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -215 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -60, maxDamage = -115, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 11, type = COMBAT_MANADRAIN, minDamage = -82, maxDamage = -215, range = 7, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYAREA, target = true },
	{ name = "speed", interval = 2000, chance = 11, speedChange = -450, radius = 6, effect = CONST_ME_PIXIE_EXPLOSION, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 54,
	armor = 54,
	mitigation = 1.18,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 85, maxDamage = 105, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
