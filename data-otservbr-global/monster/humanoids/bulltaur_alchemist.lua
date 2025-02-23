local mType = Game.createMonsterType("Bulltaur Alchemist")
local monster = {}

monster.description = "a Bulltaur Alchemist"
monster.experience = 4500
monster.outfit = {
	lookType = 1718,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 5690
monster.maxHealth = 5690
monster.race = "blood"
monster.corpse = 44713
monster.speed = 160
monster.manaCost = 0

monster.raceId = 2448
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Bulltaurs Lair.",
}

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Your misfortune is setteled!", yell = false },
	{ text = "Soon I will harvest you for ingredients!", yell = false },
	{ text = "I have just the solution for this problem!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 51528, maxCount = 30 },
	{ id = 44736, chance = 15234 },
	{ id = 44739, chance = 9169 },
	{ id = 44740, chance = 6256 },
	{ id = 239, chance = 5540 },
	{ id = 9058, chance = 3534 },
	{ id = 7643, chance = 2722 },
	{ id = 238, chance = 2006 },
	{ id = 3036, chance = 1862 },
	{ id = 23373, chance = 1385 },
	{ id = 3041, chance = 1003 },
	{ id = 3063, chance = 1003 },
	{ id = 21168, chance = 1003 },
	{ id = 32769, chance = 669 },
	{ id = 10438, chance = 621 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -120, maxDamage = -270 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -420, radius = 3, effect = CONST_ME_REDSMOKE, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -280, maxDamage = -400, range = 4, radius = 4, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_PURPLESMOKE, target = true },
	{ name = "bulltaur avalanche", interval = 2000, chance = 20, minDamage = -350, maxDamage = -450 },
}

monster.defenses = {
	defense = 67,
	armor = 67,
	mitigation = 2.11,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "drunk", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
