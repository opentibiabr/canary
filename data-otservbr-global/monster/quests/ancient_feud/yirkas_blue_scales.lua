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
	{ id = 31559, chance = 100000, maxCount = 6 }, -- Blue Goanna Scale
	{ id = 3035, chance = 100000, maxCount = 17 }, -- Platinum Coin
	{ id = 7643, chance = 100000, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 9058, chance = 15800 }, -- Gold Ingot
	{ id = 3038, chance = 5400 }, -- Green Gem
	{ id = 34102, chance = 5400 }, -- Yirkas' Egg
	{ id = 3041, chance = 4700 }, -- Blue Gem
	{ id = 31340, chance = 4700 }, -- Lizard Heart
	{ id = 23531, chance = 4000 }, -- Ring of Green Plasma
	{ id = 821, chance = 4000 }, -- Magma Legs
	{ id = 5741, chance = 3700 }, -- Skull Helmet
	{ id = 7422, chance = 3000 }, -- Jade Hammer
	{ id = 3342, chance = 3000 }, -- War Axe
	{ id = 3420, chance = 2700 }, -- Demon Shield
	{ id = 24392, chance = 2700 }, -- Gemmed Figurine
	{ id = 3281, chance = 2400 }, -- Giant Sword
	{ id = 8074, chance = 2000 }, -- Spellbook of Mind Control
	{ id = 3063, chance = 1300 }, -- Gold Ring
	{ id = 10438, chance = 1300 }, -- Spellweaver's Robe
	{ id = 7440, chance = 1000 }, -- Mastermind Potion
	{ id = 7382, chance = 1000 }, -- Demonrage Sword
	{ id = 7404, chance = 1000 }, -- Assassin Dagger
	{ id = 21168, chance = 340 }, -- Alloy Legs
	{ id = 14247, chance = 340 }, -- Ornate Crossbow
	{ id = 3366, chance = 340 }, -- Magic Plate Armor
	{ id = 34258, chance = 340 }, -- Red Silk Flower
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
