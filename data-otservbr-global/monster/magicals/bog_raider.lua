local mType = Game.createMonsterType("Bog Raider")
local monster = {}

monster.description = "a bog raider"
monster.experience = 800
monster.outfit = {
	lookType = 299,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 460
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Underneath Malada and Talahu, Edron Bog Raider Cave in Stonehome, \z
		Edron Earth Elemental Cave, Alchemist Quarter, Vengoth Castle, Robson Isle. Oramond Hydra/Bog Raider Cave.",
}

monster.health = 1300
monster.maxHealth = 1300
monster.race = "venom"
monster.corpse = 8123
monster.speed = 125
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
	staticAttackChance = 60,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 4,
	color = 30,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Tchhh!", yell = false },
	{ text = "Slurp!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 105 }, -- gold coin
	{ id = 9667, chance = 23000 }, -- boggy dreads
	{ id = 239, chance = 5000 }, -- great health potion
	{ id = 7642, chance = 5000 }, -- great spirit potion
	{ id = 3557, chance = 5000 }, -- plate legs
	{ id = 8044, chance = 1000 }, -- belted cape
	{ id = 8084, chance = 1000 }, -- springsprout rod
	{ id = 7643, chance = 1000 }, -- ultimate health potion
	{ id = 8063, chance = 260 }, -- paladin armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -183, condition = { type = CONDITION_POISON, totalDamage = 80, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -90, maxDamage = -140, range = 7, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -175, radius = 3, effect = CONST_ME_BUBBLES, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -96, maxDamage = -110, range = 7, shootEffect = CONST_ANI_SMALLEARTH, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -600, range = 7, effect = CONST_ME_SMALLPLANTS, target = true, duration = 15000 },
}

monster.defenses = {
	defense = 0,
	armor = 20,
	mitigation = 0.78,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 65, maxDamage = 95, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = 85 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
