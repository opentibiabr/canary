local mType = Game.createMonsterType("Banshee")
local monster = {}

monster.description = "a banshee"
monster.experience = 900
monster.outfit = {
	lookType = 78,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 78
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Single one under the White Flower Temple in Thais (respawn takes about 20-25 minutes), \z
		Banshee Quest area in Ghostlands (also accesible by Isle of the Kings), Demon Quest Room, Drefia, \z
		Ancient Ruins Tomb, Desert Dungeon (unreachable), Pits of Inferno in Tafariel's Throne room, \z
		Cemetery Quarter in Yalahar, Vengoth Castle, one in Robson Isle.",
}

monster.health = 1000
monster.maxHealth = 1000
monster.race = "undead"
monster.corpse = 6019
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	runHealth = 500,
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
	{ text = "Dance for me your dance of death!", yell = false },
	{ text = "Let the music play!", yell = false },
	{ text = "I will mourn your death!", yell = false },
	{ text = "Are you ready to rock?", yell = false },
	{ text = "Feel my gentle kiss of death.", yell = false },
	{ text = "That's what I call easy listening!", yell = false },
	{ text = "IIIIEEEeeeeeehhhHHHH!", yell = false },
}

monster.loot = {
	{ id = 2917, chance = 68000 }, -- Candlestick
	{ id = 3031, chance = 27000, maxCount = 80 }, -- Gold Coin
	{ id = 3054, chance = 7800 }, -- Silver Amulet
	{ id = 3568, chance = 5900 }, -- Simple Dress
	{ id = 11446, chance = 4300 }, -- Hair of a Banshee
	{ id = 10420, chance = 4100 }, -- Petrified Scream
	{ id = 3027, chance = 2500 }, -- Black Pearl
	{ id = 3017, chance = 2100 }, -- Silver Brooch
	{ id = 3299, chance = 1400 }, -- Poison Dagger
	{ id = 3098, chance = 1300 }, -- Ring of Healing
	{ id = 3007, chance = 1200 }, -- Crystal Ring
	{ id = 3567, chance = 950 }, -- Blue Robe
	{ id = 3081, chance = 860 }, -- Stone Skin Amulet
	{ id = 237, chance = 780 }, -- Strong Mana Potion
	{ id = 3026, chance = 780 }, -- White Pearl
	{ id = 3004, chance = 690 }, -- Wedding Ring
	{ id = 2949, chance = 430 }, -- Lyre
	{ id = 3059, chance = 430 }, -- Spellbook
	{ id = 811, chance = 340 }, -- Terra Mantle
	{ id = 3061, chance = 86 }, -- Life Crystal
	{ id = 3566, chance = 70 }, -- Red Robe
	{ id = 12320, chance = 30 }, -- Sweet Smelling Bait
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100, condition = { type = CONDITION_POISON, totalDamage = 3, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -200, radius = 4, effect = CONST_ME_SOUND_RED, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_DEATHDAMAGE, minDamage = -55, maxDamage = -350, range = 1, radius = 1, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -300, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	mitigation = 1.74,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 120, maxDamage = 190, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
