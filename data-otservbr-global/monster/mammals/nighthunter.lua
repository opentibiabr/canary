local mType = Game.createMonsterType("Nighthunter")
local monster = {}

monster.description = "a nighthunter"
monster.experience = 12647
monster.outfit = {
	lookType = 1552,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2270
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Monster Graveyard",
}

monster.health = 19200
monster.maxHealth = 19200
monster.race = "blood"
monster.corpse = 39299
monster.speed = 205
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
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
	{ text = "Shriiiiek! Shriiiiek!", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 39381, chance = 80000, maxCount = 2 }, -- nighthunter wing
	{ id = 7643, chance = 23000, maxCount = 3 }, -- ultimate health potion
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ id = 7449, chance = 5000 }, -- crystal sword
	{ id = 14040, chance = 5000 }, -- warriors axe
	{ id = 16121, chance = 5000 }, -- green crystal shard
	{ id = 16125, chance = 5000 }, -- cyan crystal fragment
	{ id = 16126, chance = 5000 }, -- red crystal fragment
	{ id = 3081, chance = 1000 }, -- stone skin amulet
	{ id = 8074, chance = 1000 }, -- spellbook of mind control
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -700 },
	{ name = "combat", interval = 3500, chance = 35, type = COMBAT_EARTHDAMAGE, minDamage = -950, maxDamage = -1300, range = 1, radius = 1, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
	{ name = "nighthunter wave", interval = 5000, chance = 25, minDamage = -600, maxDamage = -775 },
}

monster.defenses = {
	defense = 85,
	armor = 81,
	mitigation = 2.28,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

RegisterPrimalPackBeast(monster)
