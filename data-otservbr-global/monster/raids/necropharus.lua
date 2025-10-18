local mType = Game.createMonsterType("Necropharus")
local monster = {}

monster.description = "Necropharus"
monster.experience = 1050
monster.outfit = {
	lookType = 209,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 750
monster.maxHealth = 750
monster.race = "blood"
monster.corpse = 18293
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	maxSummons = 6,
	summons = {
		{ name = "Ghoul", chance = 20, interval = 1000, count = 2 },
		{ name = "Ghost", chance = 17, interval = 1000, count = 2 },
		{ name = "Mummy", chance = 15, interval = 1000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You will rise as my servant!", yell = false },
	{ text = "Praise to my master Urgith!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 99 }, -- Gold Coin
	{ id = 10320, chance = 97440 }, -- Book of Necromantic Rituals
	{ id = 11475, chance = 92860 }, -- Necromantic Robe
	{ id = 3337, chance = 35716 }, -- Bone Club
	{ id = 3441, chance = 9521 }, -- Bone Shield
	{ id = 3294, chance = 2560 }, -- Short Sword
	{ id = 3377, chance = 1000 }, -- Scale Armor
	{ id = 3114, chance = 14285 }, -- Skull (Item)
	{ id = 3116, chance = 5130 }, -- Big Bone
	{ id = 3732, chance = 26189 }, -- Green Mushroom
	{ id = 3311, chance = 54761 }, -- Clerical Mace
	{ id = 3574, chance = 11907 }, -- Mystic Turban
	{ id = 3066, chance = 1000 }, -- Snakebite Rod
	{ id = 3070, chance = 7690 }, -- Moonlight Rod
	{ id = 2902, chance = 1000 }, -- Bowl
	{ id = 3661, chance = 1000 }, -- Grave Flower
	{ id = 3324, chance = 41030 }, -- Skull Staff
	{ id = 3079, chance = 2560 }, -- Boots of Haste
	{ id = 237, chance = 4757 }, -- Strong Mana Potion
	{ id = 5809, chance = 100000 }, -- Soul Stone
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -80, condition = { type = CONDITION_POISON, totalDamage = 8, interval = 4000 } },
	{ name = "combat", interval = 3000, chance = 70, type = COMBAT_PHYSICALDAMAGE, minDamage = -60, maxDamage = -217, range = 5, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -80, maxDamage = -120, range = 1, target = false },
	{ name = "combat", interval = 1000, chance = 17, type = COMBAT_FIREDAMAGE, minDamage = -50, maxDamage = -140, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 1000, chance = 17, type = COMBAT_ENERGYDAMAGE, minDamage = -50, maxDamage = -140, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	mitigation = 1.18,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 0, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, target = false },
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
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
