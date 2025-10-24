local mType = Game.createMonsterType("Werewolf")
local monster = {}

monster.description = "a werewolf"
monster.experience = 1900
monster.outfit = {
	lookType = 308,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 510
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Vengoth Castle, Vengoth Werewolf Cave, Grimvale, were-beasts cave south-west of Edron.",
}

monster.health = 1955
monster.maxHealth = 1955
monster.race = "blood"
monster.corpse = 18099
monster.speed = 140
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 300,
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

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "war wolf", chance = 40, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "GRRR", yell = true },
	{ text = "GRROARR", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 98996, maxCount = 225 }, -- Gold Coin
	{ id = 10317, chance = 10317 }, -- Werewolf Fur
	{ id = 22052, chance = 15789 }, -- Werewolf Fangs
	{ id = 3410, chance = 9924 }, -- Plate Shield
	{ id = 8895, chance = 7970 }, -- Rusted Armor
	{ id = 3725, chance = 6908 }, -- Brown Mushroom
	{ id = 22083, chance = 1376 }, -- Moonlight Crystals
	{ id = 3741, chance = 4933 }, -- Troll Green
	{ id = 236, chance = 5360 }, -- Strong Health Potion
	{ id = 5897, chance = 4958 }, -- Wolf Paw
	{ id = 3269, chance = 2921 }, -- Halberd
	{ id = 7643, chance = 2192 }, -- Ultimate Health Potion
	{ id = 7439, chance = 1034 }, -- Berserk Potion
	{ id = 3081, chance = 787 }, -- Stone Skin Amulet
	{ id = 3055, chance = 649 }, -- Platinum Amulet
	{ id = 3053, chance = 701 }, -- Time Ring
	{ id = 3326, chance = 601 }, -- Epee
	{ id = 7383, chance = 492 }, -- Relic Sword
	{ id = 7428, chance = 326 }, -- Bonebreaker
	{ id = 7419, chance = 55 }, -- Dreaded Cleaver
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350 },
	{ name = "outfit", interval = 2000, chance = 1, radius = 1, effect = CONST_ME_SOUND_BLUE, target = true, duration = 2000, outfitMonster = "werewolf" },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -80, maxDamage = -200, length = 4, spread = 2, effect = CONST_ME_SOUND_RED, target = false },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, radius = 3, effect = CONST_ME_SOUND_WHITE, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, radius = 1, effect = CONST_ME_SOUND_GREEN, target = false },
	{ name = "werewolf skill reducer", interval = 2000, chance = 15, range = 1, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 36,
	mitigation = 0.83,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 120, maxDamage = 225, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 400, range = 7, effect = CONST_ME_SOUND_PURPLE, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 75 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 55 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
