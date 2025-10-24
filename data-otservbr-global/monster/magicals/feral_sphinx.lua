local mType = Game.createMonsterType("Feral Sphinx")
local monster = {}

monster.description = "a feral sphinx"
monster.experience = 8800
monster.outfit = {
	lookType = 1188,
	lookHead = 76,
	lookBody = 75,
	lookLegs = 57,
	lookFeet = 0,
	lookAddons = 2,
	lookMount = 0,
}

monster.raceId = 1807
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Kilmaresh, south of Issavi.",
}

monster.health = 9800
monster.maxHealth = 9800
monster.race = "blood"
monster.corpse = 31658
monster.speed = 160
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
	{ text = "I am not as kind as my sisters!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 3 }, -- Platinum Coin
	{ id = 31437, chance = 5820 }, -- Sphinx Feather
	{ id = 3085, chance = 7152 }, -- Dragon Necklace
	{ id = 817, chance = 6289 }, -- Magma Amulet
	{ id = 3071, chance = 5898 }, -- Wand of Inferno
	{ id = 3029, chance = 5509 }, -- Small Sapphire
	{ id = 3039, chance = 8680 }, -- Red Gem
	{ id = 16121, chance = 7180 }, -- Green Crystal Shard
	{ id = 16125, chance = 9370 }, -- Cyan Crystal Fragment
	{ id = 818, chance = 2278 }, -- Magma Boots
	{ id = 821, chance = 1761 }, -- Magma Legs
	{ id = 3320, chance = 3720 }, -- Fire Axe
	{ id = 827, chance = 1716 }, -- Magma Monocle
	{ id = 8093, chance = 4349 }, -- Wand of Draconia
	{ id = 31438, chance = 5275 }, -- Sphinx Tiara
	{ id = 677, chance = 1410 }, -- Small Enchanted Emerald
	{ id = 3041, chance = 4190 }, -- Blue Gem
	{ id = 3038, chance = 1590 }, -- Green Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "fire wave", interval = 2000, chance = 15, minDamage = -350, maxDamage = -500, length = 1, spread = 0, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -500, radius = 4, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -550, range = 1, shootEffect = CONST_ANI_FIRE, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_HOLYDAMAGE, minDamage = -400, maxDamage = -580, length = 6, spread = 3, effect = CONST_ME_HOLYAREA, target = false },
}

monster.defenses = {
	defense = 90,
	armor = 90,
	mitigation = 2.69,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 425, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
