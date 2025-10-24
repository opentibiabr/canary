local mType = Game.createMonsterType("Brimstone Bug")
local monster = {}

monster.description = "a brimstone bug"
monster.experience = 900
monster.outfit = {
	lookType = 352,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 674
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Beneath Razachai, Northern Zao Plantations, Brimstone Bug Cave, Chyllfroest, Krailos Spider Lair",
}

monster.health = 1300
monster.maxHealth = 1300
monster.race = "venom"
monster.corpse = 11571
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
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
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 2,
	color = 66,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Chrrr!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 9640, chance = 49850 }, -- Poisonous Slime
	{ id = 10305, chance = 19750 }, -- Lump of Earth
	{ id = 10315, chance = 14870 }, -- Sulphurous Stone
	{ id = 11703, chance = 10180 }, -- Brimstone Shell
	{ id = 237, chance = 9160 }, -- Strong Mana Potion
	{ id = 236, chance = 9040 }, -- Strong Health Potion
	{ id = 11702, chance = 5959 }, -- Brimstone Fangs
	{ id = 3032, chance = 2790, maxCount = 4 }, -- Small Emerald
	{ id = 5904, chance = 1620 }, -- Magic Sulphur
	{ id = 3049, chance = 910 }, -- Stealth Ring
	{ id = 3055, chance = 80 }, -- Platinum Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -213, condition = { type = CONDITION_POISON, totalDamage = 400, interval = 4000 } },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -600, range = 7, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false, duration = 10000 },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_EARTHDAMAGE, minDamage = -140, maxDamage = -310, radius = 6, effect = CONST_ME_SMALLPLANTS, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -130, maxDamage = -200, length = 6, spread = 3, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "brimstone bug wave", interval = 2000, chance = 15, minDamage = -80, maxDamage = -120, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 38,
	mitigation = 1.18,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
