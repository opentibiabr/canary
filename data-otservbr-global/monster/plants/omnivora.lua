local mType = Game.createMonsterType("Omnivora")
local monster = {}

monster.description = "an omnivora"
monster.experience = 750
monster.outfit = {
	lookType = 717,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1141
monster.Bestiary = {
	class = "Plant",
	race = BESTY_RACE_PLANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Tiquanda Medusa Tower.",
}

monster.health = 1200
monster.maxHealth = 1200
monster.race = "blood"
monster.corpse = 21995
monster.speed = 105
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
	canWalkOnFire = false,
	canWalkOnPoison = true,
	isPreyExclusive = true,
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
	{ id = 3031, chance = 23000, maxCount = 145 }, -- gold coin
	{ id = 7885, chance = 23000 }, -- fish
	{ id = 3723, chance = 23000, maxCount = 3 }, -- white mushroom
	{ id = 3582, chance = 23000 }, -- ham
	{ id = 3052, chance = 5000 }, -- life ring
	{ id = 3069, chance = 1000 }, -- necrotic rod
	{ id = 16124, chance = 1000 }, -- blue crystal splinter
	{ id = 16123, chance = 1000 }, -- brown crystal splinter
	{ id = 3297, chance = 1000 }, -- serpent sword
	{ id = 16122, chance = 1000 }, -- green crystal splinter
	{ id = 8072, chance = 260 }, -- spellbook of enlightenment
	{ id = 813, chance = 260 }, -- terra boots
	{ id = 12311, chance = 260 }, -- carrot on a stick
	{ id = 6299, chance = 260 }, -- death ring
	{ id = 814, chance = 260 }, -- terra amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -150 },
	{ name = "speed", interval = 4000, chance = 20, speedChange = -350, range = 7, shootEffect = CONST_ANI_POISON, target = true, duration = 12000 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -80, maxDamage = -100, range = 7, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -50, maxDamage = -100, length = 8, spread = 0, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 38,
	mitigation = 0.99,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 250, maxDamage = 400, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
