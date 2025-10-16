local mType = Game.createMonsterType("Crazed Summer Rearguard")
local monster = {}

monster.description = "a crazed summer rearguard"
monster.experience = 4700
monster.outfit = {
	lookType = 1136,
	lookHead = 114,
	lookBody = 94,
	lookLegs = 3,
	lookFeet = 121,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1733
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Court of Summer, Dream Labyrinth.",
}

monster.health = 5300
monster.maxHealth = 5300
monster.race = "blood"
monster.corpse = 30081
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Is this real life?", yell = false },
	{ text = "Weeeuuu weeeuuu!!!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 11 }, -- platinum coin
	{ id = 5921, chance = 23000 }, -- heaven blossom
	{ id = 30005, chance = 23000 }, -- dream essence egg
	{ id = 9635, chance = 23000 }, -- elvish talisman
	{ id = 676, chance = 23000 }, -- small enchanted ruby
	{ id = 16120, chance = 5000 }, -- violet crystal shard
	{ id = 16126, chance = 5000 }, -- red crystal fragment
	{ id = 25735, chance = 5000, maxCount = 8 }, -- leaf star
	{ id = 23529, chance = 5000 }, -- ring of blue plasma
	{ id = 29995, chance = 5000 }, -- sun fruit
	{ id = 3575, chance = 5000 }, -- wood cape
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ id = 23526, chance = 1000 }, -- collar of blue plasma
	{ id = 675, chance = 1000, maxCount = 2 }, -- small enchanted sapphire
	{ id = 3028, chance = 1000 }, -- small diamond
	{ id = 16163, chance = 260 }, -- crystal crossbow
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2500, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -300, range = 6, effect = CONST_ME_FIREATTACK, target = true },
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -300, range = 6, radius = 2, effect = CONST_ME_FIREAREA, target = true },
}

monster.defenses = {
	defense = 20,
	armor = 76,
	mitigation = 2.11,
}

monster.reflects = {
	{ type = COMBAT_FIREDAMAGE, percent = 70 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
