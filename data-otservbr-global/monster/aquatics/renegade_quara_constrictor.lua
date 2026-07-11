local mType = Game.createMonsterType("Renegade Quara Constrictor")
local monster = {}

monster.description = "a renegade quara constrictor"
monster.experience = 1250
monster.outfit = {
	lookType = 46,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1097
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 2,
	Locations = "Seacrest Grounds when Seacrest Serpents are not spawning.",
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "blood"
monster.corpse = 6065
monster.speed = 190
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0,
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 20,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}

monster.light = {
	level = 2,
	color = 35,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 81000, maxCount = 3 }, -- Platinum Coin
	{ id = 11487, chance = 14600 }, -- Quara Tentacle
	{ id = 3062, chance = 6900 }, -- Mind Stone
	{ id = 238, chance = 6500 }, -- Great Mana Potion
	{ id = 3098, chance = 5300 }, -- Ring of Healing
	{ id = 3581, chance = 5000 }, -- Shrimp
	{ id = 3033, chance = 4700, maxCount = 2 }, -- Small Amethyst
	{ id = 7368, chance = 4500, maxCount = 7 }, -- Assassin Star
	{ id = 3030, chance = 4200, maxCount = 2 }, -- Small Ruby
	{ id = 14252, chance = 3400, maxCount = 10 }, -- Vortex Bolt
	{ id = 8083, chance = 1000 }, -- Northwind Rod
	{ id = 16120, chance = 950 }, -- Violet Crystal Shard
	{ id = 5895, chance = 370 }, -- Fish Fin
	{ id = 2995, chance = 260 }, -- Piggy Bank
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 60, attack = 40, effect = CONST_ME_DRAWBLOOD },
	{ name = "quara constrictor freeze", interval = 2000, chance = 10, target = false },
	{ name = "quara constrictor electrify", interval = 2000, chance = 10, range = 1, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 35,
	mitigation = 1.04,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 150, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
