local mType = Game.createMonsterType("Choking Fear")
local monster = {}

monster.description = "a choking fear"
monster.experience = 4700
monster.outfit = {
	lookType = 586,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1015
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "All over the surface of Upper Roshamuul and Nightmare Isles."
	}

monster.health = 5800
monster.maxHealth = 5800
monster.race = "undead"
monster.corpse = 20159
monster.speed = 190
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 5
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
	{text = "Ah, sweet air... don't you miss it?", yell = false},
	{text = "Murr tat muuza!", yell = false},
	{text = "kchh", yell = false},
	{text = "hsssss", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 100000, maxCount = 100},
	{name = "platinum coin", chance = 100000, maxCount = 8},
	{id = 3051, chance = 3000}, -- energy ring
	{id = 3052, chance = 4200}, -- life ring
	{id = 3098, chance = 3000}, -- ring of healing
	{name = "guardian shield", chance = 1540},
	{name = "beastslayer axe", chance = 3290},
	{name = "brown piece of cloth", chance = 6000},
	{name = "yellow piece of cloth", chance = 3500},
	{name = "great mana potion", chance = 20000, maxCount = 3},
	{name = "terra boots", chance = 720},
	{name = "great spirit potion", chance = 20000, maxCount = 3},
	{name = "ultimate health potion", chance = 19000, maxCount = 3},
	{name = "spellbook of mind control", chance = 720},
	{name = "underworld rod", chance = 720},
	{name = "springsprout rod", chance = 510},
	{name = "green crystal shard", chance = 1540},
	{name = "brown crystal splinter", chance = 52500, maxCount = 2},
	{name = "blue crystal splinter", chance = 10000, maxCount = 3},
	{name = "cluster of solace", chance = 620},
	{name = "dead weight", chance = 14180},
	{name = "hemp rope", chance = 14180}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -499, condition = {type = CONDITION_POISON, totalDamage = 600, interval = 4000}},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -700, maxDamage = -900, length = 5, spread = 3, effect = CONST_ME_HITBYPOISON, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -300, radius = 1, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_SLEEP, target = true},
	{name ="speed", interval = 2000, chance = 20, speedChange = -800, radius = 1, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_SLEEP, target = true, duration = 15000},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -130, maxDamage = -300, radius = 4, effect = CONST_ME_SOUND_RED, target = false},
	{name ="choking fear drown", interval = 2000, chance = 20, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -250, maxDamage = -500, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true}
}

monster.defenses = {
	defense = 35,
	armor = 35,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 80, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 15},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 55}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
