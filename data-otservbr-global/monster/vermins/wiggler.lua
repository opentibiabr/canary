local mType = Game.createMonsterType("Wiggler")
local monster = {}

monster.description = "a wiggler"
monster.experience = 900
monster.outfit = {
	lookType = 510,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"WigglerDeath",
}

monster.raceId = 899
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Can be found in Truffels Garden as well as the Mushroom Gardens.",
}

monster.health = 1200
monster.maxHealth = 1200
monster.race = "venom"
monster.corpse = 16193
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
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
	targetDistance = 1,
	runHealth = 359,
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
	{ text = "Zzzrp", yell = false },
	{ text = "Crick! Crick!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 23000 }, -- platinum coin
	{ id = 3723, chance = 23000, maxCount = 5 }, -- white mushroom
	{ id = 15793, chance = 23000, maxCount = 5 }, -- crystalline arrow
	{ id = 16142, chance = 23000, maxCount = 5 }, -- drill bolt
	{ id = 16122, chance = 5000 }, -- green crystal splinter
	{ id = 237, chance = 5000 }, -- strong mana potion
	{ id = 236, chance = 5000 }, -- strong health potion
	{ id = 3429, chance = 5000 }, -- black shield
	{ id = 5912, chance = 5000 }, -- blue piece of cloth
	{ id = 16127, chance = 5000 }, -- green crystal fragment
	{ id = 3297, chance = 5000 }, -- serpent sword
	{ id = 5914, chance = 5000 }, -- yellow piece of cloth
	{ id = 3065, chance = 1000 }, -- terra rod
	{ id = 5910, chance = 1000 }, -- green piece of cloth
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200, condition = { type = CONDITION_POISON, totalDamage = 500, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -180, maxDamage = -270, length = 4, spread = 3, effect = CONST_ME_HITBYPOISON, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -160, maxDamage = -200, range = 7, shootEffect = CONST_ANI_POISONARROW, effect = CONST_ME_SMALLPLANTS, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -700, length = 3, spread = 2, effect = CONST_ME_HITAREA, target = false, duration = 30000 },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 510, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
