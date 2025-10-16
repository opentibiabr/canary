local mType = Game.createMonsterType("Hideous Fungus")
local monster = {}

monster.description = "a hideous fungus"
monster.experience = 3700
monster.outfit = {
	lookType = 499,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 891
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

monster.health = 4600
monster.maxHealth = 4600
monster.race = "venom"
monster.corpse = 16083
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 4,
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

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "humorless fungus", chance = 10, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Munch munch munch!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 199 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 7 }, -- platinum coin
	{ id = 16143, chance = 23000, maxCount = 15 }, -- envenomed arrow
	{ id = 239, chance = 23000 }, -- great health potion
	{ id = 238, chance = 23000 }, -- great mana potion
	{ id = 16140, chance = 23000 }, -- hideous chunk
	{ id = 268, chance = 23000 }, -- mana potion
	{ id = 16103, chance = 23000, maxCount = 3 }, -- mushroom pie
	{ id = 5909, chance = 23000 }, -- white piece of cloth
	{ id = 5912, chance = 5000 }, -- blue piece of cloth
	{ id = 5910, chance = 5000 }, -- green piece of cloth
	{ id = 814, chance = 5000 }, -- terra amulet
	{ id = 3279, chance = 5000 }, -- war hammer
	{ id = 5911, chance = 5000 }, -- red piece of cloth
	{ id = 813, chance = 5000 }, -- terra boots
	{ id = 16117, chance = 1000 }, -- muck rod
	{ id = 812, chance = 1000 }, -- terra legs
	{ id = 811, chance = 1000 }, -- terra mantle
	{ id = 16099, chance = 260 }, -- mushroom backpack
	{ id = 16164, chance = 260 }, -- mycological bow
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -250, maxDamage = -430, range = 7, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_SMALLPLANTS, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -250, maxDamage = -550, length = 8, spread = 0, shootEffect = CONST_ANI_SNOWBALL, effect = CONST_ME_ICEAREA, target = false },
	{ name = "drunk", interval = 2000, chance = 10, range = 7, radius = 5, shootEffect = CONST_ANI_SMALLSTONE, effect = CONST_ME_STUN, target = true, duration = 4000 },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -400, maxDamage = -640, range = 7, radius = 3, effect = CONST_ME_HITBYPOISON, target = false },
}

monster.defenses = {
	defense = 0,
	armor = 60,
	mitigation = 1.74,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 275, maxDamage = 350, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 5, effect = CONST_ME_MAGIC_BLUE, duration = 2000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
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
