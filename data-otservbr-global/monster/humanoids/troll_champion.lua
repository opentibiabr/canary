local mType = Game.createMonsterType("Troll Champion")
local monster = {}

monster.description = "a troll champion"
monster.experience = 40
monster.outfit = {
	lookType = 281,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 392
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Edron Troll-Goblin Peninsula, Ab'dendriel Shadow Caves, Thais South-East Troll Caves, \z
		Dusalk's Troll Clan Cave, Island of Destiny in Paladin's guild.",
}

monster.health = 75
monster.maxHealth = 75
monster.race = "blood"
monster.corpse = 861
monster.speed = 69
monster.manaCost = 350

monster.changeTarget = {
	interval = 4000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 15,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Meee maity!", yell = false },
	{ text = "Grrrr", yell = false },
	{ text = "Whaaaz up!?", yell = false },
	{ text = "Gruntz!", yell = false },
	{ text = "Groar", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 12 }, -- gold coin
	{ id = 3277, chance = 80000 }, -- spear
	{ id = 3552, chance = 23000 }, -- leather boots
	{ id = 3577, chance = 23000 }, -- meat
	{ id = 3336, chance = 5000 }, -- studded club
	{ id = 3412, chance = 5000 }, -- wooden shield
	{ id = 3447, chance = 5000, maxCount = 5 }, -- arrow
	{ id = 9689, chance = 5000 }, -- bunch of troll hair
	{ id = 11515, chance = 1000 }, -- trollroot
	{ id = 3054, chance = 260 }, -- silver amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -35 },
}

monster.defenses = {
	defense = 20,
	armor = 10,
	mitigation = 0.28,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
