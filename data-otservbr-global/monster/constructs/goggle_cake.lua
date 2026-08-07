local mType = Game.createMonsterType("Goggle Cake")
local monster = {}

monster.description = "a goggle cake"
monster.experience = 2700
monster.outfit = {
	lookType = 1740,
	lookHead = 0,
	lookBody = 10,
	lookLegs = 115,
	lookFeet = 54,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2534
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Dessert Dungeons.",
}

monster.health = 2700
monster.maxHealth = 2700
monster.race = "undead"
monster.corpse = 48271
monster.speed = 122
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
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
	{ text = "Give me your sweets! They are mine to devour!", yell = false },
	{ text = "Hm? Where ... where are you now?", yell = false },
	{ text = "Hunger!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 80000, maxCount = 17 }, -- Platinum Coin
	{ id = 675, chance = 7000, maxCount = 5 }, -- Small Enchanted Sapphire
	{ id = 3292, chance = 5800 }, -- Combat Knife
	{ id = 238, chance = 5700 }, -- Great Mana Potion
	{ id = 25737, chance = 3800, maxCount = 3 }, -- Rainbow Quartz
	{ id = 3029, chance = 3700, maxCount = 2 }, -- Small Sapphire
	{ id = 3039, chance = 2600 }, -- Red Gem
	{ id = 8042, chance = 1800 }, -- Spirit Cloak
	{ id = 48116, chance = 1500 }, -- Gummy Rotworm
	{ id = 48254, chance = 1500 }, -- Churro Heart
	{ id = 3606, chance = 1100 }, -- Egg
	{ id = 815, chance = 920 }, -- Glacier Amulet
	{ id = 3603, chance = 720 }, -- Flour
	{ id = 48249, chance = 690, maxCount = 19 }, -- Milk Chocolate Coin
	{ id = 3598, chance = 590, maxCount = 2 }, -- Cookie
	{ id = 824, chance = 570 }, -- Glacier Robe
	{ id = 3326, chance = 440 }, -- Epee
	{ id = 3284, chance = 220 }, -- Ice Rapier
	{ id = 6393, chance = 170 }, -- Cream Cake
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -170, maxDamage = -300, range = 7, shootEffect = CONST_ANI_CHERRYBOMB, effect = CONST_ME_STARBURST, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -120, maxDamage = -260, range = 6, shootEffect = CONST_ANI_CHERRYBOMB, effect = CONST_ME_CREAM, target = true },
}

monster.defenses = {
	defense = 38,
	armor = 38,
	mitigation = 0.99,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 105 },
	{ type = COMBAT_FIREDAMAGE, percent = 110 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
