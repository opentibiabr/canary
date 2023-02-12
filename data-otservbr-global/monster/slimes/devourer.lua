local mType = Game.createMonsterType("Devourer")
local monster = {}

monster.description = "a devourer"
monster.experience = 1755
monster.outfit = {
	lookType = 617,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1056
monster.Bestiary = {
	class = "Slime",
	race = BESTY_RACE_SLIME,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Rathleton Sewers, Lower Rathleton, Oramond/Western Plains, \z
		Underground Glooth Factory, Jaccus Maxxen's Dungeon."
	}

monster.health = 1900
monster.maxHealth = 1900
monster.race = "venom"
monster.corpse = 21113
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
	chance = 0
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "*gulp*", yell = false},
	{text = "*Bruaarrr!*", yell = false},
	{text = "*omnnommm nomm*", yell = false}
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 165}, -- gold coin
	{id = 3035, chance = 9100, maxCount = 2}, -- platinum coin
	{id = 21182, chance = 1670}, -- glob of glooth
	{id = 3034, chance = 940}, -- talon
	{id = 3029, chance = 1170, maxCount = 3}, -- small sapphire
	{id = 3033, chance = 1030, maxCount = 3}, -- small amethyst
	{id = 9057, chance = 1030, maxCount = 3}, -- small topaz
	{id = 3032, chance = 1170, maxCount = 3}, -- small emerald
	{id = 3030, chance = 1190, maxCount = 3}, -- small ruby
	{id = 3028, chance = 1050, maxCount = 3}, -- small diamond
	{id = 3037, chance = 1090}, -- yellow gem
	{id = 3038, chance = 100}, -- green gem
	{id = 21164, chance = 210}, -- glooth cape
	{id = 21183, chance = 130}, -- glooth amulet
	{id = 21179, chance = 350}, -- glooth blade
	{id = 21178, chance = 510}, -- glooth club
	{id = 21180, chance = 390}, -- glooth axe
	{id = 21158, chance = 370}, -- glooth spear
	{id = 8084, chance = 250}, -- springsprout rod
	{id = 3065, chance = 260} -- terra rod
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 62, attack = 50, condition = {type = CONDITION_POISON, totalDamage = 360, interval = 4000}},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -40, maxDamage = -125, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_MAGIC_RED, target = true},
	{name ="combat", interval = 2000, chance = 8, type = COMBAT_EARTHDAMAGE, minDamage = -50, maxDamage = -160, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_GREEN_RINGS, target = true},
	{name ="devourer wave", interval = 2000, chance = 5, minDamage = -50, maxDamage = -150, target = false},
	{name ="devourer paralyze", interval = 2000, chance = 9, target = false},
	{name ="combat", interval = 2000, chance = 11, type = COMBAT_EARTHDAMAGE, minDamage = -50, maxDamage = -150, length = 1, spread = 0, effect = CONST_ME_SMOKE, target = false},
	{name ="combat", interval = 2000, chance = 7, type = COMBAT_EARTHDAMAGE, minDamage = -120, maxDamage = -135, radius = 4, effect = CONST_ME_GREEN_RINGS, target = false}
}

monster.defenses = {
	defense = 25,
	armor = 15,
	{name ="combat", interval = 2000, chance = 6, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_GREEN, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 15},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
