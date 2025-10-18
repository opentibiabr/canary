local mType = Game.createMonsterType("Minotaur Cult Follower")
local monster = {}

monster.description = "a minotaur cult follower"
monster.experience = 950
monster.outfit = {
	lookType = 25,
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

monster.raceId = 1508
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

monster.health = 1600
monster.maxHealth = 1600
monster.race = "blood"
monster.corpse = 5969
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	{ text = "We will rule!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 155 }, -- Gold Coin
	{ id = 3035, chance = 65050, maxCount = 3 }, -- Platinum Coin
	{ id = 3582, chance = 59520 }, -- Ham
	{ id = 21204, chance = 22040 }, -- Cowbell
	{ id = 3410, chance = 20010 }, -- Plate Shield
	{ id = 9639, chance = 15230 }, -- Cultish Robe
	{ id = 3056, chance = 14970 }, -- Bronze Amulet
	{ id = 11472, chance = 14240, maxCount = 2 }, -- Minotaur Horn
	{ id = 21175, chance = 12390 }, -- Mino Shield
	{ id = 239, chance = 11820 }, -- Great Health Potion
	{ id = 5878, chance = 11810 }, -- Minotaur Leather
	{ id = 3577, chance = 7700 }, -- Meat
	{ id = 3098, chance = 3250 }, -- Ring of Healing
	{ id = 3030, chance = 3110, maxCount = 2 }, -- Small Ruby
	{ id = 3032, chance = 3150, maxCount = 2 }, -- Small Emerald
	{ id = 3033, chance = 2970, maxCount = 2 }, -- Small Amethyst
	{ id = 9057, chance = 2680, maxCount = 2 }, -- Small Topaz
	{ id = 21174, chance = 1910 }, -- Mino Lance
	{ id = 9058, chance = 989 }, -- Gold Ingot
	{ id = 5911, chance = 870 }, -- Red Piece of Cloth
	{ id = 3369, chance = 560 }, -- Warrior Helmet
	{ id = 3037, chance = 220 }, -- Yellow Gem
	{ id = 7401, chance = 210 }, -- Minotaur Trophy
	{ id = 3039, chance = 140 }, -- Red Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -240 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -110, maxDamage = -210, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 32,
	mitigation = 1.24,
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
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
