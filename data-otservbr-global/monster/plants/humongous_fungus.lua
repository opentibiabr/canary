local mType = Game.createMonsterType("Humongous Fungus")
local monster = {}

monster.description = "a humongous fungus"
monster.experience = 2900
monster.outfit = {
	lookType = 488,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 881
monster.Bestiary = {
	class = "Plant",
	race = BESTY_RACE_PLANT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Warzone 1, Rathleton Sewers, unreachable location in Tiquanda Laboratory.",
}

monster.health = 3400
monster.maxHealth = 3400
monster.race = "blood"
monster.corpse = 15872
monster.speed = 130
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 80,
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
	{ text = "Munch munch munch!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 6 }, -- platinum coin
	{ id = 5909, chance = 23000 }, -- white piece of cloth
	{ id = 5913, chance = 23000 }, -- brown piece of cloth
	{ id = 16103, chance = 23000, maxCount = 3 }, -- mushroom pie
	{ id = 16139, chance = 23000 }, -- humongous chunk
	{ id = 16142, chance = 23000, maxCount = 15 }, -- drill bolt
	{ id = 236, chance = 5000, maxCount = 2 }, -- strong health potion
	{ id = 237, chance = 5000, maxCount = 2 }, -- strong mana potion
	{ id = 238, chance = 5000, maxCount = 2 }, -- great mana potion
	{ id = 239, chance = 5000, maxCount = 2 }, -- great health potion
	{ id = 268, chance = 5000, maxCount = 3 }, -- mana potion
	{ id = 812, chance = 5000 }, -- terra legs
	{ id = 813, chance = 5000 }, -- terra boots
	{ id = 814, chance = 5000 }, -- terra amulet
	{ id = 5911, chance = 5000 }, -- red piece of cloth
	{ id = 5912, chance = 5000 }, -- blue piece of cloth
	{ id = 7436, chance = 5000 }, -- angelic axe
	{ id = 811, chance = 1000 }, -- terra mantle
	{ id = 16117, chance = 1000 }, -- muck rod
	{ id = 16164, chance = 260 }, -- mycological bow
	{ id = 16099, chance = 260 }, -- mushroom backpack
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -330 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -180, maxDamage = -350, range = 7, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_SMALLPLANTS, target = false },
	{ name = "poisonfield", interval = 2000, chance = 10, radius = 4, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -500, maxDamage = -1000, length = 8, spread = 0, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -130, maxDamage = -260, length = 5, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -400, maxDamage = -640, range = 7, radius = 3, effect = CONST_ME_HITBYPOISON, target = false },
}

monster.defenses = {
	defense = 0,
	armor = 70,
	mitigation = 2.02,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 225, maxDamage = 380, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 35 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
