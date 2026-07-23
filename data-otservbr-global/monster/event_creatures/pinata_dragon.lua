local mType = Game.createMonsterType("Pinata Dragon")
local monster = {}

monster.description = "a pinata dragon"
monster.experience = 50
monster.outfit = {
	lookTypeEx = 25062,
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "undead"
monster.corpse = 0
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 15,
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
	maxSummons = 3,
	summons = {
		{ name = "Demon", chance = 7, interval = 2000, count = 3 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You can't have my treasures!", yell = false },
	{ text = "Hit me one more time!", yell = false },
	{ text = "Na Nana Naaa Naaa!", yell = false },
	{ text = "You'll never get my stuff!", yell = false },
	{ text = "Do you really want to hurt me?", yell = false },
	{ text = "Bring it on!", yell = false },
}

monster.loot = {
	{ id = 6569, chance = 100000, maxCount = 5 }, -- Candy
	{ id = 3598, chance = 51000, maxCount = 9 }, -- Cookie
	{ id = 30202, chance = 13800 }, -- Winterberry Liquor
	{ id = 30198, chance = 9500 }, -- Meringue Cake
	{ id = 6574, chance = 8400 }, -- Bar of Chocolate
	{ id = 30315, chance = 6800 }, -- Pinata
	{ id = 24949, chance = 5300 }, -- Costume Bag (Retro)
	{ id = 30197, chance = 4800 }, -- Festive Backpack
	{ id = 6279, chance = 3900 }, -- Party Cake
	{ id = 24402, chance = 3600 }, -- Chocolatey Dragon Scale Legs
	{ id = 24397, chance = 2200 }, -- Ferumbras' Candy Hat
	{ id = 2991, chance = 1300 }, -- Doll
	{ id = 123, chance = 480 }, -- Toy Mouse
	{ id = 5791, chance = 360 }, -- Stuffed Dragon
	{ id = 30317, chance = 120 }, -- Ferumbras Puppet
	{ id = 6570, chance = 54000 }, -- Surprise Bag (Blue)
	{ id = 6571, chance = 54000 }, -- Surprise Bag (Red)
	{ id = 8853, chance = 54000 }, -- Suspicious Surprise Bag
}

monster.attacks = {}

monster.defenses = {
	defense = 1,
	armor = 1,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, effect = CONST_ME_MORTAREA, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
