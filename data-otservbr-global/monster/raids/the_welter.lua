local mType = Game.createMonsterType("The Welter")
local monster = {}

monster.description = "The Welter"
monster.experience = 11000
monster.outfit = {
	lookType = 563,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 964,
	bossRace = RARITY_NEMESIS,
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "blood"
monster.corpse = 18974
monster.speed = 128
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5,
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
	targetDistance = 1,
	runHealth = 300,
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
	maxSummons = 1,
	summons = {
		{ name = "spawn of the welter", chance = 16, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "FCHHHHH", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 150 }, -- Gold Coin
	{ id = 3035, chance = 88888, maxCount = 20 }, -- Platinum Coin
	{ id = 3029, chance = 28571, maxCount = 5 }, -- Small Sapphire
	{ id = 236, chance = 44444, maxCount = 3 }, -- Strong Health Potion
	{ id = 237, chance = 55555, maxCount = 3 }, -- Strong Mana Potion
	{ id = 3436, chance = 1000 }, -- Medusa Shield
	{ id = 281, chance = 71428 }, -- Giant Shimmering Pearl
	{ id = 3081, chance = 57142 }, -- Stone Skin Amulet
	{ id = 3079, chance = 1000 }, -- Boots of Haste
	{ id = 3392, chance = 25000 }, -- Royal Helmet
	{ id = 3369, chance = 25000 }, -- Warrior Helmet
	{ id = 4839, chance = 33333 }, -- Hydra Egg
	{ id = 9058, chance = 60000 }, -- Gold Ingot
	{ id = 3370, chance = 1000 }, -- Knight Armor
	{ id = 3284, chance = 1000 }, -- Ice Rapier
	{ id = 9302, chance = 33333 }, -- Sacred Tree Amulet
	{ id = 8074, chance = 33333 }, -- Spellbook of Mind Control
	{ id = 19356, chance = 1000 }, -- Triple Bolt Crossbow
	{ id = 19083, chance = 25000 }, -- Silver Raid Token
	{ id = 19357, chance = 1000 }, -- Shrunken Head Necklace
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 90, attack = 100 },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 17, minDamage = -500, maxDamage = -660, length = 8, spread = 3, effect = CONST_ME_SMALLPLANTS, target = false },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -450, length = 8, spread = 3, effect = CONST_ME_BLACKSMOKE, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_ICEDAMAGE, minDamage = -150, maxDamage = -270, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = true },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_ICEDAMAGE, minDamage = -120, maxDamage = -230, range = 1, radius = 1, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = true },
	{ name = "the welter paralyze", interval = 2000, chance = 9, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 27,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 32, type = COMBAT_HEALING, minDamage = 250, maxDamage = 600, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_HEALING, minDamage = 150, maxDamage = 700, radius = 5, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "the welter summon2", interval = 2000, chance = 9, target = false },
	{ name = "the welter heal", interval = 2000, chance = 8, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 25 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
