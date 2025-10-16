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
	{ id = 3031, chance = 80000, maxCount = 154 }, -- gold coin
	{ id = 11491, chance = 23000 }, -- quara bone
	{ id = 7378, chance = 23000, maxCount = 7 }, -- royal spear
	{ id = 3028, chance = 5000, maxCount = 2 }, -- small diamond
	{ id = 3581, chance = 5000, maxCount = 5 }, -- shrimp
	{ id = 3275, chance = 5000 }, -- double axe
	{ id = 5895, chance = 5000 }, -- fish fin
	{ id = 239, chance = 1000 }, -- great health potion
	{ id = 7383, chance = 1000 }, -- relic sword
	{ id = 7368, chance = 1000 }, -- assassin star
	{ id = 824, chance = 1000 }, -- glacier robe
	{ id = 5741, chance = 260 }, -- skull helmet
	{ id = 12318, chance = 260 }, -- giant shrimp
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
