local mType = Game.createMonsterType("Pirat Mate")
local monster = {}

monster.description = "a pirat mate"
monster.experience = 2400
monster.outfit = {
	lookType = 1346,
	lookHead = 0,
	lookBody = 95,
	lookLegs = 95,
	lookFeet = 113,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2039
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "The Wreckoning",
}

monster.health = 3200
monster.maxHealth = 3200
monster.race = "blood"
monster.corpse = 35388
monster.speed = 175
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 50,
	healthHidden = false,
	isBlockable = true,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false,
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
	{ id = 3028, chance = 23000 }, -- small diamond
	{ id = 36706, chance = 23000 }, -- red gem
	{ id = 16125, chance = 23000 }, -- cyan crystal fragment
	{ id = 16126, chance = 23000 }, -- red crystal fragment
	{ id = 3280, chance = 23000 }, -- fire sword
	{ id = 35573, chance = 23000 }, -- pirats tail
	{ id = 35596, chance = 23000 }, -- mouldy powder
	{ id = 35572, chance = 23000, maxCount = 9 }, -- pirate coin
	{ id = 3032, chance = 5000 }, -- small emerald
	{ id = 3284, chance = 5000 }, -- ice rapier
	{ id = 35574, chance = 5000 }, -- shark fins
	{ id = 16121, chance = 5000 }, -- green crystal shard
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ id = 22193, chance = 5000 }, -- onyx chip
	{ id = 35571, chance = 5000 }, -- small treasure chest
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "energy beam", interval = 2000, chance = 10, minDamage = -150, maxDamage = -210, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "energy wave", interval = 2000, chance = 10, minDamage = -140, maxDamage = -80, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 75,
	mitigation = 1.94,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 30, maxDamage = 60, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = -30 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
