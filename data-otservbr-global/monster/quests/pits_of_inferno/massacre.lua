local mType = Game.createMonsterType("Massacre")
local monster = {}

monster.description = "Massacre"
monster.experience = 20000
monster.outfit = {
	lookType = 244,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 305,
	bossRace = RARITY_NEMESIS,
}

monster.health = 32000
monster.maxHealth = 32000
monster.race = "blood"
monster.corpse = 6335
monster.speed = 215
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5,
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
	{ text = "HATE! HATE! KILL! KILL!", yell = true },
	{ text = "GRRAAARRRHH!", yell = true },
	{ text = "GRRRR!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 89660, maxCount = 207 }, -- Gold Coin
	{ id = 3035, chance = 51720, maxCount = 6 }, -- Platinum Coin
	{ id = 3577, chance = 87501, maxCount = 9 }, -- Meat
	{ id = 5021, chance = 75860, maxCount = 6 }, -- Orichalcum Pearl
	{ id = 6499, chance = 98213 }, -- Demonic Essence
	{ id = 3116, chance = 3639 }, -- Big Bone
	{ id = 3106, chance = 56363 }, -- Old Twig
	{ id = 5944, chance = 98213 }, -- Soul Orb
	{ id = 239, chance = 5458 }, -- Great Health Potion
	{ id = 238, chance = 10907 }, -- Great Mana Potion
	{ id = 3360, chance = 1000 }, -- Golden Armor
	{ id = 6104, chance = 1000 }, -- Jewel Case
	{ id = 3340, chance = 1000 }, -- Heavy Mace
	{ id = 7403, chance = 3850 }, -- Berserker
	{ id = 3422, chance = 1000 }, -- Great Shield
	{ id = 6540, chance = 100000 }, -- Piece of Massacre's Shell
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 160, attack = 200 },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1100, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_EXPLOSIONAREA, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 45,
	--	mitigation = ???,
	{ name = "speed", interval = 2000, chance = 8, speedChange = 790, effect = CONST_ME_MAGIC_RED, target = false, duration = 10000 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 600, maxDamage = 1090, effect = CONST_ME_HITBYFIRE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -1 },
	{ type = COMBAT_EARTHDAMAGE, percent = 1 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
