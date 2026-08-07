local mType = Game.createMonsterType("Iks Pututu")
local monster = {}

monster.description = "an iks pututu"
monster.experience = 980
monster.outfit = {
	lookType = 1589,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2343
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

monster.health = 1310
monster.maxHealth = 1310
monster.race = "blood"
monster.corpse = 42061
monster.speed = 110
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
	{ text = "Attahch!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 78000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 39000, maxCount = 4 }, -- Platinum Coin
	{ id = 281, chance = 7600 }, -- Giant Shimmering Pearl (Green)
	{ id = 24961, chance = 7000 }, -- Tiger Eye
	{ id = 3029, chance = 6200, maxCount = 3 }, -- Small Sapphire
	{ id = 237, chance = 4800, maxCount = 2 }, -- Strong Mana Potion
	{ id = 8072, chance = 1800 }, -- Spellbook of Enlightenment
	{ id = 22194, chance = 1800 }, -- Opal
	{ id = 9058, chance = 1600 }, -- Gold Ingot
	{ id = 40527, chance = 1500 }, -- Rotten Feather
	{ id = 40529, chance = 1400 }, -- Gold-Brocaded Cloth
	{ id = 40528, chance = 1200 }, -- Ritual Tooth
	{ id = 50150, chance = 910 }, -- Ring of Orange Plasma
	{ id = 3081, chance = 710 }, -- Stone Skin Amulet
	{ id = 40534, chance = 40 }, -- Broken Iks Sandals
	{ id = 40531, chance = 40 }, -- Broken Iks Faulds
	{ id = 40532, chance = 20 }, -- Broken Iks Headpiece
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -150 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -80, maxDamage = -90, radius = 2, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -75, maxDamage = -95, length = 8, spread = 0, effect = CONST_ME_STONE_STORM, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -98, maxDamage = -114, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 32,
	mitigation = 1.18,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 51, maxDamage = 71, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 25 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
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
