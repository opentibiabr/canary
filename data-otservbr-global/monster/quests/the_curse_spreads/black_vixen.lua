local mType = Game.createMonsterType("Black Vixen")
local monster = {}

monster.description = "a black vixen"
monster.experience = 3200
monster.outfit = {
	lookType = 1038,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3200
monster.maxHealth = 3200
monster.race = "blood"
monster.corpse = 27714
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1559,
	bossRace = RARITY_ARCHFOE,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 3,
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

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "werefox", chance = 20, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You are not clever enough to defeat me!", yell = false },
	{ text = "The slyness of foxes will deceive the unwary!", yell = false },
}

monster.loot = {
	{ id = 27462, chance = 100000 }, -- Fox Paw
	{ id = 3035, chance = 100000, maxCount = 10 }, -- Platinum Coin
	{ id = 27463, chance = 100000 }, -- Werefox Tail
	{ id = 3027, chance = 36436, maxCount = 2 }, -- Black Pearl
	{ id = 7368, chance = 81199, maxCount = 10 }, -- Assassin Star
	{ id = 3031, chance = 79354, maxCount = 70 }, -- Gold Coin
	{ id = 238, chance = 40217, maxCount = 2 }, -- Great Mana Potion
	{ id = 7642, chance = 40735, maxCount = 2 }, -- Great Spirit Potion
	{ id = 23374, chance = 15372, maxCount = 2 }, -- Ultimate Spirit Potion
	{ id = 3049, chance = 9530 }, -- Stealth Ring
	{ id = 10389, chance = 1350 }, -- Traditional Sai
	{ id = 3038, chance = 22597 }, -- Green Gem
	{ id = 677, chance = 28248, maxCount = 3 }, -- Small Enchanted Emerald
	{ id = 23373, chance = 13526, maxCount = 2 }, -- Ultimate Mana Potion
	{ id = 27706, chance = 5683 }, -- Werefox Trophy
	{ id = 3070, chance = 7837 }, -- Moonlight Rod
	{ id = 22083, chance = 2691 }, -- Moonlight Crystals
	{ id = 3741, chance = 5685 }, -- Troll Green
	{ id = 22060, chance = 2769 }, -- Werewolf Amulet
	{ id = 8027, chance = 1077 }, -- Composite Hornbow
	{ id = 22516, chance = 1919 }, -- Silver Token
	{ id = 14142, chance = 140 }, -- Foxtail
	{ id = 22084, chance = 140 }, -- Wolf Backpack
	{ id = 3055, chance = 230 }, -- Platinum Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -290 },
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 100, maxDamage = 720, range = 7, shootEffect = CONST_ANI_THROWINGSTAR, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -600, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
	{ name = "combat", interval = 1000, chance = 14, type = COMBAT_DEATHDAMAGE, minDamage = -100, maxDamage = -700, length = 5, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "outfit", interval = 1000, chance = 1, radius = 1, target = true, duration = 2000, outfitMonster = "werewolf" },
}

monster.defenses = {
	defense = 45,
	armor = 40,
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 150, maxDamage = 345, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -40 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
