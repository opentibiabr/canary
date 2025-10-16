local mType = Game.createMonsterType("The Rootkraken")
local monster = {}

monster.description = "the rootkraken"
monster.experience = 700000
monster.outfit = {
	lookType = 1765,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}
monster.events = {}

monster.bosstiary = {
	bossRaceId = 2528,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "blood"
monster.corpse = 49120
monster.speed = 170
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
	{ text = "Chrrrk!", yell = false },
}

monster.loot = {
	{ id = 46628, chance = 80000 }, -- amber crusher
	{ id = 3043, chance = 80000, maxCount = 3 }, -- crystal coin
	{ id = 3035, chance = 80000, maxCount = 93 }, -- platinum coin
	{ id = 7643, chance = 80000, maxCount = 19 }, -- ultimate health potion
	{ id = 32624, chance = 80000 }, -- amber with a bug
	{ id = 7642, chance = 80000, maxCount = 7 }, -- great spirit potion
	{ id = 23374, chance = 80000, maxCount = 14 }, -- ultimate spirit potion
	{ id = 32623, chance = 80000 }, -- giant topaz
	{ id = 30060, chance = 80000 }, -- giant emerald
	{ id = 30061, chance = 80000 }, -- giant sapphire
	{ id = 237, chance = 80000 }, -- strong mana potion
	{ id = 238, chance = 80000, maxCount = 14 }, -- great mana potion
	{ id = 23375, chance = 80000, maxCount = 4 }, -- supreme health potion
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 32769, chance = 80000 }, -- white gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 47374, chance = 80000 }, -- amber sabre
	{ id = 47370, chance = 80000 }, -- amber bludgeon
	{ id = 47369, chance = 80000 }, -- amber greataxe
	{ id = 32625, chance = 80000 }, -- amber with a dragonfly
	{ id = 32622, chance = 80000 }, -- giant amethyst
	{ id = 48516, chance = 80000 }, -- root tentacle
	{ id = 48517, chance = 80000 }, -- fish eye
	{ id = 48514, chance = 80000 }, -- strange inedible fruit
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -650, maxDamage = -1650 },
	{ name = "rootkraken", interval = 2500, chance = 20 },
	{ name = "combat", interval = 2500, chance = 23, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -1390, range = 5, effect = CONST_ME_REAPER, target = true },
	{ name = "rootkrakentwo", interval = 2000, chance = 20 },
}

monster.defenses = {
	defense = 76,
	armor = 76,
	mitigation = 2.02,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
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
