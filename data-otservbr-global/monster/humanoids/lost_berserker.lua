local mType = Game.createMonsterType("Lost Berserker")
local monster = {}

monster.description = "a lost berserker"
monster.experience = 4800
monster.outfit = {
	lookType = 496,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 888
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Warzones 2 and 3.",
}

monster.health = 5900
monster.maxHealth = 5900
monster.race = "blood"
monster.corpse = 16071
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
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
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Kill! Kiill! Kill!", yell = false },
	{ text = "Death! Death! Death!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 99980, maxCount = 9 }, -- Platinum Coin
	{ id = 16123, chance = 7709, maxCount = 2 }, -- Brown Crystal Splinter
	{ id = 3725, chance = 15130, maxCount = 2 }, -- Brown Mushroom
	{ id = 16142, chance = 8010, maxCount = 10 }, -- Drill Bolt
	{ id = 239, chance = 13680 }, -- Great Health Potion
	{ id = 238, chance = 14070 }, -- Great Mana Potion
	{ id = 16127, chance = 6610 }, -- Green Crystal Fragment
	{ id = 5880, chance = 8720 }, -- Iron Ore
	{ id = 9057, chance = 7990, maxCount = 2 }, -- Small Topaz
	{ id = 16124, chance = 4670 }, -- Blue Crystal Splinter
	{ id = 12600, chance = 1980 }, -- Coal
	{ id = 3097, chance = 2460 }, -- Dwarven Ring
	{ id = 2995, chance = 4080 }, -- Piggy Bank
	{ id = 16120, chance = 3760 }, -- Violet Crystal Shard
	{ id = 3429, chance = 620 }, -- Black Shield
	{ id = 10422, chance = 1040 }, -- Clay Lump
	{ id = 3415, chance = 1360 }, -- Guardian Shield
	{ id = 3318, chance = 2410 }, -- Knight Axe
	{ id = 7427, chance = 500 }, -- Chaos Mace
	{ id = 5904, chance = 720 }, -- Magic Sulphur
	{ id = 7452, chance = 890 }, -- Spiked Squelcher
	{ id = 813, chance = 690 }, -- Terra Boots
	{ id = 3428, chance = 869 }, -- Tower Shield
	{ id = 3320, chance = 510 }, -- Fire Axe
	{ id = 3392, chance = 230 }, -- Royal Helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -501 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -300, range = 7, shootEffect = CONST_ANI_WHIRLWINDAXE, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -250, range = 7, radius = 3, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_EXPLOSIONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -100, radius = 5, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -800, radius = 2, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 40,
	armor = 80,
	mitigation = 2.40,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
