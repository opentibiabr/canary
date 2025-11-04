local mType = Game.createMonsterType("Quara Predator")
local monster = {}

monster.description = "a quara predator"
monster.experience = 1850
monster.outfit = {
	lookType = 20,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 237
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Calassa, Frozen Trench, Sunken Quarter, Alchemist Quarter (unreachable), \z
		The Inquisition Quest, Seacrest Grounds.",
}

monster.health = 2200
monster.maxHealth = 2200
monster.race = "blood"
monster.corpse = 6067
monster.speed = 225
monster.manaCost = 0

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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 2,
	color = 35,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Gnarrr!", yell = false },
	{ text = "Tcharrr!", yell = false },
	{ text = "Rrrah!", yell = false },
	{ text = "Rraaar!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 78040, maxCount = 154 }, -- Gold Coin
	{ id = 11491, chance = 9929 }, -- Quara Bone
	{ id = 7378, chance = 31968, maxCount = 7 }, -- Royal Spear
	{ id = 3028, chance = 4164, maxCount = 2 }, -- Small Diamond
	{ id = 3581, chance = 3526, maxCount = 5 }, -- Shrimp
	{ id = 3275, chance = 26206 }, -- Double Axe
	{ id = 5895, chance = 1471 }, -- Fish Fin
	{ id = 239, chance = 830 }, -- Great Health Potion
	{ id = 7383, chance = 450 }, -- Relic Sword
	{ id = 7368, chance = 768 }, -- Assassin Star
	{ id = 824, chance = 261 }, -- Glacier Robe
	{ id = 5741, chance = 768 }, -- Skull Helmet
	{ id = 12318, chance = 20 }, -- Giant Shrimp
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -473, effect = CONST_ME_DRAWBLOOD },
}

monster.defenses = {
	defense = 45,
	armor = 40,
	mitigation = 1.46,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 270, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 5000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 25, maxDamage = 75, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
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
