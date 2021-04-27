local mType = Game.createMonsterType("Diamond Servant")
local monster = {}

monster.description = "a diamond servant"
monster.experience = 700
monster.outfit = {
	lookType = 397,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 702
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 5,
	FirstUnlock = 2,
	SecondUnlock = 3,
	CharmsPoints = 50,
	Stars = 3,
	Occurrence = 3,
	Locations = "Edron."
	}

monster.health = 1000
monster.maxHealth = 1000
monster.race = "venom"
monster.corpse = 13485
monster.speed = 172
monster.manaCost = 0
monster.maxSummons = 0

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
	runHealth = 100,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Error. LOAD 'PROGRAM',8,1", yell = false},
	{text = "Remain. Obedient.", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 44000, maxCount = 100},
	{name = "gold coin", chance = 50000, maxCount = 79},
	{name = "yellow gem", chance = 550},
	{name = "might ring", chance = 940},
	{name = "life crystal", chance = 9150},
	{name = "wand of cosmic energy", chance = 530},
	{name = "soul orb", chance = 45000},
	{name = "bonebreaker", chance = 10},
	{name = "mastermind potion", chance = 400},
	{name = "strong health potion", chance = 5790},
	{name = "strong mana potion", chance = 5980},
	{name = "lightning pendant", chance = 710},
	{name = "crystalline armor", chance = 20},
	{name = "gear wheel", chance = 5000},
	{id = 9976, chance = 5320},
	{name = "shockwave amulet", chance = 110},
	{name = "gear crystal", chance = 5000},
	{name = "slime mould", chance = 480}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -80, maxDamage = -120, radius = 3, effect = CONST_ME_YELLOWENERGY, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -125, maxDamage = -170, length = 5, spread = 2, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = false},
	{name ="drunk", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_STUN, target = true, duration = 3000}
}

monster.defenses = {
	defense = 25,
	armor = 25
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 80},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -5},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
