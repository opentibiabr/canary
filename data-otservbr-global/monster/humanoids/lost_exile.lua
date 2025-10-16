local mType = Game.createMonsterType("Lost Exile")
local monster = {}

monster.description = "a lost exile"
monster.experience = 1800
monster.outfit = {
	lookType = 537,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"LastExileDeath",
}

monster.raceId = 1529
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "South east of the Gnome Deep Hub's entrance.",
}

monster.health = 1600
monster.maxHealth = 1600
monster.race = "blood"
monster.corpse = 17684
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "**", yell = false },
	{ text = "**", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 2 }, -- platinum coin
	{ id = 17847, chance = 23000 }, -- wimp tooth chain
	{ id = 12600, chance = 23000 }, -- coal
	{ id = 236, chance = 23000, maxCount = 3 }, -- strong health potion
	{ id = 3725, chance = 23000, maxCount = 2 }, -- brown mushroom
	{ id = 17850, chance = 23000 }, -- holy ash
	{ id = 17855, chance = 23000 }, -- red hair dye
	{ id = 17856, chance = 23000 }, -- basalt fetish
	{ id = 9057, chance = 23000 }, -- small topaz
	{ id = 17830, chance = 23000 }, -- bonecarving knife
	{ id = 17857, chance = 23000 }, -- basalt figurine
	{ id = 17848, chance = 23000 }, -- lost hushers staff
	{ id = 238, chance = 23000, maxCount = 2 }, -- great mana potion
	{ id = 17831, chance = 23000 }, -- bone fetish
	{ id = 17849, chance = 23000 }, -- skull shatterer
	{ id = 3097, chance = 5000 }, -- dwarven ring
	{ id = 3415, chance = 1000 }, -- guardian shield
	{ id = 17829, chance = 1000 }, -- buckle
	{ id = 10422, chance = 1000 }, -- clay lump
	{ id = 3318, chance = 1000 }, -- knight axe
	{ id = 813, chance = 1000 }, -- terra boots
	{ id = 27653, chance = 1000 }, -- suspicious device
	{ id = 3428, chance = 260 }, -- tower shield
	{ id = 812, chance = 260 }, -- terra legs
	{ id = 3320, chance = 260 }, -- fire axe
	{ id = 3324, chance = 260 }, -- skull staff
	{ id = 7452, chance = 260 }, -- spiked squelcher
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -120 },
	{ name = "sudden death rune", interval = 2000, chance = 15, minDamage = -150, maxDamage = -350, range = 3, length = 6, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -150, maxDamage = -250, range = 3, length = 5, spread = 5, effect = CONST_ME_SMOKE, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -150, maxDamage = -290, range = 3, length = 5, spread = 5, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_POISONAREA, target = false },
	{ name = "sudden death rune", interval = 2000, chance = 15, minDamage = -70, maxDamage = -250, range = 7, target = false },
	{ name = "drunk", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_ENERGY, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 0, maxDamage = 160, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
