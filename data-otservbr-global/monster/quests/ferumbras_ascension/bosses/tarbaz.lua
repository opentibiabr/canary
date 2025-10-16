local mType = Game.createMonsterType("Tarbaz")
local monster = {}

monster.description = "Tarbaz"
monster.experience = 500000
monster.outfit = {
	lookType = 842,
	lookHead = 0,
	lookBody = 21,
	lookLegs = 19,
	lookFeet = 3,
	lookAddons = 2,
	lookMount = 0,
}

monster.events = {
	"AscendantBossesDeath",
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "undead"
monster.corpse = 22495
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 1188,
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
	{ text = "You are a failure.", yell = false },
}

monster.loot = {
	{ id = 22762, chance = 80000 }, -- maimer
	{ id = 22757, chance = 80000 }, -- shroud of despair
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 22726, chance = 80000 }, -- rift shield
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 16119, chance = 80000 }, -- blue crystal shard
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 16121, chance = 80000 }, -- green crystal shard
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 6558, chance = 80000 }, -- flask of demonic blood
	{ id = 3051, chance = 80000 }, -- energy ring
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 8082, chance = 80000 }, -- underworld rod
	{ id = 6499, chance = 80000 }, -- demonic essence
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 16120, chance = 80000 }, -- violet crystal shard
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 823, chance = 80000 }, -- glacier kilt
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3028, chance = 80000 }, -- small diamond
	{ id = 824, chance = 80000 }, -- glacier robe
	{ id = 3326, chance = 80000 }, -- epee
	{ id = 815, chance = 80000 }, -- glacier amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1000, maxDamage = -2000 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -1000, length = 10, spread = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "speed", interval = 2000, chance = 25, speedChange = -600, radius = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -700, radius = 5, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -800, length = 10, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -800, length = 8, spread = 3, effect = CONST_ME_FIREATTACK, target = false },
}

monster.defenses = {
	defense = 120,
	armor = 100,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 900, maxDamage = 3500, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "speed", interval = 3000, chance = 30, speedChange = 460, effect = CONST_ME_MAGIC_RED, target = false, duration = 7000 },
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
