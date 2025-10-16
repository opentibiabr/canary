local mType = Game.createMonsterType("Lamassu")
local monster = {}

monster.description = "a lamassu"
monster.experience = 9000
monster.outfit = {
	lookType = 1190,
	lookHead = 50,
	lookBody = 2,
	lookLegs = 0,
	lookFeet = 76,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1806
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Kilmaresh.",
}

monster.health = 8700
monster.maxHealth = 8700
monster.race = "blood"
monster.corpse = 31394
monster.speed = 160
monster.manaCost = 0

monster.faction = FACTION_ANUMA
monster.enemyFactions = { FACTION_PLAYER, FACTION_FAFNAR }

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
	{ text = "Be gone, mortal! This is not your place!", yell = false },
	{ text = "I won't tolerate any sacrilege!", yell = false },
	{ text = "I guard this site in Suon's name!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 31441, chance = 23000 }, -- lamassu hoof
	{ id = 31442, chance = 23000 }, -- lamassu horn
	{ id = 814, chance = 23000 }, -- terra amulet
	{ id = 16120, chance = 23000, maxCount = 2 }, -- violet crystal shard
	{ id = 16119, chance = 23000, maxCount = 2 }, -- blue crystal shard
	{ id = 36706, chance = 23000, maxCount = 2 }, -- red gem
	{ id = 830, chance = 23000 }, -- terra hood
	{ id = 16126, chance = 23000 }, -- red crystal fragment
	{ id = 3032, chance = 23000 }, -- small emerald
	{ id = 22194, chance = 23000 }, -- opal
	{ id = 3036, chance = 5000 }, -- violet gem
	{ id = 3041, chance = 5000 }, -- blue gem
	{ id = 3082, chance = 5000 }, -- elven amulet
	{ id = 9302, chance = 5000 }, -- sacred tree amulet
	{ id = 16121, chance = 5000 }, -- green crystal shard
	{ id = 16122, chance = 5000 }, -- green crystal splinter
	{ id = 25737, chance = 5000, maxCount = 2 }, -- rainbow quartz
	{ id = 16127, chance = 5000 }, -- green crystal fragment
	{ id = 22193, chance = 5000 }, -- onyx chip
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -400, maxDamage = -500, radius = 1, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -300, maxDamage = -500, radius = 3, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -405, range = 5, radius = 2, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_SMALLPLANTS, target = true },
}

monster.defenses = {
	defense = 82,
	armor = 82,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -30 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
