local mType = Game.createMonsterType("Squid Warden")
local monster = {}

monster.description = "a squid warden"
monster.experience = 15300
monster.outfit = {
	lookType = 1059,
	lookHead = 9,
	lookBody = 21,
	lookLegs = 3,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1669
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Secret Library (ice section).",
}

monster.health = 16500
monster.maxHealth = 16500
monster.race = "undead"
monster.corpse = 28786
monster.speed = 215
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 50417, maxCount = 50 }, -- Platinum Coin
	{ id = 28570, chance = 35950, maxCount = 6 }, -- Glowing Rune
	{ id = 3029, chance = 68104, maxCount = 3 }, -- Small Sapphire
	{ id = 9661, chance = 22725 }, -- Frosty Heart
	{ id = 7441, chance = 13981 }, -- Ice Cube
	{ id = 28568, chance = 15700 }, -- Inkwell (Black)
	{ id = 7643, chance = 15690 }, -- Ultimate Health Potion
	{ id = 23373, chance = 17470 }, -- Ultimate Mana Potion
	{ id = 3284, chance = 5230 }, -- Ice Rapier
	{ id = 829, chance = 8180 }, -- Glacier Mask
	{ id = 3333, chance = 5040 }, -- Crystal Mace
	{ id = 9663, chance = 4019 }, -- Piece of Dead Brain
	{ id = 7449, chance = 4591 }, -- Crystal Sword
	{ id = 824, chance = 2320 }, -- Glacier Robe
	{ id = 823, chance = 2730 }, -- Glacier Kilt
	{ id = 21194, chance = 4150 }, -- Slime Heart
	{ id = 7387, chance = 4059 }, -- Diamond Sceptre
	{ id = 7437, chance = 950 }, -- Sapphire Hammer
	{ id = 8050, chance = 670 }, -- Crystalline Armor
	{ id = 16118, chance = 740 }, -- Glacial Rod
	{ id = 9303, chance = 280 }, -- Leviathan's Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -300 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -200, range = 7, shootEffect = CONST_ANI_ICE, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -200, maxDamage = -680, range = 7, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -200, maxDamage = -375, length = 3, spread = 2, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_ICEDAMAGE, minDamage = -230, maxDamage = -480, range = 7, radius = 3, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICETORNADO, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 78,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
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
