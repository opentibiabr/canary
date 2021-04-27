local mType = Game.createMonsterType("Firestarter")
local monster = {}

monster.description = "a firestarter"
monster.experience = 80
monster.outfit = {
	lookType = 159,
	lookHead = 94,
	lookBody = 77,
	lookLegs = 78,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 737
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 2,
	Locations = "Shadowthorn, during the Thornfire World Change."
	}

monster.health = 180
monster.maxHealth = 180
monster.race = "blood"
monster.corpse = 20599
monster.speed = 200
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = true,
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "FIRE!", yell = true},
	{text = "BURN!", yell = true},
	{text = "Hey, what's that burnt stench... isn't that... YOU?", yell = true},
	{text = "Set everything on fire!!", yell = true},
	{text = "DEATH to the FALSE GOD!!", yell = true},
	{text = "You shall burn in the thornfires!!", yell = false},
	{text = "DOWN with the followers of the bog!!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 79000, maxCount = 35},
	{name = "longsword", chance = 6000},
	{name = "bow", chance = 4000},
	{name = "grapes", chance = 20000},
	{id = 5921, chance = 930},
	{name = "elvish bow", chance = 100},
	{name = "flaming arrow", chance = 30000, maxCount = 12},
	{name = "elvish talisman", chance = 5000},
	{id = 13757, chance = 15280},
	{name = "flintstone", chance = 340}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -15},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -21, radius = 1, shootEffect = CONST_ANI_BURSTARROW, effect = CONST_ME_EXPLOSIONHIT, target = true},
	{name ="firefield", interval = 2000, chance = 10, radius = 1, shootEffect = CONST_ANI_FIRE, target = true}
}

monster.defenses = {
	defense = 15,
	armor = 15
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = -20}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
