local mType = Game.createMonsterType("Vok the Freakish")
local monster = {}

monster.description = "Vok the Freakish"
monster.experience = 27000
monster.outfit = {
	lookType = 1268,
	lookHead = 0,
	lookBody = 98,
	lookLegs = 0,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 32000
monster.maxHealth = 32000
monster.race = "undead"
monster.corpse = 32610
monster.speed = 142
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 1892,
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
	illusionable = true,
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
	{ id = 32583, chance = 13768 }, -- Skull Coin
	{ id = 3035, chance = 100000, maxCount = 10 }, -- Platinum Coin
	{ id = 32774, chance = 47101 }, -- Cursed Bone
	{ id = 32769, chance = 42753 }, -- White Gem
	{ id = 32771, chance = 30434 }, -- Moonstone
	{ id = 3039, chance = 1000, maxCount = 2 }, -- Red Gem
	{ id = 32703, chance = 4716 }, -- Death Toll
	{ id = 3010, chance = 6521 }, -- Emerald Bangle
	{ id = 24392, chance = 6521 }, -- Gemmed Figurine
	{ id = 14247, chance = 4878 }, -- Ornate Crossbow
	{ id = 32619, chance = 943 }, -- Pair of Nightmare Boots
	{ id = 32772, chance = 1000 }, -- Silver Hand Mirror
	{ id = 1781, chance = 4132 }, -- Small Stone
	{ id = 16163, chance = 3773 }, -- Crystal Crossbow
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -500 },
	{ name = "combat", interval = 1500, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -500, radius = 3, shootEffect = CONST_ANI_ENVENOMEDARROW, effect = CONST_ME_HITBYPOISON, target = true },
	{ name = "combat", interval = 1500, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -650, length = 4, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 1500, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -650, radius = 4, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 1500, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -650, radius = 4, effect = CONST_ME_GREEN_RINGS, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 82,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
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
