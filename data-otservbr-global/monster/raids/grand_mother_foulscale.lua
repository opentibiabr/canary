local mType = Game.createMonsterType("Grand Mother Foulscale")
local monster = {}

monster.description = "Grand Mother Foulscale"
monster.experience = 1400
monster.outfit = {
	lookType = 34,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 642,
	bossRace = RARITY_NEMESIS,
}

monster.health = 1850
monster.maxHealth = 1850
monster.race = "blood"
monster.corpse = 5973
monster.speed = 90
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	runHealth = 400,
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
	maxSummons = 4,
	summons = {
		{ name = "dragon hatchlings", chance = 40, interval = 4000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "GROOAAARRR!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 87500, maxCount = 71 }, -- Gold Coin
	{ id = 3583, chance = 31818 }, -- Dragon Ham
	{ id = 3449, chance = 5000, maxCount = 8 }, -- Burst Arrow
	{ id = 3294, chance = 25000 }, -- Short Sword
	{ id = 3409, chance = 25000 }, -- Steel Shield
	{ id = 3286, chance = 1000 }, -- Mace
	{ id = 3285, chance = 1000 }, -- Longsword
	{ id = 3557, chance = 15000 }, -- Plate Legs
	{ id = 3351, chance = 7500 }, -- Steel Helmet
	{ id = 3349, chance = 7500 }, -- Crossbow
	{ id = 3275, chance = 15000 }, -- Double Axe
	{ id = 3322, chance = 12500 }, -- Dragon Hammer
	{ id = 3071, chance = 1000 }, -- Wand of Inferno
	{ id = 7430, chance = 2500 }, -- Dragonbone Staff
	{ id = 3416, chance = 5000 }, -- Dragon Shield
	{ id = 5920, chance = 100000 }, -- Green Dragon Scale
	{ id = 5877, chance = 100000 }, -- Green Dragon Leather
	{ id = 3301, chance = 2500 }, -- Broadsword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -20, maxDamage = -170 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -45, maxDamage = -85, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_FIREDAMAGE, minDamage = -90, maxDamage = -150, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 27,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 17, type = COMBAT_HEALING, minDamage = 34, maxDamage = 66, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
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
