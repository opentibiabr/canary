local mType = Game.createMonsterType("Arachnophobica")
local monster = {}

monster.description = "an arachnophobica"
monster.experience = 4700
monster.outfit = {
	lookType = 1135,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1729
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Buried Cathedral, Haunted Cellar, Court of Summer, Court of Winter, Dream Labyrinth.",
}

monster.health = 5000
monster.maxHealth = 5000
monster.race = "blood"
monster.corpse = 30073
monster.speed = 200
monster.manaCost = 0

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
	{ text = "Tip tap tip tap!", yell = false },
	{ text = "Zip zip zip!!!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 14 }, -- platinum coin
	{ id = 7642, chance = 80000, maxCount = 3 }, -- great spirit potion
	{ id = 8031, chance = 23000 }, -- spider fangs
	{ id = 10306, chance = 23000 }, -- essence of a bad dream
	{ id = 3054, chance = 23000 }, -- silver amulet
	{ id = 3091, chance = 23000 }, -- sword ring
	{ id = 3062, chance = 5000 }, -- mind stone
	{ id = 3073, chance = 5000 }, -- wand of cosmic energy
	{ id = 3051, chance = 5000 }, -- energy ring
	{ id = 3052, chance = 5000 }, -- life ring
	{ id = 3092, chance = 5000 }, -- axe ring
	{ id = 817, chance = 5000 }, -- magma amulet
	{ id = 3060, chance = 5000 }, -- orb
	{ id = 3050, chance = 5000 }, -- power ring
	{ id = 3082, chance = 5000 }, -- elven amulet
	{ id = 8082, chance = 5000 }, -- underworld rod
	{ id = 6299, chance = 5000 }, -- death ring
	{ id = 23528, chance = 5000 }, -- collar of red plasma
	{ id = 23529, chance = 5000 }, -- ring of blue plasma
	{ id = 3083, chance = 5000 }, -- garlic necklace
	{ id = 9302, chance = 5000 }, -- sacred tree amulet
	{ id = 3098, chance = 5000 }, -- ring of healing
	{ id = 3055, chance = 5000 }, -- platinum amulet
	{ id = 5879, chance = 5000 }, -- spider silk
	{ id = 3045, chance = 1000 }, -- strange talisman
	{ id = 3058, chance = 1000 }, -- strange symbol
	{ id = 13990, chance = 1000 }, -- necklace of the deep
	{ id = 23527, chance = 260 }, -- collar of green plasma
	{ id = 3081, chance = 260 }, -- stone skin amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350 },
	{ name = "arachnophobicawavedice", interval = 2000, chance = 20, minDamage = -250, maxDamage = -350, target = false },
	{ name = "arachnophobicawaveenergy", interval = 2000, chance = 20, minDamage = -250, maxDamage = -350, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -350, radius = 4, effect = CONST_ME_BLOCKHIT, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -300, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false },
}

monster.defenses = {
	defense = 0,
	armor = 70,
	mitigation = 1.94,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 150, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -40 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
