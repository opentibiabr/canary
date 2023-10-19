local mType = Game.createMonsterType("Bakragore")
local monster = {}

monster.description = "Bakragore"
monster.experience = 15000000
monster.outfit = {
	lookType = 1671,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.bosstiary = {
	bossRaceId = 2367,
	bossRace = RARITY_NEMESIS
}

monster.health = 660000
monster.maxHealth = 660000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 44012
monster.speed = 222
monster.summonCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0
}

monster.flags = {
	attackable = true,
	hostile = true,
	summonable = false,
	convinceable = false,
	illusionable = false,
	boss = true,
	ignoreSpawnBlock = false,
	pushable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	healthHidden = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Blood ... will ... be ... mine!!", yell = false},
	{text = "Revenge! Rise! Revive!", yell = false},
	{text = "World... to... devour!", yell = false}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
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

monster.attacks = {
}

monster.defenses = {
	defense = 5,
	armor = 10
}

monster.loot = {
	{id = 3043, chance = 100000, maxCount = 165},
	{id = 32622, chance = 100000},
	{id = 32623, chance = 100000, maxCount = 6},
	{id = 7440, chance = 100000, maxCount = 23},
	{id = 23373, chance = 100000, maxCount = 198},
	{id = 3037, chance = 100000, maxCount = 9},
	{id = "bag you covet", chance = 20000},
	{id = 43946, chance = 20000},
	{id = 43947, chance = 20000},
	{id = 43948, chance = 20000},
	{id = 43949, chance = 20000},
	{id = 43950, chance = 20000},
	{id = 43961, chance = 20000},
	{id = 43962, chance = 20000}
}

mType:register(monster)
