local mType = Game.createMonsterType("The Blightfather")
local monster = {}

monster.description = "The Blightfather"
monster.experience = 400
monster.outfit = {
	lookType = 348,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 638,
	bossRace = RARITY_NEMESIS,
}

monster.health = 400
monster.maxHealth = 400
monster.race = "venom"
monster.corpse = 10458
monster.speed = 145
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 12,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 80,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
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
	{ id = 3031, chance = 2000, maxCount = 61 }, -- gold coin
	{ id = 3031, chance = 2000, maxCount = 60 }, -- gold coin
	{ id = 9692, chance = 17500 }, -- lump of dirt
	{ id = 9640, chance = 12500 }, -- poisonous slime
	{ id = 10455, chance = 7000 }, -- lancer beetle shell
	{ id = 10457, chance = 400 }, -- beetle necklace
	{ id = 3033, chance = 800 }, -- small amethyst
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 40, attack = 80 },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	--	mitigation = ???,
	{ name = "invisible", interval = 1000, chance = 10, effect = CONST_ME_MAGIC_RED },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
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
