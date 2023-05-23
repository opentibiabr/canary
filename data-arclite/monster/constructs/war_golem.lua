local mType = Game.createMonsterType("War Golem")
local monster = {}

monster.description = "a war golem"
monster.experience = 2310
monster.outfit = {
	lookType = 326,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 533
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Factory Quarter."
	}

monster.health = 4300
monster.maxHealth = 4300
monster.race = "venom"
monster.corpse = 9092
monster.speed = 160
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
	{text = "Azerus barada nikto!", yell = false},
	{text = "Klonk klonk klonk", yell = false},
	{text = "Engaging Enemy!", yell = false},
	{text = "Threat level processed.", yell = false},
	{text = "Charging weapon systems!", yell = false},
	{text = "Auto repair in progress.", yell = false},
	{text = "The battle is joined!", yell = false},
	{text = "Termination initialized!", yell = false},
	{text = "Rrrtttarrrttarrrtta", yell = false},
	{text = "Eliminated", yell = false}
}

monster.loot = {
	{id = 3031, chance = 37500, maxCount = 90}, -- gold coin
	{id = 3031, chance = 375000, maxCount = 80}, -- gold coin
	{id = 953, chance = 5260, maxCount = 5}, -- nail
	{id = 3265, chance = 5500}, -- two handed sword
	{id = 3410, chance = 9000}, -- plate shield
	{id = 3282, chance = 7000}, -- morning star
	{id = 3413, chance = 6500}, -- battle shield
	{id = 7643, chance = 10080}, -- ultimate health potion
	{id = 238, chance = 8860}, -- great mana potion
	{id = 5880, chance = 1920}, -- iron ore
	{id = 7439, chance = 900}, -- berserk potion
	{id = 3326, chance = 6400}, -- epee
	{id = 8895, chance = 260}, -- rusted armor
	{id = 3093, chance = 810}, -- club ring
	{id = 3097, chance = 1210}, -- dwarven ring
	{id = 9067, chance = 130}, -- crystal of power
	{id = 9065, chance = 1080}, -- crystal pedestal
	{id = 820, chance = 90}, -- lightning boots
	{id = 3554, chance = 620}, -- steel boots
	{id = 7403, chance = 50}, -- berserker
	{id = 7422, chance = 120}, -- jade hammer
	{id = 7428, chance = 770}, -- bonebreaker
	{id = 3061, chance = 1000}, -- life crystal
	{id = 12305, chance = 100} -- tin key
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -165, maxDamage = -220, range = 7, shootEffect = CONST_ANI_ENERGY, target = false},
	{name ="outfit", interval = 2000, chance = 1, range = 7, target = false, duration = 3000, outfitMonster = "skeleton"},
	{name ="war golem electrify", interval = 2000, chance = 15, range = 1, target = false},
	{name ="war golem skill reducer", interval = 2000, chance = 10, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{name ="speed", interval = 2000, chance = 15, speedChange = 300, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 5},
	{type = COMBAT_EARTHDAMAGE, percent = 50},
	{type = COMBAT_FIREDAMAGE, percent = 15},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 30},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
