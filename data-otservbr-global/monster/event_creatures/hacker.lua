local mType = Game.createMonsterType("Hacker")
local monster = {}

monster.description = "a hacker"
monster.experience = 45
monster.outfit = {
	lookType = 8,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 430
monster.maxHealth = 430
monster.race = "blood"
monster.corpse = 5980
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 429,
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
	{ text = "Feel the wrath of me dos attack!", yell = false },
	{ text = "You're next!", yell = false },
	{ text = "Gimme free gold!", yell = false },
	{ text = "Me sooo smart!", yell = false },
	{ text = "Me have a cheating link for you!", yell = false },
	{ text = "Me is GM!", yell = false },
	{ text = "Gimme your password!", yell = false },
	{ text = "Me just need the code!", yell = false },
	{ text = "Me not stink!", yell = false },
	{ text = "Me other char is highlevel!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 1000, maxCount = 12 }, -- Gold Coin
	{ id = 3582, chance = 1000 }, -- Ham
	{ id = 2914, chance = 1000 }, -- Lamp
	{ id = 6571, chance = 1000 }, -- Surprise Bag (Red)
	{ id = 6570, chance = 1000 }, -- Surprise Bag (Blue)
	{ id = 3269, chance = 1000 }, -- Halberd
	{ id = 3279, chance = 1000 }, -- War Hammer
	{ id = 3274, chance = 1000 }, -- Axe
	{ id = 3266, chance = 1000 }, -- Battle Axe
}

monster.attacks = {
	{ name = "melee", interval = 1000, chance = 100, minDamage = 0, maxDamage = -83 },
}

monster.defenses = {
	defense = 12,
	armor = 15,
	mitigation = 0.36,
	{ name = "speed", interval = 1000, chance = 15, speedChange = 290, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
	{ name = "outfit", interval = 10000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 500, outfitMonster = "pig" },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
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
