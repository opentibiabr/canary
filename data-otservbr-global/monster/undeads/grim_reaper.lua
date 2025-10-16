local mType = Game.createMonsterType("Grim Reaper")
local monster = {}

monster.description = "a grim reaper"
monster.experience = 5500
monster.outfit = {
	lookType = 300,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 465
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Drefia Grim Reaper Dungeons, deep in Drefia Wyrm Lair (after the Medusa Shield Quest), \z
		Edron (Hero Cave), Yalahar (Cemetery Quarter), Oramond Dungeon, \z
		  Abandoned Sewers and optionally in the Demon Oak Quest.",
}

monster.health = 3900
monster.maxHealth = 3900
monster.race = "undead"
monster.corpse = 8127
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 20,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "Death!", yell = false },
	{ text = "Come a little closer!", yell = false },
	{ text = "The end is near!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 273 }, -- gold coin
	{ id = 6558, chance = 80000 }, -- flask of demonic blood
	{ id = 6499, chance = 23000 }, -- demonic essence
	{ id = 238, chance = 23000 }, -- great mana potion
	{ id = 3453, chance = 23000 }, -- scythe
	{ id = 7643, chance = 23000 }, -- ultimate health potion
	{ id = 3035, chance = 5000, maxCount = 4 }, -- platinum coin
	{ id = 9660, chance = 5000 }, -- mystical hourglass
	{ id = 3421, chance = 5000 }, -- dark shield
	{ id = 3047, chance = 5000 }, -- magic light wand
	{ id = 8896, chance = 5000 }, -- slightly rusted armor
	{ id = 5021, chance = 5000, maxCount = 4 }, -- orichalcum pearl
	{ id = 7418, chance = 1000 }, -- nightmare blade
	{ id = 8082, chance = 1000 }, -- underworld rod
	{ id = 6299, chance = 260 }, -- death ring
	{ id = 823, chance = 260 }, -- glacier kilt
	{ id = 8061, chance = 260 }, -- skullcracker armor
	{ id = 3081, chance = 260 }, -- stone skin amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -320 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -165, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -350, maxDamage = -720, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -300, length = 7, spread = 0, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -225, maxDamage = -275, radius = 4, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 30,
	mitigation = 0.64,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 130, maxDamage = 205, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 450, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 65 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 80 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
