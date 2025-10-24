local mType = Game.createMonsterType("Deepling Worker")
local monster = {}

monster.description = "a deepling worker"
monster.experience = 130
monster.outfit = {
	lookType = 470,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 795
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Fiehonja, Coral mine.",
}

monster.health = 190
monster.maxHealth = 190
monster.race = "blood"
monster.corpse = 14094
monster.speed = 65
monster.manaCost = 0

monster.faction = FACTION_DEEPLING
monster.enemyFactions = { FACTION_PLAYER, FACTION_DEATHLING }

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
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 20,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "Qjell afar gou jey!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 75530, maxCount = 25 }, -- Gold Coin
	{ id = 14017, chance = 7070 }, -- Deepling Scales
	{ id = 3578, chance = 12009, maxCount = 3 }, -- Fish
	{ id = 12683, chance = 500 }, -- Heavy Trident
	{ id = 12730, chance = 320 }, -- Eye of a Deepling
	{ id = 5895, chance = 330 }, -- Fish Fin
	{ id = 3032, chance = 130 }, -- Small Emerald
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -80, effect = CONST_ME_DRAWBLOOD },
}

monster.defenses = {
	defense = 10,
	armor = 7,
	mitigation = 0.46,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
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
