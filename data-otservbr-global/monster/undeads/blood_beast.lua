local mType = Game.createMonsterType("Blood Beast")
local monster = {}

monster.description = "a blood beast"
monster.experience = 1000
monster.outfit = {
	lookType = 602,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1040
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Oramond/Southern Plains, Lower Rathleton, Oramond/Western Plains, \z
		Underground Glooth Factory, Jaccus Maxxen's Dungeon."
	}

monster.health = 1600
monster.maxHealth = 1600
monster.race = "venom"
monster.corpse = 20980
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 4
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
	canWalkOnEnergy = true,
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
	{text = "Roarr!", yell = false}
}

monster.loot = {
	{id = 21178, chance = 2010}, -- glooth club
	{id = 9640, chance = 3080}, -- poisonous slime
	{id = 21146, chance = 2720}, -- glooth steak
	{id = 3031, chance = 100000, maxCount = 139}, -- gold coin
	{id = 21194, chance = 1040}, -- slime heart
	{id = 236, chance = 7710}, -- strong health potion
	{id = 7366, chance = 1290, maxCount = 5}, -- viper star
	{id = 21183, chance = 250}, -- glooth amulet
	{id = 21179, chance = 210}, -- glooth blade
	{id = 21178, chance = 210}, -- glooth club
	{id = 21180, chance = 250}, -- glooth axe
	{id = 21158, chance = 280} -- glooth spear
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 82, attack = 50, condition = {type = CONDITION_POISON, totalDamage = 260, interval = 4000}},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -65, maxDamage = -105, range = 5, shootEffect = CONST_ANI_GREENSTAR, effect = CONST_ME_POISONAREA, target = true},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 17, minDamage = -300, maxDamage = -400, radius = 4, effect = CONST_ME_MAGIC_GREEN, target = false}
}

monster.defenses = {
	defense = 36,
	armor = 23,
	{name ="speed", interval = 2000, chance = 8, speedChange = 314, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000},
	{name ="combat", interval = 2000, chance = 7, type = COMBAT_HEALING, minDamage = 80, maxDamage = 120, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
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
