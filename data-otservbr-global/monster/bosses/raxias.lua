local mType = Game.createMonsterType("Raxias")
local monster = {}

monster.description = "a raxias"
monster.experience = 900
monster.outfit = {
	lookType = 980,
	lookHead = 79,
	lookBody = 95,
	lookLegs = 81,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 1100
monster.maxHealth = 1100
monster.race = "blood"
monster.corpse = 25814
monster.speed = 25
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 1624,
	bossRace = RARITY_NEMESIS,
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
	rewardBoss = true,
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
	{ text = "This is a nightmare and you won't wake up!", yell = false },
	{ text = "This was your last chance!", yell = false },
	{ text = "Blood, fight and rage!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 143 }, -- gold coin
	{ id = 25694, chance = 80000 }, -- fairy wings
	{ id = 25735, chance = 80000, maxCount = 6 }, -- leaf star
	{ id = 3728, chance = 80000 }, -- dark mushroom
	{ id = 236, chance = 80000, maxCount = 2 }, -- strong health potion
	{ id = 3674, chance = 80000 }, -- goat grass
	{ id = 24383, chance = 80000, maxCount = 2 }, -- cave turnip
	{ id = 239, chance = 80000, maxCount = 2 }, -- great health potion
	{ id = 24962, chance = 80000 }, -- prismatic quartz
	{ id = 25693, chance = 80000 }, -- shimmering beetles
	{ id = 675, chance = 80000 }, -- small enchanted sapphire
	{ id = 1781, chance = 80000, maxCount = 5 }, -- small stone
	{ id = 9014, chance = 80000 }, -- leaf legs
	{ id = 3575, chance = 80000 }, -- wood cape
	{ id = 2953, chance = 80000 }, -- panpipes
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -180, range = 7, shootEffect = CONST_ANI_SNOWBALL, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_ENERGYDAMAGE, minDamage = 0, maxDamage = -175, length = 3, spread = 3, effect = CONST_ME_POFF, target = false },
}

monster.defenses = {
	defense = 33,
	armor = 28,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -1 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
