local mType = Game.createMonsterType("Mitmah Seer")
local monster = {}

monster.description = "a mitmah seer"
monster.experience = 4580
monster.outfit = {
	lookType = 1710,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2461
monster.Bestiary = {
	class = "Extra Dimensional",
	race = BESTY_RACE_EXTRA_DIMENSIONAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Iksupan Waterways",
}

monster.health = 4620
monster.maxHealth = 4620
monster.race = "venom"
monster.corpse = 44671
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	critChance = 3,
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
	{ text = "This dimension reeks!!", yell = false },
	{ text = "Pamphlets at the exit only! Only one per person!", yell = false },
	{ text = "This is the end of you!", yell = false },
}

monster.loot = {
	{ id = 236, chance = 23000, maxCount = 3 }, -- strong health potion
	{ id = 238, chance = 23000 }, -- great mana potion
	{ id = 22194, chance = 23000 }, -- opal
	{ id = 3016, chance = 5000 }, -- ruby necklace
	{ id = 36706, chance = 5000 }, -- red gem
	{ id = 3063, chance = 5000 }, -- gold ring
	{ id = 3073, chance = 5000 }, -- wand of cosmic energy
	{ id = 3038, chance = 1000 }, -- green gem
	{ id = 27488, chance = 1000 }, -- gold nugget
	{ id = 25699, chance = 260 }, -- wooden spellbook
	{ id = 48099, chance = 80000 }, -- mitmah seer soul core
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -250, maxDamage = -400, radius = 4, effect = CONST_ME_BLACKSMOKE, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -400, range = 5, radius = 3, effect = CONST_ME_MORTAREA, target = true },
	{ name = "mitmahseekwave", interval = 2000, chance = 20, minDamage = -200, maxDamage = -400 },
}

monster.defenses = {
	defense = 40,
	armor = 45,
	mitigation = 2.02,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 130, maxDamage = 210, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
