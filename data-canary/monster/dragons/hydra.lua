--# Monster converted using Devm monster converter #--
local mType = Game.createMonsterType("Hydra")
local monster = {}

monster.description = "a hydra"
monster.experience = 2100
monster.outfit = {
	lookType = 121,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 121
monster.Bestiary = {
	class = "Dragon",
	race = BESTY_RACE_DRAGON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Many on the northern Hydra Mountain in east Tiquanda, 3-4 on the southern Hydra Mountain, \z
		1 at the Hydra Egg Quest in Tiquanda, 1 north-east of the Elephant Tusk Quest, \z
		2 above the Forbidden Lands hydra cave here and many inside it, many in Deeper Banuta, \z
		many on Talahu surface, a few in Ferumbras Citadel basement on Kharos, \z
		2 on a hill in the Yalahar Arena and Zoo Quarter, 1 deep in the Yalahar Foreigner Quarter (Crystal Lake), \z
		many in the Oramond Hydra/Bog Raider Cave."
	}

monster.health = 2350
monster.maxHealth = 2350
monster.race = "blood"
monster.corpse = 6048
monster.speed = 180
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 300,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
	{text = "FCHHHHH", yell = false},
	{text = "HISSSS", yell = false}
}

monster.loot = {
	{id = 3029, chance = 5000}, -- small sapphire
	{id = 3031, chance = 34000, maxCount = 100}, -- gold coin
	{id = 3031, chance = 34000, maxCount = 100}, -- gold coin
	{id = 3031, chance = 20000, maxCount = 46}, -- gold coin
	{id = 3035, chance = 48000, maxCount = 3}, -- platinum coin
	{id = 3061, chance = 570}, -- life crystal
	{id = 3079, chance = 130}, -- boots of haste
	{id = 3081, chance = 900}, -- stone skin amulet
	{id = 3098, chance = 1190}, -- ring of healing
	{id = 3369, chance = 890}, -- warrior helmet
	{id = 3370, chance = 1000}, -- knight armor
	{id = 3392, chance = 210}, -- royal helmet
	{id = 3436, chance = 270}, -- medusa shield
	{id = 3582, chance = 60000, maxCount = 4}, -- ham
	{id = 4839, chance = 930}, -- hydra egg
	{id = 237, chance = 380}, -- strong mana potion
	{id = 8014, chance = 4780}, -- cucumber
	{id = 10282, chance = 10120} -- hydra head
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -270},
	{name ="speed", interval = 2000, chance = 25, speedChange = -700, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_GREEN_RINGS, target = true, duration = 15000},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -250, length = 8, spread = 3, effect = CONST_ME_LOSEENERGY, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -80, maxDamage = -155, shootEffect = CONST_ANI_SMALLICE, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -66, maxDamage = -320, length = 8, spread = 3, effect = CONST_ME_CARNIPHILA, target = false}
}

monster.defenses = {
	defense = 35,
	armor = 35,
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 260, maxDamage = 407, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -5},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
