local mType = Game.createMonsterType("Mooh'Tah Warrior")
local monster = {}

monster.description = "a mooh'tah warrior"
monster.experience = 900
monster.outfit = {
	lookType = 611,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1051
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Oramond/Southern Plains, Minotaur Hills, \z
		Oramond Dungeon (depending on Magistrate votes), Underground Glooth Factory."
	}

monster.health = 1200
monster.maxHealth = 1200
monster.race = "blood"
monster.corpse = 21091
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 4
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
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Feel the power of the Mooh'Tah!", yell = false},
	{text = "Ommm!", yell = false}
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 120}, -- gold coin
	{id = 3035, chance = 39860, maxCount = 3}, -- platinum coin
	{id = 21202, chance = 15030}, -- mooh'tah shell
	{id = 237, chance = 7110}, -- strong mana potion
	{id = 236, chance = 6390}, -- strong health potion
	{id = 5878, chance = 5530}, -- minotaur leather
	{id = 3030, chance = 5470}, -- small ruby
	{id = 3032, chance = 5280}, -- small emerald
	{id = 3033, chance = 5200}, -- small amethyst
	{id = 9057, chance = 4760}, -- small topaz
	{id = 11472, chance = 4710, maxCount = 2}, -- minotaur horn
	{id = 21177, chance = 1380}, -- cowtana
	{id = 3091, chance = 1110}, -- sword ring
	{id = 21166, chance = 1090}, -- mooh'tah plate
	{id = 3415, chance = 1020}, -- guardian shield
	{id = 3371, chance = 710}, -- knight legs
	{id = 5911, chance = 650}, -- red piece of cloth
	{id = 3370, chance = 490}, -- knight armor
	{id = 7401, chance = 150} -- minotaur trophy
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 45, attack = 80},
	{name ="combat", interval = 2000, chance = 14, type = COMBAT_ENERGYDAMAGE, minDamage = -150, maxDamage = -200, length = 4, spread = 3, effect = CONST_ME_YELLOWENERGY, target = false},
	{name ="combat", interval = 2000, chance = 11, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -135, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_EXPLOSIONAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -150, radius = 3, effect = CONST_ME_HITAREA, target = false},
	{name ="mooh'tah master skill reducer", interval = 2000, chance = 19, range = 7, target = false}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="combat", interval = 2000, chance = 22, type = COMBAT_HEALING, minDamage = 110, maxDamage = 160, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="haste", interval = 2000, chance = 8, speedChange = 220, effect = CONST_ME_MAGIC_RED, target = false, duration = 1000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 5},
	{type = COMBAT_ENERGYDAMAGE, percent = 5},
	{type = COMBAT_EARTHDAMAGE, percent = 10},
	{type = COMBAT_FIREDAMAGE, percent = 15},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 15}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
