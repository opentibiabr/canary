local mType = Game.createMonsterType("Vile Grandmaster")
local monster = {}

monster.description = "a vile grandmaster"
monster.experience = 1500
monster.outfit = {
	lookType = 268,
	lookHead = 59,
	lookBody = 19,
	lookLegs = 95,
	lookFeet = 94,
	lookAddons = 1,
	lookMount = 0
}

monster.raceId = 1147
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Old Fortress (north of Edron), Old Masonry, Forbidden Temple (Carlin)."
	}

monster.health = 1700
monster.maxHealth = 1700
monster.race = "blood"
monster.corpse = 22023
monster.speed = 140
monster.manaCost = 390

monster.changeTarget = {
	interval = 4000,
	chance = 20
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
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
	{text = "I will end this now!", yell = false},
	{text = "I've seen orcs tougher than you!", yell = false},
	{text = "Your gods won't help you!", yell = false},
	{text = "Is that the best, you can throw at me?", yell = false},
	{text = "You'll make a fine trophy!", yell = false}
}

monster.loot = {
	{id = 7364, chance = 1210, maxCount = 4}, -- sniper arrow
	{id = 3031, chance = 75410, maxCount = 30}, -- gold coin
	{id = 3035, chance = 75410, maxCount = 2}, -- platinum coin
	{id = 3592, chance = 1210}, -- grapes
	{id = 3577, chance = 1210, maxCount = 2}, -- meat
	{id = 239, chance = 1210}, -- great health potion
	{id = 3269, chance = 1610}, -- halberd
	{id = 3658, chance = 510}, -- red rose
	{id = 3003, chance = 1510}, -- rope
	{id = 11510, chance = 910}, -- scroll of heroic deeds
	{id = 11450, chance = 910}, -- small notebook
	{id = 3030, chance = 810, maxCount = 2}, -- small ruby
	{id = 3029, chance = 810, maxCount = 2}, -- small sapphire
	{id = 3004, chance = 510}, -- wedding ring
	{id = 5911, chance = 210}, -- red piece of cloth
	{id = 3279, chance = 210}, -- war hammer
	{id = 3381, chance = 310}, -- crown armor
	{id = 3280, chance = 210}, -- fire sword
	{id = 3385, chance = 310}, -- crown helmet
	{id = 3419, chance = 210}, -- crown shield
	{id = 3382, chance = 110}, -- crown legs
	{id = 3055, chance = 210} -- platinum amulet
}

monster.attacks = {
	{name ="vile grandmaster", interval = 2000, chance = 15, target = false},
	{name ="melee", interval = 2000, chance = 100, minDamage = 10, maxDamage = -260},
	-- bleed
	{name ="condition", type = CONDITION_BLEEDING, interval = 2000, chance = 20, minDamage = -150, maxDamage = -225, radius = 4, shootEffect = CONST_ANI_THROWINGKNIFE, target = true}
}

monster.defenses = {
	defense = 50,
	armor = 35,
	{name ="combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 220, maxDamage = 280, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = 25},
	{type = COMBAT_EARTHDAMAGE, percent = 25},
	{type = COMBAT_FIREDAMAGE, percent = 25},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
