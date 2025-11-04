local mType = Game.createMonsterType("Misguided Thief")
local monster = {}

monster.description = "a misguided thief"
monster.experience = 1200
monster.outfit = {
	lookType = 684,
	lookHead = 58,
	lookBody = 40,
	lookLegs = 60,
	lookFeet = 116,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1413
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Misguided Camp accessible via Outlaw Camp's portal.",
}

monster.health = 1800
monster.maxHealth = 1800
monster.race = "blood"
monster.corpse = 26125
monster.speed = 130
monster.manaCost = 390

monster.changeTarget = {
	interval = 4000,
	chance = 20,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.events = {
	"GlowingRubbishAmuletDeath",
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
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I spotted you!", yell = false },
	{ text = "Let me show you your destiny!", yell = false },
	{ text = "There is no escape now, friend.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 75030, maxCount = 80 }, -- Gold Coin
	{ id = 3582, chance = 55090 }, -- Ham
	{ id = 3577, chance = 44049 }, -- Meat
	{ id = 237, chance = 6280 }, -- Strong Mana Potion
	{ id = 25296, chance = 8700 }, -- Rubbish Amulet
	{ id = 3039, chance = 6120 }, -- Red Gem
	{ id = 3037, chance = 5790 }, -- Yellow Gem
	{ id = 236, chance = 6050 }, -- Strong Health Potion
	{ id = 16124, chance = 860 }, -- Blue Crystal Splinter
	{ id = 3063, chance = 330 }, -- Gold Ring
	{ id = 3081, chance = 989 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -225 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -150, range = 7, shootEffect = CONST_ANI_FIRE, target = true },
}

monster.defenses = {
	defense = 35,
	armor = 35,
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 450, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -1 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = -1 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -1 },
	{ type = COMBAT_HOLYDAMAGE, percent = 1 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
