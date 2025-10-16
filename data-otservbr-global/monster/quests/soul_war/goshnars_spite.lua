local mType = Game.createMonsterType("Goshnar's Spite")
local monster = {}

monster.description = "Goshnar's Spite"
monster.experience = 75000
monster.outfit = {
	lookType = 1305,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"SoulWarBossesDeath",
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "undead"
monster.corpse = 33867
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1903,
	bossRace = RARITY_ARCHFOE,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 95,
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
}

monster.loot = {
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 23375, chance = 80000 }, -- supreme health potion
	{ id = 7443, chance = 80000 }, -- bullseye potion
	{ id = 23374, chance = 80000 }, -- ultimate spirit potion
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 32623, chance = 80000 }, -- giant topaz
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 23373, chance = 80000 }, -- ultimate mana potion
	{ id = 32622, chance = 80000 }, -- giant amethyst
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 33952, chance = 80000 }, -- figurine of spite
	{ id = 33926, chance = 80000 }, -- spites spirit
	{ id = 34075, chance = 80000 }, -- the skull of a beast
	{ id = 34072, chance = 80000 }, -- spectral horseshoe
	{ id = 34109, chance = 80000 }, -- bag you desire
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 7439, chance = 80000 }, -- berserk potion
}

monster.attacks = {

	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -5000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -1400, maxDamage = -2200, length = 8, spread = 0, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "singlecloudchain", interval = 6000, chance = 40, minDamage = -1700, maxDamage = -1900, range = 6, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -1200, maxDamage = -3500, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_GREEN_RINGS, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -1400, maxDamage = -2200, length = 8, spread = 0, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "soulwars fear", interval = 2000, chance = 10, target = true },
}

monster.defenses = {
	defense = 160,
	armor = 160,
	mitigation = 5.40,
	{ name = "speed", interval = 1000, chance = 20, speedChange = 500, effect = CONST_ME_MAGIC_RED, target = false, duration = 10000 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 1250, maxDamage = 3250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
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
