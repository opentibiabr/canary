local mType = Game.createMonsterType("Crazed Summer Vanguard")
local monster = {}

monster.description = "a Crazed Summer Vanguard"
monster.experience = 5000
monster.outfit = {
	lookType = 1136,
	lookHead = 20,
	lookBody = 94,
	lookLegs = 20,
	lookFeet = 81,
	lookAddons = 1,
	lookMount = 0
}

monster.raceId = 1732
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Court of Winter, Dream Labyrinth."
	}

monster.health = 5500
monster.maxHealth = 5500
monster.race = "blood"
monster.corpse = 34715
monster.speed = 390
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
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
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
	{text = "I see colours, all colours! Or are these just illusions?", yell = false},
	{text = "La di da di doo!!", yell = false}
}

monster.loot = {
	{name = "platinum coin", chance = 1000000, maxCount = 13},
	{name = "elven astral observer", chance = 1000000, maxCount = 2},
	{name = "dream essence egg", chance = 15000},
	{name = "belted cape", chance = 11550},
	{name = "two handed sword", chance = 13550},
	{name = "seeds", chance = 14750},
	{id = 2419, chance = 17550},
	{name = "knife", chance = 15650},
	{name = "dragon necklace", chance = 14550},
	{name = "magma amulet", chance = 1655},
	{name = "wand of dragonbreath", chance = 15150},
	{name = "wand of draconia", chance = 1263},
	{name = "magma boots", chance = 11100},
	{name = "sun fruit", chance = 1800},
	{name = "bullseye potion", chance = 800}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -160, maxDamage = -530},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -270, maxDamage = -710, length = 3, spread = 0, effect = CONST_ME_FIREAREA, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -250, maxDamage = -300, range = 7, shootEffect = CONST_ANI_FIRE, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -380, radius = 5, effect = CONST_ME_EXPLOSIONHIT, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -350, radius = 5, effect = CONST_ME_EXPLOSIONAREA, target = true}
}

monster.defenses = {
	defense = 20,
	armor = 70
}

monster.reflects = {
	{type = COMBAT_FIREDAMAGE, percent = 70}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 30},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
