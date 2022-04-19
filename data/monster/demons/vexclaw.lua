--# Monster converted using Devm monster converter #--
local mType = Game.createMonsterType("Vexclaw")
local monster = {}

monster.description = "a vexclaw"
monster.experience = 6248
monster.outfit = {
	lookType = 854,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1197
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "The Dungeons of The Ruthless Seven."
	}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "fire"
monster.corpse = 22776
monster.speed = 270
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Weakness must be culled!", yell = false},
	{text = "Power is miiiiine!", yell = false}
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 200}, -- gold coin
	{id = 3035, chance = 100000, maxCount = 6}, -- platinum coin
	{id = 7642, chance = 26010, maxCount = 5}, -- great spirit potion
	{id = 238, chance = 25210, maxCount = 5}, -- great mana potion
	{id = 22728, chance = 21500}, -- vexclaw talon
	{id = 6499, chance = 20730}, -- demonic essence
	{id = 7643, chance = 19960, maxCount = 5}, -- ultimate health potion
	{id = 3731, chance = 19940, maxCount = 6}, -- fire mushroom
	{id = 3306, chance = 18940}, -- golden sickle
	{id = 2848, chance = 18450}, -- purple tome
	{id = 3033, chance = 10090, maxCount = 5}, -- small amethyst
	{id = 9057, chance = 9790, maxCount = 5}, -- small topaz
	{id = 3032, chance = 9770, maxCount = 5}, -- small emerald
	{id = 3030, chance = 9590, maxCount = 5}, -- small ruby
	{id = 3034, chance = 5400}, -- talon
	{id = 3037, chance = 5090}, -- yellow gem
	{id = 8094, chance = 4940}, -- wand of voodoo
	{id = 3039, chance = 4730}, -- red gem
	{id = 3284, chance = 4730}, -- ice rapier
	{id = 3320, chance = 3520}, -- fire axe
	{id = 3048, chance = 2250}, -- might ring
	{id = 3281, chance = 1880}, -- giant sword
	{id = 3049, chance = 1790}, -- stealth ring
	{id = 3051, chance = 1790}, -- energy ring
	{id = 22727, chance = 1360}, -- rift lance
	{id = 3098, chance = 1320}, -- ring of healing
	{id = 3055, chance = 940}, -- platinum amulet
	{id = 3356, chance = 520}, -- devil helmet
	{id = 22867, chance = 370}, -- rift crossbow
	{id = 3366, chance = 70}, -- magic plate armor
	{id = 7382, chance = 30} -- demonrage sword
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 75, attack = 150},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -120, range = 7, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -250, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	-- {name ="choking fear drown", interval = 2000, chance = 20, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -400, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -200, length = 8, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false},
	{name ="firefield", interval = 2000, chance = 10, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -490, length = 8, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false},
	-- {name ="energy strike", interval = 2000, chance = 10, minDamage = -210, maxDamage = -300, range = 1, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -300, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000}
}

monster.defenses = {
	defense = 55,
	armor = 55,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 180, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 30},
	{type = COMBAT_ENERGYDAMAGE, percent = 50},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 30}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
