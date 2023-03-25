--# Monster converted using Devm monster converter #--
local mType = Game.createMonsterType("Destroyer")
local monster = {}

monster.description = "a destroyer"
monster.experience = 2500
monster.outfit = {
	lookType = 236,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 287
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Pits of Inferno, Formorgar Mines, Alchemist Quarter, Oramond Dungeon."
	}

monster.health = 3700
monster.maxHealth = 3700
monster.race = "undead"
monster.corpse = 6319
monster.speed = 150
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
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
	{text = "COME HERE AND DIE!", yell = false},
	{text = "Destructiooooon!", yell = false},
	{text = "It's a good day to destroy!", yell = false}
}

monster.loot = {
	{id = 3008, chance = 578}, -- crystal necklace
	{id = 3031, chance = 60000, maxCount = 100}, -- gold coin
	{id = 3031, chance = 40000, maxCount = 100}, -- gold coin
	{id = 3031, chance = 40000, maxCount = 100}, -- gold coin
	{id = 3031, chance = 60000, maxCount = 41}, -- gold coin
	{id = 3033, chance = 7692, maxCount = 2}, -- small amethyst
	{id = 3035, chance = 4166, maxCount = 3}, -- platinum coin
	{id = 3062, chance = 564}, -- mind stone
	{id = 3281, chance = 1694}, -- giant sword
	{id = 3304, chance = 14285}, -- crowbar
	{id = 3357, chance = 4347}, -- plate armor
	{id = 3383, chance = 10000}, -- dark armor
	{id = 3449, chance = 12500, maxCount = 12}, -- burst arrow
	{id = 3456, chance = 6250}, -- pick
	{id = 3554, chance = 992}, -- steel boots
	{id = 3577, chance = 50000, maxCount = 6}, -- meat
	{id = 5741, chance = 108}, -- skull helmet
	{id = 5944, chance = 6666}, -- soul orb
	{id = 6299, chance = 144}, -- death ring
	{id = 6499, chance = 20000}, -- demonic essence
	{id = 7419, chance = 833}, -- dreaded cleaver
	{id = 7427, chance = 869}, -- chaos mace
	{id = 239, chance = 1136}, -- great health potion
	{id = 10298, chance = 7142} -- metal spike
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -200, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="speed", interval = 2000, chance = 15, speedChange = 420, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 25},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = 30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -15},
	{type = COMBAT_HOLYDAMAGE , percent = -3},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
