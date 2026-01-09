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
	{ id = 3035, chance = 100000 }, -- Platinum Coin
	{ id = 31441, chance = 8416 }, -- Lamassu Hoof
	{ id = 31442, chance = 13992 }, -- Lamassu Horn
	{ id = 814, chance = 8098 }, -- Terra Amulet
	{ id = 16120, chance = 10916, maxCount = 2 }, -- Violet Crystal Shard
	{ id = 16119, chance = 10620, maxCount = 2 }, -- Blue Crystal Shard
	{ id = 3039, chance = 16620, maxCount = 2 }, -- Red Gem
	{ id = 830, chance = 6709 }, -- Terra Hood
	{ id = 16126, chance = 10849 }, -- Red Crystal Fragment
	{ id = 3032, chance = 5709 }, -- Small Emerald
	{ id = 22194, chance = 6740 }, -- Opal
	{ id = 3036, chance = 1949 }, -- Violet Gem
	{ id = 3041, chance = 1659 }, -- Blue Gem
	{ id = 3082, chance = 1920 }, -- Elven Amulet
	{ id = 9302, chance = 1980 }, -- Sacred Tree Amulet
	{ id = 16121, chance = 1060 }, -- Green Crystal Shard
	{ id = 16122, chance = 3220 }, -- Green Crystal Splinter
	{ id = 25737, chance = 3520, maxCount = 2 }, -- Rainbow Quartz
	{ id = 16127, chance = 3520 }, -- Green Crystal Fragment
	{ id = 22193, chance = 4260 }, -- Onyx Chip
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
