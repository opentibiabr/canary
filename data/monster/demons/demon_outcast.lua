local mType = Game.createMonsterType("Demon Outcast")
local monster = {}

monster.description = "a demon outcast"
monster.experience = 6200
monster.outfit = {
	lookType = 590,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1019
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Roshamuul Prison."
	}

monster.health = 6900
monster.maxHealth = 6900
monster.race = "blood"
monster.corpse = 22549
monster.speed = 296
monster.manaCost = 0
monster.maxSummons = 2

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
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.summons = {
	{name = "energy elemental", chance = 10, interval = 2000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Back in the evil business!", yell = false},
	{text = "This prison break will have casualties!", yell = false},
	{text = "At last someone to hurt", yell = false},
	{text = "No one will imprison me again!", yell = false}
}

monster.loot = {
	{name = "small diamond", chance = 10000, maxCount = 5},
	{name = "small sapphire", chance = 10000, maxCount = 5},
	{name = "small ruby", chance = 12000, maxCount = 5},
	{name = "gold coin", chance = 100000, maxCount = 100},
	{name = "small emerald", chance = 10000, maxCount = 5},
	{name = "platinum coin", chance = 100000, maxCount = 6},
	{name = "might ring", chance = 910},
	{name = "stealth ring", chance = 1300},
	{name = "platinum amulet", chance = 1000},
	{name = "ring of healing", chance = 3000},
	{name = "giant sword", chance = 2000},
	{name = "ice rapier", chance = 660},
	{name = "devil helmet", chance = 910},
	{name = "crusader helmet", chance = 740},
	{name = "crown shield", chance = 740},
	{name = "demon shield", chance = 170},
	{name = "fire mushroom", chance = 20600, maxCount = 6},
	{id = 5906, chance = 1000},
	{name = "assassin star", chance = 8340, maxCount = 10},
	{name = "demonrage sword", chance = 350},
	{name = "great mana potion", chance = 18000, maxCount = 2},
	{name = "ultimate health potion", chance = 20500, maxCount = 3},
	{name = "small topaz", chance = 9300, maxCount = 5},
	{name = "cluster of solace", chance = 550}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -450, length = 6, spread = 3, effect = CONST_ME_PURPLEENERGY, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -350, maxDamage = -550, length = 8, spread = 3, effect = CONST_ME_YELLOWENERGY, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -250, radius = 3, effect = CONST_ME_ENERGYHIT, target = true},
	{name ="demon outcast skill reducer", interval = 2000, chance = 10, range = 5, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -80, maxDamage = -150, radius = 4, effect = CONST_ME_MAGIC_GREEN, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 250, maxDamage = 425, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 5},
	{type = COMBAT_HOLYDAMAGE , percent = -5},
	{type = COMBAT_DEATHDAMAGE , percent = 5}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
