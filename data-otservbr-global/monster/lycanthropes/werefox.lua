local mType = Game.createMonsterType("Werefox")
local monster = {}

monster.description = "a werefox"
monster.experience = 1600
monster.outfit = {
	lookType = 1030,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1549
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Were-beasts cave south-west of Edron and in the Last Sanctum east of Cormaya.",
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "blood"
monster.corpse = 27521
monster.speed = 140
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
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "fox", chance = 10, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Yelp!", yell = false },
	{ text = "Grrrrrr", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 4 }, -- platinum coin
	{ id = 3031, chance = 80000, maxCount = 85 }, -- gold coin
	{ id = 27462, chance = 23000 }, -- fox paw
	{ id = 27463, chance = 23000 }, -- werefox tail
	{ id = 22083, chance = 23000 }, -- moonlight crystals
	{ id = 3741, chance = 5000 }, -- troll green
	{ id = 268, chance = 5000 }, -- mana potion
	{ id = 237, chance = 5000 }, -- strong mana potion
	{ id = 7368, chance = 5000 }, -- assassin star
	{ id = 3010, chance = 5000 }, -- emerald bangle
	{ id = 3070, chance = 5000 }, -- moonlight rod
	{ id = 238, chance = 5000 }, -- great mana potion
	{ id = 677, chance = 5000, maxCount = 2 }, -- small enchanted emerald
	{ id = 3098, chance = 1000 }, -- ring of healing
	{ id = 22060, chance = 1000 }, -- werewolf amulet
	{ id = 3055, chance = 1000 }, -- platinum amulet
	{ id = 27706, chance = 260 }, -- werefox trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -290 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -200, shootEffect = CONST_ANI_GREENSTAR, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -225, range = 7, radius = 4, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_DEATHDAMAGE, minDamage = -100, maxDamage = -700, length = 5, spread = 0, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 40,
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 145, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
