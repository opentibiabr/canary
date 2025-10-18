local mType = Game.createMonsterType("Crazed Summer Rearguard")
local monster = {}

monster.description = "a crazed summer rearguard"
monster.experience = 4700
monster.outfit = {
	lookType = 1136,
	lookHead = 114,
	lookBody = 94,
	lookLegs = 3,
	lookFeet = 121,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1733
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Court of Summer, Dream Labyrinth.",
}

monster.health = 5300
monster.maxHealth = 5300
monster.race = "blood"
monster.corpse = 30081
monster.speed = 200
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
	{ text = "Is this real life?", yell = false },
	{ text = "Weeeuuu weeeuuu!!!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 98096, maxCount = 11 }, -- Platinum Coin
	{ id = 5921, chance = 12082 }, -- Heaven Blossom
	{ id = 30005, chance = 10032 }, -- Dream Essence Egg
	{ id = 9635, chance = 7525 }, -- Elvish Talisman
	{ id = 676, chance = 6480 }, -- Small Enchanted Ruby
	{ id = 16120, chance = 5763 }, -- Violet Crystal Shard
	{ id = 16126, chance = 4953 }, -- Red Crystal Fragment
	{ id = 25735, chance = 5239, maxCount = 8 }, -- Leaf Star
	{ id = 23529, chance = 2913 }, -- Ring of Blue Plasma
	{ id = 29995, chance = 1107 }, -- Sun Fruit
	{ id = 3575, chance = 1657 }, -- Wood Cape
	{ id = 3037, chance = 1045 }, -- Yellow Gem
	{ id = 23526, chance = 1129 }, -- Collar of Blue Plasma
	{ id = 675, chance = 885, maxCount = 2 }, -- Small Enchanted Sapphire
	{ id = 3028, chance = 777 }, -- Small Diamond
	{ id = 16163, chance = 523 }, -- Crystal Crossbow
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2500, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -300, range = 6, effect = CONST_ME_FIREATTACK, target = true },
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -300, range = 6, radius = 2, effect = CONST_ME_FIREAREA, target = true },
}

monster.defenses = {
	defense = 20,
	armor = 76,
	mitigation = 2.11,
}

monster.reflects = {
	{ type = COMBAT_FIREDAMAGE, percent = 70 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
