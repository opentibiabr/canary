local mType = Game.createMonsterType("Serpent Spawn")
local monster = {}

monster.description = "a serpent spawn"
monster.experience = 3050
monster.outfit = {
	lookType = 220,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 220
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Deeper Banuta, Forbidden Islands: Talahu (Medusa Cave) and Kharos (at level -1), Razzachai, \z
		Deep below the Crystal Lakes in Foreigner Quarter, Cult's cave in the Magician Quarter, Medusa Tower.",
}

monster.health = 3000
monster.maxHealth = 3000
monster.race = "venom"
monster.corpse = 6061
monster.speed = 117
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 30,
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 275,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "HISSSS", yell = true },
	{ text = "I bring you deathhhh, mortalssss", yell = false },
	{ text = "Sssssouls for the one", yell = false },
	{ text = "Tsssse one will risssse again", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 239 }, -- gold coin
	{ id = 3732, chance = 23000 }, -- green mushroom
	{ id = 9694, chance = 23000 }, -- snake skin
	{ id = 3029, chance = 23000 }, -- small sapphire
	{ id = 3052, chance = 23000 }, -- life ring
	{ id = 3450, chance = 23000 }, -- power bolt
	{ id = 3051, chance = 23000 }, -- energy ring
	{ id = 2903, chance = 5000 }, -- golden mug
	{ id = 7386, chance = 5000 }, -- mercenary sword
	{ id = 238, chance = 5000 }, -- great mana potion
	{ id = 10313, chance = 1000 }, -- winged tail
	{ id = 3066, chance = 1000 }, -- snakebite rod
	{ id = 3428, chance = 1000 }, -- tower shield
	{ id = 3061, chance = 1000 }, -- life crystal
	{ id = 7456, chance = 1000 }, -- noble axe
	{ id = 3373, chance = 1000 }, -- strange helmet
	{ id = 36586, chance = 1000 }, -- old parchment
	{ id = 3369, chance = 1000 }, -- warrior helmet
	{ id = 3381, chance = 1000 }, -- crown armor
	{ id = 3407, chance = 260 }, -- charmers tiara
	{ id = 3392, chance = 260 }, -- royal helmet
	{ id = 8074, chance = 260 }, -- spellbook of mind control
	{ id = 8052, chance = 260 }, -- swamplair armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -252 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -80, maxDamage = -300, range = 7, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "outfit", interval = 2000, chance = 1, range = 7, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 3000, outfitMonster = "clay guardian" },
	{ name = "speed", interval = 2000, chance = 25, speedChange = -850, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_GREEN_RINGS, target = true, duration = 12000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -500, length = 8, spread = 3, effect = CONST_ME_SOUND_RED, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -500, length = 8, spread = 3, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 35,
	mitigation = 1.04,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 250, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 340, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
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
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
