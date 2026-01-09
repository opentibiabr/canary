local mType = Game.createMonsterType("Minotaur Cult Prophet")
local monster = {}

monster.description = "a minotaur cult prophet"
monster.experience = 1100
monster.outfit = {
	lookType = 23,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"MinotaurCultTaskDeath",
}

monster.raceId = 1509
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Minotaurs Cult Cave",
}

monster.health = 1700
monster.maxHealth = 1700
monster.race = "blood"
monster.corpse = 5981
monster.speed = 120
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
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Bow to the power of the iron bull!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 150 }, -- Gold Coin
	{ id = 3035, chance = 66260, maxCount = 3 }, -- Platinum Coin
	{ id = 3582, chance = 58750 }, -- Ham
	{ id = 21204, chance = 19180 }, -- Cowbell
	{ id = 238, chance = 16670 }, -- Great Mana Potion
	{ id = 11472, chance = 19240, maxCount = 2 }, -- Minotaur Horn
	{ id = 5878, chance = 14260 }, -- Minotaur Leather
	{ id = 9639, chance = 15150 }, -- Cultish Robe
	{ id = 3032, chance = 10130 }, -- Small Emerald
	{ id = 3070, chance = 7880 }, -- Moonlight Rod
	{ id = 3577, chance = 7569 }, -- Meat
	{ id = 9057, chance = 7770 }, -- Small Topaz
	{ id = 239, chance = 7640 }, -- Great Health Potion
	{ id = 3030, chance = 6950 }, -- Small Ruby
	{ id = 3033, chance = 6900, maxCount = 2 }, -- Small Amethyst
	{ id = 3098, chance = 6230 }, -- Ring of Healing
	{ id = 9058, chance = 1230 }, -- Gold Ingot
	{ id = 5911, chance = 480 }, -- Red Piece of Cloth
	{ id = 7401, chance = 500 }, -- Minotaur Trophy
	{ id = 3039, chance = 500 }, -- Red Gem
	{ id = 3037, chance = 430 }, -- Yellow Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -240 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -350, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -350, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
}

monster.defenses = {
	defense = 15,
	armor = 28,
	mitigation = 1.10,
	{ name = "Minotaur Cult Prophet Mass Healing", interval = 2000, chance = 20, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
