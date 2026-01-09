local mType = Game.createMonsterType("Grynch Clan Goblin")
local monster = {}

monster.description = "a grynch clan goblin"
monster.experience = 4
monster.outfit = {
	lookType = 61,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 393
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 5,
	FirstUnlock = 2,
	SecondUnlock = 3,
	CharmsPoints = 10,
	Stars = 1,
	Occurrence = 3,
	Locations = "They do not have a set respawn spot. They are announced to be stealing presents from a \z
			random Tibian city and spawn in the aforetold city. \z
			There are two or three messages that appear on each raid and three massive spawns of goblins.",
}

monster.health = 80
monster.maxHealth = 80
monster.race = "blood"
monster.corpse = 6002
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
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
	hostile = false,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 0,
	targetDistance = 11,
	runHealth = 80,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "T'was not me hand in your pocket!", yell = false },
	{ text = "Look! Cool stuff in house. Let's get it!", yell = false },
	{ text = "Uhh! Nobody home! <chuckle>", yell = false },
	{ text = "Me just borrowed it!", yell = false },
	{ text = "Me no steal! Me found it!", yell = false },
	{ text = "Me had it for five minutes. It's family heirloom now!", yell = false },
	{ text = "Nice human won't hurt little, good goblin?", yell = false },
	{ text = "Gimmegimme!", yell = false },
	{ text = "Invite me in you lovely house plx!", yell = false },
	{ text = "Other Goblin stole it!", yell = false },
	{ text = "All presents mine!", yell = false },
	{ text = "Me got ugly ones purse", yell = false },
	{ text = "Free itans plz!", yell = false },
	{ text = "Not me! Not me!", yell = false },
	{ text = "Guys, help me here! Guys? Guys???", yell = false },
	{ text = "That only much dust in me pocket! Honest!", yell = false },
	{ text = "Can me have your stuff?", yell = false },
	{ text = "Halp, Big dumb one is after me!", yell = false },
	{ text = "Uh, So many shiny things!", yell = false },
	{ text = "Utani hur hur hur!", yell = false },
	{ text = "Mee? Stealing? Never!!!", yell = false },
	{ text = "Oh what fun it is to steal a one-horse open sleigh!", yell = false },
	{ text = "Must have it! Must have it!", yell = false },
	{ text = "Where me put me lockpick?", yell = false },
	{ text = "Catch me if you can!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 55270, maxCount = 16 }, -- Gold Coin
	{ id = 6496, chance = 30182 }, -- Christmas Present Bag
	{ id = 2992, chance = 15120, maxCount = 3 }, -- Snowball
	{ id = 3598, chance = 7920, maxCount = 5 }, -- Cookie
	{ id = 3585, chance = 9920, maxCount = 3 }, -- Red Apple
	{ id = 6276, chance = 4930 }, -- Lump of Cake Dough
	{ id = 3586, chance = 5120, maxCount = 2 }, -- Orange
	{ id = 836, chance = 2000, maxCount = 4 }, -- Walnut
	{ id = 841, chance = 940, maxCount = 5 }, -- Peanut
	{ id = 2875, chance = 520 }, -- Bottle
	{ id = 3572, chance = 770 }, -- Scarf
	{ id = 3599, chance = 990, maxCount = 3 }, -- Candy Cane
	{ id = 3606, chance = 1070, maxCount = 2 }, -- Egg
	{ id = 4871, chance = 510 }, -- Explorer Brooch
	{ id = 5894, chance = 600, maxCount = 3 }, -- Bat Wing
	{ id = 10207, chance = 959 }, -- Snowman Package
	{ id = 3590, chance = 310, maxCount = 4 }, -- Cherry
	{ id = 6393, chance = 110 }, -- Cream Cake
	{ id = 2950, chance = 100 }, -- Lute
	{ id = 3147, chance = 110 }, -- Blank Rune
	{ id = 3046, chance = 110 }, -- Magic Light Wand
	{ id = 2639, chance = 110 }, -- Picture (Landscape)
	{ id = 6500, chance = 420 }, -- Gingerbreadman
	{ id = 5890, chance = 410, maxCount = 3 }, -- Chicken Feather
	{ id = 5902, chance = 350 }, -- Honeycomb
	{ id = 6392, chance = 100 }, -- Valentine's Cake
	{ id = 2906, chance = 119 }, -- Watch
	{ id = 3454, chance = 410 }, -- Broom
	{ id = 2995, chance = 90 }, -- Piggy Bank
	{ id = 5792, chance = 130 }, -- Die
	{ id = 3463, chance = 80 }, -- Mirror
	{ id = 2392, chance = 70 }, -- Small White Pillow
	{ id = 2983, chance = 100 }, -- Flower Bowl
	{ id = 3042, chance = 90 }, -- Scarab Coin
	{ id = 5021, chance = 80 }, -- Orichalcum Pearl
	{ id = 3003, chance = 70 }, -- Rope
}

monster.attacks = {}

monster.defenses = {
	defense = 12,
	armor = 5,
	mitigation = 0.25,
	{ name = "speed", interval = 1000, chance = 15, speedChange = 500, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
