local mType = Game.createMonsterType("Lost Basher")
local monster = {}

monster.description = "a lost basher"
monster.experience = 2300
monster.outfit = {
	lookType = 538,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 925
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

monster.health = 2600
monster.maxHealth = 2600
monster.race = "blood"
monster.corpse = 17683
monster.speed = 130
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
	staticAttackChance = 80,
	targetDistance = 1,
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
	{ text = "Yhouuuu!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 12600, chance = 23000 }, -- coal
	{ id = 17827, chance = 23000 }, -- bloody dwarven beard
	{ id = 17826, chance = 23000 }, -- lost bashers spike
	{ id = 3725, chance = 23000, maxCount = 2 }, -- brown mushroom
	{ id = 238, chance = 23000 }, -- great mana potion
	{ id = 17855, chance = 23000 }, -- red hair dye
	{ id = 17847, chance = 23000 }, -- wimp tooth chain
	{ id = 17857, chance = 23000 }, -- basalt figurine
	{ id = 9057, chance = 23000 }, -- small topaz
	{ id = 17830, chance = 23000 }, -- bonecarving knife
	{ id = 7643, chance = 23000 }, -- ultimate health potion
	{ id = 17856, chance = 23000 }, -- basalt fetish
	{ id = 17831, chance = 23000 }, -- bone fetish
	{ id = 5880, chance = 5000 }, -- iron ore
	{ id = 2995, chance = 5000 }, -- piggy bank
	{ id = 3429, chance = 5000 }, -- black shield
	{ id = 3097, chance = 5000 }, -- dwarven ring
	{ id = 17828, chance = 5000 }, -- pair of iron fists
	{ id = 16119, chance = 5000 }, -- blue crystal shard
	{ id = 17829, chance = 1000 }, -- buckle
	{ id = 3318, chance = 1000 }, -- knight axe
	{ id = 813, chance = 1000 }, -- terra boots
	{ id = 3371, chance = 1000 }, -- knight legs
	{ id = 7452, chance = 260 }, -- spiked squelcher
	{ id = 3320, chance = 260 }, -- fire axe
	{ id = 7427, chance = 260 }, -- chaos mace
	{ id = 3342, chance = 260 }, -- war axe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -351 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -220, range = 7, radius = 3, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_EXPLOSIONAREA, target = true },
	{ name = "drunk", interval = 2000, chance = 15, radius = 4, shootEffect = CONST_ANI_WHIRLWINDCLUB, effect = CONST_ME_SOUND_RED, target = true, duration = 6000 },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -650, radius = 2, effect = CONST_ME_ENERGYHIT, target = false, duration = 15000 },
}

monster.defenses = {
	defense = 30,
	armor = 57,
	mitigation = 1.62,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 250, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
