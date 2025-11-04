local mType = Game.createMonsterType("Elder Wyrm")
local monster = {}

monster.description = "an elder wyrm"
monster.experience = 2500
monster.outfit = {
	lookType = 561,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 963
monster.Bestiary = {
	class = "Dragon",
	race = BESTY_RACE_DRAGON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Drefia Wyrm Lair, Vandura Wyrm Cave, Oramond Factory Raids (west), Warzone 4.",
}

monster.health = 2700
monster.maxHealth = 2700
monster.race = "blood"
monster.corpse = 18966
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 250,
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
	{ text = "GRROARR", yell = true },
	{ text = "GRRR", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 180 }, -- Gold Coin
	{ id = 3035, chance = 25032, maxCount = 3 }, -- Platinum Coin
	{ id = 3583, chance = 34202, maxCount = 2 }, -- Dragon Ham
	{ id = 236, chance = 19744 }, -- Strong Health Potion
	{ id = 237, chance = 19972 }, -- Strong Mana Potion
	{ id = 3349, chance = 8285 }, -- Crossbow
	{ id = 9665, chance = 16993 }, -- Wyrm Scale
	{ id = 3028, chance = 4861, maxCount = 5 }, -- Small Diamond
	{ id = 5944, chance = 5161 }, -- Soul Orb
	{ id = 8093, chance = 1464 }, -- Wand of Draconia
	{ id = 816, chance = 789 }, -- Lightning Pendant
	{ id = 822, chance = 722 }, -- Lightning Legs
	{ id = 3450, chance = 967, maxCount = 10 }, -- Power Bolt
	{ id = 8092, chance = 724 }, -- Wand of Starstorm
	{ id = 820, chance = 203 }, -- Lightning Boots
	{ id = 825, chance = 217 }, -- Lightning Robe
	{ id = 7430, chance = 204 }, -- Dragonbone Staff
	{ id = 7451, chance = 173 }, -- Shadow Sceptre
	{ id = 8027, chance = 270 }, -- Composite Hornbow
	{ id = 50187, chance = 660 }, -- Legs of Wisdom
	{ id = 9304, chance = 114 }, -- Shockwave Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -360 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -90, maxDamage = -150, radius = 4, effect = CONST_ME_TELEPORT, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -140, maxDamage = -250, radius = 5, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -180, length = 8, spread = 3, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "elder wyrm wave", interval = 2000, chance = 10, minDamage = -200, maxDamage = -300, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 48,
	mitigation = 1.35,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 75 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
