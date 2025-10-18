local mType = Game.createMonsterType("Giant Spider")
local monster = {}

monster.description = "a giant spider"
monster.experience = 900
monster.outfit = {
	lookType = 38,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 38
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Plains of Havoc, Point of no Return in Outlaw Camp, Ghostlands, Hellgate, \z
	Mintwallin Secret Laboratory, Mad Mage Room deep below Ancient Temple, Mount Sternum Undead Cave, \z
	Green Claw Swamp, Maze of Lost Souls, Crusader Helmet Quest in the Dwarf Mines, Mushroom Gardens, \z
	west Drillworm Caves, Edron Hero Cave, Edron Orc Cave, on a hill near Drefia, \z
	on a hill north-west of Ankrahmun (inaccessible), Forbidden Lands, Deeper Banuta, Malada, Ramoa, \z
	 Arena and Zoo Quarter, second floor up of Cemetery Quarter, beneath Fenrock, Vengoth Castle, \z
	 Vandura Mountain, in a cave in Robson Isle, Chyllfroest, Spider Caves, second floor of Krailos Spider Lair, Caverna Exanima.",
}

monster.health = 1300
monster.maxHealth = 1300
monster.race = "venom"
monster.corpse = 5977
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 20,
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
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Poison Spider", chance = 10, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 96790, maxCount = 195 }, -- Gold Coin
	{ id = 3448, chance = 69210, maxCount = 12 }, -- Poison Arrow
	{ id = 3357, chance = 10074 }, -- Plate Armor
	{ id = 3557, chance = 7890 }, -- Plate Legs
	{ id = 3265, chance = 5080 }, -- Two Handed Sword
	{ id = 5879, chance = 1894 }, -- Spider Silk
	{ id = 3351, chance = 5343 }, -- Steel Helmet
	{ id = 236, chance = 1010 }, -- Strong Health Potion
	{ id = 3370, chance = 349 }, -- Knight Armor
	{ id = 3371, chance = 383 }, -- Knight Legs
	{ id = 3053, chance = 784 }, -- Time Ring
	{ id = 828, chance = 108 }, -- Lightning Headband
	{ id = 3055, chance = 191 }, -- Platinum Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300, condition = { type = CONDITION_POISON, totalDamage = 160, interval = 4000 } },
	{ name = "poisonfield", interval = 2000, chance = 10, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -40, maxDamage = -70, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, target = true },
}

monster.defenses = {
	defense = 0,
	armor = 30,
	mitigation = 1.04,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 390, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
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
