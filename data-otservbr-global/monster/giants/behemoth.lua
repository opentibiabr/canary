local mType = Game.createMonsterType("Behemoth")
local monster = {}

monster.description = "a behemoth"
monster.experience = 2500
monster.outfit = {
	lookType = 55,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 55
monster.Bestiary = {
	class = "Giant",
	race = BESTY_RACE_GIANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Cyclopolis, deepest part of Tarpit Tomb after the flame, Forbidden Lands, Vandura Mountain, \z
		Deeper Banuta, Serpentine Tower (unreachable), deep into the Formorgar Mines, Arena and Zoo Quarter, \z
		The Dark Path, Lower Spike, Chyllfroest, Medusa Tower and Underground Glooth Factory (west side).",
}

monster.health = 4000
monster.maxHealth = 4000
monster.race = "blood"
monster.corpse = 5999
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "Crush the intruders!", yell = false },
	{ text = "You're so little!", yell = false },
	{ text = "Human flesh -  delicious!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 90070, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 43954, maxCount = 5 }, -- Platinum Coin
	{ id = 3577, chance = 32566, maxCount = 6 }, -- Meat
	{ id = 11447, chance = 9402 }, -- Battle Stone
	{ id = 3275, chance = 9390 }, -- Double Axe
	{ id = 7368, chance = 12239, maxCount = 5 }, -- Assassin Star
	{ id = 3033, chance = 5270, maxCount = 5 }, -- Small Amethyst
	{ id = 3265, chance = 4100 }, -- Two Handed Sword
	{ id = 239, chance = 1720 }, -- Great Health Potion
	{ id = 3383, chance = 3174 }, -- Dark Armor
	{ id = 3357, chance = 2587 }, -- Plate Armor
	{ id = 3008, chance = 743 }, -- Crystal Necklace
	{ id = 5893, chance = 1205 }, -- Perfect Behemoth Fang
	{ id = 3281, chance = 989 }, -- Giant Sword
	{ id = 3058, chance = 919 }, -- Strange Symbol
	{ id = 3116, chance = 4227 }, -- Big Bone
	{ id = 3456, chance = 3690 }, -- Pick
	{ id = 5930, chance = 664 }, -- Behemoth Claw
	{ id = 3554, chance = 440 }, -- Steel Boots
	{ id = 7396, chance = 115 }, -- Behemoth Trophy
	{ id = 2893, chance = 5802 }, -- Amphora
	{ id = 3304, chance = 8364 }, -- Crowbar
	{ id = 7413, chance = 105 }, -- Titan Axe
	{ id = 3342, chance = 131 }, -- War Axe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -200, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 50,
	mitigation = 1.74,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 300, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
