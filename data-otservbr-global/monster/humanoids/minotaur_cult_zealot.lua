local mType = Game.createMonsterType("Minotaur Cult Zealot")
local monster = {}

monster.description = "a minotaur cult zealot"
monster.experience = 1350
monster.outfit = {
	lookType = 29,
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

monster.raceId = 1510
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

monster.health = 1800
monster.maxHealth = 1800
monster.race = "blood"
monster.corpse = 5983
monster.speed = 125
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
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 150 }, -- Gold Coin
	{ id = 3035, chance = 39430, maxCount = 3 }, -- Platinum Coin
	{ id = 11473, chance = 16540 }, -- Purple Robe
	{ id = 3066, chance = 11930 }, -- Snakebite Rod
	{ id = 237, chance = 11660, maxCount = 3 }, -- Strong Mana Potion
	{ id = 9639, chance = 9710 }, -- Cultish Robe
	{ id = 7425, chance = 6530 }, -- Taurus Mace
	{ id = 5878, chance = 5240 }, -- Minotaur Leather
	{ id = 3033, chance = 2970, maxCount = 2 }, -- Small Amethyst
	{ id = 3032, chance = 2720, maxCount = 2 }, -- Small Emerald
	{ id = 3028, chance = 2270, maxCount = 2 }, -- Small Diamond
	{ id = 3029, chance = 2700, maxCount = 2 }, -- Small Sapphire
	{ id = 11472, chance = 2750, maxCount = 2 }, -- Minotaur Horn
	{ id = 5911, chance = 2090 }, -- Red Piece of Cloth
	{ id = 9057, chance = 2290, maxCount = 2 }, -- Small Topaz
	{ id = 3030, chance = 2220, maxCount = 2 }, -- Small Ruby
	{ id = 3037, chance = 430 }, -- Yellow Gem
	{ id = 3039, chance = 500 }, -- Red Gem
	{ id = 7401, chance = 90 }, -- Minotaur Trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -340 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -90, maxDamage = -320, range = 7, shootEffect = CONST_ANI_WHIRLWINDAXE, target = true },
}

monster.defenses = {
	defense = 30,
	armor = 35,
	mitigation = 1.37,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
