local mType = Game.createMonsterType("The Halloween Hare")
local monster = {}

monster.description = "The Halloween Hare"
monster.experience = 0
monster.outfit = {
	lookType = 74,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 1
monster.maxHealth = 1
monster.race = "blood"
monster.corpse = 0
monster.speed = 150
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 95
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
	staticAttackChance = 10,
	targetDistance = 2,
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
}

monster.loot = {
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = 0},
	{name ="outfit", interval = 2000, chance = 6, radius = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 6000, outfitMonster = "bat"},
	{name ="outfit", interval = 2000, chance = 5, radius = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 6000, outfitMonster = "Thornback tortoise"},
	{name ="outfit", interval = 2000, chance = 6, radius = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 6000, outfitMonster = "orc"},
	{name ="outfit", interval = 2000, chance = 5, radius = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 6000, outfitMonster = "snake"},
	{name ="outfit", interval = 2000, chance = 6, radius = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 6000, outfitMonster = "warlock"},
	{name ="outfit", interval = 2000, chance = 5, radius = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 6000, outfitMonster = "witch"},
	{name ="outfit", interval = 2000, chance = 5, radius = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 6000, outfitMonster = "necromancer"},
	{name ="outfit", interval = 2000, chance = 5, radius = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 6000, outfitMonster = "dwarf geomancer"},
	{name ="outfit", interval = 2000, chance = 5, radius = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 6000, outfitMonster = "monk"},
	{name ="outfit", interval = 2000, chance = 5, radius = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 6000, outfitMonster = "crab"},
	{name ="outfit", interval = 2000, chance = 5, radius = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 6000, outfitMonster = "ghost"},
	{name ="outfit", interval = 2000, chance = 5, radius = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 6000, outfitMonster = "minotaur mage"},
	{name ="outfit", interval = 2000, chance = 5, radius = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 6000, outfitMonster = "green frog"},
	{name ="outfit", interval = 2000, chance = 5, radius = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 6000, outfitMonster = "parrot"},
	{name ="outfit", interval = 2000, chance = 15, radius = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 6000, outfitItem = 2096}
}

monster.defenses = {
	defense = 999,
	armor = 999,
	{name ="combat", interval = 1000, chance = 50, type = COMBAT_HEALING, minDamage = 1500, maxDamage = 2000, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 100},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
