local mType = Game.createMonsterType("The Unwelcome")
local monster = {}

monster.description = "The Unwelcome"
monster.experience = 30000
monster.outfit = {
	lookType = 1277,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"FeasterOfSoulsBossDeath",
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "undead"
monster.corpse = 32741
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
	chance = 0,
}

monster.bosstiary = {
	bossRaceId = 1868,
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
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 1,
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

monster.summon = {
	maxSummons = 3,
	summons = {
		{ name = "wormling", chance = 40, interval = 2000, count = 3 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3043, chance = 80000, maxCount = 2 }, -- crystal coin
	{ id = 32770, chance = 80000, maxCount = 2 }, -- diamond
	{ id = 32771, chance = 80000 }, -- moonstone
	{ id = 32769, chance = 80000 }, -- white gem
	{ id = 7439, chance = 80000, maxCount = 10 }, -- berserk potion
	{ id = 7440, chance = 80000, maxCount = 10 }, -- mastermind potion
	{ id = 7443, chance = 80000, maxCount = 10 }, -- bullseye potion
	{ id = 23374, chance = 80000, maxCount = 6 }, -- ultimate spirit potion
	{ id = 23375, chance = 80000, maxCount = 6 }, -- supreme health potion
	{ id = 23373, chance = 80000, maxCount = 6 }, -- ultimate mana potion
	{ id = 32589, chance = 80000 }, -- angel figurine
	{ id = 32774, chance = 80000 }, -- cursed bone
	{ id = 32773, chance = 80000 }, -- ivory comb
	{ id = 32772, chance = 80000 }, -- silver hand mirror
	{ id = 32703, chance = 80000 }, -- death toll
	{ id = 32622, chance = 80000 }, -- giant amethyst
	{ id = 32623, chance = 80000 }, -- giant topaz
	{ id = 32625, chance = 80000 }, -- amber with a dragonfly
	{ id = 32599, chance = 80000 }, -- writhing heart
	{ id = 32600, chance = 80000 }, -- writhing brain
	{ id = 32630, chance = 80000 }, -- spooky hood
	{ id = 32591, chance = 80000 }, -- soulforged lantern
	{ id = 32631, chance = 80000 }, -- ghost claw
	{ id = 32618, chance = 80000 }, -- soulful legs
	{ id = 32617, chance = 80000 }, -- fabulous legs
	{ id = 32624, chance = 80000 }, -- amber with a bug
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 600, maxDamage = -1050, condition = { type = CONDITION_POISON, totalDamage = 4, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_LIFEDRAIN, minDamage = -900, maxDamage = -1400, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 1000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -1000, maxDamage = -1750, radius = 2, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "drunk", interval = 1000, chance = 70, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "strength", interval = 1000, chance = 60, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = 0, maxDamage = -900, length = 5, spread = 3, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 1000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -600, maxDamage = -1200, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "speed", interval = 3000, chance = 40, speedChange = -700, effect = CONST_ME_MAGIC_RED, target = true, duration = 20000 },
}

monster.defenses = {
	defense = 15,
	armor = 10,
	--	mitigation = ???,
	{ name = "speed", interval = 10000, chance = 40, speedChange = 510, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 20000 },
	{ name = "combat", interval = 5000, chance = 60, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 2500, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 90 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 90 },
	{ type = COMBAT_EARTHDAMAGE, percent = 90 },
	{ type = COMBAT_FIREDAMAGE, percent = 90 },
	{ type = COMBAT_LIFEDRAIN, percent = 90 },
	{ type = COMBAT_MANADRAIN, percent = 90 },
	{ type = COMBAT_DROWNDAMAGE, percent = 90 },
	{ type = COMBAT_ICEDAMAGE, percent = 90 },
	{ type = COMBAT_HOLYDAMAGE, percent = 90 },
	{ type = COMBAT_DEATHDAMAGE, percent = 90 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
