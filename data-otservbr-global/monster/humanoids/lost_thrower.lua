local mType = Game.createMonsterType("Lost Thrower")
local monster = {}

monster.description = "a lost thrower"
monster.experience = 1500
monster.outfit = {
	lookType = 539,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 926
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Caves of the Lost, Lower Spike and in the Lost Dwarf version of the Forsaken Mine.",
}

monster.health = 1700
monster.maxHealth = 1700
monster.race = "blood"
monster.corpse = 17718
monster.speed = 120
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
	canWalkOnEnergy = false,
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
	{ id = 3031, chance = 80000, maxCount = 140 }, -- gold coin
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 17856, chance = 23000 }, -- basalt fetish
	{ id = 17857, chance = 23000 }, -- basalt figurine
	{ id = 17827, chance = 23000 }, -- bloody dwarven beard
	{ id = 17851, chance = 23000 }, -- broken throwing axe
	{ id = 3725, chance = 23000, maxCount = 2 }, -- brown mushroom
	{ id = 12600, chance = 23000 }, -- coal
	{ id = 239, chance = 23000 }, -- great health potion
	{ id = 238, chance = 23000 }, -- great mana potion
	{ id = 5880, chance = 23000 }, -- iron ore
	{ id = 17853, chance = 23000 }, -- lost bracers
	{ id = 17854, chance = 23000 }, -- mad froth
	{ id = 17855, chance = 23000 }, -- red hair dye
	{ id = 17852, chance = 5000 }, -- helmet of the lost
	{ id = 17829, chance = 1000 }, -- buckle
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -301 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -250, range = 7, radius = 1, shootEffect = CONST_ANI_THROWINGSTAR, effect = CONST_ME_EXPLOSIONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_PHYSICALDAMAGE, range = 7, radius = 2, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -150, maxDamage = -300, range = 7, radius = 2, shootEffect = CONST_ANI_WHIRLWINDCLUB, effect = CONST_ME_STUN, target = true },
	{ name = "drunk", interval = 2000, chance = 10, radius = 3, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_EXPLOSIONAREA, target = true, duration = 6000 },
}

monster.defenses = {
	defense = 30,
	armor = 50,
	mitigation = 1.40,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 100, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 10, effect = CONST_ME_TELEPORT },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
