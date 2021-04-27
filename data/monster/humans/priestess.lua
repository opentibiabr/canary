local mType = Game.createMonsterType("Priestess")
local monster = {}

monster.description = "a priestess"
monster.experience = 420
monster.outfit = {
	lookType = 58,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 58
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Hero Cave, Drefia ruins, Lich Hell, Tombs, Magician Quarter in Yalahar, Vengoth Castle."
	}

monster.health = 390
monster.maxHealth = 390
monster.race = "blood"
monster.corpse = 20491
monster.speed = 170
monster.manaCost = 0
monster.maxSummons = 2

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
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
	{name = "ghoul", chance = 10, interval = 2000, max = 2}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Your energy is mine.", yell = false},
	{text = "Now your life is come to the end, hahahaha!", yell = false},
	{text = "Throw the soul on the altar!", yell = false}
}

monster.loot = {
	{id = 1962, chance = 890},
	{id = 2070, chance = 1410},
	{name = "piggy bank", chance = 90},
	{name = "crystal necklace", chance = 640},
	{name = "talon", chance = 750},
	{name = "hailstorm rod", chance = 1100},
	{id = 2192, chance = 1250},
	{id = 2070, chance = 1400},
	{name = "clerical mace", chance = 1500},
	{name = "black shield", chance = 210},
	{name = "red apple", chance = 7500, maxCount = 2},
	{name = "goat grass", chance = 11720},
	{name = "wood mushroom", chance = 3240},
	{name = "sling herb", chance = 13200},
	{name = "powder herb", chance = 5900},
	{name = "mana potion", chance = 850},
	{name = "cultish robe", chance = 1800},
	{name = "black hood", chance = 5230},
	{name = "dark rosary", chance = 9840}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -75},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -55, maxDamage = -120, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -2, maxDamage = -170, range = 7, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 15, range = 7, shootEffect = CONST_ANI_POISON, target = false}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 80, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -5},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 70},
	{type = COMBAT_FIREDAMAGE, percent = 40},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 5}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
