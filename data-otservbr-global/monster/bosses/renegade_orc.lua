local mType = Game.createMonsterType("Renegade Orc")
local monster = {}

monster.description = "a renegade orc"
monster.experience = 270
monster.outfit = {
	lookType = 59,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"RenegadeOrcDeath",
}

monster.health = 450
monster.maxHealth = 450
monster.race = "blood"
monster.corpse = 6001
monster.speed = 110
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Harga puchak muhmak!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 29 }, -- gold coin
	{ id = 3298, chance = 80000, maxCount = 2 }, -- throwing knife
	{ id = 7885, chance = 80000 }, -- fish
	{ id = 3725, chance = 80000 }, -- brown mushroom
	{ id = 11479, chance = 80000 }, -- orc leather
	{ id = 3307, chance = 80000 }, -- scimitar
	{ id = 3410, chance = 80000 }, -- plate shield
	{ id = 3301, chance = 80000 }, -- broadsword
	{ id = 3091, chance = 80000 }, -- sword ring
	{ id = 3285, chance = 80000 }, -- longsword
	{ id = 10196, chance = 80000 }, -- orc tooth
	{ id = 266, chance = 80000 }, -- health potion
	{ id = 3557, chance = 80000 }, -- plate legs
	{ id = 3369, chance = 80000 }, -- warrior helmet
	{ id = 7378, chance = 80000 }, -- royal spear
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -130 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -50, range = 7, shootEffect = CONST_ANI_THROWINGKNIFE, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 25,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -2 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
