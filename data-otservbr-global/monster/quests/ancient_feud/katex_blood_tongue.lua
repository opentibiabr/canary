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
	{ id = 7643, chance = 100000, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 3035, chance = 99000, maxCount = 17 }, -- Platinum Coin
	{ id = 9058, chance = 24000 }, -- Gold Ingot
	{ id = 48248, chance = 22000 }, -- Rainbow Waffles
	{ id = 33943, chance = 22000 }, -- Werehyaena Nose
	{ id = 3036, chance = 6500 }, -- Violet Gem
	{ id = 34219, chance = 6500 }, -- Werehyaena Trophy
	{ id = 22083, chance = 4400, maxCount = 5 }, -- Moonlight Crystals
	{ id = 33944, chance = 4400 }, -- Werehyaena Talisman
	{ id = 34100, chance = 3800 }, -- Katex' Blood
	{ id = 3041, chance = 2700 }, -- Blue Gem
	{ id = 3281, chance = 2700 }, -- Giant Sword
	{ id = 3366, chance = 2700 }, -- Magic Plate Armor
	{ id = 5741, chance = 2200 }, -- Skull Helmet
	{ id = 7404, chance = 1900 }, -- Assassin Dagger
	{ id = 14247, chance = 1900 }, -- Ornate Crossbow
	{ id = 3360, chance = 1900 }, -- Golden Armor
	{ id = 3063, chance = 1900 }, -- Gold Ring
	{ id = 3420, chance = 1400 }, -- Demon Shield
	{ id = 7382, chance = 1100 }, -- Demonrage Sword
	{ id = 7440, chance = 1100 }, -- Mastermind Potion
	{ id = 21168, chance = 820 }, -- Alloy Legs
	{ id = 23531, chance = 820 }, -- Ring of Green Plasma
	{ id = 3342, chance = 820 }, -- War Axe
	{ id = 7422, chance = 540 }, -- Jade Hammer
	{ id = 33778, chance = 540 }, -- Raw Watermelon Tourmaline
	{ id = 49373, chance = 270 }, -- Greater Spiritualist Gem
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
