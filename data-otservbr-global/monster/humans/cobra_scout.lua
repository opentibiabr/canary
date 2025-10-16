local mType = Game.createMonsterType("Cobra Scout")
local monster = {}

monster.description = "a cobra scout"
monster.experience = 7310
monster.outfit = {
	lookType = 1217,
	lookHead = 1,
	lookBody = 1,
	lookLegs = 102,
	lookFeet = 78,
	lookAddons = 2,
	lookMount = 0,
}

monster.raceId = 1776
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Cobra Bastion.",
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 31635
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 4,
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
	{ text = "Think I can't see you? Think again...", yell = false },
	{ text = "You don't stand a chance!", yell = false },
	{ text = "What are you looking for?", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 9 }, -- platinum coin
	{ id = 22194, chance = 23000, maxCount = 5 }, -- opal
	{ id = 774, chance = 23000, maxCount = 28 }, -- earth arrow
	{ id = 31678, chance = 23000 }, -- cobra crest
	{ id = 17818, chance = 23000 }, -- cheesy figurine
	{ id = 3081, chance = 23000 }, -- stone skin amulet
	{ id = 9058, chance = 23000 }, -- gold ingot
	{ id = 36706, chance = 5000 }, -- red gem
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ id = 16121, chance = 5000 }, -- green crystal shard
	{ id = 3032, chance = 5000 }, -- small emerald
	{ id = 3038, chance = 5000 }, -- green gem
	{ id = 3036, chance = 5000 }, -- violet gem
	{ id = 9302, chance = 1000 }, -- sacred tree amulet
	{ id = 23533, chance = 1000 }, -- ring of red plasma
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_EARTHDAMAGE, minDamage = -350, maxDamage = -450, shootEffect = CONST_ANI_SNIPERARROW, target = true },
	{ name = "combat", interval = 2000, chance = 16, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -420, radius = 4, shootEffect = CONST_ANI_POISONARROW, effect = CONST_ME_GREEN_RINGS, target = true },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = -300, maxDamage = -380, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 81,
	armor = 81,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onSpawn = function(monster)
	monster:handleCobraOnSpawn()
end

mType:register(monster)
