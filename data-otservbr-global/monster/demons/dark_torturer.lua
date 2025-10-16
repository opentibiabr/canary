local mType = Game.createMonsterType("Dark Torturer")
local monster = {}

monster.description = "a dark torturer"
monster.experience = 4650
monster.outfit = {
	lookType = 234,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 285
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Pits of Inferno, Vengoth, The Inquisition Quest's Blood Halls, Oramond Dungeon, \z
	Oramond Fury Dungeon, Roshamuul Prison, Grounds of Damnation and Halls of Ascension.",
}

monster.health = 7350
monster.maxHealth = 7350
monster.race = "undead"
monster.corpse = 6327
monster.speed = 185
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
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
	{ text = "You like it, don't you?", yell = false },
	{ text = "IahaEhheAie!", yell = false },
	{ text = "It's party time!", yell = false },
	{ text = "Harrr, Harrr!", yell = false },
	{ text = "The torturer is in!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3582, chance = 80000, maxCount = 2 }, -- ham
	{ id = 3035, chance = 80000, maxCount = 8 }, -- platinum coin
	{ id = 6558, chance = 80000, maxCount = 3 }, -- flask of demonic blood
	{ id = 5944, chance = 23000 }, -- soul orb
	{ id = 238, chance = 23000, maxCount = 2 }, -- great mana potion
	{ id = 239, chance = 23000, maxCount = 2 }, -- great health potion
	{ id = 6499, chance = 23000 }, -- demonic essence
	{ id = 3554, chance = 5000 }, -- steel boots
	{ id = 3461, chance = 5000 }, -- saw
	{ id = 9058, chance = 5000 }, -- gold ingot
	{ id = 5021, chance = 5000, maxCount = 2 }, -- orichalcum pearl
	{ id = 7368, chance = 5000, maxCount = 5 }, -- assassin star
	{ id = 6299, chance = 5000 }, -- death ring
	{ id = 5479, chance = 5000 }, -- cats paw
	{ id = 5801, chance = 1000 }, -- jewelled backpack
	{ id = 7412, chance = 1000 }, -- butchers axe
	{ id = 7388, chance = 260 }, -- vile axe
	{ id = 3364, chance = 260 }, -- golden legs
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -781, range = 7, shootEffect = CONST_ANI_THROWINGKNIFE, target = false },
	{ name = "dark torturer skill reducer", interval = 2000, chance = 5, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 45,
	mitigation = 1.74,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 90 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
