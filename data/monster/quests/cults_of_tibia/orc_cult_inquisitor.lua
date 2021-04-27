local mType = Game.createMonsterType("Orc Cult Inquisitor")
local monster = {}

monster.description = "an orc cult inquisitor"
monster.experience = 1150
monster.outfit = {
	lookType = 8,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1505
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Edron Orc Cave."
	}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "blood"
monster.corpse = 5980
monster.speed = 125
monster.manaCost = 590
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
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 95,
	targetDistance = 1,
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "You unorcish scum will die!", yell = true}
}

monster.loot = {
	{name = "strong health potion", chance = 18390},
	{name = "gold coin", chance = 100000, maxCount = 221},
	{name = "black pearl", chance = 510, maxCount = 2},
	{name = "berserk potion", chance = 2940},
	{name = "small ruby", chance = 4020, maxCount = 5},
	{name = "battle axe", chance = 6340},
	{name = "bug meat", chance = 17160},
	{name = "red mushroom", chance = 7730, maxCount = 3},
	{name = "halberd", chance = 9890},
	{name = "orcish axe", chance = 850},
	{name = "cultish robe", chance = 9890},
	{name = "ham", chance = 8960},
	{name = "orc tooth", chance = 5410},
	{name = "orcish gear", chance = 15460},
	{name = "orc leather", chance = 7730}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500}
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{name ="speed", interval = 2000, chance = 30, speedChange = 290, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
