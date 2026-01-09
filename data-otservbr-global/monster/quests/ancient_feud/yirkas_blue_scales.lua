local mType = Game.createMonsterType("Yirkas Blue Scales")
local monster = {}

monster.description = "Yirkas Blue Scales"
monster.experience = 4900
monster.outfit = {
	lookType = 1196,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1982,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 6300
monster.maxHealth = 6300
monster.race = "blood"
monster.corpse = 31409
monster.speed = 190
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
}

monster.loot = {
	{ id = 34102, chance = 6473 }, -- Yirkas' Egg
	{ id = 31559, chance = 99914, maxCount = 4 }, -- Blue Goanna Scale
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 7643, chance = 100000, maxCount = 3 }, -- Ultimate Health Potion
	{ id = 9058, chance = 12521 }, -- Gold Ingot
	{ id = 3041, chance = 4344 }, -- Blue Gem
	{ id = 34258, chance = 658 }, -- Red Silk Flower
	{ id = 24392, chance = 5110 }, -- Gemmed Figurine
	{ id = 31340, chance = 5281 }, -- Lizard Heart
	{ id = 3420, chance = 1448 }, -- Demon Shield
	{ id = 3281, chance = 2470 }, -- Giant Sword
	{ id = 3063, chance = 1192 }, -- Gold Ring
	{ id = 7440, chance = 1448 }, -- Mastermind Potion
	{ id = 23531, chance = 2896 }, -- Ring of Green Plasma
	{ id = 10438, chance = 1192 }, -- Spellweaver's Robe
	{ id = 33778, chance = 283 }, -- Raw Watermelon Tourmaline
	{ id = 21168, chance = 878 }, -- Alloy Legs
	{ id = 821, chance = 3321 }, -- Magma Legs
	{ id = 5741, chance = 2896 }, -- Skull Helmet
	{ id = 7422, chance = 2981 }, -- Jade Hammer
	{ id = 3342, chance = 1959 }, -- War Axe
	{ id = 7404, chance = 1703 }, -- Assassin Dagger
	{ id = 3038, chance = 4344 }, -- Green Gem
	{ id = 3366, chance = 936 }, -- Magic Plate Armor
	{ id = 7382, chance = 936 }, -- Demonrage Sword
	{ id = 8074, chance = 1022 }, -- Spellbook of Mind Control
	{ id = 14247, chance = 929 }, -- Ornate Crossbow
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100, condition = { type = CONDITION_POISON, totalDamage = 15, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -400, maxDamage = -500, length = 3, spread = 0, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -350, range = 3, radius = 3, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -500, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -300, radius = 4, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 78,
	armor = 78,
	--	mitigation = ???,
	{ name = "speed", interval = 2000, chance = 5, speedChange = 350, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
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
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
