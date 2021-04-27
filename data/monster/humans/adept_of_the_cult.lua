local mType = Game.createMonsterType("Adept of the Cult")
local monster = {}

monster.description = "an adept of the cult"
monster.experience = 400
monster.outfit = {
	lookType = 194,
	lookHead = 114,
	lookBody = 94,
	lookLegs = 94,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 254
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Goroma, Liberty Bay's deeper cult dungeon, Formorgar Mines, Magician Quarter, Forbidden Temple."
	}

monster.health = 430
monster.maxHealth = 430
monster.race = "blood"
monster.corpse = 20311
monster.speed = 190
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.summons = {
	{name = "Ghoul", chance = 10, interval = 2000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Feel the power of the cult!", yell = false},
	{text = "Praise the voodoo!", yell = false},
	{text = "Power to the cult!", yell = false}
}

monster.loot = {
	{id = 1962, chance = 940},
	{name = "small ruby", chance = 320},
	{name = "gold coin", chance = 65520, maxCount = 60},
	{id = 2169, chance = 420},
	{name = "silver amulet", chance = 1020},
	{name = "hailstorm rod", chance = 220},
	{name = "clerical mace", chance = 1260},
	{name = "red robe", chance = 80},
	{name = "pirate voodoo doll", chance = 1730},
	{id = 6089, chance = 700},
	{name = "lunar staff", chance = 120},
	{name = "amber staff", chance = 680},
	{name = "cultish robe", chance = 10080},
	{name = "cultish symbol", chance = 90},
	{name = "rope belt", chance = 10000},
	{name = "broken key ring", chance = 120}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -90, condition = {type = CONDITION_POISON, totalDamage = 2, interval = 4000}},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -70, maxDamage = -150, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true},
	{name ="drunk", interval = 2000, chance = 10, range = 7, radius = 1, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYDAMAGE, target = true, duration = 4000}
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{name ="combat", interval = 3000, chance = 20, type = COMBAT_HEALING, minDamage = 45, maxDamage = 60, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="invisible", interval = 2000, chance = 10, effect = CONST_ME_YELLOW_RINGS}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
