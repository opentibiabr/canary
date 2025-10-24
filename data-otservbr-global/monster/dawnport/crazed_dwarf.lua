local mType = Game.createMonsterType("Crazed Dwarf")
local monster = {}

monster.description = "a crazed dwarf"
monster.experience = 50
monster.outfit = {
	lookType = 69,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 105
monster.maxHealth = 105
monster.race = "blood"
monster.corpse = 6007
monster.speed = 78
monster.manaCost = 320

monster.changeTarget = {
	interval = 2000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
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
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 4 }, -- Gold Coin
	{ id = 3723, chance = 43751 }, -- White Mushroom
	{ id = 3276, chance = 24305 }, -- Hatchet
	{ id = 3410, chance = 13195 }, -- Plate Shield
	{ id = 3274, chance = 15276 }, -- Axe
	{ id = 3559, chance = 10420 }, -- Leather Legs
	{ id = 3456, chance = 9720 }, -- Pick
	{ id = 3378, chance = 9031 }, -- Studded Armor
	{ id = 3505, chance = 7638 }, -- Letter
	{ id = 3097, chance = 1000 }, -- Dwarven Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 10, attack = 26 },
}

monster.defenses = {
	defense = 10,
	armor = 9,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
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

mType:register(monster)
