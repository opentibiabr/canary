local mType = Game.createMonsterType("Fernfang")
local monster = {}

monster.description = "Fernfang"
monster.experience = 600
monster.outfit = {
	lookType = 206,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 400
monster.maxHealth = 400
monster.race = "blood"
monster.corpse = 18285
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 50,
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

monster.summon = {
	maxSummons = 3,
	summons = {
		{ name = "War Wolf", chance = 13, interval = 1000, count = 3 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You desecrated this place!", yell = false },
	{ text = "Yoooohuuuu!", yell = false },
	{ text = "I will cleanse this isle!", yell = false },
	{ text = "Grrrrrrr", yell = false },
}

monster.loot = {
	{ id = 9646, chance = 100000 }, -- Book of Prayers
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 98000, maxCount = 3 }, -- Platinum Coin
	{ id = 3736, chance = 92000 }, -- Star Herb
	{ id = 11492, chance = 57000 }, -- Rope Belt
	{ id = 3050, chance = 51000 }, -- Power Ring
	{ id = 3037, chance = 45000 }, -- Yellow Gem
	{ id = 11493, chance = 42000 }, -- Safety Pin
	{ id = 3147, chance = 18900 }, -- Blank Rune
	{ id = 3600, chance = 17000 }, -- Bread
	{ id = 237, chance = 15100 }, -- Strong Mana Potion
	{ id = 3012, chance = 11300 }, -- Wolf Tooth Chain
	{ id = 3563, chance = 11300 }, -- Green Tunic
	{ id = 2885, chance = 11300 }, -- Brown Flask
	{ id = 3289, chance = 9400 }, -- Staff
	{ id = 2914, chance = 9400 }, -- Lamp
	{ id = 3738, chance = 5700 }, -- Sling Herb
	{ id = 5786, chance = 5700 }, -- Wooden Whistle
	{ id = 3061, chance = 1900 }, -- Life Crystal
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -50 },
	{ name = "combat", interval = 1000, chance = 13, type = COMBAT_HOLYDAMAGE, minDamage = -65, maxDamage = -180, range = 7, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYDAMAGE, target = false },
	{ name = "combat", interval = 1000, chance = 25, type = COMBAT_MANADRAIN, minDamage = -20, maxDamage = -45, range = 7, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 10,
	armor = 15,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 10, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 7, speedChange = 280, effect = CONST_ME_MAGIC_RED, target = false, duration = 10000 },
	{ name = "outfit", interval = 1000, chance = 5, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 14000, outfitMonster = "War Wolf" },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 70 },
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
