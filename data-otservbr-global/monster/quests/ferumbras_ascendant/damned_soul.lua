local mType = Game.createMonsterType("Damned Soul")
local monster = {}

monster.description = "a damned soul"
monster.experience = 300
monster.outfit = {
	lookType = 232,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 800
monster.maxHealth = 800
monster.race = "undead"
monster.corpse = 22698
monster.speed = 190
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 4
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
	runHealth = 800,
	healthHidden = false,
	isBlockable = false,
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
	{text = "Forgive Meeeee!", yell = false},
	{text = "Mouuuurn meeee!", yell = false},
	{text = "Help meee!", yell = false}
}

monster.loot = {
	{id = 3147, chance = 34550, maxCount = 3}, -- blank rune
	{id = 6499, chance = 6990}, -- demonic essence
	{id = 10316, chance = 33070}, -- unholy bone
	{id = 3031, chance = 99940, maxCount = 198}, -- gold coin
	{id = 3035, chance = 99940, maxCount = 3}, -- platinum coin
	{id = 238, chance = 14200, maxCount = 2}, -- great mana potion
	{id = 239, chance = 8810, maxCount = 2}, -- great health potion
	{id = 5944, chance = 15000}, -- soul orb
	{id = 3027, chance = 11930, maxCount = 3}, -- black pearl
	{id = 3026, chance = 10800, maxCount = 3}, -- white pearl
	{id = 8895, chance = 6200}, -- rusted armor
	{id = 8896, chance = 3350}, -- slightly rusted armor
	{id = 5806, chance = 4940}, -- silver goblet
	{id = 3016, chance = 1590}, -- ruby necklace
	{id = 3081, chance = 2560}, -- stone skin amulet
	{id = 3039, chance = 2050}, -- red gem
	{id = 3428, chance = 740}, -- tower shield
	{id = 5741, chance = 170}, -- skull helmet
	{id = 3324, chance = 850}, -- skull staff
	{id = 7413, chance = 1020}, -- titan axe
	{id = 7407, chance = 740}, -- haunted blade
	{id = 6299, chance = 2160}, -- death ring
	{id = 6525, chance = 1250} -- skeleton decoration
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 76, attack = 100},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_DEATHDAMAGE, minDamage = -90, maxDamage = -240, length = 3, spread = 0, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="lost soul paralyze", interval = 2000, chance = 18, target = false}
}

monster.defenses = {
	defense = 35,
	armor = 25
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
