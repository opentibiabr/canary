local mType = Game.createMonsterType("Xogixath")
local monster = {}

monster.description = "xogixath"
monster.experience = 22000
monster.outfit = {
	lookType = 842,
	lookHead = 3,
	lookBody = 16,
	lookLegs = 75,
	lookFeet = 79,
	lookAddons = 2,
	lookMount = 0,
}

monster.events = {
	"XogixathDeath",
}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "fire"
monster.corpse = 12838
monster.speed = 95
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1827,
	bossRace = RARITY_BANE,
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
}

monster.loot = {
	{ id = 3039, chance = 54793, maxCount = 2 }, -- Red Gem
	{ id = 3029, chance = 1000, maxCount = 3 }, -- Small Sapphire
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 16121, chance = 17187 }, -- Green Crystal Shard
	{ id = 3081, chance = 10937 }, -- Stone Skin Amulet
	{ id = 3320, chance = 6519 }, -- Fire Axe
	{ id = 31323, chance = 6097 }, -- Sea Horse Figurine
	{ id = 31324, chance = 4444 }, -- Golden Mask
	{ id = 31557, chance = 1000 }, -- Enchanted Blister Ring
	{ id = 31617, chance = 1000 }, -- Winged Boots
	{ id = 16127, chance = 6248 }, -- Green Crystal Fragment
	{ id = 8093, chance = 6249 }, -- Wand of Draconia
	{ id = 16124, chance = 15627 }, -- Blue Crystal Splinter
	{ id = 675, chance = 14062 }, -- Small Enchanted Sapphire
	{ id = 3071, chance = 3123 }, -- Wand of Inferno
	{ id = 6299, chance = 3123 }, -- Death Ring
	{ id = 30402, chance = 1000 }, -- Enchanted Theurgic Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -650 },
	{ name = "sudden death rune", interval = 2000, chance = 16, minDamage = -450, maxDamage = -550, range = 5, target = true },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_FIREDAMAGE, minDamage = -400, maxDamage = -480, range = 5, radius = 3, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -400, maxDamage = -550, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_FIREDAMAGE, minDamage = -420, maxDamage = -600, length = 5, spread = 3, effect = CONST_ME_HITBYFIRE, target = false },
}

monster.defenses = {
	defense = 86,
	armor = 86,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
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
