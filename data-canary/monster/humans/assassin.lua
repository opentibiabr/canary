--# Monster converted using Devm monster converter #--
local mType = Game.createMonsterType("Assassin")
local monster = {}

monster.description = "an assassin"
monster.experience = 105
monster.outfit = {
	lookType = 152,
	lookHead = 114,
	lookBody = 95,
	lookLegs = 95,
	lookFeet = 95,
	lookAddons = 3,
	lookMount = 0
}

monster.raceId = 224
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Dark Cathedral, Trade Quarter, Factory Quarter, Foreigner Quarter."
	}

monster.health = 175
monster.maxHealth = 175
monster.race = "blood"
monster.corpse = 18046
monster.speed = 112
monster.manaCost = 450

monster.changeTarget = {
	interval = 4000,
	chance = 0
}

monster.strategiesTarget = {
	nearest = 70,
	health = 20,
	damage = 10,
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
	canWalkOnFire = false,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Die!", yell = false},
	{text = "Feel the hand of death!", yell = false},
	{text = "You are on my deathlist!", yell = false}
}

monster.loot = {
	{id = 2920, chance = 29980, maxCount = 2}, -- torch
	{id = 3028, chance = 220}, -- small diamond
	{id = 3031, chance = 83210, maxCount = 50}, -- gold coin
	{id = 3031, chance = 7250, maxCount = 14}, -- gold coin
	{id = 3291, chance = 9500}, -- knife
	{id = 3292, chance = 4000}, -- combat knife
	{id = 3351, chance = 3230}, -- steel helmet
	{id = 3409, chance = 970}, -- steel shield
	{id = 3410, chance = 1900}, -- plate shield
	{id = 3413, chance = 1600}, -- battle shield
	{id = 3404, chance = 480}, -- leopard armor
	{id = 3405, chance = 230}, -- horseman helmet
	{id = 7366, chance = 4200, maxCount = 7} -- viper star
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -120},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -40, range = 7, shootEffect = CONST_ANI_THROWINGSTAR, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -120, maxDamage = -160, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="invisible", interval = 2000, chance = 10, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -5},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
