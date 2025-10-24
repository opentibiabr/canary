local mType = Game.createMonsterType("Barbarian Brutetamer")
local monster = {}

monster.description = "a barbarian brutetamer"
monster.experience = 90
monster.outfit = {
	lookType = 264,
	lookHead = 78,
	lookBody = 97,
	lookLegs = 95,
	lookFeet = 121,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 332
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Krimhorn, Bittermor, Ragnir, and Fenrock.",
}

monster.health = 145
monster.maxHealth = 145
monster.race = "blood"
monster.corpse = 18058
monster.speed = 89
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
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
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 10,
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
		{ name = "War Wolf", chance = 10, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "To me, creatures of the wild!", yell = false },
	{ text = "My instincts tell me about your cowardice.", yell = false },
	{ text = "Feel the power of the beast!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 90180, maxCount = 15 }, -- Gold Coin
	{ id = 3289, chance = 7165 }, -- Staff
	{ id = 3358, chance = 9073 }, -- Chain Armor
	{ id = 3597, chance = 12811, maxCount = 2 }, -- Corncob
	{ id = 7343, chance = 7709 }, -- Fur Bag
	{ id = 2824, chance = 4816 }, -- Book (Grey)
	{ id = 3347, chance = 5501 }, -- Hunting Spear
	{ id = 268, chance = 656 }, -- Mana Potion
	{ id = 7379, chance = 285 }, -- Brutetamer's Staff
	{ id = 7457, chance = 139 }, -- Fur Boots
	{ id = 7463, chance = 218 }, -- Mammoth Fur Cape
	{ id = 7464, chance = 80 }, -- Mammoth Fur Shorts
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -20 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -34, range = 7, radius = 1, shootEffect = CONST_ANI_SNOWBALL, target = true },
	{ name = "barbarian brutetamer skill reducer", interval = 2000, chance = 15, range = 5, target = false },
}

monster.defenses = {
	defense = 0,
	armor = 8,
	mitigation = 0.36,
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_HEALING, minDamage = 50, maxDamage = 80, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
