local mType = Game.createMonsterType("Infernal Demon")
local monster = {}

monster.description = "an infernal demon"
monster.experience = 17430
monster.outfit = {
	lookType = 1313,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1938
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Claustrophobic Inferno.",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 32000
monster.maxHealth = 32000
monster.race = "blood"
monster.corpse = 33901
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	canPushCreatures = false,
	staticAttackChance = 90,
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
	{ text = "The smell of fear follows you.", yell = false },
	{ text = "Your soul will burn.", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 7643, chance = 23000, maxCount = 5 }, -- ultimate health potion
	{ id = 3028, chance = 23000 }, -- small diamond
	{ id = 9058, chance = 23000 }, -- gold ingot
	{ id = 16119, chance = 23000 }, -- blue crystal shard
	{ id = 16125, chance = 23000 }, -- cyan crystal fragment
	{ id = 16126, chance = 23000 }, -- red crystal fragment
	{ id = 817, chance = 5000 }, -- magma amulet
	{ id = 818, chance = 5000 }, -- magma boots
	{ id = 3041, chance = 5000 }, -- blue gem
	{ id = 3281, chance = 5000 }, -- giant sword
	{ id = 3342, chance = 5000 }, -- war axe
	{ id = 7386, chance = 5000 }, -- mercenary sword
	{ id = 16127, chance = 5000 }, -- green crystal fragment
	{ id = 22193, chance = 5000 }, -- onyx chip
	{ id = 3081, chance = 1000 }, -- stone skin amulet
	{ id = 34109, chance = 260 }, -- bag you desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1450 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -1150, maxDamage = -1400, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -800, maxDamage = -1250, length = 8, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -1000, maxDamage = -1350, radius = 4, effect = CONST_ME_MORTAREA, target = false },
	{ name = "death chain", interval = 2000, chance = 20, minDamage = -1100, maxDamage = -1380, target = true },
}

monster.defenses = {
	defense = 120,
	armor = 120,
	mitigation = 3.33,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
