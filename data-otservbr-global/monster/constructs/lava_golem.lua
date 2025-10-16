local mType = Game.createMonsterType("Lava Golem")
local monster = {}

monster.description = "a lava golem"
monster.experience = 7900
monster.outfit = {
	lookType = 491,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 884
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Warzone 2.",
}

monster.health = 9000
monster.maxHealth = 9000
monster.race = "fire"
monster.corpse = 15988
monster.speed = 210
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 80,
	random = 20,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 10,
	color = 206,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Grrrrunt", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 199 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 11 }, -- platinum coin
	{ id = 16131, chance = 23000 }, -- blazing bone
	{ id = 9636, chance = 23000 }, -- fiery heart
	{ id = 238, chance = 23000, maxCount = 2 }, -- great mana potion
	{ id = 16122, chance = 23000, maxCount = 2 }, -- green crystal splinter
	{ id = 5880, chance = 23000 }, -- iron ore
	{ id = 16130, chance = 23000, maxCount = 2 }, -- magma clump
	{ id = 268, chance = 23000, maxCount = 2 }, -- mana potion
	{ id = 16141, chance = 23000, maxCount = 5 }, -- prismatic bolt
	{ id = 16126, chance = 23000 }, -- red crystal fragment
	{ id = 236, chance = 23000, maxCount = 2 }, -- strong health potion
	{ id = 237, chance = 23000, maxCount = 2 }, -- strong mana potion
	{ id = 7643, chance = 23000 }, -- ultimate health potion
	{ id = 16120, chance = 23000 }, -- violet crystal shard
	{ id = 3037, chance = 23000 }, -- yellow gem
	{ id = 5914, chance = 23000 }, -- yellow piece of cloth
	{ id = 5909, chance = 5000 }, -- white piece of cloth
	{ id = 817, chance = 5000 }, -- magma amulet
	{ id = 818, chance = 5000 }, -- magma boots
	{ id = 5911, chance = 5000 }, -- red piece of cloth
	{ id = 3071, chance = 5000 }, -- wand of inferno
	{ id = 3419, chance = 5000 }, -- crown shield
	{ id = 3320, chance = 5000 }, -- fire axe
	{ id = 3280, chance = 5000 }, -- fire sword
	{ id = 36706, chance = 5000 }, -- red gem
	{ id = 16115, chance = 5000 }, -- wand of everblazing
	{ id = 826, chance = 1000 }, -- magma coat
	{ id = 8074, chance = 1000 }, -- spellbook of mind control
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -700, length = 8, spread = 0, effect = CONST_ME_FIREATTACK, target = false },
	{ name = "lava golem soulfire", interval = 2000, chance = 15, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -220, maxDamage = -350, radius = 4, effect = CONST_ME_FIREAREA, target = true },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -800, length = 5, spread = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 30000 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -280, maxDamage = -350, radius = 3, effect = CONST_ME_HITBYFIRE, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 84,
	mitigation = 2.51,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 35 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
