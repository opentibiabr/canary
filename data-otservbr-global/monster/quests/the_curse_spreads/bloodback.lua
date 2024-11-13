local mType = Game.createMonsterType("Bloodback")
local monster = {}

monster.description = "Bloodback"
monster.experience = 4000
monster.outfit = {
	lookType = 1039,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 5200
monster.maxHealth = 5200
monster.race = "blood"
monster.corpse = 27718
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1560,
	bossRace = RARITY_ARCHFOE,
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
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Wereboar", chance = 20, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You will DIE!", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 13600000, maxCount = 100 },
	{ name = "gold coin", chance = 13600000, maxCount = 100 },
	{ name = "platinum coin", chance = 13600000, maxCount = 10 },
	{ name = "great health potion", chance = 13600000, maxCount = 10 },
	{ name = "red crystal fragment", chance = 13600000, maxCount = 2 },
	{ name = "small enchanted ruby", chance = 13600000, maxCount = 3 },
	{ name = "furry club", chance = 13600000 },
	{ id = 3039, chance = 13600000 }, -- red gem
	{ name = "spiked squelcher", chance = 13600000 },
	{ name = "stone skin amulet", chance = 13600000 },
	{ name = "wereboar hooves", chance = 13600000, maxCount = 2 },
	{ name = "wereboar loincloth", chance = 13600000, maxCount = 2 },
	{ name = "wereboar tusks", chance = 13600000, maxCount = 2 },
	{ name = "dreaded cleaver", chance = 400 },
	{ name = "fur armor", chance = 400 },
	{ name = "fur boots", chance = 400 },
	{ id = 22102, chance = 250 }, -- wereboar trophy
	{ name = "silver token", chance = 250 },
	{ name = "wolf backpack", chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -290 },
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -420, range = 7, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -600, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
	{ name = "combat", interval = 1000, chance = 14, type = COMBAT_DEATHDAMAGE, minDamage = -100, maxDamage = -200, length = 5, spread = 0, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 40,
	--	mitigation = ???,
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 150, maxDamage = 345, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
