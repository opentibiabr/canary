local mType = Game.createMonsterType("The Dread Maiden")
local monster = {}

monster.description = "The Dread Maiden"
monster.experience = 72000
monster.outfit = {
	lookType = 1278,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"FeasterOfSoulsBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1872,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "undead"
monster.corpse = 32744
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You will be mine for eternity!", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 100000, minCount = 1, maxCount = 2 }, -- crystal coin
	{ id = 32770, chance = 48000 }, -- diamond
	{ id = 32769, chance = 48000 }, -- white gem
	{ id = 23373, chance = 44000, minCount = 3, maxCount = 11 }, -- ultimate mana potion
	{ id = 32771, chance = 40000, minCount = 1, maxCount = 2 }, -- moonstone
	{ id = 23374, chance = 36000, minCount = 2, maxCount = 9 }, -- ultimate spirit potion
	{ id = 32772, chance = 20000 }, -- silver hand mirror
	{ id = 23375, chance = 20000, minCount = 4, maxCount = 9 }, -- supreme health potion
	{ id = 7443, chance = 16000, minCount = 2, maxCount = 16 }, -- bullseye potion
	{ id = 32773, chance = 16000 }, -- ivory comb
	{ id = 32626, chance = 12000 }, -- amber
	{ id = 7439, chance = 12000, minCount = 6, maxCount = 15 }, -- berserk potion
	{ id = 7440, chance = 12000, minCount = 4, maxCount = 15 }, -- mastermind potion
	{ id = 32703, chance = 8000, minCount = 1, maxCount = 3 }, -- death toll
	{ id = 32589, chance = 4000 }, -- angel figurine
	{ id = 32774, chance = 4000 }, -- cursed bone
	{ id = 32596, chance = 4000 }, -- dark bell (Silver)
	{ id = 32622, chance = 4000 }, -- giant amethyst
	{ id = 32595, chance = 4000 }, -- jagged sickle
	{ id = 32591, chance = 4000 }, -- soulforged lantern
	{ id = 32619, chance = 730 }, -- pair of nightmare boots
	{ id = 32631, chance = 730 }, -- ghost claw
	{ id = 32630, chance = 730 }, -- spooky hood
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -600, condition = { type = CONDITION_POISON, totalDamage = 4, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -350, maxDamage = -750, radius = 4, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "combat", interval = 4000, chance = 50, type = COMBAT_DEATHDAMAGE, minDamage = -600, maxDamage = -1500, length = 7, effect = CONST_ME_POFF, target = false },
	{ name = "dread rcircle", interval = 2000, chance = 40, minDamage = -400, maxDamage = -1000 },
}

monster.defenses = {
	defense = 170,
	armor = 170,
	--	mitigation = ???,
	{ name = "speed", interval = 10000, chance = 40, speedChange = 510, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 20000 },
	{ name = "combat", interval = 5000, chance = 60, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 2500, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
