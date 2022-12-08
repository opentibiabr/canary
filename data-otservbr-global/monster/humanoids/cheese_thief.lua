local mType = Game.createMonsterType("Cheese Thief")
local monster = {}

monster.description = "a Cheese Thief"
monster.experience = 800
monster.outfit = {
	lookType = 534,
	lookHead = 101,
	lookBody = 0,
	lookLegs = 101,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 918
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 35,
	Stars = 3,
	Occurrence = 0,
	Locations = "Rascacoon"
	}

monster.health = 1100
monster.maxHealth = 1100
monster.race = "blood"
monster.corpse = 17454
monster.speed = 52
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 50,
	healthHidden = false,
	isBlockable = true,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.loot = {

}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -0, maxDamage = -100}
	}

monster.defenses = {
	defense = 50,
	armor = 50,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 30, maxDamage = 60, effect = CONST_ME_MAGIC_BLUE, target = false}
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
