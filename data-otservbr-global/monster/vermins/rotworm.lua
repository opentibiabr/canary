local mType = Game.createMonsterType("Rotworm")
local monster = {}

monster.description = "a rotworm"
monster.experience = 40
monster.outfit = {
	lookType = 26,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 26
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Almost everywhere, like Ancient Temple, Vandura, Folda dungeon, Fibula Dungeon, \z
		caves connecting Edron and Cormaya, Venore Swamp Troll cave, Thais Troll cave, Ferngrims Gate, \z
		Dwarf Mines, Hellgate, below the graves in eastern Rookgaard, spider cave in western Rookgaard, \z
		cave northeast of Ab'Dendriel, Darashia Rotworm Caves, Liberty Bay, Fenrock, \z
		below Green Claw Swamp and some other places.",
}

monster.health = 65
monster.maxHealth = 65
monster.race = "blood"
monster.corpse = 5967
monster.speed = 58
monster.manaCost = 305

monster.changeTarget = {
	interval = 4000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
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
}

monster.loot = {
	{ id = 3031, chance = 71900, maxCount = 17 }, -- Gold Coin
	{ id = 3582, chance = 20532 }, -- Ham
	{ id = 9692, chance = 10631 }, -- Lump of Dirt
	{ id = 3577, chance = 19556 }, -- Meat
	{ id = 3286, chance = 4602 }, -- Mace
	{ id = 3264, chance = 3264 }, -- Sword
	{ id = 3492, chance = 5459, maxCount = 3 }, -- Worm
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -40 },
}

monster.defenses = {
	defense = 10,
	armor = 8,
	mitigation = 0.28,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
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
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
