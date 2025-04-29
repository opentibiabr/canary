local mType = Game.createMonsterType("The Duke of the Depths")
local monster = {}

monster.description = "The Duke Of The Depths"
monster.experience = 300000
monster.outfit = {
	lookType = 1047,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"DepthWarzoneBossDeath",
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "blood"
monster.corpse = 27641
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 50,
}

monster.bosstiary = {
	bossRaceId = 1520,
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
	{ text = "SzzzSzzz!", yell = false },
	{ text = "Chhhhhh!", yell = false },
}

monster.loot = {
	{ name = "platinum coin", chance = 100000, maxCount = 63 },
	{ name = "mastermind potion", chance = 100000 },
	{ name = "stone skin amulet", chance = 100000 },
	{ id = 27713, chance = 100000 }, -- heavy crystal fragment
	{ name = "wand of inferno", chance = 75000 },
	{ name = "great mana potion", chance = 64580, maxCount = 18 },
	{ name = "blue crystal shard", chance = 60420 },
	{ name = "fire axe", chance = 58330 },
	{ name = "ultimate health potion", chance = 52080, maxCount = 18 },
	{ name = "fire sword", chance = 52080 },
	{ name = "great spirit potion", chance = 45830, maxCount = 18 },
	{ name = "luminous orb", chance = 37500 },
	{ name = "damaged worm head", chance = 27080 },
	{ name = "small amethyst", chance = 25000 },
	{ name = "small diamond", chance = 20830 },
	{ name = "slightly rusted helmet", chance = 20830 },
	{ name = "green gem", chance = 18750 },
	{ name = "slightly rusted shield", chance = 18750 },
	{ name = "silver token", chance = 16670 },
	{ name = "giant tentacle", chance = 16670 },
	{ name = "yellow gem", chance = 16670 },
	{ name = "blue gem", chance = 16670 },
	{ name = "small ruby", chance = 14580 },
	{ id = 281, chance = 14580 }, -- giant shimmering pearl
	{ name = "magic sulphur", chance = 14580 },
	{ name = "huge chunk of crude iron", chance = 12500 },
	{ id = 3039, chance = 12500 }, -- red gem
	{ name = "small topaz", chance = 10420 },
	{ name = "small emerald", chance = 10420 },
	{ name = "muck rod", chance = 10420 },
	{ name = "gold token", chance = 10420 },
	{ name = "crystal coin", chance = 6250 },
	{ name = "gnome shield", chance = 4170 },
	{ name = "crystalline armor", chance = 4170 },
	{ name = "gnome sword", chance = 4170 },
	{ name = "terra mantle", chance = 2080 },
	{ name = "violet gem", chance = 2080 },
	{ name = "gnome legs", chance = 3390 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -800 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -1000, range = 3, length = 6, spread = 8, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -1000, range = 3, length = 9, spread = 4, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -135, maxDamage = -1000, radius = 2, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1000, radius = 8, effect = CONST_ME_HITAREA, target = false },
}

monster.defenses = {
	defense = 160,
	armor = 160,
	--	mitigation = ???,
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

monster.heals = {
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
}

mType:register(monster)
