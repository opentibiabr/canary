local mType = Game.createMonsterType("Stone Devourer")
local monster = {}

monster.description = "a stone devourer"
monster.experience = 2900
monster.outfit = {
	lookType = 486,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 879
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Warzone 1.",
}

monster.health = 4200
monster.maxHealth = 4200
monster.race = "undead"
monster.corpse = 15865
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 1,
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
	{ text = "Rumble!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 94000, maxCount = 10 }, -- Platinum Coin
	{ id = 7643, chance = 24000 }, -- Ultimate Health Potion
	{ id = 16125, chance = 21000 }, -- Cyan Crystal Fragment
	{ id = 16137, chance = 17600 }, -- Stone Nose
	{ id = 238, chance = 17600, maxCount = 2 }, -- Great Mana Potion
	{ id = 236, chance = 14700, maxCount = 2 }, -- Strong Health Potion
	{ id = 237, chance = 14700, maxCount = 2 }, -- Strong Mana Potion
	{ id = 16138, chance = 11800 }, -- Crystalline Spikes
	{ id = 9632, chance = 11800 }, -- Ancient Stone
	{ id = 12600, chance = 8800 }, -- Coal
	{ id = 7437, chance = 5900 }, -- Sapphire Hammer
	{ id = 16122, chance = 5900 }, -- Green Crystal Splinter
	{ id = 268, chance = 5900, maxCount = 2 }, -- Mana Potion
	{ id = 7454, chance = 5900 }, -- Glorious Axe
	{ id = 15793, chance = 2900, maxCount = 5 }, -- Crystalline Arrow
	{ id = 3097, chance = 2900 }, -- Dwarven Ring
	{ id = 3081, chance = 2330 }, -- Stone Skin Amulet
	{ id = 7452, chance = 1460 }, -- Spiked Squelcher
	{ id = 3333, chance = 760 }, -- Crystal Mace
	{ id = 3342, chance = 730 }, -- War Axe
	{ id = 3281, chance = 460 }, -- Giant Sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -990 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -230, maxDamage = -460, range = 7, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_STONES, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -650, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -150, maxDamage = -260, length = 5, spread = 0, effect = CONST_ME_STONES, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 75,
	mitigation = 2.31,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
