local mType = Game.createMonsterType("Iks Chuka")
local monster = {}

monster.description = "an iks chuka"
monster.experience = 1050
monster.outfit = {
	lookType = 1588,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2345
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 1,
	Locations = "Iksupan",
}

monster.health = 1240
monster.maxHealth = 1240
monster.race = "blood"
monster.corpse = 42057
monster.speed = 120
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 3,
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
	{ text = "Pucataaan!", yell = false },
	{ text = "Mahrrrca!", yell = false },
	{ text = "Puccahtaaan!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 99544 }, -- Gold Coin
	{ id = 3029, chance = 8702 }, -- Small Sapphire
	{ id = 16120, chance = 14920 }, -- Violet Crystal Shard
	{ id = 16122, chance = 10908 }, -- Green Crystal Splinter
	{ id = 3007, chance = 1853 }, -- Crystal Ring
	{ id = 7378, chance = 4056 }, -- Royal Spear
	{ id = 9058, chance = 1216 }, -- Gold Ingot
	{ id = 40527, chance = 1834 }, -- Rotten Feather
	{ id = 40529, chance = 1101 }, -- Gold-Brocaded Cloth
	{ id = 40528, chance = 964 }, -- Ritual Tooth
	{ id = 3081, chance = 390 }, -- Stone Skin Amulet
	{ id = 40532, chance = 10 }, -- Broken Iks Headpiece
	{ id = 40534, chance = 60 }, -- Broken Iks Sandals
	{ id = 40535, chance = 60 }, -- Broken Iks Spear
	{ id = 3035, chance = 39440, maxCount = 4 }, -- Platinum Coin
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -175 },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -130, range = 4, shootEffect = CONST_ANI_ENCHANTEDSPEAR, target = true },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -110, maxDamage = -175, radius = 2, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -98, maxDamage = -114, range = 5, radius = 1, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 30,
	armor = 29,
	mitigation = 0.99,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
