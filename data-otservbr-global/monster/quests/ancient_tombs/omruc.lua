local mType = Game.createMonsterType("Omruc")
local monster = {}

monster.description = "Omruc"
monster.experience = 2950
monster.outfit = {
	lookType = 90,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 4300
monster.maxHealth = 4300
monster.race = "undead"
monster.corpse = 6025
monster.speed = 185
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 90,
	bossRace = RARITY_BANE,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 20,
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
	targetDistance = 4,
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
		{ name = "Stalker", chance = 100, interval = 2000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Now chhhou shhhee me ... Now chhhou don't.", yell = false },
	{ text = "Chhhhou are marked ashhh my prey.", yell = false },
	{ text = "Catchhhh me if chhhou can.", yell = false },
	{ text = "Die!", yell = false },
	{ text = "Psssst, I am over chhhere.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 86010, maxCount = 160 }, -- Gold Coin
	{ id = 3585, chance = 82520, maxCount = 2 }, -- Red Apple
	{ id = 3447, chance = 19580, maxCount = 21 }, -- Arrow
	{ id = 3448, chance = 60140, maxCount = 20 }, -- Poison Arrow
	{ id = 3449, chance = 45450, maxCount = 15 }, -- Burst Arrow
	{ id = 7365, chance = 34270, maxCount = 2 }, -- Onyx Arrow
	{ id = 3450, chance = 13990, maxCount = 3 }, -- Power Bolt
	{ id = 3028, chance = 10273, maxCount = 3 }, -- Small Diamond
	{ id = 3239, chance = 100000 }, -- Crystal Arrow
	{ id = 239, chance = 8390 }, -- Great Health Potion
	{ id = 3049, chance = 3500 }, -- Stealth Ring
	{ id = 3037, chance = 1000 }, -- Yellow Gem
	{ id = 3079, chance = 700 }, -- Boots of Haste
	{ id = 10290, chance = 1400 }, -- Mini Mummy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -120, condition = { type = CONDITION_POISON, totalDamage = 65, interval = 4000 } },
	{ name = "combat", interval = 5000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -250, range = 1, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -500, shootEffect = CONST_ANI_POISONARROW, target = false },
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -120, maxDamage = -450, range = 3, shootEffect = CONST_ANI_BURSTARROW, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "melee", interval = 3000, chance = 20, minDamage = -150, maxDamage = -500 },
	{ name = "speed", interval = 1000, chance = 25, speedChange = -900, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 50000 },
}

monster.defenses = {
	defense = 35,
	armor = 20,
	{ name = "combat", interval = 1000, chance = 17, type = COMBAT_HEALING, minDamage = 100, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 14, effect = CONST_ME_MAGIC_BLUE },
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
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
