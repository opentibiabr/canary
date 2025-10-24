local mType = Game.createMonsterType("Vile Grandmaster")
local monster = {}

monster.description = "a vile grandmaster"
monster.experience = 1500
monster.outfit = {
	lookType = 268,
	lookHead = 59,
	lookBody = 19,
	lookLegs = 95,
	lookFeet = 94,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1147
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

monster.health = 1700
monster.maxHealth = 1700
monster.race = "blood"
monster.corpse = 22023
monster.speed = 140
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
	{ text = "Is that the best, you can throw at me?", yell = false },
	{ text = "I've seen orcs tougher than you!", yell = false },
	{ text = "I will end this now!", yell = false },
	{ text = "Your gods won't help you!", yell = false },
	{ text = "You'll make a fine trophy!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 99939, maxCount = 172 }, -- Gold Coin
	{ id = 3035, chance = 73730, maxCount = 2 }, -- Platinum Coin
	{ id = 3577, chance = 9630 }, -- Meat
	{ id = 239, chance = 7020 }, -- Great Health Potion
	{ id = 11510, chance = 7870 }, -- Scroll of Heroic Deeds
	{ id = 3004, chance = 5130 }, -- Wedding Ring
	{ id = 3029, chance = 3610 }, -- Small Sapphire
	{ id = 3030, chance = 3580 }, -- Small Ruby
	{ id = 11450, chance = 2390 }, -- Small Notebook
	{ id = 3279, chance = 2060 }, -- War Hammer
	{ id = 5911, chance = 2150 }, -- Red Piece of Cloth
	{ id = 3381, chance = 1160 }, -- Crown Armor
	{ id = 3382, chance = 770 }, -- Crown Legs
	{ id = 3280, chance = 860 }, -- Fire Sword
	{ id = 3385, chance = 610 }, -- Crown Helmet
	{ id = 3055, chance = 389 }, -- Platinum Amulet
	{ id = 3419, chance = 310 }, -- Crown Shield
	{ id = 2995, chance = 140 }, -- Piggy Bank
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 10, maxDamage = -260 },
	-- bleed
	{ name = "condition", type = CONDITION_BLEEDING, interval = 2000, chance = 20, minDamage = -150, maxDamage = -225, radius = 4, shootEffect = CONST_ANI_THROWINGKNIFE, effect = CONST_ME_DRAWBLOOD, target = true },
}

monster.defenses = {
	defense = 50,
	armor = 40,
	mitigation = 1.48,
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 220, maxDamage = 280, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 25 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
