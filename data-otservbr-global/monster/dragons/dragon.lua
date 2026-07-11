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
	lookMount = 0,
}

monster.events = {
	"TheGreatDragonHuntDeath",
	"TheFirstDragonDragonTaskDeath",
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
		underground of Fenrock (on the way to Beregar), Krailos Steppe and Crystal Lakes.",
}

monster.health = 1000
monster.maxHealth = 1000
monster.race = "blood"
monster.corpse = 5973
monster.speed = 86
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 300,
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
	{ text = "FCHHHHH", yell = true },
	{ text = "GROOAAARRR", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 90000, maxCount = 104 }, -- Gold Coin
	{ id = 3583, chance = 65000, maxCount = 2 }, -- Dragon Ham
	{ id = 3409, chance = 15100 }, -- Steel Shield
	{ id = 11457, chance = 10100 }, -- Dragon's Tail
	{ id = 3349, chance = 10100 }, -- Crossbow
	{ id = 3449, chance = 8000, maxCount = 10 }, -- Burst Arrow
	{ id = 3285, chance = 4000 }, -- Longsword
	{ id = 3351, chance = 3100 }, -- Steel Helmet
	{ id = 3557, chance = 2000 }, -- Plate Legs
	{ id = 3301, chance = 1700 }, -- Broadsword
	{ id = 3275, chance = 1100 }, -- Double Axe
	{ id = 3071, chance = 1000 }, -- Wand of Inferno
	{ id = 5877, chance = 980 }, -- Green Dragon Leather
	{ id = 236, chance = 930 }, -- Strong Health Potion
	{ id = 5920, chance = 890 }, -- Green Dragon Scale
	{ id = 3297, chance = 500 }, -- Serpent Sword
	{ id = 3028, chance = 460 }, -- Small Diamond
	{ id = 3322, chance = 430 }, -- Dragon Hammer
	{ id = 3416, chance = 300 }, -- Dragon Shield
	{ id = 3061, chance = 74 }, -- Life Crystal
	{ id = 44158, chance = 74 }, -- Dragon Trophy
	{ id = 7430, chance = 47 }, -- Dragonbone Staff
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -120 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -60, maxDamage = -140, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -170, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 25,
	mitigation = 0.99,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 40, maxDamage = 70, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
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
