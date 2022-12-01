local mType = Game.createMonsterType("Tremendous Tyrant")
local monster = {}

monster.description = "a tremendous tyrant"
monster.experience = 6100
monster.outfit = {
	lookType = 1396,
	lookHead = 60,
	lookBody = 84,
	lookLegs = 40,
	lookFeet = 94,
	lookAddons = 3,
	lookMount = 0
}

monster.raceId = 2089
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Dwelling of the Forgotten"
}

monster.health = 11500
monster.maxHealth = 11500
monster.race = "blood"
monster.corpse = 36684
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 10
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "naps naps naps!", yell = false}
}

monster.loot = {
	{name = "platinum coin", chance = 70000, maxCount = 24},
	{name = "gold ingot", chance = 11820, maxCount = 2},
	{id = 3039, chance = 14550, maxCount = 1}, -- red gem
	{name = "violet crystal shard", chance = 6360, maxCount = 3},
	{name = "green crystal shard", chance = 5450},
	{name = "blue crystal shard", chance = 5450},
	{name = "tremendous tyrant shell", chance = 4550},
	{name = "yellow gem", chance = 9090, maxCount = 1},
	{name = "spellbook of warding", chance = 8180},
	{name = "wand of starstorm", chance = 910},
	{name = "ice rapier", chance = 1820},
	{name = "hailstorm rod", chance = 2730},
	{name = "knight axe", chance = 4550},
	{name = "dragonbone staff", chance = 3640},
	{name = "tremendous tyrant head", chance = 8180},
	{name = "wand of cosmic energy", chance = 2730},
	{name = "warrior's shield", chance = 1820},
	{name = "elven amulet", chance = 2730},
	{name = "focus cape", chance = 1820},
	{name = "glacier robe", chance = 4555}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_ICEDAMAGE, minDamage = -600, maxDamage = -650, length = 5, spread = 0, effect = CONST_ME_ICEATTACK, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -600, maxDamage = -700, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = false}, -- avalanche
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_HOLYDAMAGE, minDamage = -750, maxDamage = -950, range = 5, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYAREA, target = true},
}

monster.defenses = {
	defense = 71,
	armor = 71
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = -20},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 100},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 15},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
