local mType = Game.createMonsterType("The False God")
local monster = {}

monster.description = "The False God"
monster.experience = 50000
monster.outfit = {
	lookType = 984,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"CultsOfTibiaBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1409,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "blood"
monster.corpse = 22495
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 30,
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
	{ text = "CREEEAK!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 325 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 37 }, -- platinum coin
	{ id = 21196, chance = 80000 }, -- necromantic rust
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 23535, chance = 80000, maxCount = 7 }, -- energy bar
	{ id = 3028, chance = 80000, maxCount = 10 }, -- small diamond
	{ id = 3032, chance = 80000, maxCount = 10 }, -- small emerald
	{ id = 3029, chance = 80000, maxCount = 10 }, -- small sapphire
	{ id = 3033, chance = 80000, maxCount = 10 }, -- small amethyst
	{ id = 9057, chance = 80000, maxCount = 10 }, -- small topaz
	{ id = 7642, chance = 80000, maxCount = 15 }, -- great spirit potion
	{ id = 238, chance = 80000, maxCount = 11 }, -- great mana potion
	{ id = 7643, chance = 80000, maxCount = 9 }, -- ultimate health potion
	{ id = 5887, chance = 80000 }, -- piece of royal steel
	{ id = 5889, chance = 80000, maxCount = 3 }, -- piece of draconian steel
	{ id = 5888, chance = 80000, maxCount = 12 }, -- piece of hell steel
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
	{ id = 5880, chance = 80000 }, -- iron ore
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 5911, chance = 80000, maxCount = 9 }, -- red piece of cloth
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 8082, chance = 80000 }, -- underworld rod
	{ id = 3342, chance = 80000 }, -- war axe
	{ id = 7383, chance = 80000 }, -- relic sword
	{ id = 17828, chance = 80000 }, -- pair of iron fists
	{ id = 22762, chance = 1000 }, -- maimer
	{ id = 8040, chance = 1000 }, -- velvet mantle
	{ id = 3281, chance = 260 }, -- giant sword
	{ id = 21175, chance = 80000 }, -- mino shield
	{ id = 21176, chance = 80000 }, -- execowtioner axe
	{ id = 14001, chance = 1000 }, -- ornate mace
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -500, range = 4, radius = 4, effect = CONST_ME_STONES, target = true },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -650, radius = 5, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
