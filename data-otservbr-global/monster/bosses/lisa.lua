local mType = Game.createMonsterType("Lisa")
local monster = {}

monster.description = "Lisa"
monster.experience = 18000
monster.outfit = {
	lookType = 604,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1059,
	bossRace = RARITY_BANE,
}

monster.health = 55000
monster.maxHealth = 55000
monster.race = "venom"
monster.corpse = 20988
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 3,
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
	runHealth = 0,
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
	{ name = "bowl of glooth soup", chance = 55000, maxCount = 5 },
	{ name = "glooth sandwich", chance = 34500, maxCount = 5 },
	{ name = "great health potion", chance = 33000, maxCount = 5 },
	{ name = "great mana potion", chance = 33000, maxCount = 5 },
	{ name = "great spirit potion", chance = 33000, maxCount = 5 },
	{ name = "glooth steak", chance = 28000, maxCount = 5 },
	{ name = "slimy leaf tentacle", chance = 22000, maxCount = 3 },
	{ name = "small amethyst", chance = 21000, maxCount = 5 },
	{ name = "small diamond", chance = 18000, maxCount = 5 },
	{ name = "small ruby", chance = 16000, maxCount = 5 },
	{ name = "small topaz", chance = 14800, maxCount = 5 },
	{ name = "glooth club", chance = 10500 },
	{ name = "glooth spear", chance = 9900 },
	{ name = "glooth whip", chance = 9500 },
	{ name = "glooth amulet", chance = 9000 },
	{ name = "glooth axe", chance = 8000 },
	{ name = "glooth blade", chance = 7000 },
	{ name = "glooth cape", chance = 6000 },
	{ id = 3039, chance = 2600 }, -- red gem
	{ name = "yellow gem", chance = 2500 },
	{ name = "lisa's doll", chance = 300 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 150, attack = 100, condition = { type = CONDITION_POISON, totalDamage = 900, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -400, range = 7, radius = 1, shootEffect = CONST_ANI_GREENSTAR, effect = CONST_ME_MORTAREA, target = true },
	{ name = "effect", interval = 2000, chance = 15, range = 7, radius = 6, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_BIGPLANTS, target = true },
	{ name = "effect", interval = 2000, chance = 15, range = 7, radius = 6, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_PLANTATTACK, target = true },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_MANADRAIN, minDamage = -100, maxDamage = -200, radius = 8, effect = CONST_ME_POISONAREA, target = false },
	{ name = "lisa paralyze", interval = 2000, chance = 12, target = false },
	{ name = "lisa skill reducer", interval = 2000, chance = 15, target = false },
	{ name = "lisa wave", interval = 2000, chance = 11, minDamage = -400, maxDamage = -900, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 15,
	--	mitigation = ???,
	{ name = "lisa summon", interval = 2000, chance = 5, target = false },
	{ name = "lisa heal", interval = 1000, chance = 100, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
