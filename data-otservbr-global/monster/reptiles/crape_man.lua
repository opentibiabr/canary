local mType = Game.createMonsterType("Crape Man")
local monster = {}

monster.description = "a crape man"
monster.experience = 5040
monster.outfit = {
	lookType = 1601,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2337
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Ingol",
}

monster.health = 9150
monster.maxHealth = 9150
monster.race = "blood"
monster.corpse = 42210
monster.speed = 155
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
	illusionable = true,
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
	{ text = "Ungh! Ungh!", yell = false },
	{ text = "Klack klack!", yell = false },
	{ text = "Hugah!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 3315, chance = 23000 }, -- guardian halberd
	{ id = 40582, chance = 23000 }, -- crab man claws
	{ id = 239, chance = 5000 }, -- great health potion
	{ id = 822, chance = 5000 }, -- lightning legs
	{ id = 823, chance = 5000 }, -- glacier kilt
	{ id = 826, chance = 5000 }, -- magma coat
	{ id = 3038, chance = 5000 }, -- green gem
	{ id = 14042, chance = 5000 }, -- warriors shield
	{ id = 3332, chance = 1000 }, -- hammer of wrath
	{ id = 7456, chance = 1000 }, -- noble axe
	{ id = 3006, chance = 80000 }, -- ring of the sky
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -498 },
	{ name = "combat", interval = 3500, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -120, maxDamage = -320, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, target = true },
	{ name = "combat", interval = 2500, chance = 50, type = COMBAT_ENERGYDAMAGE, minDamage = -330, maxDamage = -380, range = 7, radius = 4, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_PURPLEENERGY, target = true },
	{ name = "combat", interval = 3000, chance = 65, type = COMBAT_ENERGYDAMAGE, minDamage = -311, maxDamage = -370, length = 3, spread = 3, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 80,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
