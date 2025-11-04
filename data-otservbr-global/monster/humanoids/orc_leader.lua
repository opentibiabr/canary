local mType = Game.createMonsterType("Orc Leader")
local monster = {}

monster.description = "an orc leader"
monster.experience = 270
monster.outfit = {
	lookType = 59,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 59
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Orc Fort, Edron Orc Cave, South of the temple in PoH, Maze of Lost Souls, Cyclopolis, Zao Orc Land.",
}

monster.health = 450
monster.maxHealth = 450
monster.race = "blood"
monster.corpse = 6001
monster.speed = 115
monster.manaCost = 640

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 15,
	damage = 15,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Ulderek futgyr human!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 28180, maxCount = 35 }, -- Gold Coin
	{ id = 3578, chance = 30772 }, -- Fish
	{ id = 3725, chance = 10564 }, -- Brown Mushroom
	{ id = 11479, chance = 19730 }, -- Orc Leather
	{ id = 3410, chance = 9019 }, -- Plate Shield
	{ id = 3298, chance = 17933, maxCount = 4 }, -- Throwing Knife
	{ id = 3372, chance = 2417 }, -- Brass Legs
	{ id = 3285, chance = 5142 }, -- Longsword
	{ id = 7378, chance = 3080 }, -- Royal Spear
	{ id = 3091, chance = 3275 }, -- Sword Ring
	{ id = 3357, chance = 1346 }, -- Plate Armor
	{ id = 3307, chance = 10205 }, -- Scimitar
	{ id = 11480, chance = 2080 }, -- Skull Belt
	{ id = 3301, chance = 854 }, -- Broadsword
	{ id = 10196, chance = 1298 }, -- Orc Tooth
	{ id = 266, chance = 494 }, -- Health Potion
	{ id = 3557, chance = 634 }, -- Plate Legs
	{ id = 3369, chance = 97 }, -- Warrior Helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -185 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -70, range = 7, shootEffect = CONST_ANI_THROWINGKNIFE, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 20,
	mitigation = 1.18,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
