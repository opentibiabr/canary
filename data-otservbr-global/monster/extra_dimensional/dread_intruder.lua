local mType = Game.createMonsterType("Dread Intruder")
local monster = {}

monster.description = "a dread intruder"
monster.experience = 2400
monster.outfit = {
	lookType = 882,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1260
monster.Bestiary = {
	class = "Extra Dimensional",
	race = BESTY_RACE_EXTRA_DIMENSIONAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Otherworld",
}

monster.health = 4500
monster.maxHealth = 4500
monster.race = "venom"
monster.corpse = 23478
monster.speed = 165
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25,
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
	{ text = "Whirr!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 8 }, -- platinum coin
	{ id = 238, chance = 23000 }, -- great mana potion
	{ id = 7642, chance = 23000 }, -- great spirit potion
	{ id = 7643, chance = 23000 }, -- ultimate health potion
	{ id = 23545, chance = 23000 }, -- energy drink
	{ id = 23535, chance = 23000 }, -- energy bar
	{ id = 23516, chance = 23000 }, -- instable proto matter
	{ id = 23523, chance = 23000 }, -- energy ball
	{ id = 23510, chance = 23000 }, -- odd organ
	{ id = 23519, chance = 23000 }, -- frozen lightning
	{ id = 16124, chance = 23000 }, -- blue crystal splinter
	{ id = 16125, chance = 23000 }, -- cyan crystal fragment
	{ id = 3033, chance = 5000, maxCount = 2 }, -- small amethyst
	{ id = 3030, chance = 5000, maxCount = 2 }, -- small ruby
	{ id = 3029, chance = 5000, maxCount = 2 }, -- small sapphire
	{ id = 16120, chance = 5000 }, -- violet crystal shard
	{ id = 3036, chance = 1000 }, -- violet gem
	{ id = 23528, chance = 260 }, -- collar of red plasma
	{ id = 23526, chance = 260 }, -- collar of blue plasma
	{ id = 23527, chance = 260 }, -- collar of green plasma
	{ id = 23533, chance = 260 }, -- ring of red plasma
	{ id = 23529, chance = 260 }, -- ring of blue plasma
	{ id = 23531, chance = 260 }, -- ring of green plasma
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	-- energy damage
	{ name = "condition", type = CONDITION_ENERGY, interval = 2000, chance = 20, minDamage = -400, maxDamage = -600, radius = 5, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -250, maxDamage = -400, range = 4, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "dread intruder wave", interval = 2000, chance = 25, minDamage = -350, maxDamage = -550, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 50,
	mitigation = 1.54,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 80, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 90 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 80 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
