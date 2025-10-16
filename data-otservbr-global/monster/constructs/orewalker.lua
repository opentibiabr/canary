local mType = Game.createMonsterType("Orewalker")
local monster = {}

monster.description = "an orewalker"
monster.experience = 5900
monster.outfit = {
	lookType = 490,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 883
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Warzone 3.",
}

monster.health = 7200
monster.maxHealth = 7200
monster.race = "undead"
monster.corpse = 15911
monster.speed = 190
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
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
	{ text = "CLONK!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 198 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 10 }, -- platinum coin
	{ id = 16124, chance = 23000, maxCount = 2 }, -- blue crystal splinter
	{ id = 16125, chance = 23000 }, -- cyan crystal fragment
	{ id = 238, chance = 23000, maxCount = 2 }, -- great mana potion
	{ id = 16121, chance = 23000 }, -- green crystal shard
	{ id = 5880, chance = 23000 }, -- iron ore
	{ id = 268, chance = 23000, maxCount = 4 }, -- mana potion
	{ id = 16141, chance = 23000, maxCount = 5 }, -- prismatic bolt
	{ id = 16133, chance = 23000 }, -- pulverized ore
	{ id = 10310, chance = 23000 }, -- shiny stone
	{ id = 9057, chance = 23000, maxCount = 3 }, -- small topaz
	{ id = 236, chance = 23000, maxCount = 2 }, -- strong health potion
	{ id = 237, chance = 23000, maxCount = 2 }, -- strong mana potion
	{ id = 10315, chance = 23000 }, -- sulphurous stone
	{ id = 7643, chance = 23000, maxCount = 2 }, -- ultimate health potion
	{ id = 16135, chance = 23000 }, -- vein of ore
	{ id = 3097, chance = 5000 }, -- dwarven ring
	{ id = 7454, chance = 5000 }, -- glorious axe
	{ id = 5904, chance = 5000 }, -- magic sulphur
	{ id = 7413, chance = 5000 }, -- titan axe
	{ id = 3385, chance = 5000 }, -- crown helmet
	{ id = 3371, chance = 5000 }, -- knight legs
	{ id = 16096, chance = 5000 }, -- wand of defiance
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ id = 3381, chance = 260 }, -- crown armor
	{ id = 16163, chance = 260 }, -- crystal crossbow
	{ id = 8050, chance = 260 }, -- crystalline armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "orewalker wave", interval = 2000, chance = 15, minDamage = -296, maxDamage = -700, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1500, length = 6, spread = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -800, maxDamage = -1080, radius = 3, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_SMALLPLANTS, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -800, radius = 2, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 45,
	armor = 79,
	mitigation = 2.31,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 65 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 25 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
