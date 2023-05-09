local mType = Game.createMonsterType("Stabilizing Dread Intruder")
local monster = {}

monster.description = "a stabilizing dread intruder"
monster.experience = 1900
monster.outfit = {
	lookType = 882,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1267
monster.Bestiary = {
	class = "Extra Dimensional",
	race = BESTY_RACE_EXTRA_DIMENSIONAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Otherworld (Edron)"
	}

monster.health = 2800
monster.maxHealth = 2800
monster.race = "venom"
monster.corpse = 23478
monster.speed = 145
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25
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
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Whirr!", yell = false}
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 100}, -- gold coin
	{id = 3035, chance = 20000, maxCount = 5}, -- platinum coin
	{id = 23535, chance = 12200}, -- energy bar
	{id = 238, chance = 10800}, -- great mana potion
	{id = 23513, chance = 9800}, -- strange proto matter
	{id = 23517, chance = 9400}, -- solid rage
	{id = 23522, chance = 9000}, -- glistening bone
	{id = 7643, chance = 8700}, -- ultimate health potion
	{id = 23545, chance = 8700}, -- energy drink
	{id = 7642, chance = 8700}, -- great spirit potion
	{id = 3033, chance = 5000, maxCount = 2}, -- small amethyst
	{id = 16124, chance = 4800}, -- blue crystal splinter
	{id = 3029, chance = 4400, maxCount = 2}, -- small sapphire
	{id = 16120, chance = 4200}, -- violet crystal shard
	{id = 3030, chance = 3400, maxCount = 2}, -- small ruby
	{id = 16125, chance = 3300} -- cyan crystal fragment
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -300, range = 4, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true},
	{name ="dread intruder wave", interval = 2000, chance = 25, minDamage = -350, maxDamage = -450, target = false}
}

monster.defenses = {
	defense = 50,
	armor = 50,
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 80, maxDamage = 120, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -5},
	{type = COMBAT_ENERGYDAMAGE, percent = 80},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 5},
	{type = COMBAT_HOLYDAMAGE , percent = -5},
	{type = COMBAT_DEATHDAMAGE , percent = 70}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
