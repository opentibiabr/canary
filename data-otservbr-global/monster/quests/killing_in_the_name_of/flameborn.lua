local mType = Game.createMonsterType("Flameborn")
local monster = {}

monster.description = "Flameborn"
monster.experience = 2550
monster.outfit = {
	lookType = 322,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 3500
monster.maxHealth = 3500
monster.race = "fire"
monster.corpse = 9009
monster.speed = 130
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15
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
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{id = 3035, chance = 100000}, -- platinum coin
	{id = 3035, chance = 100000, maxCount = 13}, -- platinum coin
	{id = 239, chance = 75810}, -- great health potion
	{id = 10304, chance = 100000}, -- hellspawn tail
	{id = 7368, chance = 19350, maxCount = 5}, -- assassin star
	{id = 7643, chance = 77420}, -- ultimate health potion
	{id = 6499, chance = 35480}, -- demonic essence
	{id = 3724, chance = 67740, maxCount = 2}, -- red mushroom
	{id = 9057, chance = 43550, maxCount = 4}, -- small topaz
	{id = 3371, chance = 67740}, -- knight legs
	{id = 3369, chance = 20970}, -- warrior helmet
	{id = 7452, chance = 6450}, -- spiked squelcher
	{id = 7439, chance = 37100}, -- berserk potion
	{id = 9056, chance = 20970}, -- black skull
	{id = 9034, chance = 1610}, -- dracoyle statue
	{id = 7421, chance = 3230}, -- onyx flail
	{id = 12311, chance = 4840}, -- carrot on a stick
	{id = 3419, chance = 29030} -- crown shield
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350},
	{name ="fireball rune", interval = 2000, chance = 20, minDamage = -150, maxDamage = -175, target = false},
	{name ="hellspawn soulfire", interval = 2000, chance = 10, range = 5, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 120, maxDamage = 230, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 270, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 80},
	{type = COMBAT_FIREDAMAGE, percent = 40},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
