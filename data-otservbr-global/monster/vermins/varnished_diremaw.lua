local mType = Game.createMonsterType("Varnished Diremaw")
local monster = {}

monster.description = "a varnished diremaw"
monster.experience = 5900
monster.outfit = {
	lookType = 1397,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2090
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Dwelling of the Forgotten.",
}

monster.health = 9000
monster.maxHealth = 9000
monster.race = "blood"
monster.corpse = 36688
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	level = 3,
	color = 71,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 11 }, -- platinum coin
	{ id = 3065, chance = 80000 }, -- terra rod
	{ id = 3010, chance = 23000 }, -- emerald bangle
	{ id = 3028, chance = 23000 }, -- small diamond
	{ id = 3032, chance = 23000 }, -- small emerald
	{ id = 3038, chance = 23000 }, -- green gem
	{ id = 36706, chance = 23000 }, -- red gem
	{ id = 3067, chance = 23000 }, -- hailstorm rod
	{ id = 16120, chance = 23000 }, -- violet crystal shard
	{ id = 16121, chance = 23000 }, -- green crystal shard
	{ id = 16122, chance = 23000 }, -- green crystal splinter
	{ id = 16123, chance = 23000 }, -- brown crystal splinter
	{ id = 16125, chance = 23000 }, -- cyan crystal fragment
	{ id = 36781, chance = 23000 }, -- varnished diremaw brainpan
	{ id = 36782, chance = 23000 }, -- varnished diremaw legs
	{ id = 819, chance = 5000 }, -- glacier shoes
	{ id = 823, chance = 5000 }, -- glacier kilt
	{ id = 3419, chance = 5000 }, -- crown shield
	{ id = 3575, chance = 5000 }, -- wood cape
	{ id = 7387, chance = 5000 }, -- diamond sceptre
	{ id = 7407, chance = 5000 }, -- haunted blade
	{ id = 8073, chance = 5000 }, -- spellbook of warding
	{ id = 8084, chance = 5000 }, -- springsprout rod
	{ id = 8092, chance = 5000 }, -- wand of starstorm
	{ id = 22085, chance = 5000 }, -- fur armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_ICEDAMAGE, minDamage = -700, maxDamage = -750, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = true }, -- avalanche
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_HOLYDAMAGE, minDamage = -730, maxDamage = -750, radius = 3, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_ICEDAMAGE, minDamage = -800, maxDamage = -850, range = 4, shootEffect = CONST_ANI_ICE, target = true },
}

monster.defenses = {
	defense = 5,
	armor = 50,
	mitigation = 1.60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
