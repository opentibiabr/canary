local mType = Game.createMonsterType("Mahrdis")
local monster = {}

monster.description = "Mahrdis"
monster.experience = 3050
monster.outfit = {
	lookType = 86,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3900
monster.maxHealth = 3900
monster.race = "undead"
monster.corpse = 6025
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 86,
	bossRace = RARITY_BANE,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Fire Elemental", chance = 30, interval = 2000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Ashes to ashes!", yell = false },
	{ text = "Fire, Fire!", yell = false },
	{ text = "The eternal flame demands its due!", yell = false },
	{ text = "This is why I'm hot.", yell = false },
	{ text = "May my flames engulf you!", yell = false },
	{ text = "Burnnnnnnnnn!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 88740, maxCount = 230 }, -- Gold Coin
	{ id = 3240, chance = 100000 }, -- Burning Heart
	{ id = 239, chance = 10176 }, -- Great Health Potion
	{ id = 3052, chance = 6634 }, -- Life Ring
	{ id = 3030, chance = 12089, maxCount = 3 }, -- Small Ruby
	{ id = 3320, chance = 920 }, -- Fire Axe
	{ id = 3039, chance = 751 }, -- Red Gem
	{ id = 3024, chance = 140 }, -- Holy Falcon
	{ id = 10290, chance = 110 }, -- Mini Mummy
	{ id = 3439, chance = 170 }, -- Phoenix Shield
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400, condition = { type = CONDITION_POISON, totalDamage = 65, interval = 4000 } },
	{ name = "combat", interval = 1600, chance = 7, type = COMBAT_PHYSICALDAMAGE, minDamage = -60, maxDamage = -600, range = 1, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 1000, chance = 7, type = COMBAT_FIREDAMAGE, minDamage = -60, maxDamage = -600, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
	{ name = "speed", interval = 2000, chance = 13, speedChange = -850, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 50000 },
	{ name = "combat", interval = 2000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -80, maxDamage = -800, radius = 3, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "firefield", interval = 1000, chance = 12, radius = 4, effect = CONST_ME_BLOCKHIT, target = false },
	-- fire
	{ name = "condition", type = CONDITION_FIRE, interval = 2000, chance = 13, minDamage = -50, maxDamage = -500, length = 8, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 20,
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_HEALING, minDamage = 20, maxDamage = 800, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 45 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = -22 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
