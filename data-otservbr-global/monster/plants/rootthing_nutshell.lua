local mType = Game.createMonsterType("Rootthing Nutshell")
local monster = {}

monster.description = "a rootthing nutshell"
monster.experience = 9200
monster.outfit = {
	lookType = 1760,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2540
monster.Bestiary = {
	class = "Plant",
	race = BESTY_RACE_PLANT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Podzilla Stalk",
}

monster.health = 13500
monster.maxHealth = 13500
monster.race = "venom"
monster.corpse = 48397
monster.speed = 190
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
	canPushCreatures = false,
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
	{ text = "<CREEAK>", yell = true },
	{ text = "<KNARRR>", yell = true },
	{ text = "<KNOORRR>", yell = true },
}

monster.loot = {
	{ id = 48510, chance = 23000 }, -- demon root
	{ id = 31577, chance = 5000 }, -- terra helmet
	{ id = 3032, chance = 5000 }, -- small emerald
	{ id = 3326, chance = 5000 }, -- epee
	{ id = 48511, chance = 5000 }, -- resin parasite
	{ id = 3038, chance = 1000 }, -- green gem
	{ id = 8052, chance = 1000 }, -- swamplair armor
	{ id = 6553, chance = 260 }, -- ruthless axe
	{ id = 6553, chance = 260 }, -- ruthless axe
	{ id = 45652, chance = 260 }, -- preserved pink seed
	{ id = 45653, chance = 260 }, -- preserved red seed
	{ id = 45657, chance = 260 }, -- preserved yellow seed
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -670 },
	{ name = "rotthligulus", interval = 2000, chance = 20, minDamage = -750, maxDamage = -1100 },
	{ name = "rotthingwave", interval = 2000, chance = 20 },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -700, range = 6, effect = CONST_ME_BITE, target = true },
}

monster.defenses = {
	defense = 85,
	armor = 85,
	mitigation = 2.31,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
