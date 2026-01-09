local mType = Game.createMonsterType("Katex Blood Tongue")
local monster = {}

monster.description = "Katex Blood Tongue"
monster.experience = 5000
monster.outfit = {
	lookType = 1300,
	lookHead = 76,
	lookBody = 57,
	lookLegs = 113,
	lookFeet = 113,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 6300
monster.maxHealth = 6300
monster.race = "blood"
monster.corpse = 34189
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
}

monster.bosstiary = {
	bossRaceId = 1981,
	bossRace = RARITY_ARCHFOE,
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
		{ name = "werehyaena", chance = 50, interval = 5000, count = 1 },
	},
}

monster.voices = {
	interval = 0,
	chance = 0,
}

monster.loot = {
	{ id = 34100, chance = 5190 }, -- Katex' Blood
	{ id = 3035, chance = 99837, maxCount = 9 }, -- Platinum Coin
	{ id = 7643, chance = 100000, maxCount = 3 }, -- Ultimate Health Potion
	{ id = 33943, chance = 21005 }, -- Werehyaena Nose
	{ id = 9058, chance = 23438 }, -- Gold Ingot
	{ id = 5741, chance = 2919 }, -- Skull Helmet
	{ id = 3420, chance = 2426 }, -- Demon Shield
	{ id = 33944, chance = 4541 }, -- Werehyaena Talisman
	{ id = 33778, chance = 823 }, -- Raw Watermelon Tourmaline
	{ id = 34219, chance = 5352 }, -- Werehyaena Trophy
	{ id = 3366, chance = 2108 }, -- Magic Plate Armor
	{ id = 34258, chance = 625 }, -- Red Silk Flower
	{ id = 7404, chance = 1459 }, -- Assassin Dagger
	{ id = 7382, chance = 1299 }, -- Demonrage Sword
	{ id = 3281, chance = 2027 }, -- Giant Sword
	{ id = 3360, chance = 1299 }, -- Golden Armor
	{ id = 7422, chance = 1333 }, -- Jade Hammer
	{ id = 7440, chance = 1297 }, -- Mastermind Potion
	{ id = 14247, chance = 1378 }, -- Ornate Crossbow
	{ id = 3036, chance = 5271 }, -- Violet Gem
	{ id = 3342, chance = 926 }, -- War Axe
	{ id = 22083, chance = 2108 }, -- Moonlight Crystals
	{ id = 23531, chance = 1216 }, -- Ring of Green Plasma
	{ id = 3063, chance = 1993 }, -- Gold Ring
	{ id = 3041, chance = 2676 }, -- Blue Gem
	{ id = 21168, chance = 1004 }, -- Alloy Legs
	{ id = 281, chance = 143 }, -- Giant Shimmering Pearl
}

monster.attacks = {
	{ name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2000, maxDamage = -300 },
	{ name = "combat", type = COMBAT_EARTHDAMAGE, interval = 2000, chance = 30, minDamage = -350, maxDamage = -500, range = 5, radius = 3, length = 3, spread = 3, target = true, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_POFF },
	{ name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2000, chance = 40, minDamage = -300, maxDamage = -400, radius = 5, target = false, effect = CONST_ME_MORTAREA },
	{ name = "katex deathT", interval = 2000, chance = 30, minDamage = -250, maxDamage = -350, target = false },
}

monster.defenses = {
	{ name = "speed", interval = 2000, chance = 15, speed = 200, duration = 5000, effect = CONST_ME_MAGIC_BLUE },
	defense = 0,
	armor = 38,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = true },
}

mType:register(monster)
