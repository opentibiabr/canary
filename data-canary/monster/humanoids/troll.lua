--# Monster converted using Devm monster converter #--
local mType = Game.createMonsterType("Troll")
local monster = {}

monster.description = "a troll"
monster.experience = 20
monster.outfit = {
	lookType = 15,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 15
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 250,
	FirstUnlock = 10,
	SecondUnlock = 100,
	CharmsPoints = 5,
	Stars = 1,
	Occurrence = 0,
	Locations = "In many dungeons around Tibia like the troll cave in Thais, south of Carlin (out the east \z
		exit and down the hole), Island of Destiny, Edron Troll Cave, and in Ab'Dendriel. Also found in Rookgaard."
	}

monster.health = 50
monster.maxHealth = 50
monster.race = "blood"
monster.corpse = 5960
monster.speed = 63
monster.manaCost = 290

monster.changeTarget = {
	interval = 4000,
	chance = 0
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 15,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{text = "Grrr", yell = false},
	{text = "Groar", yell = false},
	{text = "Gruntz!", yell = false},
	{text = "Hmmm, bugs", yell = false},
	{text = "Hmmm, dogs", yell = false}
}

monster.loot = {
	{id = 3003, chance = 7950}, -- rope
	{id = 3031, chance = 65300, maxCount = 12}, -- gold coin
	{id = 3054, chance = 80}, -- silver amulet
	{id = 3268, chance = 18000}, -- hand axe
	{id = 3277, chance = 13000}, -- spear
	{id = 3336, chance = 5000}, -- studded club
	{id = 3355, chance = 12000}, -- leather helmet
	{id = 3412, chance = 4730}, -- wooden shield
	{id = 3552, chance = 10000}, -- leather boots
	{id = 3577, chance = 15000}, -- meat
	{id = 9689, chance = 1000}, -- bunch of troll hair
	{id = 23986, chance = 1000} -- heavy old tome
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -15}
}

monster.defenses = {
	defense = 10,
	armor = 10
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 25},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
