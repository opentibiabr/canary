local mType = Game.createMonsterType("Werefox")
local monster = {}

monster.description = "a Werefox"
monster.experience = 1600
monster.outfit = {
	lookType = 1030,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
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
	Locations = "Were-beasts cave south-west of Edron and in the Last Sanctum east of Cormaya."
	}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "blood"
monster.corpse = 27521
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
	maxSummons = 1,
	summons = {
		{name = "fox", chance = 10, interval = 2000, count = 1}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Yelp!", yell = false},
	{text = "Grrrrrr", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 405000, maxCount = 200},
	{name = "platinum coin", chance = 4050, maxCount = 2},
	{name = "fox paw", chance = 4050, maxCount = 2},
	{name = "werefox tail", chance = 4050, maxCount = 2},
	{name = "strong mana potion", chance = 4050, maxCount = 2},
	{name = "great mana potion", chance = 4050, maxCount = 2},
	{name = "mana potion", chance = 4050, maxCount = 2},
	{name = "small enchanted emerald", chance = 4050, maxCount = 2},
	{name = "emerald bangle", chance = 4050, maxCount = 2},
	{name = "moonlight rod", chance = 500},
	{name = "troll green", chance = 500, maxCount = 2},
	{name = "assassin star", chance = 300, maxCount = 5},
	{name = "platinum amulet", chance = 130},
	{id = 3098, chance = 200}, -- ring of healing
	{name = "werewolf amulet", chance = 50},
	{id = 27706, chance = 30} -- werefox trophy
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -290},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -200, shootEffect = CONST_ANI_GREENSTAR, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -225, range = 7, radius = 4, effect = CONST_ME_MAGIC_RED, target = true},
	{name ="combat", interval = 2000, chance = 14, type = COMBAT_DEATHDAMAGE, minDamage = -100, maxDamage = -700, length = 5, spread = 3, effect = CONST_ME_MORTAREA, target = false}
}

monster.defenses = {
	defense = 45,
	armor = 40,
	{name ="combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 145, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 5},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 40}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
