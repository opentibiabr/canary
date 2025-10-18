local mType = Game.createMonsterType("Candy Floss Elemental")
local monster = {}

monster.description = "a candy floss elemental"
monster.experience = 3850
monster.outfit = {
	lookType = 1749,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2533
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Dessert Dungeons.",
}

monster.health = 3700
monster.maxHealth = 3700
monster.race = "undead"
monster.corpse = 48345
monster.speed = 105
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
	staticAttackChance = 90,
	targetDistance = 4,
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
	{ text = "Come into my fluffy embrace!", yell = false },
	{ text = "Want fairy floss? I will feed you up.", yell = false },
	{ text = "Did you have to come here, little one? I just wanted to lay around and take it easy.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 95965, maxCount = 149 }, -- Gold Coin
	{ id = 3035, chance = 86289, maxCount = 11 }, -- Platinum Coin
	{ id = 25694, chance = 6713 }, -- Fairy Wings
	{ id = 3036, chance = 1098 }, -- Violet Gem
	{ id = 16120, chance = 2656 }, -- Violet Crystal Shard
	{ id = 22194, chance = 3635 }, -- Opal
	{ id = 23535, chance = 3805 }, -- Energy Bar
	{ id = 25737, chance = 3261, maxCount = 2 }, -- Rainbow Quartz
	{ id = 48116, chance = 3267, maxCount = 3 }, -- Gummy Rotworm
	{ id = 48544, chance = 1403 }, -- Wad of Fairy Floss
	{ id = 8084, chance = 581 }, -- Springsprout Rod
	{ id = 3054, chance = 150 }, -- Silver Amulet
	{ id = 3093, chance = 281 }, -- Club Ring
	{ id = 48249, chance = 863, maxCount = 10 }, -- Milk Chocolate Coin
	{ id = 3048, chance = 1750 }, -- Might Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -150, maxDamage = -250, range = 7, shootEffect = CONST_ANI_CHERRYBOMB, effect = CONST_ME_STARBURST, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -160, maxDamage = -300, range = 6, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -160, maxDamage = -300, range = 6, radius = 2, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_PIXIE_EXPLOSION, target = true },
}

monster.defenses = {
	defense = 45,
	armor = 45,
	mitigation = 1.26,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 40 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
