local mType = Game.createMonsterType("Naga Archer")
local monster = {}

monster.description = "a naga archer"
monster.experience = 5150
monster.outfit = {
	lookType = 1537,
	lookHead = 55,
	lookBody = 6,
	lookLegs = 0,
	lookFeet = 78,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2260
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_AMPHIBIC,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Temple of the Moon Goddess.",
}

monster.health = 4640
monster.maxHealth = 4640
monster.race = "blood"
monster.corpse = 39225
monster.speed = 182
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 3,
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
	{ text = "Intruder! Don't violate this sanctuary!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 13 }, -- platinum coin
	{ id = 6093, chance = 23000 }, -- crystal ring
	{ id = 39413, chance = 23000 }, -- naga archer scales
	{ id = 39411, chance = 23000 }, -- naga armring
	{ id = 39412, chance = 23000 }, -- naga earring
	{ id = 3349, chance = 5000 }, -- crossbow
	{ id = 3347, chance = 5000 }, -- hunting spear
	{ id = 16119, chance = 5000 }, -- blue crystal shard
	{ id = 3017, chance = 5000 }, -- silver brooch
	{ id = 3350, chance = 5000 }, -- bow
	{ id = 14247, chance = 1000 }, -- ornate crossbow
	{ id = 7741, chance = 1000 }, -- ice cube
	{ id = 3010, chance = 1000 }, -- emerald bangle
	{ id = 24392, chance = 260 }, -- gemmed figurine
	{ id = 16163, chance = 260 }, -- crystal crossbow
	{ id = 7438, chance = 260 }, -- elvish bow
	{ id = 7443, chance = 260 }, -- bullseye potion
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_PHYSICALDAMAGE, minDamage = -95, maxDamage = -390, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_PURPLEENERGY, range = 6, target = true }, -- basic_attack
	{ name = "nagadeathattack", interval = 2500, chance = 20, minDamage = -430, maxDamage = -505, range = 6, target = true }, -- death_strike
	{ name = "nagadeath", interval = 3000, chance = 20, minDamage = -380, maxDamage = -470, target = false }, -- short_death_wave
	{ name = "death chain", interval = 3500, chance = 20, minDamage = -460, maxDamage = -520, range = 6, target = true }, -- death_chain
	{ name = "combat", interval = 4000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -85, maxDamage = -190, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_PURPLEENERGY, range = 6, target = true }, -- explosion_strike
}

monster.defenses = {
	defense = 110,
	armor = 63,
	mitigation = 1.74,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
