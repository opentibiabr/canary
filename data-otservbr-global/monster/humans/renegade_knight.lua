local mType = Game.createMonsterType("Renegade Knight")
local monster = {}

monster.description = "a renegade knight"
monster.experience = 1200
monster.outfit = {
	lookType = 268,
	lookHead = 97,
	lookBody = 113,
	lookLegs = 76,
	lookFeet = 98,
	lookAddons = 2,
	lookMount = 0,
}

monster.raceId = 1146
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Old Fortress (north of Edron), Old Masonry, Forbidden Temple (Carlin).",
}

monster.health = 1450
monster.maxHealth = 1450
monster.race = "blood"
monster.corpse = 22020
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
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
	canPushCreatures = false,
	staticAttackChance = 90,
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
	{ text = "I'll teach you a lesson!", yell = false },
	{ text = "Feel my steel!", yell = false },
	{ text = "Take this!", yell = false },
	{ text = "Let's see how good you are!", yell = false },
	{ text = "A challenge at last!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 99990, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 25400, maxCount = 2 }, -- Platinum Coin
	{ id = 3577, chance = 9260 }, -- Meat
	{ id = 239, chance = 7050 }, -- Great Health Potion
	{ id = 11510, chance = 6080 }, -- Scroll of Heroic Deeds
	{ id = 3265, chance = 5110 }, -- Two Handed Sword
	{ id = 3030, chance = 3680 }, -- Small Ruby
	{ id = 5911, chance = 1810 }, -- Red Piece of Cloth
	{ id = 11450, chance = 1550 }, -- Small Notebook
	{ id = 3279, chance = 990 }, -- War Hammer
	{ id = 3382, chance = 570 }, -- Crown Legs
	{ id = 3381, chance = 670 }, -- Crown Armor
	{ id = 3385, chance = 590 }, -- Crown Helmet
	{ id = 3280, chance = 520 }, -- Fire Sword
	{ id = 2995, chance = 120 }, -- Piggy Bank
	{ id = 3419, chance = 200 }, -- Crown Shield
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 10, maxDamage = -175 },
}

monster.defenses = {
	defense = 50,
	armor = 38,
	mitigation = 1.46,
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 35 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
