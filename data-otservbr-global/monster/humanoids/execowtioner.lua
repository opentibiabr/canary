local mType = Game.createMonsterType("Execowtioner")
local monster = {}

monster.description = "an execowtioner"
monster.experience = 2400
monster.outfit = {
	lookType = 609,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1046
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Oramond Mountain Hideout, Oramond Minotaur Camp (northern camp), \z
		Underground Glooth Factory, Oramond Dungeon.",
}

monster.health = 3500
monster.maxHealth = 3500
monster.race = "blood"
monster.corpse = 21004
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 4,
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
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
	{ text = "I'm the one who puts the cute into execute!", yell = false },
	{ text = "I'm here to punish!", yell = false },
	{ text = "Justice is swift and unavoidable!", yell = false },
	{ text = "I'll bring justice!", yell = false },
	{ text = "There is excellence in execution!", yell = false },
	{ text = "Your sentence is death!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 198 }, -- Gold Coin
	{ id = 3035, chance = 65500, maxCount = 3 }, -- Platinum Coin
	{ id = 21201, chance = 16219 }, -- Execowtioner Mask
	{ id = 5878, chance = 15720 }, -- Minotaur Leather
	{ id = 239, chance = 10350 }, -- Great Health Potion
	{ id = 238, chance = 9910 }, -- Great Mana Potion
	{ id = 3577, chance = 8390 }, -- Meat
	{ id = 3030, chance = 5270, maxCount = 2 }, -- Small Ruby
	{ id = 11472, chance = 4900, maxCount = 2 }, -- Minotaur Horn
	{ id = 9057, chance = 4990, maxCount = 2 }, -- Small Topaz
	{ id = 5911, chance = 2830 }, -- Red Piece of Cloth
	{ id = 21176, chance = 1090 }, -- Execowtioner Axe
	{ id = 3318, chance = 780 }, -- Knight Axe
	{ id = 3381, chance = 610 }, -- Crown Armor
	{ id = 7413, chance = 650 }, -- Titan Axe
	{ id = 7412, chance = 470 }, -- Butcher's Axe
	{ id = 9058, chance = 410 }, -- Gold Ingot
	{ id = 7401, chance = 290 }, -- Minotaur Trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 90, attack = 80 },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_LIFEDRAIN, minDamage = -135, maxDamage = -280, range = 7, radius = 5, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_DRAWBLOOD, target = true },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_PHYSICALDAMAGE, minDamage = -90, maxDamage = -200, range = 7, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_EXPLOSIONAREA, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 40,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
