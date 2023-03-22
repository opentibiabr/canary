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
	lookMount = 0
}

monster.health = 32000
monster.maxHealth = 32000
monster.race = "blood"
monster.corpse = 6335
monster.speed = 215
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5
}

monster.bosstiary = {
	bossRaceId = 305,
	bossRace = RARITY_NEMESIS
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
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "HATE! HATE! KILL! KILL!", yell = true},
	{text = "GRRAAARRRHH!", yell = true},
	{text = "GRRRR!", yell = true}
}

monster.loot = {
	{id = 3116, chance = 5880}, -- big bone
	{id = 6499, chance = 100000}, -- demonic essence
	{id = 239, chance = 5880}, -- great health potion
	{id = 238, chance = 5880}, -- great mana potion
	{id = 3031, chance = 94120, maxCount = 157}, -- gold coin
	{id = 3422, chance = 500}, -- great shield
	{id = 3577, chance = 88240, maxCount = 9}, -- meat
	{id = 5021, chance = 82350, maxCount = 7}, -- orichalcum pearl
	{id = 3106, chance = 64710}, -- old twig
	{id = 3035, chance = 58820, maxCount = 6}, -- platinum coin
	{id = 6540, chance = 100000}, -- piece of massacre's shell
	{id = 5944, chance = 100000}, -- soul orb
	{id = 3340, chance = 1000}, -- heavy mace
	{id = 7403, chance = 900}, -- berserker
	{id = 3360, chance = 3500}, -- golden armor
	{id = 6104, chance = 1200} -- jewel case
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 160, attack = 200},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1100, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_EXPLOSIONAREA, target = false}
}

monster.defenses = {
	defense = 65,
	armor = 45,
	{name ="speed", interval = 2000, chance = 8, speedChange = 790, effect = CONST_ME_MAGIC_RED, target = false, duration = 10000},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 600, maxDamage = 1090, effect = CONST_ME_HITBYFIRE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -7},
	{type = COMBAT_EARTHDAMAGE, percent = 30},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = -3},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
