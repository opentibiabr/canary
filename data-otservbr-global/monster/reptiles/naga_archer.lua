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
	{ id = 3035, chance = 100000, maxCount = 13 }, -- Platinum Coin
	{ id = 3007, chance = 6347 }, -- Crystal Ring
	{ id = 39413, chance = 16586 }, -- Naga Archer Scales
	{ id = 39411, chance = 6813 }, -- Naga Armring
	{ id = 39412, chance = 12847 }, -- Naga Earring
	{ id = 3349, chance = 3630 }, -- Crossbow
	{ id = 3347, chance = 3579 }, -- Hunting Spear
	{ id = 16119, chance = 2580 }, -- Blue Crystal Shard
	{ id = 3017, chance = 1134 }, -- Silver Brooch
	{ id = 3350, chance = 1724 }, -- Bow
	{ id = 14247, chance = 603 }, -- Ornate Crossbow
	{ id = 7441, chance = 904 }, -- Ice Cube
	{ id = 3010, chance = 486 }, -- Emerald Bangle
	{ id = 24392, chance = 230 }, -- Gemmed Figurine
	{ id = 16163, chance = 326 }, -- Crystal Crossbow
	{ id = 7438, chance = 333 }, -- Elvish Bow
	{ id = 7443, chance = 145 }, -- Bullseye Potion
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
