local mType = Game.createMonsterType("Plunder Patriarch")
local monster = {}

monster.description = "plunder patriarch"
monster.experience = 0
monster.outfit = {
	lookType = 1567,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 20000
monster.maxHealth = 20000
monster.race = "undead"
monster.corpse = 39538
monster.speed = 40
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 5000,
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
}

monster.loot = {
	{ id = 33778, chance = 80000 }, -- raw watermelon tourmaline
	{ id = 39038, chance = 80000 }, -- royal almandine
	{ id = 32622, chance = 80000 }, -- giant amethyst
	{ id = 30061, chance = 80000 }, -- giant sapphire
	{ id = 39040, chance = 80000 }, -- fiery tear
	{ id = 32624, chance = 80000 }, -- amber with a bug
	{ id = 32625, chance = 80000 }, -- amber with a dragonfly
	{ id = 3043, chance = 80000, maxCount = 45 }, -- crystal coin
	{ id = 39148, chance = 80000 }, -- spiritthorn helmet
	{ id = 39147, chance = 80000 }, -- spiritthorn armor
	{ id = 39178, chance = 80000 }, -- charged spiritthorn ring
	{ id = 39149, chance = 80000 }, -- alicorn headguard
	{ id = 39150, chance = 80000 }, -- alicorn quiver
	{ id = 39181, chance = 80000 }, -- charged alicorn ring
	{ id = 39153, chance = 80000 }, -- arboreal crown
	{ id = 39154, chance = 80000 }, -- arboreal tome
	{ id = 39187, chance = 80000 }, -- charged arboreal ring
	{ id = 39151, chance = 80000 }, -- arcanomancer regalia
	{ id = 39152, chance = 80000 }, -- arcanomancer folio
	{ id = 39184, chance = 80000 }, -- charged arcanomancer sigil
}

monster.attacks = {
	{ name = "melee", interval = 200, chance = 20, minDamage = 0, maxDamage = -950 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -600, maxDamage = -1000, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -700, length = 5, spread = 2, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 0,
	--	mitigation = ???,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 400, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
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
