--# Monster converted using Devm monster converter #--
local mType = Game.createMonsterType("Dragon")
local monster = {}

monster.description = "a dragon"
monster.experience = 700
monster.outfit = {
	lookType = 34,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 34
monster.Bestiary = {
	class = "Dragon",
	race = BESTY_RACE_DRAGON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Thais Ancient Temple, Darashia Dragon Lair, Mount Sternum Dragon Cave, Mintwallin, \z
		deep in Fibula Dungeon, Kazordoon Dragon Lair (near Dwarf Bridge), Plains of Havoc, Elven Bane castle, \z
		Maze of Lost Souls, southern cave and dragon tower in Shadowthorn, Orc Fortress, Venore Dragon Lair, \z
		Pits of Inferno, Behemoth Quest room in Edron, Hero Cave, deep Cyclopolis, Edron Dragon Lair, Goroma, \z
		Ankrahmun Dragon Lairs, Draconia, Dragonblaze Peaks, some Ankrahmun Tombs, \z
		underground of Fenrock (on the way to Beregar), Krailos Steppe and Crystal Lakes."
	}

monster.health = 1000
monster.maxHealth = 1000
monster.race = "blood"
monster.corpse = 4025
monster.speed = 86
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 300,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "GROOAAARRR", yell = true},
	{text = "FCHHHHH", yell = true}
}

monster.loot = {
	{id = 3028, chance = 380}, -- small diamond
	{id = 3031, chance = 47500, maxCount = 70}, -- gold coin
	{id = 3031, chance = 37500, maxCount = 45}, -- gold coin
	{id = 3061, chance = 120}, -- life crystal
	{id = 3071, chance = 1005}, -- wand of inferno
	{id = 3275, chance = 960}, -- double axe
	{id = 3285, chance = 4000}, -- longsword
	{id = 3297, chance = 420}, -- serpent sword
	{id = 3301, chance = 1950}, -- broadsword
	{id = 3322, chance = 560}, -- dragon hammer
	{id = 3349, chance = 10000}, -- crossbow
	{id = 3351, chance = 3000}, -- steel helmet
	{id = 3409, chance = 15000}, -- steel shield
	{id = 3416, chance = 320}, -- dragon shield
	{id = 3449, chance = 8060, maxCount = 10}, -- burst arrow
	{id = 3557, chance = 2000}, -- plate legs
	{id = 3583, chance = 65500, maxCount = 3}, -- dragon ham
	{id = 5877, chance = 1005}, -- green dragon leather
	{id = 5920, chance = 1000}, -- green dragon scale
	{id = 7430, chance = 110}, -- dragonbone staff
	{id = 236, chance = 1000}, -- strong health potion
	{id = 11457, chance = 9740} -- dragon's tail
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -120},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -60, maxDamage = -140, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -170, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 40, maxDamage = 70, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 80},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
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
